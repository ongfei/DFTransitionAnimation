//
//  UIViewController+Transition.m
//  UIViewController的category 主要处理转场动画的代理
//
//  Created by ongfei on 2018/3/21.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "UIViewController+Transition.h"
#import "DFInteractiveTransition.h"
#import "DFTransitionProtocol.h"
#import <objc/runtime.h>

@implementation UIViewController (Transition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method sysdidDisappear = class_getInstanceMethod(self.class, @selector(viewDidAppear:));
        Method dfdidDisappear = class_getInstanceMethod(self.class, @selector(df_viewDidAppear:));
        method_exchangeImplementations(sysdidDisappear, dfdidDisappear);
    });
}

- (void)df_viewDidAppear:(BOOL)animated {
    //pop的情况 重新设置代理
    self.navigationController.delegate = self;

    [self df_viewDidAppear:animated];
}

#pragma mark -  ----------AssociatedObject----------

- (void)setInteractiveTransition:(DFInteractiveTransition *)interactiveTransition {
    objc_setAssociatedObject(self, @selector(interactiveTransition), interactiveTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DFInteractiveTransition *)interactiveTransition {
    return objc_getAssociatedObject(self, @selector(interactiveTransition));
}


#pragma mark - ----------UINavigationControllerDelegate----------
/**
 navigationController push pop 动画 系统代理
 */
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {

    DFBaseTransitionAnimation *transition;
    if (operation == UINavigationControllerOperationPush) {
        if ([fromVC conformsToProtocol:@protocol(DFTransitionProtocol)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
            UIViewController<DFTransitionProtocol> *fromvc = fromVC;
#pragma clang diagnostic pop
            if ([fromvc respondsToSelector:@selector(pushTransitionAnimation)]) {
                transition = [fromvc pushTransitionAnimation];
                transition.transitionType = DFTransitionPush;
            }
        }
    }else if (operation == UINavigationControllerOperationPop) {
        if ([fromVC conformsToProtocol:@protocol(DFTransitionProtocol)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
            UIViewController<DFTransitionProtocol> *fromvc = fromVC;
#pragma clang diagnostic pop
            if ([fromvc respondsToSelector:@selector(popTransitionAnimation)]) {
                transition = [fromvc popTransitionAnimation];
                transition.transitionType = DFTransitionPop;
            }
        }
    }
//    没有自定义动画 默认返回DFBaseTransitionAnimation里的动画
    if (!transition) {
        transition = [[DFBaseTransitionAnimation alloc] init];
        transition.transitionType = operation == UINavigationControllerOperationPush? DFTransitionPush : DFTransitionPop;
    }
//    添加手势
    if (operation == UINavigationControllerOperationPush) {
        self.interactiveTransition = [[DFInteractiveTransition alloc] init];
        if ([toVC conformsToProtocol:@protocol(DFTransitionProtocol)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
            UIViewController<DFTransitionProtocol> *tovc = toVC;
#pragma clang diagnostic pop
            //手势方向
            if ([tovc respondsToSelector:@selector(gestureDirection)]) {
                self.interactiveTransition.direction = [tovc gestureDirection];
            }else {
                self.interactiveTransition.direction = DFTransitionGestureDirectionRight;
            }
            //手势类型
            if ([tovc respondsToSelector:@selector(gesturesSupport)]) {
                self.interactiveTransition.gestureType = [tovc gesturesSupport];
            }else {
                self.interactiveTransition.gestureType = DFTransitionGestureEdge;
            }
        }
        [self.interactiveTransition addGestureToViewController:toVC];
    }
    return transition;
}

/**
 navigationController 手势处理 系统代理
 */
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
//    NSLog(@"=====%d----%@",self.interactiveTransition.interacting,self.interactiveTransition);
    if (((DFBaseTransitionAnimation *)animationController).transitionType == DFTransitionPop) {
        if (self.interactiveTransition.interacting) {
            return self.interactiveTransition;
        }
    }
    return nil;
}

- (void)dealloc {
    NSLog(@"%@--销毁",self);
}

@end
