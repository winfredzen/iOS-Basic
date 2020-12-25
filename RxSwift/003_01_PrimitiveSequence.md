# PrimitiveSequence

在源码中，看到许多地方都有`PrimitiveSequence`的使用

其结构关系大概如下：

![016](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/016.png)

`PrimitiveSequence`是一个结构体，定义如下：

```swift
/// Observable sequences containing 0 or 1 element.
public struct PrimitiveSequence<Trait, Element> {
    let source: Observable<Element>

    init(raw: Observable<Element>) {
        self.source = raw
    }
}
```

