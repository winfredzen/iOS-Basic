# ARC&内存管理

在程序中经常会遇到循环应用的问题，导致`deinit`方便不调用

这里涉及方面有：

+ ARC，自动引用计数 - 可参考[自动引用计数](https://www.cnswift.org/automatic-reference-counting)
+ 闭包 - 可参考[闭包](https://www.cnswift.org/closures)

可参考的文章：

+ [ARC and Memory Management in Swif](https://www.raywenderlich.com/966538-arc-and-memory-management-in-swift)

## 循环引用

如何解决循环引用？

**可通过弱引用(`weak`)或者无主引用(`unowned`)来解决**

使用原则是：对于生命周期中会变为 `nil` 的实例使用弱引用。相反，对于初始化赋值后再也不会被赋值为 `nil` 的实例，使用无主引用

![区别](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/12.png) 

### 弱引用

弱引用声明的都是**可选类型**，原因是：ARC 会在被引用的实例被释放是自动地设置弱引用为 `nil`

如下的例子，`Apartment` 的 `tenant` 属性被声明为弱引用：

```swift
class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}
 
class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var tenant: Person?
    deinit { print("Apartment \(unit) is being deinitialized") }
}
```



### 无主引用

与弱引用不同的是，无主引用假定是**永远有值**的。因此，无主引用总是被定义为**非可选类型**

官方文档中的例子是，`Customer` 和 `CreditCard` ，模拟了银行客户和客户的信用卡

一个客户可能有或者没有信用卡，但是一张信用卡总是关联着一个客户。为了表示这种关系， `Customer` 类有一个可选类型的 `card` 属性，但是 `CreditCard` 类有一个非可选类型的 `customer` 属性

```swift
class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}
 
class CreditCard {
    let number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}
```

### 闭包的循环引用

使用捕获列表来解决闭包和类实例之间的循环强引用

捕获列表可参考[捕获列表](https://www.cnswift.org/expressions#spl-10)

官方的例子：

```swift
class HTMLElement {
    
    let name: String
    let text: String?
    
    lazy var asHTML: () -> String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
    
}
```

捕获列表是 `[unowned self]` ，表示“用无主引用而不是强引用来捕获 `self` ”



####捕获列表

作用：默认情况下，闭包表达式会使用**强引用**捕捉它所在的环境范围内的常量和变量。你可以**使用捕获列表来显式地控制闭包如何捕获值**

必须使用in关键字，即使你省略了参数名，参数类型和返回值类型

捕获为值类型，如下的例子，`a` 在捕获列表中但是 `b` 不在，所以有不同的行为：

```swift
var a = 0
var b = 0
let closure = { [a] in
    print(a, b)
}
 
a = 10
b = 10
closure()
// Prints "0 10"
```

>在一在闭包范围内，这有两个 a ，但是只有一个变量名字叫 b 。在闭包创建的时候会用闭包范围外的 a 的值初始化闭包范围内的 a ，但是他们毫无联系。这意思就是改变一个 a 的值不会影响到另一个 a 的值，相比之下，闭包范围内外 b 都是同一个变量，在闭包范围内外改变值，改变的都是同一个。

捕获为引用类型，如下的例子：

```swift
class SimpleClass {
    var value: Int = 0
}
var x = SimpleClass()
var y = SimpleClass()
let closure = { [x] in
    print(x.value, y.value)
}
 
x.value = 10
y.value = 10
closure()
// Prints "10 10"
```

> 代码中有两个变量 x ，一个常量在闭包内，一个变量在外，但是它们引用的是同一个对象因为是引用语义

如果表达式的类型是类，你可以在捕获列表达式使用 `weak` 和 `unowned` 修饰它，闭包会用弱引用和无主引用来获取表达式的值

```swift
myFunction { print(self.title) }                    // strong capture
myFunction { [weak self] in print(self!.title) }    // weak capture
myFunction { [unowned self] in print(self.title) }  // unowned capture
```

你可以在捕获列表中将任意表达式的值绑定到捕获列表。当闭包创建的时候表达式就会计算，并且会按照指定的类型捕获。例如：

```
// Weak capture of "self.parent" as "parent"
myFunction { [weak parent = self.parent] in print(parent!.title) }
```

## 其它

在[ARC and Memory Management in Swift](https://www.raywenderlich.com/959-arc-and-memory-management-in-swift)一文中，还讲到了如下的内容

在Swift中有如下的2种类型，如：

+ 值类型，如结构体和枚举
+ 引用类型，如类

它们的不同点是，值类型被传递时是复制的，而引用类型是共享被引用的信息的

那是否意味着值类型是不会发生循环引用的？的确如此，值类型不会有循环引用的问题

如下定义代码：

```swift
struct Node { // Error
    var payload = 0
    var next: Node? = nil
}
```

编译器会提示错误：

```
MemoryManagement.playground:128:9: note: cycle beginning here: Node? -> (some: Node)
    var next: Node? = nil
        ^
```

一个`struct`(值类型)是不能递归使用or使用它自身的实例，否则，`struct`的size是无限的。改成如下的形式：

```swift
class Node {
  var payload = 0
  var next: Node? = nil
}
```

对类来说，引用自身不是什么问题

但如果有如下的代码：

```swift
class Person {
  var name: String
  var friends: [Person] = []
  init(name: String) {
    self.name = name
    print("New person instance: \(name)")
  }
  
  deinit {
    print("Person instance \(name) is being deallocated")
  }
}

do {
  let ernie = Person(name: "Ernie")
  let bert = Person(name: "Bert")
  
  ernie.friends.append(bert) // Not deallocated
  bert.friends.append(ernie) // Not deallocated
}
```

> `ernie` and `bert` stay alive by keeping a reference to each other in their `friends`array, although the array itself is a value type. Make the array `unowned`; Xcode will show an error: `unowned` only applies to class types.
>
> 在friends数组中，`ernie`与`bert`相互引用。虽然array是值类型，但如果使array为`unowned`，Xcode会报错：`unowned`只能用于类类型

为打破这种循环，需创建一个泛型的包裹对象(generic wrapper object)，使用它把实例添加到数组中

添加如下的定义，使用了泛型：

```swift
class Unowned<T: AnyObject> {
  unowned var value: T
  init (_ value: T) {
    self.value = value
  }
}
```

修改`Person`类中`friends`的属性：

```swift
var friends: [Unowned<Person>] = []
```

添加friends时，使用如下的方式：

```swift
do {
  let ernie = Person(name: "Ernie")
  let bert = Person(name: "Bert")
  
  ernie.friends.append(Unowned(bert))
  bert.friends.append(Unowned(ernie))
}
```

此时`ernie` 和 `bert` 就可以销毁了



















