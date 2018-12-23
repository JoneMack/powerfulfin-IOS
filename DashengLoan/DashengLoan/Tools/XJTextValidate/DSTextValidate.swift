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
    
    fileprivate var validateBlock:((Bool)->Void)?
    
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
    func validate(_ text:String?) -> DSValidateResult {
        return DSValidateResult(enable: true, tips: "")
    }
    func validateInput(_ text:String?) -> Bool {
        return true
    }
}
private var myContext = 0

class XJTextFiled:UITextField {
    
    var validater:DSTextValidater? {
        
        didSet {
            addTarget(self, action: #selector(XJTextFiled.textDidChanged), for: .editingChanged)
            
        }
    }
    var oldText:String?
    
 
    @objc func textDidChanged()  {
        validater?.textFiled(self, textShouldChanged: self.text, oldText: oldText)
        oldText = text
    }
    
    
    /// 检测text值，是否合法
    /// 调用之前self.validater 必须有值
    /// - Parameter complete: 回调
    func valitateTextStatusChanged(complete:@escaping ((Bool) -> Void)) {
        validater?.validateBlock = complete
    }
    
    func validateText() -> DSValidateResult {
        return validater?.validate(self.text) ?? DSValidateResult(enable: true, tips: "")
    }
}

class DSPhoneValidater:DSTextValidater {
    override func validate(_ text: String?) -> DSValidateResult {
        let count : Int = text?.lengthOfBytes(using: .utf8) ?? 0
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
        return scan.scanInt(&val) && scan.isAtEnd && text?.lengthOfBytes(using: .utf8) ?? 0 < 12
    }
}
class DSCodeValidater:DSTextValidater {
    override func validate(_ text: String?) -> DSValidateResult {
        let count : Int = text?.lengthOfBytes(using: .utf8) ?? 0

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
class  DSPasswordValidater: DSTextValidater {
    override func validate(_ text: String?) -> DSValidateResult {
        let count : Int = text?.lengthOfBytes(using: .utf8) ?? 0
        
        if count > 0 {
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

