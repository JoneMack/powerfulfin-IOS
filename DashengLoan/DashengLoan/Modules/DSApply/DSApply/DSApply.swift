//
//  DSApply.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/25.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

/// 申请管理中心
class DSApply: NSObject {
    static let `default` = DSApply()
    fileprivate var schooId:String = ""
    fileprivate var faceAuthConfig:DSApplyConfiger?
    fileprivate weak var beginController:UIViewController?
    
    func beginApply(_ schooId:String ,fromController:UIViewController)  {
        self.schooId = schooId
        self.beginController = fromController
        showUserIdView()
        return
//        loadUserFaceAuthConfig { [weak self] in
//            if self?.faceAuthConfig?.verified == 1 {
//                self?.showUserIdView()
//            }else{
//                self?.showUserFaceAuthView()
//            }
//        }
    }

}

// MARK: - 人脸识别
extension DSApply {
    
    /// 直接进入认证页面
    func beginAuthFace()  {
        loadUserFaceAuthConfig {[weak self] in
            self?.showUserFaceAuthView()
        }
    }
    /// 加载认证配置
    fileprivate func loadUserFaceAuthConfig(complete:@escaping(()->Void)) {
        DSApplyDataService.getApplyConifer(part: 1) {[weak self] (configer) in
            self?.faceAuthConfig = configer
           complete()
        }
    }
    /// 展示认证页面
   fileprivate func showUserFaceAuthView() {
        let authFaceManager = DSAuthFaceManager()
        authFaceManager.authEngine.authKey = faceAuthConfig?.key
        authFaceManager.authEngine.outOrderId = faceAuthConfig?.order
        authFaceManager.authEngine.userId = faceAuthConfig?.user_id
        authFaceManager.authEngine.notificationUrl = faceAuthConfig?.notify_url
        if faceAuthConfig?.safe_mode == 0{
            authFaceManager.authEngine.safeMode = .high
        }else if faceAuthConfig?.safe_mode == 1{
            authFaceManager.authEngine.safeMode = .medium
        }else if faceAuthConfig?.safe_mode == 2{
            authFaceManager.authEngine.safeMode = .low
        }
        authFaceManager.showFaceAuthEngine(from: beginController!)
        showUserIdView()
    }
    /// 展示用户信息页面
   fileprivate func showUserIdView() {
        
        if (beginController?.rt_navigationController.rt_topViewController.isKind(of: DSUserIdViewController.classForCoder()))! == true {
            return
        }
        let userIdVC =  DSUserIdViewController()
        beginController?.navigationController?.pushViewController(userIdVC, animated: true)
    }
}
