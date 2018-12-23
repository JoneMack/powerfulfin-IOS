//
//  DSNetConfiger.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/20.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import AVFoundation
let baseURL = "http://powerfulfin.kezhanwang.cn/app/"
class DSNetConfiger {
    
    class func requestURL(absoluteURL:String) -> String {
        return baseURL+absoluteURL
    }

}
