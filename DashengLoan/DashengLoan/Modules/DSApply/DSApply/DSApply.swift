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
    
    //学校机构id
    fileprivate var schooId:String = ""
    //人脸识别SDK的配置
    fileprivate var faceAuthConfig:DSApplyConfiger?
    //人脸识别SDK
    fileprivate let authFaceManager = DSAuthFaceManager()
    //初始进来的页面
    fileprivate weak var beginController:UIViewController?
    //当前展示的步骤
    fileprivate weak var currentController:DSApplyTableViewController?
    fileprivate var step:Int = 0
    func beginApply(_ schooId:String ,fromController:UIViewController)  {
        self.schooId = schooId
        self.beginController = fromController
        step = 0
        showNextStep()
    }

}
// MARK: - 额，步骤管理
extension DSApply {
    func showNextStep() {
        
        if step == 0 {
//            showUserIdView()
//            return
            XJToast.showToastAction()
            loadUserFaceAuthConfig { [weak self] in
                DispatchQueue.main.async {
                    XJToast.hiddenToastAction()
                    if self?.faceAuthConfig?.verified == 1 {
                        self?.showUserIdView()
                    }else{
                        self?.showUserFaceAuthView()
                    }
                }
            }
        }
        
        currentController = beginController?.rt_navigationController.rt_topViewController as? DSApplyTableViewController
    }
    
}
// MARK: - 步骤 0 身份证信息
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
        authFaceManager.authFinish = {[weak self] (isSuccess,userInfo,eremsg) in
            if isSuccess {
                if let userVC = self?.beginController?.rt_navigationController.rt_topViewController as? DSUserIdViewController {
                    userVC.orderId = self?.faceAuthConfig?.order
                    userVC.updateUserIdInfo(userInfo: userInfo)
                    userVC.reloadUserIdPic()
                }
            }
        }
    }
    /// 展示用户信息页面
    fileprivate func showUserIdView() {
        
        if (beginController?.rt_navigationController.rt_topViewController.isKind(of: DSUserIdViewController.classForCoder()))! == true {
            return
        }
        
        let userIdVC =  DSUserIdViewController()
        userIdVC.schooId = self.schooId
        userIdVC.orderId = faceAuthConfig?.order
        beginController?.navigationController?.pushViewController(userIdVC, animated: true)
    }
}
// MARK: - 步骤 1 银行卡信息
extension DSApply {
    
}

