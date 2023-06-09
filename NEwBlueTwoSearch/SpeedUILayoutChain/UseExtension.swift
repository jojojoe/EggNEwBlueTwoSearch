//
//  UseExtension.swift
//  NEwBlueTwoSearch
//
//  Created by Joe on 2023/6/4.
//

import UIKit
import Foundation

extension Double {
    func accuracyToString(position: Int) -> String {
        
        let roundingBehavior = NSDecimalNumberHandler(roundingMode: .plain, scale: Int16(position), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        
        let ouncesDecimal: NSDecimalNumber = NSDecimalNumber(value: self)
        let roundedOunces: NSDecimalNumber = ouncesDecimal.rounding(accordingToBehavior: roundingBehavior)
        
        var formatterString : String = "0."
        if position > 0 {
            for _ in 0 ..< position {
                formatterString.append("0")
            }
        }else {
            formatterString = "0"
        }
        let formatter : NumberFormatter = NumberFormatter()
        
        formatter.positiveFormat = formatterString
        
        var roundingStr = formatter.string(from: roundedOunces) ?? "0.00"
        
        if roundingStr.range(of: ".") != nil {
            
            let sub1 = String(roundingStr.suffix(1))
            if sub1 == "0" {
                roundingStr = String(roundingStr.prefix(roundingStr.count-1))
                let sub2 = String(roundingStr.suffix(1))
                if sub2 == "0" {
                    roundingStr = String(roundingStr.prefix(roundingStr.count-2))
                }
            }
        }
        return roundingStr
    }
}

extension Double {
    func rounded(digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
}

public class Once {
    var already: Bool = false
    
    public init() {}
    
    public func run(_ block: () -> Void) {
        guard !already else {
            return
        }
        block()
        already = true
    }
}

public class TaskDelay {
    
    public init() {}
    public static var `default` = TaskDelay()
    var taskBlock: ((_ cancel: Bool)->Void)?
    var actionBlock: (()->Void)?
    
    public func taskDelay(afterTime: TimeInterval, task:@escaping ()->Void) {
        actionBlock = task
        taskBlock = { cancel in
            if let actionBlock = TaskDelay.default.actionBlock {
                if !cancel {
                    DispatchQueue.main.async {
                        actionBlock()
                    }
                }
            }
            TaskDelay.default.taskBlock = nil
            TaskDelay.default.actionBlock = nil
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + afterTime) {
            if let taskBlock = TaskDelay.default.taskBlock {
                taskBlock(false)
            }
        }
    }
    
    public func taskCancel() {
        DispatchQueue.main.async {
            if let taskBlock = TaskDelay.default.taskBlock {
                taskBlock(true)
            }
        }
    }
}


extension UIScreen {
    static func isDevice8SE() -> Bool {
        if Device.current.diagonal <= 4.7 {
            return true
        }
        return false
    }
    
    static func isDevice8SEPaid() -> Bool {
        if Device.current.diagonal <= 4.7 || Device.current.diagonal >= 7.0 {
            return true
        }
        return false
    }
    
    static func isDevice8Plus() -> Bool {
        if Device.current.diagonal == 5.5 {
            return true
        }
        return false
    }
    
    
}
