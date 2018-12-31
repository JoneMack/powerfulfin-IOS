//
//  DSApplyConfiger.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/25.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

struct DSApplyConfiger: Codable {
    // MARK: - 人脸识别配置 part = 1
    
    var key:String?
    var order:String?
    var notify_url:String?
    var user_id:String?
    var safe_mode:Int?
    var verified:Int?
    
    // MARK: - 银行信息列表 part = 2
    
    var bank_list:[DSBank]?
    
    // MARK: - 关系 part = 3
    /// 关系列表
    var relations:[String]?
    /// 住房情况
    var housing_situation:[String]?
    /// 婚姻状况
    var marital_status:[String]?
    
    
}

struct DSBank:Codable {
    var bankname:String?
    var bank_code:String?
    var logo:String?
}
