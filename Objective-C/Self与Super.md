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

super其实是一个编译器标示符，不是一个指针。其本质是：只要编译器看到super这个标志,就会让当前对象去调用父类方法,本质还是当前对象在调用

例如，你可以直接输出self：

```
NSLog(@"%@", self);
```

但是你不能输出super，会提示错误：

![super提示出错](https://github.com/winfredzen/iOS-Basic/blob/master/Objective-C/images/1.png)





如下的例子，`Son`继承自`Father`，在`Son`中有如下的`test`方法：

```
- (void)test {
    NSLog(@"Son Test: %@ %@ %@ %@",[self class], [self superclass], [super class], [super superclass]);
}
```
初始化一个`Son`实例，来调用`test`方法，如下：

```
    Son *son = [[Son alloc] init];
    [son test];
```

控制台输出结果为：

```
Son Test: Son Father Son Father
```

如果在`Father`中也有一个`test`方法，我们在`Son`的`test`方法中，直接调用父类的`test`方法如下：

```
//Father.m

- (void)test {
    NSLog(@"Father Test: %@ %@ %@ %@",[self class], [self superclass], [super class], [super superclass]);
}

//Son.m

- (void)test {
    [super test];
}

```

还是一样的调用`Son`实例的`test`方法，其输出结果为：

```
Father Test: Son Father Son Father
```



------

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

其解释为：

>简单来说，self和super都是指向当前实例的，不同的是，`[self class]`会在当前类的方法列表中去找class这个方法，`[super class]`会直接开始在当前类的父类中去找calss这个方法，两者在找不到的时候，都会继续向祖先类查询class方法，最终到`NSObject`类。那么问题来了，由于我们在Father和Son中都没有去重写class这个方法，最终自然都会去执行NSObject中的class方法，结果也自然应该是一样的。至于为什么是Son，我们可以看看NSObject中class的实现：
>
>```
>- (Class)class {
>    return object_getClass(self);
>}
>```
>
>这就说的通了，返回的都是self的类型，self此处正好就是Son，因此结果就会输出Son

详细的解释[刨根问底：对于 self = [super init] 的思考](http://ios.jobbole.com/84348/)

当调用`[self class]`方法时，会转化为`objc_msgSend`函数，这个函数定义如下：

这时候就开始了消息传递和转发的过程，会先从Cache 中查找方法，然后当前类，如果还是查找不到会去父类，直至`NSObject`类

对于NSObject类中，`- (Class)class`的实现如下：

```
- (Class)class {  
    return object_getClass(self);  
}
```

当调用`[super class]`方法时，会转化为`objc_msgSendSuper`，这个函数定义如下：

```
id objc_msgSendSuper(struct objc_super *super, SEL op, ...)
```

`objc_msgSendSuper`函数第一个参数`super`的数据类型是一个指向`objc_super`的结构体

```
struct objc_super {
   __unsafe_unretained id receiver;
   __unsafe_unretained Class super_class;
};
```

结构体包含两个成员，第一个是`receiver`，表示类的实例。第二个成员是记录当前类的父类是什么,会优先从Father这个类里去找`- (Class)class`,然后进行消息传递的过程。

会发现不管是`self`、还是`super`指向消息接受者是一样的，并且经过消息传递，最终处理消息的方法都是`NSObject`中的`- (Class)class`方法。

----

**为什么要写`self = [super init]`？**

>这里是担心父类初始化失败，如果初始化一个对象失败，就会返回nil，当返回nil的时候`self = [super init]`测试的主体就不会再继续执行。如果不这样做，你可能会操作一个不可用的对象，它的行为是不可预测的，最终可能会导致你的程序崩溃。




















