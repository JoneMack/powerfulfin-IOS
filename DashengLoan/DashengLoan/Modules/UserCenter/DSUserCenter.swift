//
//  DSUserCenter.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/20.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
@objc protocol DSUserStatusListener:NSObjectProtocol {
    
    func userLoginSuccess()
    func userLogoutSuccess()
    @objc optional func userInfoChanged()
}
class DSUserCenter: NSObject {
    static let `default` = DSUserCenter()
    fileprivate(set) var userInfo:DSUserInfo?
    var firstLaunch = DSAppearance.isFirstLaunch

    var hasLogin:Bool {
        if userInfo != nil {
            return true
        }
        return false
    }
    
    let listeners = NSHashTable<DSUserStatusListener>(options: [.weakMemory,.objectPersonality])
    
    func addListener(_ listener:DSUserStatusListener)  {
        listeners.add(listener)
    }
    func removeListener(_ listener:DSUserStatusListener) {
        listeners.remove(listener)
    }
    func applicationDidFinishLaunching() {
        
        do {
            if let userJsonDic = UserDefaults.standard.value(forKey: "user") {
                let info = try XJDecoder.xj_decode(DSUserInfo.self, from: userJsonDic)
                self.userInfo = info
                noticeListenter(selector: #selector(DSUserStatusListener.userLoginSuccess))
                return
            }
        } catch {}
        logout()
    }
}
extension DSUserCenter {
    func login(userInfo:DSUserInfo)  {
        self.userInfo = userInfo
        loginToLocalService(userInfo: userInfo)
        noticeListenter(selector: #selector(DSUserStatusListener.userLoginSuccess))
    }
    func logout() {
        userInfo = nil
        noticeListenter(selector: #selector(DSUserStatusListener.userLogoutSuccess))
        logoutFromLocalService()
    }
    func updateUserInfo(_ userInfo:DSUserInfo)  {
        self.userInfo = userInfo
        noticeListenter(selector: #selector(DSUserStatusListener.userInfoChanged))
        loginToLocalService(userInfo: self.userInfo!)
    }
    fileprivate func updateLocalUserInfo() {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(self.userInfo!)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
            UserDefaults.standard.set(json, forKey: "user")
            UserDefaults.standard.synchronize()
        } catch {}
    }
    fileprivate func noticeListenter(selector:Selector) {
        for listener in listeners.allObjects {
            if listener.responds(to: selector) {
                listener.perform(selector)
            }
        }
    }
}

// MARK: - 本地信息处理
extension DSUserCenter {
    func loginToLocalService(userInfo:DSUserInfo)  {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(userInfo)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
            UserDefaults.standard.set(json, forKey: "user")
            UserDefaults.standard.synchronize()
        } catch {}
    }
    func logoutFromLocalService() {
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.synchronize()
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
}
