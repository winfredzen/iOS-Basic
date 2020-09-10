# Int、Int8、Int16、Int32、Int64

参考：

+ [Swift 中的位操作](https://swift.gg/2016/03/30/Dealing-With-Bit-Sets-In-Swift/)



> Swift 提供了一个包含不同定长和符号类型整型的集合：**Int/UInt**， **Int8/UInt8**(8 位)，**Int16/UInt16**(16 位)，**Int32/UInt32**(32 位)，**Int64/UInt64**(64 位)。
>
> Int 和 UInt 这两种类型是有平台依赖的：在32位平台上等于 **Int32/UInt32**，而在64位平台上等于 **Int64/UInt64**。其他整型的长度是特定的，与你编译的目标平台无关。



## Integer类型转换

```swift
var someInt: Int = 7 // init an Int
var someUInt: UInt = UInt(someInt) // Cast Int from UInt
var someNewUInt: UInt = 10 // init a UInt
var someInt: Int = Int(someNewUInt) // Cast from UInt to Int
```

