# self Self 元类型

在开源代码种经常遇到有使用self Self的情况，记录下学习笔记

参考：

+ [类型](https://www.cnswift.org/types)
+ [理解 Swift 中的元类型：.Type 与 .self](https://juejin.im/post/5bfc0c096fb9a04a027a085b)
+ [接口和类方法中的 SELF](https://swifter.tips/use-self/)

## 元类型

> 元类型指的是所有类型的类型，包括类类型、结构体类型、枚举类型和协议类型
>
> 类、结构体或枚举类型的元类型是类型名字后紧跟 `.Type`  。协议类型的元类型——并不是运行时遵循该协议的具体类型——是的该协议名字紧跟 `.Protocol` 。例如，类类型 `SomeClass` 的元类型就是 `SomeClass.Type` ，协议类型 `SomeProtocol` 的元类型就是 `SomeProtocal.Protocol` 

> 你可以使用后缀 `self` 表达式来获取类型作为一个值。比如说， `SomeClass.self` 返回 `SomeClass` 本身，而不是 `SomeClas` 的一个实例。并且 `SomeProtocol.self`  返回 `SomeProtocol` 本身，而不是运行时遵循 `SomeProtocol` 的某个类型的实例。你可以对类型的实例使用 `dynamicType`  表达式来获取该实例的动态运行时的类型，如下例所示：
>
> ```swift
> class SomeBaseClass {
>     class func printClassName() {
>         print("SomeBaseClass")
>     }
> }
> class SomeSubClass: SomeBaseClass {
>     override class func printClassName() {
>         print("SomeSubClass")
>     }
> }
> let someInstance: SomeBaseClass = SomeSubClass()
> // The compile-time type of someInstance is SomeBaseClass,
> // and the runtime type of someInstance is SomeSubClass
> someInstance.dynamicType.printClassName()
> // Prints "SomeSubClass"
> ```
>
> 可以使用特征运算符( === 和 !== )来测试一个实例的运行时类型和它的编译时类型是否一致。
>
> ```swift
> if someInstance.dynamicType === someInstance.self {
>     print("The dynamic and static type of someInstance are the same")
> } else {
>     print("The dynamic and static type of someInstance are different")
> }
> // Prints "The dynamic and static type of someInstance are different"
> ```
>
> 使用初始化器表达式从类型的元类型的值构造出类型的实例。对于类实例，必须用 `required`  关键字标记被调用的构造器或者使用 `final` 关键字标记整个类。
>
> ```swift
> class AnotherSubClass: SomeBaseClass {
>     let string: String
>     required init(string: String) {
>         self.string = string
>     }
>     override class func printClassName() {
>         print("AnotherSubClass")
>     }
> }
> let metatype: AnotherSubClass.Type = AnotherSubClass.self
> let anotherInstance = metatype.init(string: "some string")
> ```

> Swift 中的元类型用 .Type 表示。比如 Int.Type 就是 Int 的元类型。 类型与值有着不同的形式，就像 Int 与 5 的关系。元类型也是类似，.Type 是类型，类型的 .self 是元类型的值。
>
> ```swift
> let intMetatype: Int.Type = Int.self
> ```
>
> `Int.Type`是类型，`Int.self`是值

## AnyClass

这里的 `AnyClass` 其实就是一个元类型：

```swift
typealias AnyClass = AnyObject.Type
```

`AnyClass` 就是一个任意类型元类型的别名。当我们访问静态变量的时候其实也是通过元类型的访问的，只是 Xcode 帮我们省略了 .self。下面两个写法是等价的。如果可以不引起歧义，我想没人会愿意多写一个 self。

```swift
Int.max
Int.self.max
```



## self

通常的用法是`self.属性`，与oc基本类似

还有种用法就是上面说的，类型的 `.self` 是元类型的值

```swift
let intMetatype: Int.Type = Int.self
```



## Self

> Self 类型不是一个特定的类型，但能让你方便地引用当前类型而不需要重复已知的类型名称。
>
> 在协议声明或者协议成员声明中， Self 类型引用自最终遵循协议的类型。
>
> 在结构体、类或者枚举声明中， Self 类型引用自通过声明引入的类型。在类型成员声明中， Self 类型引用自那个类型。在类成员声明中， Self 可以在方法体内作为方法返回类型，但在其他任何上下文中都不行。比如，下面的代码显示了实例方法 f ，它返回的类型是 Self 。
>
> ```swift
> class Superclass {
>     func f() -> Self { return self }
> }
> let x = Superclass()
> print(type(of: x.f()))
> // Prints "Superclass"
>  
> class Subclass: Superclass { }
> let y = Subclass()
> print(type(of: y.f()))
> // Prints "Subclass"
>  
> let z: Superclass = Subclass()
> print(type(of: z.f()))
> // Prints "Subclass"
> ```
>
> 上面例子的最后一部分显示了 Self 引用自 z 的值的运行时 Subclass ，而不是编译时类型 Superclass 自己的类型。
>
> 在内嵌类型声明中， Self 类型引用自最内层类型声明引入的类型。
>
> Self 类型引用自 Swift 标准库函数 type(of:) 相同的类型。使用 `Self.someStaticMember` 来访问当前类型的成员，与 `type(of: self).someStaticMember` 没区别。

在[Swift中self和Self](https://www.jianshu.com/p/5059d2993509)一文中有如下的描述：

>1.Self可以用于协议(protocol)中限制相关的类型
>2.Self可以用于类(Class)中来充当方法的返回值类型



## type(of:)

[type(of:)](https://developer.apple.com/documentation/swift/2885064-type)返回的是动态类型

> You can use the `type(of:)` function to find the dynamic type of a value, particularly when the dynamic type is different from the static type. The *static type* of a value is the known, compile-time type of the value. The *dynamic type* of a value is the value’s actual type at run-time, which can be a subtype of its concrete type.

具体可参考官方文档例子

**type(of:) vs .self**

> `.self` 取到的是静态的元类型，声明的时候是什么类型就是什么类型。`type(of:)` 取的是运行时候的元类型，也就是这个实例 的类型



## Protocol

`P.Type` vs. `P.Protocol`

参考：

+ [Why can't I pass a Protocol.Type to a generic T.Type parameter?](https://stackoverflow.com/questions/45234233/why-cant-i-pass-a-protocol-type-to-a-generic-t-type-parameter)

> There are two kinds of protocol metatypes. For some protocol `P`, and a conforming type `C`:
>
> - A `P.Protocol` describes the type of a protocol itself (the only value it can hold is `P.self`).
> - A `P.Type` describes a concrete type that conforms to the protocol. It can hold a value of `C.self`, but *not* `P.self` because [protocols don't conform to themselves](https://stackoverflow.com/a/43408193/2976878) (although one exception to this rule is `Any`, as `Any` is the [top type](https://en.wikipedia.org/wiki/Top_type), so any metatype value can be typed as `Any.Type`; including `Any.self`).

































