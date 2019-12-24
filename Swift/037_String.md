# String

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

















