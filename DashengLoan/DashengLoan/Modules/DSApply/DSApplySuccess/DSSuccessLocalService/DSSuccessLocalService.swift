//
//  DSSuccessLocalService.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/10.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSSuccessLocalService: DSApplyLocalService {
    override func fileName() -> String {
        return "success"
    }
    override func reloadData(info: Any) {
        if let successInfo = info as? DSApplySuccessInfo {
            let money = models[0][0]
            let source = models[0][1]
            let product = models[0][2]
            let date = models[0][3]
            let tips = models[0][4]
            let xmont = models[0][5]
            let ymont = models[0][6]
            let bankCode = models[0][7]
            let bankName = models[0][8]

            money.content = "￥\(successInfo.account!).00"
            source.content = "•该笔借款将由\(successInfo.resource_company ?? "")提供"
            product.content = successInfo.product_name
            let replayInfo = successInfo.repay_info
            date.content = replayInfo?.title
            tips.content = "以下为试算金额，实际还款以通知为准"
            xmont.content = "\(replayInfo?.content_one?.content ?? "")\(replayInfo?.content_one?.money ?? "")"
            bankCode.content = successInfo.bank_info?.bank_account
            bankName.content = successInfo.bank_info?.bank_name
            
            if replayInfo?.content_two?.money == nil || replayInfo?.content_two?.money?.isEmpty == true {
            
                var sectionOne = models[0]
                sectionOne.remove(at: 6)
                models[0] = sectionOne
            }else{
                ymont.content = "\(replayInfo?.content_two?.content ?? "")\(replayInfo?.content_two?.money ?? "")"
            }
        }
    }
}
