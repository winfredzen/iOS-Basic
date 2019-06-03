# @objc、dynamic

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

