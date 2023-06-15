//
//  NEwSettingPageView.swift
//  NEwBlueTwoSearch
//
//  Created by sege li on 2023/6/4.
//

import UIKit

class NEwSettingPageView: UIView {

    var fatherFuVC: UIViewController?
    let wangguanBg = UIView()
    let shareBgImgV = UIImageView()
    let restoreBg = UIView()
    let btnW: CGFloat = UIScreen.main.bounds.size.width - 24 * 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupV()
        updateSubscribeStatus()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSubscribeStatus() {
        wangguanBg.isHidden = true
        shareBgImgV.snp.remakeConstraints({
            $0.left.equalToSuperview().offset(24)
            $0.top.equalTo(wangguanBg.snp.top).offset(0)
            $0.width.equalTo(btnW)
            $0.height.equalTo(btnW * 128.0/342)
        })
        restoreBg.isHidden = true
            
    }
    
    func setupV() {
        
        //
        let tiLabel = UILabel()
            .text("Setting")
            .color(.white)
            .font(UIFont.SFProTextHeavy, 20)
            .adhere(toSuperview: self) {
                $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(5)
                $0.left.equalToSuperview().offset(24)
                $0.width.greaterThanOrEqualTo(10)
                $0.height.equalTo(34)
            }
        
        //
        let scrollV = UIScrollView()
        addSubview(scrollV)
        scrollV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(tiLabel.snp.bottom).offset(20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-100)
        }
        
        //
        let scrollW: CGFloat = UIScreen.main.bounds.size.width
        scrollV.contentSize = CGSize(width: scrollW, height: 385)
        
        
        wangguanBg
            .adhere(toSuperview: scrollV) {
                $0.left.equalToSuperview().offset(24)
                $0.top.equalToSuperview().offset(10)
                $0.width.equalTo(btnW)
                $0.height.equalTo(btnW * 64.0/342)
            }
        //
        let _ = UIImageView()
            .image("settingbtn1banner")
            .adhere(toSuperview: wangguanBg) {
                $0.left.right.top.bottom.equalTo(wangguanBg)
            }
            
