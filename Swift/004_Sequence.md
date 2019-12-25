# Sequence

参考文档：

+ [Swift 中的 Sequence（一）](<http://liuduo.me/2017/05/26/sequence_base/>)

[Sequence](<https://developer.apple.com/documentation/swift/sequence>)表示的是：

> A type that provides sequential, iterated access to its elements.
>
> 一种提供对其元素进行顺序迭代访问的类型

声明如下：

```swift
protocol Sequence
```

一个sequence就是一个值列表，可以一次单步执行一个值。迭代元素最常用的方法使用`for-in`循环

```swift
let oneTwoThree = 1...3
for number in oneTwoThree {
    print(number)
}
// Prints "1"
// Prints "2"
// Prints "3"
```

可起来很简单，但是这种功能可以让你在任何sequence上执行许多的操作。如，检查sequence是否包含特定的值

>The `Sequence` protocol makes no requirement on conforming types regarding whether they will be destructively consumed by iteration. 
>
> `Sequence` 协议对遵循协议的类型是否被遍历损坏没有要求
>
> As a consequence, don’t assume that multiple `for`-`in` loops on a sequence will either resume iteration or restart from the beginning
>
>~~不要假设sequence 的  `for`-`in` 循环将重新开始 或者 从头开始~~
>
>```swift
>for element in sequence {
>    if ... some condition { break }
>}
>
>for element in sequence {
>    // No defined behavior
>}
>```
>
>我的理解是，第一个for-in循环在某种条件下，中断了，第二个for-in循环，不会从头开始遍历(重新遍历)
>
> A conforming sequence that is not a collection is allowed to produce an arbitrary sequence of elements in the second `for`-`in` loop.
>
>sequence不是collection，在第二个循环中，可能会产生任意序列的元素?
>
>To establish that a type you’ve created supports nondestructive iteration, add conformance to the `Collection` protocol.
>
>如果要支持无损遍历，要遵循`Collection`协议

这里只是我自己的理解，可参考[Swift中Collection的Protocol](<https://mikefighting.github.io/2017/07/28/note-advance-swift-collection-protocols/>)

参考[关于序列和集合需要知道的二三事](<https://academy.realm.io/cn/posts/try-swift-soroush-khanlou-sequence-collection/>)

> 序列是一个记录了一组元素的列表。它有两个重要的特性：**第一**，它的容量可以有限也可无限；**第二**，只可以迭代 (iterate) 一次。
>
> ```swift
> protocol Sequence {
>     associatedtype Iterator: IteratorProtocol
>     func makeIterator() -> Iterator
> }
> ```
>
> 2个部分组成：
>
> + 一个关联类型 (associated type)，遵循**IteratorProtocol** 协议
> + 一个函数，用来构建`Iterator`



## IteratorProtocol

[IteratorProtocol](<https://developer.apple.com/documentation/swift/iteratorprotocol>)声明：

```swift
protocol IteratorProtcol {
    associatedtype Element
    mutating func next() -> Element?
}
```

`Sequence` 协议是基于 `IteratorProtocol` 构建的

其中仅声明了一个 `next()` 方法，用来返回 Sequence 中的下一个元素，或者当没有下一个元素时返回 `nil`

例如，实现一个斐波那契数列

```swift
struct FibsIterator: IteratorProtocol {
    var state = (0, 1)
    mutating func next() -> Int? {
        let upcomingNumber = state.0
        state = (state.1, state.0 + state.1)
        return upcomingNumber
    }
}
```



## 遵循Sequence协议

使自己的自定义类型遵循Sequence可以实现许多有用的操作，例如for-in循环和contains方法。在自定义类型中遵循Sequence，需要添加 `makeIterator()` 方法，并返回一个`iterator`

另一种方式是，自己的类型充当其iterator，实现`IteratorProtocol`协议的要求，同时声明遵循`IteratorProtocol`和`Sequence`协议

如下的例子，一个倒计时Countdown序列

```swift
struct Countdown: Sequence, IteratorProtocol {
    var count: Int

    mutating func next() -> Int? {
        if count == 0 {
            return nil
        } else {
            defer { count -= 1 }
            return count
        }
    }
}

let threeToGo = Countdown(count: 3)
for i in threeToGo {
    print(i)
}
// Prints "3"
// Prints "2"
// Prints "1"
```









