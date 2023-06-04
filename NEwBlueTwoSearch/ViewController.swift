//
//  ViewController.swift
//  NEwBlueTwoSearch
//
//  Created by Joe on 2023/6/4.
//

import UIKit
import EasySwiftLayout

class ViewController: UIViewController {

    let bluetoothBtn =  NEwHomeToolBtn(frame: .zero, iconName: "Bluetooth", titStr: "Bluetooth")
    let manualBtn =  NEwHomeToolBtn(frame: .zero, iconName: "faq", titStr: "Manual")
    let settingBtn =  NEwHomeToolBtn(frame: .zero, iconName: "setting", titStr: "Settings")
    
    let homePage = NEwHomePageView()
    let settingPage = NEwSettingPageView()
    let manualPage = NEwManualPageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        setView1()
        bluetoothBtnClick()
    }

    func setView1() {
        view.clipsToBounds()
            .backgroundColor(.white)
        let bgImgV = UIImageView()
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
        homePage.proClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.probtnClickAction()
            }
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
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-34)
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
    func probtnClickAction() {
        
    }
    func scanBtnClickAction() {
        
    }
    
    @objc func bluetoothBtnClick() {
        homePage.isHidden = false
        manualPage.isHidden = true
        settingPage.isHidden = true
        
        bluetoothBtn.isSelected = true
        manualBtn.isSelected = false
        settingBtn.isSelected = false
    }
    
    @objc func manualBtnClick() {
        homePage.isHidden = true
        manualPage.isHidden = false
        settingPage.isHidden = true
        
        bluetoothBtn.isSelected = false
        manualBtn.isSelected = true
        settingBtn.isSelected = false
    }
    
    @objc func settingBtnClick() {
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
