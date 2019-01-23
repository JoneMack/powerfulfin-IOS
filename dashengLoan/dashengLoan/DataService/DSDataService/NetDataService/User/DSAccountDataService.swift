//
//  DSAccountDataService.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/20.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSAccountDataService {
    
    /// 登录接口
    ///
    /// - Parameters:
    ///   - userName: 用户名/手机号
    ///   - password: 密码/手机号验证码
    ///   - type: 登录方式：1 手机号+验证码，2是用户名+密码
    ///   - complete: 用户信息
    class func login(userName:String,password:String,type:NSInteger=1,complete:@escaping((DSUserInfo)-> Void)) {
        
        var parameters = [String:Any]()
        parameters["phone"] = userName
        parameters["pushid"] = JPushManager.registrationID
        if type == 1 {
            parameters["vcode"] = password
        }else{
            parameters["password"] = password
        }
      let request = XJRequest("v1/login/login", method: .post, parameters: parameters)

        XJNetWork.request(request, successHandler: { (jsonInfo) in
            
            if let userInfo = try? XJDecoder.xj_decode(DSUserInfo.self, from: jsonInfo) {
                complete(userInfo)
            }
        }) { (error) in
            if error.code > 0 {//新用户，没密码
                DSAlert.showAlert(title: "提示", message: error.errorMsg, sureTitle: "确定")
            }else{
                XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
            }
        }
        
    }
    /// 获取手机号验证码
    class func getPhoneCode(phone:String ,complete:@escaping(()->Void))  {
        let request = XJRequest("v1/login/verifycode", method: .get, parameters: ["phone":phone])
        XJNetWork.request(request, successHandler: { (jsonInfo) in
           complete()
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
        
    }
    /// 退出登录
    class func logout() {
        let request = XJRequest("v1/logout", method: .get)
        XJNetWork.request(request, successHandler: { (jsonInfo) in
            
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
        
    }
    static func updateUserPassword(oldPwd:String?,newPwd:String,complete:@escaping((Bool)->Void)) {
        let request = XJRequest("v1/login/setpassword", method: .post, parameters: ["old_password":oldPwd ?? "","new_password":newPwd])
        XJNetWork.request(request, successHandler: { (jsonInfo) in
            if DSUserCenter.default.userInfo != nil {
                var userInfo = DSUserCenter.default.userInfo!
                userInfo.has_password = "1"
                DSUserCenter.default.updateUserInfo(userInfo)
            }
            complete(true)
        }) { (error) in
            complete(false)
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
    }
    static func getUserMessageList(complete:@escaping((DSUserMessageInfo?,Bool)->Void)) {
        let requet = XJRequest("", method: .get)
        XJNetWork.request(requet, successHandler: { (jsonInfo) in
            if let model = try? XJDecoder.xj_decode(DSUserMessageInfo.self, from: jsonInfo) {
                complete(model,true)
            }
        }) { (error) in
            complete(nil,false)
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
        
    }
    
}
