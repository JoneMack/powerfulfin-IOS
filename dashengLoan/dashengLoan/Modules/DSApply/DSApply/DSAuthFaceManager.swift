
//
//  DSAuthFaceManager.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/25.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

/// 人脸识别DSK
class DSAuthFaceManager:NSObject {
    let authEngine = UDIDSafeAuthEngine()
    
    /// 认证回调：是否认证完成，身份证信息，错误信息
    var authFinish:((Bool,DSUserIdInfo,String) -> Void)?
    
    override init() {
        super.init()
        authEngine.delegate = self
        authEngine.showInfo = true
        
    }
    func showFaceAuthEngine(from controller:UIViewController) {
        authEngine.startIdSafe(withUserName: "", identityNumber: "", in: controller)
    }
    
}
extension DSAuthFaceManager : UDIDSafeAuthDelegate {
    /*
     result_auth : 交易成功后必传。有 T、F、 C 三种状态，分别对应认证 成功，认证失败和正在人 工审核中
     */
    func idSafeAuthFinished(withResult result: Int, userInfo: Any!) {
        var isFinished = false
        
        var errorMsg:String = "认证失败"
        var userIdInfo = DSUserIdInfo()
        
        if result == 0 {//流程走完
            
            if let resultInfo = userInfo as? [String:Any] {
                isFinished = true
                var isAuthSuccessed = false
                let authResult = resultInfo["result_auth"] as? String
                if authResult == "T" {
                    errorMsg = "认证成功"
                    isAuthSuccessed = true
                    
                }
                
                userIdInfo.user_real = isAuthSuccessed ? 2 : 3
                userIdInfo.full_name = resultInfo["id_name"] as? String
                userIdInfo.identity_number = resultInfo["id_no"] as? String
                userIdInfo.nationality = resultInfo["state_id"] as? String
                if let date = resultInfo["start_card"] as? String {
                    let during = date.getDate()
                    userIdInfo.start_date = during.0
                    userIdInfo.end_date = during.1
                }                
                userIdInfo.issuing_authority = resultInfo["branch_issued"] as? String
                userIdInfo.address = resultInfo["addr_card"] as? String
                userIdInfo.idcard_information_pic_url = resultInfo["url_frontcard"] as? String
                userIdInfo.idcard_national_pic_url = resultInfo["url_backcard"] as? String
                
            }
        }else if result == 1 {//取消认证
            errorMsg = "认证发生异常"
        }else if result == 2 {//取消认证
            errorMsg = "取消认证"
            userIdInfo.user_real = 1
        }else if result == 3 {//取消认证
            errorMsg = "认证姓名不合法"
        }else if result == 4 {//取消认证
            errorMsg = "认证身份证号不合法"
        }
        authFinish?(isFinished,userIdInfo,errorMsg)
    }
   
}
