# Hashable

可参考：

+ [Hashable / Hasher](https://nshipster.cn/hashable/)

[Hashable](https://developer.apple.com/documentation/swift/hashable)协议，继承自`Equatable`，在swift中定义如下：

```swift
public protocol Hashable : Equatable {
	var hashValue: Int { get }
	func hash(into hasher: inout Hasher)
}
```

遵循`Hashable`协议的任何类型，可以用在set中或者作为一个字典的key。标准库中的许多类型都遵循`Hashable`协议：Strings, integers, floating-point 和 Boolean 值, 即使 sets 都默认可哈希。其它类型，如optionals、arrays和ranges，在其类型参数实现哈希时，会自动的变成hashable

自定义类型有可以hashable。定义一个枚举，不带关联值，会自动变成可Hashable。可以给自定义添加Hashable，实现`hash(into:)`方法。

> For structs whose stored properties are all `Hashable`, and for enum types that have all-`Hashable`associated values, the compiler is able to provide an implementation of `hash(into:)`automatically.
>
> 存储属性都为Hashable的struct，和关联值都是Hashable的枚举，编译器会自动提供一个`hash(into:)`的实现



## 遵循Hashable协议

> The `Hashable` protocol inherits from the `Equatable` protocol, so you must also satisfy that protocol’s requirements.
>
> Hashable协议继承自Equatable协议，所以也要该协议的要求

官方例子：

```swift
/// A point in an x-y coordinate system.
struct GridPoint {
    var x: Int
    var y: Int
}

extension GridPoint: Hashable {
    static func == (lhs: GridPoint, rhs: GridPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

var tappedPoints: Set = [GridPoint(x: 2, y: 3), GridPoint(x: 4, y: 1)]
let nextTap = GridPoint(x: 0, y: 1)
if tappedPoints.contains(nextTap) {
    print("Already tapped at (\(nextTap.x), \(nextTap.y)).")
} else {
    tappedPoints.insert(nextTap)
    print("New tap detected at (\(nextTap.x), \(nextTap.y)).")
}
// Prints "New tap detected at (0, 1).")
```

