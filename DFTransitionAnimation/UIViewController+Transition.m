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

    if ([self conformsToProtocol:@protocol(DFTransitionProtocol)]) {
        self.navigationController.delegate = self;
    }else {
        self.navigationController.delegate = nil;
    }
    __weak typeof (self)weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
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
    if (!transition) {
        transition = [[DFBaseTransitionAnimation alloc] init];
        transition.transitionType = operation == UINavigationControllerOperationPush? DFTransitionPush : DFTransitionPop;
    }
    if (operation == UINavigationControllerOperationPush) {
        self.interactiveTransition = [[DFInteractiveTransition alloc] init];
        if ([toVC conformsToProtocol:@protocol(DFTransitionProtocol)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
            UIViewController<DFTransitionProtocol> *tovc = toVC;
#pragma clang diagnostic pop
            if ([tovc respondsToSelector:@selector(gestureDirection)]) {
                self.interactiveTransition.direction = [tovc gestureDirection];
            }else {
                self.interactiveTransition.direction = DFTransitionGestureDirectionRight;
            }
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

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    
    if (((DFBaseTransitionAnimation *)animationController).transitionType == DFTransitionPop) {
        if (self.interactiveTransition.interacting) {
            return self.interactiveTransition;
        }
    }
    return nil;
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
    
    DFBaseTransitionAnimation *transition = nil;
    if ([source conformsToProtocol:@protocol(DFTransitionProtocol)]) {
        if ([[self transitionVC:source] respondsToSelector:@selector(presentTransitionAnimation)]) {
            transition = [[self transitionVC:source] presentTransitionAnimation];
            transition.transitionType = DFTransitionPresent;
        }
    }
    self.interactiveTransition = [[DFInteractiveTransition alloc] init];
    if ([presented conformsToProtocol:@protocol(DFTransitionProtocol)]) {
        if ([[self transitionVC:presented] respondsToSelector:@selector(gestureDirection)]) {
            self.interactiveTransition.direction = [[self transitionVC:presented] gestureDirection];
        }else {
            self.interactiveTransition.direction = DFTransitionGestureDirectionRight;
        }
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
    
    UIPresentationController *presentationC = nil;
    if ([source conformsToProtocol:@protocol(DFTransitionProtocol)]) {
        if ([[self transitionVC:source] respondsToSelector:@selector(presentationControllerForPresentedViewController)]) {
            presentationC = [[[[self transitionVC:source] presentationControllerForPresentedViewController] alloc] initWithPresentedViewController:presented presentingViewController:presenting];
        }
    }
    return presentationC;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
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
