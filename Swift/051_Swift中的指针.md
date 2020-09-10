# Swift中的指针

参考：

+ [Swift 中的指针使用](https://onevcat.com/2015/01/swift-pointer/)



## MemoryLayout

[MemoryLayout](https://developer.apple.com/documentation/swift/memorylayout)表示的是：

> The memory layout of a type, describing its size, stride, and alignment.
>
> 类型的内存布局，描述其size、stride、alignment

参考：

+ [Unsafe Swift: Using Pointers and Interacting With C](https://www.raywenderlich.com/7181017-unsafe-swift-using-pointers-and-interacting-with-c)
+ [Swift三部曲（一）：指针的使用](https://juejin.im/post/6844903872905871367)



> // 单位均为字节
> MemoryLayout<T>.size       // 类型T需要的内存大小
> MemoryLayout<T>.stride     // 类型T实际分配的内存大小(由于内存对齐原则，会多出空白的空间)
> MemoryLayout<T>.alignment  // 内存对齐的基数



![037](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/37.png)



### Struct布局

```swift
struct EmptyStruct {}

MemoryLayout<EmptyStruct>.size      // returns 0
MemoryLayout<EmptyStruct>.alignment // returns 1
MemoryLayout<EmptyStruct>.stride    // returns 1

struct SampleStruct {
  let number: UInt32
  let flag: Bool
}

MemoryLayout<SampleStruct>.size       // returns 5
MemoryLayout<SampleStruct>.alignment  // returns 4
MemoryLayout<SampleStruct>.stride     // returns 8
```

`SampleStruct`其`size`为5，但`stride`为8。 那是因为它的对齐alignment要求它必须在4字节的边界上。鉴于此，Swift最好的办法是以八个字节的间隔打包。



### class vs struct

```swift
class EmptyClass {}

MemoryLayout<EmptyClass>.size      // returns 8 (on 64-bit)
MemoryLayout<EmptyClass>.stride    // returns 8 (on 64-bit)
MemoryLayout<EmptyClass>.alignment // returns 8 (on 64-bit)

class SampleClass {
  let number: Int64 = 0
  let flag = false
}

MemoryLayout<SampleClass>.size      // returns 8 (on 64-bit)
MemoryLayout<SampleClass>.stride    // returns 8 (on 64-bit)
MemoryLayout<SampleClass>.alignment // returns 8 (on 64-bit)
```

class是引用类型，MemoryLayout给出的一个引用的大小：8个字节



## 指针

有8种指针组合

![038](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/38.png)



### 使用Raw指针

`UnsafeRawBufferPointer`使您可以访问内存，就好像它是字节的集合一样。 这意味着您可以遍历字节并使用下标访问它们。 您还可以使用很酷的方法，例如`filter`，`map`、`reduce`

```swift
let count = 2 //存储几个整数
let stride = MemoryLayout<Int>.stride
let alignment = MemoryLayout<Int>.alignment
let byteCount = stride * count //需要的byte数量

// do闭包
do {
  print("Raw pointers")
  
  // 分配所需的字节
  let pointer = UnsafeMutableRawPointer.allocate(
    byteCount: byteCount,
    alignment: alignment)
  // 延迟块可确保正确的释放了指针，需自己管理内存
  defer {
    pointer.deallocate()
  }
  
  // 存储byte
  pointer.storeBytes(of: 42, as: Int.self)
  // 通过advanced指针步长字节来计算第二个整数的内存地址
  pointer.advanced(by: stride).storeBytes(of: 6, as: Int.self)
  // 加载byte
  pointer.load(as: Int.self)
  pointer.advanced(by: stride).load(as: Int.self)
  
  // 使用raw指针初始化buffer指针
  let bufferPointer = UnsafeRawBufferPointer(start: pointer, count: byteCount)
  for (index, byte) in bufferPointer.enumerated() {
    print("byte \(index): \(byte)")
  }
}

```

控制台输出结果为：

```swift
Raw pointers
byte 0: 42
byte 1: 0
byte 2: 0
byte 3: 0
byte 4: 0
byte 5: 0
byte 6: 0
byte 7: 0
byte 8: 6
byte 9: 0
byte 10: 0
byte 11: 0
byte 12: 0
byte 13: 0
byte 14: 0
byte 15: 0
```



### 使用Typed指针

![039](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/39.png)

```swift
do {
    print("Typed pointers")
    
    //泛型int，让swift知道你在使用pointer来加载和存储Int类型的值
    let pointer = UnsafeMutablePointer<Int>.allocate(capacity: count)
    //初始化
    pointer.initialize(repeating: 0, count: count)
    //析构
    defer {
        pointer.deinitialize(count: count)
        pointer.deallocate()
    }
    
    pointer.pointee = 42
    pointer.advanced(by: 1).pointee = 6
    pointer.pointee
    pointer.advanced(by: 1).pointee
    
    let bufferPointer = UnsafeBufferPointer(start: pointer, count: count)
    for (index, value) in bufferPointer.enumerated() {
        print("value \(index): \(value)")
    }
}
```

控制台输出为：

```swift
Typed pointers
value 0: 42
value 1: 6
```



### Raw Pointers转换为Typed Pointers

```swift
do {
    print("Converting raw pointers to typed pointers")
    
    let rawPointer = UnsafeMutableRawPointer.allocate(
        byteCount: byteCount,
        alignment: alignment)
    defer {
        rawPointer.deallocate()
    }
    
    //绑定内存
    let typedPointer = rawPointer.bindMemory(to: Int.self, capacity: count)
    typedPointer.initialize(repeating: 0, count: count)
    defer {
        typedPointer.deinitialize(count: count)
    }
    
    typedPointer.pointee = 42
    typedPointer.advanced(by: 1).pointee = 6
    typedPointer.pointee
    typedPointer.advanced(by: 1).pointee
    
    let bufferPointer = UnsafeBufferPointer(start: typedPointer, count: count)
    for (index, value) in bufferPointer.enumerated() {
        print("value \(index): \(value)")
    }
}
```







