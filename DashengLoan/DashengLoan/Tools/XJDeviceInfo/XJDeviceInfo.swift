//
//  XJDeviceInfo.swift
//  jiazhifu
//
//  Created by liuxiangjing on 2018/10/19.
//  Copyright © 2018 liuxiangjing. All rights reserved.
//

import UIKit
struct WifiInfo {
    var ssid:String = ""
    var mac:String = ""
    
    
}
import SystemConfiguration.CaptiveNetwork
class XJDeviceInfo: NSObject {
    
    static var wifiInfo:WifiInfo {
        var wifiInof = WifiInfo()
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    wifiInof.ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String ?? ""
                    wifiInof.mac = interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String ?? ""
                    break
                }
            }
        }
        return wifiInof
    }
   
    static var deviceId: String {
        return XJUDID.xj_uuidForDeivce()
    }
    static var systemName:String {
        return UIDevice.current.systemName
    }
    static var systemVersion:String {
        return UIDevice.current.systemVersion
    }
    
    static var appVersion:String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    static var appBuildVersion:String {
      return  Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
    
    static var screenWidth:CGFloat {
        return UIScreen.main.bounds.width
    }
    static var screenHeight:CGFloat {
        return UIScreen.main.bounds.height
    }
    static var isPhoneXMore:Bool {
        var topHeight = 0
        if #available(iOS 11.0, *) {
            let safeAreaInset = UIApplication.shared.windows[0].safeAreaInsets
            switch UIApplication.shared.statusBarOrientation {
            case .portrait:
                topHeight = Int(safeAreaInset.top)
            case .portraitUpsideDown :
                topHeight = Int(safeAreaInset.bottom)
            case .landscapeLeft :
                topHeight = Int(safeAreaInset.left)
            case .landscapeRight :
                topHeight = Int(safeAreaInset.right)
            default :
                topHeight = 0
            }
        }
        if topHeight > 20 {
            return true
        }
        return false
    }
    
    static var tabBarHeight:CGFloat {
        if isPhoneXMore {
            return 83
        }else{
            return 49
        }
    }
    static var tabbarSpaceInX:CGFloat {
        if isPhoneXMore {
            return 34
        }
        return 0
        
    }
    
    static var naivgaitonBarHeight:CGFloat {
        return defaultBarHeight+statusBarHeight
    }
    static var statusBarHeight:CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    static var defaultBarHeight:CGFloat {
        return 44
    }
}
