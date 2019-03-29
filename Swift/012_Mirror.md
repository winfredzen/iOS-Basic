# Mirror

参考：

+ [Swift 反射 API 及用法](https://swift.gg/2015/11/23/swift-reflection-api-what-you-can-do/)
+ [REFLECTION 和 MIRROR](https://swifter.tips/reflect/)
+ [Swift 中的 Reflection（反射）](https://zhuanlan.zhihu.com/p/33945268)

Swift 的反射机制是基于一个叫 [**Mirror**](https://developer.apple.com/documentation/swift/mirror) 的 `struct` 来实现的。你为具体的 `subject` 创建一个 `Mirror`，然后就可以通过它查询这个对象 `subject` 。

通过`public init(reflecting subject: Any)`方法创建一个Mirror对象，参数是一个Any类型，这是 Swift 中最通用的类型。Swift 中的任何东西至少都是 `Any` 类型的[1](https://swift.gg/2015/11/23/swift-reflection-api-what-you-can-do/#1)。这样一来 `mirror` 就可以兼容 `struct`, `class`, `enum`, `Tuple`, `Array`, `Dictionary`, `set` 等。

通常的使用方式是：

```swift
struct Person {
    let name: String
    let age: Int
}

let xiaoMing = Person(name: "XiaoMing", age: 16)
let r = Mirror(reflecting: xiaoMing) // r 是 MirrorType

print("xiaoMing 是 \(r.displayStyle!)")

print("属性个数:\(r.children.count)")
for i in r.children.startIndex..<r.children.endIndex {
    print("属性名:\(r.children[i].0!)，值:\(r.children[i].1)")
}

// 输出：
// xiaoMing 是 Struct
// 属性个数:2
// 属性名:name，值:XiaoMing
// 属性名:age，值:16
```

常用的属性

1.`public let displayStyle: Mirror.DisplayStyle?`

`displayStyle`表示对象的类型，定义的enum如下：

```swift
    public enum DisplayStyle {

        case `struct`

        case `class`

        case `enum`

        case tuple

        case optional

        case collection

        case dictionary

        case set
    }
```

Swift 标准库中还有很多类型为 `Any` 的东西没有被列举在上面的 `DisplayStyle` `enum` 中。如果试图反射它们中间的某一个又会发生什么呢？比如 `closure`。

```swift
let closure = { (a: Int) -> Int in return a * 2 }
let aMirror = Mirror(reflecting: closure) //nil
```

2.`public let children: Mirror.Children`

表示的是：

>A collection of `Child` elements describing the structure of the reflected subject.
>
>它实际上是一个 `Child` 的集合，而 `Child` 则是一对键值的多元组：

详细的定义如下：

```swift
public typealias Children = AnyCollection<Mirror.Child>
public typealias Child = (label: String?, value: Any)
```

> 每个 Child 都是具有两个元素的多元组，其中第一个是属性名，第二个是这个属性所存储的值。需要特别注意的是，这个值有可能是多个元素组成嵌套的形式 (例如属性值是数组或者字典的话，就是这样的形式)。

可以这样进行遍历：

```swift
for case let (label?, value) in aMirror.children {
    print (label, value)
}
```

3.`public let subjectType: Any.Type`

subjectType表示对象的类型

```swift
print(aMirror.subjectType)
//输出 : Bookmark
print(Mirror(reflecting: 5).subjectType)
//输出 : Int
print(Mirror(reflecting: "test").subjectType)
//输出 : String
print(Mirror(reflecting: NSNull()).subjectType)
//输出 : NSNull
```

4.`public var superclassMirror: Mirror? { get }`

这是我们对象父类的 `mirror`。如果这个对象不是一个类，它会是一个空的 `Optional` 值。如果对象的类型是基于类的，你会得到一个新的 `Mirror`：

```swift
// 试试 struct
print(Mirror(reflecting: aBookmark).superclassMirror())
// 输出: nil
// 试试 class
print(Mirror(reflecting: aBookmark.store).superclassMirror())
// 输出: Optional(Mirror for Store)
```



如果觉得一个个打印太过于麻烦，我们也可以简单地使用 `dump` 方法来通过获取一个对象的镜像并进行标准输出的方式将其输出出来。比如对上面的对象 `xiaoMing`：

```swift
dump(xiaoMing)
// 输出：
// ▿ Person
//  - name: XiaoMing
//  - age: 16
```



## CustomReflectable

参考：[Dynamic Features in Swift](https://www.raywenderlich.com/5743-dynamic-features-in-swift)

> `CustomReflectable` provides the hook with which you can specify what parts of a type instance are shown by using a custom `Mirror`. To conform to `CustomReflectable`, a type must define the `customMirror` property.
>
> ```swift
> extension DogCatcherNet: CustomReflectable {
>   public var customMirror: Mirror {
>     return Mirror(DogCatcherNet.self,
>                   children: ["Customer Review Stars": customerReviewStars,
>                             ],
>                   displayStyle: .class, ancestorRepresentation: .generated)
>   }
> }
> 
> ```
>
> 







