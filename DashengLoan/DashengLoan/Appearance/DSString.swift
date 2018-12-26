//
//  DSString.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/24.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
import CommonCrypto

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
   
}
