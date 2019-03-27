# Method Swizzling为什么要先调用class_addMethod

通常Method Swizzling做法如下：

```objective-c
@interface UIViewController (MRCUMAnalytics)

@end

@implementation UIViewController (MRCUMAnalytics)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(mrc_viewWillAppear:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void)mrc_viewWillAppear:(BOOL)animated {
    [self mrc_viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

@end
```

在交换方法之前调用了`class_addMethod`方法

在文章[Objective-C Method Swizzling 的最佳实践](http://blog.leichunfeng.com/blog/2015/06/14/objective-c-method-swizzling-best-practice/)一文中有如下的说明：

> 我们使用 Method Swizzling 的目的通常都是为了给程序增加功能，而不是完全地替换某个功能，所以我们一般都需要在自定义的实现中调用原始的实现。所以这里就会有两种情况需要我们分别进行处理：
>
> **第 1 种情况**：主类本身有实现需要替换的方法，也就是 `class_addMethod` 方法返回 `NO` 。这种情况的处理比较简单，直接交换两个方法的实现就可以了：
>
> ```objective-c
> - (void)viewWillAppear:(BOOL)animated {
>     /// 先调用原始实现，由于主类本身有实现该方法，所以这里实际调用的是主类的实现
>     [self mrc_viewWillAppear:animated];
>     /// 我们增加的功能
>     [MobClick beginLogPageView:NSStringFromClass([self class])];
> }
> 
> - (void)mrc_viewWillAppear:(BOOL)animated {
>     /// 主类的实现
> }
> ```
>
> **第 2 种情况**：主类本身没有实现需要替换的方法，而是继承了父类的实现，即 `class_addMethod`方法返回 `YES` 。这时使用 `class_getInstanceMethod` 函数获取到的 `originalSelector` 指向的就是父类的方法，我们再通过执行 `class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));`将父类的实现替换到我们自定义的 `mrc_viewWillAppear` 方法中。这样就达到了在 `mrc_viewWillAppear` 方法的实现中调用父类实现的目的。
>
> ```objective-c
> - (void)viewWillAppear:(BOOL)animated {
>     /// 先调用原始实现，由于主类本身并没有实现该方法，所以这里实际调用的是父类的实现
>     [self mrc_viewWillAppear:animated];
>     /// 我们增加的功能
>     [MobClick beginLogPageView:NSStringFromClass([self class])];
> }
> 
> - (void)mrc_viewWillAppear:(BOOL)animated {
>     /// 父类的实现
> }
> ```
>
> 





