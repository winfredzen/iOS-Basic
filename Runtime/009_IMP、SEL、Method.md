# IMP、SEL、Method

参考：

+ [Selector, Method 和 IMP 的区别与联系](https://www.jianshu.com/p/84d1771e9792)



## Selector

```objective-c
typedef struct objc_selector *SEL
```

**选择子或者选择器**，选择子代表方法在 Runtime 期间的标识符。为 SEL 类型，虽然 SEL 是 objc_selector 结构体指针，但实际上它只是一个 C 字符串。在类加载的时候，编译器会生成与方法相对应的选择子，并注册到 Objective-C 的 Runtime 运行系统。

常见的有两种方式来获取/创建选择子:

```objective-c
SEL selA = @selector(setString:);
SEL selB = sel_registerName("setString:"); 
```



## IMP

```objective-c
typedef id (*IMP)(id, SEL, ...)
```

代表函数指针，即函数执行的入口。该函数使用标准的 C 调用。第一个参数指向 self（它代表当前类实例的地址，如果是类则指向的是它的元类），作为消息的接受者；第二个参数代表方法的选择子；... 代表可选参数，前面的 id 代表返回值。



## Method

```objective-c
typedef struct objc_method *Method
```

Method 对开发者来说是一种不透明的类型，被隐藏在我们平时书写的类或对象的方法背后。它是一个 objc_method 结构体指针，objc_method 的定义为：

```objective-c
/// Method
struct objc_method {
    SEL method_name; 
    char *method_types;
    IMP method_imp;
};
```

+ 方法名 method_name 类型为 SEL，前面提到过相同名字的方法即使在不同类中定义，它们的方法选择器也相同。

+ 方法类型 method_types 是个 char 指针，其实存储着方法的参数类型和返回值类型，即是 Type Encoding 编码。

+ method_imp 指向方法的实现，本质上是一个函数的指针，就是前面讲到的 Implementation。



Selector，Method，IMP 它们之间的关系可以这么解释：
 **一个类（Class）持有一个分发表，在运行期分发消息，表中的每一个实体代表一个方法（Method），它的名字叫做选择子（SEL），对应着一种方法实现（IMP）。**



