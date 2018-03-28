//
//  Animation.m
//  Test
//
//  Created by ongfei on 2018/3/21.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "Animation.h"

@implementation Animation
//动画执行时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.5;
}
//转场动画处理
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    if (self.transitionType == DFTransitionPush) {
        
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *tempView = [toVC.view snapshotViewAfterScreenUpdates:YES];
        UIView *containView = [transitionContext containerView];
        
        [containView addSubview:toVC.view];
        [containView addSubview:fromVC.view];
        [containView addSubview:tempView];
        
        tempView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
        
        [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.4 initialSpringVelocity:1/0.4 options:0 animations:^{
            tempView.layer.transform = CATransform3DIdentity;
        } completion:^(BOOL finished) {
            
            if ([transitionContext transitionWasCancelled]) {
                [transitionContext completeTransition:NO];
            }else{
                [transitionContext completeTransition:YES];
                toVC.view.hidden = NO;
            }
            [tempView removeFromSuperview];
        }];
    }else {
        
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
        UIView *containView = [transitionContext containerView];
        
        
        [containView addSubview:toVC.view];
        [containView addSubview:tempView];
        
        tempView.layer.transform = CATransform3DIdentity;
        
        [UIView animateWithDuration:0.3 animations:^{
            tempView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
        } completion:^(BOOL finished) {
            
            if ([transitionContext transitionWasCancelled]) {
                
                [transitionContext completeTransition:NO];
                fromVC.view.hidden = NO;
                [tempView removeFromSuperview];
                
            }else{
                [transitionContext completeTransition:YES];
                toVC.view.hidden = NO;
                fromVC.view.hidden = YES;
                [tempView removeFromSuperview];
            }
            
        }];
    }
    
    
}
@end
