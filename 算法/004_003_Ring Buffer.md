# Ring Buffer

[Ring Buffer](<https://zh.wikipedia.org/wiki/%E7%92%B0%E5%BD%A2%E7%B7%A9%E8%A1%9D%E5%8D%80>)维基百科的解释：

> **圆形缓冲区**（circular buffer），也称作**圆形队列**（circular queue），**循环缓冲区**（cyclic buffer），**环形缓冲区**（ring buffer），是一种用于表示一个固定尺寸、头尾相连的[缓冲区](https://zh.wikipedia.org/wiki/%E7%BC%93%E5%86%B2%E5%8C%BA)的数据结构，适合缓存[数据流](https://zh.wikipedia.org/w/index.php?title=%E6%95%B0%E6%8D%AE%E6%B5%81&action=edit&redlink=1)。
>
> 圆形缓冲区的一个有用特性是：当一个数据元素被用掉后，其余数据元素不需要移动其存储位置。相反，一个非圆形缓冲区（例如一个普通的队列）在用掉一个数据元素后，其余数据元素需要向前搬移。换句话说，圆形缓冲区适合实现[先进先出](https://zh.wikipedia.org/wiki/%E5%85%88%E9%80%B2%E5%85%88%E5%87%BA)缓冲区，而非圆形缓冲区适合[后进先出](https://zh.wikipedia.org/w/index.php?title=%E5%90%8E%E8%BF%9B%E5%85%88%E5%87%BA&action=edit&redlink=1)缓冲区。

在[swift-algorithm-club](https://github.com/raywenderlich/swift-algorithm-club)一文中对[Ring Buffer](<https://github.com/raywenderlich/swift-algorithm-club/tree/master/Ring%20Buffer>)也有如下的介绍：

Ring Buffer也叫 circular buffer

基于array的队列存在的问题是：添加元素很快**O(1)**，但移除元素时却很慢，**O(n)**。原因是，数组中剩余的元素要进行偏移

一种更高效的方式是使用ring buffer 或者 circular buffer。从概念上讲，这是一种从尾部绕道头部的数组，所以不需要移除任何item，所有的操作都是**O(1)**

原理是这样的，有一个固定大小的array，例如是5：

```swift
[    ,    ,    ,    ,     ]
 r
 w
```

最开始是，array是空的，read(r)和write(w)指针在起始位置

然后在array中添加一些数据，write写入，或者入列(enqueue)，例如数字`123`

```swift
[ 123,    ,    ,    ,     ]
  r
  ---> w
```

每次我们添加数据时，write指针向前移动一步。我们在添加更多的数据：

```swift
[ 123, 456, 789, 666,     ]
  r    
       -------------> w
```

此时，array中只剩一个位置了。现在read读取一些数据，由于w指针在r指针前面，就表示有数据可读。r指针随着读取数据往前移动

```swift
[ 123, 456, 789, 666,     ]
  ---> r              w
```

在读2次：

```swift
[ 123, 456, 789, 666,     ]
       --------> r    w
```

现在再写入数据，入列2个item，`333` 和 `555`

```swift
[ 123, 456, 789, 666, 333 ]
                 r    ---> w
```

此时，w指针已达到array的尾部，没有额外的空间来放`555`。怎么办呢？由于它是一个circular buffer，我们将w指针返回到起始位置，写剩余的数据

```swift
[ 555, 456, 789, 666, 333 ]
  ---> w         r        
```

现在可以继续读取剩余的三个数据 `666`, `333`, 和 `555`

```swift
[ 555, 456, 789, 666, 333 ]
       w         --------> r        
```

当然，在r指针到打buffer结束点时，它也会转到起始位置

```swift
[ 555, 456, 789, 666, 333 ]
       w            
  ---> r
```

现在buffer又空了，read指针已近赶上了write指针



在Swift中实现如下：

```swift
public struct RingBuffer<T> {
  fileprivate var array: [T?]
  fileprivate var readIndex = 0
  fileprivate var writeIndex = 0

  public init(count: Int) {
    array = [T?](repeating: nil, count: count)
  }

  public mutating func write(_ element: T) -> Bool {
    if !isFull {
      array[writeIndex % array.count] = element
      writeIndex += 1
      return true
    } else {
      return false
    }
  }

  public mutating func read() -> T? {
    if !isEmpty {
      let element = array[readIndex % array.count]
      readIndex += 1
      return element
    } else {
      return nil
    }
  }

  fileprivate var availableSpaceForReading: Int {
    return writeIndex - readIndex
  }

  public var isEmpty: Bool {
    return availableSpaceForReading == 0
  }

  fileprivate var availableSpaceForWriting: Int {
    return array.count - availableSpaceForReading
  }

  public var isFull: Bool {
    return availableSpaceForWriting == 0
  }
}
```

