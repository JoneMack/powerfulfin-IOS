//
//  DSImageInfo.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/27.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

let defaultImageType = "1"

struct DSImageInfo: Codable {
    //app展示用
    var url:String?
    //服务器接口用
    var path:String?
    //名字  //本地默认上传按钮的type == defaultImageType
    var type:String?
}
struct DSUploaderImageInfo {
    var data:Data?
    var servicename:String?
    
    var imageInfo:DSImageInfo?
    
    var indexPath:IndexPath?
    var index:Int = -1
    var isReplace : Bool = false
    
}
