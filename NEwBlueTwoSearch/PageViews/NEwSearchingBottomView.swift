//
//  NEwSearchingBottomView.swift
//  NEwBlueTwoSearch
//
//  Created by Joe on 2023/6/4.
//

import UIKit

class NEwSearchingBottomView: UIView {

    var collection: UICollectionView!
    var closeClickBlock: (()->Void)?
    var itemclickBlock: ((NEwPeripheralItem)->Void)?
    var refreshWating: Bool = false
    var allDevicePreviewView: [BSiegBlueDeviceSearchingPreview] = []
    var cellSize: CGSize = CGSize.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellSize = CGSize(width: CGFloat(Int(UIScreen.main.bounds.size.width / 3)), height: 140)
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
        layout.scrollDirection = .vertical
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
        closeClickBlock?()
    }
}

extension NEwSearchingBottomView {
    
    func fetchSearchingContents() {
        if !refreshWating {
            refreshWating = true
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
                [weak self] in
                guard let `self` = self else {return}
                self.refreshWating = false
            }
            //
            var currentSearchingPreviews: [BSiegBlueDeviceSearchingPreview] = []
            //
            for item in NEwBlueToolManager.default.peripheralItemList {
                
                var currenPre: BSiegBlueDeviceSearchingPreview!
                if let piver = allDevicePreviewView.first(where: { pre in
                    pre.peripheralItem == item
                }) {
                    currenPre = piver
                } else {
                    let vie = BSiegBlueDeviceSearchingPreview(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: cellSize), peripheralItem: item)
                    currenPre = vie
                }
                currenPre.updateItemContentStatus()
                currentSearchingPreviews.append(currenPre)
            }
            //
            sortedDeviceItems(list: currentSearchingPreviews)
            
        }
        
    }
    
    func sortedDeviceItems(list: [BSiegBlueDeviceSearchingPreview]) {
        var listpro: [BSiegBlueDeviceSearchingPreview] = []
        listpro = list.sorted { item1, item2 in
            return item1.peripheralItem.rssi > item2.peripheralItem.rssi
        }
        allDevicePreviewView = listpro
        collection.reloadData()
    }
}

extension NEwSearchingBottomView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: NEwSearchingItemCell.self, for: indexPath)
        let prev = allDevicePreviewView[indexPath.item]
        cell.contentBgV.removeSubviews()
        cell.contentBgV.addSubview(prev)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allDevicePreviewView.count
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
        let prev = allDevicePreviewView[indexPath.item]
        itemclickBlock?(prev.peripheralItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class NEwSearchingItemCell: UICollectionViewCell {
    let contentBgV = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        contentView.addSubview(contentBgV)
        contentBgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        
        
    }
}

class BSiegBlueDeviceSearchingPreview: UIView {
    
    var peripheralItem: NEwPeripheralItem
    let deviceIconImgV = UIImageView()
    let deviceNameLabel = UILabel()
    let distanceLabel = UILabel()
    
    var ringProgressView = RingProgressView()
    
    init(frame: CGRect, peripheralItem: NEwPeripheralItem) {
        self.peripheralItem = peripheralItem
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        //
        let iconbgV = UIView()
        addSubview(iconbgV)
        iconbgV.backgroundColor = UIColor(hexString: "#E8EDFF")
        iconbgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.width.height.equalTo(48)
        }
        iconbgV.layer.cornerRadius = 24
        iconbgV.clipsToBounds = true
        //
        deviceIconImgV.contentMode = .scaleAspectFit
        deviceIconImgV.clipsToBounds = true
        iconbgV.addSubview(deviceIconImgV)
        deviceIconImgV.snp.makeConstraints {
            $0.center.equalTo(iconbgV)
            $0.width.height.equalTo(32)
        }
        //
        iconbgV.addSubview(ringProgressView)
        ringProgressView.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        ringProgressView.progress = 0
        ringProgressView.startColor = UIColor(hexString: "#3971FF")!
        ringProgressView.endColor = UIColor(hexString: "#3971FF")!
        ringProgressView.backgroundRingColor = .clear
        ringProgressView.ringWidth = 3
        ringProgressView.shadowOpacity = 0
        ringProgressView.hidesRingForZeroProgress = true
        
        //
        deviceNameLabel.font = UIFont(name: "Poppins-Bold", size: 14)
        deviceNameLabel.textColor = UIColor(hexString: "#242766")
        deviceNameLabel.lineBreakMode = .byTruncatingTail
        deviceNameLabel.numberOfLines = 2
        deviceNameLabel.textAlignment = .center
        addSubview(deviceNameLabel)
        deviceNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(iconbgV.snp.bottom).offset(4)
            $0.bottom.equalToSuperview().offset(-25)
            $0.left.equalToSuperview().offset(10)
        }
        
        //
        addSubview(distanceLabel)
        distanceLabel.font = UIFont(name: "Poppins-Medium", size: 12)
        distanceLabel.textColor = UIColor(hexString: "#242766")?.withAlphaComponent(0.5)
        distanceLabel.adjustsFontSizeToFitWidth = true
        distanceLabel.textAlignment = .center
        distanceLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(deviceNameLabel.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
        }
        
    }
     
    func updateItemContentStatus() {
        
        let deviceNameStr = peripheralItem.deviceName
        let deviceIconStr = peripheralItem.deviceTagIconName(isSmall: true)
        let distancePercent = peripheralItem.deviceDistancePercent()
        let distanceAboutM = peripheralItem.fetchAboutDistanceString()
        //
        ringProgressView.progress = distancePercent
        deviceIconImgV.image = UIImage(named: deviceIconStr)
        deviceNameLabel.text = deviceNameStr
        distanceLabel.text = distanceAboutM
    }
}
