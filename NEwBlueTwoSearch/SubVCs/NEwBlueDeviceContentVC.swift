//
//  NEwBlueDeviceContentVC.swift
//  NEwBlueTwoSearch
//
//  Created by JOJO on 2023/6/6.
//

import UIKit

class NEwBlueDeviceContentVC: UIViewController {
    var fatherVC: ViewController!
    let tiNameLabel = UILabel()
    let backB = UIButton()
    let vibrationBtn = BSiegToolBtn()
    let positionBtn = BSiegToolBtn()
    let favoriteBtn = BSiegToolBtn()
    let voiceBtn = BSiegToolBtn()
    let centerV = UIView()
    let contentImgV = UIImageView()
    var bluetoothDevice: NEwPeripheralItem
    let didlayoutOnce: Once = Once()
    let distancePersentLabel = UILabel()
    var ring1V = RingProgressView()
    
    let testinfoLabel = UILabel()
    
    var refreshWating: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    init(bluetoothDevice: NEwPeripheralItem) {
        self.bluetoothDevice = bluetoothDevice
        NEwBlueToolManager.default.currentTrackingItem = bluetoothDevice
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupV()
        updateFavoriteStatus()
        
        if !NEwBlueToolManager.default.centralManager.isScanning {
            NEwBlueToolManager.default.startScan()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addNoti()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeNoti()
    }
    
    deinit {
        removeNoti()
    }
    
    func updatePositionPersent() {
        
        if !refreshWating {
            refreshWating = true
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                [weak self] in
                guard let `self` = self else {return}
                self.refreshWating = false
            }
            
            //
            let progress = bluetoothDevice.deviceDistancePercent()
            let percentStr = bluetoothDevice.deviceDistancePercentStr()
            ring1V.progress = progress
            distancePersentLabel.text = percentStr
            testinfoLabel.adjustsFontSizeToFitWidth = true

//
//            debugPrint("update ring1V.progress: \(progress) distancePersentLabel - \(percentStr)")
//            debugPrint("currentTrackingItemRssi \(NEwBlueToolManager.default.currentTrackingItemRssi) currentTrackingItemName - \(NEwBlueToolManager.default.currentTrackingItemName)")
            
            //
            if voiceBtn.isSelected == true {
                NEwBlueToolManager.default.playAudio()
            } else {
                NEwBlueToolManager.default.stopAudio()
            }
            if vibrationBtn.isSelected == true {
                NEwBlueToolManager.default.playFeedVib()
            } else {
                NEwBlueToolManager.default.stopVibTimer()
            }
        }
        
        
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if centerV.bounds.size.width == UIScreen.main.bounds.size.width {
            didlayoutOnce.run {
                setupCenterDeviceView()
            }
        }

    }
    
    func updateFavoriteStatus() {
        if NEwBlueToolManager.default.favoriteDevicesIdList.contains(bluetoothDevice.identifier) {
            favoriteBtn.isSelected = true
            favoriteBtn.iconImgV.image = UIImage(named: "icon_heart_s")
        } else {
            favoriteBtn.isSelected = false
            favoriteBtn.iconImgV.image = UIImage(named: "icon_heart")
        }
        
    }

    func userSubscriVC() {
//        let subsVC = BSiegDeSubscVC()
//        subsVC.modalPresentationStyle = .fullScreen
//        self.present(subsVC, animated: true)
    }
    
}

extension NEwBlueDeviceContentVC {
    
    func addNoti() {
        NotificationCenter.default.addObserver(self, selector:#selector(discoverDeviceUpdate(notification:)) , name: NEwBlueToolManager.default.trackingDeviceNotiName, object: nil)
        
    }
    
    func removeNoti() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func discoverDeviceUpdate(notification: Notification) {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            self.updatePositionPersent()
        }
    }
    
    
}

extension NEwBlueDeviceContentVC {
    func trackStatusChange(isTracking: Bool) {
        if isTracking {
            NEwBlueToolManager.default.addUserFavorite(deviceId: bluetoothDevice.identifier)
        } else {
            NEwBlueToolManager.default.removeUserFavorite(deviceId: bluetoothDevice.identifier)
        }
//        updateFavoriteStatus()
    }
}

