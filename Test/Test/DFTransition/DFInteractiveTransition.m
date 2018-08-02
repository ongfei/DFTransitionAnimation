//
//  DFInteractiveTransition.m
//  转场动画手势处理类
//
//  Created by ongfei on 2018/3/21.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "DFInteractiveTransition.h"

@interface DFInteractiveTransition ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGFloat percent;
//不要强引用 否则会造成无法释放问题 这个坑
@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@end

@implementation DFInteractiveTransition

- (void)addGestureToViewController:(UIViewController *)vc {
    
    switch (_gestureType) {
        case DFTransitionGestureFull:
            _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
            break;
        case DFTransitionGestureEdge:
            _pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
            switch (self.direction) {
                case DFTransitionGestureDirectionRight:
                    ((UIScreenEdgePanGestureRecognizer *)_pan).edges = UIRectEdgeRight;
                    break;
                case DFTransitionGestureDirectionLeft:
                    ((UIScreenEdgePanGestureRecognizer *)_pan).edges = UIRectEdgeLeft;
                    break;
                case DFTransitionGestureDirectionUp:
                    ((UIScreenEdgePanGestureRecognizer *)_pan).edges = UIRectEdgeTop;
                    break;
                case DFTransitionGestureDirectionDown:
                    ((UIScreenEdgePanGestureRecognizer *)_pan).edges = UIRectEdgeBottom;
                    break;
                default:
                    break;
            }
            break;
        case DFTransitionGestureNone:
            return;
        default:
            return;
    }
    self.vc = vc;
    [vc.view addGestureRecognizer:_pan];
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    
    _percent = 0.0;
    CGFloat totalWidth = pan.view.bounds.size.width;
    CGFloat totalHeight = pan.view.bounds.size.height;
    switch (self.direction) {
            
        case DFTransitionGestureDirectionLeft:{
            CGFloat x = [pan translationInView:pan.view].x;
            _percent = -x/totalWidth;
        }
            break;
        case DFTransitionGestureDirectionRight:{
            CGFloat x = [pan translationInView:pan.view].x;
            _percent = x/totalWidth;
        }
            break;
        case DFTransitionGestureDirectionDown:{
            
            CGFloat y = [pan translationInView:pan.view].y;
            _percent = y/totalHeight;
            
        }
            break;
        case DFTransitionGestureDirectionUp:{
            CGFloat y = [pan translationInView:pan.view].y;
            _percent = -y/totalHeight;
        }
            
        default:
            break;
    }
//    NSLog(@"---%f",_percent);

    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            _interacting = YES;
            [self beganGesture];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            [self updateInteractiveTransition:_percent];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            _interacting = NO;
            [self continueAction];
        }
            break;
        default:
            break;
    }
}



- (void)beganGesture {

    if (self.type == DFTransitionPop) {
        [self.vc.navigationController popViewControllerAnimated:YES];
    }else if (self.type == DFTransitionDismiss) {
        [self.vc dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)continueAction {
    if (_displayLink) {
        return;
    }
    //防止卡顿
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(UIChange)];
    [_displayLink  addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
}

- (void)UIChange {
    
    CGFloat timeDistance = 2.0/60;
    if (_percent > 0.4) {
        _percent += timeDistance;
    }else {
        _percent -= timeDistance;
    }
    [self updateInteractiveTransition:_percent];
    
    if (_percent >= 1.0) {
        
        [self finishInteractiveTransition];
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
    if (_percent <= 0.0) {
        
        [_displayLink invalidate];
        _displayLink = nil;
        [self cancelInteractiveTransition];
    }
}

//- (void)dealloc {
//    NSLog(@"%@--销毁",self);
//}

@end
