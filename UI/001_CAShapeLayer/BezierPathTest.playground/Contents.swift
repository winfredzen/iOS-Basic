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
        
        //        createPath()
        createPath2()
    }
    
    
    
    func createPath2() {
        let starPath = UIBezierPath()
        starPath.move(to: CGPoint(x: 10, y: 100))
        starPath.addLine(to: CGPoint(x: 50, y: 100))
        let radius = CGFloat(60.0)
        var arcCenter = CGPoint(x: 50.0 + radius, y: 100.0)
        let startAngle = -CGFloat.pi
        let endAngle = CGFloat(0.0)
        let clockwise = true
        
        var openCirclePath = UIBezierPath(arcCenter: arcCenter,
                                          radius: radius,
                                          startAngle: startAngle,
                                          endAngle: endAngle,
                                          clockwise: clockwise)
        starPath.append(openCirclePath)
        starPath.addLine(to: CGPoint(x: 300, y: 100))
        
        let endPath = UIBezierPath()
        endPath.move(to: CGPoint(x: 10, y: 100))
        endPath.addLine(to: CGPoint(x: 100, y: 100))
        
        arcCenter = CGPoint(x: 100.0 + radius, y: 100.0)
        
        openCirclePath = UIBezierPath(arcCenter: arcCenter,
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: clockwise)
        endPath.append(openCirclePath)
        
        endPath.addLine(to: CGPoint(x: 300, y: 100))
        
        // Set an initial path
        shapeLayer.path = starPath.cgPath
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.toValue = endPath.cgPath
        pathAnimation.duration = 3.0
        pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pathAnimation.autoreverses = true
        pathAnimation.repeatCount = .greatestFiniteMagnitude
        
        shapeLayer.add(pathAnimation, forKey: "pathAnimation")
        
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
