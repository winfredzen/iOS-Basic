# Array

官方文档：

+ [Array](https://developer.apple.com/documentation/swift/array)

Array是个struct

```swift
@frozen struct Array<Element>
```

## 一些初始化

1.使用Range初始化

```swift
let range = 0...4
let arr = Array(0...4)
```

range是个`ClosedRange`类型

