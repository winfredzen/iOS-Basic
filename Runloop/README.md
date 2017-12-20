# RunLoop

RunLoop从字面上理解就是运行循环，其基本作用是：

+ 保存程序的持续运行
+ 处理App中的各种事件（如触摸事件、定时器事件、Selector事件）
+ 节省CPU资源，提高程序性能，该做事时做事，该休息时休息

如下如果没有RunLoop，程序执行之后就结束了

```
int main(int argc, char * argv[]) {
    NSLog(@"execute main function");
    return 0;
}
```

如果有了RunLoop，由于main函数里面启动了个RunLoop，所以程序并不会马上退出，保持持续运行状态

```
int main(int argc, char * argv[]) {
    BOOL running = YES;
    do {
        // 执行各种任务，处理各种事件
             // ......
    } while (running);
    return 0;
}

```

iOS的main函数

```
int main(int argc, char * argv[]) {
  @autoreleasepool {
      return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }
}
```
`UIApplicationMain`函数内部就启动了一个RunLoop，所以`UIApplicationMain`函数一直没有返回，保持了程序的持续运行
，这个这个默认启动的RunLoop是跟主线程相关联的




iOS中有2套API来访问和使用RunLoop

+ `Foundation`中的`NSRunLoop` 是基于 `CFRunLoopRef` 的封装，提供了面向对象的 API，但是这些 API 不是线程安全的

	```
	  NSRunLoop *mainRunLoop = [NSRunLoop mainRunLoop];// 获得主线程的RunLoop对象

	  NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];// 获得当前线程的RunLoop对象

	  
	  NSLog(@"mainRunLoop : %p, currentRunLoop : %p", mainRunLoop, currentRunLoop);
	  //mainRunLoop : 0x6040000affc0, currentRunLoop : 0x6040000affc0
	```

+ `Core Foundation`中的`CFRunLoopRef` 是在 `CoreFoundation` 框架内的，它提供了纯 C 函数的 API，所有这些 API 都是线程安全的

	```
	  NSLog(@"%p", CFRunLoopGetMain());//获得主线程的RunLoop对象
 0x6040001f1300
	  NSLog(@"%p", CFRunLoopGetCurrent());//获得当前线程的RunLoop对象
 0x6040001f1300
	  NSLog(@"%p", mainRunLoop.getCFRunLoop);//0x6040001f1300
	```

**RunLoop与线程的关系**

+ 每条线程都有唯一的一个与之对应的RunLoop对象
+ 主线程的RunLoop已经自动创建好了，子线程的RunLoop需要主动创建
+ RunLoop在第一次获取时创建，在线程结束时销毁



**在 `CoreFoundation` 里面关于 RunLoop 有5个类**

+ CFRunLoopRef
+ CFRunLoopModeRef
+ CFRunLoopSourceRef
+ CFRunLoopTimerRef
+ CFRunLoopObserverRef

