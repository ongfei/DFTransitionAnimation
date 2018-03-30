//
//  FViewController.m
//  Test
//
//  Created by ongfei on 2018/3/28.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "FViewController.h"
#import "DFTransitionProtocol.h"
#import "PresentAnimation.h"

@interface FViewController ()<DFTransitionProtocol>

@property (nonatomic, strong) UIView *v;

@end

@implementation FViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [self.view addGestureRecognizer:tap];
    //    [self.navigationController openTransitionAnimation:YES];
    
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    
    self.v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    self.v.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.v];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        
//        self.v.alpha = 1.0f;
//        
//    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        
//        NSLog(@"completion");
//    }];
//    
//    [self.transitionCoordinator animateAlongsideTransitionInView:self.v animation:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        
//        UIView *containerView = [context containerView];
//        UIView *fromeView = [context viewForKey:UITransitionContextFromViewKey];
//        UIView *toView = [context viewForKey:UITransitionContextToViewKey];
//        UIViewController *fromeVC = [context viewControllerForKey: UITransitionContextFromViewControllerKey];
//        UIViewController *toVC = [context viewControllerForKey: UITransitionContextToViewControllerKey];
//        
//        NSLog(@"%@-%@-%@-%@-%@",containerView,fromeView,toView,fromeVC,toVC);
//        
//        
//    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        NSLog(@"aaaaaaaaa");
//    }];
//    
////    当手势动结束后会回调该接口
//    [self.transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        NSLog(@"notifyWhenInteractionEndsUsingBlock");
//    }];
    
}

- (void)click {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (DFBaseTransitionAnimation *)dismissTransitionAnimation {
    //    return nil;
    PresentAnimation *transition = [[PresentAnimation alloc] init];
    return transition;
}

- (DFTransitionGestureType)gesturesSupport {
    
    return DFTransitionGestureFull;
}

- (DFTransitionGestureDirection)gestureDirection {
    return DFTransitionGestureDirectionDown;
}

@end
