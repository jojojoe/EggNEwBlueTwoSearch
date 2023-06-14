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
    var devicesContentClickBlock: (()->Void)?
    var itemclickBlock: ((NEwPeripheralItem)->Void)?
    var refreshWating: Bool = false
    let bottomV = UIView()
    var cellSize: CGSize = CGSize.zero
    let titLabel1 = UILabel()
    let titLabel2 = UILabel()
    let deviceContentBtn = UIButton()
    let noDeviceBgV = UIView()
    var ringProgressViewList: [String:RingProgressView] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellSize = CGSize(width: CGFloat(Int((UIScreen.main.bounds.size.width - 1) / 3)), height: 140)
        setupV()
        addNoti()
    }
    
    func showContentStatus(isShow: Bool) {
        var alphav: CGFloat = 0
        if isShow {
            alphav = 1
            bottomV.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(self.snp.top).offset(65)
                $0.height.equalTo(UIScreen.main.bounds.size.height / 2 + 40)
            }
        } else {
            bottomV.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(self.snp.bottom).offset(30)
                $0.height.equalTo(UIScreen.main.bounds.size.height / 2 + 40)
                
            }
        }
        UIView.animate(withDuration: 0.35, delay: 0) {
            self.setNeedsLayout()
            self.layoutIfNeeded()
            self.titLabel1.alpha = alphav
            self.titLabel2.alpha = alphav
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addNoti() {
        NotificationCenter.default.addObserver(self, selector:#selector(discoverDeviceUpdate(notification:)) , name: NEwBlueToolManager.default.discoverDeviceNotiName, object: nil)
        
    }
    
    func removeNoti() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func discoverDeviceUpdate(notification: Notification) {
        DispatchQueue.main.async {
            if NEwBlueToolManager.default.bluePeripheralList.count == 0 {
                self.noDeviceBgV.isHidden = false
            } else {
                self.noDeviceBgV.isHidden = true
            }
            self.collection.reloadData()
            self.deviceContentBtn
                .title("\(NEwBlueToolManager.default.bluePeripheralList.count) nearby devices found")
        }
    }
    
    func setupV() {
        //
        titLabel1.alpha = 0
        titLabel2.alpha = 0
        //
        addSubview(bottomV)
        bottomV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.size.width)
            $0.top.equalTo(self.snp.bottom).offset(30)
            $0.height.equalTo(UIScreen.main.bounds.size.height / 2 + 40)
        }
        bottomV
            .cornerRadius(30, masksToBounds: false)
            .shadow(color: UIColor(hexString: "#385EE5"), radius: 20, opacity: 0.3, offset: CGSize(width: 0, height: 0), path: nil)
            .backgroundColor(UIColor(hexString: "#F1F4FF")!)
        
        //
        titLabel2.adhere(toSuperview: self) {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(bottomV.snp.top).offset(-12)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        .text("Please do not interrupt the operation")
        .font(UIFont.SFProTextRegular, 14)
        .color(.white)
        //
        titLabel1.adhere(toSuperview: self) {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(titLabel2.snp.top).offset(-12)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        .text("Searching...")
        .font(UIFont.SFProTextSemibold, 16)
        .color(.white)
        
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
        bottomV.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalTo(closeBtn.snp.bottom).offset(5)
            $0.right.left.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.size.height / 2 - 70 - 70)
        }
        collection.register(cellWithClass: NEwSearchingItemCell.self)
        //
        deviceContentBtn.adhere(toSuperview: bottomV) {
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
            $0.top.equalTo(collection.snp.bottom).offset(0)
        }
        .title("\(NEwBlueToolManager.default.bluePeripheralList.count) nearby devices found")
        .titleColor(UIColor(hexString: "#3971FF")!)
        .font(UIFont.SFProTextSemibold, 14)
        .target(target: self, action: #selector(deviceContentBtnClick), event: .touchUpInside)
        let deviceContentArrowImgV = UIImageView()
        deviceContentArrowImgV.image("CaretDoubleRight")
            .adhere(toSuperview: deviceContentBtn) {
                $0.centerY.equalToSuperview()
                if let label = deviceContentBtn.titleLabel {
                    $0.left.equalTo(label.snp.right).offset(10)
                } else {
                    $0.centerX.equalToSuperview()
                }
                $0.width.height.equalTo(12)
            }
        
        //
        noDeviceBgV
            .backgroundColor(UIColor(hexString: "#F1F4FF")!)
            .adhere(toSuperview: bottomV) {
                $0.left.right.bottom.equalToSuperview()
                $0.top.equalTo(collection.snp.top)
            }
        let noDeviImgV = UIImageView()
            .image("search_no")
            .adhere(toSuperview: noDeviceBgV) {
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview().offset(-50)
                $0.width.height.equalTo(120)
            }
        let noDeviLabe = UILabel()
            .adhere(toSuperview: noDeviceBgV) {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(noDeviImgV.snp.bottom).offset(20)
                $0.width.height.greaterThanOrEqualTo(12)
            }
            .color(UIColor(hexString: "#262B55")!.withAlphaComponent(0.5))
            .font(UIFont.SFProTextSemibold, 14)
            .text("No devices found")
            .textAlignment(.center)
        
        self.noDeviceBgV.isHidden = true
//        if NEwBlueToolManager.default.peripheralItemList.count == 0 {
//            self.noDeviceBgV.isHidden = false
//        } else {
//            self.noDeviceBgV.isHidden = true
//        }
    }

}

