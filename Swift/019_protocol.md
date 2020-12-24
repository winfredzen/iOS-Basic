# protocol

参考：

+ [协议](https://www.cnswift.org/protocols)

同时有父类和协议，将父类名放在协议名之前

```swift
class SomeClass: SomeSuperclass, FirstProtocol, AnotherProtocol {
    // class definition goes here
}
```



## 基本

**类型属性**

```swift
protocol AnotherProtocol {
    static var someTypeProperty: Int { get set }
}
```



### 方法

方法参数不能有默认值

**定义类型方法**

```swift
protocol SomeProtocol {
    static func someTypeMethod()
}
```



#### 异变方法

有时一个方法需要改变（或*异变*）其所属的实例。例如值类型的实例方法（即结构体或枚举），在方法的 `func` 关键字之前使用 `mutating` 关键字，来表示在该方法可以改变其所属的实例，以及该实例的所有属性

**如果你在协议中标记实例方法需求为 `mutating` ，在为类实现该方法的时候不需要写 `mutating` 关键字。 `mutating` 关键字只在结构体和枚举类型中需要书写**



```swift
protocol Togglable {
    mutating func toggle()
}
```



```swift
enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}
var lightSwitch = OnOffSwitch.off
lightSwitch.toggle()
// lightSwitch is now equal to .on
```



#### 初始化器

```swift
protocol SomeProtocol {
    init(someParameter: Int)
}
```

通过实现**指定初始化器**或**便捷初始化器**来使遵循该协议的类满足协议的初始化器要求，必须使用`required`关键字修饰

```swift
class SomeClass: SomeProtocol {
    required init(someParameter: Int) {
        // initializer implementation goes here
    }
}
```



### 委托

如：

```swift
var delegate: DiceGameDelegate?
```



### 类专用的协议

通过添加 AnyObject 关键字到协议的继承列表，你就可以限制协议只能被类类型采纳（并且不是结构体或者枚举）。

```swift
protocol SomeClassOnlyProtocol: AnyObject, SomeInheritedProtocol {
    // class-only protocol definition goes here
}
```



## Other



1.属性要求定义为变量属性，在名称前面使用 `var` 关键字

参考：[Swift Protocols: Properties distinction(get, get set)🏃🏻‍♀️🏃🏻](<https://medium.com/@chetan15aga/swift-protocols-properties-distinction-get-get-set-32a34a7f16e9>)

+ 协议中属性定义为只读，实现协议中属性可以为任何类型的属性，也可以将其设置为可写的，都没问题
+ 如果协议中属性定义为可读和可写，不能是常量存储属性或者只读计算属性

![020](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/20.png)

![021](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/21.png)



2.协议的类型转换

不强制转换，如果声明时只有get方法，set方法也起作用

```swift
protocol FullyNamed{
 var firstName: String {get}
 var lastName: String {get set}
}
struct SuperHero: FullyNamed{
 var firstName = “Super”
 var lastName = “Man”
}
var dcHero = SuperHero()
print(dcHero) // SuperHero(firstName: “Super”, lastName: “Man”)
dcHero.firstName = “Bat”
dcHero.lastName = “Girl”
print(dcHero) // SuperHero(firstName: “Bat”, lastName: “Girl”)
```

如果显式的强制转换，将不允许set

```swift
var anotherDcHero:FullyNamed = SuperHero()
print(anotherDcHero)
anotherDcHero.firstName = “Bat” 
//ERROR: cannot assign to property: ‘firstName’ is a get-only property
anotherDcHero.lastName = “Girl”
print(anotherDcHero)
```



3.协议中的私有属性

+ [协议中的私有属性](https://swift.gg/2019/02/18/protocols-private-properties/)



## 使用中遇到的一些问题

1.提示`Type xxxx doesnt conform to protocol 'NSObjectProtocol'`

例如，我自定义一个类，只遵循`UICollectionViewDataSource`协议

![32](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/32.png)

原因是[Type CCC doesnt conform to protocol 'NSObjectProtocol'](https://stackoverflow.com/questions/34638065/type-ccc-doesnt-conform-to-protocol-nsobjectprotocol)

> If you follow up the inheritance chain, `NSURLSessionDataDelegate` inherits `NSURLSessionTaskDelegate`, which inherits `NSURLSessionDelegate`, which inherits, `NSObjectProtocol`. This protocol has various required methods like `isEqual(_:)` and `respondsToSelector(_:)` which you class does not implement.

所以需要继承自`NSObject`

![33](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/33.png)





















