//
//  DSColor.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/3.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit


// MARK: - UIColor类
extension UIColor {
    
    /// 16进制转颜色
    /// - Parameter hex: 不需要带#
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    convenience init(R:CGFloat,G:CGFloat,B:CGFloat,A:CGFloat = 1) {
        self.init(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: A)
    }
}

// MARK: - App 主题色
extension UIColor {
    
    class var ds_tintColor:UIColor {
        if DSAppearance.appearance.appType == .qingmiao {
            return UIColor(hex: "56c24f")
        }
        return UIColor(hex: "ea4934")
    }
    
    /// 黑色字 RGB:51.51.51  hex:333333
    class var ds_blackText:UIColor {
        return UIColor(hex: "333333")
    }
    
    /// 比黑色字浅一号 RGB:102.102.102 hex 666666
    class var ds_darkText:UIColor {
        return UIColor(hex: "666666")
    }
    
    /// 灰色字 RGB:153.153.153.153 hex 999999
    class var ds_grayColor:UIColor {
        return UIColor(hex: "999999")
    }
    
    /// 浅灰色 RGB:195.195.195 hex c3c3c3
    class var ds_lightGrayText: UIColor {
        return UIColor(hex: "c3c3c3")
    }
    /// 浅灰色 hex 8f8f8f
    class var ds_gray8fText:UIColor {
        return UIColor(hex: "8f8f8f")
    }
    
    /// 最浅色的字：RGB:204.204.204 hex cccccc
    class var ds_lineGrayColor:UIColor {
        return UIColor(hex: "cccccc")
    }
    class var ds_backgroundColor:UIColor {
        return UIColor(R: 239, G: 239, B: 239)
    }
    /// 按钮红色边框的颜色 RGB:210 57 40 hex D23928
    class var ds_redBorder:UIColor {
        if DSAppearance.appearance.appType == .qingmiao {
            return UIColor(hex: "56c24f")
        }
        return UIColor(hex: "d23928")
    }
    
    /// 按钮灰色边框的颜色 RGB:171.171.171 hex ababab
    class var ds_garyBorder:UIColor {
        return UIColor(hex: "ababab")
    }
    /// 按钮红色字颜色 RGB:234.73.52 hex:ea4934
    class var ds_redText:UIColor {
        return UIColor(hex: "ea4934")
    }
    /// 浅黄色背景色
    class var ds_lightOrangeBack:UIColor {
        return UIColor(R: 255, G: 248, B: 216)
    }
    class var ds_orangeText:UIColor {
        return UIColor(R: 255, G: 111, B: 0)
    }
    class var ds_blueText:UIColor {
        return UIColor(hex: "5a91e1")
    }
    
    
}
