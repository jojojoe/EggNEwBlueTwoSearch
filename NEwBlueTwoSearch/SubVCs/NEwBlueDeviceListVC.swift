//
//  NEwBlueDeviceListVC.swift
//  NEwBlueTwoSearch
//
//  Created by JOJO on 2023/6/6.
//

import UIKit

class NEwBlueDeviceListVC: UIViewController {

    
    var collection: UICollectionView!
    var itemclickBlock: ((NEwPeripheralItem)->Void)?
    var searchAgainClickBlock: (()->Void)?
    var refreshWating: Bool = false
    
    var allDevicePreviewView: [BSiegBlueDevicePreview] = []
    var myDevicePreviewView: [BSiegBlueDevicePreview] = []
    var otherDevicePreviewView: [BSiegBlueDevicePreview] = []
    
    let cellSize: CGSize = CGSize(width: UIScreen.main.bounds.width - 24 * 2, height: 78)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentV()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    func setupContentV() {
        view.backgroundColor = .clear
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: NEwDeviceListCell.self)
        collection.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: BSiegBlueHeader.self)
        
        
    }
    
    func updateContentDevice() {
        if !refreshWating {
            refreshWating = true
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                [weak self] in
                guard let `self` = self else {return}
                self.refreshWating = false
            }
            
            myDevicePreviewView = []
            otherDevicePreviewView = []
            
            
            //
            NEwBlueToolManager.default.peripheralItemList.forEach { item in
                var currenPreview: BSiegBlueDevicePreview!
                if let pv = allDevicePreviewView.first(where: { prev in
                    prev.peripheralItem == item
                }) {
                    currenPreview = pv
                } else {
                    let v = BSiegBlueDevicePreview(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: cellSize), peripheralItem: item)
                    currenPreview = v
                }
                currenPreview.updateContent()
                
                if NEwBlueToolManager.default.favoriteDevicesIdList.contains(item.identifier) {
                    myDevicePreviewView.append(currenPreview)
                } else {
                    otherDevicePreviewView.append(currenPreview)
                }
            }
            sortedItems()
            
        }
        
    }
    
    func sortedItems() {
        //
//        myDevicePreviewView = myDevicePreviewView.sorted { item1, item2 in
//            return item1.peripheralItem.rssi > item2.peripheralItem.rssi
//        }
//        otherDevicePreviewView = otherDevicePreviewView.sorted { item1, item2 in
//            return item1.peripheralItem.rssi > item2.peripheralItem.rssi
//        }
//        
//        allDevicePreviewView = myDevicePreviewView + otherDevicePreviewView
//        collection.reloadData()
    }


}



extension NEwBlueDeviceListVC: UICollectionViewDataSource {
    
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: NEwDeviceListCell.self, for: indexPath)
         
        var preview: BSiegBlueDevicePreview!
        
        if myDevicePreviewView.count == 0 && otherDevicePreviewView.count == 0 {
            
        } else if myDevicePreviewView.count == 0 && otherDevicePreviewView.count != 0 {
            preview = otherDevicePreviewView[indexPath.item]
        } else if myDevicePreviewView.count != 0 && otherDevicePreviewView.count == 0 {
            preview = myDevicePreviewView[indexPath.item]
            cell.favoButton.isSelected = true
            
        } else {
            if indexPath.section == 0 {
                preview = myDevicePreviewView[indexPath.item]
                cell.favoButton.isSelected = true
            } else {
                preview = otherDevicePreviewView[indexPath.item]
                cell.favoButton.isSelected = false
            }

        }
        cell.contentBgV.removeSubviews()
        
        cell.contentBgV.addSubview(preview)
        cell.contentPreview = preview
        preview.updateContent()
        
        cell.favoClickBlock = {
            [weak self] favoStatus, deviceid in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if deviceid.count >= 1 {
                    if favoStatus {
                        NEwBlueToolManager.default.addUserFavorite(deviceId: deviceid)
                    } else {
                        NEwBlueToolManager.default.removeUserFavorite(deviceId: deviceid)
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                        [weak self] in
                        guard let `self` = self else {return}
                        self.updateContentDevice()
                    }
                    
                }
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if myDevicePreviewView.count == 0 && otherDevicePreviewView.count == 0 {
            return 0
        } else if myDevicePreviewView.count == 0 && otherDevicePreviewView.count != 0 {
            return otherDevicePreviewView.count
        } else if myDevicePreviewView.count != 0 && otherDevicePreviewView.count == 0 {
            return myDevicePreviewView.count
        } else {
            if section == 0 {
                return myDevicePreviewView.count
            } else {
                return otherDevicePreviewView.count
            }
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if myDevicePreviewView.count == 0 && otherDevicePreviewView.count == 0 {
            return 0
        } else if myDevicePreviewView.count == 0 && otherDevicePreviewView.count != 0 {
            return 1
        } else if myDevicePreviewView.count != 0 && otherDevicePreviewView.count == 0 {
            return 1
        } else {
            return 2
        }
        return 1
    }
    
}

