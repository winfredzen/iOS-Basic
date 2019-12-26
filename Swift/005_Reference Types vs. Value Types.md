# Reference Types vs. Value Types

参考：

+ [Reference vs. Value Types in Swift](https://www.raywenderlich.com/9481-reference-vs-value-types-in-swift)
+ [Value and Reference Types](https://developer.apple.com/swift/blog/?id=10)



在Swift中struct、enum、tuple都为值类型

```swift
struct Cat {
    var wasFed = false
}

var cat = Cat()
var kitty = cat
kitty.wasFed = true

cat.wasFed //false
kitty.wasFed //true
```



参考[Swift Standard Library](https://github.com/apple/swift/tree/master/stdlib/public/core)，可发现`String`,  `Array`, 和 `Dictionary`，都是用`struct`实现的，都是值类型

什么时候使用值类型，什么时候使用引用类型？在Apple的[Value and Reference Types](https://developer.apple.com/swift/blog/?id=10)中，有如下的说明：

如下的时候考虑使用值类型：

+ Comparing instance data with `==` makes sense
+ You want copies to have independent state
+ The data will be used in code across multiple threads

如下的时候考虑使用引用类型：

+ Comparing instance identity with `===` makes sense
+ You want to create shared, mutable state



## 使用值类型

1.**Use a value type when comparing instance data with == makes sense**

```swift
struct Point: CustomStringConvertible {
    var x: Float
    var y: Float
    
    var description: String {
        return "{x: \(x), y: \(y)}"
    }
    
}

let point1 = Point(x: 2, y: 3)
let point2 = Point(x: 2, y: 3)
```

例如，比较2个point，你关系的是内部的值是否是相等的，而不关心它们的内存地址

如下实现`Equatable`协议

```swift
extension Point: Equatable {
    static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

point1 == point2 //true
```



2.**Use a value type when copies should have independent state**

即复制时需要保持独立的状态

```swift
struct Shape {
  var center: Point
}

let initialPoint = Point(x: 0, y: 0)
let circle = Shape(center: initialPoint)
var square = Shape(center: initialPoint)

square.center.x = 5   // {x: 5.0, y: 0.0}
circle.center         // {x: 0.0, y: 0.0}
```

每个`Shape`都有自己的`Point`副本

3.**Use a value type when the code will use this data across multiple threads**

在多线程中使用



## 使用引用类型

1.**Use a reference type when comparing instance identity with === makes sense**

`===`检查2个对象是否完全相同，即存储数据的内存地址是否相同



2.**Use a reference type when you want to create a shared, mutable state**

即共享状态



## Mutability

Mutability可变性

如下的例子：

```swift
class Dog {
  var wasFed = false
}

let dog = Dog()
let puppy = dog
puppy.wasFed = true
```

`puppy`被声明为`let`，但是你可以修改`wasFed`属性

>For reference types, let means the reference must remain constant. In other words, you can’t change the instance the constant references, but you can mutate the instance itself.
>
>对于引用类型，let表示的是reference必须不变。无法改变实例的常量引用，但可以更改实例本身。

> For value types, let means the instance must remain constant. No properties of the instance will ever change, regardless of whether the property is declared with let or var.
>
> 对于值类型，`let`意味着实例必须保持不变。 不管该属性是用`let`还是`var`声明的，实例的属性都不会改变。



## 混合使用

### 引用类型包含值类型的属性

引用类型包含值类型的属性，如下的例子，一般没什么问题：

```swift
struct Address {
  var streetAddress: String
  var city: String
  var state: String
  var postalCode: String
}

class Person {          // Reference type
  var name: String      // Value type
  var address: Address  // Value type

  init(name: String, address: Address) {
    self.name = name
    self.address = address
  }
}

// 1
let kingsLanding = Address(
  streetAddress: "1 King Way",
  city: "Kings Landing",
  state: "Westeros",
  postalCode: "12345")
let madKing = Person(name: "Aerys", address: kingsLanding)
let kingSlayer = Person(name: "Jaime", address: kingsLanding)

// 2
kingSlayer.address.streetAddress = "1 King Way Apt. 1"

// 3
madKing.address.streetAddress  // 1 King Way
kingSlayer.address.streetAddress // 1 King Way Apt. 1
```

### 值类型包含应用类型属性

```swift
struct Address {
    var streetAddress: String
    var city: String
    var state: String
    var postalCode: String
}

class Person {          // Reference type
    var name: String      // Value type
    var address: Address  // Value type
    
    init(name: String, address: Address) {
        self.name = name
        self.address = address
    }
}

struct Bill {
    let amount: Float
    let billedTo: Person
}

```

如上的例子，`Bill`是个值类型，但是`billedTo`属性确是个引用类型，多个`Bill`共享`billedTo`的`Person`对象

```swift
let kingsLanding = Address(
    streetAddress: "1 King Way",
    city: "Kings Landing",
    state: "Westeros",
    postalCode: "12345")

// 1
let billPayer = Person(name: "Robert", address: kingsLanding)

// 2
let bill = Bill(amount: 42.99, billedTo: billPayer)
let bill2 = bill

// 3
billPayer.name = "Bob"

// Inspect values
bill.billedTo.name    // "Bob"
bill2.billedTo.name   // "Bob"
```

如上`Bill`为值类型，其属性`billedTo`却为引用类型，所以在`bill2 = bill`时，并不是完全的复制

可以在Bill中添加一个显式的初始化方法：

```swift
init(amount: Float, billedTo: Person) {
  self.amount = amount
  // Create a new Person reference from the parameter
  self.billedTo = Person(name: billedTo.name, address: billedTo.address)
}
```

此时值为：

```swift
bill.billedTo.name    // "Robert"
bill2.billedTo.name   // "Robert"
```

但还有一个问题是，你可以在外面修改`billedTo`，如下所示：

```swift
bill.billedTo.name = "Bob"

bill.billedTo.name //Bob
bill2.billedTo.name //Bob
```

即虽然`let bill2 = bill`，都是值类型，但是修改`bill`的`billedTo`的`name`属性，造成了`bill2`属性的改变，违背了值类型的规则

所以这里的问题是，即使你的struct是不可变的，但是内部的数据可以被修改

### Copy-on-Write计算属性

如何解决呢？使用`Copy-on-Write`计算属性

1.创建一个私有的变量 `_billedTo` ，指向 `Person`对象

2.创建计算属性 `billedToForRead` 返回私有变量

3.创建计算属性 `billedToForWrite` ，用于写操作



```swift
struct Bill {
    let amount: Float
    private var _billedTo: Person
    
    // 1
    private var billedToForRead: Person {
        return _billedTo
    }
    
    private var billedToForWrite: Person {
        mutating get {
            if !isKnownUniquelyReferenced(&_billedTo) {
                print("Making a copy of _billedTo")
                _billedTo = Person(name: _billedTo.name, address: _billedTo.address)
            } else {
                print("Not making a copy of _billedTo")
            }
            return _billedTo
        }
    }
    
    init(amount: Float, billedTo: Person) {
        self.amount = amount
        _billedTo = Person(name: billedTo.name, address: billedTo.address)
    }
    
    // 2
    mutating func updateBilledToAddress(address: Address) {
        billedToForWrite.address = address
    }
    
    mutating func updateBilledToName(name: String) {
        billedToForWrite.name = name
    }
    
    // ... Methods to read billedToForRead data
}
```

`isKnownUniquelyReferenced(_:)`检查是否有其它的对象引用传入的参数对象



## Advanced Swift: Values and References

Swift中Type的分类，可参考:[Types](<https://docs.swift.org/swift-book/ReferenceManual/Types.html>)

+ named types
  + class
  + struct
  + enum
  + protocol
+ compound types
  + tuple
  + function

struct enum tuple 是值类型，class function是引用类型



### mutating

值类型属性不能被自身的实例方法修改，要使用`mutating`关键字



### inout

inout可以定义一个输入输出形式参数。

> 输入输出形式参数有一个能*输入*给函数的值，函数能对其进行修改，还能*输出*到函数外边替换原来的值



如下的例子，运行结果显示只有一次读和一次写

```swift
struct Tracked<Value>: CustomDebugStringConvertible {
  
  private var _value: Value
  private(set) var readCount = 0
  private(set) var writeCount = 0
  
  init(_ value: Value) {
    self._value = value
  }
  
  var value: Value {
    mutating get {
      readCount += 1
      return _value
    }
    set {
      writeCount += 1
      _value = newValue
    }
  }
  
  mutating func resetCounts() {
    readCount = 0
    writeCount = 0
  }
  
  var debugDescription: String {
    return "\(_value) Reads: \(readCount) Writes: \(writeCount)"
  }
}

func computeNothing(input: inout Int) {
}

func compute100Times(input: inout Int) {
  for _ in 1...100 {
    input += 1
  }
}

var tracked = Tracked(42)
computeNothing(input: &tracked.value)
print("computeNothing", tracked)  // 1 Read and 1 Write for nothing

tracked.resetCounts()

compute100Times(input: &tracked.value)
print("compute100Times", tracked)  // Still only 1 Read and 1 Write
```

控制台输出结果

```xml
computeNothing 42 Reads: 1 Writes: 1
compute100Times 142 Reads: 1 Writes: 1
```

