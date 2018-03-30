//
//  DFTransitionAnimation.m
//  Test
//
//  Created by ongfei on 2018/3/20.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "DFTransitionAnimation.h"

@implementation DFTransitionAnimation

- (instancetype)init {
    if (self = [super init]) {
        self.duration = 0.5;
    }
    return self;
}

//动画执行时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    
    return self.duration;
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
        
        tempView.layer.transform = CATransform3DMakeScale(4, 4, 1);
        tempView.alpha = 0.1;
        tempView.hidden = NO;
        
        
        [UIView animateWithDuration:0.4 animations:^{
            
            tempView.layer.transform = CATransform3DIdentity;
            tempView.alpha = 1;
            
        } completion:^(BOOL finished) {
            
            if ([transitionContext transitionWasCancelled]) {
                toVC.view.hidden = YES;
                [transitionContext completeTransition:NO];
            }else{
                toVC.view.hidden = NO;
                [transitionContext completeTransition:YES];
            }
            [tempView removeFromSuperview];
            
        }];
    }else {
        
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
        UIView *containView = [transitionContext containerView];
        
        [containView addSubview:fromVC.view];
        [containView addSubview:toVC.view];
        [containView addSubview:tempView];
        
        fromVC.view.hidden = YES;
        toVC.view.hidden = NO;
        toVC.view.alpha = 1;
        tempView.hidden = NO;
        tempView.alpha = 1;
        
        [UIView animateWithDuration:0.4 animations:^{
            tempView.layer.transform = CATransform3DMakeScale(4, 4, 1);
            tempView.alpha = 0.0;
        } completion:^(BOOL finished) {
            
            if ([transitionContext transitionWasCancelled]) {
                
                fromVC.view.hidden = NO;
                [transitionContext completeTransition:NO];
                tempView.alpha = 1;
            }else{
                [transitionContext completeTransition:YES];
                toVC.view.hidden = NO;
            }
            [tempView removeFromSuperview];
        }];
    }
    

}

@end
