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


class NEwSearchingItemCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        
        
    }
}
