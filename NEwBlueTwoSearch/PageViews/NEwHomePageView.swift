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
    let scanCenterBgV = NEwCenterScanView()
    let tiLabel = UILabel()
    let probtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSubscribeStatus() {
        probtn.isHidden = true
    }
    
    func showSearchingStatus(isShow: Bool) {
        
        let offy = (self.frame.size.height / 2 - 70 - CGRectGetMaxY(tiLabel.frame)) / 2
        let targetw: CGFloat = offy * 2 - 40
        let scalew: CGFloat = targetw / 311
        debugPrint("offy - \(offy)")
        
        scanCenterBgV.startAnimal(isStart: isShow)
        
        
        UIView.animate(withDuration: 0.35, delay: 0) {
            
            if isShow {
                self.scanCenterBgV.transform = CGAffineTransform(translationX: 0, y: -offy)
                self.scanCenterBgV.transform = self.scanCenterBgV.transform.scaledBy(x: scalew, y: scalew)
            } else {
                self.scanCenterBgV.transform = CGAffineTransform.identity
            }
            
        }
    }
    
    func setupV() {
        
        //
        
        tiLabel
            .text("Bluetooth Scanner")
            .color(.white)
            .font(UIFont.SFProTextHeavy, 20)
            .adhere(toSuperview: self) {
                $0.left.equalToSuperview().offset(24)
//                $0.centerY.equalTo(probtn.snp.centerY).offset(0)
                $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(22)
                $0.width.greaterThanOrEqualTo(10)
                $0.height.equalTo(34)
            }
        
        //
        probtn
            .image(UIImage(named: "homepro"))
            .adhere(toSuperview: self) {
                $0.centerY.equalTo(tiLabel.snp.centerY).offset(0)
                $0.right.equalToSuperview().offset(-24)
                $0.width.equalTo(78)
                $0.height.equalTo(34)
            }
            .target(target: self, action: #selector(probtnClick), event: .touchUpInside)
        
        let centerBgV = UIView()
        centerBgV.adhere(toSuperview: self) {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(428)
            $0.centerY.equalToSuperview()
        }
        
        //
        
        scanCenterBgV.adhere(toSuperview: self) {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(centerBgV.snp.top)
            $0.width.height.equalTo(311)
        }
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
                $0.bottom.equalTo(centerBgV.snp.bottom).offset(0)
                $0.width.equalTo(260)
                $0.height.equalTo(56)
            }
            .target(target: self, action: #selector(tapStartScanClick), event: .touchUpInside)
        //
        let taptoLabel = UIButton()
        taptoLabel
            .title("Tap to Detect")
            .titleColor(.white)
            .font(UIFont.SFProTextMedium, 14)
            .adhere(toSuperview: self) {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(scanBtn.snp.top).offset(-12)
                $0.width.greaterThanOrEqualTo(10)
                $0.height.equalTo(18)
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
    }

}

extension NEwHomePageView {
    
}


class NEwCenterScanView: UIView {

    let layerV3 = UIImageView()
    let layerV2 = UIImageView()
    let layerV1 = UIImageView()
    
    private let radarAnimation = "radarAnimation"
    private let radarAnimation2 = "radarAnimatio2"
    private var animationLayer: CALayer?
    private var animationGroup: CAAnimationGroup?
    
    
    func startAnimal(isStart: Bool) {
        if isStart {
            startScanRotateAnimal()
        } else {
            stopScanRotateAnimal()
        }
    }
    
    
    func startScanRotateAnimal() {
        makeRadarAnimation(animalView: layerV3)
        makeRadarAnimation2(animalView: layerV2)
    }
    
    func stopScanRotateAnimal() {
        layerV3.layer.removeAnimation(forKey: radarAnimation)
        layerV2.layer.removeAnimation(forKey: radarAnimation2)
    }
    
    private func makeRadarAnimation(animalView: UIView) {
           
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0.0
        animation.toValue = CGFloat.pi * 2
        animation.duration  = 1
        animation.autoreverses = false
        animation.fillMode = .forwards
        animation.repeatCount = HUGE
        
        animalView.layer.add(animation, forKey: radarAnimation)
         
    }
    
    private func makeRadarAnimation2(animalView: UIView) {
           
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0.0
        animation.toValue = CGFloat.pi * 2
        animation.duration  = 4
        animation.autoreverses = false
        animation.fillMode = .forwards
        animation.repeatCount = HUGE
        
        animalView.layer.add(animation, forKey: radarAnimation2)
         
    }
    
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
