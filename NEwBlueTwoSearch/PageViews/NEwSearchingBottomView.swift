//
//  NEwSearchingBottomView.swift
//  NEwBlueTwoSearch
//
//  Created by Joe on 2023/6/4.
//

import UIKit

class NEwSearchingBottomView: UIView {

    var collection: UICollectionView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupV() {
        let titLabel1 = UILabel()
        titLabel1.adhere(toSuperview: self) {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(10)
        }
        .text("Searching...")
        .font(UIFont.SFProTextSemibold, 16)
        .color(.white)
        let titLabel2 = UILabel()
        titLabel2.adhere(toSuperview: self) {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titLabel1.snp.bottom).offset(12)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        .text("Please do not interrupt the operation")
        .font(UIFont.SFProTextRegular, 14)
        .color(.white)
        //
        let bottomV = UIView()
            .adhere(toSuperview: self) {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(titLabel2.snp.bottom).offset(16)
                $0.bottom.equalToSuperview().offset(40)
            }
            .cornerRadius(30, masksToBounds: false)
            .shadow(color: UIColor(hexString: "#385EE5"), radius: 20, opacity: 0.3, offset: CGSize(width: 0, height: 0), path: nil)
        //
        let closeBtn = UIButton()
            .adhere(toSuperview: bottomV) {
                $0.top.left.right.equalToSuperview()
                $0.height.equalTo(44)
            }
            .image(UIImage(named: "searchingclose"))
            .target(target: self, action: #selector(closeBtnClick), event: .touchUpInside)
        //
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalTo(closeBtn.snp.bottom).offset(5)
            $0.right.left.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-80)
        }
        collection.register(cellWithClass: NEwSearchingItemCell.self)
    }

    
    @objc func closeBtnClick() {
        
    }
}

extension NEwSearchingBottomView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: NEwSearchingItemCell.self, for: indexPath)
        
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension NEwSearchingBottomView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cewidth: CGFloat = CGFloat(Int(UIScreen.main.bounds.size.width / 3))
        return CGSize(width: cewidth, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
}

extension NEwSearchingBottomView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class NEwSearchingItemCell: UICollectionViewCell {
    let contentV = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        contentView.addSubview(contentV)
        contentImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        
        
    }
}

class BSiegBlueDevicePreview: UIView {
    
    var peripheralItem: NEwPeripheralItem
     
    let contentImgV = UIImageView()
    let deviceNameLabel = UILabel()
    let describeLabel = UILabel()
    
    var ringProgressView = RingProgressView()
    
    init(frame: CGRect, peripheralItem: NEwPeripheralItem) {
        self.peripheralItem = NEwPeripheralItem
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        //
        let iconbgV = UIView()
        self.addSubview(iconbgV)
        iconbgV.backgroundColor = UIColor(hexString: "#E8EDFF")
        iconbgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.width.height.equalTo(48)
        }
        iconbgV.layer.cornerRadius = 24
        iconbgV.clipsToBounds = true
        //
        contentImgV.contentMode = .scaleAspectFit
        contentImgV.clipsToBounds = true
        addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.center.equalTo(iconbgV)
            $0.width.height.equalTo(32)
        }
        //
        iconbgV.addSubview(ring1V)
        ring1V.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        ring1V.startColor = UIColor(hexString: "#3971FF")!
        ring1V.endColor = UIColor(hexString: "#3971FF")!
        ring1V.ringWidth = 3
        ring1V.backgroundRingColor = .clear
        ring1V.hidesRingForZeroProgress = true
        ring1V.shadowOpacity = 0
        ring1V.progress = 0
        //
        
        self.addSubview(deviceNameLabel)
        deviceNameLabel.font = UIFont(name: "Poppins-Bold", size: 14)
        deviceNameLabel.textColor = UIColor(hexString: "#242766")
        deviceNameLabel.lineBreakMode = .byTruncatingTail
        deviceNameLabel.textAlignment = .left
        deviceNameLabel.snp.makeConstraints {
            $0.left.equalTo(iconbgV.snp.right).offset(15)
            $0.top.equalTo(iconbgV.snp.top)
            $0.bottom.equalTo(iconbgV.snp.centerY)
            $0.right.equalToSuperview().offset(-50)
        }
        
        //
        self.addSubview(describeLabel)
        describeLabel.font = UIFont(name: "Poppins-Medium", size: 12)
        describeLabel.textColor = UIColor(hexString: "#242766")?.withAlphaComponent(0.5)
//        describeLabel.lineBreakMode = .byTruncatingTail
        describeLabel.adjustsFontSizeToFitWidth = true
        describeLabel.textAlignment = .left
        describeLabel.snp.makeConstraints {
            $0.left.equalTo(iconbgV.snp.right).offset(15)
            $0.top.equalTo(iconbgV.snp.centerY)
            $0.bottom.equalTo(iconbgV.snp.bottom)
            $0.right.equalToSuperview().offset(-50)
        }
        
        //
        let arrowImgV = UIImageView()
        arrowImgV.contentMode = .scaleAspectFit
        arrowImgV.image = UIImage(named: "CaretRight")
        arrowImgV.clipsToBounds = true
        addSubview(arrowImgV)
        arrowImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-14)
            $0.width.height.equalTo(20)
        }
         
        //
        
    }
     
    func updateContent() {
        
        let deviceIconStr = peripheralItem.deviceTagIconName(isSmall: true)
        let deviceNameStr = peripheralItem.deviceName
        let distancePercent = peripheralItem.deviceDistancePercent()
        debugPrint("cell update deviceName: \(deviceNameStr) distancePercent - \(distancePercent)")
        contentImgV.image = UIImage(named: deviceIconStr)
        deviceNameLabel.text = deviceNameStr
        ring1V.progress = distancePercent
        describeLabel.text = peripheralItem.fetchDistanceString()
    }
}
