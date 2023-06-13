//
//  NEwBlueDeviceContentVC.swift
//  NEwBlueTwoSearch
//
//  Created by JOJO on 2023/6/6.
//

import UIKit

class NEwBlueDeviceContentVC: UIViewController {
    
    let titleDeviceNameLabel = UILabel()
    let backButton = UIButton()
    let favoriteHotBtn = UIButton()
    let voiceBtn = NeEwVoiceBtn(frame: .zero, norImgStr: "content_voice_n", selectImgStr: "content_voice_s", titStr: "Voice")
    let vibBtn = NeEwVoiceBtn(frame: .zero, norImgStr: "content_vib_n", selectImgStr: "content_vib_s", titStr: "Vibration")
    let postionBtn = NeEwVoiceBtn(frame: .zero, norImgStr: "content_postion", selectImgStr: "content_postion", titStr: "Position")
    
    var peripheralItem: NEwPeripheralItem
    
    let centerV = UIView()
    let contentImgV = UIImageView()
    let persentLabel = UILabel()
    let infoDescribeLabel = UILabel()
    var ringProgressView = RingProgressView()
    let didlayoutOnce: Once = Once()
    
//    let testinfoLabel = UILabel()
    var refreshWating: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    init(peripheral: NEwPeripheralItem) {
        self.peripheralItem = peripheral
        NEwBlueToolManager.default.currentTrackingItem = peripheral
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNoti()
        setupV()
        
        updateFavoriteStatus()
        
        if !NEwBlueToolManager.default.centralManager.isScanning {
            NEwBlueToolManager.default.startScan()
        }
        
    }
    
