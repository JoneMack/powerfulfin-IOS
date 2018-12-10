//
//  DSAppearance.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/7.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

extension UIFont {
    class func ds_fontWithSize(size: CGFloat) -> UIFont {
        
        return UIFont.systemFont(ofSize: size)
    }
    
}
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
        return UIColor.blue
    }
}
