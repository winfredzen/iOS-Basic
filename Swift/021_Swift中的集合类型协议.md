# Swift中的集合类型协议

参考：

+ [Swift 里集合类型协议的关系](https://www.cnblogs.com/huahuahu/p/Swift-li-ji-he-lei-xing-xie-yi-de-guan-xi.html)
+ [不是所有可变的集合都叫做 MutableCollection](https://segmentfault.com/a/1190000008416656)



[BidirectionalCollection](<https://developer.apple.com/documentation/swift/bidirectionalcollection>):

> A collection that supports backward as well as forward traversal.
>
> 支持反向遍历

[RandomAccessCollection](<https://developer.apple.com/documentation/swift/randomaccesscollection>):

>A collection that supports efficient random-access index traversal.
>
>可以在常量时间访问任何元素的集合。[Array](https://developer.apple.com/reference/swift/array) 就是一个规范的例子。
>
>`RandomAccessCollection` 协议改进了 `BidirectionalCollection` 协议，因为前者是后者的严格超集 —— 任何可以有效地跳转到任意索引的集合都可以向后遍历。`RandomAccessCollection` 没有基于 `BidirectionalCollection` 提供新的 API；也就是说前者能做的事情，后者都可以做到。然而，`RandomAccessCollection` 严格的特性保证了遵守者中的算法只能通过随机元素访问来实现。

[MutableCollection](<https://developer.apple.com/documentation/swift/mutablecollection>):

> A collection that supports subscript assignment.
>
> 支持集合通过下标的方式改变自身的元素，即 `array[index] = newValue`。

[RangeReplaceableCollection](<https://developer.apple.com/documentation/swift/rangereplaceablecollection>):

> A collection that supports replacement of an arbitrary subrange of elements with the elements of another collection.
>
> 支持插入和删除任意区间的元素集合

