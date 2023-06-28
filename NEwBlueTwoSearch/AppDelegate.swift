//
//  AppDelegate.swift
//  NEwBlueTwoSearch
//
//  Created by sege li on 2023/6/4.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

/*
 
    Device Finder
    com.find.spy.device
 App ID    6450285725
 Contact     dham_huang_dad390@outlook.com
 
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

