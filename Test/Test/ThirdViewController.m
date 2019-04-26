//
//  ThirdViewController.m
//  Test
//
//  Created by ongfei on 2018/3/21.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "ThirdViewController.h"
#import "DFTransitionProtocol.h"
#import "Animation.h"
#import "UINavigationController+Transition.h"

@interface ThirdViewController ()
//<DFTransitionProtocol>

@end

@implementation ThirdViewController

//- (DFBaseTransitionAnimation *)popTransitionAnimation {
//    
//    //    return nil;
//    Animation *transition = [[Animation alloc] init];
//    return transition;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
