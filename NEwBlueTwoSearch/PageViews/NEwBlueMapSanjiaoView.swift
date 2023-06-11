//
//  NEwBlueMapSanjiaoView.swift
//  NEwBlueTwoSearch
//
//  Created by Joe on 2023/6/10.
//

import UIKit


class NEwBlueDeviceDegreeScaleV: UIView {
    
    /// 背景视图
    private lazy var backgroundView: UIView = {
        let v = UIView(frame: bounds)
        return v
    }()
    
    /// 水平视图
//    private lazy var levelView: UIView = {
//        let levelView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width / 2 - 50, height: 1))
//        levelView.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
////        levelView.backgroundColor = .white
//        levelView.backgroundColor = .clear
//        return levelView
//    }()
    
    /// 垂直视图
//    private lazy var verticalView: UIView = {
//        let verticalView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: self.frame.size.height / 2 - 50))
//        verticalView.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
////        verticalView.backgroundColor = .white
//        verticalView.backgroundColor = .clear
//        return verticalView
//    }()
    
    /// 指针视图
//    private lazy var lineView: UIView = {
//        let lineView = UIView(frame: CGRect(x: self.frame.size.width / 2 - 1.5, y: 20, width: 3, height: 60))
////        lineView.backgroundColor = .white
//        lineView.backgroundColor = .clear
//        return lineView
//    }()
    
    /// 指南针三角视图
//    private lazy var compassTriangleView: UIView = {
//        let screenW: CGFloat = 200
//        let triangle = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenW))
//        triangle.backgroundColor = .clear
//        return triangle
//    }()
    
    /// 红色三角视图
    private lazy var redTriangleView = UIView()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        layer.cornerRadius = frame.size.width / 2
        addSubview(backgroundView)
        configScaleDial()
//        addSubview(levelView)
//        addSubview(verticalView)
//        insertSubview(lineView, at: 0)
//        addSubview(compassTriangleView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum MoveDirection {
    case east
    case eastN
    case eastS
    case west
    case westN
    case westS
    case nort
    case sorth
}


//MARK: - Update multiple times
extension NEwBlueDeviceDegreeScaleV {
    
    /// 计算中心坐标
    ///
    /// - Parameters:
    ///   - center: 中心点
    ///   - angle: 角度
    ///   - scale: 刻度
    /// - Returns: CGPoint
    private func calculateTextPositon(withArcCenter center: CGPoint, andAngle angle: CGFloat, andScale scale: CGFloat) -> CGPoint {
        let x = (self.frame.size.width / 2 - 50) * scale * CGFloat(cosf(Float(angle)))
        let y = (self.frame.size.width / 2 - 50) * scale * CGFloat(sinf(Float(angle)))
        return CGPoint(x: center.x + x, y: center.y + y)
    }
    
    /// 旋转重置刻度标志的方向
    ///
    /// - Parameter heading: 航向
    public func resetDirection(_ heading: CGFloat) {
        debugPrint("heading = \(heading)")
        backgroundView.transform = CGAffineTransform(rotationAngle: heading)
//        for label in backgroundView.subviews {
//            backgroundView.subviews[1].transform = .identity    // 红色三角视图，不旋转。
//            label.transform = CGAffineTransform(rotationAngle: -heading)
//        }
    }
    
}

//MARK: - Configure
extension NEwBlueDeviceDegreeScaleV {
    
