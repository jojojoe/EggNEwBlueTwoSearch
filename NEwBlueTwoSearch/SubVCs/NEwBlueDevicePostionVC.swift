//
//  NEwBlueDevicePostionVC.swift
//  NEwBlueTwoSearch
//
//  Created by JOJO on 2023/6/6.
//

import UIKit
import MapKit
import CoreLocation


/// 刻度视图
class BSiegMapDegreeScaleV: UIView {
    
    /// 背景视图
    private lazy var backgroundView: UIView = {
        let v = UIView(frame: bounds)
        return v
    }()
    
    /// 水平视图
    private lazy var levelView: UIView = {
        let levelView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width / 2 - 50, height: 1))
        levelView.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
//        levelView.backgroundColor = .white
        levelView.backgroundColor = .clear
        return levelView
    }()
    
    /// 垂直视图
    private lazy var verticalView: UIView = {
        let verticalView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: self.frame.size.height / 2 - 50))
        verticalView.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
//        verticalView.backgroundColor = .white
        verticalView.backgroundColor = .clear
        return verticalView
    }()
    
    /// 指针视图
    private lazy var lineView: UIView = {
        let lineView = UIView(frame: CGRect(x: self.frame.size.width / 2 - 1.5, y: 20, width: 3, height: 60))
//        lineView.backgroundColor = .white
        lineView.backgroundColor = .clear
        return lineView
    }()
    
    /// 指南针三角视图
    private lazy var compassTriangleView: UIView = {
        let screenW: CGFloat = 200
        let triangle = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenW))
        triangle.backgroundColor = .clear
        return triangle
    }()
    
    /// 红色三角视图
    private lazy var redTriangleView = UIView()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        layer.cornerRadius = frame.size.width / 2
        addSubview(backgroundView)
        addSubview(levelView)
        addSubview(verticalView)
        insertSubview(lineView, at: 0)
        configScaleDial()
        addSubview(compassTriangleView)
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
extension BSiegMapDegreeScaleV {
    
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
        backgroundView.transform = CGAffineTransform(rotationAngle: heading)
        for label in backgroundView.subviews {
            backgroundView.subviews[1].transform = .identity    // 红色三角视图，不旋转。
            label.transform = CGAffineTransform(rotationAngle: -heading)
        }
    }
    
}

//MARK: - Configure
extension BSiegMapDegreeScaleV {
    
    /// 配置刻度表
    private func configScaleDial() {
        
        /// 360度
        let degree_360: CGFloat = CGFloat.pi
        
        /// 180度
        let degree_180: CGFloat = degree_360 / 2
        
        /// 角度
        let angle: CGFloat = degree_360 / 90
        
        /// 方向数组
        let directionArray = ["北", "东", "南", "西"]
        
        /// 点
        let po = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        
        //画圆环，每隔2°画一个弧线，总共180条
        for i in 0 ..< 180 {
            
            /// 开始角度
            let startAngle: CGFloat = -(degree_180 + degree_360 / 180 / 2) + angle * CGFloat(i)
            
            /// 结束角度
            let endAngle: CGFloat = startAngle + angle / 2
            
            // 创建一个路径对象
            let bezPath = UIBezierPath(arcCenter: po, radius: frame.size.width / 2 - 70, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            /// 形变图层
            let shapeLayer = CAShapeLayer()
            
            if i % 15 == 0 {
                // 设置描边色
//                shapeLayer.strokeColor = UIColor.white.cgColor
                shapeLayer.strokeColor = UIColor.clear.cgColor
                shapeLayer.lineWidth = 20
            }else {
//                shapeLayer.strokeColor = UIColor.gray.cgColor
                shapeLayer.strokeColor = UIColor.clear.cgColor
                shapeLayer.lineWidth = 20
            }
            shapeLayer.path = bezPath.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor    // 设置填充路径色
            backgroundView.layer.addSublayer(shapeLayer)
            
            // 刻度的标注
            if i % 15 == 0 {
                /// 刻度的标注 0 30 60...
                var tickText = "\(i * 2)"
                
                let textAngle: CGFloat = startAngle + (endAngle - startAngle) / 2
                
                let point: CGPoint = calculateTextPositon(withArcCenter: po, andAngle: textAngle, andScale: 1.15)
                
                // UILabel
                let label = UILabel(frame: CGRect(x: point.x, y: point.y, width: 30, height: 20))
                label.center = point
                label.text = tickText
//                label.textColor = .white
                label.textColor = .clear
                label.font = UIFont.systemFont(ofSize: 15)
                label.textAlignment = .center
                backgroundView.addSubview(label)
                
                if i % 45 == 0 {    //北 东 南 西
                    tickText = directionArray[i / 45]
                    
                    let point2: CGPoint = calculateTextPositon(withArcCenter: po, andAngle: textAngle, andScale: 0.65)
                    // UILabel
                    let label2 = UILabel(frame: CGRect(x: point2.x, y: point2.y, width: 30, height: 30))
                    label2.center = point2
                    label2.text = tickText
//                    label2.textColor = .white
                    label2.textColor = .clear
                    label2.font = UIFont.systemFont(ofSize: 27)
                    label2.textAlignment = .center
                    
                    if tickText == "北" {
                        DrawRedTriangleView(point)
                    }
                    backgroundView.addSubview(label2)
                }
            }
        }
    }
    
    /// 绘制红色三角形视图
    private func DrawRedTriangleView(_ point: CGPoint) {
        let triwidth: CGFloat = 34
        
        
        redTriangleView = UIView(frame: CGRect(x: point.x, y: point.y, width: triwidth, height: triwidth))
        redTriangleView.center = CGPoint(x: point.x, y: point.y)
        redTriangleView.backgroundColor = .clear
        backgroundView.addSubview(redTriangleView)
        
        
        // 画三角
        
        
        let trianglePath = UIBezierPath()
        var point = CGPoint(x: 0 + 4, y: triwidth)
        trianglePath.move(to: point)
        point = CGPoint(x: triwidth / 2, y: 0)
        trianglePath.addLine(to: point)
        point = CGPoint(x: triwidth - 4, y: triwidth)
        trianglePath.addLine(to: point)
        trianglePath.close()
        let triangleLayer = CAShapeLayer()
        triangleLayer.path = trianglePath.cgPath
        triangleLayer.fillColor = UIColor(hexString: "#3971FF")!.cgColor
        redTriangleView.layer.addSublayer(triangleLayer)
    }
    
}

class NEwBlueDevicePostionVC: UIViewController {

