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
        if(urlString != nil){
            if let url = URL(string: urlString!) {
                self.af_setImage(withURL: url ,placeholderImage:placeholderImage)
            }
        }
    }
}
