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



`View`协议的定义如下：

```swift
/// A piece of user interface.
///
/// You create custom views by declaring types that conform to the `View`
/// protocol. Implement the required `body` property to provide the content
/// and behavior for your custom view.
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol View {

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required `body` property.
    associatedtype Body : View

    /// Declares the content and behavior of this view.
    var body: Self.Body { get }
}
```



在`Preview`中的Text上`Command+Click`，会弹出如下的气泡

![003](https://github.com/winfredzen/iOS-Basic/blob/master/SwiftUI/images/003.png)

选择`Inspect`，可自定义属性

![004](https://github.com/winfredzen/iOS-Basic/blob/master/SwiftUI/images/004.png)

在代码编辑器中也可以`Command+Click`，弹出如下的气泡

![005](https://github.com/winfredzen/iOS-Basic/blob/master/SwiftUI/images/005.png)



> To customize a SwiftUI view, you call methods called modifiers. Modifiers wrap a view to change its display or other properties. Each modifier returns a new view, so it’s common to chain multiple modifiers, stacked vertically.
>
> 要自定义SwiftUI视图，您可以调用称为修饰符(modifiers)的方法。 Modifiers包装视图以更改其显示或其他属性。 每个修饰符都会返回一个新视图，因此通常将多个修饰符垂直堆叠在一起。



## Stack

> When creating a SwiftUI view, you describe its content, layout, and behavior in the view’s body property; however, the body property only returns a single view. You can combine and embed multiple views in stacks, which group views together horizontally, vertically, or back-to-front.
>
> 创建SwiftUI视图时，可以在视图的body属性中描述其内容、布局和行为；但是，body属性只返回一个视图。您可以将多个视图组合并嵌入到Stack中，这些Stack将视图水平、垂直或从后到前分组在一起。



> By default, stacks center their contents along their axis and provide context-appropriate spacing.
>
> 默认情况下，Stack的内容沿其轴居中，并提供适当的上下文间距。



## Spacer

> A *spacer* expands to make its containing view use all of the space of its parent view, instead of having its size defined only by its contents.
>
> *spacer*展开后，使其包含的视图使用其父视图的所有空间，而不是仅由其内容定义其大小。



## 同时使用UIKit和SwiftUI视图

> To use UIView subclasses from within SwiftUI, you wrap the other view in a SwiftUI view that conforms to the UIViewRepresentable protocol. SwiftUI includes similar protocols for WatchKit and AppKit views.
>
> 要在SwiftUI中使用UIView子类，可以将另一个视图包装在符合`UIViewRepresentable`协议的SwiftUI视图中。SwiftUI为WatchKit和AppKit视图提供了类似的协议。



`UIViewRepresentable`协议如下：

```swift
public protocol UIViewRepresentable : View where Self.Body == Never {

    /// The type of `UIView` to be presented.
    associatedtype UIViewType : UIView

    /// Creates a `UIView` instance to be presented.
    func makeUIView(context: Self.Context) -> Self.UIViewType

    /// Updates the presented `UIView` (and coordinator) to the latest
    /// configuration.
    func updateUIView(_ uiView: Self.UIViewType, context: Self.Context)

    /// Cleans up the presented `UIView` (and coordinator) in
    /// anticipation of their removal.
    static func dismantleUIView(_ uiView: Self.UIViewType, coordinator: Self.Coordinator)

    /// A type to coordinate with the `UIView`.
    associatedtype Coordinator = Void

    /// Creates a `Coordinator` instance to coordinate with the
    /// `UIView`.
    ///
    /// `Coordinator` can be accessed via `Context`.
    func makeCoordinator() -> Self.Coordinator

    typealias Context = UIViewRepresentableContext<Self>
}
```

`UIViewRepresentable`协议有2个方法需要添加

+ `makeUIView(context:)` - 创建一个view来展示
+ `updateUIView(_:context:)` - 配置view，响应变化



## Landmarks效果

`MapView.swift`

```swift
import MapKit

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
        latitude: 34.011286, longitude: -116.166868)
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
```

`CircleImage.swift`

```swift
import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image.init("turtlerock")
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
```

`ContentView.swift`

```swift

struct ContentView: View {
    var body: some View {
        VStack {
            
            MapView()
                .edgesIgnoringSafeArea(.top) //延伸到屏幕顶部
                .frame(height: 300)
            
            CircleImage().offset(y: -130).padding(.bottom, -130)
            
            VStack(alignment:.leading) {
                Text("Turtle Rock").font(.title)
                HStack {
                    Text("Joshua Tree National Park").font(.subheadline)
                    Spacer()
                    Text("California").font(.subheadline)
                }
            }
            .padding()
            
            Spacer() //将内容推到top
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

```

最终的效果

![002](https://github.com/winfredzen/iOS-Basic/blob/master/SwiftUI/images/002.png)









