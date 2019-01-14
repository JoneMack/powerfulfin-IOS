//
//  DSOrderPlanInfo.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/4.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit


struct DSOrderPlanInfo: Codable {
    var loan_bill:[DSPlanInfo]?
    
}
struct DSPlanInfo:Codable {
    /// 期数id
    var bill_id:Int?
    /// 应还日期
    var should_repay_date:String?
    /// 当期还款状态id
    var status:Int?
    /// 当期还款状态描述
    var status_desp:String?
    /// 期数描述
    var installment:String?
    /// 已还时间，未还款时下发空
    var repay_date:String?
    /// 应还总额
    var repay_need:String?
    /// 已还总额
    var repaid:String?
    /// 还款方式，未还款时下发空
    var repay_way:String?
    /// 还款银行卡号，未还款时下发空
    var repay_bank_account:String?
    /// 还款银行，未还款时下发空
    var repay_bank_name:String?
    /// 还款按钮，1：展示按钮，其他值不展示
    var repay_button:Int?
    /// 资金方ID
    var resource:Int?
    
}
