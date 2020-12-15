# Dictionary

**1.默认值**

[subscript(_:default:)](https://developer.apple.com/documentation/swift/dictionary/2894528-subscript)获取对应key的value，如果dictionary不包含对应的key，会获取默认值

```swift
subscript(key: Key, default defaultValue: @autoclosure () -> Value) -> Value { get set }
```

```swift
var responseMessages = [200: "OK",
                        403: "Access forbidden",
                        404: "File not found",
                        500: "Internal server error"]

let httpResponseCodes = [200, 403, 301]
for code in httpResponseCodes {
    let message = responseMessages[code, default: "Unknown response"]
    print("Response \(code): \(message)")
}
// Prints "Response 200: OK"
// Prints "Response 403: Access Forbidden"
// Prints "Response 301: Unknown response"
```


可参考：

+ [Dictionary default values](https://www.hackingwithswift.com/sixty/2/6/dictionary-default-values)
+ [How to specify default values for dictionary keys](https://www.hackingwithswift.com/example-code/language/how-to-specify-default-values-for-dictionary-keys)


```swift
var scores = ["Taylor Swift": 25, "Ed Sheeran": 20]
var adeleScore = scores["Adele Adkins", default: 0]
```
