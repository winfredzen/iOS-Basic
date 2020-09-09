# reserveCapacity(_:)

[reserveCapacity(_:)](https://developer.apple.com/documentation/swift/array/1538966-reservecapacity)可以保留足够的空间来存储指定数量的元素。

参考：

+ [Array performance: append() vs reserveCapacity()](https://www.hackingwithswift.com/articles/128/array-performance-append-vs-reservecapacity)
+ [Swift 中的 Array 性能比较: append vs reserveCapacity(译)](https://juejin.im/post/6844903874696839176)



> 如果你往数组中添加很多元素，你可能会发现：使用`reserveCapacity()`函数提前告诉 Swift 你需要多大的长度，代码性能会更好。然而，对它的使用你需要格外小心，因为它也可能使你的代码变得非常非常慢。
>
> 首先，让我们看一下数组的存储策略。如果你创建一个包含四个元素的数组，Swift 将会分配足够的内存去存储这仅有的4个元素。所以，数组的 `count` 和 `capacity` 都是4。
>
> 现在，你想去添加第五个元素。但数组并没有足够的长度去添加它，所以数组需要寻找一块足够存放五个元素的内存，然后将数组的4个元素拷贝过去，最后再拼接第五个元素。它的时间复杂度是O(n)。
>
> 为了避免不断重新分配内存，Swift 对数组的容量采用了一种几何增加模式(a geometric allocation pattern)。这是一种非常好的方式，它成倍的增加数组的容量避免多次重新分配内存的问题。当你在容量为4的数组中添加第五个元素的时候，Swift 将会将数组的长度增加为 8 。每当你超出数组的长度范围，它将会以32、64等成倍的依次增加。
>
> 如果你知道你将要存储512个元素，你可以使用`reserveCapacity()`函数来通知 Swift。然后 Swift 会立刻分配一块可以存储512个元素的内存给数组，而不是创建一个小数组，再多次重新分配内存。
>
> 示例：
>
> ```swift
> var randomNumbers = [Int]()
> randomNumbers.reserveCapacity(512)
> 
> for _ in 1...512 {
>     randomNumbers.append(Int.random(in: 1...10))
> }
> ```
>
> 由于`reserveCapacity()`的时间复杂度也是 O(n) ，所以你应该在数组为空的时候调用它。
>
> 但是这有一个非常重要的点：你需要确定你的数组增长策略比 Swift 的好。记住， Swift 使用几何增长策略，所以调整数组尺寸的次数会随着数组容量的增加而减少，这就意味着它会将时间复杂度平摊为O(1)。