    let mapView: MKMapView = MKMapView()
    let tiNameLabel = UILabel()
    let infoDevNameLabel = UILabel()
    let infoPostionLabel = UILabel()
    var bluetoothDevice: NEwPeripheralItem
    let locationManager:CLLocationManager = CLLocationManager()
    var firstDisplay = true
    var mapDegree: BSiegMapDegreeScaleV!
    var currentDirection: MoveDirection = .nort
    var currentOffsetRotate: CGFloat = 0
    var currentCachaRssi: Double = 0
    
    var refreshWating: Bool = false
    var currentHeadi: Float = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    init(bluetoothDevice: NEwPeripheralItem) {
        self.bluetoothDevice = bluetoothDevice
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingHeading()   // 停止获得航向数据，省电
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    deinit {
        locationManager.stopUpdatingHeading()   // 停止获得航向数据，省电
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = .standard
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        
        //
        locationManager.delegate = self
        locationManager.distanceFilter = 0
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        setupV()
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.headingAvailable() {
//            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
        //
        let degreeWidth: CGFloat = 240
        mapDegree = BSiegMapDegreeScaleV(frame: CGRect(x: (UIScreen.main.bounds.size.width - degreeWidth)/2, y: (UIScreen.main.bounds.size.height - UIScreen.main.bounds.size.width) / 2, width: degreeWidth, height: degreeWidth))
        view.addSubview(mapDegree)
        mapDegree.isUserInteractionEnabled = false
        mapDegree.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupLocationPositionNow()
    }
    
    func setupLocationPositionNow() {
        
        
        
    }
    
    func setupV() {
        view.clipsToBounds = true
        //
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        let backB = UIButton()
        view.addSubview(backB)
        backB.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.width.height.equalTo(44)
        }
        backB.setImage(UIImage(named: "nav_back"), for: .normal)
        backB.addTarget(self, action: #selector(backBClick(sender: )), for: .touchUpInside)
        
        //
        
        view.addSubview(tiNameLabel)
        tiNameLabel.snp.makeConstraints {
            $0.left.equalTo(backB.snp.right).offset(20)
            $0.centerY.equalTo(backB.snp.centerY).offset(0)
            $0.centerX.equalToSuperview()
            $0.height.greaterThanOrEqualTo(17)
        }
        tiNameLabel.lineBreakMode = .byTruncatingTail
        tiNameLabel.text = bluetoothDevice.deviceName
        tiNameLabel.textAlignment = .center
        tiNameLabel.textColor = UIColor(hexString: "#242766")
        tiNameLabel.font = UIFont(name: "Poppins-Bold", size: 24)
        
        //
        setupSearchAgainV()
    }
    
    func setupSearchAgainV() {
        //
        let bottomBar = UIView()
        view.addSubview(bottomBar)
        bottomBar.backgroundColor = .clear
        bottomBar.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(190)
        }
        bottomBar.layer.cornerRadius = 30
        bottomBar.addShadow(ofColor: UIColor(hexString: "#2B2F3C")!, radius: 40, offset: CGSize(width: 0, height: -5), opacity: 0.1)
        //
        let bottomBgImgv = UIImageView()
        bottomBar.addSubview(bottomBgImgv)
        bottomBgImgv.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        bottomBgImgv.image = UIImage(named: "mapbottom")
        //
        let founditBtn = UIButton()
        bottomBar.addSubview(founditBtn)
        founditBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().offset(30)
            $0.bottom.equalToSuperview().offset(-40)
            $0.height.equalTo(60)
        }
        founditBtn.backgroundColor = UIColor(hexString: "#3971FF")
        founditBtn.layer.cornerRadius = 30
        founditBtn.clipsToBounds = true
        founditBtn.setTitle("I Found It!", for: .normal)
        founditBtn.setTitleColor(.white, for: .normal)
        founditBtn.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
        founditBtn.addTarget(self, action: #selector(founditBtnClick(sender: )), for: .touchUpInside)
        
        //
        
        bottomBar.addSubview(infoDevNameLabel)
        infoDevNameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalToSuperview().offset(24)
            $0.width.height.greaterThanOrEqualTo(17)
        }
        infoDevNameLabel.lineBreakMode = .byTruncatingTail
        infoDevNameLabel.text = bluetoothDevice.deviceName
        infoDevNameLabel.textAlignment = .center
        infoDevNameLabel.textColor = UIColor(hexString: "#242766")
        infoDevNameLabel.font = UIFont(name: "Poppins-Bold", size: 16)
        
         
        
        bottomBar.addSubview(infoPostionLabel)
        infoPostionLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalTo(infoDevNameLabel.snp.bottom)
            $0.bottom.equalTo(founditBtn.snp.top).offset(-2)
            $0.centerX.equalToSuperview()
        }
        infoPostionLabel.numberOfLines = 0
        infoPostionLabel.text = ""
        infoPostionLabel.textAlignment = .left
        infoPostionLabel.textColor = UIColor(hexString: "#242766")!.withAlphaComponent(0.5)
        infoPostionLabel.font = UIFont(name: "Poppins", size: 12)
        infoPostionLabel.adjustsFontSizeToFitWidth = true
    }

    
    
    
    @objc func backBClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func founditBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
         
    }
    
}

extension NEwBlueDevicePostionVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if firstDisplay {
            if let coord2d = userLocation.location?.coordinate {
                let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
                let region: MKCoordinateRegion = MKCoordinateRegion(center: coord2d, span: span)
                mapView.setRegion(region, animated: true)
                firstDisplay = false
            }

            
        }
    }
    
    private func update(_ newHeading: CLHeading) {
        
        /// 朝向
        let theHeading: CLLocationDirection = newHeading.magneticHeading > 0 ? newHeading.magneticHeading : newHeading.trueHeading
        
        /// 角度
        let angle = Int(theHeading)
        /*
        switch angle {
        case 0:
//            debugPrint("北")
        case 90:
//            debugPrint("东")
        case 180:
//            debugPrint("南")
        case 270:
//            debugPrint("西")
        default:
            break
        }
        */
        
        if angle > 350 && angle < 10 {
            currentDirection = .nort
        }else if angle > 10 && angle < 80 {
            currentDirection = .eastN
        }else if angle > 80 && angle < 100 {
            currentDirection = .east
        }else if angle > 100 && angle < 170 {
            currentDirection = .eastS
        }else if angle > 170 && angle < 190 {
            currentDirection = .sorth
        }else if angle > 190 && angle < 260 {
            currentDirection = .westS
        }else if angle > 260 && angle < 280 {
            currentDirection = .west
        }else if angle > 280 && angle < 350 {
            currentDirection = .westN
        }
    }
}

