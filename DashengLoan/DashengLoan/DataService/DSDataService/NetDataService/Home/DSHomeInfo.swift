//
//  DSHomeInfo.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/24.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

/// 首页数据
struct DSHomeInfo: Codable {
    var banner:[DSHomeBanner]?
    var customer_service:DSCustomerService?
    var notice:DSHomeNotice?
    var loan:DSHomeLoanInfo?
}

/// banner
struct DSHomeBanner:Codable {
    var img:String?
    var url:String?
}

/// 客服热线
struct DSCustomerService:Codable {
    var phone:String?
    var email:String?
}

/// 大圣快报
struct DSHomeNotice:Codable {
    var content:String?
    var url:String?
}

/// 分期信息
struct DSHomeLoanInfo:Codable {
    /// 状态值
    var status:String?
    
    /// 状态logo
    var status_img_2x:String?
    var status_img_3x:String?
    /// 状态
    var status_desp:String?
    /// 还款日
    var repay_date:String?
    /// 还款金额
    var repay_money:String?
    /// 描述
    var remark:String?
    /// 推荐的学校id
    var school_id:String?
    /// 推荐的学校名字
    var school_name:String
    /// 要展示的按钮
    var buttons:[DSLoanButtonInfo]?
}
struct DSLoanButtonInfo:Codable {
    var name:String?
    var url:String?
    var style:String?
}