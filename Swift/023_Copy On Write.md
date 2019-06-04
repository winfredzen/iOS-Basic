# Copy On Write

什么是copy on write？

> Copy on write是用来在copy结构体时，提高表现力的。例如，array中包含1000个元素，你将这个array复制给另一个array。如果到最后时，这两个array的数据还是相同的，swift还是得复制1000次。这样就有点得不偿失。
>
> 所以使用copy on write：当2个变量指向同一个array时，其实指向的底层同样的数据。当修改第二个变量的时候，swift会进行复制，所以第一个变量会保持不变
>
> [What is copy on write?](<https://www.hackingwithswift.com/example-code/language/what-is-copy-on-write>)

在 Swift 标准库中，像是 Array，Dictionary 和 Set 这样的集合类型是通过一种叫做写时复制(copy-on-write) 的技术实现的

```swift
var x = [1,2,3]
var y = x
x.append(5)
y.removeLast()
x // [1, 2, 3, 5]
y // [1, 2]
```

>在内部，这些 Array 结构体含有指向某个内存的引用。这个内存就是数组中元素所存储的位置。
>两个数组的引用指向的是内存中同一个位置，这两个数组共享了它们的存储部分。不过，当我
>们改变 x 的时候，这个共享会被检测到，内存将会被复制。这样一来，我们得以独立地改变两个
>变量。昂贵的元素复制操作只在必要的时候发生，也就是我们改变这两个变量的时候发生复制
>
>这种行为就被称为**写时复制**。它的工作方式是，每当数组被改变，它首先检查它对存储缓冲区
>的引用是否是**唯一的**，或者说，检查数组本身是不是这块缓冲区的唯一拥有者。如果是，那么
>缓冲区可以进行原地变更;也不会有复制被进行。不过，如果缓冲区有一个以上的持有者 (如本
>例中)，那么数组就需要先进行复制，然后对复制的值进行变化，而保持其他的持有者不受影响



如下的例子([Use Copy-On-Write With Swift Value Types](<https://dzone.com/articles/use-copy-on-write-with-swift-value-types-1>))，通过内存地址可发现区别：

```swift
func address(of object: UnsafeRawPointer) -> String {
    let addr = Int(bitPattern: object)
    return String(format: "%p", addr)
}

var array1 = [1, 2, 3, 4]
address(of: array1)     // 0x7ffdc255d370
var array2 = array1
address(of: array2)     // 0x7ffdc255d370
array1.append(2)
address(of: array1)     // 0x7ffdc255db80
address(of: array2)     // 0x7ffdc255d370
```



## 写时复制 **(**高效方式**)**

> 在 Swift 中，我们可以使用 [isKnownUniquelyReferenced](<https://developer.apple.com/documentation/swift/2429905-isknownuniquelyreferenced>) 函数来检查某个引用只有一个持有者。如果你将一个 Swift 类的实例传递给这个函数，并且没有其他变量强引用这个对象的话，函数将返回 true。如果还有其他的强引用，则返回 false。不过，对于Objective-C 的类，它会直接返回 false。

问题常出现在值类型中引用了引用类型，例如struct中包含了引用变量，如在[How to safely use reference types inside value types with isKnownUniquelyReferenced()](<https://www.hackingwithswift.com/example-code/language/how-to-safely-use-reference-types-inside-value-types-with-isknownuniquelyreferenced>)中介绍的：

 `ChatHistory`类

```swift
class ChatHistory: NSCopying {
    var messages: String = "Anonymous"

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ChatHistory()
        copy.messages = messages
        return copy
    }
}
```

结构体User中有

```
class ChatHistory: NSCopying {
    var messages: String = "Anonymous"

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ChatHistory()
        copy.messages = messages
        return copy
    }
}
```

结构体User中有

```
class ChatHistory: NSCopying {
    var messages: String = "Anonymous"

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ChatHistory()
        copy.messages = messages
        return copy
    }
}
```

结构体User中有ChatHistory类型的变量

```swift
struct User {
    var chats = ChatHistory()
}
```

虽然User是值类型，但是里面的`chats`却是引用类型，如下，会输出2次`Goodbye!`

```swift
let twostraws = User()
twostraws.chats.messages = "Hello!"

var taylor = User()
taylor.chats = twostraws.chats

twostraws.chats.messages = "Goodbye!"

print(twostraws.chats.messages) //Goodbye!
print(taylor.chats.messages) //Goodbye!
```



如何修改呢？

1.使用私有属性

2.使用getter/setter，来对私有私有属性进行处理



```swift
struct User {
    private var _chats = ChatHistory()

    var chats: ChatHistory {
        mutating get {
            if !isKnownUniquelyReferenced(&_chats) {
                _chats = _chats.copy() as! ChatHistory
            }

            return _chats
        }

        set {
            _chats = newValue
        }
    }
}
```



即如果`_chats`如果只有一个持有者，就直接返回这个`_chats`。否则的话，返回复制的值



在[Use Copy-On-Write With Swift Value Types](<https://dzone.com/articles/use-copy-on-write-with-swift-value-types-1>)中也有类似的例子：



```swift

final class Ref<T> {
    var value: T
    init(value: T) {
        self.value = value
    }
}
struct Box<T> {
    private var ref: Ref<T>
    init(value: T) {
        ref = Ref(value: value)
    }
    var value: T {
        get { return ref.value }
        set {
            guard isKnownUniquelyReferenced(&ref) else {
                ref = Ref(value: newValue)
                return
            }
            ref.value = newValue
        }
    }
}
```

