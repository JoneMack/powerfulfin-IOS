//
//  DSUserOrderListInfo.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/4.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

struct DSUserOrderListInfo: Codable {
    var list:[DSSimpleOrderInfo]?
    
}
struct DSSimpleOrderInfo :Codable {
    var lid:String?
    var borrow_money:String?
    var org_name:String?
    var status_desp:String?
    
}
struct DSOrderInfo:Codable {
    /// 订单id
    var lid:String?
    var status_desp:String?
    
    /// 借款时间。申请时间
    var create_time:String?
    /// 资金方id
//    var resource:Int?
    /// 资金方名字
    var resource_company:String?
    /// 借款金额
    var borrow_money:String?
    /// 分期期数
    var installment:String?
    /// 待还期数
    var repay_need:Int?
    /// 机构名称
    var org_name:String?
    /// 用户姓名
    var full_name:String?
    var phone:String?
    
    /// 银行卡号
    var bank_account:String?
    /// 银行名称
    var bank_name:String?
    /// 借款金融的名称
    var loan_product:String?
    /// 还款协议地址
    var contract:String?
    /// 拒绝原因
    var audit_opinion:String?
}
