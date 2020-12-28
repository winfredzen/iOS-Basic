# Filter操作符



## **Ignoring operators**

**1.ignoreElements()**

ignoreElements会忽略掉所有的`Next`事件，允许stop事件通过，例如`completed` 或者 `error` 事件

![017](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/017.png)

```swift
let strikes = PublishSubject<String>()
let disposeBag = DisposeBag()
strikes.ignoreElements().subscribe { _ in
    print("You're out!")
}.disposed(by: disposeBag)
strikes.onNext("X")
strikes.onNext("X")
strikes.onNext("X")
strikes.onCompleted()
```

输出结果为：

```swift
You're out!
```



**2.elementAt**

还有一种情况是，需要处理emit的nth元素。

下面的图示中，`elementAt`中索引是1，所以只允许第二个元素通过

![018](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/018.png)

如下的例子：

```swift
let strikes = PublishSubject<String>()
let disposeBag = DisposeBag()
strikes.element(at: 1).subscribe(onNext: { event in
    print("onNext: " + event)
}, onCompleted: {
    print("You're out!")
}).disposed(by: disposeBag)
strikes.onNext("X")
strikes.onNext("XX")
strikes.onNext("XXX")
strikes.onCompleted()
```

输出结果如下：

```swift
onNext: XX
You're out!
```

> An interesting fact about element(at:): As soon as an element is emitted at the provided index, the subscription is terminated.
>
> 关于`element(at:)`的一个点是，一旦一个给定索引的element被emitted，这个subscription就被终止了



**3.filter**

`filter`如同名字表示的那样，就是过滤

![019](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/019.png)

```swift
let diposeBag = DisposeBag()
Observable.of(1, 2, 3, 4, 5, 6)
    .filter { $0.isMultiple(of: 2) }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: diposeBag)
```

输出结果为：

```swift
2
4
6
```



**4.skip**

`skip`操作符，可以跳过一些元素。如下面的图示，跳过最开始的2个元素，即忽略最开始的2个元素

![020](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/020.png)

如下的例子：

```swift
let diposeBag = DisposeBag()
Observable.of("A", "B", "C", "D", "E", "F")
    .skip(3)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: diposeBag)
```

输出结果为：

```swift
D
E
F
```



**5.skipWhile**

`true`时会导致元素被跳过，`false`时会通过，和`filter`相反

> **Remember, skip only skips elements up until the first element is let through, and then *all* remaining elements are allowed through.**
>
> skip跳过元素，直至第一个元素被通过，然后，所有剩下的元素都被允许通过

![021](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/021.png)

```swift
let diposeBag = DisposeBag()
Observable.of(2, 2, 3, 4, 4)
    .skipWhile({ $0.isMultiple(of: 2) })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: diposeBag)
```

输出结果为：

```swift
3
4
4
```



**6.skipUntil**

参考：

+ [skipUntil](https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/decision_tree/skipUntil.html)

> **跳过 `Observable` 中头几个元素，直到另一个 `Observable` 发出一个元素**

![022](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/022.png)

如下的例子：

```swift
let disposeBag = DisposeBag()
let subject = PublishSubject<String>()
let trigger = PublishSubject<String>()
subject.skipUntil(trigger).subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)
subject.onNext("A")
subject.onNext("B")
trigger.onNext("X")
subject.onNext("C")
```

输出结果为：

```swift
C
```



## **Taking operators**

take操作符合skip操作符相反

如下图示所示：

![023](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/023.png)

```swift
let disposeBag = DisposeBag()
Observable.of(1, 2, 3, 4, 5, 6)
    .take(2)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
```

输出结果为：

```swift
1
2
```



**1.takeWhile**

`takeWhile`与`skipWhile`类似

![024](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/024.png)

如下的例子，可使用`enumerated`操作符，来获取index和element

```swift
let disposeBag = DisposeBag()
Observable.of(2, 2, 4, 4, 6, 6)
    .enumerated()
    .takeWhile({index, integer in
        integer.isMultiple(of: 2) && index < 3
    })
    .map(\.element)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
```

