# mutating

如下例子：

![45](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/45.png)

提示`Cannot assign to property: 'self' is immutable`

需要添加`mutating`关键字

```swift
struct Person {
    var name: String
    
    mutating func makeAnonymous() {
        name = "Anonymous"
    }
}
```

此时就可以通过方法修改`struct`的属性了

```swift
var person = Person(name: "Ed")
person.makeAnonymous()
```

但如果将上面的var修改为let，也会提示报错：

![46](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/46.png)



参考：

+ [在实例方法中修改值类型](https://www.cnswift.org/methods#spl-2)

> 结构体和枚举是*值类型*。**默认情况下，值类型属性不能被自身的实例方法修改。**
>
> 总之，如果你需要在特定的方法中修改结构体或者枚举的属性，你可以选择将这个方法*异变*。然后这个方法就可以在方法中异变（嗯，改变）它的属性了，并且任何改变在方法结束的时候都会写入到原始的结构体中。方法同样可以指定一个全新的实例给它隐含的 self属性，并且这个新的实例将会在方法结束的时候替换掉现存的这个实例。
>
> ```swift
> struct Point {
>     var x = 0.0, y = 0.0
>     mutating func moveBy(x deltaX: Double, y deltaY: Double) {
>         x += deltaX
>         y += deltaY
>     }
> }
> var somePoint = Point(x: 1.0, y: 1.0)
> somePoint.moveBy(x: 2.0, y: 3.0)
> print("The point is now at (\(somePoint.x), \(somePoint.y))")
> // prints "The point is now at (3.0, 4.0)"
> ```



**那么对类呢，mutating有作用吗？**

参考：

+ [Swift - mutating关键字的使用](https://www.jianshu.com/p/14cc9d30770a)



```swift
class SimpleClass: ExampleProtocol {
    var simpleDescription: String = "A very simple class"
    var anotherProperty: Int = 110
    // 在 class 中实现带有mutating方法的接口时，不用mutating进行修饰。因为对于class来说，类的成员变量和方法都是透明的，所以不必使用 mutating 来进行修饰
    func adjust() {
        simpleDescription += " Now 100% adjusted"
    }
}
// 打印结果
var a = SimpleClass()
a.adjust()
let aDescription = a.simpleDescription
```









