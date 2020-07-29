# class_rw_t 和 class_ro_t 的区别

参考：

+ [Objective-C runtime - 属性与方法](http://vanney9.com/2017/06/05/objective-c-runtime-property-method/)



> 先回忆一下objc_class的结构
>
> ![019](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/019.png)
>
> `bits` 用来存储类的属性，方法，协议等信息。它是一个`class_data_bits_t`类型
>
> ```objective-c
> struct class_data_bits_t {
>     uintptr_t bits;
>     // method here
> }
> ```
>
> > `uintptr_t` is an unsigned integer type that is capable of storing a data pointer. Which typically means that it's the same size as a pointer.
>
> 这个结构体只有一个64bit的成员变量`bits`，先来看看这64bit分别存放的什么信息：
>
> ![020](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/020.png)
>
> `is_swift` : 第一个bit，判断类是否是Swift类
>
> `has_default_rr` ：第二个bit，判断当前类或者父类含有默认的`retain/release/autorelease/retainCount/_tryRetain/_isDeallocating/retainWeakReference/allowsWeakReference` 方法
>
> `require_raw_isa` ：第三个bit， 判断当前类的实例是否需要raw_isa (不是很懂)
>
> `data` ：第4-48位，存放一个指向`class_rw_t`结构体的指针，该结构体包含了该类的属性，方法，协议等信息。至于为何只用44bit来存放地址，可以参考[Objective-C runtime - 类和对象](http://vanney9.com/2017/06/03/objective-c-runtime-class-object/)
>
> ### class_rw_t 和 class_ro_t
>
> 先来看看两个结构体的内部成员变量
>
> ```objective-c
> struct class_rw_t {
>     uint32_t flags;
>     uint32_t version;
> 
>     const class_ro_t *ro;
> 
>     method_array_t methods;
>     property_array_t properties;
>     protocol_array_t protocols;
> 
>     Class firstSubclass;
>     Class nextSiblingClass;
> };
> 
> struct class_ro_t {
>     uint32_t flags;
>     uint32_t instanceStart;
>     uint32_t instanceSize;
>     uint32_t reserved;
> 
>     const uint8_t * ivarLayout;
> 
>     const char * name;
>     method_list_t * baseMethodList;
>     protocol_list_t * baseProtocols;
>     const ivar_list_t * ivars;
> 
>     const uint8_t * weakIvarLayout;
>     property_list_t *baseProperties;
> };
> ```
>
> 可以看出，class_rw_t结构体内有一个指向class_ro_t结构体的指针。
>
> 每个类都对应有一个class_ro_t结构体和一个class_rw_t结构体。在编译期间，class_ro_t结构体就已经确定，objc_class中的bits的data部分存放着该结构体的地址。在runtime运行之后，具体说来是在运行runtime的`realizeClass` 方法时，会生成class_rw_t结构体，该结构体包含了class_ro_t，并且更新data部分，换成class_rw_t结构体的地址。
>
> 用两张图来说明这个过程：
>
> 类的`realizeClass`运行之前：
>
> ![021](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/021.png)
>
> 类的`realizeClass`运行之后：
>
> ![022](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/022.png)
>
> 细看两个结构体的成员变量会发现很多相同的地方，他们都存放着当前类的属性、实例变量、方法、协议等等。区别在于：**class_ro_t存放的是编译期间就确定的；而class_rw_t是在runtime时才确定**，它会先将class_ro_t的内容拷贝过去，然后再将当前类的分类的这些属性、方法等拷贝到其中。**所以可以说class_rw_t是class_ro_t的超集**，**当然实际访问类的方法、属性等也都是访问的class_rw_t中的内容**