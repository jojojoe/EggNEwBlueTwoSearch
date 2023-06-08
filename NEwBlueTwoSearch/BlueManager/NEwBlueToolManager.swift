//
//  NEwBlueToolManager.swift
//  NEwBlueTwoSearch
//
//  Created by Joe on 2023/6/4.
//

import Foundation
import UIKit
import CoreBluetooth
import AVFoundation
import AudioToolbox


class NEwBlueToolManager: NSObject {
    static let `default` = NEwBlueToolManager()
    var centralManager: CBCentralManager!
    var peripheralItemList: [NEwPeripheralItem] = []
    var favoritePeripheralItemList: [NEwPeripheralItem] = []
    var otherPeripheralItemList: [NEwPeripheralItem] = []
    
    var cachaedPeripheralItemList: [NEwPeripheralItem] = []
    let queue = DispatchQueue(label: "fetchqueue", qos: .background)
    var deviceBluetoothDeniedBlock: (()->Void)?
    var favoriteDevicesIdList: [String] = []
    var centralManagerStatus: Bool?
    let discoverDeviceNotiName: NSNotification.Name = NSNotification.Name.init("not_ScaningDeviceUpdate")
    let trackingDeviceNotiName: NSNotification.Name = NSNotification.Name.init("trackingDeviceUpdate")
    let deviceFavoriteChangeNotiName: NSNotification.Name = NSNotification.Name.init("deviceFavoriteChange")
    var currentTrackingItem: NEwPeripheralItem?
    var currentTrackingItemRssi: Double?
    var currentTrackingItemName: String?
    
    let slowVoice = "did_slow.mp3"
    let fastVoice = "did_fast.mp3"
    
    var audioPlayer: AVAudioPlayer?
    var currentAudioType: String?
    var feedTimer: Timer?
    var pendingRefresh = false
    
    
    override init() {
        super.init()
        fetchUserFavorites()
    }
    
    func prepare() {
        centralManager = CBCentralManager(delegate: self, queue: queue)
    }
    
    
    func startScan() {
        DispatchQueue.global().async {
            [weak self] in
            guard let `self` = self else {return}
            self.centralManagerScan()
        }
    }
    
    func stopScan() {
        cachaedPeripheralItemList = peripheralItemList
        centralManager.stopScan()
    }
    
    func centralManagerScan() {
       self.centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
   }
   
    func fetchUserFavorites() {
        favoriteDevicesIdList = UserDefaults.standard.object(forKey: "ud_favoriteDevicesId") as? [String] ?? []
        debugPrint("favoriteDevicesIdList = \(favoriteDevicesIdList.count)")
    }
    
    func addUserFavorite(deviceId: String) {
        if !favoriteDevicesIdList.contains(deviceId) {
            favoriteDevicesIdList.append(deviceId)
            UserDefaults.standard.set(favoriteDevicesIdList, forKey: "ud_favoriteDevicesId")
            UserDefaults.standard.synchronize()
            
            let peri = peripheralItemList.first { ite in
                ite.identifier == deviceId
            }
          
            if let item = peri {
                if !favoritePeripheralItemList.contains(item) {
                    favoritePeripheralItemList.append(item)
                }
                if otherPeripheralItemList.contains(item) {
                    otherPeripheralItemList.removeAll(item)
                }
            }
            
            senddeviceFavoriteChangeNotification()
        }
    }
    
    func removeUserFavorite(deviceId: String) {
        if favoriteDevicesIdList.contains(deviceId) {
            favoriteDevicesIdList.removeAll { item in
                item == deviceId
            }
            UserDefaults.standard.set(favoriteDevicesIdList, forKey: "ud_favoriteDevicesId")
            UserDefaults.standard.synchronize()
            
            let peri = peripheralItemList.first { ite in
                ite.identifier == deviceId
            }
          
            if let item = peri {
                if !otherPeripheralItemList.contains(item) {
                    otherPeripheralItemList.append(item)
                }
                if favoritePeripheralItemList.contains(item) {
                    favoritePeripheralItemList.removeAll(item)
                }
            }
            
            senddeviceFavoriteChangeNotification()
        }
    }
}

 

extension NEwBlueToolManager {
    func audioSlowVoiceStyle() -> String {
        if let item = currentTrackingItem {
            let persent = item.deviceDistancePercent()
            if persent <= 0.7 {
                return slowVoice
            } else {
                return fastVoice
            }
        }
        return slowVoice
    }
    
    func playAudio() {
        let prepareAudio = audioSlowVoiceStyle()
        if prepareAudio == currentAudioType {
            return
        }
        currentAudioType = prepareAudio
        if audioPlayer?.isPlaying == true {
            stopAudio()
        }
        if let bundlePath = Bundle.main.path(forResource: prepareAudio, ofType: nil), let url = URL(string: bundlePath) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = -1
//                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                debugPrint("error = \(error.localizedDescription)")
            }
        }
    }
    
    func stopAudio() {
        if let audioP = audioPlayer {
            audioP.stop()
            currentAudioType = nil
            audioPlayer = nil
        }
    }
    
    //
    func playVibInterval() -> TimeInterval {
        if let item = currentTrackingItem {
            let persent = item.deviceDistancePercent()
            if persent <= 0.3 {
                return 6
            } else if persent <= 0.7 {
                return 3.5
            } else {
                return 1.5
            }
        }
        return 1
    }
    
    func playFeedVib() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        stopVibTimer()
        
        func addnewTimer(interval: TimeInterval) {
            let timer = Timer.new(every: interval) {
                [weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                }
            }
            feedTimer = timer
            timer.start()
        }
        
        addnewTimer(interval: playVibInterval())
        
    }
    
    func stopVibTimer() {
        if let timer = feedTimer {
            timer.invalidate()
            feedTimer = nil
        }
    }

}

