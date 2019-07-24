# Swift单例

在OC中一般使用如下的形式创建单例：

```objective-c
@implementation MyManager
+ (id)sharedManager {
    static MyManager * staticInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        staticInstance = [[self alloc] init];
    });
    return staticInstance;
}
@end
```

使用了`dispatch_once_t`，保证实例只能被初始一次

在Swift中如何创建单例呢？

可参考官方文档[Managing a Shared Resource Using a Singleton](https://developer.apple.com/documentation/swift/cocoa_design_patterns/managing_a_shared_resource_using_a_singleton)

创建单例，可以使用static类型属性，即使在多线程访问中，也可以保证只延迟初始化一次

```swift
class Singleton {
    static let sharedInstance = Singleton()
}
```

如果需要在初始化之外执行其它的额外的操作，可以使用闭包

```swift
class Singleton {
    static let sharedInstance: Singleton = {
        let instance = Singleton()
        // setup code
        return instance
    }()
}
```

参考：

+ [What Is a Singleton and How To Create One In Swift](https://cocoacasts.com/what-is-a-singleton-and-how-to-create-one-in-swift)
+ [单例](https://swifter.tips/singleton/)

