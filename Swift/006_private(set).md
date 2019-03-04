# private(set)

在项目中有看到使用`private(set)`的形式，表示的是变量的set方法是private

一般用于：set方法私有，get方法公开的场景

参考：[SWIFT: Public getter and Private setter](https://medium.com/@fahad_29644/swift-public-getter-and-private-setter-d115c5598242)

例如，使`Person`的`dream`属性的get方法公开，set方法私有，以前的做法是：

```swift
class Person {
    
    private var name : String
    private var dream : String
    
    init(name: String, dream: String) {
        self.name = name
        self.dream = dream
    }

    func getDream() -> String {
        return dream
    }
    
}

let person = Person(name: "wz", dream: "Money")
person.getDream()
```

而使用`private(set)`的形式如下，使用起来更简洁

```swift
class Person {
    
    private(set) var name : String
    private(set) var dream : String
    
    init(name: String, dream: String) {
        self.name = name
        self.dream = dream
    }
}

let person = Person(name: "wz", dream: "Money")
person.dream
```

