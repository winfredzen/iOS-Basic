# Dictionary

参考：

+ [Dictionary by Example - Swift Programming Language](https://developerinsider.co/dictionary-by-example-swift-programming-language/)
+ [Swift 4.0 中对 Dictionary 的改进](https://swiftcafe.io/post/swift4-dict)



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



**2.初始化**

a.创建空字典

```swift
var emptyDict: [String: String] = [:]
print(emptyDict.isEmpty)

//prints true 
```

b.使用`key-value`对`sequence`创建字典，`init(uniqueKeysWithValues:)`

```swift
let digitWords = ["one", "two", "three", "four", "five"]
let wordToValue = Dictionary(uniqueKeysWithValues: zip(digitWords, 1...5))
print(wordToValue["three"]!)

// Prints 3

print(wordToValue)

// Prints ["three": 3, "four": 4, "five": 5, "one": 1, "two": 2]
```

c. `init(_:uniquingKeysWith:)`，如何处理重复的key

```swift
let pairsWithDuplicateKeys = [("a", 1), ("b", 2), ("a", 3), ("b", 4)]
let firstValues = Dictionary(pairsWithDuplicateKeys, uniquingKeysWith: { (first, _) in first })
let lastValues = Dictionary(pairsWithDuplicateKeys, uniquingKeysWith: { (_, last) in last })
print(firstValues)

//prints ["a": 1, "b": 2]

print(lastValues)

//prints ["a": 3, "b": 4]
```

d.`init(grouping:by:)`, **自动根据 key 分组**

```swift
let students = ["Kofi", "Abena", "Efua", "Kweku", "Akosua"]
let studentsByLetter = Dictionary(grouping: students, by: { $0.first! })
print(studentsByLetter)

//prints ["E": ["Efua"], "K": ["Kofi", "Kweku"], "A": ["Abena", "Akosua"]]
```





























