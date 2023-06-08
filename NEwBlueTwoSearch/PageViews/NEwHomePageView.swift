//
//  NEwHomePageView.swift
//  NEwBlueTwoSearch
//
//  Created by Joe on 2023/6/4.
//

import UIKit

class NEwHomePageView: UIView {
    var fatherFuVC: UIViewController?
    var startScanBlock: (()->Void)?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupV() {
        //
        let probtn = UIButton()
            .image(UIImage(named: "homepro"))
            .adhere(toSuperview: self) {
                $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
                $0.right.equalToSuperview().offset(-24)
                $0.width.equalTo(78)
                $0.height.equalTo(34)
            }
            .target(target: self, action: #selector(probtnClick), event: .touchUpInside)
        //
        let tiLabel = UILabel()
            .text("Bluetooth Scanner")
            .color(.white)
            .font(UIFont.SFProTextHeavy, 20)
            .adhere(toSuperview: self) {
                $0.left.equalToSuperview().offset(24)
                $0.centerY.equalTo(probtn.snp.centerY).offset(0)
                $0.width.greaterThanOrEqualTo(10)
                $0.height.equalTo(34)
            }
        //
        let centerBgV = UIView()
        centerBgV.adhere(toSuperview: self) {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(428)
            $0.centerY.equalToSuperview()
        }
        
        //
        let scanCenterBgV = NEwCenterScanView()
        scanCenterBgV.adhere(toSuperview: centerBgV) {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.height.equalTo(311)
        }
        //
        let taptoLabel = UIButton()
        taptoLabel
            .title("Tap to Detect")
            .titleColor(.white)
            .font(UIFont.SFProTextMedium, 14)
            .adhere(toSuperview: self) {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(scanCenterBgV.snp.bottom).offset(30)
                $0.width.greaterThanOrEqualTo(10)
                $0.height.equalTo(18)
            }
            .target(target: self, action: #selector(tapStartScanClick), event: .touchUpInside)
        //
        let scanBtn = UIButton()
        scanBtn
            .title("Start Scan")
            .titleColor(UIColor(hexString: "#6B95FF")!)
            .font(UIFont.SFProTextSemibold, 16)
            .backgroundColor(.white)
            .cornerRadius(28)
            .adhere(toSuperview: self) {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(taptoLabel.snp.bottom).offset(12)
                $0.width.equalTo(260)
                $0.height.equalTo(56)
            }
            .target(target: self, action: #selector(tapStartScanClick), event: .touchUpInside)
        
    }
    
    @objc func probtnClick() {
        if let fvc = fatherFuVC {
            NEwBlueToolManager.default.showOpenSubscribeProVC(fuVC: fvc)
        }
    }
    
    @objc func tapStartScanClick() {
        startScanBlock?()
//        
//        if NEwBlueToolManager.default.centralManagerStatus == true {
//            showSearchingBanner(isShow: true)
//            BSiesBabyBlueManager.default.peripheralItemList = []
//            BSiesBabyBlueManager.default.startScan()
//        } else {
//            showBluetoothDeniedAlertV()
//        }
    }

}

extension NEwHomePageView {
    showSearchingBanner
}


class NEwCenterScanView: UIView {

    let layerV3 = UIImageView()
    let layerV2 = UIImageView()
    let layerV1 = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupV() {
        
        layerV3
            .image("search_layer3")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: self) {
                $0.left.top.bottom.right.equalToSuperview()
            }
        layerV2
            .image("search_layer2")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: self) {
                $0.left.top.bottom.right.equalToSuperview()
            }
        layerV1
            .image("search_layer1")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: self) {
                $0.left.top.bottom.right.equalToSuperview()
            }
        let layerVcenter = UIImageView()
            .image("searchIcon_center")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: self) {
                $0.left.top.bottom.right.equalToSuperview()
            }
        
        
    }

}
