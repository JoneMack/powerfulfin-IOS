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
let registerURL = "\(baseHost)/web/contract/reg.html"
//  数字证书使用授权书
let dutyURL = "\(baseHost)/web/contract/sign.html"
// 分期付款授权书
let agreementURL = "\(baseHost)/web/contract/empower.html"
// 关于我们
let aboutUsURL = "\(baseHost)/web/app/about.html"
// 常见问题
let questionURL = "\(baseHost)/web/app/question.html"


class DSNetConfiger {
    
    class func requestURL(absoluteURL:String) -> String {
        return baseURL+absoluteURL
    }

}
