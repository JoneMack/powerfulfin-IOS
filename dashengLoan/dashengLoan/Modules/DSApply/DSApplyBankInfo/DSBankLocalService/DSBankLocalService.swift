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
    
    override func checkUploadParameters(_ showTips: Bool) -> DSApplyParamtersChecker {
        var checker = DSApplyParamtersChecker()
        let sectionOne = models[0]
        let count = sectionOne.count - 1
        
        for index in 0...count {
            let model = sectionOne[index]
            if index == 0 {
                checker = checkeModelSubContentParamters(model: model, show: showTips, checker: checker)
            }else if index == 1{
                checker = checkeModelContentParamters(model: model, show: showTips, checker: checker)
                var bankNum = model.content
                bankNum = bankNum?.replacingOccurrences(of: " ", with: "")
                checker.paramters[model.servicename] = bankNum
            }else{
                checker = checkeModelContentParamters(model: model, show: showTips, checker: checker)

            }
            if checker.canUpload == false {
                return checker
            }
        }
        return checker
    }
}
extension DSBankLocalService {
    
    func getPhoneCodeParaDic() -> [String:String] {
        let bankModel = cellMode(indexPath: IndexPath(row: 0, section: 0))
        let bankCodeModel = cellMode(indexPath: IndexPath(row: 1, section: 0))
        let phoneModel = cellMode(indexPath: IndexPath(row: 2, section: 0))
        let bankCode = bankCodeModel.content?.replacingOccurrences(of: " ", with: "")
        
        return ["bank_code":bankModel.subContent ?? "",
            "bank_account":bankCode ?? "",
            "phone":phoneModel.content ?? ""]
    }
    func getBindCardParaDic() -> [String:String] {
        var pardDic = getPhoneCodeParaDic()
        let codeModel = cellMode(indexPath: IndexPath(row: 3, section: 0))
        pardDic["vcode"] = codeModel.content
        return pardDic
    }
}
