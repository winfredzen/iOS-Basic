# ExpressibleByArrayLiteral协议

[ExpressibleByArrayLiteral](<https://developer.apple.com/documentation/swift/expressiblebyarrayliteral>):

> A type that can be initialized using an array literal.
>
> 表示的是一个类型可使用数组字面量进行初始化

数组字面量值得是一种简单的方式来表示值的列表，使用方括号，逗号分隔

Arrays, sets, 和 option sets 都遵循`ExpressibleByArrayLiteral`，如下的形式：

```swift
let employeesSet: Set<String> = ["Amir", "Jihye", "Dave", "Alessia", "Dave"]
print(employeesSet)
// Prints "["Amir", "Dave", "Jihye", "Alessia"]"

let employeesArray: [String] = ["Amir", "Jihye", "Dave", "Alessia", "Dave"]
print(employeesArray)
// Prints "["Amir", "Jihye", "Dave", "Alessia", "Dave"]"
```

**遵循ExpressibleByArrayLiteral协议**

需声明一个`init(arrayLiteral:)`初始化方法

如下的例子：

```swift
struct Sentence {
    let words: [String]
}

extension Sentence: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: String...) {
        self = Sentence(words: elements)
    }
}
```

就可以使用字面量来初始化`Sentence`

```swift
let sentence: Sentence = ["A", "B", "C"]
print(sentence) // prints 'Sentence(words: ["A", "B", "C"])'
```

但需要注意的是：

> *An array type and an array literal are different things. This means that you can’t initialize a type that conforms to ExpressibleByArrayLiteral by assigning an existing array to it.*

```swift
let words = ["A", "B", "C"]
let anotherSentence: Sentence = words // error: Cannot convert value of type '[String]' to specified type 'Sentence'
```

参考：

+ [Using Initialization with Literals to Design Richer AP](<http://www.vadimbulavin.com/initialization-with-literals/>)

