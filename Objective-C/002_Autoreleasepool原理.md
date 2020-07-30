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

![004](https://github.com/winfredzen/iOS-Basic/blob/master/Objective-C/images/004.jpg)

- AutoreleasePool并没有单独的结构，而是由若干个AutoreleasePoolPage以`双向链表`的形式组合而成（分别对应结构中的parent指针和child指针）
- AutoreleasePool是按线程一一对应的（结构中的thread指针指向当前线程）
- AutoreleasePoolPage每个对象会开辟4096字节内存（也就是虚拟内存一页的大小），除了上面的实例变量所占空间，剩下的空间全部用来储存autorelease对象的地址
- 上面的`id *next`指针作为游标指向栈顶最新add进来的autorelease对象的下一个位置
- 一个AutoreleasePoolPage的空间被占满时，会新建一个AutoreleasePoolPage对象，连接链表，后来的autorelease对象在新的page加入



所以，若当前线程中只有一个AutoreleasePoolPage对象，并记录了很多autorelease对象地址时内存如下图：

![005](https://github.com/winfredzen/iOS-Basic/blob/master/Objective-C/images/005.jpg)

图中的情况，这一页再加入一个autorelease对象就要满了（也就是next指针马上指向栈顶），这时就要执行上面说的操作，建立下一页page对象，与这一页链表连接完成后，新page的`next`指针被初始化在栈底（begin的位置），然后继续向栈顶添加新对象。

**所以，向一个对象发送`- autorelease`消息，就是将这个对象加入到当前AutoreleasePoolPage的栈顶next指针指向的位置**



## 释放时刻

每当进行一次`objc_autoreleasePoolPush`调用时，runtime向当前的AutoreleasePoolPage中add进一个`哨兵对象`，值为0（也就是个nil），那么这一个page就变成了下面的样子：

![006](https://github.com/winfredzen/iOS-Basic/blob/master/Objective-C/images/006.jpg)

`objc_autoreleasePoolPush`的返回值正是这个哨兵对象的地址，被`objc_autoreleasePoolPop(哨兵对象)`作为入参，于是：

1. 根据传入的哨兵对象地址找到哨兵对象所处的page
2. 在当前page中，将晚于哨兵对象插入的所有autorelease对象都发送一次`- release`消息，并向回移动`next`指针到正确位置
3. 补充2：从最新加入的对象一直向前清理，可以向前跨越若干个page，直到哨兵所在的page



刚才的objc_autoreleasePoolPop执行后，最终变成了下面的样子：

![007](https://github.com/winfredzen/iOS-Basic/blob/master/Objective-C/images/007.jpg)



