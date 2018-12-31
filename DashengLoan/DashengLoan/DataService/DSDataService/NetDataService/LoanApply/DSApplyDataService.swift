//
//  DSApplyDataService.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/25.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSApplyDataService {
    /// 获取配置
    class func getApplyConifer(part:Int,complete:@escaping((DSApplyConfiger)->Void)) {
        let request = XJRequest("v1/user/uconfig", method: .post, parameters: ["part":part])
        XJNetWork.request(request, successHandler: { (jsonInfo) in
            if let model = try? XJDecoder.xj_decode(DSApplyConfiger.self, from: jsonInfo) {
                complete(model)
            }
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
    }
    class func getAddressList(province:String? = nil,city:String? = nil,  complete:@escaping(([DSAddress]?,Bool)->Void)) {
        var request:XJRequest!
        if province == nil && city == nil {
            request = XJRequest("v1/area/province", method: .get)
        }else if province != nil {
            request = XJRequest("v1/area/city", method: .get,parameters:["province":province!])
        }else if city != nil {
            request = XJRequest("v1/area/area", method: .get,parameters:["city":city!])
        }
        XJNetWork.request(request, successHandler: { (jsonInfo) in
            if let model = try? XJDecoder.xj_decode([DSAddress].self, from: jsonInfo) {
                complete(model,true)
            }
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
            complete(nil,false)
        }
    }
    
}

// MARK: - 用户身份证信息相关
extension DSApplyDataService {
    /// 获取用户信息
    class func getUserIdInfo(complete:@escaping((DSUserIdInfo)->Void)) {
        let request = XJRequest("v1/user/getuserrealinfo", method: .get)
        XJNetWork.request(request, successHandler: { (jsonInfo) in
            if let model = try? XJDecoder.xj_decode(DSUserIdInfo.self, from: jsonInfo) {
                complete(model)
            }
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")

        }
    }
    /// 获取用户身份证照片
    class func getUserIdPic(order:String,complete:@escaping((Bool,DSUserIdInfo?)->Void)) {
        let request = XJRequest("v1/user/idcardpic", method: .get, parameters: ["order":order])
        XJNetWork.request(request, successHandler: { (jsonInfo) in
            if let model = try? XJDecoder.xj_decode(DSUserIdInfo.self, from: jsonInfo) {
                complete(true,model)
            }else{
                complete(false,nil)
            }
        }) { (error) in
            complete(false,nil)
//            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
    }
    /// 上传用户身份信息
    class func uploadUserIdInfo(info:[String:String],complete:@escaping((Bool)->Void)) {
        let requrst = XJRequest("v1/user/userreal", method: .post, parameters: info)
        XJNetWork.request(requrst, successHandler: { (jsonInfo) in
            complete(true)
        }) { (error) in
            complete(false)
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
    }
}

// MARK: - 银行卡相关
extension DSApplyDataService {
    /// 获取已绑银行卡列表
    class func getBindsBakCards(complete:@escaping((DSUserBanksInfo)-> Void)){
        let requrst = XJRequest("v1/bank/banks", method: .get)
        XJNetWork.request(requrst, successHandler: { (jsonInfo) in
            if let model = try? XJDecoder.xj_decode(DSUserBanksInfo.self, from: jsonInfo) {
                complete(model)
            }
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
    }
    /// 绑定银行卡
    class func bindBankCard(cardInfo:[String:String],complete:@escaping(()->Void)){
        let requrst = XJRequest("v1/bank/bind", method: .get, parameters: cardInfo)
        
        XJNetWork.request(requrst, successHandler: { (jsonInfo) in
             complete()
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
    }
    /// 获取银行卡签约短信
    class func getBankPhoneCode(cardInfo:[String:String],complete:@escaping((String?,Bool)->Void)){
        let requrst = XJRequest("v1/bank/sms", method: .get, parameters: cardInfo)
        
        XJNetWork.request(requrst, successHandler: { (jsonInfo) in
            if let jsonDic = jsonInfo as? [String:String] {
                if let key = jsonDic["serialnumber"] {
                    complete(key,true)
                }
            }else{ complete(nil,false) }
        }) { (error) in
            complete(nil,false)
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
    }
    
    /// 更换支付卡
    ///
    /// - Parameters:
    ///   - carNum: 卡号
    ///   - complete: 回调
    class func changePayBankCard(_ carNum:String,complete:@escaping(()->Void)) {
        let requrst = XJRequest("v1/bank/change", method: .get, parameters: ["bank_account":carNum])
        XJNetWork.request(requrst, successHandler: { (jsonInfo) in
            complete()
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
    }
}

// MARK: - 联络信息相关
extension DSApplyDataService {
    /// 获取联系人信息
    class func getUserContact(complete:@escaping((DSUserContact)->Void)){
        let requrst = XJRequest("v1/user/getusercontact", method: .get)
        XJNetWork.request(requrst, successHandler: { (jsonInfo) in
            if let model = try? XJDecoder.xj_decode(DSUserContact.self, from: jsonInfo) {
                complete(model)
            }
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
    }
    /// 提交联系人信息
    class func uploadUserContact(contactInfo:[String:String],complete:@escaping(()->Void)) {
        let requrst = XJRequest("v1/user/usercontact", method: .post, parameters: contactInfo)
        XJNetWork.request(requrst, successHandler: { (jsonInfo) in
            complete()
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
    }
}

// MARK: - 学历以及职业
extension DSApplyDataService {
    class func getUserWork(complete:@escaping((DSUserWork)->Void)){
        let requrst = XJRequest("v1/user/getuserwork", method: .get)
        XJNetWork.request(requrst, successHandler: { (jsonInfo) in
            if let model = try? XJDecoder.xj_decode(DSUserWork.self, from: jsonInfo) {
                complete(model)
            }
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
    }
    class func uploadUserWork(workInfo:[String:String],complete:@escaping(()->Void)) {
        let requrst = XJRequest("v1/user/userwork", method: .post, parameters: workInfo)
        XJNetWork.request(requrst, successHandler: { (jsonInfo) in
            complete()
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
    }
}

// MARK: - 设备信息。通讯录
extension DSApplyDataService {
    class func uploadUserPhoneInfo(phoneInfo:[String:String],complete:@escaping(()->Void)) {
        let requrst = XJRequest("v1/user/phonebook", method: .post, parameters: phoneInfo)
        XJNetWork.request(requrst, successHandler: { (jsonInfo) in
            complete()
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
    }
}

// MARK: - 订单资料相关
extension DSApplyDataService {
    
}
