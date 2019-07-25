# Swift KVC

与KVO一样，kvc的属性要用`@objc`标记，我试了下，如果没有使用`@objc`，会提示错误：

![22](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/22.png)

如下的例子：

```swift
class Person: NSObject {
    
    @objc var firstName: String
    var lastName: String
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
}

let person = Person(firstName: "wang", lastName: "z")

print(person.firstName) //wang
print(person.value(forKey: "firstName") as! String) //wang
```

通过`valueForKey:`获取属性对应的值，需注意的是，返回值是可选类型

通过`setValue(_:, forKey:)`设置属性值

```swift
person.setValue("zhang", forKey: "firstName")
print(person.firstName) //zhang
```



参考：

+ [KVO & KVC In swift](https://hackernoon.com/kvo-kvc-in-swift-12f77300c387)
+ [漫谈 KVC 与 KVO](https://swiftcafe.io/2016/01/03/kvc)

