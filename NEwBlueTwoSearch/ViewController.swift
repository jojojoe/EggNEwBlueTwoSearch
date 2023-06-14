//
//  ViewController.swift
//  NEwBlueTwoSearch
//
//  Created by sege li on 2023/6/4.
//

import UIKit


class ViewController: UIViewController {

    let bluetoothBtn =  NEwHomeToolBtn(frame: .zero, iconName: "Bluetooth", titStr: "Bluetooth")
    let manualBtn =  NEwHomeToolBtn(frame: .zero, iconName: "faq", titStr: "Manual")
    let settingBtn =  NEwHomeToolBtn(frame: .zero, iconName: "setting", titStr: "Settings")
    var searchingBottomPage: NEwSearchingBottomView?
    let homePage = NEwHomePageView()
    let settingPage = NEwSettingPageView()
    let manualPage = NEwManualPageView()
    var isfirstOp = true
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        setView1()
        bluetoothBtnClick()

    }
    
    func setView1() {
        view.clipsToBounds()
            .backgroundColor(.white)
        let _ = UIImageView()
            .image("homeoage")
            .contentMode(.scaleAspectFill)
            .adhere(toSuperview: view) {
                $0.left.right.top.bottom.equalToSuperview()
            }
        //
        let contentV = UIView()
            .adhere(toSuperview: view) {
                $0.left.right.top.bottom.equalToSuperview()
            }
        //
        homePage
            .adhere(toSuperview: contentV) {
                $0.left.right.top.bottom.equalToSuperview()
            }
        homePage.startScanBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.scanBtnClickAction()
            }
        }
        //
        settingPage.fatherFuVC = self
        settingPage.adhere(toSuperview: contentV) {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        manualPage.adhere(toSuperview: contentV) {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        //
        let bottomToolBgV = UIView()
            .backgroundColor(UIColor(hexString: "#98BBFF")!)
            .cornerRadius(40, masksToBounds: false)
            .shadow(color: UIColor(hexString: "#385EE5")!, radius: 20, opacity: 0.5, offset: CGSize(width: 0, height: 0), path: nil)
            .adhere(toSuperview: view) {
                $0.centerX.equalToSuperview()
                $0.left.equalToSuperview().offset(24)
                if UIScreen.isDevice8SE() {
                    $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-14)
                } else {
                    $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-34)
                }

                $0.height.equalTo(80)
            }
        //
        let btnW: CGFloat = (UIScreen.main.bounds.size.width - 24 * 2 - 24 * 2) / 3
        let btnH: CGFloat = 80
        
        //
        bluetoothBtn.frame = CGRect(x: 24, y: 0, width: btnW, height: btnH)
        manualBtn.frame = CGRect(x: 24 + btnW, y: 0, width: btnW, height: btnH)
        settingBtn.frame = CGRect(x: 24 + btnW * 2, y: 0, width: btnW, height: btnH)
        bottomToolBgV.addSubview(bluetoothBtn)
        bottomToolBgV.addSubview(manualBtn)
        bottomToolBgV.addSubview(settingBtn)
        bluetoothBtn.target(target: self, action: #selector(bluetoothBtnClick), event: .touchUpInside)
        manualBtn.target(target: self, action: #selector(manualBtnClick), event: .touchUpInside)
        settingBtn.target(target: self, action: #selector(settingBtnClick), event: .touchUpInside)
        
    }

    
}

extension ViewController {
    func showSearchingBlueStatus() {
        
        //
        var bottomFrame = CGRect.zero
        if UIScreen.isDevice8SEPaid() {
            let frameY: CGFloat = CGRectGetMaxY(self.homePage.tiLabel.frame) + 150
            let frameH: CGFloat = UIScreen.main.bounds.size.height - frameY
            bottomFrame = CGRect(x: 0, y: frameY, width: UIScreen.main.bounds.size.width, height: frameH)
        } else {
            let frameY: CGFloat = CGRectGetMaxY(self.homePage.tiLabel.frame) + 244
            let frameH: CGFloat = UIScreen.main.bounds.size.height - frameY
            bottomFrame = CGRect(x: 0, y: frameY, width: UIScreen.main.bounds.size.width, height: frameH)
        }
        let searchingBottomPage = NEwSearchingBottomView(frame: bottomFrame)
        self.searchingBottomPage = searchingBottomPage
        view.addSubview(searchingBottomPage)
//        searchingBottomPage.adhere(toSuperview: view) {
//            $0.left.right.bottom.equalToSuperview()
//            if UIScreen.isDevice8SEPaid() {
//                $0.top.equalTo(view.safeAreaLayoutGuide.snp.centerY).offset(-50)
//            } else {
//                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIScreen.main.bounds.size.height * 1/4)
//            }
//
//        }
        searchingBottomPage.closeClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                NEwBlueToolManager.default.stopScan()
                self.hiddenSearchingBlueStatus()
            }
        }
        searchingBottomPage.itemclickBlock = {
            [weak self] perItem in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.showBlueDeviceContent(item: perItem)
            }
        }
        searchingBottomPage.devicesContentClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.showBlueContenentListVC()
            }
        }
        
        //
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15) {
            self.homePage.showSearchingStatus(isShow: true)
            searchingBottomPage.showContentStatus(isShow: true)
        }
    }
    
    func hiddenSearchingBlueStatus() {
        self.homePage.showSearchingStatus(isShow: false)
        self.searchingBottomPage?.showContentStatus(isShow: false)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            [weak self] in
            guard let `self` = self else {return}
            if let _ = self.searchingBottomPage?.superview {
                self.searchingBottomPage?.removeFromSuperview()
            }
        }
    }
    
    func showBlueDeniedV() {
        let alertVC = UIAlertController(title: "Oops", message: "You have declined access to Bluetooth, please active it in Settings > Bluetooth.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
            DispatchQueue.main.async {
                let url = URL(string: UIApplication.openSettingsURLString)!
                UIApplication.shared.open(url, options: [:])
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertVC.addAction(cancel)
        alertVC.addAction(confirm)
        self.present(alertVC, animated: true)
    }
    
    func showBlueDeviceContent(item: NEwPeripheralItem) {
        let vc = NEwBlueDeviceContentVC(peripheral: item)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showBlueContenentListVC() {
        NEwBlueToolManager.default.stopScan()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
            let vc = NEwBlueDeviceListVC()
            self.navigationController?.pushViewController(vc, animated: true)
            vc.restartClickBlock = {
                [weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                        NEwBlueToolManager.default.startScan()
                        self.showSearchingBlueStatus()
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.35) {
            self.hiddenSearchingBlueStatus()
        }
    }
}

extension ViewController {
    
    func scanBtnClickAction() {
        if NEwBlueToolManager.default.centralManagerStatus == true {
            NEwBlueToolManager.default.bluePeripheralList = []
            NEwBlueToolManager.default.startScan()
            showSearchingBlueStatus()
        } else {
//            showBlueDeniedV()
            
            //Test
//            #if DEBUG
//            let item1 = NEwPeripheralItem(identifier: "1", deviceName: "mac", rssi: -59)
//            let item2 = NEwPeripheralItem(identifier: "2", deviceName: "phone", rssi: -59)
//            let item3 = NEwPeripheralItem(identifier: "3", deviceName: "pods", rssi: -59)
//            NEwBlueToolManager.default.bluePeripheralList = [item1, item2, item3]
//            showSearchingBlueStatus()
//
//            NEwBlueToolManager.default.sendTrackingDeviceNotification()
//
//            #endif
            
            
            
        }
    }
    
    @objc func bluetoothBtnClick() {
        if isfirstOp {
            isfirstOp = false
        } else {
            NEwBlueToolManager.default.giveTapVib()
        }
        
        homePage.isHidden = false
        manualPage.isHidden = true
        settingPage.isHidden = true
        
        bluetoothBtn.isSelected = true
        manualBtn.isSelected = false
        settingBtn.isSelected = false
    }
    
    @objc func manualBtnClick() {
        NEwBlueToolManager.default.giveTapVib()
        homePage.isHidden = true
        manualPage.isHidden = false
        settingPage.isHidden = true
        
        bluetoothBtn.isSelected = false
        manualBtn.isSelected = true
        settingBtn.isSelected = false
    }
    
    @objc func settingBtnClick() {
        NEwBlueToolManager.default.giveTapVib()
        homePage.isHidden = true
        manualPage.isHidden = true
        settingPage.isHidden = false
        
        bluetoothBtn.isSelected = false
        manualBtn.isSelected = false
        settingBtn.isSelected = true
    }
    
}




class NEwHomeToolBtn: UIButton {
    var iconName: String
    var titStr: String
    let pointV = UIView()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                alpha = 1
            } else {
                alpha = 0.55
            }
            pointV.isHidden = !isSelected
        }
    }
    
    init(frame: CGRect, iconName: String, titStr: String) {
        self.iconName = iconName
        self.titStr = titStr
        super.init(frame: frame)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent() {
        let iconImgV = UIImageView()
            .image(iconName)
            .adhere(toSuperview: self) {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(snp.centerY).offset(4)
                $0.width.height.equalTo(24)
            }
        let nameL = UILabel()
            .text(titStr)
            .color(.white)
            .font(UIFont.SFProTextBold, 10)
            .textAlignment(.center)
            .adjustsFontSizeToFitWidth()
            .adhere(toSuperview: self) {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(iconImgV.snp.bottom).offset(6)
                $0.height.equalTo(13)
                $0.left.equalToSuperview()
            }
        pointV
            .backgroundColor(.white)
            .adhere(toSuperview: self) {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(nameL.snp.bottom).offset(4)
                $0.width.height.equalTo(4)
            }
            .cornerRadius(2)
        pointV.isHidden = true
    }
    
    
}
