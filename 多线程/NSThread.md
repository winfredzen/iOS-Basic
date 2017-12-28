# NSThread

一个`NSThread`对象就代表一条线程，`NSThread`创建线程有如下的形式：

1.使用`initWithTarget: selector: object:` 方法，该方法有3个参数：

+ 第一个参数：目标对象
+ 第二个参数：方法选择器
+ 第三个参数：传递的参数

使用此方法创建线程后，需要启动线程，如下：

```
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(run:) object:@"abc"];
    thread.name = @"子线程";
    [thread start];
```

`name`属性设置线程的名称

```
thread.name = @"子线程";
```

`threadPriority`属性设置线程优先级，取值范围 `0.0 ~ 1.0` 之间，最高是`1.0`，默认优先级是`0.5`

```
thread.threadPriority = 1.0;
```

**线程的生命周期：当线程中的任务执行完毕之后就被释放掉**

2.使用`detachNewThreadSelector: toTarget: withObject:`分离出一条子线程，它会自动启动线程，并且无法对线程进行更详细的设置

```
[NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:@"abc"];
```

3.使用`performSelectorInBackground: withObject:`隐式创建并启动线程

```
[self performSelectorInBackground:@selector(run:) withObject:@"abc"];
```

**主线程相关方法**

```
+ (NSThread *)mainThread; // 获得主线程
- (BOOL)isMainThread; // 是否为主线程
+ (BOOL)isMainThread; // 是否为主线程
```

**获取当前线程**

```
NSThread *current = [NSThread currentThread];
```

**线程名字**

```
- (void)setName:(NSString *)n;
- (NSString *)name;
```

## 线程状态

