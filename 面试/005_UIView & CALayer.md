#  UIView & CALayer

参考：

+ [动画解释](https://objccn.io/issue-12-1/)
+ [图层与视图](https://zsisme.gitbooks.io/ios-/content/chapter1/layer-capabilities.html)



每一个`UIview`都有一个`CALayer`实例的图层属性，也就是所谓的*backing layer*，视图的职责就是创建并管理这个图层，以确保当子视图在层级关系中添加或者被移除的时候，他们关联的图层也同样对应在层级关系树当中有相同的操作

 **但是为什么iOS要基于`UIView`和`CALayer`提供两个平行的层级关系呢？**

> 原因在于要做职责分离，这样也能避免很多重复代码。在iOS和Mac OS两个平台上，事件和用户交互有很多地方的不同，基于多点触控的用户界面和基于鼠标键盘有着本质的区别，这就是为什么iOS有UIKit和`UIView`，但是Mac OS有AppKit和`NSView`的原因。他们功能上很相似，但是在实现上有着显著的区别。
>
> 绘图，布局和动画，相比之下就是类似Mac笔记本和桌面系列一样应用于iPhone和iPad触屏的概念。把这种功能的逻辑分开并应用到独立的Core Animation框架，苹果就能够在iOS和Mac OS之间共享代码，使得对苹果自己的OS开发团队和第三方开发者去开发两个平台的应用更加便捷。



`UIView`可以处理触摸事件，可以支持基于*Core Graphics*绘图，可以做仿射变换（例如旋转或者缩放），或者简单的类似于滑动或者渐变的动画。

`CALayer`类在概念上和`UIView`类似，同样也是一些被层级关系树管理的矩形块，同样也可以包含一些内容（像图片，文本或者背景色），管理子图层的位置。它们有一些方法和属性用来做动画和变换。和`UIView`最大的不同是`CALayer`不处理用户的交互。

`CALayer`并不清楚具体的*响应链*（iOS通过视图层级关系用来传送触摸事件的机制），于是它并不能够响应事件，即使它提供了一些方法来判断是否一个触点在图层的范围之内



Core Animation 维护了两个平行 layer 层次结构：

+ *model layer tree（模型层树）* - 反映了我们能直接看到的 layers 的状态
+ *presentation layer tree（表示层树）*-  则是动画正在表现的值的近似

> 实际上还有所谓的第三个 layer 树，叫做 *rendering tree（渲染树）*。因为它对 Core Animation 而言是私有的，所以我们在这里不讨论它。

考虑在 view 上增加一个渐出动画。如果在动画中的任意时刻，查看 layer 的 `opacity` 值，你是得不到与屏幕内容对应的透明度的。取而代之，你需要查看 presentation layer 以获得正确的结果。

虽然你可能不会去直接设置 presentation layer 的属性，但是使用它的当前值来创建新的动画或者在动画发生时与 layers 交互是非常有用的。

通过使用 `-[CALayer presentationLayer]` 和 `-[CALayer modelLayer]`，你可以在两个 layer 之间轻松切换。



