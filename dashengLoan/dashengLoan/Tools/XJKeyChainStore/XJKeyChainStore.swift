//
//  XJKeyChainStore.swift
//  jiazhifu
//
//  Created by liuxiangjing on 2018/10/25.
//  Copyright © 2018 liuxiangjing. All rights reserved.
//

import UIKit
import Security

/// 钥匙串管理
struct XJKeyChainStore {

    static let shared = XJKeyChainStore()
    let service:String
    
    init(service:String = Bundle.main.bundleIdentifier ?? "") {
       self.service = service
    }
    
    fileprivate func quaryMutableDictionary() -> NSMutableDictionary {
        let quaryDic = NSMutableDictionary()
        // 设置条件存储的类型
        quaryDic.setObject(kSecClassGenericPassword, forKey: kSecClass as! NSCopying)
        
        quaryDic.setObject(self.service, forKey: kSecAttrService as! NSCopying)

        return quaryDic
    }
    
}
extension XJKeyChainStore {
    static func setObject(_ object: Any, forKey akey: String) {
        let queryDic = XJKeyChainStore.shared.quaryMutableDictionary()
        queryDic.setObject(akey, forKey: kSecAttrAccount as! NSCopying)
        
        var keyData:AnyObject? = nil
        var status = SecItemCopyMatching(queryDic, &keyData)
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        
        if status == errSecItemNotFound  {
            queryDic.setObject(data, forKey: kSecValueData as! NSCopying)
            status = SecItemAdd(queryDic, nil)
        }else if status == errSecSuccess {
            let aQurey = NSMutableDictionary()
            aQurey.setObject(data, forKey: kSecValueData as! NSCopying)
            status = SecItemUpdate(queryDic, aQurey)
        }
        print(status)
        
    }
    
    static func object(forKey aKey:String) -> AnyObject! {
        let queryDic = XJKeyChainStore.shared.quaryMutableDictionary()
        queryDic.setObject(aKey, forKey: kSecAttrAccount as! NSCopying)
        queryDic.setObject(kCFBooleanTrue, forKey: kSecReturnData as! NSCopying)
        queryDic.setObject(kSecMatchLimitOne, forKey: kSecMatchLimit as! NSCopying)
        
        
        var keyData:AnyObject?
        
        if SecItemCopyMatching(queryDic, &keyData) == noErr {
            if keyData != nil {
                let ret = NSKeyedUnarchiver.unarchiveObject(with: keyData as! Data)
                return ret as AnyObject
            }
        }
        return keyData
    }
    static func removeObject(forKey aKey:String){
        let queryDic = XJKeyChainStore.shared.quaryMutableDictionary()
        queryDic.setObject(aKey, forKey: kSecAttrAccount as! NSCopying)
        SecItemDelete(queryDic)
    }
}
