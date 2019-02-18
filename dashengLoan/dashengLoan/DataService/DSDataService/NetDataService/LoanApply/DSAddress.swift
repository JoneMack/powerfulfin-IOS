//
//  DSAddress.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/28.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
import HandyJSON
@objcMembers
class DSAddress:NSObject,HandyJSON {
    var areaid:Int?
    var name:String?
    var parentid:Int?
    var joinname:String?
    required override init() {
        
    }
}
class DSAddressLocalInfo {
    var province:String = ""
    var city:String = ""
    var area:String = ""
    var address:String = ""
}
