# Autoreleasepool原理

参考：

+ [黑幕背后的Autorelease](https://blog.sunnyxx.com/2014/10/15/behind-autorelease/)
+ [AutoreleasePool的原理和实现](https://www.jianshu.com/p/1b66c4d47cd7)



ARC下，我们使用`@autoreleasepool{}`来使用一个AutoreleasePool，随后编译器将其改写成下面的样子：

```objective-c
void *context = objc_autoreleasePoolPush();
// {}中的代码
objc_autoreleasePoolPop(context);
```

而这两个函数都是对`AutoreleasePoolPage`的简单封装，所以自动释放机制的核心就在于这个类。

AutoreleasePoolPage是一个C++实现的类

