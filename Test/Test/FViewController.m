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

@end

@implementation FViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [self.view addGestureRecognizer:tap];
    //    [self.navigationController openTransitionAnimation:YES];
    
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    v.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:v];
    
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
