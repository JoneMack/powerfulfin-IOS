//
//  DSApplyDataService.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/25.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSApplyDataService {
    class func getApplyConifer(part:Int,complete:@escaping((DSApplyConfiger)->Void)) {
        let request = XJRequest("v1/user/uconfig", method: .post, parameters: ["part":part])
        XJNetWork.request(request, successHandler: { (jsonInfo) in
            if let model = try? XJDecoder.xj_decode(DSApplyConfiger.self, from: jsonInfo) {
                complete(model)
            }
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
        
    }
}
