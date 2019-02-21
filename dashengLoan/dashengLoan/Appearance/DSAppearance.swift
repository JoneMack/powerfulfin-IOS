//
//  DSAppearance.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/7.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

public enum DSAppType:Int {
    case dasheng = 0
    case qingmiao = 1
}
class DSAppearance {
    
    static let appearance = DSAppearance()
    // shifoushz
    var isAudit:Bool = false
    var appChannel:String = {
        let channel = XJDeviceInfo.channel
        return channel
    }()
    /// na yi ge app
    var appType:DSAppType = {
        let bundleId = XJDeviceInfo.appBundleId
        if bundleId == "com.powerfulfin.dasheng" {
            return .dasheng
        }else if bundleId == "com.young4up.qingmiao" {
            return .qingmiao
        }
        return .dasheng
    }()
    
    
    
    class func applicationDidFinishLaunching(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let webView = UIWebView()
        let ua = webView.stringByEvaluatingJavaScript(from: "navigator.userAgent") ?? ""
        UserDefaults.standard.setValue(ua, forKey: userAgentKey)
        UserDefaults.standard.synchronize()
        
        UMCAnalyticsManager.stratAnalytics()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarTintColor = UIColor.ds_blackText
        DSBugly.startBugly()
    }
    
    static var isFirstLaunch:Bool {
        let first = UserDefaults.standard.bool(forKey: "loan.first.launch")
        if first == false {
            UserDefaults.standard.set(true, forKey: "loan.first.launch")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
    
    
}



extension UIView {
    class func lineView() -> UIView {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.ds_lineGrayColor
        return lineView
    }
}
