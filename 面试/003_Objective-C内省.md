# Objective-C内省

参考：

+ [OC中的内省(Introspection)方法](https://www.cnblogs.com/chenjiangxiaoyu/p/8504682.html)



我们在写OC代码的时候经常用到：`isKindOfClass:` 一类的方法，但是对于它并没有一个了解，这里也是从网上搜索了一些内容，简单介绍并记录一下。这类方法就是属于OC的特性之一：内省。

> 内省(Introspection):是面向对象语言和环境的一个强大的特性，OC和Cocoa在这个方法尤其的丰富。**内省是对象揭示自己作为一个运行时对象的详细信息的一种能力。这些详细信息包括对象在继承树上的位置，对象是否遵循特定的协议，以及是否可以响应特定的消息。**NSObject协议和类定义了很多内省方法，用于查询运行时的信息，以便根据对象的特征进行识别。

下面我们简单介绍几个NSObject的内省方法（项目中也是经常用到）：

1.`isKindOfClass:`

检查对象是否是那个类或者其派生类实例化得对象

2.`isMemberOfClass:`

检查对象是否是那个类的实例化得对象

3.`respondToSelector:`

检查对象是否包含这个方法

4.`conformsToProtocol:`

检查对象是否符合协议，是否实现了协议中所有的必选方法