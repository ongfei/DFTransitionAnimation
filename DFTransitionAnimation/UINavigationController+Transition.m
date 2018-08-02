//
//  UINavigationController+Transition.m
//  主要就是把Nav的代理指向DFNavTransitionConfig
//  也可以在自定义Nav中操作
//
//  Created by ongfei on 2018/3/21.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "UINavigationController+Transition.h"
#import "DFTransitionProtocol.h"
#import <objc/runtime.h>

@implementation UINavigationController (Transition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method sysPush = class_getInstanceMethod(self.class, @selector(pushViewController:animated:));
        Method dfPush = class_getInstanceMethod(self.class, @selector(df_pushViewController:animated:));
        method_exchangeImplementations(sysPush, dfPush);
    });
}

- (void)df_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController conformsToProtocol:@protocol(DFTransitionProtocol)]) {
        self.delegate = (id<UINavigationControllerDelegate>)viewController;
    }else {
        self.delegate = nil;
    }
    [self df_pushViewController:viewController animated:animated];
}

@end
