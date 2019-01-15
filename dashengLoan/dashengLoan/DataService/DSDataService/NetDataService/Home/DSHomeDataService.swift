//
//  DSHomeDataService.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/24.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
import HandyJSON
class DSHomeDataService {
    class func loadHomeData(complete:@escaping((DSHomeInfo?,Bool) -> Void)) {
        let paraDic = ["school_mac":XJDeviceInfo.wifiInfo.mac]
        let request = XJRequest("v1/index/index", method: .get,parameters:paraDic)
        XJNetWork.request(request, successHandler: { (jsonInfo) in
            if  let homeInfo = DSHomeInfo.deserialize(from: jsonInfo as? [String : Any]) {
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
            if  let homeInfo = DSSearchData.deserialize(from: jsonInfo as? [String : Any]) {
                complete(homeInfo)
            }
        }) { (error) in
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
        
    }
}
