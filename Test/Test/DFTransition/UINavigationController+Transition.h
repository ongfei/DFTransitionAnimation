//
//  UINavigationController+Transition.h
//  主要就是把Nav的代理指向DFNavTransitionConfig
//  也可以在自定义Nav中操作
//
//  Created by ongfei on 2018/3/21.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFInteractiveTransition.h"

@interface UINavigationController (Transition)
/**
 是否开启转场动画
 */
//- (void)openTransitionAnimation:(BOOL)state;

@end
