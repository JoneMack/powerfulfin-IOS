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
    static let defalut = DSUserCenter()
    fileprivate(set) var userInfo:DSUserInfo?
    let listeners = NSHashTable<DSUserStatusListener>(options: [.weakMemory,.objectPersonality])
    
    func addListener(_ listener:DSUserStatusListener)  {
        listeners.add(listener)
    }
    func removeListener(_ listener:DSUserStatusListener) {
        listeners.remove(listener)
    }
    func applicationDidFinishLaunching() {
        
        login(userInfo: DSUserInfo(name: "152****2112"))
//        logout()
    }
}
extension DSUserCenter {
    func login(userInfo:DSUserInfo)  {
        self.userInfo = userInfo
        noticeListenter(selector: #selector(DSUserStatusListener.userLoginSuccess))
    }
    func logout() {
        userInfo = nil
        noticeListenter(selector: #selector(DSUserStatusListener.userLogoutSuccess))
    }
    func updateUserInfo()  {
        noticeListenter(selector: #selector(DSUserStatusListener.userInfoChanged))
    }
    fileprivate func noticeListenter(selector:Selector) {
        for listener in listeners.allObjects {
            if listener.responds(to: selector) {
                listener.perform(selector)
            }
        }
    }
}
