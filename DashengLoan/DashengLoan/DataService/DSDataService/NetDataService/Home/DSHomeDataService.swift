//
//  DSHomeDataService.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/24.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSHomeDataService {
    class func loadHomeData(complete:@escaping((DSHomeInfo?,Bool) -> Void)) {
        let request = XJRequest("v1/index/index", method: .get)
        XJNetWork.request(request, successHandler: { (jsonInfo) in
            if let homeInfo = try? XJDecoder.xj_decode(DSHomeInfo.self, from: jsonInfo) {
                complete(homeInfo,true)
            }
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
            complete(nil,false)
        }
    }
    class func searchSchools(name:String,page:Int = 1,complete:@escaping((DSSearchData)->Void)) {
        let request = XJRequest("v1/search/school", method: .get, parameters: ["keyword":name,"page":page])
        XJNetWork.request(request, successHandler: { (jsonInfo) in
            if let homeInfo = try? XJDecoder.xj_decode(DSSearchData.self, from: jsonInfo) {
                complete(homeInfo)
            }
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
        
    }
}
