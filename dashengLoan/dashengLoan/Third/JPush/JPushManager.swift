//
//  JPushManager.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/22.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

#if DEBUG
fileprivate let isProduction = false
#else
fileprivate let isProduction = true
#endif

fileprivate let jpushKey = "39e546a3fa44c0777dbd1078"
fileprivate let registrationIDKey = "ds.push.id.key"

class JPushManager: NSObject {
    static func applicationDidFinishLaunching(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?,delegate:JPUSHRegisterDelegate) {
        
        setBadge(num: 0)
        let entity = JPUSHRegisterEntity()
        entity.types = Int(JPAuthorizationOptions.alert.rawValue)|Int(JPAuthorizationOptions.sound.rawValue)|Int(JPAuthorizationOptions.badge.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: delegate)
        
        JPUSHService.setup(withOption: launchOptions, appKey: jpushKey, channel: DSAppearance.appearance.appChannel, apsForProduction: isProduction)
        
        JPUSHService.registrationIDCompletionHandler { (code, registrationID) in
            if let registID = registrationID {
                print("pushId:\(registID)")
                UserDefaults.standard.setValue(registID, forKey: registrationIDKey)
                UserDefaults.standard.synchronize()
            }
        }
        JPUSHService.setLogOFF()
    }
    /// 获取id
    static var registrationID:String? {
        
        if let registrationID = UserDefaults.standard.value(forKey: registrationIDKey) as? String {
            return registrationID
        }
        return nil
    }
    /// 注册Token
    static func registerDevice(_ token:Data) {
        JPUSHService.registerDeviceToken(token)
    }
    /// 设置图标通知数量
    static func setBadge(num:Int){
        UIApplication.shared.applicationIconBadgeNumber = num
        JPUSHService.setBadge(num)
    }
    
}
extension JPushManager {
    static func handleRemoteNotificationInfo(noticeInfo:[AnyHashable:Any]) {
        JPUSHService.handleRemoteNotification(noticeInfo)
        if let link = noticeInfo["link"] as? String {
            DSRouter.openURL(url: link)
        }
    }
}
