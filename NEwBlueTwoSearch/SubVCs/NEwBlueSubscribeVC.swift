//
//  NEwBlueSubscribeVC.swift
//  NEwBlueTwoSearch
//
//  Created by Joe on 2023/6/8.
//

import UIKit
import SnapKit
import WebKit




class NEwBlueSubscribeVC: UIViewController {
  
    
//    let monthBeforePrice: Double = 19.99
    var defaultMonthPrice: Double = 8.99
    var defaultYearPrice: Double = 29.99
    var currentSymbol: String = "$"
    
    let scaningAniBgV = UIView()
    let centerScanAniImgV = UIImageView()
    
    let backBtn = UIButton()
    let theContinueBtn = UIButton()
    let monthBgBtn = UIButton()
    let yearBgBtn = UIButton()
    
    let yearPriceLabel = UILabel()
    let yearPriceInfoLabel = UILabel()
    let yearSelectImgV = UIImageView()
    
    let monthPriceLabel = UILabel()
    let monthPriceInfoLabel = UILabel()
    let monthSelectImgV = UIImageView()
    
    var pageDisappearBlock: (()->Void)?
    
    var didlayoutOnce = Once()
    
    private let radarAnimation = "radarAnimation"
    private var animationLayer: CALayer?
    private var animationGroup: CAAnimationGroup?
    
    
    func startScanRotateAnimal() {
        makeRadarAnimation(animalView: centerScanAniImgV)
        
    }
    
    func stopScanRotateAnimal() {
        centerScanAniImgV.layer.removeAnimation(forKey: radarAnimation)
    }
    
    private func makeRadarAnimation(animalView: UIView) {
           
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0.0
        animation.toValue = CGFloat.pi * 2
        animation.duration  = 2
        animation.autoreverses = false
        animation.fillMode = .forwards
        animation.repeatCount = HUGE
        
        animalView.layer.add(animation, forKey: radarAnimation)
         
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupV()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if scaningAniBgV.bounds.size.width == UIScreen.main.bounds.size.width {
            didlayoutOnce.run {
                addScaningAnimalV()
                startScanRotateAnimal()
            }
        }

    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopScanRotateAnimal()
        pageDisappearBlock?()
    }
    
