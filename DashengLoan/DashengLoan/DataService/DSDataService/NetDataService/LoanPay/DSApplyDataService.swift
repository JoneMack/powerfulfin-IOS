//
//  DSApplyDataService.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/25.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSApplyDataService {
    //获取配置
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
    
}

// MARK: - 联络信息相关
extension DSApplyDataService {
    
}

// MARK: - 学历以及职业
extension DSApplyDataService {
    
}

// MARK: - 设备信息。通讯录
extension DSApplyDataService {
    
}

// MARK: - 订单资料相关
extension DSApplyDataService {
    
}