具体的解释参考大神的博文[深入理解RunLoop](https://blog.ibireme.com/2015/05/18/runloop/)

>一个 RunLoop 包含若干个 Mode，每个 Mode 又包含若干个 Source/Timer/Observer。每次调用 RunLoop 的主函数时，只能指定其中一个 Mode，这个Mode被称作 CurrentMode。如果需要切换 Mode，只能退出 Loop，再重新指定一个 Mode 进入。这样做主要是为了分隔开不同组的 Source/Timer/Observer，让其互不影响。

要注意的是Mode里面至少要有一个Timer或者Source，如果RunLoop中没有Timer和Source，只有Observer是不可以的

## CFRunLoopModeRef

`CFRunLoopModeRef`代表RunLoop的运行模式，一个RunLoop包含若干个Mode，每个Mode又包含若干个Source/Timer/Observer

系统默认注册了5个Mode：

+ **kCFRunLoopDefaultMode**-App默认的Mode，通常主线程是在这个模式下运行
+ **NSEventTrackingRunLoopMode**-界面跟踪Mode，用于ScrollView追踪触摸滚动，保证界面滑动时不收其他Mode的影响
+ UIInitializationRunLoopMode-在刚启动 App 时第进入的第一个 Mode，启动完成后就不再使用
+ GSEventReceiveRunLoopMode: 接受系统事件的内部 Mode，通常用不到
+ **kCFRunLoopCommonModes**: 这是一个占位的 Mode，不是一种真正的Mode


如下Timer使用不同的Mode的例子，在界面上添加一个`UITextView`

```
- (void)timer{
  NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
  //[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
  //[[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
  [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
```

+ `NSDefaultRunLoopMode`时-Timer的事件在textView滚动时不执行
+ `UITrackingRunLoopMode`时-Timer的事件在textView滚动时才执行
+ `NSRunLoopCommonModes`时-Timer的事件在textView滚动时或不滚动时都执行(`NSRunLoopCommonModes = NSDefaultRunLoopMode + UITrackingRunLoopMode`)


使用`scheduledTimerWithTimeInterval: target: selector:userInfo:repeats:`方法创建的timer，会自动添加到runloop中，并设置运行模式为默认。所以，如果在子线程中使用这个方法创建这个timer，由于当前子线程对应的`RunLoop`并不存在（主线程对应的RunLoop默认创建），所以需要创建当前子线程对应的`RunLoop`

```
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [NSThread detachNewThreadSelector:@selector(timerInThread) toTarget:self withObject:nil];
}

- (void)timerInThread{
  NSRunLoop *currentRunloop = [NSRunLoop currentRunLoop];
  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
  //开启runloop
  [currentRunloop run];
}

```

## CFRunLoopTimerRef

CFRunLoopTimerRef是基于时间的触发器，基本上说的就是NSTimer

### GCD定时器

NSTimer定时器是会受到RunLoop运行模式影响的，而GCD定时器则不回受到RunLoop的影响，而且GCD定时器是绝对精准的

在Xcode中可直接使用代码库来调出GCD定时器，不用一个一个的写

![GCD定时器](https://github.com/winfredzen/iOS-Basic/blob/master/Runloop/images/1.png)

使用时要注意的一点就是：要放置创建的timer被释放掉，需要强引用它，如下的例子：

```
@property (nonatomic, strong) dispatch_source_t timer;
……

//GCD定时器
- (void)GCDTimer{
  //1.创建GCD中的定时器
  /**
   *第一个参数：source的类型，DISPATCH_SOURCE_TYPE_TIMER表示定时器
   *第二个参数：描述信息，线程ID
   *第三个参数：更详细描述信息
   *第四个参数：队列，决定GCD定时器中的任务在哪个线程中执行的
   */
  dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
  //2.设置定时器（起始时间，间隔时间，精准度）
  /**
   *第一个参数：定时器对象
   *第二个参数：起始时间，DISPATCH_TIME_NOW表示从现在开始计时
   *第三个参数：间隔时间，GCD中时间是以纳秒为单位的
   *第四个参数：精准度，如果想绝对精准，传0
   */
  dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
  //3.设置定时器任务
  dispatch_source_set_event_handler(timer, ^{
    NSLog(@"CurrentThread: %@", [NSThread currentThread]);
  });
  //4.启动执行
  dispatch_resume(timer);
  
  self.timer = timer;
}
```

## CFRunLoopSourceRef

CFRunLoopSourceRef是事件源（输入源），其分类是：

1.原来的分法

+ Port-Based Sources基于端口
+ Custom Input Sources基于自定义的
+ Cocoa Perform Selector Sources

2.现在的分法

+ Source0：非基于Port的（可以理解为用户主动触发的事件，例如按钮点击事件）
+ Source1：基于Port的（可以理解为系统内部的消息事件）

## CFRunloopObserver

`CFRunLoopObserverRef`是观察者，能够监听RunLoop的状态改变

可以监听的时间点有以下几个：

```
typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
    kCFRunLoopEntry         = (1UL << 0), // 即将进入Loop
    kCFRunLoopBeforeTimers  = (1UL << 1), // 即将处理 Timer
    kCFRunLoopBeforeSources = (1UL << 2), // 即将处理 Source
    kCFRunLoopBeforeWaiting = (1UL << 5), // 即将进入休眠
    kCFRunLoopAfterWaiting  = (1UL << 6), // 刚从休眠中唤醒
    kCFRunLoopExit          = (1UL << 7), // 即将退出Loop
};
```

如下的例子，创建观察者，添加一个timer，观察调用情况

```
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [self observer];
  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(task) userInfo:nil repeats:YES];
}

.....

-(void)task
{
  NSLog(@"%s",__func__);
  
  //    [NSRunLoop currentRunLoop] runUntilDate:[];
}

-(void)observer
{
  //1.创建监听者
  /*
   第一个参数:怎么分配存储空间
   第二个参数:要监听的状态 kCFRunLoopAllActivities 所有的状态
   第三个参数:时候持续监听
   第四个参数:优先级 总是传0
   第五个参数:当状态改变时候的回调
   */
  CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
    
    /*
     kCFRunLoopEntry = (1UL << 0),        即将进入runloop
     kCFRunLoopBeforeTimers = (1UL << 1), 即将处理timer事件
     kCFRunLoopBeforeSources = (1UL << 2),即将处理source事件
     kCFRunLoopBeforeWaiting = (1UL << 5),即将进入睡眠
     kCFRunLoopAfterWaiting = (1UL << 6), 被唤醒
     kCFRunLoopExit = (1UL << 7),         runloop退出
     kCFRunLoopAllActivities = 0x0FFFFFFFU
     */
    switch (activity) {
      case kCFRunLoopEntry:
        NSLog(@"即将进入runloop");
        break;
      case kCFRunLoopBeforeTimers:
        NSLog(@"即将处理timer事件");
        break;
      case kCFRunLoopBeforeSources:
        NSLog(@"即将处理source事件");
        break;
      case kCFRunLoopBeforeWaiting:
        NSLog(@"即将进入睡眠");
        break;
      case kCFRunLoopAfterWaiting:
        NSLog(@"被唤醒");
        break;
      case kCFRunLoopExit:
        NSLog(@"runloop退出");
        break;
        
      default:
        break;
    }
  });
  
  //添加Observer
  /*
   第一个参数:要监听哪个runloop
   第二个参数:观察者
   第三个参数:运行模式
   */
  CFRunLoopAddObserver(CFRunLoopGetCurrent(),observer, kCFRunLoopDefaultMode);
  
  //NSDefaultRunLoopMode == kCFRunLoopDefaultMode
  //NSRunLoopCommonModes == kCFRunLoopCommonModes
}

```
点击屏幕，控制台输出如下：

```
2017-12-20 11:43:08.076589+0800 RunLoop[16614:2570242] 被唤醒
2017-12-20 11:43:08.076832+0800 RunLoop[16614:2570242] -[ViewController task]
2017-12-20 11:43:08.077277+0800 RunLoop[16614:2570242] 即将处理timer事件
2017-12-20 11:43:08.077399+0800 RunLoop[16614:2570242] 即将处理source事件
2017-12-20 11:43:08.077535+0800 RunLoop[16614:2570242] 即将进入睡眠
2017-12-20 11:43:10.076849+0800 RunLoop[16614:2570242] 被唤醒
2017-12-20 11:43:10.077035+0800 RunLoop[16614:2570242] -[ViewController task]
2017-12-20 11:43:10.077199+0800 RunLoop[16614:2570242] 即将处理timer事件
2017-12-20 11:43:10.077321+0800 RunLoop[16614:2570242] 即将处理source事件
2017-12-20 11:43:10.077462+0800 RunLoop[16614:2570242] 即将进入睡眠
```

利用Observer，可以在RunLoop进入休眠状态时，分配一些任务给它，将其唤醒

##RunLoop处理逻辑

![官方图](https://github.com/winfredzen/iOS-Basic/blob/master/Runloop/images/2.png)

**RunLoop事件队列**
每次运行run loop，你线程的run loop都会自动处理之前未处理的消息，并通知相关的观察者。具体的顺序如下：

1.通知观察者run loop已经启动
2.通知观察者任何即将要开始的定时器
3.通知观察者任何即将启动的非基于端口的源
4.启动任何准备好的非基于端口的源
5.如果基于端口的源准备好并处于等待状态，立即启动，并进入步骤9
6.通知观察者线程进入休眠
7.将线程置于休眠直到任一下面的事件发生：

+ 某一事件到达基于端口的源
+ 定时器启动
+ run loop设置的事件已经超时
+ run loop被显示唤醒


8.通知观察者线程将被唤醒
8.处理未处理的事件

+ 如果用户定义的定时器启动，处理定时器事件并重启run loop，进入步骤2
+ 如果输入源启动，传递相应的消息
+ 如果run loop被显式唤醒而且时间还没超时，重启run loop，进入步骤2

10.通知观察者run loop结束


![非官方图](https://github.com/winfredzen/iOS-Basic/blob/master/Runloop/images/3.png)




	






















