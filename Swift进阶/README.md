# 内建集合类型

内容来自《Swift进阶》一书，记录学习笔记



## 数组



和标准库中所有集合类型一样，数组是具有**值语义**的，赋值时数组的内容会被复制

```swift
var x = [1, 2, 3]
var y = x
y.append(4) //[1, 2, 3, 4]
x //[1, 2, 3]
```

对比 `NSArray`和`NSMutableArray`

```swift
let a = NSMutableArray(array: [1,2,3]) 
// 我们不想让 b 发⽣改变 
let b: NSArray = a
// 但是事实上它依然能够被 a 影响并改变
a.insert(4, at: 3) 
b // ( 1, 2, 3, 4 )
```

`b`为不可变的`NSArray`，但是它的引用特性并**不能**保证这个数组不会被改变。正确的做法是，赋值时先手动复制：

```swift
let c = NSMutableArray(array: [1,2,3])
let d = c.copy() as! NSArray
c.insert(4, at: 3) //[1, 2, 3, 4]
d //[1, 2, 3]
```

> 创建如此多的复制有可能造成**性能问题**，不过实际上 Swift 标准库中的所有集合类型都使用了“**写时复制**” 这一技术，它能够保证只在必要的时候对数据进行复制。在我们的例子中，直到`y.append` 被调用的之前，`x` 和 `y` 都将共享内部的存储。



### 数组索引

+ `isEmpty` 和 `count`

+  想要迭代数组？`for x in array`

+ 想要迭代除了第一个元素以外的数组其余部分？`for x in array.dropFirst()`

+ 想要迭代除了最后 5 个元素以外的数组？`for x in array.dropLast(5)`

+ 想要列举数组中的元素和对应的下标？`for (num, element) in collection.enumerated()`

  ```swift
  let array = ["Apples", "Peaches", "Plums"]
  
  for (index, item) in array.enumerated() {
      print("Found \(item) at position \(index)")
  }
  ```

  

+ 想要寻找一个指定元素的位置？`if let idx = array.index { someMatchingLogic($0) }`

  ```swift
  let arr = ["a","b","c","a"]
  
  let indexOfA = arr.firstIndex(of: "a") // 0
  let indexOfB = arr.lastIndex(of: "a") // 3
  ```

  

+ 想要对数组中的所有元素进行变形？`array.map { someTransformation($0) }`

+ 想要筛选出符合某个特定标准的元素？`array.filter { someCriteria($0) }`

+ `first` 和 `last` 属性返回一个可选值，当数组为空时，它们返回 `nil`。

+ 如果数组为空时调用 `removeLast`，那么将会导致崩溃；

  ```swift
  var emptyArr: [Int] = []
  emptyArr.removeLast()//error: Execution was interrupted, reason: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, s
  //Fatal error: Can't remove last element from an empty collection: file Swift/RangeReplaceableCollection.swift, line 854
  ```

+  `popLast` 在数组不为空时删除最后一个元素并返回它，在数组为空时，它将不执行任何操作，直接返回 `nil`



### 数组变形

#### Map

在开发中需要经常的对数组进行某些操作，如下计算平方

```swift
let fibs = [0, 1, 1, 2, 3, 5]
var squared: [Int] = []
for fib in fibs {
    squared.append(fib * fib)
}
squared //[0, 1, 1, 4, 9, 25]
```

使用`map`来完成

```swift
let squares = fibs.map { fib in fib * fib }
squares //[0, 1, 1, 4, 9, 25]
```

