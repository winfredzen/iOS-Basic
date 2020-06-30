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

![31](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/31.png)



## 一些方法

## max

```swift
@inlinable public func max(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Element?
```

返回序列中的最大值，返回的是可选类型，如官方文档中的例子：

```swift
let heights = [67.5, 65.7, 64.3, 61.1, 58.5, 60.3, 64.9]
let greatestHeight = heights.max()
print(greatestHeight)
// Prints "Optional(67.5)"
```

参考：

+ [Finding an Array’s Minimum and Maximum Values in Swift](https://shapiroadam.com/array-minimum-maximum-value-swift/)





## 遍历

参考：

+ [How to loop over arrays](https://www.hackingwithswift.com/articles/76/how-to-loop-over-arrays)





