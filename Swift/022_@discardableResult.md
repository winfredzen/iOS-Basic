# @discardableResult

参考：

+ [How to ignore return values using @discardableResult](<https://www.hackingwithswift.com/example-code/language/how-to-ignore-return-values-using-discardableresult>)

使用`@discardableResult`可以忽略返回值

例如，字典有个方法`updateValue()`方法，用来改变key对应的value。如果key存在，就返回原来的value。如果key不存在，就返回nil。

```swift
var scores = ["Sophie": 5, "James": 2]
scores.updateValue(3, forKey: "James")
```

`updateValue()`就是使用`@discardableResult`标记的

在自己的函数中使用`@discardableResult`

```swift
enum LogLevel: String {
    case trace, debug, info, warn, error, fatal
}

func log(_ message: String, level: LogLevel = .info) -> String {
    let logLine = "[\(level)] \(Date()): \(message)"
    print(logLine)
    return logLine
}

log("Hello, world!")

@discardableResult func discardableLog(_ message: String, level: LogLevel = .info) -> String {
    let logLine = "[\(level)] \(Date()): \(message)"
    print(logLine)
    return logLine
}
```

