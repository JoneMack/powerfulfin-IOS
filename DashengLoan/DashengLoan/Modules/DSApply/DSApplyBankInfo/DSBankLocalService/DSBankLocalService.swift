//
//  DSBankLocalService.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSBankLocalService: DSApplyLocalService {
    override init() {
        super.init()
    }
    override func fileName() -> String {
        return "bank"
    }
   override func loadLocalData() {
        super.loadLocalData()
    }
}
extension DSBankLocalService {
    
    func getPhoneCodeParaDic() -> [String:String] {
        let bankModel = cellMode(indexPath: IndexPath(row: 0, section: 0))
        let bankCodeModel = cellMode(indexPath: IndexPath(row: 1, section: 0))
        let phoneModel = cellMode(indexPath: IndexPath(row: 2, section: 0))
        return ["bank_code":bankModel.subContent ?? "",
            "bank_account":bankCodeModel.content ?? "",
            "phone":phoneModel.content ?? ""]
    }
    func getBindCardParaDic() -> [String:String] {
        var pardDic = getPhoneCodeParaDic()
        let codeModel = cellMode(indexPath: IndexPath(row: 3, section: 0))
        pardDic["vcode"] = codeModel.content
        return pardDic
        
    }
}
