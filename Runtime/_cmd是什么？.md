# _cmd是什么？

参考：

+ [Objective-C _cmd用法](http://henrydong.com/2016/01/06/Objective-C-cmd%E7%94%A8%E6%B3%95/)

`_cmd` 是隐藏的参数，代表当前方法的 selector，它和 self 一样都是每个方法调用时都会传入的参数，动态运行时会提及如何传的这两个参数。

比如这样一个语句：

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Current method: %@ %@", [self class],NSStringFromSelector(_cmd));
}
```

**控制台输出：**

```objective-c
Current method: FirstViewController viewDidLoad
```

其实我更加喜欢这样：

```objective-c
- (void)viewDidLoad
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // ...
}
```

**控制台输出：**

```objective-c
-[MyViewController viewDidLoad]
```

