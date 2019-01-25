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
    static let applyFinished: NSNotification.Name = NSNotification.Name(rawValue: "DSApplyFinishedNotice")
    //学校机构id
    fileprivate var schooId:String = ""
    //人脸识别SDK的配置
    fileprivate var faceAuthConfig:DSApplyConfiger?
    //人脸识别SDK
    fileprivate let authFaceManager = DSAuthFaceManager()
    //初始进来的页面
    fileprivate weak var beginController:UIViewController?
    fileprivate var step:Int = 0
    func beginApply(_ schooId:String ,fromController:UIViewController?)  {
        
        
        self.schooId = schooId
        self.beginController = fromController
        step = 0
        updateBeginController()
        showNextStep()
    }
    fileprivate func updateBeginController() {
        
        if beginController == nil {
            let navigation = UIApplication.shared.currentNavigationController
            if let viewControlelr = navigation?.topViewController {
               
                let controllers = viewControlelr.rt_navigationController.rt_viewControllers
                let count = (controllers?.count ?? 1)-1
                for index in (0...count).reversed() {
                    if let controller = controllers?[index] {
                        if controller.isKind(of: DSApplyTableViewController.classForCoder()) || controller.isKind(of: DSBankListViewController.classForCoder()) || controller.isKind(of: DSLocationViewController.classForCoder()) || controller.isKind(of: DSPhoneViewController.classForCoder()) {
                        }else{
                            beginController = controller
                            break
                        }
                    }
                }
            }
        }
    }
}
// MARK: - 额，步骤管理
extension DSApply {
    func showNextStep() {
        updateBeginController()

        updateCurrentStep()
        if step == 0 {
           showUserIdView()
        }else if step == 1 {
            beginBankManagerController()
        }else if step == 2 {
            showContactViewController()
        }else if step == 3 {
            showWorkViewController()
        }else if step == 4 {
            showLocationViewController()
        }else if step == 5 {
            showPhoneViewController()
        }else if step == 6 {
            showOrderViewController()
        }else if step == 7 {
            NotificationCenter.default.post(name: DSApply.applyFinished, object: nil)
            beginController?.navigationController?.popToRootViewController(animated: true)
        }
        if step > 0 && step < 7 {
            removeMiddleViewController()
        }
    }
    fileprivate func removeMiddleViewController(){
        var controllers = beginController?.rt_navigationController?.viewControllers
        let orgControllers = beginController?.rt_navigationController.rt_viewControllers
        let count = (controllers?.count)!-1
        let formIndex = (orgControllers?.index(of: beginController!))! + 1
        if count > formIndex {
            controllers?.removeSubrange(formIndex..<count)
            beginController?.rt_navigationController?.viewControllers = controllers!
        }
    }
    fileprivate func updateCurrentStep() {
        let topVC = beginController?.rt_navigationController.rt_topViewController
        if topVC == beginController {
            step = 0
        }else if topVC?.isKind(of: DSUserIdViewController.classForCoder()) ?? false {
            step = 1
        }else if topVC?.isKind(of: DSBankViewController.classForCoder()) ?? false || topVC?.isKind(of: DSBankListViewController.classForCoder()) ?? false{
            step = 2
        }else if topVC?.isKind(of: DSContactViewController.classForCoder()) ?? false {
            step = 3
        }else if topVC?.isKind(of: DSWorkViewController.classForCoder()) ?? false {
            step = 4
        }else if topVC?.isKind(of: DSLocationViewController.classForCoder()) ?? false {
            step = 5
        }else if topVC?.isKind(of: DSPhoneViewController.classForCoder()) ?? false {
            step = 6
        }else if topVC?.isKind(of: DSApplyOrderViewController.classForCoder()) ?? false {
            step = 7
        }
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
        if let userVC = beginController?.rt_navigationController.rt_topViewController {
            authFaceManager.showFaceAuthEngine(from: userVC)
        }
        authFaceManager.authFinish = {[weak self] (isSuccess,userInfo,eremsg) in
            if isSuccess {
                self?.updateBeginController()
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
        beginController?.navigationController?.pushViewController(userIdVC, animated: true)
    }
}
// MARK: - 步骤 1 银行卡信息
extension DSApply {
   fileprivate func beginBankManagerController() {
        XJToast.showToastAction()
        DSApplyDataService.getBindsBakCards {[weak self] (banksInfo,success) in
            XJToast.hiddenToastAction()
            if success {
                if banksInfo?.banks?.count ?? 0 > 0 {
                    self?.showBankListViewController(bansInfo: banksInfo!)
                }else{
                    self?.showBankViewController(bansInfo: banksInfo!)
                }
                self?.removeMiddleViewController()
            }
        }
    }
   fileprivate func showBankViewController(bansInfo:DSUserBanksInfo)  {
        let bankVC = DSBankViewController()
        bankVC.schooId = self.schooId
        bankVC.userName = bansInfo.user_real?.full_name
        beginController?.navigationController?.pushViewController(bankVC, animated: true)
        
    }
    fileprivate func showBankListViewController(bansInfo:DSUserBanksInfo) {
        let bankVC = DSBankListViewController()
        bankVC.banksInfo = bansInfo
        beginController?.navigationController?.pushViewController(bankVC, animated: true)
    }
}

// MARK: - 步骤 2 联系人信息
extension DSApply {
    fileprivate func showContactViewController() {
        let targetVC = DSContactViewController()
        targetVC.schooId = self.schooId
        beginController?.navigationController?.pushViewController(targetVC, animated: true)
    }
}
// MARK: - 步骤 3 工作学历信息
extension DSApply {
    fileprivate func showWorkViewController() {
        let targetVC = DSWorkViewController()
        targetVC.schooId = self.schooId
        beginController?.navigationController?.pushViewController(targetVC, animated: true)
    }
}

// MARK: - 步骤4 位置信息
extension DSApply {
    fileprivate func showLocationViewController() {
        let targetVC = DSLocationViewController()
        targetVC.schooId = self.schooId
        beginController?.navigationController?.pushViewController(targetVC, animated: true)
    }
}

// MARK: - 步骤5 手机通讯录
extension DSApply {
    fileprivate func showPhoneViewController() {
        let targetVC = DSPhoneViewController()
        beginController?.navigationController?.pushViewController(targetVC, animated: true)
    }
}

// MARK: - 步骤6 订单信心
extension DSApply {
    fileprivate func showOrderViewController()  {
        let targetVC = DSApplyOrderViewController()
        targetVC.schooId = self.schooId
        beginController?.navigationController?.pushViewController(targetVC, animated: true)
    }
}
