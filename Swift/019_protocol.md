# protocol

1.属性要求定义为变量属性，在名称前面使用 `var` 关键字

参考：[Swift Protocols: Properties distinction(get, get set)🏃🏻‍♀️🏃🏻](<https://medium.com/@chetan15aga/swift-protocols-properties-distinction-get-get-set-32a34a7f16e9>)

+ 协议中属性定义为只读，实现协议中属性可以为任何类型的属性，也可以将其设置为可写的，都没问题
+ 如果协议中属性定义为可读和可写，不能是常量存储属性或者只读计算属性

![020](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/20.png)

