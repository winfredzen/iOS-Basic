# String

参考：

+ [字符串和字符](https://swiftgg.gitbook.io/swift/swift-jiao-cheng/03_strings_and_characters)

+ [Swift String Cheat Sheet](https://useyourloaf.com/blog/swift-string-cheat-sheet/)



## 初始化

初始化包括从其它类型转换、使用字面量等很多种方式

```swift
var emptyString = ""            // Empty (Mutable) String
let stillEmpty = String()       // Another empty String
let helloWorld = "Hello World!" // String literal

let a = String(true)            // from boolean: "true"
let b: Character = "A"          // Explicit type to create a Character
let c = String(b)               // from character "A"
let d = String(3.14)            // from Double "3.14"
let e = String(1000)            // from Int "1000"
let f = "Result = \(d)"         // Interpolation "Result = 3.14"
let g = "\u{2126}"              // Unicode Ohm sign Ω

// New in Swift 4.2
let hex = String(254, radix: 16, uppercase: true) // "FE"
let octal = String(18, radix: 8) // "22"
```

**创建重复的值**

```swift
let h = String(repeating:"01", count:3) // 010101
```

**从文件中创建string**

```swift
if let txtPath = Bundle.main.path(forResource: "lorem", ofType: "txt") {
  do {
    let lorem = try String(contentsOfFile: txtPath, encoding: .utf8)
  } catch {
    print("Something went wrong")
  }
}
```



## Raw Strings

参考：

+ [How to use raw strings in Swift 5](https://www.hackingwithswift.com/articles/162/how-to-use-raw-strings-in-swift)

在Swift5中允许使用raw strings，使用`#`作为字符串定界符，当使用`#`时，它会影响swift理解字符串中特殊字符的方式：

> `\`不再充当转义字符，`\n`字面意思是反斜杠，接上`n`，而不是换行符，`\(variable)`也不会是字符串插值

```swift
let regularString = "\\Hello \\World"
```

其字符串在控制输出的结果为`\Hello \World`，而：

```swift
let rawString = #"\Hello \World"#
```

输出结果同样为`\Hello \World`，这个字符串使用`#`来开头，表示的就是raw string

也可以在字符串中使用`#`，来标记特殊字符。例如，如果要使用字符串插值，应该使用`\#(variableName) `，而不是`\(variableName)`

```swift
        let name = "Taylor"
        let greeting = #"Hello, \#(name)!"#
        print(greeting)
```

其输出结果为`Hello, Taylor!`

还可以与多行字符串使用，如下：

```swift
let message = #"""
This is rendered as text: \(example).
This uses string interpolation: \#(example).
"""#
```



可以在字符串周围添加上多个`#`符号，以创建更多唯一的字符串定界符，如下，所有的这些创建的都是相同的字符串：

```swift
let zero = "This is a string"
let one = #"This is a string"#
let two = ##"This is a string"##
let three = ###"This is a string"###
let four = ####"This is a string"####
```

为什么有这种情况呢？因为在你的字符串中可能会出现`#`

```swift
        let str = ##"My dog said "woof"#gooddog"##
        print(str)
```

其输出结果为`My dog said "woof"#gooddog`



## 使用Index来遍历

+ startIndex - 表示是第一个element的位置，如果为空的话，则等于endIndex
+ endIndex - 获取最后一个 `Character` 的**后一个位置**的索引

它们都是`String.Index`类型

```swift
let hello = "hello"
let startIndex = hello.startIndex // 0
let endIndex = hello.endIndex     // 5
hello[startIndex]                 // "h"
```

通过调用 `String` 的 `index(before:)` 或 `index(after:)` 方法，可以立即得到前面或后面的一个索引

```swift
hello[hello.index(after: startIndex)] // "e"
hello[hello.index(before: endIndex)]  // "o"
```

通过调用 `index(_:offsetBy:)` 方法来获取对应偏移量的索引

```swift
hello[hello.index(startIndex, offsetBy: 1)]  // "e"
hello[hello.index(endIndex, offsetBy: -4)]   // "e"
```



## 对象的class名字作为字符串

参考：

+ [Get class name of object as string in Swift](https://stackoverflow.com/questions/24494784/get-class-name-of-object-as-string-in-swift)

使用

```swift
String(describing: YourType.self)
```

或者

```swift
String(describing: self)
```

