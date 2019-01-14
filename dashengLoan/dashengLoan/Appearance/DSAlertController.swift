//
//  DSAlertController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/24.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSAlert {

    class func  showAlert(title:String?,message:String?,sureTitle:String?,cancel:Bool=false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if sureTitle != nil {
            alert.addAction(UIAlertAction(title: sureTitle, style: .default, handler: nil))
        }
        if cancel {
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        }
        UIApplication.shared.present(controller: alert)
    }

}
