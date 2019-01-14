//
//  DSFont.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/3.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit


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