extension NEwSearchingBottomView {
    
    @objc func closeBtnClick() {
        closeClickBlock?()
    }
    
    @objc func deviceContentBtnClick() {
        devicesContentClickBlock?()
    }

    
    func setupRingProgressV() -> RingProgressView {
        let ringProgressView = RingProgressView()
        ringProgressView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        ringProgressView.startColor = UIColor(hexString: "#3971FF")!
        ringProgressView.endColor = UIColor(hexString: "#3971FF")!
        ringProgressView.backgroundRingColor = .clear
        ringProgressView.ringWidth = 3
        ringProgressView.shadowOpacity = 0
        ringProgressView.hidesRingForZeroProgress = true
        ringProgressView.progress = 0
        return ringProgressView
    }
    
}

extension NEwSearchingBottomView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: NEwSearchingItemCell.self, for: indexPath)
        let preitem = NEwBlueToolManager.default.bluePeripheralList[indexPath.item]
        cell.updateItemContentStatus(peripheralItem: preitem)
        var rinigV = ringProgressViewList[preitem.identifier]
        if rinigV == nil {
            rinigV = setupRingProgressV()
            ringProgressViewList[preitem.identifier] = rinigV
        }
        cell.iconbgV.removeSubviews()
        cell.iconbgV.addSubview(rinigV!)
        rinigV!.progress = preitem.blueDeviceDistancePercentDouble()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NEwBlueToolManager.default.bluePeripheralList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension NEwSearchingBottomView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension NEwSearchingBottomView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let preitem = NEwBlueToolManager.default.bluePeripheralList[indexPath.item]
        itemclickBlock?(preitem)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class NEwSearchingItemCell: UICollectionViewCell {
    
    var peripheralItem: NEwPeripheralItem?
    let deviceIconImgV = UIImageView()
    let deviceNameLabel = UILabel()
    let distanceLabel = UILabel()
    let iconbgV = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        //
        contentView.addSubview(iconbgV)
        iconbgV.backgroundColor = UIColor(hexString: "#E8EDFF")
        let cellW: CGFloat = CGFloat(Int((UIScreen.main.bounds.size.width - 1) / 3))
        iconbgV.frame = CGRect(x: (cellW - 60)/2, y: 0, width: 60, height: 60)
        iconbgV.layer.cornerRadius = 30
        iconbgV.clipsToBounds = false
        //
        deviceIconImgV.contentMode = .scaleAspectFit
        deviceIconImgV.clipsToBounds = true
        contentView.addSubview(deviceIconImgV)
        deviceIconImgV.snp.makeConstraints {
            $0.center.equalTo(iconbgV)
            $0.top.left.equalToSuperview().offset(12)
        }
        
        //
        deviceNameLabel.font = UIFont(name: UIFont.SFProTextSemibold, size: 14)
        deviceNameLabel.textColor = UIColor(hexString: "#262B55")
        deviceNameLabel.lineBreakMode = .byTruncatingTail
        deviceNameLabel.numberOfLines = 2
        deviceNameLabel.textAlignment = .center
        contentView.addSubview(deviceNameLabel)
        deviceNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(iconbgV.snp.bottom).offset(4)
            $0.bottom.equalToSuperview().offset(-25)
            $0.left.equalToSuperview().offset(10)
        }
        
        //
        contentView.addSubview(distanceLabel)
        distanceLabel.font = UIFont(name: UIFont.SFProTextBold, size: 12)
        distanceLabel.textColor = UIColor(hexString: "#3971FF")
        distanceLabel.backgroundColor = .clear
        distanceLabel.adjustsFontSizeToFitWidth = true
        distanceLabel.textAlignment = .center
        distanceLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(22)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(54)
        }
        distanceLabel.layer.borderColor = UIColor(hexString: "#3971FF")!.cgColor
        distanceLabel.layer.borderWidth = 1
        distanceLabel.layer.cornerRadius = 11
        
        //
        
    }
    
    
    func updateItemContentStatus(peripheralItem: NEwPeripheralItem) {
        self.peripheralItem = peripheralItem
        let deviceNameStr = peripheralItem.deviceName
        
        let deviceIconStr = peripheralItem.deviceTagIconName(isBig: false)
//        let distancePercent = peripheralItem.deviceDistancePercent()
        let distanceAboutM = peripheralItem.fetchAboutDistanceString()
        //
        deviceIconImgV.image = UIImage(named: deviceIconStr)
        deviceNameLabel.text = deviceNameStr
        distanceLabel.text = distanceAboutM
//        ringProgressView.progress = peripheralItem.deviceDistancePercent()
        
//        if self.iconbgV != peripheralItem.ringProgressView.superview {
//            self.iconbgV.removeSubviews()
//            let ringBound = CGRect(x: 0, y: 0, width: 60, height: 60)
//            peripheralItem.ringProgressView.frame = ringBound
//            self.iconbgV.addSubview(peripheralItem.ringProgressView)
//
//        }
        

    }
    
}
