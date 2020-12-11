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



























