# Cannot assign through subscript: 'self' is immutable

在项目中出现`Cannot assign through subscript: 'self' is immutable`这样的错误提示

原因是修改自身，如下：

```swift
    var appendToken: Parameters { //字典中添加token
        if let token = AuthTool.userToken {
            var param = self
            self["token"] = token //错误，Cannot assign through subscript: 'self' is immutable
            return param
        }
        return self
    }
```

原因是：

self是不可变得

怎样解决呢？

参考：

+ [Cannot assign through subscript: 'dict' is a 'let' constant](https://stackoverflow.com/questions/47310863/cannot-assign-through-subscript-dict-is-a-let-constant)

如上链接中，由于方法的参数是不可变的，所以在方法中修改参数也会提示类似的错误

错误代码：

```swift
var dictAges : [String: Int] = ["John":40, "Michael":20, "Bob": -16]

func correctAges(dict:[String:Int]) {
     for (name, age) in dict {
          guard age >= 0 else {
          dict[name] = 0
          continue
          }
     }
}
correctAges(dict:dictAges)
```

正确的代码：

```swift
var dictAges : [String: Int] = ["John":40, "Michael":20, "Bob": -16]

func correctAges(dict:[String:Int])->[String:Int] {
     var mutatedDict = dict
     for (name, age) in mutatedDict {
          guard age >= 0 else {
              mutatedDict[name] = 0
              continue
          }
     }
     return mutatedDict
}
let newDict = correctAges(dict:dictAges) //["Michael": 20, "Bob": 0, "John": 40]
```

或者使用`inout`

```swift
func correctAges(dict: inout [String:Int]){
    for (name,age) in dict {
        guard age >= 0 else {
            dict[name] = 0
            continue
        }
    }
}

correctAges(dict: &dictAges) //["Michael": 20, "Bob": 0, "John": 40]
```













