//
//  NextViewController.m
//  Test
//
//  Created by ongfei on 2018/3/20.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "NextViewController.h"
#import "DFTransitionProtocol.h"
#import "Animation.h"
#import "ThirdViewController.h"
#import "DFTransitionAnimation.h"

#import "UIViewController+Transition.h"
#import "ananan.h"

#import "UINavigationController+Transition.h"

@interface NextViewController ()<DFTransitionProtocol>

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor purpleColor];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    v.backgroundColor = [UIColor redColor];
    [self.view addSubview:v];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [self.view addGestureRecognizer:tap];
//    [self.navigationController openTransitionAnimation:YES];

}

- (void)click {
    
//    ThirdViewController *next = [ThirdViewController new];
//
//    [self.navigationController pushViewController:next animated:YES];
    [self df_presentViewController:[ThirdViewController new] animated:YES completion:^{
        
    }];
}

- (DFBaseTransitionAnimation *)presentTransitionAnimation {
    return [ananan new];
}
- (DFBaseTransitionAnimation *)dismissTransitionAnimation {
     return [ananan new];
}

- (DFBaseTransitionAnimation *)pushTransitionAnimation {

//    return nil;
    Animation *transition = [[Animation alloc] init];
    return transition;
}
//
- (DFBaseTransitionAnimation *)popTransitionAnimation {
    //    return nil;
    Animation *transition = [[Animation alloc] init];
    return transition;
}

- (DFTransitionGestureType)gesturesSupport {
    
    return DFTransitionGestureFull;
}

- (DFTransitionGestureDirection)gestureDirection {
    return DFTransitionGestureDirectionDown;
}



@end
