# Method Swizzling

参考：

+ [Method swizzling的正确姿势](https://www.jianshu.com/p/674bd221aac2)



1.在交换方法前为什么要先`class_addMethod`

如下：

```objective-c
    if (class_addMethod(self, fromSel, method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
         //如果当前类未实现fromSel方法，而是从父类继承过来的方法实现，class_addMethod为YES
        class_replaceMethod(self, toSel, method_getImplementation(fromMethod), method_getTypeEncoding(fromMethod));
    }else{
        //当前类有自己的实现
        method_exchangeImplementations(fromMethod, toMethod);
    }
```

> 这个实现中最关键的一句是class_addMethod这个，因为有好多类没有方法实现，都是从父类中继承来的，如果直接替换，相当于交换了父类这个方法的实现，但这个新的实现是在子类中的，父类的实例调用这个方法时，会崩溃。
>  class_addMethod这句话的作用是如果当前类中没有待交换方法的实现，则把父类中的方法实现添加到当前类中。



参考：

+ [iOS 开发：『Runtime』详解（二）Method Swizzling](https://juejin.im/post/6844903888122822669)
+ [Objc 黑科技 - Method Swizzle 的一些注意事项](https://swiftcafe.io/2016/12/15/swizzle/)



2.如何正确使用Method Swizzling？

> 1.应该只在 `+load` 中执行 Method Swizzling。
>
> 2.Method Swizzling 在 `+load` 中执行时，不要调用 `[super load];`。
>
> 3.Method Swizzling 应该总是在 `dispatch_once` 中执行。
>
> 4.使用 Method Swizzling 后要记得调用原生方法的实现。
>
> 5.避免命名冲突和参数 `_cmd` 被篡改。
>
> 6.谨慎对待 Method Swizzling。





## 一些应用

参考：

+ [iOS开发·runtime原理与实践: 方法交换篇(Method Swizzling)(iOS“黑魔法”，埋点统计，禁止UI控件连续点击，防奔溃处理)](https://juejin.im/post/6844903601681203214)



























