//
//  DSAppearance.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/7.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
class DSAppearance {
    static let appearance = DSAppearance()
    // shifoushz
    var isAudit:Bool = false
    
    
    class func applicationDidFinishLaunching() {
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
