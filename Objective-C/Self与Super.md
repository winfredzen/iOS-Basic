# Self与Super

self，参考[Programming with Objective-C](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithObjects/WorkingwithObjects.html#//apple_ref/doc/uid/TP40011210-CH4-SW1)的介绍：

>Whenever you’re writing a method implementation, you have access to an important hidden value, self. Conceptually, self is a way to refer to “the object that’s received this message.” It’s a pointer, just like the greeting value above, and can be used to call a method on the current receiving object.
>
>当你在写一个方法的实现的时候，你就可以访问一个重要的隐藏的value，self。从概念上讲，self指向的是“接收到该消息的对象”，它是一个指针


[What is self in ObjC? When should i use it?](https://stackoverflow.com/questions/1311507/what-is-self-in-objc-when-should-i-use-it)
>self is an implied argument to all Obj-C methods that contains a pointer to the current object in instance methods, and a pointer to the current class in class methods.
>
>Another implied argument is _cmd, which is the selector that was sent to the method.
>
>另一个隐式参数是`_cmd`，它是发送给方法的选择器

super的介绍是：
>There’s another important keyword available to you in Objective-C, called super. Sending a message to super is a way to call through to a method implementation defined by a superclass further up the inheritance chain. The most common use of super is when overriding a method.
>
>super是个关键字。向super发送消息是一种调用继承链上的superclass所定义的方法实现的方法。 super最常用的用法是重写方法。

super其实是一个编译指示器，不是一个指针。例如，你可以直接输出self：

```
NSLog(@"%@", self);
```

但是你不能输出super，会提示错误：




在网上有这样的一个题目([有关super和self的问题](https://github.com/BaiduHiDeviOS/iOS-puzzles/issues/1))，如下：

```
    @implementation Son : Father
    - (id)init
    {
        self = [super init];
        if (self) {
            NSLog(@"%@", NSStringFromClass([self class]));
            NSLog(@"%@", NSStringFromClass([super class]));
        }
        return self;
    }
    @end
```

问的是，此时会输出什么？

答案是，两句输出语句均输出：`Son`



