        let _ = NEwSettingBtn(frame: .zero, iconStr: "wangguan", titStr: "To Unlock All Features")
            .adhere(toSuperview: wangguanBg) {
                $0.left.right.top.bottom.equalTo(wangguanBg)
            }
            .target(target: self, action: #selector(wangguanBtnClick), event: .touchUpInside)
        //
        
        shareBgImgV
            .image("settingbtn2banner")
            .adhere(toSuperview: scrollV) {
                $0.left.equalToSuperview().offset(24)
                $0.top.equalTo(wangguanBg.snp.bottom).offset(20)
                $0.width.equalTo(btnW)
                $0.height.equalTo(btnW * 128.0/342)
            }
        //
        let _ = NEwSettingBtn(frame: .zero, iconStr: "share", titStr: "Share")
            .adhere(toSuperview: scrollV) {
                $0.left.right.top.equalTo(shareBgImgV)
                $0.height.equalTo(68)
            }
            .target(target: self, action: #selector(shareappBtnClick), event: .touchUpInside)
        //
        let _ = NEwSettingBtn(frame: .zero, iconStr: "filequestion", titStr: "More Help")
            .adhere(toSuperview: scrollV) {
                $0.left.right.bottom.equalTo(shareBgImgV)
                $0.height.equalTo(68)
            }
            .target(target: self, action: #selector(morehelpFeedBtnClick), event: .touchUpInside)
        //
        let privacyBgImgV = UIImageView()
            .image("settingbtn2banner")
            .adhere(toSuperview: scrollV) {
                $0.left.equalToSuperview().offset(24)
                $0.top.equalTo(shareBgImgV.snp.bottom).offset(20)
                $0.width.equalTo(btnW)
                $0.height.equalTo(btnW * 128.0/342)
            }
        //
        let _ = NEwSettingBtn(frame: .zero, iconStr: "lockaltpri", titStr: "Privacy Policy")
            .adhere(toSuperview: scrollV) {
                $0.left.right.top.equalTo(privacyBgImgV)
                $0.height.equalTo(68)
            }
            .target(target: self, action: #selector(privacyBtnClick), event: .touchUpInside)
        //
        let _ = NEwSettingBtn(frame: .zero, iconStr: "filealtterms", titStr: "Terms of Use")
            .adhere(toSuperview: scrollV) {
                $0.left.right.bottom.equalTo(privacyBgImgV)
                $0.height.equalTo(68)
            }
            .target(target: self, action: #selector(termsofBtnClick), event: .touchUpInside)
        
        //
        
        restoreBg
            .adhere(toSuperview: scrollV) {
                $0.left.equalToSuperview().offset(24)
                $0.top.equalTo(privacyBgImgV.snp.bottom).offset(20)
                $0.width.equalTo(btnW)
                $0.height.equalTo(btnW * 64.0/342)
            }
        //
        let _ = UIImageView()
            .image("settingbtn1banner")
            .adhere(toSuperview: restoreBg) {
                $0.left.right.top.bottom.equalTo(restoreBg)
            }
            
        let _ = NEwSettingBtn(frame: .zero, iconStr: "restoreset", titStr: "Restore")
            .adhere(toSuperview: restoreBg) {
                $0.left.right.top.bottom.equalTo(restoreBg)
            }
            .target(target: self, action: #selector(restoreBtnClick), event: .touchUpInside)
        
    }

}

extension NEwSettingPageView {
    @objc func wangguanBtnClick() {
        NEwBlueToolManager.default.giveTapVib()
        if let vc = self.fatherFuVC {
            /* sub
            let subscribe = NEwBlueSubscribeVC()
            subscribe.modalPresentationStyle = .fullScreen
            vc.present(subscribe, animated: true)
             */
        }
    }
    
    @objc func shareappBtnClick() {
        NEwBlueToolManager.default.giveTapVib()
        if let vc = self.fatherFuVC {
            NEwBlueToolManager.default.enterShareFriends(fuVC: vc)
        }
    }
    
    @objc func morehelpFeedBtnClick() {
        NEwBlueToolManager.default.giveTapVib()
        if let vc = self.fatherFuVC {
            NEwBlueToolManager.default.enterFeedback(fuVC: vc)
        }
    }
    
    @objc func privacyBtnClick() {
        NEwBlueToolManager.default.giveTapVib()
        NEwBlueToolManager.default.enterLinPrivacyPage()
    }
    
    @objc func termsofBtnClick() {
        NEwBlueToolManager.default.giveTapVib()
        NEwBlueToolManager.default.enterLinTermsPage()
    }
    
    @objc func restoreBtnClick() {
        NEwBlueToolManager.default.giveTapVib()
        /* sub
        if NEwBlueProManager.default.inSubscription {
            KRProgressHUD.showSuccess(withMessage: "You are already in the subscription period!")
        } else {
            NEwBlueProManager.default.restore { success in
                if success {
                    KRProgressHUD.showSuccess(withMessage: "The subscription was restored successfully")
                } else {
                    KRProgressHUD.showMessage("Nothing to Restore")
                }
            }
        }
         */
    }
}

class NEwSettingBtn: UIButton {
    
    init(frame: CGRect, iconStr: String, titStr: String) {
        super.init(frame: frame)
        
        //
        let iconImgV = UIImageView()
            .adhere(toSuperview: self) {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(20)
                $0.width.height.equalTo(24)
            }
            .image(iconStr)
        //
        let titLabel = UILabel()
            .adhere(toSuperview: self) {
                $0.centerY.equalToSuperview()
                $0.left.equalTo(iconImgV.snp.right).offset(16)
                $0.width.height.greaterThanOrEqualTo(20)
            }
            .font(UIFont.SFProTextBold, 16)
            .textAlignment(.left)
            .color(.white)
            .text(titStr)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

