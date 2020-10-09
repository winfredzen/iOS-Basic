# JSONDecoder 和 JSONEncoder

[JSONDecoder](https://developer.apple.com/documentation/foundation/jsondecoder)表示：

> An object that decodes instances of a data type from JSON objects.
>
> 从JSON解析实例

例子：

```swift
struct GroceryProduct: Codable{
    
    var name: String
    var points: Int
    var description: String?

}

let json = """
        {
            "name": "Durian",
            "points": 600,
            "description": "A fruit with a distinctive scent."
        }
    """.data(using: String.Encoding.utf8)!

let decoder = JSONDecoder()
let product = try decoder.decode(GroceryProduct.self, from: json)

print(product.name) // Prints "Durian"
```

`Codable`是`Encodable`与`Decodable`协议的别名

```swift
/// `Codable` is a type alias for the `Encodable` and `Decodable` protocols.
/// When you use `Codable` as a type or a generic constraint, it matches
/// any type that conforms to both protocols.
public typealias Codable = Decodable & Encodable
```

`decode(_:from:)`方法原型

```swift
func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
```

`T.Type`表示的是`Metatype Type`元类型

> 元类型指的是所有类型的类型，包括类类型、结构体类型、枚举类型和协议类型
>
> [Metatype Type](https://docs.swift.org/swift-book/ReferenceManual/Types.html#//apple_ref/doc/uid/TP40014097-CH31-ID455)

[JSONEncoder](https://developer.apple.com/documentation/foundation/jsonencoder)表示：

> An object that encodes instances of a data type as JSON objects.
>
> 把实例编码成JSON对象

如下的例子：

```swift
let pear = GroceryProduct(name: "Pear", points: 250, description: "A rice Pear")

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted

let data = try encoder.encode(pear)

print(String(data: data, encoding: .utf8)!)

/* Prints:
{
  "name" : "Pear",
  "points" : 250,
  "description" : "A rice Pear"
}
*/
```



## CodingKeys

参考官方文章：[Encoding and Decoding Custom Types](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types)

> Codable types can declare a special nested enumeration named `CodingKeys` that conforms to the [`CodingKey`](https://developer.apple.com/documentation/swift/codingkey) protocol. When this enumeration is present, its cases serve as the authoritative list of properties that must be included when instances of a codable type are encoded or decoded. The names of the enumeration cases should match the names you've given to the corresponding properties in your type.
>
> Codable类型可声明一个嵌套的枚举，叫做`CodingKeys`，遵循[`CodingKey`](https://developer.apple.com/documentation/swift/codingkey) 协议。
>
> Omit properties from the `CodingKeys` enumeration if they won't be present when decoding instances, or if certain properties shouldn't be included in an encoded representation. A property omitted from `CodingKeys` needs a default value in order for its containing type to receive automatic conformance to `Decodable` or `Codable`.
>
> `CodingKeys`中忽略的属性需要一个默认值

可使用来修改属性名与json中的字段名不一致的问题

在[Encoding, Decoding and Serialization in Swift 4](https://www.raywenderlich.com/382-encoding-decoding-and-serialization-in-swift-4)一文中，有如下的例子：

```swift
struct Employee: Codable {
    var name: String
    var id: Int
    var favoriteToy: Toy
}

struct Toy: Codable {
    var name: String
}

let toy1 = Toy(name: "Teddy Bear");
let employee1 = Employee(name: "John Appleseed", id: 7, favoriteToy: toy1)

let jsonEncoder = JSONEncoder()
let jsonData = try jsonEncoder.encode(employee1)
let jsonString = String(data: jsonData, encoding: .utf8)
print(jsonString)
// {"name":"John Appleseed","id":7,"favoriteToy":{"name":"Teddy Bear"}}
```

上面的例子，将`employee1`实例转为`json`，假设此时要将`id`替换为`employeeId`，修改`Employee`：

```swift
struct Employee: Codable {
  var name: String
  var id: Int
  var favoriteToy: Toy

  enum CodingKeys: String, CodingKey {
    case id = "employeeId"
    case name
    case favoriteToy
  }
}
```

修改后，此时的json为：

```swift
{ "employeeId": 7, "name": "John Appleseed", "favoriteToy": {"name":"Teddy Bear"}}
```



## Manual Encoding and Decoding

假设要将上面的json发送到服务器，但服务器要求的格式如下，不需要嵌套：

```swift
{ "employeeId": 7, "name": "John Appleseed", "gift": "Teddy Bear" }
```

所以需要手动处理编码和解码

步骤：

1.更新`CodingKeys`，将`favoriteToy`替换为`gift`

```swift
enum CodingKeys: String, CodingKey {
  case id = "employeeId"
  case name
  case gift
}
```

2.移除`Codable`，添加一个`extension`，遵循`Encodable`协议，实现`encode(to: Encoder)`方法，来描述如何编码每个属性

```swift
struct Employee {
    var name: String
    var id: Int
    var favoriteToy: Toy
    
    enum CodingKeys: String, CodingKey {
        case id = "employeeId"
        case name
        case gift
    }
}

extension Employee: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encode(favoriteToy.name, forKey: .gift) //flatten favoriteToy.name down to the .gift key
    }
}


struct Toy: Codable {
    var name: String
}

let toy1 = Toy(name: "Teddy Bear");
let employee1 = Employee(name: "John Appleseed", id: 7, favoriteToy: toy1)

let jsonEncoder = JSONEncoder()
let jsonData = try jsonEncoder.encode(employee1)
let jsonString = String(data: jsonData, encoding: .utf8)
print(jsonString!)
// {"name":"John Appleseed","gift":"Teddy Bear","employeeId":7}
```

此时的结果就为：

```swift
{"name":"John Appleseed","gift":"Teddy Bear","employeeId":7}
```



同理，解码遵循`Decodable`协议

```swift
extension Employee: Decodable {
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    name = try values.decode(String.self, forKey: .name)
    id = try values.decode(Int.self, forKey: .id)
    let gift = try values.decode(String.self, forKey: .gift)
    favoriteToy = Toy(name: gift)
  }
}

let jsonDecoder = JSONDecoder()
let employee2 = try jsonDecoder.decode(Employee.self, from: jsonData)
print(employee2.favoriteToy.name)
// Teddy Bear
```



## 数组的处理

参考：

+ [JSON to Swift with Decoder and Decodable](https://swiftunboxed.com/stdlib/json-decoder-decodable/)

> ```swift
> let jsonString = "[0, 1, 2]"
> let jsonData = jsonString.data(using: .utf8)!
> 
> let decoder = JSONDecoder()
> let dRes = try! decoder.decode([Int].self, from: jsonData)
> ```



+ [Decoding JSON arrays in Swift](https://www.avanderlee.com/swift/json-parsing-decoding/#decoding-json-arrays-in-swift)



```xml
[{
    "title": "Optionals in Swift explained: 5 things you should know",
    "url": "https://www.avanderlee.com/swift/optionals-in-swift-explained-5-things-you-should-know/"
},
{
    "title": "EXC_BAD_ACCESS crash error: Understanding and solving it",
    "url": "https://www.avanderlee.com/swift/exc-bad-access-crash/"
},
{
    "title": "Thread Sanitizer explained: Data Races in Swift",
    "url": "https://www.avanderlee.com/swift/thread-sanitizer-data-races/"
}]
```

```swift
struct BlogPost: Decodable {
    let title: String
    let url: URL
}

let blogPosts: [BlogPost] = try! JSONDecoder().decode([BlogPost].self, from: jsonData)
print(blogPosts.count) // Prints: 3
```



## 其它



+ [JSON Parsing in Swift explained with code examples](https://www.avanderlee.com/swift/json-parsing-decoding/)

+ [Swift 项目中涉及到 JSONDecoder，网络请求，泛型协议式编程的一些记录和想法](https://ming1016.github.io/2018/04/02/record-and-think-about-swift-project-jsondecoder-networking-and-pop/)
+ [利用 Swift 4 的 JSONDecoder 和 Codable 解析 JSON 和生成自訂型別資料](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-swift-4-%E7%9A%84-jsondecoder-%E5%92%8C-codable-%E8%A7%A3%E6%9E%90-json-%E5%92%8C%E7%94%9F%E6%88%90%E8%87%AA%E8%A8%82%E5%9E%8B%E5%88%A5%E8%B3%87%E6%96%99-ee793622629e)



