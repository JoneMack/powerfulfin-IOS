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
    class var ds_tintColor:UIColor {
        return UIColor.red
    }
    
   open class func `init`(R:CGFloat,G:CGFloat,B:CGFloat,A:CGFloat = 1) -> UIColor {
        return UIColor(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: A)
    }
    
}
