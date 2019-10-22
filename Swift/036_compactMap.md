# compactMap

[compactMap(_:)](https://developer.apple.com/documentation/swift/sequence/2950916-compactmap)官方文档的解释是：

>Returns an array containing the non-nil results of calling the given transformation with each element of this sequence.
>
>返回转换后的非nil的数组

```swift
let possibleNumbers = ["1", "2", "three", "///4///", "5"]

let mapped: [Int?] = possibleNumbers.map { str in Int(str) }
// [1, 2, nil, nil, 5]

let compactMapped: [Int] = possibleNumbers.compactMap { str in Int(str) }
// [1, 2, 5]
```

参考：

+ [Swift 4.1 迁移小技巧 —— CompactMap](https://juejin.im/post/5abfc462f265da2377198af0)
+ [Swift 4.1 新特性 (2) Sequence.compactMap](https://www.jianshu.com/p/d8c873e4aee8)


## `compactMap` 的由来

在开始之前，先简单介绍一下 `compactMap` 的由来，我们都知道之前 `flatMap` 有两个重载版本，第一个是用来 flat 集合的：

```swift
let arr = [[1, 2, 3], [4, 5]]

let newArr = arr.flatMap { $0 }
// newArr 的值为 [1, 2, 3, 4, 5]
```

第二个是用来 flat 可选值的：

```swift
let arr = [1, 2, 3, nil, nil, 4, 5]

let newArr = arr.flatMap { $0 }
// newArr 的值为 [1, 2, 3, 4, 5]
```


这两个版本虽然都是用来降维的，但第二个版本除了 flat 之外其实还有 filter 的作用，在使用时容易产生歧义，所以社区认为最好把第二个版本重新拆分出来，使用一个新的方法命名，就产生了这个提案 [SE-0187](https://github.com/apple/swift-evolution/blob/master/proposals/0187-introduce-filtermap.md)。

最初这个提案用了 `filterMap` 这个名字，但后来经过讨论，就决定参考了 `Ruby` 的 `Array::compact` 方法，使用 `compactMap` 这个名字。
