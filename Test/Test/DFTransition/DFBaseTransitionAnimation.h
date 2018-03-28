//
//  DFBaseTransitionAnimation.h
//  转场动画的基类 拓展的转场动画需要继承自本类 重写UIViewControllerAnimatedTransitioning代理内的两个方法
//
//  Created by ongfei on 2018/3/20.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DFTransitionType) {
    DFTransitionPush,
    DFTransitionPop,
};


@interface DFBaseTransitionAnimation : NSObject<UIViewControllerAnimatedTransitioning>
/**
 枚举用于判断是push还是pop 在自定义动画中可能用到
 */
@property (nonatomic, assign) DFTransitionType transitionType;

@end
