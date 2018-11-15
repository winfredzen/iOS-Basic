# Any vs AnyObject

参考：

- [What Is AnyObject in Swift](https://cocoacasts.com/what-is-anyobject-in-swift/)
- [What Is Any in Swift](https://cocoacasts.com/what-is-any-in-swift)

Swift 为不确定的类型提供了两种特殊的类型别名：
- AnyObject  可以表示任何类类型的实例。
- Any  可以表示任何类型，包括函数类型。

**AnyObject**

```swift
public typealias AnyObject
//The protocol to which all classes implicitly conform.
```

[AnyObject](https://developer.apple.com/documentation/swift/anyobject)是一个协议，所有的类都隐式遵循

> You use `AnyObject` when you need the flexibility of an untyped object or when you use bridged Objective-C methods and properties that return an untyped result. `AnyObject` can be used as the concrete type for an instance of any class, class type, or class-only protocol.
>
> 用于 class, class type或者 class-only protocol

> The flexible behavior of the `AnyObject` protocol is similar to Objective-C’s `id` type. For this reason, imported Objective-C types frequently use `AnyObject` as the type for properties, method parameters, and return values.

请注意：

>Swift 的 String , Array 和 Dictionary类型是作为**结构体**来实现的，这意味着字符串，数组和字典在它们被赋值到一个新的常量或者变量，亦或者它们本身被传递到一个函数或方法中的时候，其实是传递了拷贝。
>
>--[类和结构体](https://www.cnswift.org/classes-and-structures)
>
>特别之处在于，所有的 `class` 都隐式地实现了这个接口，这也是 `AnyObject` 只适用于 `class` 类型的原因。而在 Swift 中所有的基本类型，包括 `Array` 和 `Dictionary` 这些传统意义上会是 `class`的东西，统统都是 `struct` 类型，并不能由 `AnyObject` 来表示，于是 Apple 提出了一个更为特殊的 `Any`，除了 `class` 以外，它还可以表示包括 `struct` 和 `enum` 在内的所有类型。
>
>--[ANY 和 ANYOBJECT](https://swifter.tips/any-anyobject/)



定义如下的类：

```swift
class Person {

    var first: String = ""
    var last: String = ""

}

let myPerson: AnyObject = Person()
```

虽然编译器可以推断出`myPerson`常量的类型，但声明`myPerson`为`AnyObject`，编译器并不会报错。原因是`Person`类隐式遵循`AnyObject`协议

使用类型转换，将`myPerson`转为`Person`类型：

```swift
class Person {

    var first: String = ""
    var last: String = ""

}

let myPerson: AnyObject = Person()

if let person = myPerson as? Person {
    person.first
    person.last
}
```

> The `AnyObject` protocol is also useful to bridge the gap between Swift and Objective-C. Some Objective-C APIs use the `AnyObject` protocol to provide compatibility with Swift.
>
>  `AnyObject` 在桥接时非常有用



**Any**

> `Any` can represent an instance of any type at all, including function types.

`Any`比`AnyObject`的范围更宽泛

在[Objective-C id as Swift Any](https://developer.apple.com/swift/blog/?id=39)一文中：

> In Swift 3, the `id` type in Objective-C now maps to the `Any` type in Swift, which describes a value of any type, whether a class, enum, struct, or any other Swift type.

> This change improves the compatibility of Swift and Objective-C. Objective-C collections, for example, can hold elements of `Any` type as of Swift 3. This means that Foundation's `NSArray` type can store `String`, `Float`, and `Int` instances.
>
> 这项改变提高了Swift和Objective-C的兼容能力，例如 Foundation中的 `NSArray` 可以存储`String`, `Float`, 和 `Int`实例

