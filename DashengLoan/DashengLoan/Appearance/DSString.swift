//
//  DSString.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/24.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
import CommonCrypto
enum DSPic:String {
    case idcardface = "idcard_information_pic"
    case idcardback = "idcard_national_pic"
    case education = "edu_pic"
    case scene = "scene_pic"
    case person = "person_pic"
    case contract = "train_contract_pic"
    case statement = "train_statement_pic"
    func url() -> String {
        return self.rawValue + "_url"
    }
}
extension String {
    func md5String() -> String {
        let cStr = self.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    
    /// 从时间区间获取时间：例如：从2017.09.04-2037.09.04中得到2017-09-04 和2037-09-04
    ///
    /// - Parameter dateStr: 2017.09.04-2037.09.04
    /// - Returns: (2017-09-04,2037-09-04)
    func getDate() -> (String?,String?) {
        let dataArray = self.components(separatedBy: "-")
        let begin = dataArray.first
        let end = dataArray.last
        
        let beginDate = begin?.replacingOccurrences(of: ".", with: "-")
        let endDate = end?.replacingOccurrences(of: ".", with: "-")
        
        return (beginDate,endDate)
    }
   
}
