//
//  UMCAnalyticsManager.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/23.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit
fileprivate let umAppKey = "5c47d6f1b465f570d300048b"

class UMCAnalyticsManager: NSObject {
    static func stratAnalytics(){
        UMConfigure.setEncryptEnabled(true)
        UMConfigure.setLogEnabled(false)
        UMConfigure.initWithAppkey(umAppKey, channel: DSAppearance.appearance.appChannel)
        
    }
}
