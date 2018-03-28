
//  ViewController.m
//  Test
//
//  Created by ongfei on 2018/3/20.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"
#import "DFTransitionProtocol.h"
#import "DFTransitionAnimation.h"
#import "UINavigationController+Transition.h"

@interface ViewController ()
//<DFTransitionProtocol>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)click {
    
    NextViewController *next = [NextViewController new];
    
    [self.navigationController pushViewController:next animated:YES];
}

//- (DFBaseTransitionAnimation *)pushTransitionAnimation {
////    return nil;
//    DFTransitionAnimation *transition = [[DFTransitionAnimation alloc] init];
//    return transition;
//}
//
//
//- (DFTransitionGestureDirection)gestureDirection {
//    return DFTransitionGestureDirectionDown;
//}
//
@end
