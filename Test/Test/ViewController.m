
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

#import "FViewController.h"
#import "PresentAnimation.h"
#import "UIViewController+Transition.h"
#import "PresentationController.h"
#import "Animation.h"
#import "ananan.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,DFTransitionProtocol>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
//    [self.view addGestureRecognizer:tap];
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    [self.view addSubview:tableV];
    tableV.delegate = self;
    tableV.dataSource = self;
    [tableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @[@"push&pop",@"present"][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self click];
    }else {
        
        [self df_presentViewController:[FViewController new] animated:YES completion:^{
            
        }];
    }
}

- (void)click {
    
    NextViewController *next = [NextViewController new];
    
    [self.navigationController pushViewController:next animated:YES];
}

- (DFBaseTransitionAnimation *)popTransitionAnimation {
    //    return nil;
    Animation *transition = [[Animation alloc] init];
    return transition;
}

- (DFBaseTransitionAnimation *)presentTransitionAnimation {
//    return nil;
    ananan *transition = [[ananan alloc] init];
    return transition;
}

- (Class)presentationControllerForPresentedViewController {
    
    return [PresentationController class];
}

//
//
//- (DFTransitionGestureDirection)gestureDirection {
//    return DFTransitionGestureDirectionDown;
//}
//
@end
