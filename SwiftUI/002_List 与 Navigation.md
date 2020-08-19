# List 与 Navigation

内容来自Apple官方教程：

+ [Building Lists and Navigation](https://developer.apple.com/tutorials/swiftui/building-lists-and-navigation)



创建一个Row视图，表示的列表的每一项内容`LandmarkRow`

```swift
struct LandmarkRow: View {
    
    var landmark: Landmark
    
    var body: some View {
        HStack {
            landmark.image.resizable().frame(width: 50, height: 50)
            Text(landmark.name)
            Spacer()
        }
    }
}

struct LandmarkRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LandmarkRow(landmark: landmarkData[0])
            LandmarkRow(landmark: landmarkData[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
```

![006](https://github.com/winfredzen/iOS-Basic/blob/master/SwiftUI/images/006.png)

`previewLayout`方法的定义如下：

```swift
    /// Overrides the size of the container for the preview.
    ///
    /// Default is `.device`.
    @inlinable public func previewLayout(_ value: PreviewLayout) -> some View
```

可以重写预览container的大小

`PreviewLayout`是一个枚举，带有关联值

```swift
/// The size constraint for a preview.
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public enum PreviewLayout {

    /// Centers the preview in a container the size of the device the preview
    /// is running on.
    case device

    /// Fits the container to the size of the preview (when offered the size
    /// of the device the preview is running on).
    case sizeThatFits

    /// Centers the preview in a fixed size container.
    case fixed(width: CGFloat, height: CGFloat)
}
```



可以使用`Group`在preview provider中返回多个预览视图

> `Group` is a container for grouping view content. Xcode renders the group’s child views as separate previews in the canvas.

上面的`Group`等同于

```swift
        Group {
            LandmarkRow(landmark: landmarkData[0])
                .previewLayout(.fixed(width: 300, height: 70))
            LandmarkRow(landmark: landmarkData[1])
                .previewLayout(.fixed(width: 300, height: 70))
        }
```

是由于

> A view’s children inherit the view’s contextual settings, such as preview configurations.
>
> 一个view的children继承这个view的上下文设置



使用SwiftUI的`List`类型，可以显示一个列表

> The elements of the list can be static, like the child views of the stacks you’ve created so far, or dynamically generated. You can even mix static and dynamically generated views.
>
> list中的元素可以是静态，也可动态生成，甚至可以混合使用



如下的静态的列表：

```swift
struct LandmarkList: View {
    var body: some View {
        List {
            LandmarkRow(landmark: landmarkData[0])
            LandmarkRow(landmark: landmarkData[1])
        }
    }
}
```

![007](https://github.com/winfredzen/iOS-Basic/blob/master/SwiftUI/images/007.png)



除了单独指定列表的元素，也可以直接从集合中生成row

通过传递数据集合和为每个元素提供view的闭包。列表使用提供的闭包将集合中的每个元素转换为子视图。

> Lists work with *identifiable* data. You can make your data identifiable in one of two ways: by passing along with your data a key path to a property that uniquely identifies each element, or by making your data type conform to the `Identifiable` protocol.
>
> List需要*identifiable*数据，有2中方式
>
> 1.使用属性的keyPath
>
> ```swift
> struct LandmarkList: View {
>     var body: some View {
>         List(landmarkData, id: \.id) { landmark in
>             LandmarkRow(landmark: landmark)
>         }
>     }
> }
> ```
>
> `\.id`表示的是keypath
>
> 2.data类型遵循`Identifiable`协议
>
> ![008](https://github.com/winfredzen/iOS-Basic/blob/master/SwiftUI/images/008.png)
>
> 遵循`Identifiable`协议后，就可以移除`id`参数了，如下：
>
> ```swift
> struct LandmarkList: View {
>     var body: some View {
>         List(landmarkData) { landmark in
>             LandmarkRow(landmark: landmark)
>         }
>     }
> }
> ```
>
> 



> You add navigation capabilities to a list by embedding it in a `NavigationView`, and then nesting each row in a `NavigationLink` to set up a transtition to a destination view.
>
> 可以将list嵌入在`NavigationView`中来添加导航的功能，将row嵌入在 `NavigationLink`中来设置过渡到destination view



通过调用`navigationBarTitle(_:)`设置导航栏的标题

```swift
struct LandmarkList: View {
    var body: some View {
        NavigationView {
            List(landmarkData) { landmark in
                NavigationLink(destination: LandmarkDetail(landmark: landmark)) {
                    LandmarkRow(landmark: landmark)
                }
            }
            .navigationBarTitle(Text("Landmarks"))
        }
    }
}
```

最终的效果如下：

![009](https://github.com/winfredzen/iOS-Basic/blob/master/SwiftUI/images/009.png)

![010](https://github.com/winfredzen/iOS-Basic/blob/master/SwiftUI/images/010.png)



**动态生成预览视图**

```swift
struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            LandmarkList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
```





















