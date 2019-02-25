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
   /// 设备唯一id
    static var deviceId: String {
        return XJUDID.xj_uuidForDeivce()
    }
    static var deviceName:String {
        return UIDevice.current.name
    }
    static var deviceModel:String{
        return UIDevice.current.model
    }
    static var deviceType:String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        
        let identifier = machineMirror.children.reduce("") { identifier,element in
            
            guard let value = element.value as? Int8, value != 0 else{ return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
            
        }
        return identifier
    }
    
    /// 系统的名字
    static var systemName:String {
        return UIDevice.current.systemName
    }
    /// 系统的版本号
    static var systemVersion:String {
        return UIDevice.current.systemVersion
    }
    /// App Bundle Identifier
    static var appBundleId:String {
      
        return Bundle.main.infoDictionary?[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
    }
    /// app版本号
    static var appVersion:String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    /// 0的测试包，1是AppStore，2是企业包
    static var channel:String {
        return Bundle.main.infoDictionary?["DSDownloadChannel"] as? String ?? "1"
    }
    /// app Build版本号
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
