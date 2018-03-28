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

/**
 从当前VC到下一个VC需要的动画

 @return 自定义的动画样式继承自DFBaseTransitionAnimation
 */
- (DFBaseTransitionAnimation *)pushTransitionAnimation;

/**
 从当前VC返回上一个VC需要的动画

 @return 自定义的动画样式继承自DFBaseTransitionAnimation
 */
- (DFBaseTransitionAnimation *)popTransitionAnimation;

/**
 从当前VC返回上个VC 手势类型 默认 DFTransitionGestureEdge
 */
- (DFTransitionGestureType)gesturesSupport;

/**
 从当前VC返回上个VC  DFTransitionGestureFull 支持 返回当前VC的手势方向 默认 DFTransitionGestureDirectionRight
 */
- (DFTransitionGestureDirection)gestureDirection;

@end