    /// 配置刻度表
    private func configScaleDial() {
        
        /// 360度
        let degree_360: CGFloat = CGFloat.pi
        
        /// 180度
        let degree_180: CGFloat = degree_360 / 2
        
        /// 角度
        let angle: CGFloat = degree_360 / 90
        
        /// 方向数组
        let directionArray = ["N", "E", "S", "W"]
        
        /// 点
        let po = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        
        //画圆环，每隔2°画一个弧线，总共180条
        for i in 0 ..< 180 {
            
            /// 开始角度
            let startAngle: CGFloat = -(degree_180 + degree_360 / 180 / 2) + angle * CGFloat(i)
            
            /// 结束角度
            let endAngle: CGFloat = startAngle + angle / 2
            
            // 创建一个路径对象
            //            let bezPath = UIBezierPath(arcCenter: po, radius: frame.size.width / 2 - 70, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            /// 形变图层
            //            let shapeLayer = CAShapeLayer()
            
            if i % 15 == 0 {
                // 设置描边色
                //                shapeLayer.strokeColor = UIColor.white.cgColor
                //                shapeLayer.strokeColor = UIColor.clear.cgColor
                //                shapeLayer.lineWidth = 20
                //            }else {
                ////                shapeLayer.strokeColor = UIColor.gray.cgColor
                //                shapeLayer.strokeColor = UIColor.clear.cgColor
                //                shapeLayer.lineWidth = 20
                //            }
                //            shapeLayer.path = bezPath.cgPath
                //            shapeLayer.fillColor = UIColor.clear.cgColor    // 设置填充路径色
                //            backgroundView.layer.addSublayer(shapeLayer)
                
                // 刻度的标注
                if i % 15 == 0 {
                    /// 刻度的标注 0 30 60...
                    var tickText = "\(i * 2)"
                    
                    let textAngle: CGFloat = startAngle + (endAngle - startAngle) / 2
                    
                    let point: CGPoint = calculateTextPositon(withArcCenter: po, andAngle: textAngle, andScale: 1.15)
                    
                    // UILabel
                    //                let label = UILabel(frame: CGRect(x: point.x, y: point.y, width: 30, height: 20))
                    //                label.center = point
                    //                label.text = tickText
                    ////                label.textColor = .white
                    //                label.textColor = .clear
                    //                label.font = UIFont.systemFont(ofSize: 15)
                    //                label.textAlignment = .center
                    //                backgroundView.addSubview(label)
                    
                    if i % 45 == 0 {    //北 东 南 西
                        tickText = directionArray[i / 45]
                        
                        //                    let point2: CGPoint = calculateTextPositon(withArcCenter: po, andAngle: textAngle, andScale: 0.65)
                        // UILabel
                        //                    let label2 = UILabel(frame: CGRect(x: point2.x, y: point2.y, width: 30, height: 30))
                        //                    label2.center = point2
                        //                    label2.text = tickText
                        ////                    label2.textColor = .white
                        //                    label2.textColor = .clear
                        //                    label2.font = UIFont.systemFont(ofSize: 27)
                        //                    label2.textAlignment = .center
                        
                        if tickText == "N" {
                            DrawRedTriangleView(point)
                        }
                        //                    backgroundView.addSubview(label2)
                    }
                }
            }
        }
        
        /// 绘制红色三角形视图
         func DrawRedTriangleView(_ point: CGPoint) {
            let triwidth: CGFloat = 32
             let trihei: CGFloat = 43
            //
            redTriangleView = UIView(frame: CGRect(x: point.x, y: point.y, width: triwidth, height: trihei))
            redTriangleView.center = CGPoint(x: point.x, y: point.y)
            redTriangleView.backgroundColor = .clear
            backgroundView.addSubview(redTriangleView)
            //
             let arroImgV = UIImageView(frame: CGRect(x: 0, y: 0, width: triwidth, height: trihei))
             arroImgV.image("positionarrow")
             arroImgV.contentMode(.scaleAspectFit)
             redTriangleView.addSubview(arroImgV)
//             64 × 86
//
             
            // 画三角
//            let trianglePath = UIBezierPath()
//            var point = CGPoint(x: 0 + 4, y: triwidth)
//            trianglePath.move(to: point)
//            point = CGPoint(x: triwidth / 2, y: 0)
//            trianglePath.addLine(to: point)
//            point = CGPoint(x: triwidth - 4, y: triwidth)
//            trianglePath.addLine(to: point)
//            trianglePath.close()
//            let triangleLayer = CAShapeLayer()
//            triangleLayer.path = trianglePath.cgPath
//            triangleLayer.fillColor = UIColor(hexString: "#FF6262")!.cgColor
//            redTriangleView.layer.addSublayer(triangleLayer)
        }
        
    }
}
