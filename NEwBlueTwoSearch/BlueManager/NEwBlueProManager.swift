//
//  NEwBlueProManager.swift
//  NEwBlueTwoSearch
//
//  Created by sege li on 2023/6/9.
//

import UIKit
import Foundation
import SwiftyStoreKit
import TPInAppReceipt
import StoreKit


class NEwBlueProManager {
    public static var `default` = NEwBlueProManager()
    
    
    public enum NwVerifyLocalSubscriptionResult {
        case notPurchased
        case purchasedOnceTime
        case expired(expiryDate: Date, items: [InAppReceipt])
        case purchased(expiryDate: Date, items: [InAppReceipt])
    }
    
    var inSubscription: Bool = false
    var currentProducts: [NEwBlueProManager.IAPProduct] = []
    var iapTypeList: [IAPType] = [.month, .year, .week]
    var currentIapType: IAPType = .month
    
    
    public enum IAPType: String {
        case week = "com.find.cellphones.week"
        case month = "com.find.cellphones.month"
        case year = "com.find.cellphones.year"
    }
    
    public struct PurchaseNotificationKeys {
        static let success = "success"
        static let failed = "failed"
    }
    
    public struct IAPProduct: Codable {
        public var iapID: String
        public var price: Double
        public var priceLocale: Locale
        public var localizedPrice: String?
        public var currencyCode: String?
    }
    
    public enum VerifyLocalReceiptResult {
        case success(receipt: InAppReceipt)
        case error(error: IARError)
    }

}

extension NEwBlueProManager {
    
    public func restore(_ successBlock: ((Bool) -> Void)? = nil) {
        
        SwiftyStoreKit.restorePurchases(atomically: true) { [weak self] results in
            guard let `self` = self else { return }
            if results.restoreFailedPurchases.count > 0 {
                successBlock?(false)
                debugPrint("Restore Failed: \(results.restoreFailedPurchases)")
            } else if results.restoredPurchases.count > 0 {
                for purchase in results.restoredPurchases {
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                }
                
                self.refreshReceipt { (_, _) in
                    self.isPurchasedStatus { (status) in
                        if status {
                            NotificationCenter.default.post(
                                name: NSNotification.Name(rawValue: PurchaseNotificationKeys.success),
                                object: nil,
                                userInfo: nil)
                            debugPrint("Restore Success: \(results.restoredPurchases)")
                            successBlock?(true)
                        } else {
                            successBlock?(false)
                        }
                    }
                }
            } else {
                successBlock?(false)
            }
        }
    }

    public func subscribeProvipOrder(iapType: NEwBlueProManager.IAPType, source: String, completionBlock: ((Bool, String?) -> Void)? = nil) {
        
        SwiftyStoreKit.purchaseProduct(iapType.rawValue) { purchaseResult in
            switch purchaseResult {
            case let .success(purchaseDetail):
                if purchaseDetail.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchaseDetail.transaction)
                }
                self.refreshReceipt { (_, _) in
                    self.isPurchasedStatus { (status) in
                        if status {
                            let currency = purchaseDetail.product.priceLocale.currencySymbol ?? "$"
                            let price = purchaseDetail.product.price.doubleValue
                            debugPrint("product - \(currency)\(price)")
                        }
                        
                        NotificationCenter.default.post(
                            name: NSNotification.Name(rawValue: PurchaseNotificationKeys.success),
                            object: nil,
                            userInfo: nil)
                        completionBlock?(status, nil)
                    }
                }
                
            case let .error(error):
                
                var errorStr = error.localizedDescription
                switch error.code {
                case .unknown: errorStr = "Unknown error. Please contact support. If you are sure you have purchased it, please click the \"Restore\" button."
                case .clientInvalid: errorStr = "Not allowed to make the payment"
                case .paymentCancelled: errorStr = "Payment cancelled"
                case .paymentInvalid: errorStr = "The purchase identifier was invalid"
                case .paymentNotAllowed: errorStr = "The device is not allowed to make the payment"
                case .storeProductNotAvailable: errorStr = "The product is not available in the current storefront"
                case .cloudServicePermissionDenied: errorStr = "Access to cloud service information is not allowed"
                case .cloudServiceNetworkConnectionFailed: errorStr = "Could not connect to the network"
                case .cloudServiceRevoked: errorStr = "User has revoked permission to use this cloud service"
                default: errorStr = (error as NSError).localizedDescription
                }
                completionBlock?(false, errorStr)
                
            }
        }
    }
}

