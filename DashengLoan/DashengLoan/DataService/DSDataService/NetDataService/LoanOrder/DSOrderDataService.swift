//
//  DSOrderDataService.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/4.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSOrderDataService {
    /// 获取订单列表
    static func getUserOrderList(complete:@escaping((DSUserOrderListInfo?,Bool)->Void)) {
        let request = XJRequest("v1/loan/list", method: .get)
        XJNetWork.request(request, successHandler: { (jsonInfo) in
            if let model = try? XJDecoder.xj_decode(DSUserOrderListInfo.self, from: jsonInfo) {
                complete(model,true)
            }
        }) { (error) in
            complete(nil,false)
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
        
    }
    /// 获取订单详情
    static func getOrderDetailInfo(lid:String,complete:@escaping((DSOrderInfo?,Bool)->Void)) {
        let request = XJRequest("v1/loan/info", method: .get, parameters: ["lid":lid])
        XJNetWork.request(request, successHandler: { (jsonInfo) in
            if let model = try? XJDecoder.xj_decode(DSOrderInfo.self, from: jsonInfo) {
                complete(model,true)
            }
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
            complete(nil,false)
        }
    }
    static func getOrderPlanInfo(lid:String,complete:@escaping((DSOrderPlanInfo?,Bool)->Void)) {
        let request = XJRequest("v1/loan/loanbill", method: .get,parameters:["lid":lid])
        XJNetWork.request(request, successHandler: { (jsonInfo) in
            if let model = try? XJDecoder.xj_decode(DSOrderPlanInfo.self, from: jsonInfo) {
                complete(model,true)
            }
        }) { (error) in
            complete(nil,true)
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
        
    }}
