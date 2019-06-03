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





