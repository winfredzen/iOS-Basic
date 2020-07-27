# Runtime内存模型

参考：

+ [iOS Runtime详解](https://www.jianshu.com/p/6ebda3cd8052)
+ [iOS Runtime原理及使用](https://www.cnblogs.com/allencelee/p/7573627.html)

+ [Runtime内存模型探究](https://zhangferry.com/2020/02/23/runtime_objc_class)



> 因为Objc是一门动态语言，所以它总是想办法把一些决定工作从编译连接推迟到运行时。也就是说只有编译器是不够的，还需要一个运行时系统 (runtime system) 来执行编译后的代码。这就是 Objective-C Runtime 系统存在的意义，它是整个Objc运行框架的一块基石。
>
> RunTime简称运行时。OC就是运行时机制，其中最主要的是消息机制。对于C语言，函数的调用在编译的时候会决定调用哪个函数。对于OC的函数，属于动态调用过程，在编译的时候并不能决定真正调用哪个函数，只有在真正运行的时候才会根据函数的名称找到对应的函数来调用。



## NSObject的实现

OC中几乎所有的类都继承自`NSObject`，OC的动态性也是通过NSObject实现的，那就从NSObject开始探索。

在`runtime`源码中的`NSObject.h`中，我们可以找到`NSObject`的定义：

```objective-c
@interface NSObject <NSObject> {
    Class isa  OBJC_ISA_AVAILABILITY;
}
```

可以看出`NSObject`里有一个指向`Class`的`isa`，其中对于Class的定义在`objc.h`：

```objective-c
/// An opaque type that represents an Objective-C class.
typedef struct objc_class *Class;

/// Represents an instance of a class.
struct objc_object {
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
};
```

实例对象的isa是指向类（类对象）的。其实类（objc_class）也有一个isa属性，那它指向什么呢？**Meta Class（元类）**



参考：

+ [神经病院 Objective-C Runtime 入院第一天—— isa 和 Class](https://halfrost.com/objc_runtime_isa_class/)























