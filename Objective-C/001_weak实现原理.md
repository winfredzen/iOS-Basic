# weak实现原理

> 原理上来说是需要一张弱引用表，表的数据结构是哈希表，表的 `key` 是对象的内存地址，`value` 是指向该对象的所有弱引用的指针



参考：

+ [iOS底层原理：weak的实现原理](https://juejin.im/post/5e7a322f6fb9a07ca24f79bb)
+ [【iOS】weak的底层实现](https://www.jianshu.com/p/3c5e335341e0)



> weak 关键字的作用是弱引用，所引用对象的计数器不会加1，并在引用对象被释放的时候自动被设置为 nil。
>
> **SideTable**
>
> ```objective-c
> struct SideTable {
>     spinlock_t slock;
>     RefcountMap refcnts;
>     weak_table_t weak_table;
> }
> ```
>
>
> + **spinlock_t slock** : 自旋锁，用于上锁/解锁 SideTable。
>
> + **RefcountMap refcnts** ：用来存储OC对象的引用计数的 `hash表`(仅在未开启isa优化或在isa优化情况下isa_t的引用计数溢出时才会用到)。
>
> + **weak_table_t weak_table** : 存储对象弱引用指针的`hash表`。是OC中weak功能实现的核心数据结构



> **weak的原理在于底层维护了一张weak_table_t结构的hash表，key是所指对象的地址，value是weak指针的地址数组。**
>
> **weak 关键字的作用是弱引用，所引用对象的计数器不会加1，并在引用对象被释放的时候自动被设置为 nil。**
>
> **对象释放时，调用`clearDeallocating`函数根据对象地址获取所有weak指针地址的数组，然后遍历这个数组把其中的数据设为nil，最后把这个entry从weak表中删除，最后清理对象的记录。**

















