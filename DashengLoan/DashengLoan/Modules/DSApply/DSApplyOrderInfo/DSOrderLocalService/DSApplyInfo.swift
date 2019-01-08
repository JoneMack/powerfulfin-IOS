//
//  DSApplyInfo.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/7.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

/// 分期预算详情
class DSApplyInfo: NSObject {
    var productInfo: DSLoanProductInfo? {
        didSet{
            calculationPayBacnInfo()
        }
    }
    var loanAmount:String? {
        didSet{
            calculationPayBacnInfo()
        }
    }
    fileprivate(set) var title:String = "每月15日为还款日"
    fileprivate(set) var tips:String = "以下为试算金额，实际还款以通知为准"
    /// 是否是等额分期：
    fileprivate(set) var isEqualAmount = false
    /// 等额本息的情况下，每期还款金额
    fileprivate(set) var amountPerPeriod:String!
    
    /// 弹性分期的情况下，前X期的期数
    fileprivate(set) var xMonths:String!
    /// 弹性分期的情况下，前X期的每期还款金额
    fileprivate(set) var xAmount:String!
    
    /// 弹性分期的情况下，前Y期的期数
    fileprivate(set) var yMonths:String!
    /// 弹性分期的情况下，前Y期的每期还款金额
    fileprivate(set) var yAmount:String!
    
    /// 还款总额
    fileprivate(set) var repayAmount:String!
    
}
extension DSApplyInfo {
   fileprivate func calculationPayBacnInfo() {
        //金融产品类型，1=》弹性，2=》贴息，3=》等额
        if productInfo == nil || loanAmount == nil  {
            return
        }
        if productInfo?.loan_type == 1 {// 1=》弹性
            if productInfo?.rate_x == nil || productInfo?.rate_x?.isEmpty == true {
                productInfo?.rate_x = "0"
            }
            let firstAccount = loanAmount!.multiplyingBy((productInfo?.rate_x)!)
            let interestY = loanAmount!.dividingBy((productInfo?.rate_time_y?.description)!)
            let secondAccont = loanAmount?.multiplyingBy((productInfo?.rate_y)!).addingBy(interestY)
            let xAccount = firstAccount.multiplyingBy((productInfo?.rate_time_x?.description)!)
            let yAccount = secondAccont?.multiplyingBy((productInfo?.rate_time_y?.description)!)
            let totleAccount = xAccount.addingBy(yAccount!).twoScaleValue()
            
            self.isEqualAmount = false
            self.xMonths = productInfo?.rate_time_x?.description
            self.xAmount = firstAccount.twoScaleValue()
            self.yMonths = productInfo?.rate_time_y?.description
            self.yAmount = secondAccont?.twoScaleValue()
            self.repayAmount = totleAccount
            
        }else if productInfo?.loan_type == 2 {//2=》贴息
            let preMonthAccount = loanAmount?.dividingBy((productInfo?.rate_time_x?.description)!).twoScaleValue()
            
            self.isEqualAmount = true
            self.amountPerPeriod = preMonthAccount
            self.repayAmount = loanAmount?.twoScaleValue()
            
        }else if productInfo?.loan_type == 3{//3=》等额
            let yAccount = loanAmount?.dividingBy((productInfo?.rate_time_y?.description)!)
            let yAmount = loanAmount?.multiplyingBy((productInfo?.rate_y)!).addingBy(yAccount!)
            let totleAccount = yAmount?.multiplyingBy((productInfo?.rate_time_y?.description)!).twoScaleValue()
            
            self.isEqualAmount = true
            self.amountPerPeriod = yAmount?.twoScaleValue()
            self.repayAmount = totleAccount
        }
        
    }
}