extension NEwBlueProManager {
    func isPurchasedStatus(completion: @escaping (_ purchased: Bool) -> Void) {
        let dispatchGroup = DispatchGroup()
        var validPurchases: [String: NwVerifyLocalSubscriptionResult] = [:]
        var errors: [String: Error] = [:]
        for key in iapTypeList {
            dispatchGroup.enter()
            
            verifyPurchase(key) { [weak self] purchaseResult, error in
                guard let _ = self else {
                    dispatchGroup.leave()
                    return
                }
                if let err = error {
                    errors[key.rawValue] = err
                    dispatchGroup.leave()
                    return
                }
                guard let purchase = purchaseResult else {
                    dispatchGroup.leave()
                    return
                }
                switch purchase {
                case .purchased(let expiryDate, let receiptItems):
                    let now = Date()
                    if now < expiryDate {
                        validPurchases[key.rawValue] = purchase
                    }
                    validPurchases[key.rawValue] = purchase
                    dispatchGroup.leave()
                case .expired(let expiryDate, let receiptItems):
                    print("Product is expired since \(expiryDate)")
                    dispatchGroup.leave()
                    let format = DateFormatter()
                    format.timeZone = .current
                    format.dateFormat = "EEEE, MMM d, yyyy h:mm a"
                    let dateString = format.string(from: expiryDate)
                    debugPrint("dateString = \(dateString)")
                case .purchasedOnceTime:
                    validPurchases[key.rawValue] = purchase
                    dispatchGroup.leave()
                case .notPurchased:
                    dispatchGroup.leave()
                    
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            let hasValid = validPurchases.count > 0
            NEwBlueProManager.default.inSubscription = hasValid
            completion(hasValid)
        }
    }
}

extension NEwBlueProManager {
    public func fetchPurchaseInfo(block: @escaping (([NEwBlueProManager.IAPProduct]) -> Void)) {
        let iapList = iapTypeList.map { $0.rawValue }

        SwiftyStoreKit.retrieveProductsInfo(Set(iapList)) { result in
            let priceList = result.retrievedProducts.compactMap { $0 }
            let localList = priceList.compactMap { NEwBlueProManager.IAPProduct(iapID: $0.productIdentifier, price: $0.price.doubleValue.rounded(digits: 2), priceLocale: $0.priceLocale, localizedPrice: $0.localizedPrice, currencyCode: $0.priceLocale.currencyCode)
            }
            self.currentProducts = localList
            block(localList)
        }
        
    }
}

extension NEwBlueProManager {
    
    func verifyPurchase(_ purchase: IAPType,
                        completion: @escaping(NwVerifyLocalSubscriptionResult?, Error?) -> Void) {
     
        verifyReceipt { [weak self] (receiptResult, validationError) in
            if let error = validationError {
                completion(nil, error)
                return
            }
            guard let result = receiptResult else {
                completion(nil, nil)
                return
            }
            guard let _ = self else {
                completion(nil, nil)
                return
            }
            //
            switch result {
            // receipt is validated
            case .success(let receipt):
                let oneTimePurchase = "life"//IAPType.life.rawValue
                let item = receipt.purchases.first {
                    return $0.productIdentifier == oneTimePurchase
                }
                if let _ = item {
                    completion(.purchasedOnceTime, nil)
                    return
                }
                let productId = purchase.rawValue
                // check there is a subscription first
                if let subscription = receipt.activeAutoRenewableSubscriptionPurchases(ofProductIdentifier: productId, forDate: Date()) {
                    if let expiryDate = subscription.subscriptionExpirationDate {
                        completion(.purchased(expiryDate: expiryDate, items: [receipt] ), nil)
                        return
                    }
                    // no expiry date?
                    completion(.notPurchased, nil)
                }
                let purchases = receipt.purchases( ofProductIdentifier: productId ) { (InAppPurchase, InAppPurchase2) -> Bool in
                    return InAppPurchase.purchaseDate > InAppPurchase2.purchaseDate
                }
                if purchases.isEmpty {
                    completion(.notPurchased, nil)
                } else {
                    // get last purchase
                    let lastSubscription = purchases[0]
                    completion( .expired(expiryDate: lastSubscription.subscriptionExpirationDate ?? Date(), items: [receipt] ), nil )
                }
            // validation error
            case .error(let error):
                completion(nil, error)
            }
        }
    }
    
    func verifyReceipt( completion: @escaping(VerifyLocalReceiptResult?, Error?) -> Void ) {
        do {
            let receipt = try InAppReceipt.localReceipt()
            do {
                try receipt.verifyHash()
                completion(.success(receipt: receipt), nil)
            } catch IARError.initializationFailed(let reason) {
                completion(.error(error: .initializationFailed(reason: reason)),nil)
            } catch IARError.validationFailed(let reason) {
                completion(.error(error: IARError.validationFailed(reason: reason)), nil)
            } catch IARError.purchaseExpired {
                completion(.error(error: .purchaseExpired), nil)
            } catch {
                // unknown error
                completion(nil, error)
            }
        } catch {
            completion(
                .error(error: .initializationFailed(reason: .appStoreReceiptNotFound)),
                error
            )
        }
    }
    
    func refreshReceipt(completion: @escaping(FetchReceiptResult?, Error?) -> Void) {
        SwiftyStoreKit.fetchReceipt(forceRefresh: true, completion: { result in
            switch result {
            case .success:
               completion(result, nil)
            case .error(let error):
                completion(nil, error)
            }
        })
    }
}
