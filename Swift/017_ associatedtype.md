# associatedtype

在协议中不能使用`<T>`这个泛型，要使用关联类型

> *关联类型*给协议中用到的类型一个占位符名称。直到采纳协议时，才指定用于该关联类型的实际类型。关联类型通过 `associatedtype` 关键字指定

参考：

+ [关联类型](<https://www.cnswift.org/generics#spl-10>)
+ [Swift - 关键字（typealias、associatedtype）](<https://a1049145827.github.io/2018/03/06/Swift-%E5%85%B3%E9%94%AE%E5%AD%97%EF%BC%88typealias%E3%80%81associatedtype%EF%BC%89/>)

```swift
// 模型
struct Model {
    let age: Int
    let name: String
}

// 协议，使用关联类型
protocol TableViewCellProtocol {
    associatedtype T
    func updateCell(_ data: T)
}

// 遵守TableViewCellProtocol
class MyTableViewCell: UITableViewCell, TableViewCellProtocol {
    typealias T = Model
    func updateCell(_ data: Model) {
        // do something ...
    }
}
```

**给关联类型添加约束**

可以在协议里给关联类型添加约束来要求遵循的类型满足约束，例如容器中的元素都是可判等的

```swift
protocol Container {
    associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
```