输出结果为：

```swift
2
2
4
```

> 注意，这里的`takeWhile`返回的是元祖
>
> ![025](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/025.png)
>
> 使用`map`，取得其element



**2.takeUntil** 

>  takeUntil operator that will take elements *until* the predicate is met
>
> takeUntil操作符会采纳element，直至被满足条件

![026](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/026.png)

如下例子：

```swift
let disposeBag = DisposeBag()
Observable.of(1, 2, 3, 4, 5)
    .takeUntil(.inclusive, predicate: {
        $0.isMultiple(of: 4)
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
```

其输出结果为：

```swift
1
2
3
4
```

如果将`inclusive`修改为`exclusive`，输出结果为：

```swift
1
2
3
```



takeUntil也可以与一个trigger observale一起使用，如下的例子：

![027](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/027.png)

```swift
let disposeBag = DisposeBag()
let subject = PublishSubject<String>()
let trigger = PublishSubject<String>()
subject
    .takeUntil(trigger)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
subject.onNext("1")
subject.onNext("2")
trigger.onNext("X")
subject.onNext("3")
```

输出结果为：

```swift
1
2
```





## Distinct 

`distinctUntilChanged` 会阻止重复的数据通过，如下图所示：

![028](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/028.png)

```swift
let diposeBag = DisposeBag()
Observable.of("A", "A", "B", "B", "A")
    .distinctUntilChanged()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: diposeBag)
```

输出结果为：

```swift
A
B
A
```

上面的例子中的element是`String`，遵循`Equatable`协议

你也可以使用`distinctUntilChanged(_:)`，提供自定义的逻辑

![029](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/029.png)

如下的例子：

```swift
let diposeBag = DisposeBag()
let formatter = NumberFormatter()
formatter.numberStyle = .spellOut
Observable<NSNumber>.of(10, 110, 20, 200, 210, 310)
    .distinctUntilChanged {  a, b -> Bool in
        guard let aWords = formatter.string(from: a)?.components(separatedBy: " "),
              let bWords = formatter.string(from: b)?.components(separatedBy: " ") else {
            return false
        }
        var containsMatch = false
        
        for aWord in aWords where bWords.contains(aWord) {
            containsMatch = true
            break
        }
        return containsMatch
    }
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: diposeBag)
```

输出结果为：

```swift
10
20
200
```



## Demo

1.如下的拨打号码的例子：

```swift

        let disposeBag = DisposeBag()

        let contacts = [
          "603-555-1212": "Florent",
          "212-555-1212": "Junior",
          "408-555-1212": "Marin",
          "617-555-1212": "Scott"
        ]

        func phoneNumber(from inputs:[Int]) -> String {
            var phone = inputs.map(String.init).joined()
            phone.insert("-", at: phone.index(phone.startIndex, offsetBy: 3))
            phone.insert("-", at: phone.index(phone.startIndex, offsetBy: 7))
            return phone
        }

        let input = PublishSubject<Int>()

        input.skipWhile({ $0 == 0 })
            .filter({ $0 < 10 })
            .take(10)
            .toArray()
            .subscribe(onSuccess: {
                let phone = phoneNumber(from: $0)
                if let contact = contacts[phone] {
                  print("Dialing \(contact) (\(phone))...")
                } else {
                  print("Contact not found")
                }
            })
            .disposed(by: disposeBag)
        
        
        input.onNext(0)
        input.onNext(603)
        
        input.onNext(2)
        input.onNext(1)
        
        // Confirm that 7 results in "Contact not found", and then change to 2 and confirm that Junior is found
        input.onNext(2)
        
        "5551212".forEach {
          if let number = (Int("\($0)")) {
            input.onNext(number)
          }
        }
        
        input.onNext(9)
```

输出结果为：

```swift
Dialing Junior (212-555-1212)...
```











