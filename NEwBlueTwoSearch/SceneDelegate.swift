//
//  SceneDelegate.swift
//  NEwBlueTwoSearch
//
//  Created by sege li on 2023/6/4.
//
import StoreKit
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var rootNav: UINavigationController?
    let VC = ViewController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        let currentVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"

        var showS = true
                
        if let saveVersion = UserDefaults.standard.string(forKey: "saveVersion") {
            if saveVersion == currentVersion {
                showS = false
            } else {
                UserDefaults.standard.set(currentVersion, forKey: "saveVersion")
            }
        } else {
            UserDefaults.standard.set(currentVersion, forKey: "saveVersion")
        }
        
#if DEBUG
        showS = true
#endif
        
        if showS {
//            NEwBlueToolManager.default.isSplashBegin = true
            let splashVC = NEwBlueSplGuideVC()
            let nav = UINavigationController.init(rootViewController: splashVC)
            nav.isNavigationBarHidden = true
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
            splashVC.continueCloseBlock = {
                [weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    self.setupViewController(isShowingSplase: true)
                }
            }
        } else {
//            NEwBlueToolManager.default.isSplashBegin = false
            setupViewController(isShowingSplase: false)
        }
        //
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    
    func setupViewController(isShowingSplase: Bool) {
        
        let nav = UINavigationController.init(rootViewController: VC)
        nav.isNavigationBarHidden = true
        self.rootNav = nav
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        NEwBlueProManager.default.isPurchasedSubscribeStatus {[weak self] purchased in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                debugPrint("purchased - \(purchased)")
                 
//                if isShowingSplase {
//                    SKStoreReviewController.requestReview()
//                } else {
                    if !NEwBlueProManager.default.inSubscription {
                        if isShowingSplase {
                            DispatchQueue.main.async {
//                                SKStoreReviewController.requestReview()
                            }
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                                [weak self] in
                                guard let `self` = self else {return}
                                
                                
                                let subsVC = NEwBlueSubscribeVC()
                                subsVC.modalPresentationStyle = .fullScreen
                                self.VC.present(subsVC, animated: true)
                                subsVC.pageDisappearBlock = {
                                    [weak self] in
                                    guard let `self` = self else {return}
                                    DispatchQueue.main.async {
                                        SKStoreReviewController.requestReview()
                                    }
                                }
                            }
                        }
                        
                    } else {
                        NotificationCenter.default.post(
                            name: NSNotification.Name(rawValue: NEwBlueProManager.PurchaseNotificationKeys.success),
                            object: nil,
                            userInfo: nil)
                        SKStoreReviewController.requestReview()
                    }
                }
                
//            }
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

