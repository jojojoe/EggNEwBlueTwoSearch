//
//  NEwManualPageView.swift
//  NEwBlueTwoSearch
//
//  Created by Joe on 2023/6/4.
//

import UIKit

class NEwManualPageView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupV() {
        let topMenuBgV = UIButton()
        topMenuBgV.backgroundColor(.white)
            .cornerRadius(20)
            .title("Bluetooth")
            .titleColor(UIColor(hexString: "#6B95FF")!)
            .font(UIFont.SFProTextHeavy, 16)
            .isEnabled(false)
            .adhere(toSuperview: self) {
                $0.centerX.equalToSuperview()
                $0.left.equalToSuperview().offset(24)
                $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(17)
                $0.height.equalTo(40)
            }
        //
        let contentBgV = UIImageView()
            .adhere(toSuperview: self) {
                $0.left.equalToSuperview().offset(24)
                $0.centerX.equalToSuperview()
                $0.top.equalTo(topMenuBgV.snp.bottom).offset(32)
            }
            .contentMode(.scaleToFill)
            .image("manualbg")
        //
        let info1 = NEwManualBtn(frame: .zero, titStr: "Make sure your AirPods aren't\nin the case.")
        let info2 = NEwManualBtn(frame: .zero, titStr: "Bluetooth must be turned on.")
        let info3 = NEwManualBtn(frame: .zero, titStr: "Must still have battery left.")
        let info4 = NEwManualBtn(frame: .zero, titStr: "Must be within bluetooth signal\nrange.")
        
        info1.adhere(toSuperview: contentBgV) {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.height.equalTo(45)
        }
        info2.adhere(toSuperview: contentBgV) {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(info1.snp.bottom).offset(32)
            $0.height.equalTo(22)
        }
        info3.adhere(toSuperview: contentBgV) {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(info2.snp.bottom).offset(32)
            $0.height.equalTo(22)
        }
        info4.adhere(toSuperview: contentBgV) {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(info3.snp.bottom).offset(32)
            $0.height.equalTo(45)
        }
        
        
    }

}

class NEwManualBtn: UIButton {
    
    init(frame: CGRect, titStr: String) {
        super.init(frame: frame)
        
        //
        let iconImgV = UIImageView()
            .adhere(toSuperview: self) {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(20)
                $0.width.height.equalTo(20)
            }
            .image("manualIcon")
        //
        let titLabel = UILabel()
            .adhere(toSuperview: self) {
                $0.centerY.equalToSuperview()
                $0.left.equalTo(iconImgV.snp.right).offset(12)
                $0.right.equalToSuperview().offset(-20)
                $0.top.equalToSuperview()
            }
            .font(UIFont.SFProTextSemibold, 16)
            .textAlignment(.left)
            .color(.white)
            .numberOfLines(2)
            .text(titStr)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
