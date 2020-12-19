# create和debug operator

参考自：

+ [理解create和debug operator](https://boxueio.com/series/rxswift-101/episodes/213)



## create

有时候，Observable中的事件值并不像整数或字符串这么简单，当我们需要精确控制发送给订阅者的成功、错误和结束事件时，就可以使用RxSwift提供的`create` operator

`create` operator的定义如下：

```swift
    public static func create(_ subscribe: @escaping (RxSwift.AnyObserver<Self.Element>) -> RxSwift.Disposable) -> RxSwift.Observable<Self.Element>
```

+ `subscribe` - `subscribe`并不是指事件真正的订阅者，而是用来定义当有人订阅Observable中的事件时，应该如何向订阅者发送不同情况的事件
+ `RxSwift.AnyObserver<Self.Element>` - 表示任意一个订阅的“替身”，我们要用这个“替身”来表达向订阅者发送各种事件的行为
+ `subscribe`还要返回一个`Disposable`对象，我们可以用这个对象取消订阅进而回收占用的资源

在http://reactivex.io/documentation/operators/create.html ，有如下的介绍：

> ### create an Observable from scratch by means of a function
>
> ![007](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/007.png)
>
> You can create an Observable from scratch by using the Create operator. You pass this operator a function that accepts the observer as its parameter. Write this function so that it behaves as an Observable — by calling the observer’s `onNext`, `onError`, and `onCompleted` methods appropriately.
>
> A well-formed finite Observable must attempt to call either the observer’s `onCompleted` method exactly once or its `onError` method exactly once, and must not thereafter attempt to call any of the observer’s other methods.
>
> 其中的swift例子：
>
> ```swift
> let source : Observable = Observable.create { observer in
>     for i in 1...5 {
>         observer.on(.next(i))
>     }
>     observer.on(.completed)
> 
>     // Note that this is optional. If you require no cleanup you can return
>     // `Disposables.create()` (which returns the `NopDisposable` singleton)
>     return Disposables.create {
>         print("disposed")
>     }
> }
> 
> source.subscribe {
>     print($0)
> }
> ```
>
> ```swift
> next(1)
> next(2)
> next(3)
> next(4)
> next(5)
> completed
> disposed
> ```



```swift
enum CustomError: Error {
    case somethingWrong
}
let customOb = Observable<Int>.create { observer in
    // next event
    observer.onNext(10)

    observer.onError(CustomError.somethingWrong)

    observer.onNext(11)

    // complete event
    observer.onCompleted()

    return Disposables.create()
}
customOb.subscribe(
    onNext: { print($0) },
    onError: { print($0) },
    onCompleted: { print("Completed") },
    onDisposed: { print("Game over") }
).addDisposableTo(disposeBag)

// 10
// somethingWrong
// Game over
```



## 调试

在实际的变成中，如果串联多个operator，发生问题调试时就很麻烦



### do

可使用do operator，叫做`“旁路”`，它的用法和`subscribe`类似，只不过事件会“穿过”`do`，继续发给后续的环节

![008](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/008.png)

```swift
        enum CustomError: Error {
            case somethingWrong
        }
        
        let customObj = Observable<Int>.create { observer -> Disposable in
            // next event
            observer.onNext(10)

            observer.onError(CustomError.somethingWrong)

            observer.onNext(11)

            // complete event
            observer.onCompleted()

            return Disposables.create()
        }
        
        let disposeBag = DisposeBag()
        
        customObj.do(
            onNext: { print("Intercepted: \($0)") },
            onError: { print("Intercepted: \($0)") },
            onCompleted: { print("Intercepted: Completed") },
            onDispose: { print("Intercepted: Game over") }
        ).subscribe(
            onNext: { print($0) },
            onError: { print($0) },
            onCompleted: { print("Completed") },
            onDisposed: { print("Game over") }
        ).disposed(by: disposeBag)
        
```

输出结果为：

```swift
Intercepted: 10
10
Intercepted: somethingWrong
somethingWrong
Game over
Intercepted: Game over
```

注意：

+ onDispose vs onDisposed



### debug

RxSwift提供了一个调试专属的operator，叫做`debug`，它可以安插在任意一个需要确认事件值的地方，像这样：

```swift
customOb.debug()
.subscribe(
    onNext: { print($0) },
    onError: { print($0) },
    onCompleted: { print("Completed") },
    onDisposed: { print("Game over") }
).addDisposableTo(disposeBag)
```

调试输出结果如下：

```swift
2017-04-06 18:56:25.348: main.swift:23 (RxSwiftInSPM) -> subscribed
2017-04-06 18:56:25.355: main.swift:23 (RxSwiftInSPM) -> Event next(10)
10
2017-04-06 18:56:25.356: main.swift:23 (RxSwiftInSPM) -> Event error(somethingWrong)
somethingWrong
Game over
2017-04-06 18:56:25.356: main.swift:23 (RxSwiftInSPM) -> isDisposed
```





















