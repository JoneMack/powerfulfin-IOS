//
//  DSString.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/24.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
import CommonCrypto
extension String {
    public subscript(bounds: CountableRange<Int>) -> String {
        
        let string = self[index(startIndex, offsetBy: bounds.lowerBound) ..< index(startIndex, offsetBy: bounds.upperBound)]
        return String(string)
    }
    
    public subscript(bounds: CountableClosedRange<Int>) -> String {
        let string = self[index(startIndex, offsetBy: bounds.lowerBound) ... index(startIndex, offsetBy: bounds.upperBound)]
        return String(string)
    }
    
    public subscript(index: Int) -> String {
        let character = self[self.index(startIndex, offsetBy: index)]
        return String(character)
    }
}
extension String {
    func md5String() -> String {
        let cStr = self.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    
    /// 从时间区间获取时间：例如：从2017.09.04-2037.09.04中得到2017-09-04 和2037-09-04
    ///
    /// - Parameter dateStr: 2017.09.04-2037.09.04
    /// - Returns: (2017-09-04,2037-09-04)
    func getDate() -> (String?,String?) {
        let dataArray = self.components(separatedBy: "-")
        let begin = dataArray.first
        let end = dataArray.last
        
        let beginDate = begin?.replacingOccurrences(of: ".", with: "-")
        let endDate = end?.replacingOccurrences(of: ".", with: "-")
        
        return (beginDate,endDate)
    }
    
    /// 移除首尾的空格
    func removeWhiteSpace() -> String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return trimmingCharacters(in: whitespace)
    }
    // 是否包含表情
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case
            0x00A0...0x00AF,
            0x2030...0x204F,
            0x2120...0x213F,
            0x2190...0x21AF,
            0x2310...0x329F,
            0x1F000...0x1F9CF:
                return true
            default:
                continue
            }
        }
        return false
    }
    
   
}


// MARK: - 数学计算
extension String {
    /// 乘法
    func multiplyingBy(_ value:String) -> String {
        if value.count > 0 {
            let numberA = NSDecimalNumber(string: self)
            let numberB = NSDecimalNumber(string: value)
            let result = numberA.multiplying(by: numberB)
            return result.stringValue
        }
        return self
    }
    /// 除以
    func dividingBy(_ value:String) -> String {
        if value.count > 0 {
            let numberA = NSDecimalNumber(string: self)
            let numberB = NSDecimalNumber(string: value)
            let result = numberA.dividing(by: numberB)
            return result.stringValue
        }
        return self
    }
    /// 减法
    func subtractingBy(_ value:String) -> String {
        if value.count > 0 {
            let numberA = NSDecimalNumber(string: self)
            let numberB = NSDecimalNumber(string: value)
            let result = numberA.subtracting(numberB)
            return result.stringValue
        }
        return self
    }
    /// 加法
    func addingBy(_ value:String) -> String {
        if value.count > 0 {
            let numberA = NSDecimalNumber(string: self)
            let numberB = NSDecimalNumber(string: value)
            let result = numberA.adding(numberB)
            return result.stringValue
        }
        return self
    }
    
    func twoScaleValue() -> String {
        /*
         scale : 需要保留的精度。
         raiseOnExactness : 为YES时在处理精确时如果有错误，就会抛出异常。
         raiseOnOverflow  : YES时在计算精度向上溢出时会抛出异常，否则返回。
         raiseOnUnderflow : YES时在计算精度向下溢出时会抛出异常，否则返回.
         raiseOnDivideByZero : YES时。当除以0时会抛出异常，否则返回。
         */
        let numberA = NSDecimalNumber(string: self)
        let numberHandler = NSDecimalNumberHandler(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        var valueString = numberA.rounding(accordingToBehavior: numberHandler).stringValue
        
        let arange = valueString.range(of: ".")
        if arange?.isEmpty ?? true {
            valueString = valueString.appending(".00")
        }else{
            let location = distance(from: (arange?.lowerBound)!, to:valueString.endIndex)
            if location == 2 {
                valueString = valueString.appending("0")
            }
        }
        return valueString
    }
}
