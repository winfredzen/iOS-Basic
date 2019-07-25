# as as! as? is

参考：

+ [类型转换](https://www.cnswift.org/type-casting)

+ [Swift - as、as!、as?三种类型转换操作符使用详解（附样例）](http://www.hangge.com/blog/cache/detail_1089.html) - 某些用例，可能有错误，可以参考下
+ [Swift 3.0 - What's is, as, as? and as! operators?](https://jayeshkawli.ghost.io/swift-3-0-whats-is-as-as-and-as-operators/)
+ [『簡易說明Swift 4』Any — 型別轉型 （Type Casting）]([https://medium.com/@chao.shin.mail/%E7%B0%A1%E6%98%93%E8%AA%AA%E6%98%8Eswift-4-any-%E5%9E%8B%E5%88%A5%E8%BD%89%E5%9E%8B-type-casting-f4dd2dde71d3](https://medium.com/@chao.shin.mail/簡易說明swift-4-any-型別轉型-type-casting-f4dd2dde71d3))

`as` `as!` `as?` `is`主要是用在类型转换，类型判断方面

## is

is是*类型检查操作符* ，来检查一个实例是否属于一个特定的子类。如果实例是该子类类型，类型检查操作符返回 true ，否则返回 false

```swift
protocol Prot {
    func doit()
}

protocol AnotherProt {
    func doitToo()
}

class Animal: Prot {
    func doit() {

    }
}

let animal = Animal()

if animal is Prot {
    print("Conforms to Prot")
}

if animal is Animal {
    print("Class is of type Animal")
}

if animal is AnotherProt {
    // This will not print since animal does not conform to type AnotherProt
    print("Class is of type AnotherProt")
}

// Past example with devs array
// let devs: [Developer] = [Developer(), Android(), iOS(), CSharp()]

for dev in devs {
    if dev is CSharp {
        print("Dev is C Sharp")
    } else if dev is iOS {
        print("Dev is iOS")
    } else if dev is Android {
        print("Dev is Android")
    } else {
        print("Default Developer")
    }
}

// Output of previous code
Default Developer
Dev is Android
Dev is iOS
Dev is C Sharp
```



## as

什么时候使用`as`呢？

> `as` is an old operator. This can be used to convert primitive types which are interchangeable or converting Swift types to Objective-C and vice versa.
>
> as可以用来转换swift原始类型到oc类型，反之亦然

![23](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/23.png)

需要注意的是，例如，不能将`Double`直接转为`Int`

![24](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/24.png)

## as! as?

as! as?都用于向下类型转换，`as?`返回了一个你将要向下类型转换的值的可选项，如果向下转换失败，可选值为 `nil` 。

`as!`当你向下转换至一个错误的类型时，强制形式的类型转换操作符会触发一个运行错误

```swift
class Developer {
    func printWhoAmI() {
        print("I am Developer")
    }
}

class Android: Developer {
    override func printWhoAmI() {
        print("I am an Android developer")
    }
}

class iOS: Developer {
    override func printWhoAmI() {
        print("I am an iOS developer")
    }
}

class CSharp: Developer {
    override func printWhoAmI() {
        print("I am a C Sharp developer")
    }
}

let devs: [Developer] = [Developer(), Android(), iOS(), CSharp()]


for dev in devs {
    // Code below prints each line once for every type. The base class Developer does not print anything since it is a superclass.

    // The line below will get executed for every object since all of them are either of type Developer or inherit from it

    if let andDev = dev as? Developer {
        print("Developer")
    }

    // The lines below will get printed only once for every conforming type

    if let andDev = dev as? Android {
        print("Casted to Android")
    }

    if let iOSDev = dev as? iOS {
        print("Casted to iOS")
    }

    if let cSharpDev = dev as? CSharp {
        print("Casted to C Sharp")
    }
}

// Output
Developer
Casted to Android
Developer
Casted to iOS
Developer
Casted to C Sharp

// Note that below code will produce nil, since we are trying to cast Android type to iOS

let iOSDev = devs[1] as? iOS

// So will this, since attempt is made to cast iOS type to Android

let androidDev = devs[1] as? Android

// This code will successfully cast Android object into Developer, since it's upcasting

let genericDeveloper = devs[1] as? Developer
```







