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



## list中移除值

+ `pop`: 移除list最前面的node
+ `removeLast`: 移除list最后面的node
+ `remove(at:)`: 移除其它位置的node

```swift
    @discardableResult
    public mutating func pop() -> Value? {
        defer {
            head = head?.next
            if isEmpty {
                tail = nil
            }
        }
        return head?.value
    }
    
    @discardableResult
    public mutating func removeLast() -> Value? {
        // 如果head是nil，return
        guard let head = head else {
            return nil
        }
        // 如果list只有一个node，等同于pop
        guard head.next != nil else {
            return pop()
        }
        // 搜索next node直至current.next为nil，current表示的是最后的node
        var prev = head
        var current = head
        
        while let next = current.next {
            prev = current
            current = next
        }
        
        prev.next = nil
        tail = prev
        return current.value
    }
    
    @discardableResult
    public mutating func remove(after node: Node<Value>) -> Value? {
        defer {
            //如果node.next是tail
            if node.next === tail {
                tail = node
            }
            node.next = node.next?.next
        }
        return node.next?.value
    }
```



## Swift集合

将Linked List变成swift集合，遵循`Collection`协议([020_Collection协议](<https://github.com/winfredzen/iOS-Basic/blob/master/Swift/020_Collection%E5%8D%8F%E8%AE%AE.md>))

```swift
extension LinkedList: Collection {
    
    //遵循Comparable协议，重载==和<
    public struct Index: Comparable {
        
        public var node: Node<Value>?
        
        static public func ==(lhs: Index, rhs: Index) -> Bool {
            switch (lhs.node, rhs.node) {
            case let (left?, right?):
                return left.next === right.next
            case (nil, nil):
                return true
            default:
                return false
            }
        }
        
        static public func <(lhs: Index, rhs: Index) -> Bool {
            guard lhs != rhs else {
                return false
            }
            let nodes = sequence(first: lhs.node) { $0?.next }
            return nodes.contains { $0 === rhs.node }
        }
        
    }
    
    // 开始索引
    public var startIndex: Index {
        return Index(node: head)
    }
    // lastIndex是最后element后面的index
    public var endIndex: Index {
        return Index(node: tail?.next)
    }
    // i后面的索引
    public func index(after i: Index) -> Index {
        return Index(node: i.node?.next)
    }
    // 获取node的值
    public subscript(position: Index) -> Value {
        return position.node!.value
    }
    
}
```

做如下的测试：

```swift
var list = LinkedList<Int>()
for i in 0...9 {
    list.append(i)
}

print("List: \(list)")
print("First element: \(list[list.startIndex])")
print("Array containing first 3 elements: \(Array(list.prefix(3)))")
print("Array containing last 3 elements: \(Array(list.suffix(3)))")

let sum = list.reduce(0, +)
print("Sum of all values: \(sum)")
```

输出结果如下：

```xml
List: 0 -> 1 -> 2 -> 3 -> 4 -> 5 -> 6 -> 7 -> 8 -> 9         
First element: 0
Array containing first 3 elements: [0, 1, 2]
Array containing last 3 elements: [7, 8, 9]
Sum of all values: 45
```



**值类型语义和copy-on-write**

大概的意思就是复制，不是引用，如对array的处理：

```swift
	let array1 = [1, 2]
  var array2 = array1
  
  print("array1: \(array1)")
  print("array2: \(array2)")
  
  print("---After adding 3 to array 2---")
  array2.append(3)
  print("array1: \(array1)")
  print("array2: \(array2)")
```

输出结果为：

```xml
---Example of array cow---
array1: [1, 2]
array2: [1, 2]
---After adding 3 to array 2---
array1: [1, 2]
array2: [1, 2, 3]
```

当array2修改是，array1不变化



看下当前的`LinkedList`

```swift
	var list1 = LinkedList<Int>()
  list1.append(1)
  list1.append(2)
  var list2 = list1
  print("List1: \(list1)")
  print("List2: \(list2)")
  
  print("After appending 3 to list2")
  list2.append(3)
  print("List1: \(list1)")
  print("List2: \(list2)")
```

```xml
---Example of linked list cow---
List1: 1 -> 2
List2: 1 -> 2
After appending 3 to list2
List1: 1 -> 2 -> 3
List2: 1 -> 2 -> 3
```

并不是值类型的语法，原因是底层使用的Node是引用类型。但当前的LinkedList是个struct，应该是值类型的