    func setupV() {
        view.clipsToBounds = true
        //
        let bgImgV = UIImageView()
        view.addSubview(bgImgV)
        bgImgV.image = UIImage(named: "home")
        bgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        setupContinueBtn()
        setupYearPurchaseBtn()
        setupMonthPurchaseBtn()
        setupDescribeLabels()
        fetchPriceLabels()
        updateIapBtnStatus()
        
        
    }
    
    
    func setupContinueBtn() {
        view.addSubview(theContinueBtn)
        theContinueBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            $0.left.equalToSuperview().offset(30)
            $0.height.equalTo(60)
        }
        theContinueBtn.layer.cornerRadius = 30
        theContinueBtn.backgroundColor = UIColor(hexString: "#3971FF")
        theContinueBtn.setTitle("Continue", for: .normal)
        theContinueBtn.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
        theContinueBtn.setTitleColor(.white, for: .normal)
        theContinueBtn.addTarget(self, action: #selector(theContinueBtnClick(sender: )), for: .touchUpInside)
        theContinueBtn.addShadow(ofColor: UIColor(hexString: "#3971FF")!, radius: 15, offset: CGSize(width: 0, height: 5), opacity: 0.3)
        //
        let termsBtn = UIButton()
        view.addSubview(termsBtn)
        termsBtn.snp.makeConstraints {
            $0.right.equalTo(view.snp.centerX).offset(-10)
            $0.top.equalTo(theContinueBtn.snp.bottom).offset(25)
            $0.width.height.greaterThanOrEqualTo(20)
        }
        termsBtn.setTitle("Terms of use", for: .normal)
        termsBtn.setTitleColor(UIColor(hexString: "#242766")!.withAlphaComponent(0.5), for: .normal)
        termsBtn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 12)
        termsBtn.addTarget(self, action: #selector(termsBtnClick(sender: )), for: .touchUpInside)
        //
        let line1 = UIView()
        line1.backgroundColor = UIColor(hexString: "#242766")!.withAlphaComponent(0.5)
        view.addSubview(line1)
        line1.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(termsBtn.snp.centerY)
            $0.height.equalTo(16)
            $0.width.equalTo(1)
            
        }
        //
        let privacyBtn = UIButton()
        view.addSubview(privacyBtn)
        privacyBtn.snp.makeConstraints {
            $0.left.equalTo(termsBtn.snp.right).offset(20)
            $0.centerY.equalTo(termsBtn.snp.centerY)
            $0.width.height.greaterThanOrEqualTo(20)
        }
        privacyBtn.setTitle("Privacy Policy", for: .normal)
        privacyBtn.setTitleColor(UIColor(hexString: "#242766")!.withAlphaComponent(0.5), for: .normal)
        privacyBtn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 12)
        privacyBtn.addTarget(self, action: #selector(privacyBtnClick(sender: )), for: .touchUpInside)
        //
//        let line2 = UIView()
//        line2.backgroundColor = UIColor(hexString: "#242766")!.withAlphaComponent(0.5)
//        view.addSubview(line2)
//        line2.snp.makeConstraints {
//            $0.centerX.equalTo(termsBtn.snp.left).offset(-10)
//            $0.centerY.equalTo(termsBtn.snp.centerY)
//            $0.height.equalTo(16)
//            $0.width.equalTo(1)
//
//        }
        //
//        let purchaseNoticeBtn = UIButton()
//        view.addSubview(purchaseNoticeBtn)
//        purchaseNoticeBtn.snp.makeConstraints {
//            $0.right.equalTo(termsBtn.snp.left).offset(-20)
//            $0.centerY.equalTo(termsBtn.snp.centerY)
//            $0.width.height.greaterThanOrEqualTo(20)
//        }
//        purchaseNoticeBtn.setTitle("Subscribe Notice", for: .normal)
//        purchaseNoticeBtn.setTitleColor(UIColor(hexString: "#242766")!.withAlphaComponent(0.5), for: .normal)
//        purchaseNoticeBtn.titleLabel?.font = UIFont(name: "Poppins", size: 12)
//        purchaseNoticeBtn.addTarget(self, action: #selector(purchaseNoticeBtnClick(sender: )), for: .touchUpInside)
        
        //
        let cancelAnytimeLabel = UILabel()
        view.addSubview(cancelAnytimeLabel)
        cancelAnytimeLabel.textColor = UIColor(hexString: "#242766")!.withAlphaComponent(0.5)
        cancelAnytimeLabel.textAlignment = .center
        cancelAnytimeLabel.text = "No commitment, Cancel anytime"
        cancelAnytimeLabel.font = UIFont(name: "Poppins-Regular", size: 10)
        cancelAnytimeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(termsBtn.snp.top)
            $0.height.width.greaterThanOrEqualTo(10)
        }
    }
    
    func setupMonthPurchaseBtn() {
        view.addSubview(monthBgBtn)
        monthBgBtn.backgroundColor = .clear
        monthBgBtn.layer.borderColor = UIColor(hexString: "#3971FF")!.cgColor
        monthBgBtn.layer.borderWidth = 1
        monthBgBtn.layer.cornerRadius = 30
        monthBgBtn.addTarget(self, action: #selector(monthBgBtnClick(sender: )), for: .touchUpInside)
        monthBgBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().offset(30)
            $0.bottom.equalTo(yearBgBtn.snp.top).offset(-20)
            $0.height.equalTo(60)
        }
        
        //
        let monthTitleLabel = UILabel()
        monthTitleLabel.text = "Monthly"
        monthTitleLabel.textColor = UIColor(hexString: "#242766")
        monthTitleLabel.font = UIFont(name: "Poppins-SemiBold", size: 14)
        monthBgBtn.addSubview(monthTitleLabel)
        monthTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(50)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        
        monthBgBtn.addSubview(monthSelectImgV)
        monthSelectImgV.image = UIImage(named: "storeselect")
        monthSelectImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(22)
            $0.width.height.equalTo(20)
        }
        
        //
        
        monthPriceInfoLabel.textColor = .black
        monthPriceInfoLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
        monthBgBtn.addSubview(monthPriceInfoLabel)
        monthPriceInfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.greaterThanOrEqualTo(1)
        }

        //
        let monthPreImgV = UIImageView()
        monthPreImgV.image = UIImage(named: "monthbest")
        view.addSubview(monthPreImgV)
        monthPreImgV.snp.makeConstraints {
            $0.width.equalTo(88)
            $0.height.equalTo(26)
            $0.right.equalTo(monthBgBtn.snp.right).offset(-20)
            $0.centerY.equalTo(monthBgBtn.snp.top)
        }
        
    }
    
    func setupYearPurchaseBtn() {

        view.addSubview(yearBgBtn)
        yearBgBtn.backgroundColor = .clear
        yearBgBtn.layer.borderColor = UIColor(hexString: "#3971FF")!.cgColor
        yearBgBtn.layer.borderWidth = 1
        yearBgBtn.layer.cornerRadius = 30
        yearBgBtn.addTarget(self, action: #selector(yearBgBtnClick(sender: )), for: .touchUpInside)
        yearBgBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().offset(30)
            $0.bottom.equalTo(theContinueBtn.snp.top).offset(-30)
            $0.height.equalTo(60)
        }
        //
        let yearTitleLabel = UILabel()
        yearTitleLabel.text = "Yearly"
        yearTitleLabel.textColor = UIColor(hexString: "#242766")
        yearTitleLabel.font = UIFont(name: "Poppins-SemiBold", size: 14)
        yearBgBtn.addSubview(yearTitleLabel)
        yearTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(50)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        
        yearBgBtn.addSubview(yearSelectImgV)
        yearSelectImgV.image = UIImage(named: "storeselect")
        yearSelectImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(22)
            $0.width.height.equalTo(20)
        }
        //
        
        yearPriceInfoLabel.textColor = .black
        yearPriceInfoLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
        yearBgBtn.addSubview(yearPriceInfoLabel)
        yearPriceInfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        
    }
    
    func setupDescribeLabels() {
        let describeBgV = UIView()
        view.addSubview(describeBgV)
        describeBgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(monthBgBtn.snp.top).offset(-20)
            if Device.current.diagonal <= 4.7 || Device.current.diagonal >= 7.0 {
                $0.height.equalTo(190)
            } else {
                $0.height.equalTo(230)
            }
        }
        //
        let descTitleLabel = UILabel()
        describeBgV.addSubview(descTitleLabel)
        
        let titstr = "Bluetooth scanner Premium"
        let rang = NSString(string: titstr).range(of: "Premium")
        let attrStr = NSMutableAttributedString(string: titstr, attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Bold", size: 24) ?? UIFont.systemFont(ofSize: 24), NSAttributedString.Key.foregroundColor : UIColor(hexString: "#242766")!])
        attrStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(hexString: "#3971FF")!], range: rang)
        descTitleLabel.attributedText = attrStr
        descTitleLabel.textAlignment = .center
        descTitleLabel.adjustsFontSizeToFitWidth = true
        descTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalTo(348)
            $0.height.greaterThanOrEqualTo(38)
        }
        //
        var labelpadding: CGFloat = 10
        if Device.current.diagonal <= 4.7 || Device.current.diagonal >= 7.0 {
            labelpadding = 14
        } else {
            labelpadding = 20
        }
        //
        let descLabel1 = PRStoreDesInfoLabel()
        describeBgV.addSubview(descLabel1)
        descLabel1.contentL.text = "Find lost device in seconds."
        descLabel1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(54)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(descTitleLabel.snp.bottom).offset(labelpadding)
            
            $0.height.equalTo(24)
        }
        //
        let descLabel2 = PRStoreDesInfoLabel()
        describeBgV.addSubview(descLabel2)
        descLabel2.contentL.text = "Pinpoint location tracking."
        descLabel2.snp.makeConstraints {
            $0.left.equalTo(descLabel1.snp.left)
            $0.right.equalToSuperview().offset(-30)
            $0.top.equalTo(descLabel1.snp.bottom).offset(labelpadding)
            $0.height.equalTo(24)
        }
        //
        let descLabel3 = PRStoreDesInfoLabel()
        describeBgV.addSubview(descLabel3)
        descLabel3.contentL.text = "Supports oll bluetooth devices."
        descLabel3.snp.makeConstraints {
            $0.left.equalTo(descLabel1.snp.left)
            $0.right.equalToSuperview().offset(-30)
            $0.top.equalTo(descLabel2.snp.bottom).offset(labelpadding)
            $0.height.equalTo(24)
        }
        
        //
        let descLabel4 = PRStoreDesInfoLabel()
        describeBgV.addSubview(descLabel4)
        descLabel4.contentL.text = "No ads and unlimited scans."
        descLabel4.snp.makeConstraints {
            $0.left.equalTo(descLabel1.snp.left)
            $0.right.equalToSuperview().offset(-30)
            $0.top.equalTo(descLabel3.snp.bottom).offset(labelpadding)
            $0.height.equalTo(24)
        }
        
        //
        let topIconImgV = UIImageView()
        view.addSubview(topIconImgV)
        topIconImgV.image = UIImage(named: "Group 3548")
        topIconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(describeBgV.snp.top).offset(0)
            $0.left.equalToSuperview()
        }
        topIconImgV.contentMode = .scaleAspectFit
        
        //
        
        backBtn.setImage(UIImage(named: "subback"), for: .normal)
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.width.height.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        //
        let restoreBtn = UIButton()
        view.addSubview(restoreBtn)
        restoreBtn.snp.makeConstraints {
            $0.centerY.equalTo(backBtn.snp.centerY)
            $0.right.equalToSuperview().offset(-24)
            $0.width.height.greaterThanOrEqualTo(54)
        }
        restoreBtn.setTitle("Restore", for: .normal)
        restoreBtn.setTitleColor(UIColor(hexString: "#242766")!.withAlphaComponent(0.8), for: .normal)
        restoreBtn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 14)
        restoreBtn.addTarget(self, action: #selector(restoreBtnClick(sender: )), for: .touchUpInside)
        
        
        //
        scaningAniBgV.isUserInteractionEnabled = false
        view.addSubview(scaningAniBgV)
        scaningAniBgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.top.equalTo(backBtn.snp.top).offset(20)
            $0.bottom.equalTo(describeBgV.snp.top).offset(-20)
        }
        
    }
    
    func addScaningAnimalV() {
        //
        
        scaningAniBgV.addSubview(centerScanAniImgV)
        centerScanAniImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(min(scaningAniBgV.frame.size.height, scaningAniBgV.frame.size.width))
        }
        centerScanAniImgV.image = UIImage(named: "scanbganiyuan")
        //
        let scanImgV = UIImageView()
        scaningAniBgV.addSubview(scanImgV)
        scanImgV.snp.makeConstraints {
            $0.center.equalTo(centerScanAniImgV)
            $0.width.height.equalTo(120)
        }
        scanImgV.image = UIImage(named: "bluescancenter")
    }
    
    @objc func monthBgBtnClick(sender: UIButton) {
        NEwBlueProManager.default.currentIapType = .month
        updateIapBtnStatus()
    }
    
    @objc func yearBgBtnClick(sender: UIButton) {
        NEwBlueProManager.default.currentIapType = .year
        updateIapBtnStatus()
    }
    
    @objc func theContinueBtnClick(sender: UIButton) {
        NEwBlueProManager.default.subscribeIapOrder(iapType: NEwBlueProManager.default.currentIapType, source: "shop") {[weak self] subSuccess, errorStr in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if subSuccess {
                    KRProgressHUD.showSuccess(withMessage: "The subscription was successful!")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.backBtnClick(sender: self.backBtn)
                    }
                    
                } else {
                    KRProgressHUD.showError(withMessage: errorStr ?? "The subscription failed")
                }
            }

        }
        
    }
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func termsBtnClick(sender: UIButton) {
        if let url = URL(string: NEwBlueToolManager.default.termsStr) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func privacyBtnClick(sender: UIButton) {
        if let url = URL(string: NEwBlueToolManager.default.privacyStr) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func purchaseNoticeBtnClick(sender: UIButton) {
        
    }
    
    @objc func restoreBtnClick(sender: UIButton) {
        if NEwBlueProManager.default.inSubscription {
            KRProgressHUD.showSuccess(withMessage: "You are already in the subscription period!")
        } else {
            NEwBlueProManager.default.restore { success in
                if success {
                    KRProgressHUD.showSuccess(withMessage: "The subscription was restored successfully")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.backBtnClick(sender: self.backBtn)
                    }
                } else {
                    KRProgressHUD.showMessage("Nothing to Restore")
                }
            }
        }
    }
    
    
    
    //
//    let purchaseNoticeStr = """
//    <h1>Fast Print Subscriptions</h1>
//
//    <p>You can subscribe to Fast Print Subscriptions to get all the fonts, special symbols in the app.
//    </p>
//
//    <p>Fast Print Subscriptions provides some subscription. The subscription price is:</p>
//
//    <p>$\(buildYPrice)/Year</p>
//
//    <p>$\(buildMPrice)/Month</p>
//
//    <p>Payment will be charged to iTunes Account at confirmation of purchase.</p>
//
//    <p>Subscriptions will automatically renew unless auto-renew is turned off at least 24 hours before the end of the current subscription period.</p>
//
//    <p>Your account will be charged for renewal 24 hours before the end of the current period, and the renewal fee will be determined.</p>
//
//    <p>Subscriptions may be managed by the user and auto-renewal may also be turned off in the user&#39;s Account Settings after purchase.</p>
//
//    <p>If any portion of the offered free trial period is unused, the unused portion will be forfeited if the user purchases a subscription for that portion, where applicable.</p>
//
//    <p>If you do not purchase an auto-renewing subscription, you can still use our app as normal, and any unlocked content will work normally after the subscription expires.</p>
//
//    <p><a href="https://sites.google.com/view/fast-print-terms-of-use/home">Terms of Use</a> & <a href="https://sites.google.com/view/fast-print-privacy-policy/home">Privacy Policy</a></p>
//    """
    

}

