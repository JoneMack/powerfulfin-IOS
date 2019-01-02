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
    class func applicationDidFinishLaunching() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarTintColor = UIColor.ds_blackText
        
        DSBugly.startBugly()
    }
}

// MARK: - 字体类
extension UIFont {
    class func ds_font(ptSize: CGFloat) -> UIFont {
        let value = ds_adjustFontSize(ofSize: ptSize)
        return UIFont.systemFont(ofSize: value)
    }
    class func ds_boldFont(ptSize: CGFloat) -> UIFont {
        let value = ds_adjustFontSize(ofSize: ptSize)
        return UIFont.boldSystemFont(ofSize:value)
    }
    /// 适配下字体大小
    ///
    /// - Parameter ofSize: 设计图尺寸的字体大小
    /// - Returns: 当前屏幕应该显示的字体大小
    class func ds_adjustFontSize(ofSize:CGFloat) -> CGFloat {
            //当前设计图的尺寸是以 XS 设计的。即屏幕宽度为 375
        return ofSize * XJDeviceInfo.screenWidth/375;
    }
}
extension UIImage {
    
    class func ds_image(color:UIColor,size:CGSize = CGSize(width: 4, height: 4)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return theImage!;
    }
    
    class func ds_backgroundImage(_ size:CGSize) -> UIImage {
        return ds_gradientImage(size, colors: [UIColor(hex: "ec471b"),UIColor(hex: "ea3434")], direction: 1)
    }
    /// 生成一个渐变色的图片
    ///
    /// - Parameters:
    ///   - size: 图片大小
    ///   - colors: 颜色值们，初始值，中间值，结束值等
    ///   - direction: 方向：0 从上到下。 1：从左到右
    /// - Returns: 图片
    class func ds_gradientImage(_ size:CGSize, colors:[UIColor],direction:NSInteger) -> UIImage {
        
        var cgcolors = [CGColor]()
        for color in colors {
            cgcolors.append(color.cgColor)
        }
        UIGraphicsBeginImageContextWithOptions(size, true, 1)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: cgcolors as CFArray, locations: nil)
        
        let start = CGPoint(x: 0, y: 0)
        var end:CGPoint
        if direction == 0 {
            end = CGPoint(x: 0, y: size.height)
        }else{
            end = CGPoint(x: size.width, y: 0)
        }
        context?.drawLinearGradient(gradient!, start: start, end: end, options: [.drawsBeforeStartLocation,.drawsAfterEndLocation])
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return theImage!
        
    }
}
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
    
    /// 最浅色的字：RGB:204.204.204 hex cccccc
    class var ds_lineGrayColor:UIColor {
        return UIColor(hex: "cccccc")
    }
    class var ds_backgroundColor:UIColor {
        return UIColor(R: 239, G: 239, B: 239)
    }
    /// 按钮红色边框的颜色 RGB:210 57 40 hex D23928
    class var ds_redBorder:UIColor {
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
extension UIView {
    class func lineView() -> UIView {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.ds_lineGrayColor
        return lineView
    }
}
