# NSNotification相关

自己原来写的博客：

+ [iOS通知拾遗](https://blog.csdn.net/u014084081/article/details/78792642)



其它参考：

+ [深入理解iOS NSNotification](https://www.jianshu.com/p/83770200d476)



## 原理

> NSNotificationCenter是中心管理类，实现较复杂。总的来讲在NSNotificationCenter中定义了两个Table，同时为了封装观察者信息，也定义了一个Observation保存观察者信息。**他们的结构体可以简化如下**：
>
> ```objective-c
> typedef struct NCTbl {
>   Observation   *wildcard;  /* 保存既没有没有传入通知名字也没有传入object的通知*/
>  MapTable       nameless;   /*保存没有传入通知名字的通知 */
>  MapTable       named; /*保存传入了通知名字的通知 */
> } NCTable;
> ```
>
> ```objective-c
> typedef struct  Obs {
>   id        observer;   /* 保存接受消息的对象*/
>   SEL       selector;   /* 保存注册通知时传入的SEL*/
>   struct Obs    *next;      /* 保存注册了同一个通知的下一个观察者*/
>   struct NCTbl  *link;  /* 保存改Observation的Table*/
> } Observation;
> ```
>
> 在NSNotificationCenter内部一共保存了两张表。一张用于保存添加观察者的时候传入了NotifcationName的情况;一张用于保存添加观察者的时候没有传入了NotifcationName的情况，下面分两种情况分析。



> 发送通知的流程总体来讲就是根据NotifcationName查找到对应的Observer链表，然后遍历整个链表，给每个Observer结点中保持存的对象及SEL，来像对象发送信息（也即是调用对象的SEL方法）



