//
//  NEwBlueDevicePostionVC.swift
//  NEwBlueTwoSearch
//
//  Created by sege li on 2023/6/6.
//

import UIKit
import MapKit
import CoreLocation



class NEwBlueDevicePostionVC: UIViewController {

    let mapView: MKMapView = MKMapView()
    
    let infoDevNameLabel = UILabel()
    let infoPostionLabel = UILabel()
    var bluetoothDevice: NEwPeripheralItem
    let locationManager:CLLocationManager = CLLocationManager()
    var firstDisplay = true
    var mapDegree: NEwBlueDeviceDegreeScaleV!
    var currentDirection: MoveDirection = .nort
    var currentOffsetRotate: CGFloat = 0
    var currentCachaRssi: Double = 0
    let titleDeviceNameLabel = UILabel()
    let backButton = UIButton()
    let favoriteHotBtn = UIButton()
    
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
        mapDegree = NEwBlueDeviceDegreeScaleV(frame: CGRect(x: (UIScreen.main.bounds.size.width - degreeWidth)/2, y: (UIScreen.main.bounds.size.height - UIScreen.main.bounds.size.width) / 2, width: degreeWidth, height: degreeWidth))
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
        backButton.adhere(toSuperview: view) {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.width.height.equalTo(44)
        }
        .image(UIImage(named: "back_ic"))
        .target(target: self, action: #selector(backBClick), event: .touchUpInside)
        //
        titleDeviceNameLabel.adhere(toSuperview: view) {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton.snp.centerY)
            $0.left.equalTo(backButton.snp.right).offset(10)
            $0.height.equalTo(44)
        }
        .lineBreakMode(.byTruncatingTail)
        .text(bluetoothDevice.deviceName)
        .color(UIColor(hexString: "#262B55")!)
        .font(UIFont.SFProTextBold, 20)
        .textAlignment(.center)
        
        favoriteHotBtn.adhere(toSuperview: view) {
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.width.height.equalTo(44)
        }
        .image(UIImage(named: "Heart_ic"), .normal)
        .image(UIImage(named: "Heart_s"), .selected)
        .target(target: self, action: #selector(favoriteBtnClick(sender: )), event: .touchUpInside)
        
        //
        if NEwBlueToolManager.default.hotBlueDevicesIdList.contains(self.bluetoothDevice.identifier) {
            self.favoriteHotBtn.isSelected = true
        } else {
            self.favoriteHotBtn.isSelected = false
        }
        
        setupSearchAgainV()
    }
    
    func setupSearchAgainV() {
        //
        let bottomBar = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 240, width: UIScreen.main.bounds.size.width, height: 240))
            .backgroundColor(UIColor(hexString: "#F1F4FF")!)
            .shadow(color: UIColor(hexString: "#385EE5")!, radius: 30, opacity: 0.3, offset: CGSize(width: 0, height: 0), path: nil)
        bottomBar.roundCorners([.topLeft, .topRight], radius: 20)
        view.addSubview(bottomBar)
        //
        let bottomBarCloseBtn = UIButton()
            .adhere(toSuperview: bottomBar) {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(50)
                $0.height.equalTo(32)
                $0.top.equalToSuperview().offset(4)
            }
            .image(UIImage(named: "mappointcloseline"))
            .target(target: self, action: #selector(bottomBarCloseBtnClick), event: .touchUpInside)
            .isEnabled(false)
        //
        infoDevNameLabel
            .adhere(toSuperview: bottomBar) {
                $0.left.equalToSuperview().offset(30)
                $0.top.equalTo(bottomBarCloseBtn.snp.bottom).offset(0)
                $0.width.height.greaterThanOrEqualTo(20)
            }
            .lineBreakMode(.byTruncatingTail)
            .text(bluetoothDevice.deviceName)
            .textAlignment(.left)
            .color(UIColor(hexString: "#262B55")!)
            .font(UIFont.SFProTextBold, 16)
        
        
        //
        let founditBtn = UIButton()
            .adhere(toSuperview: bottomBar) {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(326)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
                $0.height.equalTo(60)
            }
            .backgroundImage(UIImage(named: "restartbutton"))
            .font(UIFont.SFProTextBold, 16)
            .titleColor(.white)
            .title("I Found It!")
            .target(target: self, action: #selector(founditBtnClick), event: .touchUpInside)
        //
        infoPostionLabel.adhere(toSuperview: bottomBar) {
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.top.equalTo(infoDevNameLabel.snp.bottom).offset(5)
            $0.bottom.equalTo(founditBtn.snp.top).offset(-5)
        }
        .color(UIColor(hexString: "#262B55")!.withAlphaComponent(0.5))
        .font(UIFont.SFProTextRegular, 12)
        .numberOfLines(0)
        .textAlignment(.left)
        .adjustsFontSizeToFitWidth()
        
    }

    
    @objc func bottomBarCloseBtnClick() {
        NEwBlueToolManager.default.giveTapVib()
    }
    
    @objc func backBClick(sender: UIButton) {
        NEwBlueToolManager.default.giveTapVib()
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func founditBtnClick() {
        NEwBlueToolManager.default.giveTapVib()
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func favoriteBtnClick(sender: UIButton) {
        NEwBlueToolManager.default.giveTapVib()
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            trackStatusChange(isTracking: true)
        } else {
            trackStatusChange(isTracking: false)
        }
        
    }
    
    func trackStatusChange(isTracking: Bool) {
        if isTracking {
            NEwBlueToolManager.default.appendUserFavoriteBlueDevice(deviceId: bluetoothDevice.identifier)
        } else {
            NEwBlueToolManager.default.removeUserFavorite(deviceId: bluetoothDevice.identifier)
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
                    }
                }
            }
        }
    }
    
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
            
            // 4.
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
    
    // 
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

