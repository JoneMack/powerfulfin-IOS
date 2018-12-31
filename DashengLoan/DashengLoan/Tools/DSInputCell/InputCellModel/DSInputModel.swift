//
//  DSInputModel.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/25.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
enum CellType : Int {
    case normal = 0 //DSInputCell
    case selector = 1 //DSSelectorCell
    case idImage = 2 //DSIdImageCell
    case rightBtn = 4 //DSRightButtonCell
    case mutableImage = 5 //DSMutableImageCell
}

@objcMembers
class DSInputModel:NSObject {
    var type:String = "DSInputCell"
    
    var title:String?
    
    var placeholder:String?
    var content:String?
    var subContent:String?
    var validater:DSTextValidater?
    
    //仅用于DSRightButtonCell
    var rightTitle:String?
    
    //仅仅用于DSSelectorCell中，
    var alignment:NSNumber?
        
    
    var images:[String]?
    
    convenience init(dic:[String:Any]) {
        self.init()
        setValuesForKeys(dic)
 
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {

    }
}
