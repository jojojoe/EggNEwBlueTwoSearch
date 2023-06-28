//
//  NEwSplashPageTwo.swift
//  NEwBlueTwoSearch
//
//  Created by sege li on 2023/6/11.
//

import UIKit

class NEwSplashPageTwo: UIView {


    var iconImgStr = "splashp3"
    var pointIconStr = "splpoint_3"
    var nameStr = "Find your lost Devices"
    let infoDEsL = UILabel()
    var continueClickBlock: (()->Void)?
    var cancelBtnClickBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupV()
        fetchPriceLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupV() {
        backgroundColor(.white)
        let iconImgV = UIImageView()
            .adhere(toSuperview: self) {
                $0.left.equalToSuperview().offset(25)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(safeAreaLayoutGuide.snp.centerY).offset(20)
                $0.height.equalTo(UIScreen.main.bounds.size.width)
            }
            .image(iconImgStr)
            .contentMode(.scaleAspectFit)
        //
        let contiNextBtn = UIButton()
            .adhere(toSuperview: self) {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(self.snp.bottom).offset(-24)
                $0.width.equalTo(400/2)
                $0.height.equalTo(160/2)
            }
            .backgroundImage(UIImage(named: "splash1button"))
            .target(target: self, action: #selector(contiNextBtnClick), event: .touchUpInside)
        
        
        
        //
        let bottomV = UIView()
            .adhere(toSuperview: self) {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(iconImgV.snp.bottom)
                $0.bottom.equalTo(contiNextBtn.snp.top).offset(-10)
            }
        //
        let nameL = UILabel()
            .adhere(toSuperview: bottomV) {
                $0.centerY.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.left.equalToSuperview().offset(10)
                $0.height.equalTo(44)
            }
            .font(UIFont.SFProTextHeavy, 28)
            .color(UIColor(hexString: "#262B55")!)
            .textAlignment(.center)
            .text(nameStr)
            .adjustsFontSizeToFitWidth()
        //
        
        infoDEsL
            .adhere(toSuperview: bottomV) {
                $0.top.equalTo(nameL.snp.bottom).offset(16)
                $0.centerX.equalToSuperview()
                $0.left.equalToSuperview().offset(10)
                $0.height.equalTo(42)
            }
            .font(UIFont.SFProTextMedium, 14)
            .color(UIColor(hexString: "#262B55")!.withAlphaComponent(0.5))
            .textAlignment(.center)
            .text("")
            .adjustsFontSizeToFitWidth()
            .numberOfLines(2)
        
        
        //
        let pointIconV = UIImageView()
            .adhere(toSuperview: bottomV) {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(nameL.snp.top).offset(-20)
                $0.width.equalTo(112/2)
                $0.height.equalTo(12/2)
            }
            .image(pointIconStr)
        
        //
        let cancelBtn = UIButton()
            .adhere(toSuperview: self) {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(contiNextBtn.snp.top).offset(-24)
                $0.width.equalTo(288)
                $0.height.equalTo(30)
            }
//            .titleColor(UIColor(hexString: "#262B55")!.withAlphaComponent(0.3))
//            .font(UIFont.SFProTextMedium, 12)
//            .backgroundImage(UIImage(named: "splash1button"))
            .target(target: self, action: #selector(cancelBtnClick), event: .touchUpInside)
        
        let attriStr = NSAttributedString(string: "Cancel anytime Or continue with limited version", attributes: [NSAttributedString.Key.font : UIFont(name: UIFont.SFProTextMedium, size: 12) ?? UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor(hexString: "#262B55")!.withAlphaComponent(0.3), NSAttributedString.Key.underlineStyle : 1, NSAttributedString.Key.underlineColor : UIColor(hexString: "#262B55")!.withAlphaComponent(0.3)])
        
        cancelBtn.setAttributedTitle(attriStr, for: .normal)
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
    
    
    func updatePrice() {
        let priceweektype = "\(NEwBlueProManager.default.currentSymbol)\(NEwBlueProManager.default.defaultWeekPrice)"
        infoDEsL.text = "Only \(priceweektype) per week. Get full features at no extra charge and commitment."
        
    }
    
    
    @objc func contiNextBtnClick() {
        continueClickBlock?()
    }
    @objc func cancelBtnClick() {
        cancelBtnClickBlock?()
    }
    

}
