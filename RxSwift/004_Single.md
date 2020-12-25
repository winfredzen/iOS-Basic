# Single

参考：

+ [Single](https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/rxswift_core/observable/single.html)



> **Single** 是 `Observable` 的另外一个版本。不像 `Observable` 可以发出多个元素，它要么只能发出一个元素，要么产生一个 `error` 事件。

看下Single的定义，在`Single.swift`文件中，有如下的内容：

```swift
public typealias Single<Element> = PrimitiveSequence<SingleTrait, Element>
```

`SingleTrait`是一个enum，定义如下：

```swift
public enum SingleEvent<Element> {
    /// One and only sequence element is produced. (underlying observable sequence emits: `.next(Element)`, `.completed`)
    case success(Element)
    
    /// Sequence terminated with an error. (underlying observable sequence emits: `.error(Error)`)
    case error(Swift.Error)
}
```



在`Single.swift`文件中，扩展了`PrimitiveSequenceType`，使用了`where`对`Trait`进行了限制

```swift
extension PrimitiveSequenceType where Trait == SingleTrait
```

其中包含的方法有：

```swift
//创建一个observable sequence
public static func create(subscribe: @escaping (@escaping SingleObserver) -> Disposable) -> Single<Element>
```

+ `subscribe` - 闭包，`(@escaping SingleObserver) -> Disposable`
+ `SingleObserver` - 也是一个闭包，`public typealias SingleObserver = (SingleEvent<Element>) -> Void`。其中的`SingleEvent`就是上面的枚举



```swift
//订阅“observer”以接收此序列的事件。
public func subscribe(_ observer: @escaping (SingleEvent<Element>) -> Void) -> Disposable
```

```swift
public func subscribe(onSuccess: ((Element) -> Void)? = nil, onError: ((Swift.Error) -> Void)? = nil) -> Disposable
```



## 例子

上面链接中网络请求的例子：

```swift
extension MainViewController {
  
  //测试single
  
  enum DataError: Error {
    case cantParseJSON
  }
  
  
  func getRepo(_ repo: String) -> Single<[String : Any]> {
    
    return Single.create { single -> Disposable in
      
      let url = URL(string: "https://api.github.com/repos/\(repo)")!
      let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        if let error = error {
          single(.error(error))
          return
        }
        
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
              let result = json as? [String : Any] else {
          single(.error(DataError.cantParseJSON))
          return
        }
        
        single(.success(result))
        
      }
      
      task.resume()
      
      
      return Disposables.create { task.cancel() }
      
    }
    
  }
  
  
}

    getRepo("ReactiveX/RxSwift")
      .subscribe(onSuccess: { json in
        print("JSON: ", json)
      },
      onError: { error in
        print("Error: ", error)
      })
      .disposed(by: bag)
```

这里的回调也是在子线程的

![015](https://github.com/winfredzen/iOS-Basic/blob/master/RxSwift/images/015.png)











