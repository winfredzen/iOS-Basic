# SwiftUI入门

参考官方教程：

+ [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui/creating-and-combining-views)

创建SwiftUI项目，`User Interface`需要选择`SwiftUI`

![创建SwiftUI项目](https://github.com/winfredzen/iOS-Basic/blob/master/SwiftUI/images/001.png)

SwiftUI view文件声明有2个struct，第一个struct遵循`View`协议，描述view的内容和布局。第二个struct，声明该视图的预览

```swift
struct ContentView: View {
    var body: some View {
        Text("Hello World")
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

一般来说右侧会出现预览的view，如果没有出现，在**Editor**中勾选`Canvas`

