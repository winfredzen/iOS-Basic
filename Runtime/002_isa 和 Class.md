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



##### （1）isa_t结构体的具体实现

接下来我们就该研究研究isa的具体实现了。objc_object里面的isa是isa_t类型。通过查看源码，我们可以知道isa_t是一个union联合体。

```objective-c
struct objc_object {
private:
    isa_t isa;
public:
    // initIsa() should be used to init the isa of new objects only.
    // If this object already has an isa, use changeIsa() for correctness.
    // initInstanceIsa(): objects with no custom RR/AWZ
    void initIsa(Class cls /*indexed=false*/);
    void initInstanceIsa(Class cls, bool hasCxxDtor);
private:
    void initIsa(Class newCls, bool indexed, bool hasCxxDtor);
｝
```

那就从initIsa方法开始研究。下面以arm64为例。

```objective-c
inline void
objc_object::initInstanceIsa(Class cls, bool hasCxxDtor)
{
    initIsa(cls, true, hasCxxDtor);
}

inline void
objc_object::initIsa(Class cls, bool indexed, bool hasCxxDtor)
{
    if (!indexed) {
        isa.cls = cls;
    } else {
        isa.bits = ISA_MAGIC_VALUE;
        isa.has_cxx_dtor = hasCxxDtor;
        isa.shiftcls = (uintptr_t)cls >> 3;
    }
}
```

initIsa第二个参数传入了一个true，所以initIsa就会执行else里面的语句。

```objective-c
# if __arm64__
#   define ISA_MASK        0x0000000ffffffff8ULL
#   define ISA_MAGIC_MASK  0x000003f000000001ULL
#   define ISA_MAGIC_VALUE 0x000001a000000001ULL
    struct {
        uintptr_t indexed           : 1;
        uintptr_t has_assoc         : 1;
        uintptr_t has_cxx_dtor      : 1;
        uintptr_t shiftcls          : 33; // MACH_VM_MAX_ADDRESS 0x1000000000
        uintptr_t magic             : 6;
        uintptr_t weakly_referenced : 1;
        uintptr_t deallocating      : 1;
        uintptr_t has_sidetable_rc  : 1;
        uintptr_t extra_rc          : 19;
#       define RC_ONE   (1ULL<<45)
#       define RC_HALF  (1ULL<<18)
    };

# elif __x86_64__
#   define ISA_MASK        0x00007ffffffffff8ULL
#   define ISA_MAGIC_MASK  0x001f800000000001ULL
#   define ISA_MAGIC_VALUE 0x001d800000000001ULL
    struct {
        uintptr_t indexed           : 1;
        uintptr_t has_assoc         : 1;
        uintptr_t has_cxx_dtor      : 1;
        uintptr_t shiftcls          : 44; // MACH_VM_MAX_ADDRESS 0x7fffffe00000
        uintptr_t magic             : 6;
        uintptr_t weakly_referenced : 1;
        uintptr_t deallocating      : 1;
        uintptr_t has_sidetable_rc  : 1;
        uintptr_t extra_rc          : 8;
#       define RC_ONE   (1ULL<<56)
#       define RC_HALF  (1ULL<<7)
    };


```

![005](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/005.png)



ISA_MAGIC_VALUE = 0x000001a000000001ULL转换成二进制是11010000000000000000000000000000000000001，结构如下图：



![006](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/006.png)



关于参数的说明：

第一位index，代表是否开启isa指针优化。index = 1，代表开启isa指针优化。

在2013年9月，苹果推出了[iPhone5s](http://en.wikipedia.org/wiki/IPhone_5S)，与此同时，iPhone5s配备了首个采用64位架构的[A7双核处理器](http://en.wikipedia.org/wiki/Apple_A7)，为了节省内存和提高执行效率，苹果提出了Tagged Pointer的概念。对于64位程序，引入Tagged Pointer后，相关逻辑能减少一半的内存占用，以及3倍的访问速度提升，100倍的创建、销毁速度提升。

在WWDC2013的《Session 404 Advanced in Objective-C》视频中，苹果介绍了 Tagged Pointer。 Tagged Pointer的存在主要是为了节省内存。我们知道，对象的指针大小一般是与机器字长有关，在32位系统中，一个指针的大小是32位（4字节），而在64位系统中，一个指针的大小将是64位（8字节）。

假设我们要存储一个NSNumber对象，其值是一个整数。正常情况下，如果这个整数只是一个NSInteger的普通变量，那么它所占用的内存是与CPU的位数有关，在32位CPU下占4个字节，在64位CPU下是占8个字节的。而指针类型的大小通常也是与CPU位数相关，一个指针所占用的内存在32位CPU下为4个字节，在64位CPU下也是8个字节。如果没有Tagged Pointer对象，从32位机器迁移到64位机器中后，虽然逻辑没有任何变化，但这种NSNumber、NSDate一类的对象所占用的内存会翻倍。如下图所示：

![007](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/007.png)



苹果提出了Tagged Pointer对象。由于NSNumber、NSDate一类的变量本身的值需要占用的内存大小常常不需要8个字节，拿整数来说，4个字节所能表示的有符号整数就可以达到20多亿（注：2^31=2147483648，另外1位作为符号位)，对于绝大多数情况都是可以处理的。所以，引入了Tagged Pointer对象之后，64位CPU下NSNumber的内存图变成了以下这样：



