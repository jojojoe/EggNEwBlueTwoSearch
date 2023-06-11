//
//  NEwSplashPageOne.swift
//  NEwBlueTwoSearch
//
//  Created by Joe on 2023/6/11.
//

import UIKit

class NEwSplashPageOne: UIView {

    let nameStr = "Track Your Lost Devices"
    let infoStr = "Can't find your lost bluetooth\ndevices"
    var continueClickBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupV() {
        backgroundColor(.white)
        let iconImgV = UIImageView()
            .adhere(toSuperview: self) {
                $0.left.equalToSuperview().offset(0)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(safeAreaLayoutGuide.snp.centerY).offset(20)
                $0.height.equalTo(UIScreen.main.bounds.size.width)
            }
            .image("splashp1")
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
        let infoDEsL = UILabel()
            .adhere(toSuperview: bottomV) {
                $0.top.equalTo(nameL.snp.bottom).offset(16)
                $0.centerX.equalToSuperview()
                $0.left.equalToSuperview().offset(10)
                $0.bottom.equalToSuperview()
            }
            .font(UIFont.SFProTextMedium, 20)
            .color(UIColor(hexString: "#262B55")!.withAlphaComponent(0.5))
            .textAlignment(.center)
            .text(infoStr)
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
            .image("splpoint_1")
        
        
    }
    
    @objc func contiNextBtnClick() {
        continueClickBlock?()
    }

}
