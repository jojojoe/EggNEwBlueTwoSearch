//
//  NEwBlueToolManager.swift
//  NEwBlueTwoSearch
//
//  Created by Joe on 2023/6/4.
//

import Foundation
import UIKit




class NEwBlueToolManager: NSObject {
    static let `default` = NEwBlueToolManager()
    
    
    
}


extension UIFont {
    static let SFProTextRegular = "SFProText-Regular"
    static let SFProTextMedium = "SFProText-Medium"
    static let SFProTextSemibold = "SFProText-Semibold"
    static let SFProTextBold = "SFProText-Bold"
    static let SFProTextHeavy = "SFProText-Heavy"
    
    
    
    
    
}

class NEwPeripheralItem: Equatable, NSObject {
    static func == (lhs: NEwPeripheralItem, rhs: NEwPeripheralItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var identifier: String
    var deviceName: String
    var rssi: Double
    
    init(identifier: String, deviceName: String, rssi: Double) {
        self.identifier = identifier
        self.deviceName = deviceName
        self.rssi = rssi
    }
    
    func deviceDistancePercent() -> Double {
        var persValue: Double = 0
        
        let distance = calculateDistance(rssi: Int(rssi))
        
        if distance.isLessThanOrEqualTo(1.0) {
            persValue = 1
        }
        if !distance.isLess(than: 1.0) && distance.isLess(than: 2.0) {
            persValue = 0.90
        }
        if !distance.isLess(than: 2.0) && distance.isLess(than: 3.0) {
            persValue = 0.80
        }
        if !distance.isLess(than: 3.0) && distance.isLess(than: 4.0) {
            persValue = 0.70
        }
        if !distance.isLess(than: 4.0) && distance.isLess(than: 5.0) {
            persValue = 0.60
        }
        if !distance.isLess(than: 5.0) && distance.isLess(than: 6.0) {
            persValue = 0.55
        }
        if !distance.isLess(than: 5.0) && distance.isLess(than: 7.0) {
            
            persValue = 0.50
        }
        if !distance.isLess(than: 7.0) && distance.isLess(than: 8.0) {
            
            persValue = 0.40
        }
        if !distance.isLess(than: 8.0) && distance.isLess(than: 9.0) {
            
            persValue = 0.30
        }
        if !distance.isLess(than: 9.0) && distance.isLess(than: 10.0) {
            
            persValue = 0.20
        }
        if !distance.isLess(than: 10.0) && distance.isLess(than: 15.0) {
            
            persValue = 0.15
        }
        if !distance.isLess(than: 15.0) && distance.isLess(than: 20.0) {
            
            persValue = 0.10
        }
        if !distance.isLess(than: 20.0) && distance.isLess(than: 30.0) {
            
            persValue = 0.05
        }
        if !distance.isLess(than: 30.0) {
            
            persValue = 0.03
        }
        return persValue
    }
    
    func deviceDistancePercentStr() -> String {
        return "\(Int(deviceDistancePercent() * 100))%"
    }
    
    func deviceTagIconName(isSmall: Bool = false) -> String {
        var iconStr = "device_bluetooth"
        if deviceName.lowercased().contains("iphone") {
            iconStr = "device_phone"
        } else if deviceName.lowercased().contains("book") {
            iconStr = "device_mbp"
        } else if deviceName.lowercased().contains("imac") {
            iconStr = "device_mac"
        } else if deviceName.lowercased().contains("airpod") {
            iconStr = "device_airpod"
        } else if deviceName.lowercased().contains("watch") {
            iconStr = "device_watch"
        } else if deviceName.lowercased().contains("pad") {
            iconStr = "device_pad"
        } else {
            iconStr = "device_bluetooth"
        }
        if isSmall {
            return iconStr + "_s"
        }
        return iconStr
    }
    
    func fetchDistanceString() -> String {
        
        func distancStr(_ distance: String) -> String {
            "Approx. \(distance) away from you"
        }
        
        var string = "Cannot calculate distance."
        let distance = calculateDistance(rssi: Int(rssi))
        
        if distance.isLessThanOrEqualTo(1.0) {
            string = distancStr("0 - 1 meter")
        }
        if !distance.isLess(than: 1.0) && distance.isLess(than: 5.0) {
            string = distancStr("1 - 5 meters")
        }
        if !distance.isLess(than: 5.0) && distance.isLess(than: 10.0) {
            string = distancStr("5 - 10 meters")
        }
        if !distance.isLess(than: 10.0) {
            string = distancStr("10+ meters")
        }
        return string
    }
    
    func calculateDistance(rssi: Int) -> Double {
        let txPower =  -59
        if (rssi == 0) {
            return -1.0
        }
        let ratio = (Double(rssi) * 1.0) / Double(txPower)
        if (ratio < 1.0) {
            return pow(ratio, 10)
        } else {
            let disatance = (0.89976) * pow(ratio, 7.7095) + 0.111
            return disatance
        }
    }
    
}
