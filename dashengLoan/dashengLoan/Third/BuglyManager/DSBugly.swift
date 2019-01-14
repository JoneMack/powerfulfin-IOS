//
//  DSBugly.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/21.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
import Bugly
class DSBugly: NSObject {
    class func startBugly() {
        let config = BuglyConfig()
        config.blockMonitorEnable = true
        config.reportLogLevel = .warn
        Bugly.start(withAppId: "d601f14874", config: config)
    }
    class func login(_ userId:String) {
        Bugly.setUserIdentifier(userId)
    }
}
