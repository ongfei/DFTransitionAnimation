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
        
//        Method syspresentViewController = class_getInstanceMethod(self.class, @selector(presentViewController:animated:completion:));
//        Method dfpresentViewController = class_getInstanceMethod(self.class, @selector(df_presentViewController:animated:completion:));
//        method_exchangeImplementations(syspresentViewController, dfpresentViewController);
    });
}

- (void)df_viewDidAppear:(BOOL)animated {
    //pop的情况 重新设置代理
//    self.navigationController.delegate = self;
    if ([self conformsToProtocol:@protocol(DFTransitionProtocol)]) {
        self.navigationController.delegate = self;
    }else {
        self.navigationController.delegate = nil;
    }
    __weak typeof (self)weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    
    NSLog(@"%@",self.navigationController.delegate);
//    self.transitioningDelegate = self;
//    self.modalPresentationStyle = UIModalPresentationCustom;
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
            UIViewController<DFTransitionProtocol> *fromvc = toVC;
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
    self.interactiveTransition.type = DFTransitionPop;
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

#pragma mark -  ----------UIViewController transitioningDelegate----------

- (void)df_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    viewControllerToPresent.transitioningDelegate = viewControllerToPresent;
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
    if ([self conformsToProtocol:@protocol(DFTransitionProtocol)]) {
        if ([[self transitionVC:self] respondsToSelector:@selector(presentModalPresentationStyle)]) {
            viewControllerToPresent.modalPresentationStyle = [[self transitionVC:self] presentModalPresentationStyle];
        }
    }
    [self presentViewController:viewControllerToPresent animated:flag completion:completion];
 
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
//    NSLog(@"111111111---%@---%@----%@",self,presented,presenting);
    DFBaseTransitionAnimation *transition = nil;
    if ([source conformsToProtocol:@protocol(DFTransitionProtocol)]) {
        if ([[self transitionVC:source] respondsToSelector:@selector(presentTransitionAnimation)]) {
            transition = [[self transitionVC:source] presentTransitionAnimation];
            transition.transitionType = DFTransitionPresent;
        }
    }
//    添加手势
    self.interactiveTransition = [[DFInteractiveTransition alloc] init];
    if ([presented conformsToProtocol:@protocol(DFTransitionProtocol)]) {

        //手势方向
        if ([[self transitionVC:presented] respondsToSelector:@selector(gestureDirection)]) {
            self.interactiveTransition.direction = [[self transitionVC:presented] gestureDirection];
        }else {
            self.interactiveTransition.direction = DFTransitionGestureDirectionRight;
        }
        //手势类型
        if ([[self transitionVC:presented] respondsToSelector:@selector(gesturesSupport)]) {
            self.interactiveTransition.gestureType = [[self transitionVC:presented] gesturesSupport];
        }else {
            self.interactiveTransition.gestureType = DFTransitionGestureEdge;
        }
    }
    [self.interactiveTransition addGestureToViewController:presented];
    
    self.interactiveTransition.type = DFTransitionDismiss;
    
    return transition;
    
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
//    NSLog(@"22222---%@---%@-",self,dismissed);
    
    DFBaseTransitionAnimation *transition = nil;
    if ([dismissed conformsToProtocol:@protocol(DFTransitionProtocol)]) {
        if ([[self transitionVC:dismissed] respondsToSelector:@selector(dismissTransitionAnimation)]) {
            transition = [[self transitionVC:dismissed] dismissTransitionAnimation];
            transition.transitionType = DFTransitionDismiss;
        }
    }
    return transition;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    
//    NSLog(@"===");
    UIPresentationController *presentationC = nil;
    if ([source conformsToProtocol:@protocol(DFTransitionProtocol)]) {
        if ([[self transitionVC:source] respondsToSelector:@selector(presentationControllerForPresentedViewController)]) {
            presentationC = [[[[self transitionVC:source] presentationControllerForPresentedViewController] alloc] initWithPresentedViewController:presented presentingViewController:presenting];
        }
    }
    return presentationC;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
//    NSLog(@"3333");
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
//    NSLog(@"4444");
    if ([animator.superclass isKindOfClass:[UIResponder class]] && ((DFBaseTransitionAnimation *)animator).transitionType == DFTransitionDismiss) {
        if (self.interactiveTransition.interacting) {
            return self.interactiveTransition;
        }
    }
    return nil;
}

- (UIViewController<DFTransitionProtocol> *)transitionVC:(UIViewController *)vc {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
    UIViewController<DFTransitionProtocol> *VC = vc;
#pragma clang diagnostic pop
    return VC;
}

@end
