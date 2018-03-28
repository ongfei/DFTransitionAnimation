//
//  DFBaseTransitionAnimation.m
//  转场动画的基类 拓展的转场动画需要继承自本类 重写UIViewControllerAnimatedTransitioning代理内的两个方法
//
//  Created by ongfei on 2018/3/20.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "DFBaseTransitionAnimation.h"

@interface DFBaseTransitionAnimation ()<CAAnimationDelegate>

@end

@implementation DFBaseTransitionAnimation

//交给子类实现
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
//    [containerView addSubview:toVC.view];
//CATransition实现的动画 pop回来的时候 手势不能百分比驱动 暂时不知道原因
//    CATransition *tranAnimation = [CATransition animation];
//    tranAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    tranAnimation.duration = 0.3f;
////    tranAnimation.delegate = self;
//    tranAnimation.type = self.transitionType == DFTransitionPush ? kCATransitionPush : kCATransitionFromTop;
//    tranAnimation.subtype = self.transitionType == DFTransitionPush ? kCATransitionFromRight : kCATransitionFromLeft;
//
//    [containerView.layer addAnimation:tranAnimation forKey:nil];
//
//    if ([transitionContext transitionWasCancelled]) {
//        [transitionContext completeTransition:NO];
//    }else{
//        [transitionContext completeTransition:YES];
//    }
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    //        [containerView addSubview:fromView];  containerView会自动添加addSubview:fromView
    
    if (self.transitionType == DFTransitionPush) {
        [containerView addSubview:toView];
        [containerView bringSubviewToFront:toView];
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        toView.layer.transform = CATransform3DMakeTranslation(screenWidth,0,0);
        [UIView animateWithDuration:0.3 animations:^{
            
            fromView.layer.transform = CATransform3DMakeScale(1,1,1);
            toView.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished){
//            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            if ([transitionContext transitionWasCancelled]) {
                [transitionContext completeTransition:NO];
            }else{
                [transitionContext completeTransition:YES];
            }

        }];
    }else {
        [containerView insertSubview:toView atIndex:0];
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        toView.layer.transform = CATransform3DMakeScale(1,1,1);
        fromView.layer.transform = CATransform3DIdentity;
        [UIView animateWithDuration:0.3 animations:^{
            toView.layer.transform = CATransform3DIdentity;
            fromView.layer.transform = CATransform3DMakeTranslation(screenWidth,0,0);
        } completion:^(BOOL finished){
//            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            if ([transitionContext transitionWasCancelled]) {
                [transitionContext completeTransition:NO];
            }else{
                [transitionContext completeTransition:YES];
            }

        }];
    }
}
//交给子类实现
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//
//    [self.tempView removeFromSuperview];
//    [self.temView1 removeFromSuperview];
//}
//- (void)dealloc {
//    NSLog(@"%@--销毁",self);
//}
@end
