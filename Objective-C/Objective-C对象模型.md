# Objective-C对象模型

主要内容来自唐巧《iOS开发进阶》一书

## isa指针

**在Objective-C中，每个对象都有一个名为`isa`的指针，指向该对象的类**。每个类描述了一系列它的实例特点，包括成员变量的列表、成员函数的列表等。每一个对象都可以接收消息，而对象能够接收的消息列表保存在它所对应的类中

在`NSObject.h`文件中，会发现`NSObject`就是一个包含`isa`指针的结构体

```
@interface NSObject <NSObject> {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-interface-ivars"
    Class isa  OBJC_ISA_AVAILABILITY;
#pragma clang diagnostic pop
}
```

在`objc.h`中，如下的定义：

```
/// Represents an instance of a class.
struct objc_object {
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
};

/// A pointer to an instance of a class.
typedef struct objc_object *id;
```

实际上，每个类也是一个对象。每个类也有一个`isa`指针。每个类也可以接收消息，如`[NSObject alloc]`，即向类发送名为`alloc`的消息

`Class`的定义如下，在`runtime.h`文件中查看

```
typedef struct objc_class *Class;

struct objc_class {
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;

#if !__OBJC2__
    Class _Nullable super_class                              OBJC2_UNAVAILABLE;
    const char * _Nonnull name                               OBJC2_UNAVAILABLE;
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE;
    struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;
    struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;
    struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;
#endif

} OBJC2_UNAVAILABLE;

```

类也是一个对象，所以它必须是另一个类的实例，这个类就是元类（metaclass）。元类保存了类方法的列表。当一个类方法被调用时，元类会首先查找它本身是否有该类方法的实现，如果没有，则该元类会向它的父类查找该方法

元类也是一个对象，所有元类的`isa`指针，指向一个根元类（root metaclass）。根元类的`isa`指针指向自己，形成一个闭环

![isa指针](https://github.com/winfredzen/iOS-Basic/blob/master/Objective-C/images/3.png)


-----

对象在内存中的排布可以看成一个结构体，该结构体的大小并不能动态变化，所以无法再运行时动态给对象添加成员变量（可通过其它的方式实现，但并不是真正的改变了对象的内存结构）

上面的`objc_class`定义中，方法的定义列表名为`methodLists`，指针的指针。通过修改该指针指向的值，可以动态的为某一个类增加成员方法，这就是`Category`实现的原理。同时也说明了为什么`Category`只可为对象增加成员方法，却不能增加成员变量









