# Category vs Extension

区别：

参考：

+ [OC中Category和Extension以及继承的用法和区别](https://www.jianshu.com/p/935e966c0c08)

> ```dart
> 1.形式上看：extension 是匿名的category
> 2.extension中声明的方法需要在implementation中实现，而category 不做强制要求
> 3.extension 可以添加属性、成员变量，而category 一般不可以。
> 
> 
> 虽然有人说extension是一个特殊的category，也有人将extension叫做匿名分类，但是其实两者差别很大。
> 
> extension
> 
> 1.在编译器决议，是类的一部分，在编译器和头文件的@interface和实现文件里的@implement一起形成了一个完整的类。
> 2.伴随着类的产生而产生，也随着类的消失而消失。
> 3.extension一般用来隐藏类的私有消息，你必须有一个类的源码才能添加一个类的extension，所以对于系统一些类，如nsstring，就无法添加类扩展
> 
> category
> 
> 1.是运行期决议的
> 2.类扩展可以添加实例变量，分类不能添加实例变量
> 原因：因为在运行期，对象的内存布局已经确定，如果添加实例变量会破坏类的内部布局，这对编译性语言是灾难性的。
> ```



