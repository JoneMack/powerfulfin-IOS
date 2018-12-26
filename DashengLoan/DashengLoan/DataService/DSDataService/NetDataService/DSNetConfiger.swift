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

class DSNetConfiger {
    
    class func requestURL(absoluteURL:String) -> String {
        return baseURL+absoluteURL
    }

}
