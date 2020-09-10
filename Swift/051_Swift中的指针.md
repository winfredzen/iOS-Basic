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



