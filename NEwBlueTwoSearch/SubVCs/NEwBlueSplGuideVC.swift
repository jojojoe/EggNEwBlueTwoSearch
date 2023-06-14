//
//  NEwBlueSplGuideVC.swift
//  NEwBlueTwoSearch
//
//  Created by sege li on 2023/6/9.
//

import UIKit

class NEwBlueSplGuideVC: UIViewController {

    var collection: UICollectionView!
    var currentIndexP: IndexPath = IndexPath(item: 0, section: 0)
    var continueCloseBlock:(()->Void)?
    var viewList: [UIView] = []
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.clipsToBounds = true
        
        let onceV = NEwSplashPageOne()
        viewList.append(onceV)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.right.left.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        collection.register(cellWithClass: NEwBlueSplashCell.self)
    }
    
    func continueBtnClickAction() {
        NEwBlueToolManager.default.giveTapVib()
        if currentIndexP.item == 2 {
            continueCloseBlock?()
            debugPrint("currentIndexP = close")
        } else {
            collection.isPagingEnabled = false
            
            currentIndexP = IndexPath(item: currentIndexP.item + 1, section: 0)
            collection.selectItem(at: currentIndexP, animated: true, scrollPosition: .centeredHorizontally)
            debugPrint("currentIndexP = \(currentIndexP.item)")
            collection.isPagingEnabled = true
        }
    }
    

    
}
extension NEwBlueSplGuideVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: NEwBlueSplashCell.self, for: indexPath)
        let cellview = viewList[indexPath.item]
        cell.bgV.removeSubviews()
        cell.bgV.addSubview(cellview)
        cellview.snp.remakeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension NEwBlueSplGuideVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == collection {
            if let indexP = collection.indexPathForItem(at: CGPoint(x: view.bounds.width/2 + collection.contentOffset.x, y: 50)) {
                if indexP.item != currentIndexP.item {
                    currentIndexP = indexP
                }
                
            }
        }
    }
    
}

extension NEwBlueSplGuideVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class NEwBlueSplashCell: UICollectionViewCell {
    let bgV = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        bgV
            .adhere(toSuperview: contentView) {
                $0.left.right.top.bottom.equalToSuperview()
            }
        
        
    }
}