extension NEwBlueDeviceListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let bottomOffset: CGFloat = 160
        if myDevicePreviewView.count == 0 && otherDevicePreviewView.count == 0 {
            return UIEdgeInsets(top: 10, left: 24, bottom: bottomOffset, right: 24)
        } else if myDevicePreviewView.count == 0 && otherDevicePreviewView.count != 0 {
            return UIEdgeInsets(top: 10, left: 24, bottom: bottomOffset, right: 24)
        } else if myDevicePreviewView.count != 0 && otherDevicePreviewView.count == 0 {
            return UIEdgeInsets(top: 10, left: 24, bottom: bottomOffset, right: 24)
        } else {
            if section == 0 {
                return UIEdgeInsets(top: 10, left: 24, bottom: 10, right: 24)
            } else {
                return UIEdgeInsets(top: 10, left: 24, bottom: bottomOffset, right: 24)
            }
            
        }
        return UIEdgeInsets(top: 10, left: 24, bottom: 10, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if myDevicePreviewView.count == 0 && otherDevicePreviewView.count == 0 {
            return CGSize(width: 0, height: 0)
        } else if myDevicePreviewView.count == 0 && otherDevicePreviewView.count != 0 {
            return CGSize(width: 0, height: 0)
        } else if myDevicePreviewView.count != 0 && otherDevicePreviewView.count == 0 {
            if section == 0 {
                return CGSize(width: UIScreen.main.bounds.size.width, height: 64)
            } else {
                return CGSize(width: 0, height: 0)
            }
            
        } else {
            return CGSize(width: UIScreen.main.bounds.size.width, height: 64)
        }
        return CGSize(width: UIScreen.main.bounds.size.width, height: 64)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withClass: BSiegBlueHeader.self, for: indexPath)
            if myDevicePreviewView.count == 0 && otherDevicePreviewView.count == 0 {

            } else if myDevicePreviewView.count == 0 && otherDevicePreviewView.count != 0 {
                
            } else if myDevicePreviewView.count != 0 && otherDevicePreviewView.count == 0 {
                if indexPath.section == 0 {
                    view.tiNameLabel.text = "My Devices"
                }
            } else {
                if indexPath.section == 0 {
                    view.tiNameLabel.text = "My Devices"
                } else {
                    view.tiNameLabel.text = "Other Devices"
                }
            }
            return view
        }
        return UICollectionReusableView()
    }
    
}

extension NEwBlueDeviceListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var previewView: BSiegBlueDevicePreview!
        
        if myDevicePreviewView.count == 0 && otherDevicePreviewView.count == 0 {
            
        } else if myDevicePreviewView.count == 0 && otherDevicePreviewView.count != 0 {
            previewView = otherDevicePreviewView[indexPath.item]
        } else if myDevicePreviewView.count != 0 && otherDevicePreviewView.count == 0 {
            previewView = myDevicePreviewView[indexPath.item]
        } else {
            if indexPath.section == 0 {
                previewView = myDevicePreviewView[indexPath.item]
            } else {
                previewView = otherDevicePreviewView[indexPath.item]
            }
        }
        itemclickBlock?(previewView.peripheralItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class BSiegBlueHeader: UICollectionReusableView {
    let tiNameLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(tiNameLabel)
        tiNameLabel.font = UIFont(name: "Poppins-Bold", size: 20)
        tiNameLabel.textColor = UIColor(hexString: "#242766")
        tiNameLabel.textAlignment = .left
        tiNameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
            $0.width.greaterThanOrEqualTo(10)
            $0.height.greaterThanOrEqualTo(24)
        }
        
    }
    
    
    
}

class BSiegBlueDevicePreview: UIView {
    var peripheralItem: NEwPeripheralItem
     
    let contentImgV = UIImageView()
    let deviceNameLabel = UILabel()
    let describeLabel = UILabel()
    
    var ring1V = RingProgressView()
    
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

class NEwDeviceListCell: NEwSwipeCollectionCell {
    var contentBgV = UIView()
    var contentPreview: BSiegBlueDevicePreview!
    var favoButton: UIButton!
    var favoClickBlock: ((Bool, String)->Void)?
    
    override init(frame: CGRect) {
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
        
        contentView.addSubview(contentBgV)
        contentBgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
      
        //
        favoButton = UIButton(frame: CGRect(x: 0, y: 0, width: 90, height: self.bounds.height))
        favoButton.layer.cornerRadius = 20
        favoButton.setBackgroundImage(UIImage(named: "cell_heart_n"), for: .normal)
        favoButton.setBackgroundImage(UIImage(named: "cell_heart_s"), for: .selected)
        favoButton.roundCorners([.topRight, .bottomRight], radius: 20)
        favoButton.addTarget(self, action: #selector(favoButtonSelf(sender: )), for: .touchUpInside)
        self.revealView = favoButton
    }
    
    @objc func favoButtonSelf(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.hideRevealView(withAnimated: true)
        favoClickBlock?(sender.isSelected, contentPreview.peripheralItem.identifier)
    }
    
}


