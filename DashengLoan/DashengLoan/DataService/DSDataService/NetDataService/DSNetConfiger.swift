//
//  DSNetConfiger.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/20.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import AVFoundation
let baseURL = "http://www.powerfulfin.com/app/"
let baseHost = "http://www.powerfulfin.com"

//  注册协议
let registerURL = "http://www.powerfulfin.com/web/contract/reg.html"
//  数字证书使用授权书
let dutyURL = "http://www.powerfulfin.com/web/contract/sign.html"
// 分期付款授权书
let agreementURL = "http://www.powerfulfin.com/web/contract/empower.html"



class DSNetConfiger {
    
    class func requestURL(absoluteURL:String) -> String {
        return baseURL+absoluteURL
    }

}
