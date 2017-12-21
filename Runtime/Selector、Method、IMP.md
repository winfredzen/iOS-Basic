# Selector、Method、IMP

参考[What's the difference between a method and a selector?](https://stackoverflow.com/questions/5608476/whats-the-difference-between-a-method-and-a-selector)，大致翻译下：


`Selector`表示的是method的名称。你肯定非常熟悉如下的的selectors：`alloc`, `init`, `release`, `dictionaryWithObjectsAndKeys:`, `setObject:forKey:`等。要注意的事冒号也是selector的一部分，也就是通过这种方式来确定这个方法需要参数。你可以有这样的选择器：`doFoo :::`，这是一个需要三个参数的方法，你可以这样来调用它`[someObject doFoo:arg1 :arg2 :arg3]`。可以直接在Cocoa中使用selector，它有`SEL`类型，如下：

```
SEL aSelector = @selector(doSomething:);
//或者
SEL aSelector = NSSelectorFromString(@"doSomething:");
```

定义好的selector可以用来发送messages到一个对象

```
SEL mySelector = @selector(doSomething);
[myObject doSomething]
[myObject performSelector:mySelector]
[myObject performSelector:@selector(doSomething)]
[myObject performSelector:NSSelectorFromString(@"doSomething")];
```

官网解释[Selector](https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/Selector.html)

>A selector is the name used to select a method to execute for an object, or the unique identifier that replaces the name when the source code is compiled. A selector by itself doesn’t do anything. It simply identifies a method. The only thing that makes the selector method name different from a plain string is that the compiler makes sure that selectors are unique. What makes a selector useful is that (in conjunction with the runtime) it acts like a dynamic function pointer that, for a given name, automatically points to the implementation of a method appropriate for whichever class it’s used with. Suppose you had a selector for the method run, and classes `Dog`, `Athlete`, and `ComputerSimulation` (each of which implemented a method `run`). The selector could be used with an instance of each of the classes to invoke its `run` method—even though the implementation might be different for each.


参考[SELECTOR](http://swifter.tips/selector/)
>@selector 是 Objective-C 时代的一个关键字，它可以将一个方法转换并赋值给一个 SEL 类型，它的表现很类似一个动态的函数指针。在 Objective-C 时 selector 非常常用，从设定 target-action，到自举询问是否响应某个方法，再到指定接受通知时需要调用的方法等等，都是由 selector 来负责的。


SEL类型代表着方法的签名，在类对象的方法列表中存储着该签名与方法代码的对应关系

+ [Method结构, SEL, IMP理解](http://www.vanbein.com/posts/ios%E8%BF%9B%E9%98%B6/2015/12/10/sel/)
+ [SEL类型](https://zhongjcbill.gitbooks.io/ios/oc/SEL%E7%B1%BB%E5%9E%8B.html)

----

`Message`是一个selector和你用它发送的参数。如`[dictionary setObject:obj forKey:key]`，那么`message`是选择器`setObject: forKey:`加上参数`obj`和`key`。message可以封装在`NSInvocation`对象中供以后调用。Message被发送到一个Receiver（接收消息的对象）

-----

`Method`是一个selector和一个实现（和相应的元数据）的组合。`implementation`其实是实际的代码块。它是一个函数指正（一个IMP）。 一个实际的method可以在内部使用一个`Method`结构体来检索到（从运行时获取到）。

[关于Objective-C方法的IMP](http://blog.csdn.net/swplzj/article/details/17280271)
>在Objecitve-C中，在类中对每一个方法有一个在运行时构建的数据结构，在Objective-C 2.0中，此结构对用户不可见，但仍在内部存在。
>
>
```
struct objc_method
{
  SEL method_name;
  char * method_types;
  IMP method_imp;
};
typedef objc_method Method;
```
>每个方法有3个属性

>+ 方法名：方法名为此方法的签名，有着相同函数名和参数名的方法有着相同的方法名。
>+ 方法类型：方法类型描述了参数的类型。
>+ IMP: IMP即函数指针，为方法具体实现代码块的地址，可像普通C函数调用一样使用IMP。
>
>由于Method的内部结构不可见，所以不能通过method->method_name的方式访问其内部属性，只能Objective-C运行时提供的函数获取。
>
```
SEL method_getName(Method method);
IMP method_getImplementation(Method method);
const char * ivar_getTypeEncoding(Ivar ivar);
```

----

`Method Signature`（方法签名）表示由方法的返回和接受参数组成的数据类型。 它们可以在运行时通过`NSMethodSignature`和（在某些情况下）一个原始`char *`来表示。


----

`Implementation`一个方法的实际可执行代码。 它在运行时的类型是一个`IMP`，它实际上只是一个函数指针。

>`IMP`的定义如下：

```
typedef id (*IMP)(id self,SEL _cmd,...);
```
>获取IMP，可通过`methodForSelector`来获取

```
IMP myImpDoSomething = [myObject methodForSelector:@selector(doSomething)];
```

>The method adressed by the IMP can be called by dereferencing the IMP.

```
myImpDoSomething(myObject, @selector(doSomething));
```

NSObject对象提供了两个方法来获取的IMP

```
- (IMP)methodForSelector:(SEL)aSelector;
+ (IMP)instanceMethodForSelector:(SEL)aSelector;
```








