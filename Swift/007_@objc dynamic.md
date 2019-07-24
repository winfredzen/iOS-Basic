# @objc、@objcMembers、dynamic

参考：

+ [Swift3、4中的@objc、@objcMembers和dynamic](http://biuer.club/2018/05/08/Swift3%E3%80%814%E4%B8%AD%E7%9A%84-objc%E3%80%81-objcMembers%E5%92%8Cdynamic/)
+ [@OBJC 和 DYNAMIC](https://swifter.tips/objc-dynamic/)
+ [@objc and dynamic](https://swiftunboxed.com/interop/objc-dynamic/)



`@objc` means you want your Swift code (class, method, property, etc.) to be visible from Objective-C.

`dynamic` means you want to use Objective-C dynamic dispatch



参考：[Swift - Swift4新特性介绍3（Substring、swap、@objc）](<http://www.hangge.com/blog/cache/detail_1839.html>)

> **过去的情况（Swift3）**
>
> 1.在项目中如果想把 **Swift** 写的 **API** 暴露给 **Objective-C** 调用，需要增加 **@objc**。在 **Swift 3** 中，编译器会在很多地方为我们隐式的加上 **@objc**。
>
> 2.比如当一个类继承于 **NSObject**，那么这个类的所有方法都会被隐式的加上 **@objc**。
>
> ```swift
> class MyClass: NSObject {
>     func print() { } // 包含隐式的 @objc
>     func show() { } // 包含隐式的 @objc
> }
> ```
>
> 3.但这样做很多并不需要暴露给 **Objective-C** 也被加上了 **@objc**。而大量 **@objc** 会导致二进制文件大小的增加
>
> **现在的情况（Swift4）**
>
> 1.在 **Swift 4** 中隐式 **@objc** 自动推断只会发生在下面这种必须要使用 **@objc** 的情况：
>
> + 覆盖父类的 **Objective-C** 方法
>
> + 符合一个 **Objective-C** 的协议

> 2.大多数地方必须手工显示地加上 **@objc**
>
> ```
> class MyClass: NSObject {
>     @objc func print() { } //显示的加上 @objc
>     @objc func show() { } //显示的加上 @objc
> }
> ```
>
> 3.如果在类前加上 **@objcMembers**，那么它、它的子类、扩展里的方法都会隐式的加上 **@objc**
>
> ```swift
> @objcMembers
> class MyClass: NSObject {
>     func print() { } //包含隐式的 @objc
>     func show() { } //包含隐式的 @objc
> }
>  
> extension MyClass {
>     func baz() { } //包含隐式的 @objc
> }
> ```
>
> 4.如果在扩展（**extension**）前加上 **@objc**，那么该扩展里的方法都会隐式的加上 **@objc**
>
> ```swift
> class SwiftClass { }
>  
> @objc extension SwiftClass {
>     func foo() { } //包含隐式的 @objc
>     func bar() { } //包含隐式的 @objc
> }
> ```
>
> 5.如果在扩展（**extension**）前加上 **@nonobjc**，那么该扩展里的方法都不会隐式的加上 **@objc**
>
> ```
> @objcMembers
> class MyClass : NSObject {
>     func wibble() { } //包含隐式的 @objc
> }
>  
> @nonobjc extension MyClass {
>     func wobble() { } //不会包含隐式的 @objc
> }
> ```



**@objc与@objcMembers的区别？**

内容来自:[objc 与 objcMembers 的区别是什么?](http://muhlenxi.com/2018/08/08/objcmembers/)



## 1 - Objective-C 访问 Swift

在 Swift4 中，如果我们想要在 Objective-C 中访问 Swift 文件中声明的属性和方法，我们声明的类只需要继承 NSObject 基类 即可。这种情况下，在 Objective-C 中无法访问该类的属性和调用该类的方法，也就是说在编译成生成的 **项目名-Swift.h** 文件中找不到该类的桥接属性和方法，自然你也无法使用。

- 如果你只想暴露**个别的**属性和方法给 Objective-C 访问和调用，你只需要在要暴露的属性和方法前添加 **@objc** 关键字即可。

举例如下：

```swift
class Person: NSObject{
    /// 只暴露性别属性
    @objc var sex: Int = 0
    var name = "anoymous"
    
    func sayhello() {
        print("I like \(sex)")
    }
    
    @objc func sayByebye() {
        print("Good bye")
    }
}
```

我们看一下生成的 Objective-C 桥接文件：

```swift
SWIFT_CLASS("_TtC11ExAttribute6Person")
@interface Person : NSObject
/// 只暴露性别属性
@property (nonatomic) NSInteger sex;
- (void)sayByebye;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
```

- 如果你想暴露该类的**全部**方法和属性给 Objective-C 访问和调用，你则需要在声明类的时候添加 **@objcMembers** 关键字即可。

举例如下：

```swift
@objcMembers class Boy: NSObject {
    var name: String = ""
    var age = 0
    
    func sayHello() {
        print("Hello, I am \(name). I am \(age) yearsold.")
    }
}
```

同样我们也看一下生成的 Objective-C 桥接文件：

```swift
SWIFT_CLASS("_TtC11ExAttribute3Boy")
@interface Boy : NSObject
@property (nonatomic, copy) NSString * _Nonnull name;
@property (nonatomic) NSInteger age;
- (void)sayHello;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
```

通过以上示例，我们可以得出结论，@objc 与 @objcMembers 的**关键区别**在于暴露给 Objective-C 的属性、方法的范围。如果我们想要保护业务实现的细节，就需要合理的使用 @objc 与 @objcMembers 关键字。



## 2 - Swift 访问 Objective-C

如果我们想要访问 Objective-C 文件中声明的类、属性和方法，我们只需要在 **项目名-Bridging-Header.h** 桥接头文件中导入我们想访问的类即可。

举例如下：

```swift
#import "OCViewController.h"
```