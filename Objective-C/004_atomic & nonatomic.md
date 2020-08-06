# atomic & nonatomic

## atomic原理

参考：

+ [从源码分析atomic和nonatomic实现原理](https://juejin.im/post/6844903949879738381)

> 操作属性的方法被定义在objc-accessors.mm文件中。
>
> ### setter
>
> 设置atomic属性时调用的是objc_setProperty_atomic方法，然后将方法转发到reallySetProperty中。方法源码如下：
>
> ```objective-c
> void objc_setProperty_atomic(id self, SEL _cmd, id newValue, ptrdiff_t offset)
> {
>     reallySetProperty(self, _cmd, newValue, offset, true, false, false);
> }
> 
> static inline void reallySetProperty(id self, SEL _cmd, id newValue, ptrdiff_t offset, bool atomic, bool copy, bool mutableCopy)
> {
>   	// 偏移量为0，更改isa指针
>     if (offset == 0) {
>         object_setClass(self, newValue);
>         return;
>     }
>     id oldValue;
>     id *slot = (id*) ((char*)self + offset);
> 
>     if (copy) {
>         newValue = [newValue copyWithZone:nil];
>     } else if (mutableCopy) {
>         newValue = [newValue mutableCopyWithZone:nil];
>     } else {
>         if (*slot == newValue) return;
>         newValue = objc_retain(newValue);
>     }
> 
>     if (!atomic) {
>         oldValue = *slot;
>         *slot = newValue;
>     } else {
>       	// 获取锁
>         spinlock_t& slotlock = PropertyLocks[slot];
>         slotlock.lock();
>         oldValue = *slot;
>         *slot = newValue;        
>         slotlock.unlock();
>     }
> 
>     objc_release(oldValue);
> }
> 
> ```
>
> 从源码看逻辑非常容易理解，在进行值的设置时，根据对象地址从全局的哈希表中取出spinlock_t类型的锁。spinlock_t是一个C++类，内部使用的是os_unfair_lock锁来保证线程访问安全。os_unfair_lock是用来替代OSSpinLock的锁，它是一个自旋锁，解决了优先级反转问题。
>
> nonatomic走的是不加锁逻辑。
>
> ### getter
>
> 源码如下:
>
> ```objective-c
> id objc_getProperty(id self, SEL _cmd, ptrdiff_t offset, BOOL atomic) {
>     // 偏移量是0,返回当前对象的isa指针
>     if (offset == 0) {
>         return object_getClass(self);
>     }
> 
>     // Retain release world
>     id *slot = (id*) ((char*)self + offset);
>     if (!atomic) return *slot;
>         
>     // Atomic retain release world
>     spinlock_t& slotlock = PropertyLocks[slot];
>     slotlock.lock();
>     id value = objc_retain(*slot);
>     slotlock.unlock();
>     
>     // 为了优化性能，在自旋锁的外部将对象放入自动释放池
>     return objc_autoreleaseReturnValue(value);
> }
> 
> ```
>
> 对atomic属性进行访问时，调用的是objc_getProperty方法，内部也是通过自旋锁来解决多线程问题，出于性能优化考虑，苹果在自旋锁之外将对象放到自动释放池中。
>
> nonatomic走的是不加锁逻辑。
>
> ### 总结
>
> 通过对源码的分析可以知道目前atomic的实现方式并不是通过@synchronized方式实现的，而是采用的更高性能的os_unfair_lock自旋锁来实现。



## atomic与线程安全

参考：

+ [Objective-C 原子属性](http://liuduo.me/2018/02/08/objective-c-atomic/)

> 既然 atomic 能简单的让一个属性的写操作变成线程安全的，为什么几乎不用它？
>
> 下面看一个简单的例子：
>
> ```objective-c
> #import "ViewController.h"
> 
> @interface ViewController ()
> @property (atomic, assign) NSInteger count;
> @end
> 
> @implementation ViewController
> 
> - (void)viewDidLoad {
>     [super viewDidLoad];
>     
>     self.count = 0;
>     
>     NSThread *threadA = [[NSThread alloc] initWithTarget:self selector:@selector(doSomething) object:nil];
>     [threadA start];
>     
>     NSThread *threadB = [[NSThread alloc] initWithTarget:self selector:@selector(doSomething) object:nil];
>     [threadB start];
> }
> 
> - (void)doSomething {
>     for (NSInteger i = 0; i < 10; i++) {
>         [NSThread sleepForTimeInterval:1.0];
>         self.count++;
>         NSLog(@"self.count = %@ %@", @(self.count), [NSThread currentThread]);
>     }
> }
> 
> @end
> ```
>
> 上面代码中，把属性 count 声明为 atomic 的。在 viewDidLoad 中创建了两个线程 threadA 和 threadB，都去执行 doSomething 方法。在 doSomething 方法中，去给 self.count 的值通过每次循环 +1 增加 10 次，然后打印 self.count 的值。为了让异常情况出现的概率提高，加入一句 `[NSThread sleepForTimeInterval:1.0];`。
>
> 运行上面的代码，会发现打印的结果中，最后一条 self.count 的值往往是小于 20 的，在中间的某些打印日志中，会发现有些数字被重复打印的两次。
>
> > ```tex
> > ...
> > 2018-02-07 23:05:08.718744+0800 AtomicDemo[53388:2777211] self.count = 13 <NSThread: 0x600000265f40>{number = 4, name = (null)}
> > 2018-02-07 23:05:08.718791+0800 AtomicDemo[53388:2777210] self.count = 14 <NSThread: 0x600000265f00>{number = 3, name = (null)}
> > 2018-02-07 23:05:09.719374+0800 AtomicDemo[53388:2777210] self.count = 15 <NSThread: 0x600000265f00>{number = 3, name = (null)}
> > 2018-02-07 23:05:09.719374+0800 AtomicDemo[53388:2777211] self.count = 15 <NSThread: 0x600000265f40>{number = 4, name = (null)}
> > 2018-02-07 23:05:10.719673+0800 AtomicDemo[53388:2777211] self.count = 17 <NSThread: 0x600000265f40>{number = 4, name = (null)}
> > 2018-02-07 23:05:10.719673+0800 AtomicDemo[53388:2777210] self.count = 16 <NSThread: 0x600000265f00>{number = 3, name = (null)}
> > ...
> > ```
>
> 上面的结果中 15 出现了两次，这说明在使用 atomic 的情况下，还是出现了资源竞争。



## Effective Objective-C 2.0内容

> atomic 与 nonatomic的区别是什么呢？前面说过，具备atomic特质的获取方法会通过锁定机制来确定其操作的原子性。这也就是说，如果两个线程读写同一个属性，那么不论何时，总能看到有效的属性值。如是不加锁的话（或者说使用nonatomic语义），那么当其中一个线程正在改写某些属性值时，另外一个线程也许突然闯入，把尚未修改好的属性值读取出来。发生这种情况时，线程读到的属性值可能不对

为什么还是大量的使用的nonatomic？

> 在iOS中使用同步锁的开销较大，这会带来性能为题

