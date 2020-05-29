# Alamofire使用笔记

通常在使用的时候，对response的类型不怎么明了？response是什么类型呢？已如下的请求为例：

```swift
        AF.request("https://httpbin.org/get").response { response in
            
            print(type(of: response)) //DataResponse<Optional<Data>, AFError>
            
        }
```

输出结果为`DataResponse<Optional<Data>, AFError>`

如果使用`responseJSON`方法

```swift
        AF.request("https://swapi.dev/api/films").responseJSON { (response) in
            print(type(of: response)) //DataResponse<Any, AFError>
        }
```

