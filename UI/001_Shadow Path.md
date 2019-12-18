#  Shadow Path

内容来自:

+ [Advanced UIView shadow effects using shadowPath](https://www.hackingwithswift.com/articles/155/advanced-uiview-shadow-effects-using-shadowpath)

最简单的path，矩形的path:

```swift
        vw.layer.shadowPath = UIBezierPath(rect: vw.bounds).cgPath
        vw.layer.shadowRadius = 5
        vw.layer.shadowOffset = .zero
        vw.layer.shadowOpacity = 1
```

![010](https://github.com/winfredzen/iOS-Basic/blob/master/UI/images/010.png)

### Contact shadows

`Contact shadows`应该是指底部接触的阴影，阴影的坐标，应该是相对与view来说的

```swift
        let shadowSize: CGFloat = 20
        let contactRect = CGRect(x: -shadowSize,
                                 y: height - (shadowSize * 0.4),
                                 width: width + shadowSize * 2,
                                 height: shadowSize)
        vw.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        vw.layer.shadowRadius = 5
        vw.layer.shadowOpacity = 0.4
```

![011](https://github.com/winfredzen/iOS-Basic/blob/master/UI/images/011.png)



### Depth shadows

```swift
        let shadowRadius: CGFloat = 5

        // how wide and high the shadow should be, where 1.0 is identical to the view
        let shadowWidth: CGFloat = 1.25
        let shadowHeight: CGFloat = 0.5

        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: shadowRadius / 2, y: height - shadowRadius / 2))
        shadowPath.addLine(to: CGPoint(x: width - shadowRadius / 2, y: height - shadowRadius / 2))
        shadowPath.addLine(to: CGPoint(x: width * shadowWidth, y: height + (height * shadowHeight)))
        shadowPath.addLine(to: CGPoint(x: width * -(shadowWidth - 1), y: height + (height * shadowHeight)))
        vw.layer.shadowPath = shadowPath.cgPath
        vw.layer.shadowRadius = shadowRadius
        vw.layer.shadowOffset = .zero
        vw.layer.shadowOpacity = 0.2
```

![012](https://github.com/winfredzen/iOS-Basic/blob/master/UI/images/012.png)