extension NEwBlueDeviceContentVC {
    func setupV() {
        view.clipsToBounds = true
        //
        let bgImgV = UIImageView()
        view.addSubview(bgImgV)
        bgImgV.image = UIImage(named: "home")
        bgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        //
        
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
            $0.right.equalToSuperview().offset(-20)
            $0.height.greaterThanOrEqualTo(17)
        }
        tiNameLabel.lineBreakMode = .byTruncatingTail
        tiNameLabel.text = bluetoothDevice.deviceName
        tiNameLabel.textAlignment = .center
        tiNameLabel.textColor = UIColor(hexString: "#242766")
        tiNameLabel.font = UIFont(name: "Poppins-Bold", size: 24)
        
        
        view.addSubview(testinfoLabel)
        testinfoLabel.snp.makeConstraints {
            $0.left.equalTo(backB.snp.right).offset(20)
            $0.top.equalTo(tiNameLabel.snp.bottom).offset(0)
            $0.centerX.equalToSuperview()
            $0.height.greaterThanOrEqualTo(17)
        }
        testinfoLabel.lineBreakMode = .byTruncatingTail
        testinfoLabel.text = ""
        testinfoLabel.textAlignment = .center
        testinfoLabel.textColor = UIColor(hexString: "#242766")
        testinfoLabel.font = UIFont(name: "Poppins-Medium", size: 24)
        
        
        //
        let founditBtn = UIButton()
        view.addSubview(founditBtn)
        founditBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().offset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
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
        let wid: CGFloat = (UIScreen.main.bounds.size.width - 22 * 2 - 15)/2
        let hei: CGFloat = (106.0/164.0) * wid
        //

