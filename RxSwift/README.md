# RxSwift



## 术语



**Observable**

参考[Observable](http://reactivex.io/documentation/observable.html)，有如下的一张图：

![003](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/003.png)

其中，最上面的一排，就是一个**Observable**。从左到右，表示时间由远及近的流动过程。上面的每一个形状，就表示在“某个时间点发生的事件”，而最右边的竖线则表示事件成功结束



**Operator**

+ [Operators ](http://reactivex.io/documentation/operators.html)

**operators**分为两大类：一类用于创建Observable；

![004](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/004.png)

这些不同的创建方法可以针对不同的事件流类型生成Observable。另一类是接受Observable作为参数，并返回一个新的Observable；

![005](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/005.png)



## 异步

**Observable**的`map`和`filter`这两个operator和集合中的`map`和`filter`方法非常类似，但它们执行的逻辑却截然不同。

如：

```swift
      _ = ["1", "2", "3", "4", "5", "6", "7", "8", "9"].map{ Int($0) }
            .filter{
                if let item = $0, item % 2 == 0 {
                    print("arr even: \(item)")
                    return true
                }
                return false
            }
        
        
       _ = Observable.from(["1", "2", "3", "4", "5", "6", "7", "8", "9"]).map({ Int($0) })
            .filter({
                if let item = $0, item % 2 == 0 {
                    print("Observable even: \(item)")
                    return true
                }
                return false
            })
```

此时控制台会输出：

```swift
arr even: 2
arr even: 4
arr even: 6
arr even: 8
```

可以发现：

> 调用集合类型的`map`和`filter`方法，表达的是**同步执行**的概念，在调用方法的同时，集合就被立即加工处理了。
>
> 但我们创建的Observable，表达的是**异步操作**。**Observable中的每一个元素，都可以理解为一个异步发生的事件**。因此，当我们对Observable调用`map`和`filter`方法时，只表示我们要对事件序列中的元素进行处理的逻辑，而并不会立即对Observable中的元素进行处理。
>
> 当我们执行编译结果的时候，**不会在控制台上打印任何消息**。也就是说，**我们没有实际执行任何的筛选逻辑**。

真正的筛选是否发生在，有人订阅这个事件的时候

```swift
        var evenNumberObservable = Observable.from(["1", "2", "3", "4", "5", "6", "7", "8", "9"]).map({ Int($0) })
            .filter({
                if let item = $0, item % 2 == 0 {
                    print("Observable even: \(item)")
                    return true
                }
                return false
            })
        evenNumberObservable.subscribe({ event in
            print("Event: \(event)")
        })
```

输出结果为：

```swift
Observable even: 2
Event: next(Optional(2))
Observable even: 4
Event: next(Optional(4))
Observable even: 6
Event: next(Optional(6))
Observable even: 8
Event: next(Optional(8))
Event: completed
```





## Swift



参考：

+ [RxSwift中文文档](https://beeth0ven.github.io/RxSwift-Chinese-Documentation/)



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

3.使用`from`,  Converts an array to an observable sequence, 用一个`Sequence`类型的对象创建一个Observable

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



## **Dispose**

要显式的取消一个订阅，调用`dispose()` ，调用`dispose()` 后，当前的 observable  会停止发出事件

```swift
let observable = Observable.of("A", "B", "C")
let subscription = observable.subscribe { event in
    print(event)
}
subscription.dispose()
```

单独管理每个订阅将很乏味，因此RxSwift包含`DisposeBag`类型。 一个dispose bag持有disposable（通常使用`disposed(by:)`方法添加），并且在dispose bag即将被释放时将对每个对象调用`dispose()`方法

> If you forget to add a subscription to a dispose bag, or manually call dispose on it  when you’re done with the subscription, or in some other way cause the observable  to terminate at some point, you will probably leak memory.
>
>  Don’t worry if you forget; the Swift compiler should warn you about unused disposables.
>
> 如果你忘记在dispose bag中添加订阅，或者在完成订阅后手动在其上调用dispose，或者以其他某种方式导致observable在某个时候终止，则可能会泄漏内存。
>
>  如果您忘记了，请不要担心； Swift编译器应警告您有关未使用的disposable。



```swift
let disposeBag = DisposeBag()
Observable.of("A", "B", "C").subscribe {
    print($0)
}.disposed(by: disposeBag)
```



在前面的例子中，创建observable时，带有指定的event元素。还可以使用`create()`方法来实现

```swift
    /**
         Creates an observable sequence from a specified subscribe method implementation.
    
         - seealso: [create operator on reactivex.io](http://reactivex.io/documentation/operators/create.html)
    
         - parameter subscribe: Implementation of the resulting observable sequence's `subscribe` method.
         - returns: The observable sequence with the specified implementation for the `subscribe` method.
         */
    public static func create(_ subscribe: @escaping (RxSwift.AnyObserver<Self.Element>) -> RxSwift.Disposable) -> RxSwift.Observable<Self.Element>
```

如下的例子：

```swift
let disposeBag = DisposeBag()
Observable<String>.create { (observer) -> Disposable in
    observer.onNext("1")
    observer.onCompleted()
    observer.onNext("?")
    return Disposables.create()
}.subscribe(
    onNext: {print($0)},
    onError: {print($0)},
    onCompleted: {print("completed")},
    onDisposed: {print("disposed")}
).disposed(by: disposeBag)
```

输出结果为：

```xml
1
completed
disposed
```

> **Note**: The last step, returning a `Disposable`, may seem strange at fifirst. Remember that **subscribe operators** **must** return a **disposable** representing the subscription, so you use `Disposables.create()` to create a disposable.



如果要emit一个error该怎么做呢？

```swift
enum MyError : Error {
    case anError
}
let disposeBag = DisposeBag()
Observable<String>.create { (observer) -> Disposable in
    observer.onNext("1")
    observer.onError(MyError.anError)
    observer.onCompleted()
    observer.onNext("?")
    return Disposables.create()
}.subscribe(
    onNext: {print($0)},
    onError: {print($0)},
    onCompleted: {print("completed")},
    onDisposed: {print("disposed")}
).disposed(by: disposeBag)
```

输出结果为：

```xml
1
anError
disposed
```



## **Creating observable factories**

`deferred`方法的介绍：

```swift
extension ObservableType {

    /**
         Returns an observable sequence that invokes the specified factory function whenever a new observer subscribes.
    
         - seealso: [defer operator on reactivex.io](http://reactivex.io/documentation/operators/defer.html)
    
         - parameter observableFactory: Observable factory function to invoke for each observer that subscribes to the resulting sequence.
         - returns: An observable sequence whose observers trigger an invocation of the given observable factory function.
         */
    public static func deferred(_ observableFactory: @escaping () throws -> RxSwift.Observable<Self.Element>) -> RxSwift.Observable<Self.Element>
}
```

> Returns an observable sequence that invokes the specified factory function whenever a new observer subscribes.
>
> 当一个新的observer subscribe时，调用这个指定的工厂方法，返回observable序列

```swift
let disposeBag = DisposeBag()
var flip = false
let factory: Observable<Int> = Observable.deferred {
    flip.toggle()
    if flip {
        return Observable.of(1, 2, 3)
    } else {
        return Observable.of(4, 5, 6)
    }
}
for _ in 0...3 {
    factory.subscribe(onNext: {
        print($0, terminator: "")
    })
    .disposed(by: disposeBag)
    
    print()
}
```

输出结果为：

```swift
123
456
123
456
```



## Trait

Trait是observables，其行为集比常规observables的要窄。

+ 它们的使用是可选的； 您可以在可能使用Trait的任何地方使用常规observables。 
+ 它们的目的是提供一种方法，以将你的意图更清楚地传达给代码的读者或API的使用者。 使用Trait暗示的上下文可以帮助使你的代码更直观

RxSwift具有三种特征：Single，Maybe和Completable

`Single` 发出 `success(value)`或者~~`error(error)`~~事件。`success(value)` 是next和completed事件的结合。这对于一次成功执行并产生值或失败的进程很有用，例如在下载数据或从磁盘加载数据时。**貌似，在`6.0.0-rc.2`的版本中，error变成了failure**

`Completable`将仅发出completed或error(error)事件。它不会发出任何值。当你只关心操作成功完成或失败（例如文件写入）时，可以使用completable。

`Maybe`是`Single`和Completable的混搭，它可以发出success(value)、completed或者error(error)。如果你需要执行一个可能成功或失败的操作，并且有选择地返回成功值，那么Maybe是你的方便之选

```swift
        let disposeBag = DisposeBag()
        
        enum FileReadError: Error {
            case fileNotFound, unreadable, encodingFailed
        }
        
        func loadText(from name: String) -> Single<String> {

            return Single.create { single in
                
                let disposable = Disposables.create()
                
                guard let path = Bundle.main.path(forResource: name, ofType:"txt") else {
                    single(.failure(FileReadError.fileNotFound))
                    return disposable
                }
                
                guard let data = FileManager.default.contents(atPath: path) else {
                    single(.failure(FileReadError.unreadable))
                    return disposable
                }
              
                guard let contents = String(data: data, encoding: .utf8) else {
                    single(.failure(FileReadError.encodingFailed))
                    return disposable
                }
                
                single(.success(contents))
                return disposable
                
            }
        }
        
        loadText(from: "Copyright").subscribe {
            switch $0 {
            case .success(let string):
                print(string)
            case .failure(let error):
                print(error)
            }
        }.disposed(by: disposeBag)
```



































