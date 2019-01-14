//
//  DSCommonDataService.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/27.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSCommonDataService {
    /// 上传图片
    class func uploadImage(imageData:Data,name:String,complete:@escaping((DSImageInfo)->Void)) {
        let request = XJRequest("v1/pic/upload", method: .post)
        request.parameters = ["name":name,"data":imageData as Any]
        
        XJToast.showProgressToastAction(message: "正在上传")
        XJNetWork.uploadRequest(request, progressHandler: { (progress) in
            XJToast.setProgress(progress: progress)
        }, successHandler: { (jsonInfo) in
            XJToast.hiddenProgressToastAction()
            if let model = try? XJDecoder.xj_decode([DSImageInfo].self, from: jsonInfo) {
                complete(model.first!)
            }
        }) { (error) in
            XJToast.hiddenProgressToastAction()
            XJToast.showToastAction(message: "\(error.errorMsg)(\(error.code))")
        }
        
    }
}
