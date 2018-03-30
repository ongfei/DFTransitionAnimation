//
//  DFTransitionAnimation.h
//  Test
//
//  Created by ongfei on 2018/3/20.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "DFBaseTransitionAnimation.h"

/**
 转场动画类
 转场需要的动画需要在这里定义
 UIViewControllerAnimatedTransitioning
 */
@interface DFTransitionAnimation : DFBaseTransitionAnimation

@property (nonatomic, assign) NSTimeInterval duration;

@end
