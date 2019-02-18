//
//  DSUserBanksInfo.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/28.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
import HandyJSON
struct DSUserBanksInfo: HandyJSON {
    
    var banks:[DSBankInfo]?
    var user_real:DSSimpleUserInfo?
}
struct DSBankInfo: HandyJSON {
    var bank_account:String?
    var bank_code:String?
    var bank_name:String?
    var logo:String?
    var phone:String?
    /// 是否为主动划扣卡，1是，2不是
    var type:Int?
}
struct DSSimpleUserInfo: HandyJSON {
    var full_name:String?
    var identity_number:String?
}