extension NEwBlueToolManager: CBCentralManagerDelegate {
    func sendDiscoverDeviceNotification() {
        NotificationCenter.default.post(name: discoverDeviceNotiName, object: nil)
    }
    
    func sendTrackingDeviceNotification() {
        NotificationCenter.default.post(name: trackingDeviceNotiName, object: nil)
    }
    
    func senddeviceFavoriteChangeNotification() {
        NotificationCenter.default.post(name: deviceFavoriteChangeNotiName, object: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        centralManagerStatus = false
        switch central.state {
        case .unknown, .resetting, .unsupported, .unauthorized, .poweredOff:
            debugPrint("central.state is .unknown")
            self.deviceBluetoothDeniedBlock?()
        case .poweredOn:
            debugPrint("central.state is .poweredOn")
            self.centralManagerStatus = true
            centralManagerScan()
        @unknown default:
            debugPrint("central.state is .@unknown default")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if let deviceName = peripheral.name {
            if let peItem = peripheralItemList.first(where: { perItem in
                perItem.identifier == peripheral.identifier.uuidString
            }) {
                peItem.rssi = Double(truncating: RSSI)
                debugPrint("peItem addr = \(peItem)")
                debugPrint("peItem.rssi = \(peItem.rssi)")
                
                if let currentTrack = currentTrackingItem, currentTrack.identifier == peItem.identifier {
                    currentTrackingItemName = currentTrack.deviceName ?? ""
                    currentTrackingItemRssi = Double(truncating: RSSI)
                    sendTrackingDeviceNotification()
                }
            } else {
                if let peItem = cachaedPeripheralItemList.first(where: { perItem in
                    perItem.identifier == peripheral.identifier.uuidString
                }) {
                    peItem.rssi = Double(truncating: RSSI)
                    peripheralItemList.append(peItem)
                } else {
                    let item = NEwPeripheralItem(identifier: peripheral.identifier.uuidString, deviceName: deviceName, rssi: Double(truncating: RSSI))
                    peripheralItemList.append(item)
                }
            }
            
            //
            if !pendingRefresh {
                pendingRefresh = true
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    [weak self] in
                    guard let `self` = self else {return}
                    self.pendingRefresh = false
                    self.sortPeripheraByRSSI()
                    self.sendDiscoverDeviceNotification()
                }
            }
        }
    }
    
    func sortPeripheraByRSSI() {
        peripheralItemList.sort { perip1, perip2 in
            perip1.rssi > perip2.rssi
        }
        var favoriteList: [NEwPeripheralItem] = []
        var otherList: [NEwPeripheralItem] = []
        peripheralItemList.forEach {
            $0.updateRingProgress()
            if self.favoriteDevicesIdList.contains($0.identifier) {
                favoriteList.append($0)
            } else {
                otherList.append($0)
            }
        }
        
        favoritePeripheralItemList = favoriteList
        otherPeripheralItemList = otherList
        
    }
    
    
}

extension NEwBlueToolManager {
    func showOpenSubscribeProVC(fuVC: UIViewController) {
        let vc = NEwBlueSubscribeVC()
        fuVC.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIFont {
    static let SFProTextRegular = "SFProText-Regular"
    static let SFProTextMedium = "SFProText-Medium"
    static let SFProTextSemibold = "SFProText-Semibold"
    static let SFProTextBold = "SFProText-Bold"
    static let SFProTextHeavy = "SFProText-Heavy"
    
}
//
class NEwPeripheralItem: Equatable {
    
    static func == (lhs: NEwPeripheralItem, rhs: NEwPeripheralItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var identifier: String
    var deviceName: String
    var rssi: Double
    var ringProgressView: RingProgressView = RingProgressView()
    
    func updateRingProgress() {
        ringProgressView.progress = deviceDistancePercent()
    }
    
    init(identifier: String, deviceName: String, rssi: Double) {
        self.identifier = identifier
        self.deviceName = deviceName
        self.rssi = rssi
        //
        ringProgressView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        ringProgressView.progress = deviceDistancePercent()
        ringProgressView.startColor = UIColor(hexString: "#3971FF")!
        ringProgressView.endColor = UIColor(hexString: "#3971FF")!
        ringProgressView.backgroundRingColor = .clear
        ringProgressView.ringWidth = 3
        ringProgressView.shadowOpacity = 0
        ringProgressView.hidesRingForZeroProgress = true
        
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
    
    func deviceTagIconName(isBig: Bool = false) -> String {
        var iconStr = "device_blue"
        if deviceName.lowercased().contains("phone") {
            iconStr = "device_phone"
        } else if deviceName.lowercased().contains("book") {
            iconStr = "device_macbook"
        } else if deviceName.lowercased().contains("mac") {
            iconStr = "device_taishiji"
        } else if deviceName.lowercased().contains("pod") {
            iconStr = "device_erji"
        } else if deviceName.lowercased().contains("watch") {
            iconStr = "device_watch"
        } else if deviceName.lowercased().contains("pad") {
            iconStr = "device_pad"
        } else {
            iconStr = "device_blue"
        }
        if isBig {
            return iconStr + "_b"
        }
        return iconStr
    }
    
    func fetchAboutDistanceString() -> String {
        let distance = calculateDistance(rssi: Int(rssi))
        var dis = CGFloat(Int(distance))
        if dis == 0 {
            dis = 0.1
        }
        return "\(dis) m"
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



