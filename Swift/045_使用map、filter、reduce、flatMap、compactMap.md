# 使用map、filter、reduce、flatMap、compactMap

参考：

+ [Swift Guide to Map Filter Reduce](https://useyourloaf.com/blog/swift-guide-to-map-filter-reduce/)

## `map`

```swift
func map<T>(_ transform: (Element) throws -> T) rethrows -> [T]
```

使用map遍历一个集合，并对集合中的每个元素应用相同的操作。

如我们遍历每个元素，计算其立方值

```swift
let values = [2.0,4.0,5.0,7.0]
var squares: [Double] = []
for value in values {
  squares.append(value*value)
}
```

但这样写起来很冗长，可以直接使用`map`

```swift
let squares2 = values.map {$0 * $0}
// [4.0, 16.0, 25.0, 49.0]
```

上面是简写，如下的是另一种形式，可方便的明白其调用方式：

```swift
let squares3 = values.map({
  (value: Double) -> Double in
  return value * value
})
```

+ 闭包有一个参数`(value: Double)`，返回一个`Double`，Swift可以推断出

+ map只有一个闭包参数，所以不需要`(`和`)`，单行closure可以忽略`return`，所以可以简写成如下的形式

  ```swift
  let squares4 = values.map {value in value * value}
  ```

在省略掉`in`就是上面的形式



返回结果的类型并不限制和源数组一样，如下的例子，将整数转为字符串

```swift
let scores = [0,28,124]
let words = scores.map { NumberFormatter.localizedString(from: $0 as NSNumber, number: .spellOut) }
// ["zero", "twenty-eight", "one hundred twenty-four"]
```



map操作并不局限于**Arrays**，可以在任何**collection**类型处使用。例如`Dictionary`或者`Set`，但结果会是`Array`

```swift
let milesToPoint = ["point1":120.0,"point2":50.0,"point3":70.0]
let kmToPoint = milesToPoint.map { name,miles in miles * 1.6093 }
debugPrint(kmToPoint)//[193.11599999999999, 80.465, 112.651]
```



## **`filter`**

**`filter`**遍历一个collection，返回只包括满足匹配条件的**`Array`**

```swift
let digits = [1,4,10,15]
let even = digits.filter { $0 % 2 == 0 }
// [4, 10]
```

### 

## **`reduce`**

组合集合中所有的item，创建一个新的value

![35](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/35.png)

`reduce`方法有2个参数，一个初始值和一个闭包

例如add the values of an array to an initial value of 10.0

```swift
let items = [2.0,4.0,5.0,7.0]
let total = items.reduce(10.0, +)
// 28.0
```

对字符串可使用`+`操作符来拼接

```swift
let codes = ["abc","def","ghi"]
let text = codes.reduce("", +)
// "abcdefghi"
```

可使用尾随闭包的形式

```swift
let names = ["alan","brian","charlie"]
let csv = names.reduce("===") {text, name in "\(text),\(name)"}
// "===,alan,brian,charlie"
```



## FlatMap and CompactMap

**1. Using `FlatMap` on a sequence with a closure that returns a sequence:**

在sequence上使用`FlatMap`来返回一个sequence

```swift
Sequence.flatMap<S>(_ transform: (Element) -> S)
    -> [S.Element] where S : Sequence
```

```swift
let results = [[5,2,7], [4,8], [9,1,3]]
let allResults = results.flatMap { $0 }
// [5, 2, 7, 4, 8, 9, 1, 3]

let passMarks = results.flatMap { $0.filter { $0 > 5} }
// [7, 8, 9]
```



**2. Using `FlatMap` on an optional:**

在可选上使用`FlatMap`

The closure takes the non-nil value of the optional and returns an optional.

```swift
Optional.flatMap<U>(_ transform: (Wrapped) -> U?) -> U?
```

如果original optional是nil，则返回nil

```swift

let input: Int? = Int("8")
let passMark: Int? = input.flatMap { $0 > 5 ? $0 : nil }
// 8
```



**3. Using `CompactMap` on a sequence with a closure that returns an optional:**

```swift
Sequence.compactMap<U>(_ transform: (Element) -> U?) -> U?
```

Note that this use of `flatMap` was renamed to `compactMap` in Swift 4.1 (Xcode 9.3). It provides a convenient way to strip `nil` values from an array:

提供了一种便利的方法，从array中去掉nil

```swift
let keys: [String?] = ["Tom", nil, "Peter", nil, "Harry"]
let validNames = keys.compactMap { $0 }
validNames
// ["Tom", "Peter", "Harry"]

let counts = keys.compactMap { $0?.count }
counts
// [3, 5, 5]
```



## Chaining

```
let marks = [4,5,8,2,9,7]
let totalPass = marks.filter{$0 >= 7}.reduce(0, +)
// 24
```

```
let numbers = [20,17,35,4,12]
let evenSquares = numbers.filter{$0 % 2 == 0}.map{$0 * $0}
// [400, 16, 144]
```

