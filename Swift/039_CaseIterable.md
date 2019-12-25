# CaseIterable

```swift
public protocol CaseIterable {

    /// A type that can represent a collection of all values of this type.
    associatedtype AllCases : Collection where Self == Self.AllCases.Element

    /// A collection of all values of this type.
    static var allCases: Self.AllCases { get }
}
```

遵循[CaseIterable](https://developer.apple.com/documentation/swift/caseiterable)协议的类型通常是没有关联值的枚举。 使用CaseIterable类型时，可以使用`allCases`属性访问该类型所有case的集合

```swift
enum CompassDirection: CaseIterable {
    case north, south, east, west
}

print("There are \(CompassDirection.allCases.count) directions.")
// Prints "There are 4 directions."
let caseList = CompassDirection.allCases
                               .map({ "\($0)" })
                               .joined(separator: ", ")
// caseList == "north, south, east, west"
```

这里的`allCases`是编译器自动合成的，只对没有关联值的枚举有效

如果你有关联值的枚举，需要自己来实现

```swift
enum Car: CaseIterable {
    static var allCases: [Car] {
        return [.ford, .toyota, .jaguar, .bmw, .porsche(convertible: false), .porsche(convertible: true)]
    }

    case ford, toyota, jaguar, bmw
    case porsche(convertible: Bool)
}
```

当枚举中有case被标记为`unavailable`时，Swift也不能自动合成`allCases`属性，如果你需要`allCases`，也需要自己来实现

```swift
enum Direction: CaseIterable {
    static var allCases: [Direction] {
        return [.north, .south, .east, .west]
    }

    case north, south, east, west

    @available(*, unavailable)
    case all
}
```

参考：

+ [How to list all cases in an enum using CaseIterable](https://www.hackingwithswift.com/example-code/language/how-to-list-all-cases-in-an-enum-using-caseiterable)
+ [Swift 4.2 新特性详解 CaseIterable.allCases](https://www.jianshu.com/p/92b88e4525d1)

