//
//  PresentAnimation.m
//  Test
//
//  Created by ongfei on 2018/3/28.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "PresentAnimation.h"

@implementation PresentAnimation
//动画执行时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.5;
}
//转场动画处理
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    NSLog(@"111111111100000000");

    if (self.transitionType == DFTransitionPresent) {
        NSLog(@"222222220000000");

        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UINavigationController *fromVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//        XWCircleSpreadController *temp = fromVC.viewControllers.lastObject;
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:toVC.view];
        //画两个圆路径
        UIBezierPath *startCycle =  [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 100, 100, 100)];
        CGFloat x = MAX(100, containerView.frame.size.width - 100);
        CGFloat y = MAX(100, containerView.frame.size.height - 100);
        CGFloat radius = sqrtf(pow(x, 2) + pow(y, 2));
        UIBezierPath *endCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        //创建CAShapeLayer进行遮盖
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = endCycle.CGPath;
        //将maskLayer作为toVC.View的遮盖
        toVC.view.layer.mask = maskLayer;
        //创建路径动画
        CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        maskLayerAnimation.delegate = self;
        //动画是加到layer上的，所以必须为CGPath，再将CGPath桥接为OC对象
        maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
        maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
        maskLayerAnimation.duration = [self transitionDuration:transitionContext];
        maskLayerAnimation.delegate = self;
        maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
        [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
        
        NSLog(@"0000000000000000000");
        
    }else {
        
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UINavigationController *toVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *fromView = fromVC.view;
        UIView *toView = toVC.view;
//        UIView *containerView = [transitionContext containerView];
//        [containerView insertSubview:toView atIndex:0];
        
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

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
    [transitionContext completeTransition:YES];
            //            [transitionContext viewControllerForKey:UITransitionContextToViewKey].view.layer.mask = nil;
    
    NSLog(@"++_+_+_+_+_+_+_+_+");
}

@end
