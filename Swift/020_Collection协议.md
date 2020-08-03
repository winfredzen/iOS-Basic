# Collection协议

[Collection](<https://developer.apple.com/documentation/swift/collection>):

> A sequence whose elements can be traversed multiple times, nondestructively, and accessed by an indexed subscript.
>
> 一个序列，其元素可以被遍历多次，无损，可以通过索引下标访问



> 集合需要具备遍历功能，通过`GeneratorType`（现为`IteratorProtocol`），可以不关心具体元素类型只要不断地用迭代器调用`next`就可以得到全部元素
>
> 但是使用迭代器无法进行多次遍历，这时就需要使用`Sequence`协议来解决这个问题。集合中的forEach、map、flatMap等功能都是使用`Sequence`协议进行多次遍历的
>
> 因为`Sequence`协议无法确定集合里的位置，所以在`Sequence`的基础上增加了`Indexable`协议，`Sequence`协议加上`Indexable`协议就是`Collection`协议
>
> 有了`Collection`协议就可以确定元素的位置了，包括开始位置和结束位置，这样就能够确定哪些元素是可以访问过的，从而避免多次访问一个元素，并且通过一个给定的位置直接找到对应位置的元素
>
> ![36](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/36.png)



Collections在swift的标准库中被广泛使用。除了继承自sequence协议相关方法，还可以获得通过访问集合中特定位置元素的能力

```swift
let text = "Buffalo buffalo buffalo buffalo."
if let firstSpace = text.firstIndex(of: " ") {
    print(text[..<firstSpace])
}
// Prints "Buffalo"
```

**访问单个元素**

可以通过有效的索引下标(除了`endIndex`属性)来访问collection的元素

例如，string中的第一个字符

```swift
let firstChar = text[text.startIndex]
print(firstChar)
// Prints "B"
```

还可以通过`first`属性，访问text的首个字符，如果collection为空，这为`nil`

```swift
print(text.first)
// Prints "Optional("B")"
```

**获取Collection切片**

可通过类似的如`prefix(while:)`或者`suffix(_:)`这样的方法，来获取collection的slice。collection的slice可包含0个或者多个元素

如下的例子，获取string的切片

```swift
let firstWord = text.prefix(while: { $0 != " " })
print(firstWord)
// Prints "Buffalo"
```

也可以通过下标来获取相同的切片

```swift
if let firstSpace = text.firstIndex(of: " ") {
    print(text[..<firstSpace]
    // Prints "Buffalo"
}
```



## 遵循Collection协议

如下的要求：

+ `startIndex` 和 `endIndex` 属性
+ 提供一个subscript，它至少是readonly的，来访问类型元素
+ `index(after:)`方法





















