//
//  DFInteractiveTransition.h
//  转场动画手势处理类
//
//  Created by ongfei on 2018/3/21.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DFBaseTransitionAnimation.h"

/**手势转场方向*/
typedef NS_ENUM(NSUInteger, DFTransitionGestureDirection) {
    DFTransitionGestureDirectionRight = 0,
    DFTransitionGestureDirectionLeft,
    DFTransitionGestureDirectionUp,
    DFTransitionGestureDirectionDown
};

/**全屏 还是 边缘*/
typedef NS_ENUM(NSUInteger, DFTransitionGestureType) {
    DFTransitionGestureFull = 0,
    DFTransitionGestureEdge,
    DFTransitionGestureNone
};

@interface DFInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) DFTransitionGestureDirection direction;

@property (nonatomic, assign) DFTransitionGestureType gestureType;

@property (nonatomic, assign) DFTransitionType type;

@property (nonatomic, assign) BOOL interacting;

- (void)addGestureToViewController:(UIViewController *)vc;

@end
