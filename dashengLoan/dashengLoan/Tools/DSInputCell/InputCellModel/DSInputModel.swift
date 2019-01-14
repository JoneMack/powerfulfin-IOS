//
//  DSInputModel.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/25.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

/*
 //DSInputCell、DSSelectorCell、DSIdImageCell、DSRightButtonCell、DSMutableImageCell
 */
@objcMembers
class DSInputModel:NSObject {
    var type:String = "DSInputCell"
    
    // 服务器字段名字
    fileprivate(set) var servicename : String = ""
    
    
    fileprivate(set) var title:String?
    
    
    fileprivate(set) var placeholder:String?
    open var content:String?
    open var subContent:String?
    
    fileprivate(set) var keyboardType:UIKeyboardType = .default
    
    fileprivate(set) var validater:DSTextValidater = DSNoramlValidater()
    
    
    //用于DSRightButtonCell和DSSelectorRightButtonCell
    open var rightTitle:String?
    open var rightImage:String?
    
    //仅仅用于DSSelectorCell中，
    fileprivate(set) var alignment:NSNumber?
    
    // 用于DSMutableImageCell
    /// 照片信息
    var images:[DSImageInfo]?
    /// 多张上传的时候，最大上传数量
    fileprivate(set) var maxcount:NSNumber?
    fileprivate(set) var tipimage:String?
    fileprivate(set) var tips:String?
    
    
    
    convenience init(dic:[String:Any]) {
        self.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "textValidater" {
            if let num = value as? NSNumber {
                if num.intValue == 1 {
                    validater = DSNoramlValidater()
                }else if num.intValue == 2 {
                    validater = DSIdValidater()
                }else if num.intValue == 3 {
                    validater = DSPhoneValidater()
                }else if num.intValue == 4 {
                    validater = DSBankCodeValidater()
                }
            }
            
        }else if key == "keyboard" {
            if let num = value as? NSNumber {
                keyboardType = UIKeyboardType(rawValue: num.intValue) ?? .default
            }
        }
    }
}
