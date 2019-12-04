# Ring

原来写过这个blog，但在项目中实际要去实现一个ring的时候，发现自己还是没有理解其实现过程，所以在重写一遍，算是给自己一个教训

原来的文章地址是[iOS自定义控件二](https://blog.csdn.net/u014084081/article/details/53435252)

代码的出处来自[Custom Controls in iOS · Drawing With Layers](https://www.raywenderlich.com/4433-custom-controls-in-ios/lessons/5)，原来是Swift3写的，下载下来后还是要做一些修改，最终的效果如下：

![001](https://github.com/winfredzen/iOS-Basic/blob/master/UI/images/001.png)

运行的时候注意选择`Editor->Live View`

1.首先添加`backgroundLayer`，是一个灰色的ring

![002](https://github.com/winfredzen/iOS-Basic/blob/master/UI/images/002.png)

2.添加`foregroundLayer`，在`foregroundLayer`上添加一个渐变`gradientLayer`，此时效果如下

![003](https://github.com/winfredzen/iOS-Basic/blob/master/UI/images/003.png)

测试渐变会覆盖整个view

3.给`foregroundLayer`添加`mask`，给`foregroundMask`设path

```swift
    fileprivate private(set) lazy var foregroundMask: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = self.ringWidth
        layer.lineCap = CAShapeLayerLineCap.round
        return layer
    }()
```

```swift
    fileprivate private(set) lazy var foregroundLayer: CALayer = {
        let layer = CALayer()
        layer.addSublayer(gradientLayer)
        layer.mask = foregroundMask //mask
        return layer
    }()
```

![004](https://github.com/winfredzen/iOS-Basic/blob/master/UI/images/004.png)

4.通过上图可以发现，渐变有明显的分隔，这里的处理是将，`gradientLayer`做旋转

```swift
gradientLayer.setValue(getAngle(value: value), forKeyPath: CALayer.rotationKeyPath)
```

![005](https://github.com/winfredzen/iOS-Basic/blob/master/UI/images/005.png)

5.旋转后还有个问题，就是头部还有颜色突变，如何处理呢？

再添加一个`ringTipLayer`，这是一个小圆

![006](https://github.com/winfredzen/iOS-Basic/blob/master/UI/images/006.png)

在对整个小圆做旋转

![007](https://github.com/winfredzen/iOS-Basic/blob/master/UI/images/007.png)

这样就基本Over了



可以将ring的value设置的大于1，就表示有多个圈，如设置`ringLayer.value = 2.2`

![008](https://github.com/winfredzen/iOS-Basic/blob/master/UI/images/008.png)





