# Collection

[Collection](<https://developer.apple.com/documentation/swift/collection>):

> A sequence whose elements can be traversed multiple times, nondestructively, and accessed by an indexed subscript.
>
> 一个序列，其元素可以被遍历多次，无损，可以通过索引下标访问

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





















