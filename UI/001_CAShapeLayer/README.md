# CAShapeLayer

关于CAShapeLayer的一些介绍可参考如下的链接，感觉很经典：

+ [CAShapeLayer in Depth, Part I](https://www.calayer.com/core-animation/2016/05/22/cashapelayer-in-depth.html)
+ [CAShapeLayer in Depth, Part II](https://www.calayer.com/core-animation/2017/12/25/cashapelayer-in-depth-part-ii.html)



## Path动画

path可以修改形状

> What this means is that “on-line” points—those that are explicitly specified as part of a path’s description—are interpolated by moving them in a straight line from their starting positions to their ending positions. On the other hand, “off-line” points—those that are calculated or inferred as intermediary points between “on-line” points—are potentially interpolated using more complex means, the details of which are not made available to us.
>
> 这就是说，“在线”点（在路径描述中明确指定的点）是通过沿直线从其起始位置移动到其终点位置进行插值的。 另一方面，“离线”点（那些被计算或推断为“在线”点之间的中间点的点）可能会使用更复杂的方法进行插值，其详细信息无法提供给我们。



如下的例子：

```swift
import UIKit
import PlaygroundSupport

class BezierPathView: UIView {
    
    let shapeLayer: CAShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        shapeLayer.frame = self.bounds.insetBy(dx: 20, dy: 20)
        shapeLayer.backgroundColor = UIColor.green.cgColor
        self.layer.addSublayer(shapeLayer)
        shapeLayer.strokeColor  = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.borderWidth = 5.0
        shapeLayer.lineWidth = 10.0
        shapeLayer.lineJoin = .bevel
        
        createPath()
    }
    
    func createPath()  {
        let starPath = UIBezierPath()
        starPath.move(to: CGPoint(x: 81.5, y: 7.0))
        starPath.addLine(to: CGPoint(x: 101.07, y: 63.86))
        starPath.addLine(to: CGPoint(x: 163.0, y: 64.29))
        starPath.addLine(to: CGPoint(x: 113.16, y: 99.87))
        starPath.addLine(to: CGPoint(x: 131.87, y: 157.0))
        starPath.addLine(to: CGPoint(x: 81.5, y: 122.13))
        starPath.addLine(to: CGPoint(x: 31.13, y: 157.0))
        starPath.addLine(to: CGPoint(x: 49.84, y: 99.87))
        starPath.addLine(to: CGPoint(x: 0.0, y: 64.29))
        starPath.addLine(to: CGPoint(x: 61.93, y: 63.86))
        starPath.addLine(to: CGPoint(x: 81.5, y: 7.0))
        starPath.close()

        let rectanglePath = UIBezierPath()
        rectanglePath.move(to: CGPoint(x: 81.5, y: 7.0))
        rectanglePath.addLine(to: CGPoint(x: 163.0, y: 7.0))
        rectanglePath.addLine(to: CGPoint(x: 163.0, y: 82.0))
        rectanglePath.addLine(to: CGPoint(x: 163.0, y: 157.0))
        rectanglePath.addLine(to: CGPoint(x: 163.0, y: 157.0))
        rectanglePath.addLine(to: CGPoint(x: 82.0, y: 157.0))
        rectanglePath.addLine(to: CGPoint(x: 0.0, y: 157.0))
        rectanglePath.addLine(to: CGPoint(x: 0.0, y: 157.0))
        rectanglePath.addLine(to: CGPoint(x: 0.0, y: 82.0))
        rectanglePath.addLine(to: CGPoint(x: 0.0, y: 7.0))
        rectanglePath.addLine(to: CGPoint(x: 81.5, y: 7.0))
        rectanglePath.close()

        // Set an initial path
        shapeLayer.path = starPath.cgPath

        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.toValue = rectanglePath.cgPath
        pathAnimation.duration = 3.0
        pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pathAnimation.autoreverses = true
        pathAnimation.repeatCount = .greatestFiniteMagnitude

        shapeLayer.add(pathAnimation, forKey: "pathAnimation")
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

let pathView = BezierPathView(frame: CGRect(x: 0, y: 0, width: 400, height: 800))
pathView.backgroundColor = .white
PlaygroundPage.current.liveView = pathView
```























