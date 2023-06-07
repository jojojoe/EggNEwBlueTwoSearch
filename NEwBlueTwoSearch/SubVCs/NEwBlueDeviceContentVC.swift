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
    let voiceBtn = NeEwVoiceBtn(frame: .zero, norImgStr: "content_voice_n", selectImgStr: "content_voice_s")
    let vibBtn = NeEwVoiceBtn(frame: .zero, norImgStr: "content_vib_n", selectImgStr: "content_vib_s")
    let postionBtn = NeEwVoiceBtn(frame: .zero, norImgStr: "content_postion", selectImgStr: "content_postion")
    
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

        setupV()
        
        updateFavoriteStatus()
        
        if !NEwBlueToolManager.default.centralManager.isScanning {
            NEwBlueToolManager.default.startScan()
        }
        
    }
    
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
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                [weak self] in
                guard let `self` = self else {return}
                self.refreshWating = false
            }
            //
            let progress = bluetoothDevice.deviceDistancePercent()
            let percentStr = bluetoothDevice.deviceDistancePercentStr()
            ringProgressView.progress = progress
            persentLabel.text = percentStr
            
            checkVoiceVibStatus()
            
        }
        
    }
    
    func checkVoiceVibStatus() {
        if voiceBtn.isSelected == true {
            NEwBlueToolManager.default.playAudio()
        }
        if vibrationBtn.isSelected == true {
            NEwBlueToolManager.default.playFeedVib()
        }
    }
    
    
    func updateFavoriteStatus() {
        if NEwBlueToolManager.default.favoriteDevicesIdList.contains(peripheralItem.identifier) {
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
            NEwBlueToolManager.default.addUserFavorite(deviceId: bluetoothDevice.identifier)
        } else {
            NEwBlueToolManager.default.removeUserFavorite(deviceId: bluetoothDevice.identifier)
        }
    }
}



extension NEwBlueDeviceContentVC {
    func setupV() {
        view.clipsToBounds = true
         
        backButton.adhere(toSuperview: view) {
            $0.left.equalToSuperview().offset(20)
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
        .color(UIColor(hexString: "#242766")!)
        .font(UIFont.SFProTextBold, 22)
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
            $0.bottom.equalToSuperview().offset(-25)
            $0.width.equalTo(326)
            $0.height.equalTo(60)
        }
        .backgroundImage(UIImage(named: ""))
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
            if NEwBlueToolManager.default.isDevice8SE() {
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
        
//        view.addSubview(distancePersentLabel)
//        distancePersentLabel.snp.makeConstraints {
//            $0.top.equalTo(iconbgV.snp.bottom).offset(30)
//            $0.centerX.equalToSuperview()
//            $0.width.height.greaterThanOrEqualTo(32)
//        }
//
//        distancePersentLabel.text = bluetoothDevice.deviceDistancePercentStr()
//        distancePersentLabel.textAlignment = .center
//        distancePersentLabel.textColor = UIColor(hexString: "#242766")
//        distancePersentLabel.font = UIFont(name: "Poppins-Bold", size: 32)
        
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
        backBClick(sender: backB)
         
    }
    
    @objc func vibBtnClick() {
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
    
    @objc func positionBtnClick() {
//        if !NEwBlueToolManager.default.inSubscription {
//            userSubscriVC()
//        } else {
            let vc = NEwBlueDevicePostionVC(bluetoothDevice: bluetoothDevice)
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
    
    override var isSelected: Bool {
        didSet {
            iconImgV.isHighlighted = isSelected
        }
    }
    
    init(frame: CGRect, norImgStr: String, selectImgStr: String) {
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
            .color(UIColor(hexString: "#262B55"))
            .font(UIFont.SFProTextMedium, 14)
  
        
        
    }
    
}
