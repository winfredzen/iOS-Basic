# keypath

KeyPath - A key path from a specific root type to a specific resulting value type.

```swift
class KeyPath<Root, Value> : PartialKeyPath<Root>
```

Swift官方文档中对keypath的描述，参见：[Key-Path 表达式](https://www.cnswift.org/expressions#Key-Path)

使用形式为`\type name.path`，*type name* 是具体的类型，包括任意泛型形式参数，比如说 `String` 、 `[Int]` 或者 `Set<Int>` 

**1.使用key-path来获取值**

```swift
struct SomeStructure {
    var someValue: Int
}
 
let s = SomeStructure(someValue: 12)
let pathToProperty = \SomeStructure.someValue
 
let value = s[keyPath: pathToProperty]
// value is 12
```

*type name* 在接口可以隐式决定类型时能省略不写。下面的代码使用 `\.someProperty` 来代替 `\SomeClass.someProperty` ：

```swift
class SomeClass: NSObject {
    @objc var someProperty: Int
    init(someProperty: Int) {
        self.someProperty = someProperty
    }
}
 
let c = SomeClass(someProperty: 10)
c.observe(\.someProperty) { object, change in
    // ...
}
```

*path* 可以引用 `self` 来创建身份 key path （ `\.self` ）。身份 key path 会指向整个实例，所以你可以通过它来一次性访问和改变所有存在变量里的数据。比如说：

```swift
var compoundValue = (a: 1, b: 2)
// Equivalent to compoundValue = (a: 10, b: 20)
compoundValue[keyPath: \.self] = (a: 10, b: 20)
```



## 其它

可参考：

+ [SwiftUI 和 Swift 5.1 新特性(3) Key Path Member Lookup](https://juejin.im/post/6844903863951032327)
+ [KeyPath在Swift中的妙用](https://juejin.im/post/6844903717511102472)

















