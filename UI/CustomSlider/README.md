# 自定义Slider

内容来自于[How To Make a Custom Control Tutorial: A Reusable Slider](https://www.raywenderlich.com/7595-how-to-make-a-custom-control-tutorial-a-reusable-slider)

记录一些要点：

1.继承自`UIControl`，重写如下的方法

+ `beginTracking(_:with:)`
+ `continueTracking(_:with:)`
+ `endTracking(_:with:)`

2.通知数值改变

在iOS中有很多方式来通知数值的改变，如`NSNotification`、KVO、代理模型等

这是主要区别delegate和target-action模式，区别如下：

+ *Multicast* - target-action可以实现多个变更通知，而delegate智能绑定到单个代理
+ *Flexibility* - 可以在delegate模式中自己定义协议，这意味着可以精确地控制传递的信息，而target-action没法来传递额外的信息

在`continueTracking(_:with:)`方法中，通知改变

```swift
sendActions(for: .valueChanged)
```



效果如下：

![009](https://github.com/winfredzen/iOS-Basic/blob/master/UI/images/009.png)