![008](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/008.png)



关于[Tagged Pointer技术](http://www.infoq.com/cn/articles/deep-understanding-of-tagged-pointer/)详细的，可以看上面链接那个文章。



has_assoc
对象含有或者曾经含有关联引用，没有关联引用的可以更快地释放内存



has_cxx_dtor
表示该对象是否有 C++ 或者 Objc 的析构器



shiftcls
类的指针。arm64架构中有33位可以存储类指针。



源码中isa.shiftcls = (uintptr_t)cls >> 3;
将当前地址右移三位的主要原因是用于将 Class 指针中无用的后三位清除减小内存的消耗，因为类的指针要按照字节（8 bits）对齐内存，其指针后三位都是没有意义的 0。具体可以看[从 NSObject 的初始化了解 isa](https://github.com/Draveness/iOS-Source-Code-Analyze/blob/master/contents/objc/从 NSObject 的初始化了解 isa.md#shiftcls)这篇文章里面的shiftcls分析。



+ magic

  判断对象是否初始化完成，在arm64中0x16是调试器判断当前对象是真的对象还是没有初始化的空间。



+ weakly_referenced

  对象被指向或者曾经指向一个 ARC 的弱变量，没有弱引用的对象可以更快释放



+ deallocating

  对象是否正在释放内存



+ has_sidetable_rc

  判断该对象的引用计数是否过大，如果过大则需要其他散列表来进行存储。



+ extra_rc

  存放该对象的引用计数值减一后的结果。对象的引用计数超过 1，会存在这个这个里面，如果引用计数为 10，extra_rc的值就为 9。



ISA_MAGIC_MASK 和 ISA_MASK 分别是通过掩码的方式获取MAGIC值 和 isa类指针。



```objective-c
inline Class 
objc_object::ISA() 
{
    assert(!isTaggedPointer()); 
    return (Class)(isa.bits & ISA_MASK);
}
```



关于x86_64的架构，具体可以看[从 NSObject 的初始化了解 isa](https://github.com/Draveness/iOS-Source-Code-Analyze/blob/master/contents/objc/从 NSObject 的初始化了解 isa.md)文章里面的详细分析。





##### （2）cache_t的具体实现

还是继续看源码

```objective-c
struct cache_t {
    struct bucket_t *_buckets;
    mask_t _mask;
    mask_t _occupied;
}

typedef unsigned int uint32_t;
typedef uint32_t mask_t;  // x86_64 & arm64 asm are less efficient with 16-bits

typedef unsigned long  uintptr_t;
typedef uintptr_t cache_key_t;

struct bucket_t {
private:
    cache_key_t _key;
    IMP _imp;
}
```



![009](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/009.png)



根据源码，我们可以知道cache_t中存储了一个bucket_t的结构体，和两个unsigned int的变量。

mask：分配用来缓存bucket的总数。
occupied：表明目前实际占用的缓存bucket的个数。

bucket_t的结构体中存储了一个unsigned long和一个IMP。IMP是一个函数指针，指向了一个方法的具体实现。

cache_t中的bucket_t *_buckets其实就是一个散列表，用来存储Method的链表。

Cache的作用主要是为了优化方法调用的性能。当对象receiver调用方法message时，首先根据对象receiver的isa指针查找到它对应的类，然后在类的methodLists中搜索方法，如果没有找到，就使用super_class指针到父类中的methodLists查找，一旦找到就调用方法。如果没有找到，有可能消息转发，也可能忽略它。但这样查找方式效率太低，因为往往一个类大概只有20%的方法经常被调用，占总调用次数的80%。所以使用Cache来缓存经常调用的方法，当调用方法时，优先在Cache查找，如果没有找到，再到methodLists查找。





##### （3）class_data_bits_t的具体实现



源码实现如下：



```objective-c
struct class_data_bits_t {

    // Values are the FAST_ flags above.
    uintptr_t bits;
}

struct class_rw_t {
    uint32_t flags;
    uint32_t version;

    const class_ro_t *ro;

    method_array_t methods;
    property_array_t properties;
    protocol_array_t protocols;

    Class firstSubclass;
    Class nextSiblingClass;

    char *demangledName;
}

struct class_ro_t {
    uint32_t flags;
    uint32_t instanceStart;
    uint32_t instanceSize;
#ifdef __LP64__
    uint32_t reserved;
#endif

    const uint8_t * ivarLayout;
    
    const char * name;
    method_list_t * baseMethodList;
    protocol_list_t * baseProtocols;
    const ivar_list_t * ivars;

    const uint8_t * weakIvarLayout;
    property_list_t *baseProperties;

    method_list_t *baseMethods() const {
        return baseMethodList;
    }
};

```



![010](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/010.png)



在 objc_class结构体中的注释写到 class_data_bits_t相当于 class_rw_t指针加上 rr/alloc 的标志。

```objective-c
class_data_bits_t bits; // class_rw_t * plus custom rr/alloc flags
```



它为我们提供了便捷方法用于返回其中的 class_rw_t *指针：

```objective-c
class_rw_t *data() {
    return bits.data();
}
```



Objc的类的属性、方法、以及遵循的协议在obj 2.0的版本之后都放在class_rw_t中。class_ro_t是一个指向常量的指针，存储来编译器决定了的属性、方法和遵守协议。rw-readwrite，ro-readonly

在编译期类的结构中的 class_data_bits_t *data指向的是一个 class_ro_t *指针：



![011](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/011.png)



在运行时调用 realizeClass方法，会做以下3件事情：

1. 从 class_data_bits_t调用 data方法，将结果从 class_rw_t强制转换为 class_ro_t指针
2. 初始化一个 class_rw_t结构体
3. 设置结构体 ro的值以及 flag

最后调用methodizeClass方法，把类里面的属性，协议，方法都加载进来。

```objective-c
struct method_t {
    SEL name;
    const char *types;
    IMP imp;

    struct SortBySELAddress :
        public std::binary_function<const method_t&,
                                    const method_t&, bool>
    {
        bool operator() (const method_t& lhs,
                         const method_t& rhs)
        { return lhs.name < rhs.name; }
    };
};
```



方法method的定义如上。里面包含3个成员变量。SEL是方法的名字name。types是Type Encoding类型编码，类型可参考[Type Encoding](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html)，在此不细说。

IMP是一个函数指针，指向的是函数的具体实现。在runtime中消息传递和转发的目的就是为了找到IMP，并执行函数。

整个运行时过程可以描述如下：

![012](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/012.png)



更加详细的分析，请看[@Draveness](https://github.com/Draveness) 的这篇文章[深入解析 ObjC 中方法的结构](https://github.com/Draveness/iOS-Source-Code-Analyze/blob/master/contents/objc/深入解析 ObjC 中方法的结构.md#深入解析-objc-中方法的结构)

到此，总结一下objc_class 1.0和2.0的差别。

![013](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/013.png)

![014](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/014.png)



## 三. 入院考试

#### （一）[self class] 与 [super class]

> 下面代码输出什么?

```objective-c
    @implementation Son : Father
    - (id)init
    {
        self = [super init];
        if (self)
        {
            NSLog(@"%@", NSStringFromClass([self class]));
            NSLog(@"%@", NSStringFromClass([super class]));
        }
    return self;
    }
    @end
```



self和super的区别：

self是类的一个隐藏参数，每个方法的实现的第一个参数即为self。

super并不是隐藏参数，它实际上只是一个”编译器标示符”，它负责告诉编译器，当调用方法时，去调用父类的方法，而不是本类中的方法。

在调用[super class]的时候，runtime会去调用objc_msgSendSuper方法，而不是objc_msgSend



```objective-c
OBJC_EXPORT void objc_msgSendSuper(void /* struct objc_super *super, SEL op, ... */ )


/// Specifies the superclass of an instance. 
struct objc_super {
    /// Specifies an instance of a class.
    __unsafe_unretained id receiver;

    /// Specifies the particular superclass of the instance to message. 
#if !defined(__cplusplus)  &&  !__OBJC2__
    /* For compatibility with old objc-runtime.h header */
    __unsafe_unretained Class class;
#else
    __unsafe_unretained Class super_class;
#endif
    /* super_class is the first class to search */
};
```



在objc_msgSendSuper方法中，第一个参数是一个objc_super的结构体，这个结构体里面有两个变量，一个是接收消息的receiver，一个是
当前类的父类super_class。

入院考试第一题错误的原因就在这里，误认为[super class]是调用的[super_class class]。

objc_msgSendSuper的工作原理应该是这样的:
从objc_super结构体指向的superClass父类的方法列表开始查找selector，找到后以objc->receiver去调用父类的这个selector。注意，最后的调用者是objc->receiver，而不是super_class！

那么objc_msgSendSuper最后就转变成



```objective-c
// 注意这里是从父类开始msgSend，而不是从本类开始，谢谢@Josscii 和他同事共同指点出此处描述的不妥。
objc_msgSend(objc_super->receiver, @selector(class))

/// Specifies an instance of a class.  这是类的一个实例
    __unsafe_unretained id receiver;   


// 由于是实例调用，所以是减号方法
- (Class)class {
    return object_getClass(self);
}
```



由于找到了父类NSObject里面的class方法的IMP，又因为传入的入参objc_super->receiver = self。self就是son，调用class，所以父类的方法class执行IMP之后，输出还是son，最后输出两个都一样，都是输出son。



#### （二）isKindOfClass 与 isMemberOfClass

> 下面代码输出什么？



```objective-c

     @interface Sark : NSObject
     @end

     @implementation Sark
     @end

  int main(int argc, const char * argv[]) {
    @autoreleasepool {
        BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
        BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
        BOOL res3 = [(id)[Sark class] isKindOfClass:[Sark class]];
        BOOL res4 = [(id)[Sark class] isMemberOfClass:[Sark class]];

        NSLog(@"%d %d %d %d", res1, res2, res3, res4);
    }
    return 0;
  }
```

先来分析一下源码这两个函数的对象实现

```objective-c
+ (Class)class {
    return self;
}

- (Class)class {
    return object_getClass(self);
}

Class object_getClass(id obj)
{
    if (obj) return obj->getIsa();
    else return Nil;
}

inline Class 
objc_object::getIsa() 
{
    if (isTaggedPointer()) {
        uintptr_t slot = ((uintptr_t)this >> TAG_SLOT_SHIFT) & TAG_SLOT_MASK;
        return objc_tag_classes[slot];
    }
    return ISA();
}

inline Class 
objc_object::ISA() 
{
    assert(!isTaggedPointer()); 
    return (Class)(isa.bits & ISA_MASK);
}

+ (BOOL)isKindOfClass:(Class)cls {
    for (Class tcls = object_getClass((id)self); tcls; tcls = tcls->superclass) {
        if (tcls == cls) return YES;
    }
    return NO;
}

- (BOOL)isKindOfClass:(Class)cls {
    for (Class tcls = [self class]; tcls; tcls = tcls->superclass) {
        if (tcls == cls) return YES;
    }
    return NO;
}

+ (BOOL)isMemberOfClass:(Class)cls {
    return object_getClass((id)self) == cls;
}

- (BOOL)isMemberOfClass:(Class)cls {
    return [self class] == cls;
}

```



首先题目中NSObject 和 Sark分别调用了class方法。

\+ (BOOL)isKindOfClass:(Class)cls方法内部，会先去获得object_getClass的类，而object_getClass的源码实现是去调用当前类的obj->getIsa()，最后在ISA()方法中获得meta class的指针。

接着在isKindOfClass中有一个循环，先判断class是否等于meta class，不等就继续循环判断是否等于super class，不等再继续取super class，如此循环下去。

[NSObject class]执行完之后调用isKindOfClass，第一次判断先判断NSObject 和 NSObject的meta class是否相等，之前讲到meta class的时候放了一张很详细的图，从图上我们也可以看出，NSObject的meta class与本身不等。接着第二次循环判断NSObject与meta class的superclass是否相等。还是从那张图上面我们可以看到：Root class(meta) 的superclass 就是 Root class(class)，也就是NSObject本身。所以第二次循环相等，于是第一行res1输出应该为YES。

同理，[Sark class]执行完之后调用isKindOfClass，第一次for循环，Sark的Meta Class与[Sark class]不等，第二次for循环，Sark Meta Class的super class 指向的是 NSObject Meta Class， 和 Sark Class不相等。第三次for循环，NSObject Meta Class的super class指向的是NSObject Class，和 Sark Class 不相等。第四次循环，NSObject Class 的super class 指向 nil， 和 Sark Class不相等。第四次循环之后，退出循环，所以第三行的res3输出为NO。

如果把这里的Sark改成它的实例对象，[sark isKindOfClass:[Sark class]，那么此时就应该输出YES了。因为在isKindOfClass函数中，判断sark的isa指向是否是自己的类Sark，第一次for循环就能输出YES了。

isMemberOfClass的源码实现是拿到自己的isa指针和自己比较，是否相等。
第二行isa 指向 NSObject 的 Meta Class，所以和 NSObject Class不相等。第四行，isa指向Sark的Meta Class，和Sark Class也不等，所以第二行res2和第四行res4都输出NO。

















