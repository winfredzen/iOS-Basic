# Result枚举

参考：

+ [[译] 如何在 Swift 5 中使用 Result](https://juejin.im/post/5c9586eee51d4536e85c3d60)
+ [The power of Result types in Swift](https://www.swiftbysundell.com/articles/the-power-of-result-types-in-swift/)

在学习Alamofire的源码时，看到如下的代码：

![34](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/34.png)

Result是个枚举，它有两种情况：`success` 和 `failure`。两者都是使用泛型实现的，因此它们可以有您选择的关联值，但 `failure` 必须符合 Swift 的 `Error` 类型

如下所示：

```swift
@frozen public enum Result<Success, Failure> where Failure : Error {
	    /// A success, storing a `Success` value.
    case success(Success)

    /// A failure, storing a `Failure` value.
    case failure(Failure)
  
      /// Creates a new result by evaluating a throwing closure, capturing the
    /// returned value as a success, or any thrown error as a failure.
    ///
    /// - Parameter body: A throwing closure to evaluate.
    public init(catching body: () throws -> Success)
}  
```

其还有一个初始化方法，接受一个闭包，如果闭包成功返回一个值，该值用于 `success` 情况，否则抛出的错误将被放入 `failure` 情况。上面图片中的用法，就是这种情况。例如：

```swift
let result = Result { try String(contentsOfFile: someFile) }
```

