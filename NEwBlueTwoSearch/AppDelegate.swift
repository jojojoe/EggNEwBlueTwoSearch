//
//  AppDelegate.swift
//  NEwBlueTwoSearch
//
//  Created by sege li on 2023/6/4.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

//    com.find.spy.device
/*
 
 产品名    Device Finder
 包名    com.find.spy.device
 App ID    6450285725
 Contact 邮箱    dham_huang_dad390@outlook.com
     
     
 内购IAP ID    com.find.spy.device.week
 内购IAP 价格    $4.99
 内购IAP ID    com.find.spy.device.month
 内购IAP 价格    $9.99
 内购IAP ID    com.find.spy.device.lifetime
 内购IAP 价格    $29.99
 Secret Key    79b1dc4457734c25931a50f251d68a19
     
     
 Privacy Policy    https://sites.google.com/view/device-finder-pp/home
 Terms of Use    https://sites.google.com/view/devicefinder-tou/home

 */
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NEwBlueProManager.default.completeTransactions()
#if DEBUG
for fy in UIFont.familyNames {
    let fts = UIFont.fontNames(forFamilyName: fy)
    for ft in fts {
        debugPrint("***fontName = \(ft)")
    }
}  
#endif
        return true
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
         
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
         
    }


}

