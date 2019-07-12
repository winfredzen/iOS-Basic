# Error

[Error](<https://developer.apple.com/documentation/swift/error>)在Swift中为一个协议

```swift
public protocol Error {
}

extension Error {
}

extension Error where Self : RawRepresentable, Self.RawValue : FixedWidthInteger {
}
```

表示的是：

> A type representing an error value that can be thrown.



## 使用枚举作为Error

枚举非常适合用来表示简单的错误。创建一个枚举遵循`Error`协议，每个case表示一个可能的error。可使用associated values关联值来表示额外的详细信息

如下的例子，`IntParsingError`枚举，表示将string解析为integer，出现的2种错误

+ overflow - string表示的值太大
+ invalidInput - 非数字字符

```swift
enum IntParsingError: Error {
    case overflow
    case invalidInput(Character)
}
```

下面的例子，在Int的扩展中，来使用：

```swift
extension Int {
    init(validating input: String) throws {
        // ...
        let c = _nextCharacter(from: input)
        if !_isValid(c) {
            throw IntParsingError.invalidInput(c)
        }
        // ...
    }
}
```

当实例化Int时，使用do语句，使用模式匹配来匹配自定义的error，获取关联值

```swift
do {
    let price = try Int(validating: "$100")
} catch IntParsingError.invalidInput(let invalid) {
    print("Invalid character: '\(invalid)'")
} catch IntParsingError.overflow {
    print("Overflow error")
} catch {
    print("Other error")
}
// Prints "Invalid character: '$'"
```



## 在Error中包含更多的数据

有时，你可能希望使用不同的错误状态来包含相同的公共数据，例如文件中的位置或某些应用程序的状态。 此时，可以使用结构Struct来表示Error。 以下示例，在解析XML文档时使用结构来表示错误，包括发生错误的行号和列号：

```swift
struct XMLParsingError: Error {
    enum ErrorKind {
        case invalidCharacter
        case mismatchedTag
        case internalError
    }

    let line: Int
    let column: Int
    let kind: ErrorKind
}

func parse(_ source: String) throws -> XMLDoc {
    // ...
    throw XMLParsingError(line: 19, column: 5, kind: .mismatchedTag)
    // ...
}
```

同样，要捕获错误，使用模式匹配。如下的例子，在 `parse(_:)`方法中捕获`XMLParsingError`错误

```swift
do {
    let xmlDoc = try parse(myXMLData)
} catch let e as XMLParsingError {
    print("Parsing error: \(e.kind) [\(e.line):\(e.column)]")
} catch {
    print("Other error: \(error)")
}
// Prints "Parsing error: mismatchedTag [19:5]"
```





