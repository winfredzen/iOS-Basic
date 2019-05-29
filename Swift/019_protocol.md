# protocol

1.属性要求定义为变量属性，在名称前面使用 `var` 关键字

参考：[Swift Protocols: Properties distinction(get, get set)🏃🏻‍♀️🏃🏻](<https://medium.com/@chetan15aga/swift-protocols-properties-distinction-get-get-set-32a34a7f16e9>)

+ 协议中属性定义为只读，实现协议中属性可以为任何类型的属性，也可以将其设置为可写的，都没问题
+ 如果协议中属性定义为可读和可写，不能是常量存储属性或者只读计算属性

![020](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/20.png)

![021](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/21.png)



2.协议的类型转换

不强制只有get类型，也可以set

```swift
protocol FullyNamed{
 var firstName: String {get}
 var lastName: String {get set}
}
struct SuperHero: FullyNamed{
 var firstName = “Super”
 var lastName = “Man”
}
var dcHero = SuperHero()
print(dcHero) // SuperHero(firstName: “Super”, lastName: “Man”)
dcHero.firstName = “Bat”
dcHero.lastName = “Girl”
print(dcHero) // SuperHero(firstName: “Bat”, lastName: “Girl”)
```

如果显示的转换，将不允许set

```swift
var anotherDcHero:FullyNamed = SuperHero()
print(anotherDcHero)
anotherDcHero.firstName = “Bat” 
//ERROR: cannot assign to property: ‘firstName’ is a get-only property
anotherDcHero.lastName = “Girl”
print(anotherDcHero)
```



3.协议中的私有属性

+ [协议中的私有属性](https://swift.gg/2019/02/18/protocols-private-properties/)