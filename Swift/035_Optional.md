# Optional

在项目中有看到`.none` `.some`相关的用法，如下：

![29](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/29.png)

查了下，发现与[Optional](https://developer.apple.com/documentation/swift/optional)有关

![30](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/30.png)

`Optional`类型是个枚举， `Optional.none`等同于`nil`字面量，`Optional.some(Wrapped)`存储着一个wrapped值

所以如下的形式是等同的：

```swift
let shortForm: Int? = Int("42")
let longForm: Optional<Int> = Int("42")

let number: Int? = Optional.some(42)
let noNumber: Int? = Optional.none
print(noNumber == nil)
// Prints "true"
```



## Nil-Coalescing Operator

使用nil-coalescing operator (`??`) 可以提供默认值

```swift
let defaultImagePath = "/images/default.png"
let heartPath = imagePaths["heart"] ?? defaultImagePath
print(heartPath)
// Prints "/images/default.png"
```

