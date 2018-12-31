//
//  DSUserContact.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/28.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

struct DSUserContact:Codable {
    /// 邮箱
    var email:String?
    /// 省id
    var home_province:String?
    /// 市id
    var home_city:String?
    /// 区id
    var home_area:String?
    /// 详细地址
    var home_address:String?
    /// 住房情况
    var housing_situation:String?
    /// 婚姻状况
    var marital_status:String?
    /// 紧急联系人
    var contact_person:String?
    /// 关系
    var contact_person_relation:String?
    /// 联系人手机号
    var contact_person_phone:String?
    /// 微信
    var wechat:String?
    /// QQ
    var qq:String?
    
}