extension NEwBlueSubscribeVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url, UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            }
            return .cancel
        } else {
            return .allow
        }
    }
}

extension NEwBlueSubscribeVC {
    
    func updatePrice(productsm: [NEwBlueProManager.IAPProduct]?) {
        if let products = productsm {
            let product0 = products[0]
            let product1 = products[1]
            currentSymbol = product0.priceLocale.currencySymbol ?? "$"
            
            if product0.iapID == NEwBlueProManager.IAPType.month.rawValue {
                defaultMonthPrice = product0.price
                defaultYearPrice = product1.price
            } else {
                defaultYearPrice = product0.price
                defaultMonthPrice = product1.price
            }
        }
        
        monthPriceLabel.text = "\(currentSymbol)\(defaultMonthPrice)/month"
        monthPriceInfoLabel.text = "\(currentSymbol)\(defaultMonthPrice)/Month"
        yearPriceLabel.text = "\(currentSymbol)\(defaultYearPrice)/year"
        yearPriceInfoLabel.text = "\(currentSymbol)\(defaultYearPrice)/Year"
        //"\(currentSymbol)\(Double(defaultYearPrice/12).accuracyToString(position: 2))/mo"
    }
    
    func fetchPriceLabels() {
        
        if NEwBlueProManager.default.currentProducts.count == NEwBlueProManager.default.iapTypeList.count {
            updatePrice(productsm: NEwBlueProManager.default.currentProducts)
        } else {
            updatePrice(productsm: nil)
            NEwBlueProManager.default.fetchPurchaseInfo {[weak self] productList in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    if productList.count == NEwBlueProManager.default.iapTypeList.count {
                        self.updatePrice(productsm: productList)
                    }
                }
            }
        }
    }
    
    func updateIapBtnStatus() {
        if NEwBlueProManager.default.currentIapType == .year {
            yearBgBtn.layer.borderColor = UIColor(hexString: "#3971FF")!.cgColor
            monthBgBtn.layer.borderColor = UIColor(hexString: "#D2D7E5")!.cgColor
            monthSelectImgV.image = UIImage(named: "storeselect")
            yearSelectImgV.image = UIImage(named: "storeselect_s")
        } else if NEwBlueProManager.default.currentIapType == .month {
            monthBgBtn.layer.borderColor = UIColor(hexString: "#3971FF")!.cgColor
            yearBgBtn.layer.borderColor = UIColor(hexString: "#D2D7E5")!.cgColor
            monthSelectImgV.image = UIImage(named: "storeselect_s")
            yearSelectImgV.image = UIImage(named: "storeselect")
        }
    }
}

class PRStoreDesInfoLabel: UIView {
    var contentL = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentL)
        contentL.textColor = UIColor(hexString: "#242766")?.withAlphaComponent(0.7)
        contentL.font = UIFont(name: "Poppins-Medium", size: 16)
        contentL.textAlignment = .left
        contentL.snp.makeConstraints {
            $0.left.equalToSuperview().offset(34)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalToSuperview()
        }
        //
        let iconImgV = UIImageView()
        addSubview(iconImgV)
        iconImgV.image = UIImage(named: "Frame")
        iconImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

