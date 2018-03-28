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
        
//        Method sysPop = class_getInstanceMethod(self.class, @selector(popViewControllerAnimated:));
//        Method dfPop = class_getInstanceMethod(self.class, @selector(df_popViewControllerAnimated:));
//
//        method_exchangeImplementations(sysPop, dfPop);

    });
}

- (void)df_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if ([viewController conformsToProtocol:@protocol(DFTransitionProtocol)]) {
        self.delegate = (id<UINavigationControllerDelegate>)viewController;
//    }
    [self df_pushViewController:viewController animated:animated];
}
//
//- (UIViewController *)df_popViewControllerAnimated:(BOOL)animated {
////    if ([self.topViewController conformsToProtocol:@protocol(DFTransitionProtocol)]) {
//        self.delegate = (id<UINavigationControllerDelegate>)self.topViewController;
////    }
//    return [self df_popViewControllerAnimated:animated];
//}



@end
