
//
//  DSAuthFaceManager.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/25.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSAuthFaceManager:NSObject {
    let authEngine = UDIDSafeAuthEngine()
    var authFinish:((DSUserInfo) -> Void)?
    
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
    func idSafeAuthFinished(withResult result: Int, userInfo: Any!) {
        
    }
    func idSafeAuthFinished(with result: UDIDSafeAuthResult, userInfo: Any!) {
        
    }
}
