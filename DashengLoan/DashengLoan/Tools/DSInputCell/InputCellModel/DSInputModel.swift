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
    
    // 服务器字段名字
    var servicename : String = ""
    
    
    var title:String?
    
    var placeholder:String?
    var content:String?
    var subContent:String?
    var validater:DSTextValidater?
    
    //用于DSRightButtonCell和DSSelectorRightButtonCell
    var rightTitle:String?
    var rightImage:String?
    
    //仅仅用于DSSelectorCell中，
    var alignment:NSNumber?
    
    // 用于DSMutableImageCell
    /// 照片信息
    var images:[DSImageInfo]?
    /// 多张上传的时候，最大上传数量
    var maxcount:NSNumber?
    var tipimage:String?
    var tips:String?
    
    
    
    convenience init(dic:[String:Any]) {
        self.init()
        setValuesForKeys(dic)
 
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {

    }
}
