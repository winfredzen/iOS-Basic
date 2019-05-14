# Range相关

参考文章：

+ [Exploring Range Types in Swift](https://medium.com/@lucianoalmeida1/exploring-range-types-in-swift-e0e7ab27ab79)
+ [How To Create Range in Swift?](https://stackoverflow.com/questions/30093688/how-to-create-range-in-swift)
+ [Swift 中的 Range](https://segmentfault.com/a/1190000017120671)



## Closed Ranges: `a...b`

闭区间

### ClosedRange

[ClosedRange](https://developer.apple.com/documentation/swift/closedrange)官方的解释是：

> An interval from a lower bound up to, and including, an upper bound.
>
> 闭区间

定义如下

```swift
struct ClosedRange<Bound> where Bound : Comparable
```

例子：

```swift
let throughFive = 0...5

throughFive.contains(3) //true

throughFive.contains(10) //false

throughFive.contains(0) //true

throughFive.contains(5) //true
```

~~`ClosedRange`不是可以`countable`(ie, it does not conform to the Sequence protocol 不遵循Sequence协议)。即意味着不能通过for来循环遍历。~~

### CountableClosedRange

[CountableClosedRange](<https://developer.apple.com/documentation/swift/countableclosedrange>)，声明如下：

```swift
typealias CountableClosedRange<Bound> = ClosedRange<Bound> where Bound : Strideable, Bound.Stride : SignedInteger
```

它可以遍历

```swift
let myRange: CountableClosedRange = 1...3

let myArray = ["a", "b", "c", "d", "e"]
myArray[myRange] // ["b", "c", "d"]

for index in myRange {
    print(myArray[index])
}
```



## Half-Open Ranges: `a..<b`

半开区间

### Range

[Range](https://developer.apple.com/documentation/swift/range)官方的解释是：

> A half-open interval from a lower bound up to, but not including, an upper bound.
>
> 半开区间，不包含上界值

定义如下：

```swift
struct Range<Bound> where Bound : Comparable
```

只要`Bound`遵循`Comparable`协议即可，表示`Int`、`Double`、`Strings`甚至是你自定义的类型都可以

```swift
let range: Range<String> = "dasda"..<"dskldjaks"
let range: Range<Int> = 0..<3
let range: Range<Double> = 1.0..<3.0
```

> When a range uses integers as its lower and upper bounds, or any other type that conforms to the `Strideable` protocol with an integer stride, you can use that range in a `for`-`in` loop or with any sequence or collection method. The elements of the range are the consecutive values from its lower bound up to, but not including, its upper bound.
>
> 当range使用整型值作为其上下边界，或者其它的遵循`Strideable`协议的类型，带有一个整型的stride，则可以在 `for`-`in` 循环中使用or其它的sequence or collection方法
>
> ```swift
> for n in 3..<5 {
>  print(n)
> }
> // Prints "3"
> // Prints "4"
> ```



### CountableRange

[CountableRange](<https://developer.apple.com/documentation/swift/countablerange>)声明如下：

```swift
typealias CountableRange<Bound> = Range<Bound> where Bound : Strideable, Bound.Stride : SignedInteger
```

> Since Swift 4.1, just a typealias for Range<Bound> where Bound conforms to [Strideable](https://developer.apple.com/documentation/swift/strideable) and Bound.Stride conforms to SignedInteger.
>
> 为Range<Bound>的别名



## PartialRangeUpTo

[PartialRangeUpTo](<https://developer.apple.com/documentation/swift/partialrangeupto>)单侧区间，不包含上界值

```swift
struct PartialRangeUpTo<Bound> where Bound : Comparable
```

```swift
let range: PartialRangeUpTo<Int> = ..<5
let array: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
array[range] //[0, 1, 2, 3, 4]
```



## PartialRangeThrough

[PartialRangeThrough](<https://developer.apple.com/documentation/swift/partialrangethrough>)单侧区间，包含上界值

```swift
let range: PartialRangeThrough<Int> = ...5
let array: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
array[range] //[0, 1, 2, 3, 4, 5]
```



## PartialRangeFrom

[PartialRangeFrom](<https://developer.apple.com/documentation/swift/partialrangefrom>)

```swift
let range: PartialRangeFrom<Int> = 5...
let array: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
array[range] //[5, 6, 7, 8, 9]
```



## Contains in Range

> The protocol [RangeExpression](https://developer.apple.com/documentation/swift/rangeexpression), which is one of the protocols that all of these types of ranges conforms to, defines a method called contains that can verify if a value is contained within the range. Also there is the ~= operator that does the same checking
>
>  ~= 操作符可以做包含检测

```swift
let range: Range<Int> = 0..<10

// ~=操作符
range~=8 //true
range~=10 //false

//contains method
range.contains(8) //true
range.contains(10) //false
```



## NSRange 与 Range

参考：

+ [Swift:Range和NSRange问题](<https://www.jianshu.com/p/5eec9260e759>)
+ [How to convert an NSRange to a Swift string index](<https://www.hackingwithswift.com/example-code/language/how-to-convert-an-nsrange-to-a-swift-string-index>)

在某些情况下有遇到NSRange与Range相互转换的问题

例如属性字符串添加attribute

```swift
open func addAttributes(_ attrs: [String : Any] = [:], range: NSRange)
```

这里的range是NSRange，但在获取sub字符串的时候其实是Range

```swift
//其实这时候获取的range类型是Range
let range = attributeStr.string.range(of: "subString")
```

解决方法参考上面的链接



在Swift 4中引入了一种简便的方法，将 `NSRange`转换为`Range`

```swift
let input = "Hello, world"
let range = NSMakeRange(0, 10)
let swiftRange = Range(range, in: input)
```

`Range`转换为 `NSRange`

```swift
let range = NSRange(beforeText.startIndex..., in: beforeText)
```

可以参考：[Swift 4中的新特性(Whatʼs New in Swift 4) 1（String）](<https://juejin.im/post/5a446f8e5188257d167a7d8a>)





