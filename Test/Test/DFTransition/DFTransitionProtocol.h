//
//  DFTransitionProtocol.h
//  自定义转场动画协议类
//
//  Created by ongfei on 2018/3/20.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFBaseTransitionAnimation.h"
#import "DFInteractiveTransition.h"

@protocol DFTransitionProtocol <NSObject>
@optional

//返回自定义动画 必须继承自 -> DFBaseTransitionAnimation

#pragma mark -  ----------push&pop&present&dismiss----------

/**
 从当前VC到下一个VC需要的动画

 @return 自定义的动画样式继承自DFBaseTransitionAnimation
 */
- (DFBaseTransitionAnimation *)pushTransitionAnimation;
- (DFBaseTransitionAnimation *)presentTransitionAnimation;

/**
 从当前VC返回上一个VC需要的动画

 @return 自定义的动画样式继承自DFBaseTransitionAnimation
 */
- (DFBaseTransitionAnimation *)popTransitionAnimation;
- (DFBaseTransitionAnimation *)dismissTransitionAnimation;

#pragma mark -  ----------手势处理代理----------

/**
 从当前VC返回上个VC 手势类型 默认 DFTransitionGestureEdge
 */
- (DFTransitionGestureType)gesturesSupport;

/**
 从当前VC返回上个VC  DFTransitionGestureFull 支持 返回当前VC的手势方向 默认 DFTransitionGestureDirectionRight
 */
- (DFTransitionGestureDirection)gestureDirection;

#pragma mark -  ----------关于模态的一些特殊设置----------

/**
 8.0之后使用
 vc1---present---->vc2 该代理实现在vc1中
 @return 返回继承自UIPresentationController的子类
 */
- (Class)presentationControllerForPresentedViewController;

/**
 present 自定义动画的两种style： Custom || FullScreen
 两种不同的style会对动画处理有影响
 @return 默认返回 Custom
 */
- (UIModalPresentationStyle)presentModalPresentationStyle;

@end
