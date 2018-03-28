# DFTransitionAnimation
转场动画+手势驱动


#### 关于使用

使用很简单 只要vc 遵守<DFTransitionProtocol>这个协议 实现方法就行 

自定义动画要继承自 DFBaseTransitionAnimation

如果不实现 那么返回的是DFBaseTransitionAnimation 这个里面的默认动画
手势的话也是默认手势 详情看协议

		- (DFBaseTransitionAnimation *)pushTransitionAnimation;
		- (DFBaseTransitionAnimation *)popTransitionAnimation;
