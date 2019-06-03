# Linked List

结点(Node)组成部分：

+ 存储数据元素的数据域
+ 存储直接后继元素的指针域，如果为`nil`，表示list的结尾

Node定义如下：

```swift
public class Node<Value> {
    public var value: Value
    public var next: Node?
    
    init(value: Value, next: Node? = nil) {
        self.value = value
        self.next = next
    }
    
}

extension Node: CustomStringConvertible {
    public var description: String {
        guard let next = next else {
            return "\(value)"
        }
        return "\(value) -> " + String(describing: next) + " "
    }
}
```

`LinkedList`有`tail`和`head`的概念

![015](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%AE%97%E6%B3%95/images/015.png)

## list中添加value

+ `push`: 在list最前面添加node
+ `append`: 在list结尾添加node
+ `insert(after:)`: 在某个node后面添加node

```swift
    public mutating func append(_ value: Value) {
        
        // 如果list为空，将head和tail都更新为新的node
        guard !isEmpty else {
            push(value)
            return
        }
        
        tail!.next = Node(value: value)
        
        tail = tail!.next
    }
    
    //获取指定index的node
    public func node(at index: Int) -> Node<Value>? {
        
        var currentNode = head
        var currentIndex = 0
        
        while currentNode != nil && currentIndex < index {
            currentNode = currentNode!.next
            currentIndex += 1
        }
        
        return currentNode
    }
    
    //忽略返回值，编译器不警告
    @discardableResult
    public mutating func insert(_ value: Value, after node: Node<Value>) -> Node<Value> {
        // 如果是在tail后面添加，则直接append
        guard tail !== node else {
            append(value)
            return tail!
        }
        // 使用value和node.next创建新的node，在node后面插入
        node.next = Node(value: value, next: node.next)
        return node.next!
    }
```





