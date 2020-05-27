# Swift Property

参考：

+ [Properties](https://docs.swift.org/swift-book/LanguageGuide/Properties.html)



## Computed Properties



### Read-Only Computed Properties

参考：

+ [Computed Properties Explained In Swift](https://learnappmaking.com/computed-property-swift-how-to/)

在某些代码中，有如下的形式的属性：

```swift
  var titleLabelText: String {
    title
  }
```

这种其实就是只读的计算属性

+ 它省略了`get { ··· }`，表示其为只读计算属性
+ 没有`return`声明，参考[Functions With an Implicit Return](https://docs.swift.org/swift-book/LanguageGuide/Functions.html#ID607)

