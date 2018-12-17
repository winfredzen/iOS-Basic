# Range相关

参考文章：

+ [Exploring Range Types in Swift](https://medium.com/@lucianoalmeida1/exploring-range-types-in-swift-e0e7ab27ab79)

## Range

[Range](https://developer.apple.com/documentation/swift/range)官方的解释是：

>A half-open interval from a lower bound up to, but not including, an upper bound.
>
>半开区间，不包含上界值

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
>     print(n)
> }
> // Prints "3"
> // Prints "4"
> ```



## ClosedRange

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



