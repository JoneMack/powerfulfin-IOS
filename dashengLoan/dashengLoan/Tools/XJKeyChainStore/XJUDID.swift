//
//  XJUDID.swift
//  jiazhifu
//
//  Created by liuxiangjing on 2018/10/30.
//  Copyright © 2018 liuxiangjing. All rights reserved.
//

import UIKit
import CoreFoundation
class XJUDID: NSObject {
    static let shared = XJUDID()
    var uuidForDeivce:String?
    
    fileprivate func getUUIdForDeivce() -> String {
        if uuidForDeivce != nil {
            return uuidForDeivce!
        }
        let key = "xj.device.uuid"
        
        uuidForDeivce = XJKeyChainStore.object(forKey: key) as? String
        if uuidForDeivce != nil {
            return uuidForDeivce!
        }
        uuidForDeivce = XJUDID.getUUIDString()
        XJKeyChainStore.setObject(uuidForDeivce!, forKey: key)
        return uuidForDeivce!
    }
}
extension XJUDID {
    class func getUUIDString() -> String {
        let uuidRef = CFUUIDCreate(kCFAllocatorDefault)
        let strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef)
        var uuidString = (strRef! as String).replacingOccurrences(of: "-", with: "")
        uuidString = uuidString.lowercased()
        return uuidString
    }
    class func xj_uuidForDeivce() -> String {
        return XJUDID.shared.getUUIdForDeivce()
    }
    
}

