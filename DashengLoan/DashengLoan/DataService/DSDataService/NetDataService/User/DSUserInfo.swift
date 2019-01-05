//
//  DSUserInfo.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/20.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

struct DSUserInfo:Codable {
    
    /// 用户id
    var uid:String?
    /// 手机号
    var phone:String?
    /// 用户名
    var name:String?
    /// 是否设置了密码 1 是设置了
    var has_password:String?
    
}
