# RxSwift

创建observable，so，什么是observable？

> You’ll see “observable”, “observable sequence” and “sequence” used interchangeably  in Rx. And, really, they’re all the same thing. 
>
>  “Stream” also refers to  the same thing
>
> `Observable`、`observable sequence` 和 `sequence` 在 Rx 都是一个意思。或者在其他 Rx 实现中称之为 `stream`。
>
> 最好称之为 `Observable`，不过翻译过来还是**序列**顺口些。

 `Observables` produce **events** over a period of time, which is referred to as **emitting**.

>  `Observables`产生**event**，称为**emitting**

Events可包含值，例如数字or自定义的实例，or手势，点击事件

**observable生命周期**

当一个observable发出一个element时，被称为`next`事件

![001](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/001.png)

上图中，observable发出3个tap事件，然后就结束了。被称为**completed**事件，它就 **terminated**终止了

![002](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/002.png)

上图中，observable发出了一个**error**事件，它也终止了，以后也就不能再emit了

+ An observable emits **next** events that contain elements
+ It can continue to do this until a **terminating event** is emitted, i.e., an **error** or **completed** event
+ Once an observable is terminated, it can no longer emit events

Event是用枚举来表示的：

```swift
/// Represents a sequence event.
///
/// Sequence grammar: 
/// **next\* (error | completed)**
@frozen public enum Event<Element> {
    /// Next element is produced.
    case next(Element)

    /// Sequence terminated with an error.
    case error(Swift.Error)

    /// Sequence completed successfully.
    case completed
}
```



## 创建observable

`Observable<Element>`遵循`ObservableType`协议

1.使用`just`方法，创建一个包含单个element的observable 序列

```swift
public static func just(_ element: Self.Element) -> RxSwift.Observable<Self.Element>
```

```swift
let one = 1
let observable = Observable<Int>.just(one) // Observable<Int>类型
```

> However, in Rx,  methods are referred to as “operators.”
>
> 在Rx中，方法也叫做operator

2.使用`of`方法，接受一个可变参数，此方法创建一个具有可变数量元素的新`Observable`实例。

```swift
public static func of(_ elements: Self.Element..., scheduler: RxSwift.ImmediateSchedulerType = CurrentThreadScheduler.instance) -> RxSwift.Observable<Self.Element>
```

```swift
let one = 1
let two = 2
let three = 3

let observable2 = Observable.of(one, two, three) //Observable<Int>类型
```

如果传递数组，会创建一个 observable array

```swift
let observable3 = Observable.of([one, two, three]) //Observable<[Int]>
```

 `just` 也可以把一个array作为一个单个元素

3.使用`from`,  Converts an array to an observable sequence

```swift
public static func from(_ array: [Self.Element], scheduler: RxSwift.ImmediateSchedulerType = CurrentThreadScheduler.instance) -> RxSwift.Observable<Self.Element>
```

```swift
let observable4 = Observable.from([one, two, three]) //Observable<Int>
```



4.0个element的observable

使用empty operator，它只会发出一个completed 事件

```swift
    /**
         Returns an empty observable sequence, using the specified scheduler to send out the single `Completed` message.
    
         - seealso: [empty operator on reactivex.io](http://reactivex.io/documentation/operators/empty-never-throw.html)
    
         - returns: An observable sequence with no elements.
         */
    public static func empty() -> RxSwift.Observable<Self.Element>
```

```swift
let observable = Observable<Void>.empty()
```

empty observable有什么用呢？

> What use is an empty observable? They’re handy when you want to return an observable that immediately terminates or intentionally has zero values.
>
> 空可观察值有什么用？ 当你要返回可立即终止或故意具有零值的可观察对象时，它们非常方便。



5.never observable

never observable创建一个 observable不会发出emit任何东西，而且不会终止。它可以用来表示一个无限的持续时间

```swift
let observable = Observable<Void>.never()
observable.subscribe(onNext: { element in
    print(element)
},
onCompleted: {
    print("Completed")
})
//不会有任何的输出
```



## **订阅** Observable

一个observable不会发送event，or执行任何工作，直到它有了一个subscriber

请记住，一个observable对象实际上是一个sequence，并且订阅一个observable实际上更像是在Swift标准库中的`Iterator`上调用`next()`方法

```swift
let sequence = 0..<3
var iterator = sequence.makeIterator()
while let e = iterator.next() {
    print(e)
}
/* Prints:
 0
 1
 2
 */
```

如下的例子：

```swift
let observable = Observable.of(one, two, three)
observable.subscribe { event in
    print(event)
}
--- Example of: subscribe ---
next(1)
next(2)
next(3)
completed
```

`subscribe`的定义

```swift
    /**
     Subscribes an event handler to an observable sequence.
     
     - parameter on: Action to invoke for each event in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    public func subscribe(_ on: @escaping (RxSwift.Event<Self.Element>) -> Void) -> RxSwift.Disposable
```

> observable为每个element，发出next事件，然后发出一个completed事件，然后终止了

通常在处理observable时，我们对其中的element更感兴趣，而不是event本身

```swift
let observable = Observable.of(one, two, three)
observable.subscribe { event in
    if let element = event.element {
        print(element)
    }
}
输出：
1
2
3
```



subscribe还有另一个方法，如下：

```swift
    /**
     Subscribes an element handler, an error handler, a completion handler and disposed handler to an observable sequence.
     
     - parameter onNext: Action to invoke for each element in the observable sequence.
     - parameter onError: Action to invoke upon errored termination of the observable sequence.
     - parameter onCompleted: Action to invoke upon graceful termination of the observable sequence.
     - parameter onDisposed: Action to invoke upon any type of termination of sequence (if the sequence has
     gracefully completed, errored, or if the generation is canceled by disposing subscription).
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    public func subscribe(onNext: ((Self.Element) -> Void)? = nil, onError: ((Error) -> Void)? = nil, onCompleted: (() -> Void)? = nil, onDisposed: (() -> Void)? = nil) -> RxSwift.Disposable
```

> 为observable序列，订阅一个element handler，一个error handler，一个completion handler，一个disposed handler

```swift
observable.subscribe(onNext: { element in
    print(element)
})
输出：
1
2
3
```

empty observable的订阅

```swift
let observable = Observable<Void>.empty()
observable.subscribe { element in
    print(element)
} onCompleted: {
    print("Completed")
}
--- Example of: empty ---
Completed
```













