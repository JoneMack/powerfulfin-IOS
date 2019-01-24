//
//  DSContactLocalService.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSContactLocalService: DSApplyLocalService {
    var addressInfo = DSAddressLocalInfo()
    override func fileName() -> String {
        return "contact"
    }
    override func reloadData(info: Any) {
        if let contactInfo = info as? DSUserContact {
            let emailModel = models[0][0]
            let wechatModel = models[0][1]
            let qqModel = models[0][2]
            
            let houseModel = models[1][0]
            let addressModel = models[1][1]
            let addressDetailModel = models[1][2]
            
            let marrageModel = models[2][0]
            let nameModel = models[2][1]
            let relationModel = models[2][2]
            let phoneModel = models[2][3]
            
            emailModel.content = contactInfo.email
            wechatModel.content = contactInfo.wechat
            qqModel.content = contactInfo.qq
            houseModel.content = contactInfo.housing_situation
            
            addressInfo.province = contactInfo.home_province ?? ""
            addressInfo.city = contactInfo.home_city ?? ""
            addressInfo.area = contactInfo.home_area ?? ""
            addressInfo.address = "\(contactInfo.home_province_name ?? "")-\(contactInfo.home_city_name ?? "")-\(contactInfo.home_area_name ?? "")"
            
            addressModel.content = addressInfo.address
            addressDetailModel.content = contactInfo.home_address
            marrageModel.content = contactInfo.marital_status
            nameModel.content = contactInfo.contact_person
            relationModel.content = contactInfo.contact_person_relation
            phoneModel.content = contactInfo.contact_person_phone
        }
        
    }
    
    func updateHomeAddress() {
        let addressModel = models[1][1]
        addressModel.content = addressInfo.address
    }
    override func checkUploadParameters(_ showTips: Bool) -> DSApplyParamtersChecker {
        var checker = DSApplyParamtersChecker()
        
        let emailModel = models[0][0]
        checker = checkeModelContentParamters(model: emailModel, show: showTips, checker: checker)
        if checker.canUpload == false {
            return checker
        }
        for index in 1...2 {
            let sectionModels = models[index]
            let count = sectionModels.count - 1
            for idx in 0...count {
                let model = sectionModels[idx]
                checker = checkeModelContentParamters(model: model, show: showTips, checker: checker)
                if checker.canUpload == false {
                    return checker
                }
            }
        }
        checker.paramters["home_province"] = addressInfo.province
        checker.paramters["home_city"] = addressInfo.city
        checker.paramters["home_area"] = addressInfo.area
        return checker
        
    }
    override func getDataInfo() -> [String : String] {
        let emailModel = models[0][0]
        let wechatModel = models[0][1]
        let qqModel = models[0][2]
        
        let houseModel = models[1][0]
        //        let addressModel = models[1][1]
        let addressDetailModel = models[1][2]
        
        let marrageModel = models[2][0]
        let nameModel = models[2][1]
        let relationModel = models[2][2]
        let phoneModel = models[2][3]
        
        return ["email":emailModel.content ?? "",
                "wechat":wechatModel.content ?? "",
                "qq":qqModel.content ?? "",
                "house_status":houseModel.content ?? "",
                "home_province":addressInfo.province,
                "home_city":addressInfo.city,
                "home_area":addressInfo.area,
                "home_address":addressDetailModel.content ?? "",
                "marriage_status":marrageModel.content ?? "",
                "contact_person":nameModel.content ?? "",
                "contact_person_relation":relationModel.content ?? "",
                "contact_person_phone":phoneModel.content ?? "",
        ]
    }
}

