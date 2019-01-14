//
//  DSImageView.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/23.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImageView {
    func setImage(_ urlString:String?,placeholderImage:UIImage? = nil)  {
        
        if var urlStr = urlString {
            if urlStr.hasPrefix("http") == false && urlStr.hasPrefix("/")  {
                urlStr = baseHost + urlStr
            }
            if let url = URL(string: urlStr) {
                self.af_setImage(withURL: url ,placeholderImage:placeholderImage)
            }
        }
    }
}
