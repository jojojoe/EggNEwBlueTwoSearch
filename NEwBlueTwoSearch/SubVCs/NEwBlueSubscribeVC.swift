//
//  NEwBlueSubscribeVC.swift
//  NEwBlueTwoSearch
//
//  Created by sege li on 2023/6/8.
//

import UIKit
import SnapKit
import WebKit

class NEwBlueSubscribeVC: UIViewController {
  
    
    
    let topbannerV = UIView()
    let scanCenterBgV = NEwCenterScanView()
    let monthProBtn = NEwStoreBtn(frame: .zero, productType: .month)
    let weekProBtn = NEwStoreBtn(frame: .zero, productType: .week)
    let yearProBtn = NEwStoreBtn(frame: .zero, productType: .year)
    var didlayoutOnce = Once()
    var pageDisappearBlock: (()->Void)?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupV()
    }
    
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if topbannerV.bounds.size.width == UIScreen.main.bounds.size.width {
            didlayoutOnce.run {
                self.addScaningAnimalV()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scanCenterBgV.startAnimal(isStart: false)
        pageDisappearBlock?()
    }
   
    func setupV() {
        view.clipsToBounds = true
        //
        setupTopBanner()
        setupBottomBanner()
        fetchPriceLabels()
        
    }
    
    func setupTopBanner() {
        let _ = UIImageView()
            .adhere(toSuperview: view) {
                $0.left.right.top.bottom.equalToSuperview()
            }
            .image("homeoage")
        //
        view.addSubview(topbannerV)
        
        //
        let backButton = UIButton()
        backButton.adhere(toSuperview: view) {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            $0.width.height.equalTo(44)
        }
        .image(UIImage(named: "whiteArrowLeft"))
        .target(target: self, action: #selector(backButtonClick), event: .touchUpInside)
        //
        let restoreButton = UIButton()
        restoreButton.adhere(toSuperview: view) {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            $0.width.equalTo(64)
            $0.height.equalTo(44)
        }
        .title("Restore")
        .font(UIFont.SFProTextMedium, 14)
        .titleColor(.white)
        .target(target: self, action: #selector(restoreButtonClick), event: .touchUpInside)
    
    }
    
    func setupBottomBanner() {
        let bottomBanner = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 552, width: UIScreen.main.bounds.size.width, height: 552))
            .backgroundColor(UIColor(hexString: "#F1F4FF")!)
        view.addSubview(bottomBanner)
        bottomBanner.roundCorners([.topLeft, .topRight], radius: 40)
        //
        let btitleL = UILabel()
            .adhere(toSuperview: bottomBanner) {
                $0.centerX.equalToSuperview().offset(-24)
                $0.top.equalToSuperview().offset(24)
                $0.width.greaterThanOrEqualTo(10)
                $0.height.equalTo(44)
            }
            .font(UIFont.SFProTextBold, 24)
            .color(UIColor(hexString: "#3971FF")!)
            .text("Bluetooth Scanner")
        let btitle2L = UILabel()
            .adhere(toSuperview: bottomBanner) {
                $0.left.equalTo(btitleL.snp.right).offset(4)
                $0.centerY.equalTo(btitleL.snp.centerY).offset(0)
                $0.width.greaterThanOrEqualTo(10)
                $0.height.equalTo(44)
            }
            .font(UIFont.SFProTextBold, 24)
            .color(UIColor(hexString: "#FFC85F")!)
            .text("Pro")
        //
        let infoDe1 = NEwDesInfoLabel(frame: .zero, infoStr: "Find lost device in seconds.")
            .adhere(toSuperview: bottomBanner) {
                $0.top.equalTo(btitleL.snp.bottom).offset(12)
                $0.left.equalTo(btitleL.snp.left)
                $0.right.equalToSuperview().offset(-20)
                $0.height.equalTo(24)
            }
        let infoDe2 = NEwDesInfoLabel(frame: .zero, infoStr: "Pinpoint location tracking.")
            .adhere(toSuperview: bottomBanner) {
                $0.top.equalTo(infoDe1.snp.bottom).offset(16)
                $0.left.equalTo(btitleL.snp.left)
                $0.right.equalToSuperview().offset(-20)
                $0.height.equalTo(24)
            }
        let infoDe3 = NEwDesInfoLabel(frame: .zero, infoStr: "Supports all bluetooth devices.")
            .adhere(toSuperview: bottomBanner) {
                $0.top.equalTo(infoDe2.snp.bottom).offset(16)
                $0.left.equalTo(btitleL.snp.left)
                $0.right.equalToSuperview().offset(-20)
                $0.height.equalTo(24)
            }
        let infoDe4 = NEwDesInfoLabel(frame: .zero, infoStr: "No ads and unlimited scans.")
            .adhere(toSuperview: bottomBanner) {
                $0.top.equalTo(infoDe3.snp.bottom).offset(16)
                $0.left.equalTo(btitleL.snp.left)
                $0.right.equalToSuperview().offset(-20)
                $0.height.equalTo(24)
            }
        //
        
        monthProBtn.adhere(toSuperview: bottomBanner) {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(infoDe4.snp.bottom).offset(24)
            $0.width.equalTo(102)
            $0.height.equalTo(132)
        }
        .target(target: self, action: #selector(monthProBtnClick), event: .touchUpInside)
        //
        weekProBtn.adhere(toSuperview: bottomBanner) {
            $0.right.equalTo(monthProBtn.snp.left).offset(-12)
            $0.bottom.equalTo(monthProBtn.snp.bottom).offset(0)
            $0.width.equalTo(100)
            $0.height.equalTo(108)
        }
        .target(target: self, action: #selector(weekProBtnClick), event: .touchUpInside)
        //
        yearProBtn.adhere(toSuperview: bottomBanner) {
            $0.left.equalTo(monthProBtn.snp.right).offset(12)
            $0.bottom.equalTo(monthProBtn.snp.bottom).offset(0)
            $0.width.equalTo(100)
            $0.height.equalTo(108)
        }
        .target(target: self, action: #selector(yearProBtnClick), event: .touchUpInside)
        //
        monthProBtnClick()
        //
        let monthBestView = UIButton()
            .adhere(toSuperview: bottomBanner) {
                $0.centerX.equalToSuperview()
                $0.centerY.equalTo(monthProBtn.snp.top)
                $0.width.equalTo(85)
                $0.height.equalTo(24)
            }
            .backgroundImage(UIImage(named: "bestvalueicon"))
            .title("Best Value")
            .font(UIFont.SFProTextSemibold, 12)
            .titleColor(UIColor.white)
        monthBestView.isUserInteractionEnabled = false
        
        //
        let proContinueBtn = UIButton()
            .adhere(toSuperview: bottomBanner, {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(326)
                $0.height.equalTo(60)
                $0.top.equalTo(monthProBtn.snp.bottom).offset(24)
            })
            .backgroundImage(UIImage(named: "restartbutton"))
            .title("Continue")
            .titleColor(UIColor.white)
            .font(UIFont.SFProTextBold, 16)
            .target(target: self, action: #selector(proContinueBtnClick), event: .touchUpInside)
        
        //
        let purchaseInfoAlertLabel = UILabel()
            .adhere(toSuperview: bottomBanner) {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(proContinueBtn.snp.bottom).offset(12)
                $0.width.greaterThanOrEqualTo(10)
                $0.height.equalTo(22)
            }
            .textAlignment(.center)
            .font(UIFont.SFProTextRegular, 12)
            .color(UIColor(hexString: "#262B55")!.withAlphaComponent(0.3))
            .adjustsFontSizeToFitWidth()
            .text("Cancel anytime Or continue with limited version")
        let pruchaseInfoLine = UIView()
            .adhere(toSuperview: bottomBanner) {
                $0.bottom.equalTo(purchaseInfoAlertLabel.snp.bottom).offset(-4)
                $0.left.equalTo(purchaseInfoAlertLabel.snp.left)
                $0.right.equalTo(purchaseInfoAlertLabel.snp.right)
                $0.height.equalTo(1)
            }
            .backgroundColor(UIColor(hexString: "#262B55")!.withAlphaComponent(0.3))
        
        
        let termsofBtn = UIButton()
            .adhere(toSuperview: bottomBanner) {
                $0.right.equalTo(bottomBanner.snp.centerX).offset(-8)
                $0.top.equalTo(purchaseInfoAlertLabel.snp.bottom).offset(8)
                $0.width.equalTo(86)
                $0.height.equalTo(34)
            }
            .target(target: self, action: #selector(termsBtnClick), event: .touchUpInside)
            .title("Terms of Use")
            .titleColor(UIColor(hexString: "#262B55")!.withAlphaComponent(0.5))
            .font(UIFont.SFProTextSemibold, 12)
        //
        let privacypoBtn = UIButton()
            .adhere(toSuperview: bottomBanner) {
                $0.left.equalTo(bottomBanner.snp.centerX).offset(8)
                $0.top.equalTo(termsofBtn.snp.top).offset(0)
                $0.width.equalTo(86)
                $0.height.equalTo(34)
            }
            .target(target: self, action: #selector(privacyBtnClick), event: .touchUpInside)
            .title("Privacy Policy")
            .titleColor(UIColor(hexString: "#262B55")!.withAlphaComponent(0.5))
            .font(UIFont.SFProTextSemibold, 12)
        
        let lineoof = UIView()
            .adhere(toSuperview: bottomBanner) {
                $0.centerX.equalToSuperview()
                $0.centerY.equalTo(termsofBtn.snp.centerY)
                $0.width.equalTo(1)
                $0.height.equalTo(14)
            }
            .backgroundColor(UIColor(hexString: "#262B55")!.withAlphaComponent(0.5))
        
        //
        topbannerV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.bottom.equalTo(bottomBanner.snp.top)
        }
    }
    
    
    func addScaningAnimalV() {
        scanCenterBgV
            .adhere(toSuperview: topbannerV) {
                $0.center.equalToSuperview()
                if UIScreen.isDevice8SE() {
                    $0.width.height.equalTo(120)
                } else {
                    $0.width.height.equalTo(200)
                }
            }
        scanCenterBgV.startAnimal(isStart: true)
    }
    
}

extension NEwBlueSubscribeVC {
    
    @objc func weekProBtnClick() {
        NEwBlueToolManager.default.giveTapVib()
        weekProBtn.isSelected = true
        monthProBtn.isSelected = false
        yearProBtn.isSelected = false
        NEwBlueProManager.default.currentIapType = .week
    }
    
    @objc func monthProBtnClick() {
        NEwBlueToolManager.default.giveTapVib()
        weekProBtn.isSelected = false
        monthProBtn.isSelected = true
        yearProBtn.isSelected = false
        NEwBlueProManager.default.currentIapType = .month
    }
    
    @objc func yearProBtnClick() {
        NEwBlueToolManager.default.giveTapVib()
        weekProBtn.isSelected = false
        monthProBtn.isSelected = false
        yearProBtn.isSelected = true
        NEwBlueProManager.default.currentIapType = .year
    }
    
    @objc func proContinueBtnClick() {
        NEwBlueToolManager.default.giveTapVib()
        NEwBlueProManager.default.subscribeProvipOrder(iapType: NEwBlueProManager.default.currentIapType, source: "shop") {[weak self] subSuccess, errorStr in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if subSuccess {
                    KRProgressHUD.showSuccess(withMessage: "The subscription was successful!")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.backButtonClick()
                    }
                } else {
                    KRProgressHUD.showError(withMessage: errorStr ?? "The subscription failed")
                }
            }
        }
    }
    
    @objc func backButtonClick() {
        NEwBlueToolManager.default.giveTapVib()
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func termsBtnClick() {
        NEwBlueToolManager.default.giveTapVib()
        if let url = URL(string: NEwBlueToolManager.default.termsStr) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func privacyBtnClick() {
        NEwBlueToolManager.default.giveTapVib()
        if let url = URL(string: NEwBlueToolManager.default.privacyStr) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func restoreButtonClick() {
        NEwBlueToolManager.default.giveTapVib()
        if NEwBlueProManager.default.inSubscription {
            KRProgressHUD.showSuccess(withMessage: "You are already in the subscription period!")
        } else {
            NEwBlueProManager.default.restore { success in
                if success {
                    KRProgressHUD.showSuccess(withMessage: "The subscription was restored successfully")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.backButtonClick()
                    }
                } else {
                    KRProgressHUD.showMessage("Nothing to Restore")
                }
            }
        }
    }
}

extension NEwBlueSubscribeVC {
    
    func updatePrice() {
        
        //"\(currentSymbol)\(Double(defaultYearPrice/12).accuracyToString(position: 2))/mo"
        
        weekProBtn.updatePrice(str: "\(NEwBlueProManager.default.currentSymbol) \(NEwBlueProManager.default.defaultWeekPrice)")
        monthProBtn.updatePrice(str: "\(NEwBlueProManager.default.currentSymbol) \(NEwBlueProManager.default.defaultMonthPrice)")
        yearProBtn.updatePrice(str: "\(NEwBlueProManager.default.currentSymbol) \(NEwBlueProManager.default.defaultYearPrice)")
        
    }
    
    func fetchPriceLabels() {
        
        if NEwBlueProManager.default.currentProducts.count == NEwBlueProManager.default.iapTypeList.count {
            updatePrice()
        } else {
            updatePrice()
            NEwBlueProManager.default.fetchPurchaseInfo {[weak self] productList in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    if productList.count == NEwBlueProManager.default.iapTypeList.count {
                        self.updatePrice()
                    }
                }
            }
        }
    }
}

class NEwDesInfoLabel: UIView {
    var contentL = UILabel()
    
    init(frame: CGRect, infoStr: String) {
        super.init(frame: frame)
        contentL
            .adhere(toSuperview: self) {
                $0.left.equalToSuperview().offset(35)
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview()
                $0.height.equalToSuperview()
            }
            .textAlignment(.left)
            .font(UIFont.SFProTextMedium, 16)
            .color(UIColor(hexString: "#262B55")!.withAlphaComponent(0.7))
            .text(infoStr)
        //
        let iconImgV = UIImageView()
            .adhere(toSuperview: self) {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview()
                $0.width.height.equalTo(24)
            }
            .image("storeinfoicon")
        //
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class NEwStoreBtn: UIButton {
    var productType: NEwBlueProManager.IAPType
    let typeLabel = UILabel()
    let priceLabel = UILabel()
    let priceTypeLabel = UILabel()
    let bgImgV = UIImageView()
    
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self
                .borderColor(UIColor(hexString: "#3971FF")!, width: 1)
                bgImgV.isHidden = false
                let colorStrS = "#FFFFFF"
                typeLabel.textColor = UIColor(hexString: colorStrS)
                priceLabel.textColor = UIColor(hexString: colorStrS)
                priceTypeLabel.textColor = UIColor(hexString: colorStrS)
            } else {
                self
                .borderColor(UIColor(hexString: "#595F97")!, width: 1)
                bgImgV.isHidden = true
                let colorStrN = "#595F97"
                typeLabel.textColor = UIColor(hexString: colorStrN)
                priceLabel.textColor = UIColor(hexString: colorStrN)
                priceTypeLabel.textColor = UIColor(hexString: colorStrN)
            }
        }
    }
    
    init(frame: CGRect, productType: NEwBlueProManager.IAPType) {
        self.productType = productType
        super.init(frame: frame)
        //
        self
            .backgroundColor(UIColor(hexString: "#F1F4FF")!)
            .borderColor(UIColor(hexString: "#595F97")!, width: 1)
            .cornerRadius(16, masksToBounds: true)
        //
        
        bgImgV.image("selectbgstore")
            .adhere(toSuperview: self) {
                $0.left.right.top.bottom.equalToSuperview()
            }
        //
        priceLabel
            .adhere(toSuperview: self) {
                $0.centerY.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.left.equalToSuperview().offset(10)
                $0.height.equalTo(20)
            }
            .textAlignment(.center)
            .font(UIFont.SFProTextRegular, 14)
            .color(UIColor(hexString: "#595F97")!)
        //
        
        priceTypeLabel
            .adhere(toSuperview: self) {
                $0.top.equalTo(priceLabel.snp.bottom).offset(4)
                $0.centerX.equalToSuperview()
                $0.left.equalToSuperview().offset(2)
                $0.height.equalTo(18)
            }
            .textAlignment(.center)
            .font(UIFont.SFProTextRegular, 12)
            .color(UIColor(hexString: "#595F97")!)
        
        //
        var typeStr: String = ""
        switch productType {
        case .week:
            typeStr = "Weekly"
        case .month:
            typeStr = "Monthly"
        case .year:
            typeStr = "Annual"
        }
        
        //
        
        typeLabel
            .adhere(toSuperview: self) {
                $0.bottom.equalTo(priceLabel.snp.top).offset(-4)
                $0.centerX.equalToSuperview()
                $0.left.equalToSuperview().offset(10)
                $0.height.equalTo(18)
            }
            .textAlignment(.center)
            .font(UIFont.SFProTextBold, 18)
            .color(UIColor(hexString: "#595F97")!)
            .text(typeStr)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePrice(str: String) {
        priceLabel.text(str)
        var typeStr: String = ""
        switch productType {
        case .week:
            typeStr = "week"
        case .month:
            typeStr = "month"
        case .year:
            typeStr = "year"
        }
        priceTypeLabel.text("\(str) / \(typeStr)")
    }
    
    
}
