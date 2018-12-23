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
        var request:XJRequest
        
        if type == 1 {
            request = XJRequest("v1/login/login", method: .post, parameters: ["phone":userName,"vcode":password])
        }else{
            request = XJRequest("v1/login/login", method: .post, parameters: ["name":userName,"password":password])
        }
        
        XJNetWork.request(request, successHandler: { (jsonInfo) in
            
           
            
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
        
    }
    class func getPhoneCode(phone:String ,complete:@escaping(()->Void))  {
        let request = XJRequest("v1/login/verifycode", method: .get, parameters: ["phone":phone])
        XJNetWork.request(request, successHandler: { (jsonInfo) in
           complete()
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
        
    }
    
    
}
