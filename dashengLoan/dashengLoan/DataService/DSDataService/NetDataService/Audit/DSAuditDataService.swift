//
//  DSAuditDataService.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/9.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSAuditDataService {
    static func getClassesInfo(orgId:String,complete:@escaping(([DSAuditClassInfo])->Void)) {
        let request = XJRequest("ios/classlist", method: .get, parameters: ["oid":orgId])
        XJNetWork.request(request, successHandler: { (jsonInfo) in
            if let model = try? XJDecoder.xj_decode([DSAuditClassInfo].self, from: jsonInfo) {
                complete(model)
            }
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
    }
    static func signClass(paraDic:[String:String],complete:@escaping(()->Void)) {
        let request = XJRequest("ios/apply", method: .get, parameters: paraDic)
        XJNetWork.request(request, successHandler: { (jsonInfo) in
            complete()
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
    }
    static func getSignOrderList(complete:@escaping(([DSAuditOrderInfo]?,Bool)->Void)) {
        let request = XJRequest("ios/applylist", method: .get)
        XJNetWork.request(request, successHandler: { (jsonInfo) in
            if let model = try? XJDecoder.xj_decode([DSAuditOrderInfo].self, from: jsonInfo) {
                complete(model,true)
            }
        }) { (error) in
            complete(nil,false)
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
    }
}
struct DSAuditClassInfo:Codable {
    var cid:String?
    var class_name:String?
}
struct DSAuditOrderInfo:Codable {
    var id:String?
    var class_name:String?
    var org_name:String?
    var status:String?
}