    func addNoti() {
        NotificationCenter.default.addObserver(self, selector:#selector(discoverDeviceUpdate(notification:)) , name: NEwBlueToolManager.default.trackingDeviceNotiName, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(deviceFavoriteChange(notification:)) , name: NEwBlueToolManager.default.deviceFavoriteChangeNotiName, object: nil)
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
    
    @objc func deviceFavoriteChange(notification: Notification) {
        DispatchQueue.main.async {
            if NEwBlueToolManager.default.hotBlueDevicesIdList.contains(self.peripheralItem.identifier) {
                self.favoriteHotBtn.isSelected = true
            } else {
                self.favoriteHotBtn.isSelected = false
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    deinit {
        removeNoti()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if centerV.bounds.size.width == UIScreen.main.bounds.size.width {
            didlayoutOnce.run {
                setupCenterDeviceView()
            }
        }
    }
    
    func updatePositionPersent() {
        
        if !refreshWating {
            refreshWating = true
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                [weak self] in
                guard let `self` = self else {return}
                self.refreshWating = false
            }
            //
            let progress = peripheralItem.deviceDistancePercent()
            let percentStr = peripheralItem.deviceDistancePercentStr()
            ringProgressView.progress = progress
            persentLabel.text = percentStr
            
            let distanceAboutM = peripheralItem.fetchAboutDistanceString()
            let distanceAproxStr = "Approx. \(distanceAboutM) away from you"
            infoDescribeLabel.text(distanceAproxStr)
            checkVoiceVibStatus()
            
        }
        
    }
    
    func checkVoiceVibStatus() {
        if voiceBtn.isSelected == true {
            NEwBlueToolManager.default.playAudio()
        }
        if vibBtn.isSelected == true {
            NEwBlueToolManager.default.playFeedVib()
        }
    }
    
    
    func updateFavoriteStatus() {
        if NEwBlueToolManager.default.hotBlueDevicesIdList.contains(peripheralItem.identifier) {
            favoriteHotBtn.isSelected = true
        } else {
            favoriteHotBtn.isSelected = false
        }
        
    }

    func userSubscriVC() {
//        let subsVC = BSiegDeSubscVC()
//        subsVC.modalPresentationStyle = .fullScreen
//        self.present(subsVC, animated: true)
    }
    
}

extension NEwBlueDeviceContentVC {
    
}

extension NEwBlueDeviceContentVC {
    func trackStatusChange(isTracking: Bool) {
        if isTracking {
            NEwBlueToolManager.default.appendUserFavoriteBlueDevice(deviceId: peripheralItem.identifier)
        } else {
            NEwBlueToolManager.default.removeUserFavorite(deviceId: peripheralItem.identifier)
        }
    }
}



extension NEwBlueDeviceContentVC {
    func setupV() {
        view.clipsToBounds = true
        view.backgroundColor(UIColor(hexString: "#F1F4FF")!)
         
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
        .text(peripheralItem.deviceName)
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
        let foundBtn = UIButton()
        foundBtn.adhere(toSuperview: view) {
            $0.centerX.equalToSuperview()
            if UIScreen.isDevice8SE() {
                $0.bottom.equalToSuperview().offset(-15)
            } else {
                $0.bottom.equalToSuperview().offset(-25)
            }
            
            $0.width.equalTo(326)
            $0.height.equalTo(60)
        }
        .backgroundImage(UIImage(named: "restartbutton"))
        .title("I Found It")
        .titleColor(UIColor.white)
        .font(UIFont.SFProTextBold, 16)
        .cornerRadius(30)
        .target(target: self, action: #selector(founditBtnClick), event: .touchUpInside)
        
        //
        let wid: CGFloat = (UIScreen.main.bounds.size.width - 22 * 2 - 15)/2
        let hei: CGFloat = (106.0/164.0) * wid
        //
      
        voiceBtn.adhere(toSuperview: view) {
            $0.left.equalTo(foundBtn.snp.left)
            $0.width.equalTo(80)
            $0.height.equalTo(109)
            if UIScreen.isDevice8SE() {
                $0.bottom.equalTo(foundBtn.snp.top).offset(-10)
            } else {
                $0.bottom.equalTo(foundBtn.snp.top).offset(-40)
            }
        }
        .target(target: self, action: #selector(voiceBtnClick), event: .touchUpInside)
        //
        vibBtn.adhere(toSuperview: view) {
            $0.centerX.equalTo(foundBtn.snp.centerX)
            $0.width.equalTo(80)
            $0.height.equalTo(109)
            $0.centerY.equalTo(voiceBtn.snp.centerY)
        }
        .target(target: self, action: #selector(vibBtnClick), event: .touchUpInside)
        
        //
        postionBtn.adhere(toSuperview: view) {
            $0.right.equalTo(foundBtn.snp.right)
            $0.width.equalTo(80)
            $0.height.equalTo(109)
            $0.centerY.equalTo(voiceBtn.snp.centerY)
        }
        .target(target: self, action: #selector(positionBtnClick), event: .touchUpInside)
        //
        persentLabel.adhere(toSuperview: view) {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(voiceBtn.snp.top).offset(-85)
            $0.width.height.greaterThanOrEqualTo(30)
        }
        .textAlignment(.center)
        .color(UIColor(hexString: "#262B55")!)
        .font(UIFont.SFProTextHeavy, 24)
        .text("0%")
        
        //
        infoDescribeLabel
            .adhere(toSuperview: view) {
                $0.centerX.equalToSuperview()
                if UIScreen.isDevice8SE() {
                    $0.top.equalTo(persentLabel.snp.bottom).offset(10)
                } else {
                    $0.top.equalTo(persentLabel.snp.bottom).offset(24)
                }
                
                $0.width.height.greaterThanOrEqualTo(30)
            }
            .textAlignment(.center)
            .color(UIColor(hexString: "#262B55")!.withAlphaComponent(0.5))
            .font(UIFont.SFProTextMedium, 16)
            .text("")
        //
        centerV.adhere(toSuperview: view) {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(backButton.snp.bottom).offset(10)
            $0.bottom.equalTo(persentLabel.snp.top).offset(-10)
        }
        
        
    }
    
    func setupCenterDeviceView() {
        //
        let leftPadding: CGFloat = 45
        var canvasVWidth = centerV.bounds.size.width - leftPadding * 2
        if canvasVWidth > centerV.bounds.size.height {
            canvasVWidth = centerV.bounds.size.height
        }
        //
        let iconbgV = UIView()
        iconbgV.adhere(toSuperview: centerV) {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(canvasVWidth)
        }
        //
        let iconBgIMgV = UIImageView()
        iconBgIMgV.adhere(toSuperview: iconbgV) {
            $0.left.right.top.bottom.equalToSuperview()
        }
        .image("devicebgblur")
        .contentMode(.scaleAspectFit)
        
        //
        let iconImgV = UIImageView()
        iconImgV.adhere(toSuperview: iconbgV) {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(canvasVWidth * 2.0/3.0)
        }
        .image(peripheralItem.deviceTagIconName(isBig: true))
        //
        
        
        iconbgV.addSubview(ringProgressView)
        ringProgressView.frame = CGRect(x: 0, y: 0, width: canvasVWidth, height: canvasVWidth)
        ringProgressView.startColor = UIColor(hexString: "#3971FF")!
        ringProgressView.endColor = UIColor(hexString: "#3971FF")!
        ringProgressView.ringWidth = 12
        ringProgressView.backgroundRingColor = .clear
        ringProgressView.hidesRingForZeroProgress = true
        ringProgressView.shadowOpacity = 0
        ringProgressView.progress = peripheralItem.deviceDistancePercent()
        persentLabel.text = peripheralItem.deviceDistancePercentStr()
        
        
    }
    
    
    @objc func backBClick() {
        
        NEwBlueToolManager.default.stopAudio()
        NEwBlueToolManager.default.stopVibTimer()
        NEwBlueToolManager.default.stopScan()
        
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func founditBtnClick() {
        backBClick()
         
    }
    
    @objc func vibBtnClick() {
        vibBtn.isSelected = !vibBtn.isSelected
        if vibBtn.isSelected == true {
            NEwBlueToolManager.default.playFeedVib()
        } else {
            NEwBlueToolManager.default.stopVibTimer()
        }
        
    }
    
    @objc func positionBtnClick() {
//        if !NEwBlueToolManager.default.inSubscription {
//            userSubscriVC()
//        } else {
            let vc = NEwBlueDevicePostionVC(bluetoothDevice: peripheralItem)
            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
    }
    
    @objc func favoriteBtnClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            trackStatusChange(isTracking: true)
        } else {
            trackStatusChange(isTracking: false)
        }
        
    }
    
    @objc func voiceBtnClick() {
        voiceBtn.isSelected = !voiceBtn.isSelected
        if voiceBtn.isSelected == true {
            NEwBlueToolManager.default.playAudio()
        } else {
            NEwBlueToolManager.default.stopAudio()
        }
    }
    
}

class NeEwVoiceBtn: UIButton {
    let iconImgV = UIImageView()
    let nameL = UILabel()
    var norImgStr: String
    var selectImgStr: String
    var titStr: String
    override var isSelected: Bool {
        didSet {
            iconImgV.isHighlighted = isSelected
        }
    }
    
    init(frame: CGRect, norImgStr: String, selectImgStr: String, titStr: String) {
        self.norImgStr = norImgStr
        self.selectImgStr = selectImgStr
        self.titStr = titStr
        super.init(frame: frame)
        setupV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupV() {
        backgroundColor = .clear
        
        clipsToBounds = true
        iconImgV.adhere(toSuperview: self) {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(snp.top).offset(0)
            $0.width.height.equalTo(80)
        }
        .image(norImgStr)
        .highlightedImage(selectImgStr)
        .contentMode(.scaleAspectFit)
        
        //
        nameL
            .adhere(toSuperview: self) {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(iconImgV.snp.bottom).offset(12)
                $0.height.equalTo(17)
                $0.width.greaterThanOrEqualTo(10)
            }
            .textAlignment(.center)
            .lineBreakMode(.byTruncatingTail)
            .numberOfLines(1)
            .color(UIColor(hexString: "#262B55")!)
            .font(UIFont.SFProTextMedium, 14)
            .text(titStr)
        
        
    }
    
}
