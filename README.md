# DFTransitionAnimation
转场动画+手势驱动


#### 关于使用

Nav的push&pop直接用系统的push pop

模态导入vc的category 调用df_preset...


使用很简单 只要vc 遵守<DFTransitionProtocol>这个协议 实现方法就行 

自定义动画要继承自 DFBaseTransitionAnimation

如果不实现 用的是系统的


A ---push---> B
如果有push动画 在B里实现

B ---pop---> A
如果有pop动画 在B里实现
