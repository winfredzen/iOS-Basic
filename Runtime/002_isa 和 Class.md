# isa 和 Class

内容来自：

+ [神经病院 Objective-C Runtime 入院第一天—— isa 和 Class](https://halfrost.com/objc_runtime_isa_class/)



## 一. Runtime简介

Runtime 又叫运行时，是一套底层的 C 语言 API，是 iOS 系统的核心之一。开发者在编码过程中，可以给任意一个对象发送消息，在编译阶段只是确定了要向接收者发送这条消息，而接受者将要如何响应和处理这条消息，那就要看运行时来决定了。

C语言中，在编译期，函数的调用就会决定调用哪个函数。
而OC的函数，属于动态调用过程，在编译期并不能决定真正调用哪个函数，只有在真正运行时才会根据函数的名称找到对应的函数来调用。

Objective-C 是一个动态语言，这意味着它不仅需要一个编译器，也需要一个运行时系统来动态得创建类和对象、进行消息传递和转发。

Objc 在三种层面上与 Runtime 系统进行交互：

![001](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/001.png)

##### 1. 通过 Objective-C 源代码

一般情况开发者只需要编写 OC 代码即可，Runtime 系统自动在幕后把我们写的源代码在编译阶段转换成运行时代码，在运行时确定对应的数据结构和调用具体哪个方法。

##### 2. 通过 Foundation 框架的 NSObject 类定义的方法

在OC的世界中，除了NSProxy类以外，所有的类都是NSObject的子类。在Foundation框架下，NSObject和NSProxy两个基类，定义了类层次结构中该类下方所有类的公共接口和行为。NSProxy是专门用于实现代理对象的类，这个类暂时本篇文章不提。这两个类都遵循了NSObject协议。在NSObject协议中，声明了所有OC对象的公共方法。



在NSObject协议中，有以下5个方法，是可以从Runtime中获取信息，让对象进行自我检查。

```objective-c
- (Class)class OBJC_SWIFT_UNAVAILABLE("use 'anObject.dynamicType' instead");
- (BOOL)isKindOfClass:(Class)aClass;
- (BOOL)isMemberOfClass:(Class)aClass;
- (BOOL)conformsToProtocol:(Protocol *)aProtocol;
- (BOOL)respondsToSelector:(SEL)aSelector;
```

-class方法返回对象的类；
-isKindOfClass: 和 -isMemberOfClass: 方法检查对象是否存在于指定的类的继承体系中；
-respondsToSelector: 检查对象能否响应指定的消息；
-conformsToProtocol:检查对象是否实现了指定协议类的方法；



在NSObject的类中还定义了一个方法

```objective-c
- (IMP)methodForSelector:(SEL)aSelector;
```

这个方法会返回指定方法实现的地址IMP。

以上这些方法会在本篇文章中详细分析具体实现。



##### 3. 通过对 Runtime 库函数的直接调用

关于这一点，其实还有一个小插曲。当我们导入了objc/Runtime.h和objc/message.h两个头文件之后，我们查找到了Runtime的函数之后，代码打完，发现没有代码提示了，那些函数里面的参数和描述都没有了。对于熟悉Runtime的开发者来说，这并没有什么难的，因为参数早已铭记于胸。但是对于新手来说，这是相当不友好的。而且，如果是从iOS6开始开发的同学，依稀可能能感受到，关于Runtime的具体实现的官方文档越来越少了？可能还怀疑是不是错觉。其实从Xcode5开始，苹果就不建议我们手动调用Runtime的API，也同样希望我们不要知道具体底层实现。所以IDE上面默认代了一个参数，禁止了Runtime的代码提示，源码和文档方面也删除了一些解释。

具体设置如下:

![002](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/002.png)

如果发现导入了两个库文件之后，仍然没有代码提示，就需要把这里的设置改成NO，即可。



## 二. NSObject起源

由上面一章节，我们知道了与Runtime交互有3种方式，前两种方式都与NSObject有关，那我们就从NSObject基类开始说起。

以下源码分析均来自[objc4-680](http://opensource.apple.com//source/objc4/)

NSObject的定义如下

```objective-c
typedef struct objc_class *Class;

@interface NSObject <NSObject> {
    Class isa  OBJC_ISA_AVAILABILITY;
}
```

在Objc2.0之前，objc_class源码如下：

```objective-c
struct objc_class {
    Class isa  OBJC_ISA_AVAILABILITY;
    
#if !__OBJC2__
    Class super_class                                        OBJC2_UNAVAILABLE;
    const char *name                                         OBJC2_UNAVAILABLE;
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
    struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
    struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
    struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
#endif
    
} OBJC2_UNAVAILABLE;

```

在这里可以看到，在一个类中，有超类的指针，类名，版本的信息。
ivars是objc_ivar_list成员变量列表的指针；methodLists是指向objc_method_list指针的指针。*methodLists是指向方法列表的指针。这里如果动态修改*methodLists的值来添加成员方法，这也是**Category实现的原理**，同样解释了Category不能添加属性的原因。



关于Category，这里推荐2篇文章可以仔细研读一下。
[深入理解Objective-C：Category](http://tech.meituan.com/DiveIntoCategory.html)
[结合 Category 工作原理分析 OC2.0 中的 runtime](https://bestswifter.com/jie-he-category-gong-zuo-yuan-li-fen-xi-oc2-0-zhong-de-runtime/)



然后在2006年苹果发布Objc 2.0之后，objc_class的定义就变成下面这个样子了。

```objective-c
typedef struct objc_class *Class;
typedef struct objc_object *id;

@interface Object { 
    Class isa; 
}

@interface NSObject <NSObject> {
    Class isa  OBJC_ISA_AVAILABILITY;
}

struct objc_object {
private:
    isa_t isa;
}

struct objc_class : objc_object {
    // Class ISA;
    Class superclass;
    cache_t cache;             // formerly cache pointer and vtable
    class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags
}

union isa_t 
{
    isa_t() { }
    isa_t(uintptr_t value) : bits(value) { }
    Class cls;
    uintptr_t bits;
}

```

![003](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/003.png)



把源码的定义转化成类图，就是上图的样子。

从上述源码中，我们可以看到，**Objective-C 对象都是 C 语言结构体实现的**，在objc2.0中，所有的对象都会包含一个isa_t类型的结构体。

**objc_object被源码typedef成了id类型**，这也就是我们平时遇到的id类型。这个结构体中就只包含了一个isa_t类型的结构体。这个结构体在下面会详细分析。

objc_class继承于objc_object。所以在objc_class中也会包含isa_t类型的结构体isa。至此，可以得出结论：**Objective-C 中类也是一个对象**。在objc_class中，除了isa之外，还有3个成员变量，一个是父类的指针，一个是方法缓存，最后一个这个类的实例方法链表。

**object类和NSObject类里面分别都包含一个objc_class类型的isa。**

上图的左半边类的关系描述完了，接着先从isa来说起。

**当一个对象的实例方法被调用的时候，会通过isa找到相应的类，然后在该类的class_data_bits_t中去查找方法。class_data_bits_t是指向了类对象的数据区域。在该数据区域内查找相应方法的对应实现。**

但是在我们调用类方法的时候，类对象的isa里面是什么呢？这里为了和对象查找方法的机制一致，遂引入了**元类**(meta-class)的概念。



关于元类，更多具体可以研究这篇文章[What is a meta-class in Objective-C?](http://www.cocoawithlove.com/2010/01/what-is-meta-class-in-objective-c.html)



在引入元类之后，类对象和对象查找方法的机制就完全统一了。

对象的实例方法调用时，通过对象的 isa 在类中获取方法的实现。
类对象的类方法调用时，通过类的 isa 在元类中获取方法的实现。

meta-class之所以重要，是因为它存储着一个类的所有类方法。每个类都会有一个单独的meta-class，因为每个类的类方法基本不可能完全相同。

对应关系的图如下图，下图很好的描述了对象，类，元类之间的关系:



![004](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/004.png)



图中实线是 super_class指针，虚线是isa指针。

1. Root class (class)其实就是NSObject，NSObject是没有超类的，所以Root class(class)的superclass指向nil。

2. 每个Class都有一个isa指针指向唯一的Meta class
3. Root class(meta)的superclass指向Root class(class)，也就是NSObject，形成一个回路。
4. 每个Meta class的isa指针都指向Root class (meta)。



我们其实应该明白，类对象和元类对象是唯一的，对象是可以在运行时创建无数个的。而在main方法执行之前，从 dyld到runtime这期间，类对象和元类对象在这期间被创建。具体可看sunnyxx这篇[iOS 程序 main 函数之前发生了什么](http://blog.sunnyxx.com/2014/08/30/objc-pre-main/)











































