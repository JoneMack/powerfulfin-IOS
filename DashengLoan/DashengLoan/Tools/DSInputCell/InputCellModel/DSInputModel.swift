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

class DSInputModel:NSObject {
    
    var inputType:DSInputTableViewCell.Type!
    
    var title:String?
    
    var placeholder:String?
    var content:String?
    var subContent:String?
    var validater:DSTextValidater?
    
    //仅用于DSRightButtonCell
    var rightTitle:String?
    
    //仅仅用于DSSelectorCell中，
    var alignment:Int?
        
    
    var images:[String]?
    
    convenience init(dic:[String:Any]) {
        self.init()
        self.title = dic["title"] as? String
        self.content = dic["content"] as? String
        self.placeholder = dic["placeholder"] as? String
        self.alignment = dic["alignment"] as? Int

        let cellType = dic["type"] as? Int
        if cellType == 1{
            inputType = DSSelectorCell.self
        }else if cellType == 2{
            inputType = DSIdImageCell.self
        }else if cellType == 4 {
            inputType = DSRightButtonCell.self
        }else if cellType == 5 {
            inputType = DSMutableImageCell.self
        }else{
            inputType = DSInputCell.self
        }
    }
}