![线程状态](https://github.com/winfredzen/iOS-Basic/blob/master/%E5%A4%9A%E7%BA%BF%E7%A8%8B/images/1.png)


**启动线程**

```
- (void)start; 
```

启动线程：调用`start`后，线程进入就绪状态，进入就绪状态，就意味着线程被放到了一个可调度线程池里面，这时CPU就可以来调度它。当CPU来调度它时，线程就处于运行状态。当线程任务执行完毕，自动进入死亡状态


**阻塞(暂停)线程**

```
+ (void)sleepUntilDate:(NSDate *)date;
+ (void)sleepForTimeInterval:(NSTimeInterval)ti;
```

**强制停止线程**

```
+ (void)exit;
```

调用`exit`方法，强制停止线程，此时线程进入死亡状态


## 多线程遇到的问题

### 资源共享

当多个线程访问同一块资源时，很容易引发数据错乱和数据安全问题

如下图所示：

![资源共享](https://github.com/winfredzen/iOS-Basic/blob/master/%E5%A4%9A%E7%BA%BF%E7%A8%8B/images/2.png)

2个线程同时对一个资源操作，导致最后的结果出错

针对这种情况，可以加锁来处理，如下图所示：

![互斥锁](https://github.com/winfredzen/iOS-Basic/blob/master/%E5%A4%9A%E7%BA%BF%E7%A8%8B/images/3.png)


### @synchronized

可通过**@synchronized**来解决

>The @synchronized directive is a convenient way to create mutex locks on the fly in Objective-C code. The @synchronized directive does what any other mutex lock would do—it prevents different threads from acquiring the same lock at the same time. 
>
>@synchronized是一种创建互斥锁的方便形式。阻止不同的线程在同一时间获取相同的锁
>
>The object passed to the @synchronized directive is a unique identifier used to distinguish the protected block. If you execute the preceding method in two different threads, passing a different object for the anObj parameter on each thread, each would take its lock and continue processing without being blocked by the other. If you pass the same object in both cases, however, one of the threads would acquire the lock first and the other would block until the first thread completed the critical section.
>
>传递给@synchronized的对象，是一个独特的标识符用来区别受保护的block
>
>[Using the @synchronized Directive](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Multithreading/ThreadSafety/ThreadSafety.html#//apple_ref/doc/uid/10000057i-CH8-SW3)



@synchronized的深入介绍，可参考如下的博文：

+ [正确使用多线程同步锁@synchronized()](http://ios.jobbole.com/91126/)
+ [关于 @synchronized，这儿比你想知道的还要多](http://yulingtianxia.com/blog/2015/11/01/More-than-you-want-to-know-about-synchronized/)

如下的例子，多个线程，对一个count处理：

```
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.totalCount = 100;
    
    self.threadA = [[NSThread alloc]initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.threadB = [[NSThread alloc]initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.threadC = [[NSThread alloc]initWithTarget:self selector:@selector(saleTicket) object:nil];
    
    self.threadA.name = @"threadA";
    self.threadB.name = @"threadB";
    self.threadC.name = @"threadC";
    
    //启动线程
    [self.threadA start];
    [self.threadB start];
    [self.threadC start];

}

-(void)saleTicket{
    NSInteger count = self.totalCount;
    if (count > 0) {
        [NSThread sleepForTimeInterval:2];//休眠2s
        self.totalCount = count - 1;
        NSLog(@"thread is %@, count is %zd", [NSThread currentThread].name,self.totalCount);
    }else{
        NSLog(@"count is 0");
    }
}

```

启动3个线程后，控制台输出的结果如下：

```
thread is threadC, count is 99
thread is threadA, count is 99
thread is threadB, count is 99
```
**结果并不正确**

加上@synchronized后即可正常的调用了，如下：

```
-(void)saleTicket{
    @synchronized (self) {
        NSInteger count = self.totalCount;
        if (count > 0) {
            [NSThread sleepForTimeInterval:2];
            self.totalCount = count - 1;
            NSLog(@"thread is %@, count is %zd", [NSThread currentThread].name,self.totalCount);
        }else{
            NSLog(@"count is 0");
        }
    }
}
```

此时控制台输出如下：

```
thread is threadB, count is 99
thread is threadC, count is 98
thread is threadA, count is 97
```

注意的问题：
`@synchronized (self)`会降低代码效率，因为共用同一个锁的那些同步块，都必须按顺序执行。若是self对象上频繁加锁，那么程序可能要等另一段与此无关的代码执行完毕，才能继续执行当前的代码。


## 其它锁

大神的博文[深入理解 iOS 开发中的锁](https://bestswifter.com/ios-lock/)

### NSLock

参考[More than you want to know about @synchronized](http://rykap.com/objective-c/2015/05/09/synchronized/)中使用的例子：

```
@implementation ThreadSafeQueue
{
    NSMutableArray *_elements;
    NSLock *_lock;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _elements = [NSMutableArray array];
        _lock = [[NSLock alloc] init];
    }
    return self;
}

- (void)push:(id)element
{
    [_lock lock];
    [_elements addObject:element];
    [_lock unlock];
}

@end
```

### NSRecursiveLock

`NSRecursiveLock`递归锁，不会出现死锁问题。参考[NSRecursiveLock递归锁的使用](http://www.cocoachina.com/ios/20150513/11808.html)

## 线程间通信

例如，在一个线程传递数据给另一个线程，或者在一个线程中完成任务后，然后再在另一个线程处理

线程间通信常用方法

```
- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait;
- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait;
```

如下的下载图片、显示图片的操作：

```
-(void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [NSThread detachNewThreadSelector:@selector(downloadImage) toTarget:self withObject:nil];
}

-(void)downloadImage
{
    NSURL *url = [NSURL URLWithString:@"xxxxx"];

    NSData *data = [NSData dataWithContentsOfURL:url];

    UIImage *image = [UIImage imageWithData:data];

//    [self performSelectorOnMainThread:@selector(showImage:) withObject:image waitUntilDone:YES];

//    [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];

    [self.imageView performSelector:@selector(setImage:) onThread:[NSThread mainThread] withObject:image waitUntilDone:YES];
}
```

### 计算代码段的执行时间

```
	//第一种方法
    NSDate *start = [NSDate date];
    //2.根据url地址下载图片数据到本地（二进制数据）
    NSData *data = [NSData dataWithContentsOfURL:url];

    NSDate *end = [NSDate date];
    NSLog(@"第二步操作花费的时间为%f",[end timeIntervalSinceDate:start]);

	//第二种方法
    CFTimeInterval start = CFAbsoluteTimeGetCurrent();
    NSData *data = [NSData dataWithContentsOfURL:url];

    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    NSLog(@"第二步操作花费的时间为%f",end - start);
```





















