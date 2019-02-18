//
//  DSApplySuucessInfo.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/10.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit
import HandyJSON
struct DSApplySuccessInfo:HandyJSON {
    /// 订单号
    var lid:Int?
    /// 公司名称
    var resource_company:String?
    /// 银行卡信息
    var bank_info:DSBankInfo?
    /// 金额计算
    var repay_info:DSApplyInfo?
    
    /// 金额
    var account:String?
    /// 产品名字
    var product_name:String?
    
    
}
