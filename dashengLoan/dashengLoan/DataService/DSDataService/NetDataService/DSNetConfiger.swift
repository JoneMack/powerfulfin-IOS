//
//  DSNetConfiger.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/20.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import AVFoundation
//let baseURL = "http://www.powerfulfin.com/app/"
//let baseHost = "http://www.powerfulfin.com"



fileprivate let netPlatformKey:String = "ds.net.platform.key"
enum DSNetPlatform : NSInteger {
    case release = 0
    case debug  = 1
}
class DSNetConfiger {
    
    class func requestURL(absoluteURL:String) -> String {
        return baseURL+absoluteURL
    }
    static var baseURL:String {
        let platform = DSNetConfiger.netPlatform
        switch platform {
        case .release:
            return "https://app.powerfulfin.com/app/"
        case .debug:
            return "http://test.app.powerfulfin.com/app/"
        }
    }
    static var baseHost:String  {
        let platform = DSNetConfiger.netPlatform
        switch platform {
        case .release:
            return "http://app.powerfulfin.com"
        case .debug:
            return "http://test.app.powerfulfin.com"
        }
    }
    static fileprivate(set) var netPlatform:DSNetPlatform = {
        let platform = UserDefaults.standard.integer(forKey: netPlatformKey)
        return DSNetPlatform(rawValue: platform) ?? .release
    }()
    static func changeNetPlatform(platform:DSNetPlatform) {
        netPlatform = platform
        UserDefaults.standard.set(platform.rawValue, forKey: netPlatformKey)
        UserDefaults.standard.synchronize()
    }
}

//  注册协议
let registerURL = "\(DSNetConfiger.baseHost)/web/contract/reg.html"
//  数字证书使用授权书
let dutyURL = "\(DSNetConfiger.baseHost)/web/contract/sign.html"
// 分期付款授权书
let agreementURL = "\(DSNetConfiger.baseHost)/web/contract/empower.html"
// 关于我们
let aboutUsURL = "\(DSNetConfiger.baseHost)/web/app/about.html"
// 常见问题
let questionURL = "\(DSNetConfiger.baseHost)/web/app/question.html"
