# Completable

参考：

+ [Completable](https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/rxswift_core/observable/completable.html)



`Completable`可以产生一个`completed`事件，或者`error`事件。适用于任务是否完成，不关心任务的返回值

`Completable`的定义如下:

```swift
public typealias Completable = PrimitiveSequence<CompletableTrait, Swift.Never>
```

`CompletableTrait`是一个枚举，只包含2个case，一个`error`，一个completed

```swift
public enum CompletableEvent {
    /// Sequence terminated with an error. (underlying observable sequence emits: `.error(Error)`)
    case error(Swift.Error)
    
    /// Sequence completed successfully.
    case completed
}
```

同样在`Completable.swift`文件中，对`PrimitiveSequenceType`进行了扩展，在其中定义了如下的方法：

```swift
//创建方法
public static func create(subscribe: @escaping (@escaping CompletableObserver) -> Disposable) -> PrimitiveSequence<Trait, Element>
//订阅方法
public func subscribe(_ observer: @escaping (CompletableEvent) -> Void) -> Disposable
public func subscribe(onCompleted: (() -> Void)? = nil, onError: ((Swift.Error) -> Void)? = nil) -> Disposable
```



## 例子

1.在Ray的RxSwift教程中，有一个是弹出一个Alert控制器的例子，如下：

```swift
extension UIViewController {
  func alert(title: String, text: String?) -> Completable {
    return Completable.create { [weak self] completable in
      let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
      alertVC.addAction(UIAlertAction(title: "Close", style: .default, handler: {_ in
        completable(.completed)
      }))
      self?.present(alertVC, animated: true, completion: nil)
      return Disposables.create {
        self?.dismiss(animated: true, completion: nil)
      }
    }
  }
}
```

在上面的`addAction`闭包中，调用的是`completable(.completed)`，表示的事件的完成

所以，这个弹出Alert的使用，如下：

```swift
  func showMessage(_ title: String, description: String? = nil) {
    //原来的使用方式
    /*
    let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { [weak self] _ in
                                    self?.dismiss(animated: true, completion: nil)
    }))
    present(alert, animated: true, completion: nil)
     */
    
    alert(title: title, text: description).subscribe().disposed(by: bag)
    
  }
```















