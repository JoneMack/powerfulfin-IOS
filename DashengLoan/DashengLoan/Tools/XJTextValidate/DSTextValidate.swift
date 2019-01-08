//
//  DSTextValidate.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/21.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
struct DSValidateResult {
    let enable:Bool
    let tips:String
}
class DSTextValidater: NSObject {
    
     var validateBlock:((Bool)->Void)?
    
    func textFiled(_ textFiled:UITextField, textShouldChanged newText:String?, oldText:String?) {
        let result  = validateInput(newText)
        var finaleText = newText
        
        if result == false {
            textFiled.text = oldText
            finaleText = oldText
        }
        let status = validate(finaleText).enable
        validateBlock?(status)
    }
    /// 校验已输入的内容是否合法
    func validate(_ text:String?) -> DSValidateResult {
        return DSValidateResult(enable: true, tips: "")
    }
    /// 校验是否可以输入当前想输入的内容
    func validateInput(_ text:String?) -> Bool {
        return true
    }
}


// 手机号码校验
class DSPhoneValidater:DSTextValidater {
    override func validate(_ text: String?) -> DSValidateResult {
        let count : Int = text?.count ?? 0
        if count > 0 && count < 12 {
            return DSValidateResult(enable: true, tips: "")
        }
        return DSValidateResult(enable: false, tips: "请输入正确的手机号")
    }
    override func validateInput(_ text: String?) -> Bool {
        if  text == "" {
            return true
        }
        let scan: Scanner = Scanner(string: text ?? "")
        var val:Int = 0
        let success = scan.scanInt(&val) && scan.isAtEnd && text?.count ?? 0 < 12
        return success
    }
}
// MARK:- 短信验证码校验
/// 短信验证码校验
class DSCodeValidater:DSTextValidater {
    override func validate(_ text: String?) -> DSValidateResult {
        let count : Int = text?.count ?? 0

        if count > 0 {
            return DSValidateResult(enable: true, tips: "")
        }
        return DSValidateResult(enable: false, tips: "请输入正确的验证码")
    }
    override func validateInput(_ text: String?) -> Bool {
        if  text == "" {
            return true
        }
        let scan: Scanner = Scanner(string: text ?? "")
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd && text?.lengthOfBytes(using: .utf8) ?? 0 < 7
    }
}
// MARK:- 密码校验
/// 密码校验
class  DSPasswordValidater: DSTextValidater {
    override func validate(_ text: String?) -> DSValidateResult {
        let count : Int = text?.count ?? 0

        if count > 7 {
            return DSValidateResult(enable: true, tips: "")
        }
        return DSValidateResult(enable: false, tips: "请输入密码")
    }
    override func validateInput(_ text: String?) -> Bool {
        if  text == "" {
            return true
        }
        let count : Int = text?.lengthOfBytes(using: .utf8) ?? 0

        return count < 21
    }
}


// MARK:- 通用校验
/// 常用的屏蔽 限制：不可以空，不可以输入表情、
class DSNoramlValidater: DSTextValidater {
    override func validate(_ text: String?) -> DSValidateResult {
        let count : Int = text?.count ?? 0
        if count > 0 {
            return DSValidateResult(enable: true, tips: "")
        }
        return DSValidateResult(enable: false, tips: "请输入正确的内容")
    }
    override func validateInput(_ text: String?) -> Bool {
        if  text == "" {
            return true
        }
        if text?.containsEmoji == true {
            return false
        }
        return true
    }
}
class DSBankCodeValidater: DSTextValidater {
    override func textFiled(_ textFiled:UITextField, textShouldChanged newText:String?, oldText:String?) {
        
        let realBankNum = newText?.replacingOccurrences(of: " ", with: "") ?? ""
        
        let result  = validateInput(realBankNum)
        
        var finaleText = ""

        if result == false {
            textFiled.text = oldText
            finaleText = oldText ?? ""
        }else{
            var  anewText = realBankNum
            var targetNum = ""
            var totleCount = anewText.count
            
            while totleCount > 0 {
                let length = totleCount > 4 ? 4 : totleCount
                let subString = anewText[0..<length]
                targetNum = targetNum.appending(subString)
                if subString.count == 4 {
                    targetNum = targetNum.appending(" ")
                }
                anewText = anewText[length..<totleCount]
                totleCount = anewText.count
            }
            finaleText = targetNum
            textFiled.text = targetNum
        }
        
        
        
        let status = validate(finaleText).enable
        validateBlock?(status)
    }
    /// 校验已输入的内容是否合法
    override func validate(_ text:String?) -> DSValidateResult {
        let count : Int = text?.count ?? 0
        if count > 0 {
            return DSValidateResult(enable: true, tips: "")
        }
        return DSValidateResult(enable: false, tips: "请输入正确的内容")
    }
    /// 校验是否可以输入当前想输入的内容
    override func validateInput(_ text:String?) -> Bool {
        if  text == "" {
            return true
        }
        if text?.containsEmoji == true {
            return false
        }
        let scan: Scanner = Scanner(string: text ?? "")
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
        
    }
}
// MARK:- 身份证校验
/// 身份证校验
class DSIdValidater: DSTextValidater {
    
    override func validate(_ text: String?) -> DSValidateResult {
        let count : Int = text?.count ?? 0

        if count == 15 || count == 18 {
            return DSValidateResult(enable: true, tips: "")
        }
        return DSValidateResult(enable: false, tips: "请输入正确的身份证号")
    }
    override func validateInput(_ text: String?) -> Bool {
        if  text == "" {
            return true
        }
        if text?.count ?? 0 > 18 {
            return false
        }
        if text?.count ?? 0 < 18 {
            let scan: Scanner = Scanner(string: text ?? "")
            var val:Int = 0
            return scan.scanInt(&val) && scan.isAtEnd
        }else{
            if text?.last == "x" || text?.last == "X" {
                let numberText = text?[0..<17]
                let scan: Scanner = Scanner(string: numberText!)
                var val:Int = 0
                return scan.scanInt(&val) && scan.isAtEnd
            }else{
                let scan: Scanner = Scanner(string: text ?? "")
                var val:Int = 0
                return scan.scanInt(&val) && scan.isAtEnd
            }
        }
    }
}

