//
//  XJTextField.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/8.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit
private var myContext = 0
class XJTextField: UITextField {

    private var validateBlock:((Bool)->Void)?
    
    var validater:DSTextValidater? {
        didSet {
            addTarget(self, action: #selector(XJTextField.textDidChanged), for: .editingChanged)
            validater?.validateBlock = validateBlock
            oldText = text
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
        validateBlock = complete
        validater?.validateBlock = complete
    }
    
    func validateText() -> DSValidateResult {
        return validater?.validate(self.text) ?? DSValidateResult(enable: true, tips: "")
    }

}