extension NEwBlueDevicePostionVC: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location:CLLocation = locations[locations.count-1]
        
        
        if (location.horizontalAccuracy > 0) {
            debugPrint("纬度=\(location.coordinate.latitude)  ;经度=\(location.coordinate.longitude)")
            
//            mapView.setCenter(location.coordinate, animated: true)
            
            let geoCoder = CLGeocoder()
            
            geoCoder.reverseGeocodeLocation(location) {[weak self] placemarks, errorr in
                guard let `self` = self else {return}
                if let place = placemarks?.first as? CLPlacemark {
                    DispatchQueue.main.async {
                        let thoroughfare: String = place.thoroughfare ?? ""
                        let locality: String = place.locality ?? ""
                        let subLocality: String = place.subLocality ?? ""
                        let administrativeArea: String = place.administrativeArea ?? ""
                        let country: String = place.country ?? ""
                        
                        let positionStr = "\(thoroughfare) \(locality) \(subLocality) \(administrativeArea) \(country)"
                        debugPrint("positionStr - \(positionStr)")
                        self.infoPostionLabel.text = positionStr
//
                    }
                }
            }
            
            if !refreshWating {
                refreshWating = true
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    [weak self] in
                    guard let `self` = self else {return}
                    self.refreshWating = false
                }
                   if let currentRssi = NEwBlueToolManager.default.currentTrackingItemRssi {
                    if currentRssi > currentCachaRssi {

                    } else {
                        currentCachaRssi = currentRssi
                        nextPostion()
                        mapDegree.resetDirection(CGFloat(currentHeadi) + currentOffsetRotate)

//                        let headingstring = "headi=\(CGFloat(headi))\n\("偏转\(Int(magneticHeading))") - \(currentOffsetRotate)"
//                        debugPrint(headingstring)
                    }


//                    infoDevNameLabel.text = headingstring
//                    infoDevNameLabel.font = UIFont.systemFont(ofSize: 10)
//                    infoDevNameLabel.numberOfLines = 2
                }
            }
            
//            locationManager.stopUpdatingLocation()
        }
    }
    
    // 获得设备地理和地磁朝向数据，从而转动地理刻度表以及表上的文字标注
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        /*
            trueHeading     : 真北方向
            magneticHeading : 磁北方向
         */
        /// 获得当前设备
        let device = UIDevice.current
        
        // 1.判断当前磁力计的角度是否有效(如果此值小于0,代表角度无效)越小越精确
        if newHeading.headingAccuracy > 0 {
            
            // 2.获取当前设备朝向(磁北方向)数据
            let magneticHeading: Float = heading(Float(newHeading.magneticHeading), fromOrirntation: device.orientation)
            
            // 地理航向数据: trueHeading
            //let trueHeading: Float = heading(Float(newHeading.trueHeading), fromOrirntation: device.orientation)
         
            /// 地磁北方向
            let headi: Float = -1.0 * Float.pi * Float(newHeading.magneticHeading) / 180.0
            // 设置角度label文字
            debugPrint("偏转角度\(Int(magneticHeading))")
            
            
            // 3.旋转变换
            
            // 4.当前手机（摄像头)朝向方向
            update(newHeading)
            
            //
            if !refreshWating {
                refreshWating = true
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    [weak self] in
                    guard let `self` = self else {return}
                    self.refreshWating = false
                }
                   if let currentRssi = NEwBlueToolManager.default.currentTrackingItemRssi {
                    if currentRssi > currentCachaRssi {
                        
                    } else {
                        currentCachaRssi = currentRssi
                        nextPostion()
                        mapDegree.resetDirection(CGFloat(headi) + currentOffsetRotate)
                        currentHeadi = headi
                        
                        
                        let headingstring = "headi=\(CGFloat(headi))\n\("偏转\(Int(magneticHeading))") - \(currentOffsetRotate)"
                        debugPrint(headingstring)
                    }
                    
                    
//                    infoDevNameLabel.text = headingstring
//                    infoDevNameLabel.font = UIFont.systemFont(ofSize: 10)
//                    infoDevNameLabel.numberOfLines = 2
                }
            }
            
            
            
            
        }
    }
    
    func nextPostion() {
        if currentDirection == .nort {
            currentDirection = .eastN
            currentOffsetRotate = 45.0/180.0
        } else if currentDirection == .eastN {
            currentDirection = .east
            currentOffsetRotate = 90.0/180.0
        } else if currentDirection == .east {
            currentDirection = .eastS
            currentOffsetRotate = 135.0/180.0
        } else if currentDirection == .eastS {
            currentDirection = .sorth
            currentOffsetRotate = 180.0/180.0
        } else if currentDirection == .sorth {
            currentDirection = .westS
            currentOffsetRotate = 225.0/180.0
        } else if currentDirection == .westS {
            currentDirection = .west
            currentOffsetRotate = 270.0/180.0
        } else if currentDirection == .west {
            currentDirection = .westN
            currentOffsetRotate = 315.0/180.0
        } else if currentDirection == .westN {
            currentDirection = .nort
            currentOffsetRotate = 0
        }
    }
    
    // 判断设备是否需要校验，受到外来磁场干扰时
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    private func heading(_ heading: Float, fromOrirntation orientation: UIDeviceOrientation) -> Float {
        
        var realHeading: Float = heading
        
        switch orientation {
        case .portrait:
            break
        case .portraitUpsideDown:
            realHeading = heading - 180
        case .landscapeLeft:
            realHeading = heading + 90
        case .landscapeRight:
            realHeading = heading - 90
        default:
            break
        }
        if realHeading > 360 {
            realHeading -= 360
        }else if realHeading < 0.0 {
            realHeading += 366
        }
        return realHeading
    }
}
