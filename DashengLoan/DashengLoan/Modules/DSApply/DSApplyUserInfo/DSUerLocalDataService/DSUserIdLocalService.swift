//
//  DSUserIdLocalService.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/25.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSUserIdLocalService: DSApplyLocalService {
   
    override func fileName() -> String {
         return "userid"
    }
    override func reloadData(info: Any) {
        if let userInfo = info as? DSUserIdInfo {
            let nameModel = cellMode(indexPath: IndexPath(row: 1, section: 0))
            let idModel = cellMode(indexPath: IndexPath(row: 2, section: 0))
            let nativeModel = cellMode(indexPath: IndexPath(row: 3, section: 0))
            let authorityModel = cellMode(indexPath: IndexPath(row: 4, section: 0))
            let starDate = cellMode(indexPath: IndexPath(row: 5, section: 0))
            let endDate = cellMode(indexPath: IndexPath(row: 6, section: 0))
            let address = cellMode(indexPath: IndexPath(row: 7, section: 0))
            let idPic = cellMode(indexPath: IndexPath(row: 8, section: 0))
            let authResult = cellMode(indexPath: IndexPath(row: 0, section: 1))
            
            nameModel.content = userInfo.full_name
            idModel.content = userInfo.identity_number
            nativeModel.content = userInfo.nationality
            authorityModel.content = userInfo.issuing_authority
            starDate.content = userInfo.start_date
            endDate.content = userInfo.end_date
            address.content = userInfo.address
            idPic.content = userInfo.idcard_information_pic_url
            if userInfo.user_real == 3 {
                authResult.content = "认证失败"
            }else if userInfo.user_real == 2 {
               authResult.content = "认证成功"
            }else{
                authResult.content = "待认证"
            }
        }
    }
    override func getDataInfo() -> [String : String] {
        let nameModel = cellMode(indexPath: IndexPath(row: 1, section: 0))
        let idModel = cellMode(indexPath: IndexPath(row: 2, section: 0))
        let nativeModel = cellMode(indexPath: IndexPath(row: 3, section: 0))
        let authorityModel = cellMode(indexPath: IndexPath(row: 4, section: 0))
        let starDate = cellMode(indexPath: IndexPath(row: 5, section: 0))
        let endDate = cellMode(indexPath: IndexPath(row: 6, section: 0))
        let address = cellMode(indexPath: IndexPath(row: 7, section: 0))
        
        var paraDic = [String:String]()
        paraDic["full_name"] = nameModel.content
        paraDic["identity_number"] = idModel.content
        paraDic["nationality"] = nativeModel.content
        paraDic["issuing_authority"] = authorityModel.content
        paraDic["start_date"] = starDate.content
        paraDic["end_date"] = endDate.content
        paraDic["address"] = address.content
        return paraDic
        
    }
    
}

