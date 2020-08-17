# RunLoop应用

参考：

+ [RunLoop已入门？不来应用一下？](https://www.jianshu.com/p/c0a550d2ac97)

**1.在RunLoop即将进入休眠前，加入大图片**

参考：

+ [RunLoopWorkDistribution](https://github.com/diwu/RunLoopWorkDistribution)

![4.gif](https://github.com/winfredzen/iOS-Basic/blob/master/Runloop/images/4.gif)

![5](https://github.com/winfredzen/iOS-Basic/blob/master/Runloop/images/5.png)



## 利用 RunLoop 原理去监控卡顿

参考：

+ [13 | 如何利用 RunLoop 原理去监控卡顿？](https://time.geekbang.org/column/article/89494?utm_term=zeus1Z0MB&utm_source=weibo&utm_medium=daiming&utm_campaign=presell-161&utm_content=daiming0320)

卡顿的原因：

+ 复杂 UI 、图文混排的绘制量过大
+ 在主线程上做网络同步请求
+ 在主线程做大量的 IO 操作
+ 运算量过大，CPU 持续高占用
+ 死锁和主子线程抢锁

监控卡顿就是要去找到主线程上都做了哪些事儿。我们都知道，线程的消息事件是依赖于 NSRunLoop 的，所以从 NSRunLoop 入手，就可以知道主线程上都调用了哪些方法。我们通过监听 NSRunLoop 的状态，就能够发现调用方法是否执行时间过长，从而判断出是否会出现卡顿

![6](https://github.com/winfredzen/iOS-Basic/blob/master/Runloop/images/6.png)



**loop 的六个状态**

```c

typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
    kCFRunLoopEntry , // 进入 loop
    kCFRunLoopBeforeTimers , // 触发 Timer 回调
    kCFRunLoopBeforeSources , // 触发 Source0 回调
    kCFRunLoopBeforeWaiting , // 等待 mach_port 消息
    kCFRunLoopAfterWaiting ), // 接收 mach_port 消息
    kCFRunLoopExit , // 退出 loop
    kCFRunLoopAllActivities  // loop 所有状态改变
}
```

如果 RunLoop 的线程，**进入睡眠前方法的执行时间过长而导致无法进入睡眠**，或者**线程唤醒后接收消息时间过长而无法进入下一步的话**，就可以认为是线程受阻了。如果这个线程是主线程的话，表现出来的就是出现了卡顿。

所以，如果我们要利用 RunLoop 原理来监控卡顿的话，就是要关注这两个阶段。**RunLoop 在进入睡眠之前和唤醒后的两个 loop 状态定义的值**，分别是 kCFRunLoopBeforeSources 和 kCFRunLoopAfterWaiting ，也就是要触发 Source0 回调和接收 mach_port 消息两个状态。



