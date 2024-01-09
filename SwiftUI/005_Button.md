# Button

最简单的创建一个Button的方式是使用默认Text样式，如下：

```swift
            Button("Regular Button") {
                
            }
```

另一种方式是自定义button的content：

```swift
            Button {
                
            } label: {
                Text("Regular Button").bold()
            }
```

![036](./images/036.png)







