# KeyValuePairs

参考：

+ [KeyValuePairs](https://developer.apple.com/documentation/swift/keyvaluepairs)
+ [What are KeyValuePairs?](https://www.hackingwithswift.com/example-code/language/what-are-keyvaluepairs)

```swift
@frozen struct KeyValuePairs<Key, Value>
```

类似于字典，有如下的优势：

+ key不需要遵循**Hashable**协议
+ key可以重复
+ item是有序的



> However, because `KeyValuePairs` doesn’t require its keys to be hashable, you don’t get the fast key look up of a regular dictionary – it’s O(*n*) rather than O(1) if you like Big O notation. Instead, you access them like an array, using numerical indexes.
>
> 然而，由于 `KeyValuePairs` 不要`key`是`hashable`，所以不可以通过key来快速查找。需要使用类似数组的形式

```swift
let recordTimes: KeyValuePairs = ["Florence Griffith-Joyner": 10.49,
                                      "Evelyn Ashford": 10.76,
                                      "Evelyn Ashford": 10.79,
                                      "Marlies Gohr": 10.81]
print(recordTimes.first!)
// Prints "("Florence Griffith-Joyner", 10.49)"
```

```swift
let runner = "Marlies Gohr"
if let index = recordTimes.firstIndex(where: { $0.0 == runner }) {
    let time = recordTimes[index].1
    print("\(runner) set a 100m record of \(time) seconds.")
} else {
    print("\(runner) couldn't be found in the records.")
}
// Prints "Marlies Gohr set a 100m record of 10.81 seconds."
```