参考[Sequence.map 的源码实现](https://github.com/apple/swift/blob/swift-5.0-RELEASE/stdlib/public/core/Sequence.swift#L590-L609)，看下源码是如何实现`map`实现的：

```swift
  @inlinable
  public func map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    let initialCapacity = underestimatedCount
    var result = ContiguousArray<T>()
    result.reserveCapacity(initialCapacity)

    var iterator = self.makeIterator()

    // Add elements up to the initial capacity without checking for regrowth.
    for _ in 0..<initialCapacity {
      result.append(try transform(iterator.next()!))
    }
    // Add remaining elements, if any.
    while let element = iterator.next() {
      result.append(try transform(element))
    }
    return Array(result)
  }
```

我们也可以自己实现：

```swift
extension Array {
    func wz_map<T>(_ transform:(Element) -> T) -> [T] {
        var result: [T] = []
        result.reserveCapacity(count)
        for x in self {
            result.append(transform(x))
        }
        return result
    }
}

let results = fibs.wz_map { fib in fib * fib }
results //[0, 1, 1, 4, 9, 25]
```

+ `Element` 是数组中包含的元素类型的占位符
+ `T` 是元素转换之后的类型占位符
+ `T` 的具体类型由调用者传入给`map`的 `transform`方法的返回值类型来决定



在代码中，如果发现，多个地方都有遍历一个数组并做相同或类似的事情时，可以考虑给`Array`写一个扩展

```swift
let array:[Int] = [1, 2, 2, 2, 3, 4, 4]
var result:[[Int]] = array.isEmpty ? [] : [[array[0]]]
for (previous, current) in zip(array, array.dropFirst()) { //循环实现
    if previous == current {
        result[result.endIndex - 1].append(current)
    } else {
        result.append([current])
    }
}
result //[[1], [2, 2, 2], [3], [4, 4]]

//扩展实现
extension Array {
    func wz_split(where condition:(Element, Element) -> Bool) -> [[Element]] {
        var result: [[Element]] = self.isEmpty ? [] : [[self[0]]]
        for (previous, current) in zip(self, self.dropFirst()) {
            if condition(previous, current) {
                result.append([current])
            } else {
                result[result.endIndex - 1].append(current)
            }
        }
        return result
    }
}

let parts = array.wz_split{ $0 != $1 }
parts // [[1], [2, 2, 2], [3], [4, 4]]
let parts2 = array.wz_split(where: !=)
```



> 实现**accumulate** — 累加，和 reduce 类似，不过是将所有元素合并到一个数组中，并保留合并时每一步的值。
>
> ```swift
> extension Array {
>     func accumulate<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) -> Result) -> [Result] {
>         var running = initialResult //创建了一个中间变量来存储每一步的值
>         return map { next in
>             running = nextPartialResult(running, next)
>             return running
>         }
>     }
> }
> [1,2,3,4].accumulate(0, +) // [1, 3, 6, 10]
> ```



#### **filter**

通过组合`map`和`filter`的操作，可以实现许多数组的操作：

```swift
(1..<10).map { $0 * $0 }.flter { $0 % 2 == 0 } // [4, 16, 36, 64]
```

`filter`的可能实现的逻辑：

```swift
extension Array {
    func flter(_ isIncluded: (Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for x in self where isIncluded(x) {
            result.append(x)
        }
        return result
    }
}
```



#### reduce

`map` 和 `filter` 都作用在一个数组上，并产生另一个新的、经过修改的数组。不过有时候，你可能会想把所有元素合并为一个新的单一的值

```swift
let fibs = [0, 1, 1, 2, 3, 5]
var total = 0
for num in fibs {
    total = total + num
}
total
```

使用`reduce`实现：

```swift
let sum = fibs.reduce(0) { total, num in total + num }
```

+ 一个初始值
+ 一个闭包

运算符也是函数，所以我们也可以把上面的例子写成这样：

```swift
fbs.reduce(0, +) // 12
```

`reduce` 的输出值的类型不必和元素的类型相同

```swift
let str = fibs.reduce("") { str, num in str + "\(num)," }
str //"0,1,1,2,3,5,"
```

`reduce`的可能实现：

```swift
extension Array {
    func wz_reduce<Result>(_ initialResult:Result, _ nextPartialResult:(Result, Element) -> Result) -> Result {
        var result = initialResult
        for x in self {
            result = nextPartialResult(result, x)
        }
        return result
    }
}
```

使用 `reduce` 去实现 `map` 和 `filter`

```swift
extension Array { 
  func map2<T>(_ transform: (Element) -> T) -> [T] { 
    return reduce([]) { $0 + [transform($1)] }
  } 
  func flter2(_ isIncluded: (Element) -> Bool) -> [Element] { 
    return reduce([]) { isIncluded($1) ? $0 + [$1] : $0 } } 
}
```

官方文档中定义：

```swift
 @inlinable public func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result
```

`reduce` 还有另外一个版本，它的类型有所不同，接受一个`inout`参数

```swift
@inlinable public func reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (inout Result, Element) throws -> ()) rethrows -> Result
```



#### flatMap

`flatMap` 方法将变换和展平这两个操作合并为一个步骤

```swift
public func flatMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult]
```



####  **forEach**

使用`forEach`进行迭代

```swift
[1, 2, 3].forEach { element in
    print(element)
}
```

注意闭包里面的返回，

```swift
(1..<10).forEach { number in
    print(number)
    if number > 2 { return }
}
```

输出：

```swift
1
2
3
4
5
6
7
8
9
```

> `return` 语句并不会终止循环，它做的仅仅是从闭包中返回，因此在 `forEach` 的实现中会开始下一个循环的迭代

**因为 return 在其中的行为不太明确，我们建议大多数其他情况下不要用 forEach**



#### 数组切片

可以通过下标来获取某个范围中的元素

```swift
let fibsArr = [0, 1, 1, 2, 3, 5]
let slice = fibsArr[1...]
slice //[1, 1, 2, 3, 5]
type(of: slice) //ArraySlice<Int>.Type
```

得到的数据结果为 `ArraySlice`，并不是`Array`

切片类型只是数组的一种**表示方式**，它背后的数据仍然是原来的数组，只不过是用切片的方式来进行表示。因为数组的元素不会被复制，所以创建一个切片的代价是很小的。

![001](https://github.com/winfredzen/iOS-Basic/blob/master/Swift%E8%BF%9B%E9%98%B6/images/001.png)

将切片数组转为数组

```swift
let newArray = Array(slice)
type(of: newArray) // Array<Int>
```

> 需要谨记的是切片和它背后的数组是使用相同的索引来引用元素的。因此，**切片索引不需要从零开始**。例如，在上面我们用 `fibs[1...]` 创建的切片的第一个元素的索引是 `1` ，因此错误地访问`slice[0]` 元素会使我们的程序因越界而崩溃。如果你操作切片的话，我们建议你总是基于`startIndex` 和 `endIndex` 属性做索引计算。



## 字典

字典的返回值是一个**可选值**，当指定的值不存在时，它就返回`nil`

```swift
enum Setting {
    case text(String)
    case int(Int)
    case bool(Bool)
}

let defaultSettings: [String : Setting] = [
    "Airplane Mode" : .bool(false),
    "Name": .text("My iPhone"),
]

let value = defaultSettings["Name"]
type(of: value) //Optional<__lldb_expr_43.Setting>.Type
```

一些方法

+  `removeValue(forKey:)`  - 从字典中移除一个值
+ `updateValue(_:forKey:)` - 更新字典内容

**合并字典**

合并字典，使用如下的方法：

```swift
@inlinable public mutating func merge(_ other: [Key : Value], uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows
```

+ 第一个参数 - 是要进行合并的键值对
+ 第二个参数 - 定义如何合并相同键的两个值的函数

文档中的例子：

```swift
var dictionary = ["a": 1, "b": 2]

// Keeping existing value for key "a":
dictionary.merge(zip(["a", "c"], [3, 4])) { (current, _) in current }
// ["b": 2, "a": 1, "c": 4]

// Taking the new value for key "a":
dictionary.merge(zip(["a", "d"], [5, 6])) { (_, new) in new }
// ["b": 2, "a": 5, "c": 4, "d": 6]
```



```swift
var settings = defaultSettings 
let overriddenSettings: [String:Setting] = ["Name": .text("Jane's iPhone")] 
settings.merge(overriddenSettings, uniquingKeysWith: { $1 }) 
settings // ["Name": Setting.text("Jane\'s iPhone"), "Airplane Mode": Setting.bool(false)]
```

> 在上面的例子中，我们使用了 `{ $1 }` 来作为合并两个值的策略。也就是说，如果某个键同时存在于 `settings` 和 `overriddenSettings` 中时，我们使用 `overriddenSettings` 中的值。



我们还可以从一个 `(Key,Value)` 键值对的序列中构建一个新的字典，使用`init(uniqueKeysWithValues:)`方法：

```swift
init<S>(uniqueKeysWithValues keysAndValues: S) where S : Sequence, S.Element == (MLDataValue.DictionaryType.Key, MLDataValue.DictionaryType.Value)
```

```swift
extension Sequence where Element: Hashable {
    var frequencies: [Element:Int] {
        let frequencyPairs = self.map { ($0, 1) }
        return Dictionary(frequencyPairs, uniquingKeysWith: +)
    }
}
let frequencies = "hello".frequencies // ["o": 1, "h": 1, "e": 1, "l": 2]
frequencies.filter { $0.value > 1 } // ["l": 2]
```

**对字典的值做映射**

`mapValues(_:)`的定义如下：

```swift
func mapValues<T>(_ transform: (Value) throws -> T) rethrows -> Dictionary<Key, T>
```

> Returns a new dictionary containing the keys of this dictionary with the values transformed by the given closure.

```swift
let settingsAsStrings = settings.mapValues {
    setting -> String in
    switch setting {
    case .text(let text): return text
    case .int(let number): return String(number)
    case .bool(let value): return String(value)
    }
}
settingsAsStrings // ["Name": "Jane\'s iPhone", "Airplane Mode": "false"]
```









