//
//  UseExtension.swift
//  NEwBlueTwoSearch
//
//  Created by Joe on 2023/6/4.
//

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
