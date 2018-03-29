//
//  UIViewController+Transition.h
//  UIViewController的category 主要处理转场动画的代理
//
//  Created by ongfei on 2018/3/21.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFInteractiveTransition.h"

@interface UIViewController (Transition)<UINavigationControllerDelegate,UIViewControllerTransitioningDelegate,UITabBarControllerDelegate>

- (void)df_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;

@end
