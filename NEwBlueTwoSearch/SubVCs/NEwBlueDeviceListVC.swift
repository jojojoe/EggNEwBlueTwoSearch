//
//  NEwBlueDeviceListVC.swift
//  NEwBlueTwoSearch
//
//  Created by JOJO on 2023/6/6.
//

import UIKit

class NEwBlueDeviceListVC: UIViewController {
    
    var collection: UICollectionView!
    let cellSize: CGSize = CGSize(width: UIScreen.main.bounds.width - 24 * 2, height: 80)
    var restartClickBlock: (()->Void)?
    var ringProgressViewList: [String:RingProgressView] = [:]
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentV()
        addNoti()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addNoti() {
        NotificationCenter.default.addObserver(self, selector:#selector(discoverDeviceUpdate(notification:)) , name: NEwBlueToolManager.default.discoverDeviceNotiName, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(deviceFavoriteChange(notification:)) , name: NEwBlueToolManager.default.deviceFavoriteChangeNotiName, object: nil)
    }
    
    func removeNoti() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func discoverDeviceUpdate(notification: Notification) {
        DispatchQueue.main.async {
            self.collection.reloadData()
        }
    }
    
    @objc func deviceFavoriteChange(notification: Notification) {
        DispatchQueue.main.async {
            self.collection.reloadData()
        }
    }
    
    func setupContentV() {
        view.clipsToBounds = true
        view.backgroundColor(UIColor(hexString: "#F1F4FF")!)
        //
        let backButton = UIButton()
        
        backButton.adhere(toSuperview: view) {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.width.height.equalTo(44)
        }
        .image(UIImage(named: "back_ic"))
        .target(target: self, action: #selector(backBClick), event: .touchUpInside)
        //
        let titleDeviceNameLabel = UILabel()
        titleDeviceNameLabel.adhere(toSuperview: view) {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton.snp.centerY)
            $0.left.equalTo(backButton.snp.right).offset(10)
            $0.height.equalTo(44)
        }
        .lineBreakMode(.byTruncatingTail)
        .text("Connect Device")
        .color(UIColor(hexString: "#262B55")!)
        .font(UIFont.SFProTextBold, 20)
        .textAlignment(.center)
        
        
        //
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
            $0.right.left.equalToSuperview()
            $0.top.equalTo(backButton.snp.bottom).offset(8)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-80)
        }
        collection.register(cellWithClass: NEwDeviceListCell.self)
        collection.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: NEwBlueDeviceHeader.self)
        
        //
        let restartBtn = UIButton()
        restartBtn.adhere(toSuperview: view) {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(collection.snp.bottom).offset(5)
            $0.width.equalTo(326)
            $0.height.equalTo(60)
        }
        .backgroundImage(UIImage(named: "restartbutton"))
        .title("Restart")
        .tintColor(.white)
        .font(UIFont.SFProTextBold, 16)
        .shadow(color: UIColor(hexString: "#242766")!, radius: 10, opacity: 0.05, offset: CGSize(width: 0, height: 5), path: nil)
        .target(target: self, action: #selector(restartBtnClick), event: .touchUpInside)
    }
    
    @objc func backBClick() {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func restartBtnClick() {
        restartClickBlock?()
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func setupRingProgressV() -> RingProgressView {
        let ringProgressView = RingProgressView()
        ringProgressView.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
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



extension NEwBlueDeviceListVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: NEwDeviceListCell.self, for: indexPath)
         
        var periphItem: NEwPeripheralItem?
        if NEwBlueToolManager.default.favoHotPeriItemsList.count == 0 && NEwBlueToolManager.default.unotherPeriItemsList.count == 0 {
            
        } else if NEwBlueToolManager.default.favoHotPeriItemsList.count == 0 && NEwBlueToolManager.default.unotherPeriItemsList.count != 0 {
            periphItem = NEwBlueToolManager.default.unotherPeriItemsList[indexPath.item]
        } else if NEwBlueToolManager.default.favoHotPeriItemsList.count != 0 && NEwBlueToolManager.default.unotherPeriItemsList.count == 0 {
            periphItem = NEwBlueToolManager.default.favoHotPeriItemsList[indexPath.item]
            cell.favoButton.isSelected = true
        } else {
            if indexPath.section == 0 {
                periphItem = NEwBlueToolManager.default.favoHotPeriItemsList[indexPath.item]
                cell.favoButton.isSelected = true
            } else {
                periphItem = NEwBlueToolManager.default.unotherPeriItemsList[indexPath.item]
                cell.favoButton.isSelected = false
            }

        }
        if let preitem = periphItem {
            cell.updateItemContentStatus(peripheralItem: preitem)
            
            //
            var rinigV = ringProgressViewList[preitem.identifier]
            if rinigV == nil {
                rinigV = setupRingProgressV()
                ringProgressViewList[preitem.identifier] = rinigV
            }
            cell.iconbgV.removeSubviews()
            cell.iconbgV.addSubview(rinigV!)
            rinigV!.progress = preitem.deviceDistancePercent()
            
        }
        
        
        cell.favoClickBlock = {
            [weak self] favoStatus, deviceid in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if deviceid.count >= 1 {
                    if favoStatus {
                        NEwBlueToolManager.default.appendUserFavoriteBlueDevice(deviceId: deviceid)
                    } else {
                        NEwBlueToolManager.default.removeUserFavorite(deviceId: deviceid)
                    }
                    cell.contentView.alpha = 1
                    cell.backgroundColor = .white
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                        [weak self] in
                        guard let `self` = self else {return}

                        self.collection.reloadData()
                    }
                    
                }
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if NEwBlueToolManager.default.favoHotPeriItemsList.count == 0 && NEwBlueToolManager.default.unotherPeriItemsList.count == 0 {
            return 0
        } else if NEwBlueToolManager.default.favoHotPeriItemsList.count == 0 && NEwBlueToolManager.default.unotherPeriItemsList.count != 0 {
            return NEwBlueToolManager.default.unotherPeriItemsList.count
        } else if NEwBlueToolManager.default.favoHotPeriItemsList.count != 0 && NEwBlueToolManager.default.unotherPeriItemsList.count == 0 {
            return NEwBlueToolManager.default.favoHotPeriItemsList.count
        } else {
            if section == 0 {
                return NEwBlueToolManager.default.favoHotPeriItemsList.count
            } else {
                return NEwBlueToolManager.default.unotherPeriItemsList.count
            }
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if NEwBlueToolManager.default.favoHotPeriItemsList.count == 0 && NEwBlueToolManager.default.unotherPeriItemsList.count == 0 {
            return 0
        } else if NEwBlueToolManager.default.favoHotPeriItemsList.count == 0 && NEwBlueToolManager.default.unotherPeriItemsList.count != 0 {
            return 1
        } else if NEwBlueToolManager.default.favoHotPeriItemsList.count != 0 && NEwBlueToolManager.default.unotherPeriItemsList.count == 0 {
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
        let bottomOffset: CGFloat = 20
        if NEwBlueToolManager.default.favoHotPeriItemsList.count == 0 && NEwBlueToolManager.default.unotherPeriItemsList.count == 0 {
            return UIEdgeInsets(top: 10, left: 24, bottom: bottomOffset, right: 24)
        } else if NEwBlueToolManager.default.favoHotPeriItemsList.count == 0 && NEwBlueToolManager.default.unotherPeriItemsList.count != 0 {
            return UIEdgeInsets(top: 10, left: 24, bottom: bottomOffset, right: 24)
        } else if NEwBlueToolManager.default.favoHotPeriItemsList.count != 0 && NEwBlueToolManager.default.unotherPeriItemsList.count == 0 {
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
        if NEwBlueToolManager.default.favoHotPeriItemsList.count == 0 && NEwBlueToolManager.default.unotherPeriItemsList.count == 0 {
            return CGSize(width: 0, height: 0)
        } else if NEwBlueToolManager.default.favoHotPeriItemsList.count == 0 && NEwBlueToolManager.default.unotherPeriItemsList.count != 0 {
            return CGSize(width: 0, height: 0)
        } else if NEwBlueToolManager.default.favoHotPeriItemsList.count != 0 && NEwBlueToolManager.default.unotherPeriItemsList.count == 0 {
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
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withClass: NEwBlueDeviceHeader.self, for: indexPath)
            if NEwBlueToolManager.default.favoHotPeriItemsList.count == 0 && NEwBlueToolManager.default.unotherPeriItemsList.count == 0 {

            } else if NEwBlueToolManager.default.favoHotPeriItemsList.count == 0 && NEwBlueToolManager.default.unotherPeriItemsList.count != 0 {
                
            } else if NEwBlueToolManager.default.favoHotPeriItemsList.count != 0 && NEwBlueToolManager.default.unotherPeriItemsList.count == 0 {
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
        
        var periphItem: NEwPeripheralItem?
        if NEwBlueToolManager.default.favoHotPeriItemsList.count == 0 && NEwBlueToolManager.default.unotherPeriItemsList.count == 0 {
            
        } else if NEwBlueToolManager.default.favoHotPeriItemsList.count == 0 && NEwBlueToolManager.default.unotherPeriItemsList.count != 0 {
            periphItem = NEwBlueToolManager.default.unotherPeriItemsList[indexPath.item]
        } else if NEwBlueToolManager.default.favoHotPeriItemsList.count != 0 && NEwBlueToolManager.default.unotherPeriItemsList.count == 0 {
            periphItem = NEwBlueToolManager.default.favoHotPeriItemsList[indexPath.item]
        } else {
            if indexPath.section == 0 {
                periphItem = NEwBlueToolManager.default.favoHotPeriItemsList[indexPath.item]
            } else {
                periphItem = NEwBlueToolManager.default.unotherPeriItemsList[indexPath.item]
            }
        }
        
        if let item = periphItem {
            showDeviceInfoContent(peripheralItem: item)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    func showDeviceInfoContent(peripheralItem: NEwPeripheralItem) {
        let vc = NEwBlueDeviceContentVC(peripheral: peripheralItem)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


class NEwBlueDeviceHeader: UICollectionReusableView {
    let tiNameLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        tiNameLabel.adhere(toSuperview: self) {
            $0.left.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
            $0.width.greaterThanOrEqualTo(10)
            $0.height.greaterThanOrEqualTo(24)
        }
        .font(UIFont.SFProTextBold, 18)
        .color(UIColor(hexString: "#262B55")!)
        .textAlignment(.left)
        
    }
    
}

//class BSiegBlueDevicePreview: UIView {
//
//
//    var ring1V = RingProgressView()
//
//    init(frame: CGRect, peripheralItem: NEwPeripheralItem) {
//        self.peripheralItem = peripheralItem
//
//        super.init(frame: frame)
//        setupView()
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    func setupView() {
//        self.backgroundColor = .white
//        self.layer.cornerRadius = 20
//        //
//        let iconbgV = UIView()
//        self.addSubview(iconbgV)
//        iconbgV.backgroundColor = UIColor(hexString: "#E8EDFF")
//        iconbgV.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.left.equalToSuperview().offset(15)
//            $0.width.height.equalTo(48)
//        }
//        iconbgV.layer.cornerRadius = 24
//        iconbgV.clipsToBounds = true
//        //
//        contentImgV.contentMode = .scaleAspectFit
//        contentImgV.clipsToBounds = true
//        addSubview(contentImgV)
//        contentImgV.snp.makeConstraints {
//            $0.center.equalTo(iconbgV)
//            $0.width.height.equalTo(32)
//        }
//        //
//        iconbgV.addSubview(ring1V)
//        ring1V.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
//        ring1V.startColor = UIColor(hexString: "#3971FF")!
//        ring1V.endColor = UIColor(hexString: "#3971FF")!
//        ring1V.ringWidth = 3
//        ring1V.backgroundRingColor = .clear
//        ring1V.hidesRingForZeroProgress = true
//        ring1V.shadowOpacity = 0
//        ring1V.progress = 0
//        //
//
//        self.addSubview(deviceNameLabel)
//        deviceNameLabel.font = UIFont(name: "Poppins-Bold", size: 14)
//        deviceNameLabel.textColor = UIColor(hexString: "#242766")
//        deviceNameLabel.lineBreakMode = .byTruncatingTail
//        deviceNameLabel.textAlignment = .left
//        deviceNameLabel.snp.makeConstraints {
//            $0.left.equalTo(iconbgV.snp.right).offset(15)
//            $0.top.equalTo(iconbgV.snp.top)
//            $0.bottom.equalTo(iconbgV.snp.centerY)
//            $0.right.equalToSuperview().offset(-50)
//        }
//
//        //
//        self.addSubview(describeLabel)
//        describeLabel.font = UIFont(name: "Poppins-Medium", size: 12)
//        describeLabel.textColor = UIColor(hexString: "#242766")?.withAlphaComponent(0.5)
////        describeLabel.lineBreakMode = .byTruncatingTail
//        describeLabel.adjustsFontSizeToFitWidth = true
//        describeLabel.textAlignment = .left
//        describeLabel.snp.makeConstraints {
//            $0.left.equalTo(iconbgV.snp.right).offset(15)
//            $0.top.equalTo(iconbgV.snp.centerY)
//            $0.bottom.equalTo(iconbgV.snp.bottom)
//            $0.right.equalToSuperview().offset(-50)
//        }
//
//        //
//        let arrowImgV = UIImageView()
//        arrowImgV.contentMode = .scaleAspectFit
//        arrowImgV.image = UIImage(named: "CaretRight")
//        arrowImgV.clipsToBounds = true
//        addSubview(arrowImgV)
//        arrowImgV.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.right.equalToSuperview().offset(-14)
//            $0.width.height.equalTo(20)
//        }
//
//        //
//
//    }
//
//    func updateContent() {
//
//        let deviceIconStr = peripheralItem.deviceTagIconName(isSmall: true)
//        let deviceNameStr = peripheralItem.deviceName
//        let distancePercent = peripheralItem.deviceDistancePercent()
//        debugPrint("cell update deviceName: \(deviceNameStr) distancePercent - \(distancePercent)")
//        contentImgV.image = UIImage(named: deviceIconStr)
//        deviceNameLabel.text = deviceNameStr
//        ring1V.progress = distancePercent
//        describeLabel.text = peripheralItem.fetchDistanceString()
//    }
//}

class NEwDeviceListCell: NEwSwipeCollectionCell {
    var contentBgV = UIView()
    var favoButton: UIButton!
    var favoClickBlock: ((Bool, String)->Void)?
    
    var peripheralItem: NEwPeripheralItem?
     
    let deviceIconImgV = UIImageView()
    let deviceNameLabel = UILabel()
    let destanceLabel = UILabel()
    let iconbgV = UIView()
    let ringProgressView: RingProgressView = RingProgressView()
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
        contentBgV.addSubview(deviceIconImgV)
        deviceIconImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        
        //
        contentBgV.addSubview(iconbgV)
        iconbgV.backgroundColor = UIColor(hexString: "#E8EDFF")
        iconbgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.width.height.equalTo(48)
        }
        iconbgV.layer.cornerRadius = 24
//        iconbgV.clipsToBounds = true
        //
        deviceIconImgV.contentMode = .scaleAspectFit
        deviceIconImgV.clipsToBounds = true
        contentBgV.addSubview(deviceIconImgV)
        deviceIconImgV.snp.makeConstraints {
            $0.center.equalTo(iconbgV)
            $0.width.height.equalTo(30)
        }
        //
        contentBgV.addSubview(deviceNameLabel)
        deviceNameLabel.font = UIFont(name: UIFont.SFProTextBold, size: 16)
        deviceNameLabel.textColor = UIColor(hexString: "#262B55")
        deviceNameLabel.lineBreakMode = .byTruncatingTail
        deviceNameLabel.textAlignment = .left
        deviceNameLabel.snp.makeConstraints {
            $0.left.equalTo(iconbgV.snp.right).offset(16)
            $0.top.equalTo(iconbgV.snp.top)
            $0.bottom.equalTo(iconbgV.snp.centerY)
            $0.right.equalToSuperview().offset(-50)
        }
        
        //
        contentBgV.addSubview(destanceLabel)
        destanceLabel.font = UIFont(name: UIFont.SFProTextMedium, size: 12)
        destanceLabel.textColor = UIColor(hexString: "#262B55")?.withAlphaComponent(0.3)
//        describeLabel.lineBreakMode = .byTruncatingTail
        destanceLabel.adjustsFontSizeToFitWidth = true
        destanceLabel.textAlignment = .left
        destanceLabel.snp.makeConstraints {
            $0.left.equalTo(iconbgV.snp.right).offset(15)
            $0.top.equalTo(iconbgV.snp.centerY)
            $0.bottom.equalTo(iconbgV.snp.bottom)
            $0.right.equalToSuperview().offset(-50)
        }
        
        //
        let arrowImgV = UIImageView()
        arrowImgV.contentMode = .scaleAspectFit
        arrowImgV.image = UIImage(named: "devieinfoarrworight")
        arrowImgV.clipsToBounds = true
        addSubview(arrowImgV)
        arrowImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-14)
            $0.width.height.equalTo(20)
        }
        
        //
//        216 × 160
        favoButton = UIButton(frame: CGRect(x: 0, y: 0, width: 216/2, height: self.bounds.height))
        favoButton.layer.cornerRadius = 20
        favoButton.setBackgroundImage(UIImage(named: "cell_heart_n"), for: .normal)
        favoButton.setBackgroundImage(UIImage(named: "cell_heart_s"), for: .selected)
        favoButton.roundCorners([.topRight, .bottomRight], radius: 20)
        favoButton.addTarget(self, action: #selector(favoButtonSelf(sender: )), for: .touchUpInside)
        self.revealView = favoButton
        
        
        //
//        setupRingProgressV()
    }
    
//    func setupRingProgressV() {
//        self.ringProgressView.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
////        self.ringProgressView.progress = self.deviceDistancePercent()
//        self.ringProgressView.startColor = UIColor(hexString: "#3971FF")!
//        self.ringProgressView.endColor = UIColor(hexString: "#3971FF")!
//        self.ringProgressView.backgroundRingColor = .clear
//        self.ringProgressView.ringWidth = 3
//        self.ringProgressView.shadowOpacity = 0
//        self.ringProgressView.hidesRingForZeroProgress = true
//        self.ringProgressView.progress = 0
//        self.iconbgV.addSubview(self.ringProgressView)
//    }
    
    @objc func favoButtonSelf(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.hideRevealView(withAnimated: true)
        if let idstr = peripheralItem?.identifier {
            favoClickBlock?(sender.isSelected, idstr)
        }
    }
    
    func updateItemContentStatus(peripheralItem: NEwPeripheralItem) {
        self.peripheralItem = peripheralItem
        let deviceNameStr = peripheralItem.deviceName
        let deviceIconStr = peripheralItem.deviceTagIconName(isBig: false)
        let distancePercent = peripheralItem.deviceDistancePercent()
        let distanceAboutM = peripheralItem.fetchAboutDistanceString()
        let distanceAproxStr = "Approx. \(distanceAboutM) away from you"
        //
        
        deviceIconImgV.image = UIImage(named: deviceIconStr)
        deviceNameLabel.text = deviceNameStr
        destanceLabel.text = distanceAproxStr
//        self.ringProgressView.progress = peripheralItem.deviceDistancePercent()
        
//        if self.iconbgV != peripheralItem.ringProgressView.superview {
//            self.iconbgV.removeSubviews()
//            let ringBound = CGRect(x: 0, y: 0, width: 48, height: 48)
//            peripheralItem.ringProgressView.frame = ringBound
//            self.iconbgV.addSubview(peripheralItem.ringProgressView)
////            peripheralItem.ringProgressView.progress = peripheralItem.deviceDistancePercent()
//        }
//        peripheralItem.ringProgressView.progress = peripheralItem.deviceDistancePercent()
//
//        if self.iconbgV != peripheralItem.ringProgressView.superview {
//
//        }
//
//        let ringBound = CGRect(x: 0, y: 0, width: 48, height: 48)
//        peripheralItem.ringProgressView.frame = ringBound
//        self.iconbgV.addSubview(peripheralItem.ringProgressView)
        
    }
    
}