        view.addSubview(vibrationBtn)
        vibrationBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(22)
            $0.bottom.equalTo(founditBtn.snp.top).offset(-30)
            $0.width.equalTo(wid)
            $0.height.equalTo(hei)
        }
        vibrationBtn.iconImgV.image = UIImage(named: "icon_vibrate")
        vibrationBtn.nameL.text = "Vibration"
        vibrationBtn.addTarget(self, action: #selector(vibrationBtnClick(sender: )), for: .touchUpInside)
        
        //
        view.addSubview(positionBtn)
        positionBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-22)
            $0.bottom.equalTo(founditBtn.snp.top).offset(-30)
            $0.width.equalTo(wid)
            $0.height.equalTo(hei)
        }
        positionBtn.iconImgV.image = UIImage(named: "icon_mapPin")
        positionBtn.nameL.text = "Position"
        positionBtn.addTarget(self, action: #selector(positionBtnClick(sender: )), for: .touchUpInside)
        //

        view.addSubview(favoriteBtn)
        favoriteBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(22)
            $0.bottom.equalTo(vibrationBtn.snp.top).offset(-15)
            $0.width.equalTo(wid)
            $0.height.equalTo(hei)
        }
        favoriteBtn.iconImgV.image = UIImage(named: "icon_heart")
        favoriteBtn.nameL.text = "Favourite"
        favoriteBtn.addTarget(self, action: #selector(favoriteBtnClick(sender: )), for: .touchUpInside)
        //
        
        view.addSubview(voiceBtn)
        voiceBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-22)
            $0.bottom.equalTo(positionBtn.snp.top).offset(-15)
            $0.width.equalTo(wid)
            $0.height.equalTo(hei)
        }
        voiceBtn.iconImgV.image = UIImage(named: "icon_voice")
        voiceBtn.nameL.text = "Voice"
        voiceBtn.addTarget(self, action: #selector(voiceBtnClick(sender: )), for: .touchUpInside)
        //
        
        view.addSubview(centerV)
        centerV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(backB.snp.bottom).offset(10)
            $0.bottom.equalTo(favoriteBtn.snp.top).offset(-10)
        }
        
    }
    
    func setupCenterDeviceView() {
        //
        let iconbgV = UIView()
        centerV.addSubview(iconbgV)
        iconbgV.backgroundColor = UIColor(hexString: "#E8EDFF")
        iconbgV.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-60)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(centerV.frame.size.height/2)
        }
        iconbgV.layer.cornerRadius = centerV.frame.size.height/2/2
        iconbgV.clipsToBounds = true
        //
        contentImgV.contentMode = .scaleAspectFit
        contentImgV.clipsToBounds = true
        iconbgV.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.center.equalTo(iconbgV)
            $0.top.equalToSuperview().offset(30)
            $0.left.equalToSuperview().offset(30)
        }
        let iconName = bluetoothDevice.deviceTagIconName()
        contentImgV.image = UIImage(named: iconName)
        
        //
        
        iconbgV.addSubview(ring1V)
        ring1V.frame = CGRect(x: 0, y: 0, width: centerV.frame.size.height/2, height: centerV.frame.size.height/2)
        ring1V.startColor = UIColor(hexString: "#3971FF")!
        ring1V.endColor = UIColor(hexString: "#3971FF")!
        ring1V.ringWidth = 12
        ring1V.backgroundRingColor = .clear
        ring1V.hidesRingForZeroProgress = true
        ring1V.shadowOpacity = 0
        ring1V.progress = 0
        
        
        //
        
        view.addSubview(distancePersentLabel)
        distancePersentLabel.snp.makeConstraints {
            $0.top.equalTo(iconbgV.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(32)
        }
        
        distancePersentLabel.text = bluetoothDevice.deviceDistancePercentStr()
        distancePersentLabel.textAlignment = .center
        distancePersentLabel.textColor = UIColor(hexString: "#242766")
        distancePersentLabel.font = UIFont(name: "Poppins-Bold", size: 32)
        
        //
        let infoLabel = UILabel()
        view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(distancePersentLabel.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.height.greaterThanOrEqualTo(32)
            $0.left.equalToSuperview().offset(28)
        }
        infoLabel.numberOfLines = 2
        infoLabel.text = "Move around so that the signal strength increases"
        infoLabel.textAlignment = .center
        infoLabel.textColor = UIColor(hexString: "#242766")!.withAlphaComponent(0.5)
        infoLabel.font = UIFont(name: "Poppins-Medium", size: 14)
        
        
    }
    
    
    @objc func backBClick(sender: UIButton) {
        
        NEwBlueToolManager.default.stopAudio()
        NEwBlueToolManager.default.stopVibTimer()
        NEwBlueToolManager.default.stopScan()
        
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func founditBtnClick(sender: UIButton) {
        backBClick(sender: backB)
         
    }
    
    @objc func vibrationBtnClick(sender: BSiegToolBtn) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            sender.backgroundColor = UIColor(hexString: "#FF961B")
            sender.iconImgV.image = UIImage(named: "icon_vibrate_s")
            sender.nameL.textColor = UIColor(hexString: "#FFFFFF")
            
            NEwBlueToolManager.default.playFeedVib()
        } else {
            sender.backgroundColor = UIColor(hexString: "#FFFFFF")
            sender.iconImgV.image = UIImage(named: "icon_vibrate")
            sender.nameL.textColor = UIColor(hexString: "#242766")
            
            NEwBlueToolManager.default.stopVibTimer()
        }
        
    }
    
    @objc func positionBtnClick(sender: BSiegToolBtn) {
//        if !NEwBlueToolManager.default.inSubscription {
//            userSubscriVC()
//        } else {
            let vc = NEwBlueDevicePostionVC(bluetoothDevice: bluetoothDevice)
            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
    }
    
    @objc func favoriteBtnClick(sender: BSiegToolBtn) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            sender.iconImgV.image = UIImage(named: "icon_heart_s")
            trackStatusChange(isTracking: true)
        } else {
            sender.iconImgV.image = UIImage(named: "icon_heart")
            trackStatusChange(isTracking: false)
        }
        
    }
    
    @objc func voiceBtnClick(sender: BSiegToolBtn) {
//        if !NEwBlueToolManager.default.inSubscription {
//            userSubscriVC()
//        } else {
            sender.isSelected = !sender.isSelected
            if sender.isSelected == true {
                sender.backgroundColor = UIColor(hexString: "#3971FF")
                sender.iconImgV.image = UIImage(named: "icon_voice_s")
                sender.nameL.textColor = UIColor(hexString: "#FFFFFF")
                NEwBlueToolManager.default.playAudio()
            } else {
                sender.backgroundColor = UIColor(hexString: "#FFFFFF")
                sender.iconImgV.image = UIImage(named: "icon_voice")
                sender.nameL.textColor = UIColor(hexString: "#242766")
                NEwBlueToolManager.default.stopAudio()
            }
//        }
    }
    
}

class BSiegToolBtn: UIButton {
    let iconImgV = UIImageView()
    let nameL = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupV() {
        backgroundColor = .white
        layer.cornerRadius = 24
        clipsToBounds = true
        //
        addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(snp.centerY).offset(0)
            $0.width.height.equalTo(30)
        }
        iconImgV.contentMode = .scaleAspectFit
        //
        
        addSubview(nameL)
        nameL.snp.makeConstraints {
            $0.left.equalTo(self.snp.left).offset(20)
            $0.top.equalTo(iconImgV.snp.bottom).offset(10)
//            $0.bottom.equalToSuperview().offset(-5)
            $0.height.greaterThanOrEqualTo(10)
            $0.centerX.equalToSuperview()
            
        }
        nameL.textAlignment = .center
        nameL.numberOfLines = 1
        nameL.lineBreakMode = .byTruncatingTail
        nameL.textColor = UIColor(hexString: "#242766")
        nameL.font = UIFont(name: "Poppins-Medium", size: 15)
        
        
    }
    
}
