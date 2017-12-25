# Runtime

官方文档[Objective-C Runtime Programming Guide](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008048-CH1-SW1)

**1.什么是Runtime？**

参考[iOS Runtime 详解](https://njafei.github.io/2017/05/04/runtime/)

>依照苹果文档的说法，runtime是：

>The Objective-C language defers as many decisions as it can from compile time and link time to runtime.
>
>（尽量将决定放到运行的时候，而不是在编译和链接过程）

参考[Objective-C Runtime](https://hit-alibaba.github.io/interview/iOS/ObjC-Basic/Runtime.html)

>Runtime 是 Objective-C 区别于 C 语言这样的静态语言的一个非常重要的特性。对于 C 语言，函数的调用会在编译期就已经决定好，在编译完成后直接顺序执行。但是 OC 是一门动态语言，函数调用变成了消息发送，在编译期不能知道要调用哪个函数。所以 Runtime 无非就是去解决如何在运行时期找到调用方法这样的问题。


**2.为什么说Objective-C是一门动态语言？**

参考[深入Objective-C的动态特性](https://onevcat.com/2012/04/objective-c-runtime/)

>Objective-C具有相当多的动态特性，基本的，也是经常被提到和用到的有动态类型（Dynamic typing），动态绑定（Dynamic binding）和动态加载（Dynamic loading）。


对于C语言，函数的调用在编译的时候会决定调用哪个函数

对于OC的函数，属于动态调用过程，在编译的时候并不能决定真正调用哪个函数，只有在真正运行的时候才会根据函数的名称找到对应的函数来调用

## 消息机制

在 Objective-C 中，方法的调用会被称为消息传递

方法调用的本质，就是让对象发送消息

在Objective-C中，消息在运行时才被绑定到方法实现，如：

```
[receiver message]
```

编译器会将方法调用转换为

```
objc_msgSend(receiver, selector)
```

`objc_msgSend`函数原型如下：

```
void objc_msgSend(id self, SEL cmd, ...);
```

这是一个可变参数的函数，第一个参数代表消息接收者，第二个代表 `SEL` 类型，后面的参数就是消息传递中使用的参数

如下的例子的`Person`的实例化，调用方法`eat`(不带参数)：

```
  Person *p = [[Person alloc] init];
  [p eat];
```
等同于如下的调用：

```
  Person *p1 = objc_msgSend(objc_getClass("Person"), sel_registerName("alloc"));
  p1 = objc_msgSend(p1, sel_registerName("init"));
  //调用eat方法
  objc_msgSend(p1, @selector(eat));
```

调用带参数的方法：

```
objc_msgSend(p1, @selector(speak:), @"hello");
```

调用类方法的方式有2中：

+ 通过类名调用

	```
	[Person eat];
	```

+ 通过类对象调用

	```
	[[Person class] eat];
	```

用类名调用类方法，底层会自动把类名转换成类对象调用，本质：让类对象发送消息

```
objc_msgSend([Person class], @selector(eat));
```

`objc_msgSend`的详细用法，请参见[runtime objc_msgSend使用](https://yaoqi-github.github.io/20160417/runtim-objc_msgSend%E4%BD%BF%E7%94%A8/)

**那系统是怎么去调用`eat`或者`speak:`方法的呢？** 

对象方法是保存在该对象的类的方法列表中，而类方法是保存在**元类**中方法列表中

>Objective-C 语言的内部，每一个对象都有一个名为 isa 的指针，指向该对象的类。每一个类描述了一系列它的实例的特点，包括成员变量的列表，成员函数的列表等。每一个对象都可以接受消息，而对象能够接收的消息列表是保存在它所对应的类中。
>
>因为类也是一个对象，那它也必须是另一个类的实列，这个类就是元类 (metaclass)。元类保存了类方法的列表。当一个类方法被调用时，元类会首先查找它本身是否有该类方法的实现，如果没有，则该元类会向它的父类查找该方法，直到一直找到继承链的头。
>
>参考[Objective-C对象模型及应用](http://blog.devtang.com/2013/10/15/objective-c-object-model/)

1. 通过isa去对应的类中查找
2. 把方法名转换成方法编号
3. 根据方法编号去查找对应方法
4. 找到只是最终函数实现地址,根据地址去方法区调用对应函数


**什么时候可以利用Runtime的消息机制？**

+ 可以调用私有方法


## 交换方法

例如系统的加载图片的方法，加载的图片可能为nil，我们在使用的时候要做如下的判断：

```
    UIImage *image = [UIImage imageNamed:@"1"];
    if (image == nil) {
        NSLog(@"image加载失败");
    }else{
        NSLog(@"image加载成功");
    }
```
这样每次写都要做判断，还是比较麻烦的，可以怎么来简化呢？

1.自定义一个`WZImage`，继承自`UIImage`，重写`imageNamed:`方法

```
+ (UIImage *)imageNamed:(NSString *)name
{
    UIImage *image = [super imageNamed:name];
    if (image) {
        NSLog(@"图片加载成功");
    } else {
        NSLog(@"图片加载失败");
    }
    return image;
}
```

但是这种方式使用起来，有如下的弊端：

+ 必须导入`"WZImage.h"`头文件
+ 必须使用`[WZImage imageNamed:@"1"]`方法
+ 如果原来的项目中大量的使用了`[UIImage imageNamed:@"1"]`方法，则修改起来很麻烦

2.使用分类，交换方法实现

如下在分类中创建一个`+ (UIImage *)wz_imageNamed:(NSString *)name;`方法，在`load`方法中，交换方法

```
+ (void)load
{
    Method imageNamedMethod = class_getClassMethod(self, @selector(imageNamed:));
    // 获取wz_imageNamed
    Method wz_imageNamedMethod = class_getClassMethod(self, @selector(wz_imageNamed:));

    method_exchangeImplementations(imageNamedMethod, wz_imageNamedMethod);

}

+ (UIImage *)wz_imageNamed:(NSString *)name
{
   UIImage *image = [UIImage wz_imageNamed:name];
    if (image) {
        NSLog(@"图片加载成功");
    } else {
        NSLog(@"图片加载失败");
    }
    return image;
}
```

## 动态添加方法

为什么要使用动态添加方法？

Objective-C都是懒加载机制,只要一个方法实现了,就会马上添加到方法列表中。如果一个类方法非常多，加载类到内存的时候也比较耗费资源，需要给每个方法生成映射表。对一些有会员机制的App，对某些非会员用户，如果加载全部的方法则非常不实用

```
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    Person *p = [[Person alloc] init];

    // 默认person，没有实现eat方法，可以通过performSelector调用，但是会报错。
    // 动态添加方法就不会报错
    [p performSelector:@selector(eat)];

}


@end


@implementation Person
// void(*)()
// 默认方法都有两个隐式参数，
void eat(id self,SEL sel)
{
    NSLog(@"%@ %@",self,NSStringFromSelector(sel));
}

// 当一个对象调用未实现的方法，会调用这个方法处理,并且会把对应的方法列表传过来.
// 刚好可以用来判断，未实现的方法是不是我们想要动态添加的方法
+ (BOOL)resolveInstanceMethod:(SEL)sel
{

    if (sel == @selector(eat)) {
        // 动态添加eat方法

        // 第一个参数：给哪个类添加方法
        // 第二个参数：添加方法的方法编号
        // 第三个参数：添加方法的函数实现（函数地址）
        // 第四个参数：函数的类型，(返回值+参数类型) v:void @:对象->self :表示SEL->_cmd
        class_addMethod(self, @selector(eat), eat, "v@:");

    }

    return [super resolveInstanceMethod:sel];
}
@end
```


## 动态添加属性

原理：给一个类声明属性，其实本质就是给这个类添加关联，并不是直接把这个值的内存空间添加到类存空间

如下个`NSObject`添加一个name属性：

```
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // 给系统NSObject类动态添加属性name

    NSObject *objc = [[NSObject alloc] init];
    objc.name = @"wz";
    NSLog(@"%@",objc.name);

}


@end


// 定义关联的key
static const char *key = "name";

@implementation NSObject (Property)

- (NSString *)name
{
    // 根据关联的key，获取关联的值。
    return objc_getAssociatedObject(self, key);
}

- (void)setName:(NSString *)name
{
    // 第一个参数：给哪个对象添加关联
    // 第二个参数：关联的key，通过这个key获取
    // 第三个参数：关联的value
    // 第四个参数:关联的策略
    objc_setAssociatedObject(self, key, name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
```

























