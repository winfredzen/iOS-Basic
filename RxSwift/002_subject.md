# Subject

参考：

+ [四种Subject的基本用法](https://boxueio.com/series/rxswift-101/episodes/222)



Subject同时作为`Observable`和`Observer`

在RxSwift中，有4中类型的subject:

+ `PublishSubject`: Starts empty and only emits new elements to subscribers
+ `BehaviorSubject`: Starts with an initial value and replays it or the latest element to new subscribers
+ `ReplaySubject`: Initialized with a buffer size and will maintain a buffer of elements up to that size and replay it to new subscribers
+ `AsyncSubject`: Emits *only the last* next event in the sequence, and only when the subject receives a completed event. This is a seldom used kind of subject, and you won’t use it in this book. It’s listed here for the sake of completeness.



## PublishSubject

`PublishSubject`执行的是“会员制”，它只会把最新的消息通知给消息发生之前的订阅者。如下的例子：

```swift
        let subject = PublishSubject<String>()
        subject.on(.next("Is anyone listening?"))
        let subscriptionOne = subject.subscribe(onNext: {string in
            print(string)
        })
        subject.onNext("1")
```

只会输出：

```swift
1
```

如下在添加第二个订阅者：

```swift
        let subject = PublishSubject<String>()
        subject.on(.next("Is anyone listening?"))
        let subscriptionOne = subject.subscribe { event in
            print("1)", event.element ?? event)
        }
        subject.onNext("1")
        let subscriptionTwo = subject.subscribe { event in
            print("2)", event.element ?? event)
        }
        subject.onNext("3")
```

```swift
1) 1
1) 3
2) 3
```

如果此时终止`subscriptionOne`，再在subject上添加另一个next event

```swift
        subscriptionOne.dispose()
        subject.onNext("4")
```

此时只有`subscriptionTwo`会输出

```swift
2) 4
```



当publish subject收到completed事件或error事件（也称为stop事件）时，它将向新订阅者发出该stop事件，并且不再发出下一个事件。 但是，它将stop事件重新发送给将来的subscriber

```swift
        subject.onCompleted()
        subject.onNext("5")
        
        subscriptionTwo.dispose()
        let disposeBag = DisposeBag()
        
        subject.subscribe {
            print("3)", $0.element ?? $0)
        }.disposed(by: disposeBag)
        subject.onNext("?")
```

```swift
2) completed
3) completed
```



## BehaviorSubject

`BehaviorSubject`和`PublisherSubject`唯一的区别，就是只要有人订阅，它就会向订阅者发送最新的一次事件作为“试用”。

![009](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/009.png)

如图所示，`BehaviorSubject`带有一个紫灯作为默认消息，当红灯之前订阅时，就会收到紫色及以后的所有消息。而在绿灯之后订阅，就只会收到绿灯及以后的所有消息了。因此，当初始化一个`BehaviorSubject`对象的时候，要给它指定一个默认的推送消息：

```swift
let subject = BehaviorSubject<String>(value: "RxSwift step by step")
let sub1 = subject.subscribe(onNext: {
    print("Sub1 - what happened: \($0)")
})
subject.onNext("Episode1 updated")
```

输出结果为：

```swift
Sub1 - what happened: RxSwift step by step
Sub1 - what happened: Episode1 updated
```



## ReplaySubject

`ReplaySubject`的行为和`BehaviorSubject`类似，都会给订阅者发送历史消息。不同地方有两点：

+ `ReplaySubject`没有默认消息，订阅空的`ReplaySubject`不会收到任何消息；
+ `ReplaySubject`自带一个缓冲区，当有订阅者订阅的时候，它会向订阅者发送缓冲区内的所有消息；

![010](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/010.png)



`ReplaySubject`缓冲区的大小，是在创建的时候确定的：

```swift
let subject = ReplaySubject<String>.create(bufferSize: 2)
```

这样，我们就创建了一个可以缓存两个消息的`ReplaySubject`。作为Observable，它此时是一个空的事件序列，订阅它，不会收到任何消息：

```swift
let sub1 = subject.subscribe(onNext: {
    print("Sub1 - what happened: \($0)")
})
```

然后，我们让`subject`接收3个事件，`sub1`就会收到三次事件订阅：

```swift
subject.onNext("Episode1 updated")
subject.onNext("Episode2 updated")
subject.onNext("Episode3 updated")

// Sub1 - what happened: Episode1 updated
// Sub1 - what happened: Episode2 updated
// Sub1 - what happened: Episode3 updated
```

这时，我们再给`subject`添加一个订阅者：

```swift
let sub2 = subject.subscribe(onNext: {
    print("Sub2 - what happened: \($0)")
})

// Sub2 - what happened: Episode2 updated
// Sub2 - what happened: Episode3 updated
```

由于`subject`缓冲区的大小是2，它会自动给`sub2`发送最新的两次历史事件。在控制台中执行一下，就可以看到注释中的结果了。



再看下如下的例子：

```swift
let subject = ReplaySubject<String>.create(bufferSize: 2)
let disposeBag = DisposeBag()
subject.onNext("1")
subject.onNext("2")
subject.onNext("3")
subject.subscribe {
    print("1) \($0)")
}.disposed(by: disposeBag)
subject.subscribe {
    print("2) \($0)")
}.disposed(by: disposeBag)
```

控制体输出结果如下：

```swift
1) next(2)
1) next(3)
2) next(2)
2) next(3)
```

**可见， `1`没有被emit**

在后面，再添加如下的代码：

```swift
subject.onNext("4")
subject.subscribe {
    print("3) \($0)")
}.disposed(by: disposeBag)
```

此时的输出结果为：

```swift
1) next(4)
2) next(4)
3) next(3)
3) next(4)
```

如果在过程中出现了error，会是什么样的状况呢？

```swift
        subject.onNext("4")
        subject.onError(MyError.anError)
        
        subject.subscribe {
            print("3) \($0)")
        }.disposed(by: disposeBag)
```

```swift
1) next(4)
2) next(4)
1) error(anError)
2) error(anError)
3) next(3)
3) next(4)
3) error(anError)
```

> 这里虽然发生了error，但对新的订阅者，还是将buffer 中的event，emit出来



如何解决呢？在error后，添加如下的代码：

```swift
subject.dispose()
```

此时的输出为：

```swift
1) error(anError)
2) error(anError)
3) error(Object `RxSwift.(unknown context at $106aa1b00).ReplayMany<Swift.String>` was already disposed.)
```



## Variable （已弃用）

在 RxSwift 5.x 中，他被[官方的正式的弃用了](https://github.com/ReactiveX/RxSwift/pull/1922)，并且在需要时，推荐使用 [BehaviorRelay](https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/recipes/rxrelay.html) 或者 [BehaviorSubject](https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/rxswift_core/observable_and_observer/behavior_subject.html)。



## RxRelay

参考：

+ [RxRelay](https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/recipes/rxrelay.html)



> **RxRelay** 既是 **可监听序列** 也是 **观察者**。
>
> 他和 **Subjects** 相似，唯一的区别是不会接受 `onError` 或 `onCompleted` 这样的终止事件。
>
> 在将非 Rx 样式的 API 转化为 Rx 样式时，**Subjects** 是非常好用的。不过一旦 **Subjects** 接收到了终止事件 `onError` 或 `onCompleted`。他就无法继续工作了，也不会转发后续任何事件。有些时候这是合理的，但在多数场景中这并不符合我们的预期。
>
> 在这些场景中一个更严谨的做法就是，创造一种**特殊的 Subjects**，这种 **Subjects** 不会接受终止事件。有了他，我们将 API 转化为 Rx 样式时，就不必担心一个意外的终止事件，导致后续事件转发失效。
>
> 我们将这种**特殊的 Subjects** 称作 **RxRelay**：

> You learned earlier that a relay wraps a subject while maintaining its replay behavior. Unlike other subjects — and observables in general — you add a value onto a relay by using the accept(_:) method. In other words, you don’t use onNext(_:). This is because relays can only accept values, i.e., you cannot add an error or completed event onto them.
>
> 使用`accept(_:)` 方法添加value，不能使用 `onNext(_:)`，不能添加error或者completed事件



使用的时候，需导入`import RxRelay`



### PublishRelay

如下的例子：

```swift
let relay = PublishRelay<String>()
let disposeBag = DisposeBag()
relay.accept("Knock knock, anyone home?")
relay.subscribe(onNext: {
    print($0)
})
.disposed(by: disposeBag)
relay.accept("1")
```

输出结果为：

```swift
1
```



### BehaviorRelay

```swift
let relay = BehaviorRelay(value: "Initial value")
let disposeBag = DisposeBag()
relay.accept("New initial value")
relay.subscribe {
    print($0)
}.disposed(by: disposeBag)
```

输出结果为：

```swift
next(New initial value)
```













































