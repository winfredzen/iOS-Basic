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



## where

泛型 `Where` 分句让你能够要求一个关联类型必须遵循指定的协议，或者指定的类型形式参数和关联类型必须相同

```swift
func allItemsMatch<C1: Container, C2: Container>
    (_ someContainer: C1, _ anotherContainer: C2) -> Bool
    where C1.ItemType == C2.ItemType, C1.ItemType: Equatable {
        
        // Check that both containers contain the same number of items.
        if someContainer.count != anotherContainer.count {
            return false
        }
        
        // Check each pair of items to see if they are equivalent.
        for i in 0..<someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }
        
        // All items match, so return true.
        return true
}
```

- C1 必须遵循 Container 协议（写作 `C1: Container` ）；
- C2 也必须遵循 Container 协议（写作 `C2: Container` ）；
- C1 的 ItemType 必须和 C2 的 ItemType 相同（写作 `C1.ItemType == C2.ItemType` ）；
- C1 的 ItemType 必须遵循 Equatable 协议（写作 `C1.ItemType: Equatable` ）



























