//
//  XJImageCompress.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/27.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit


extension UIImage {
    
    /// 自动压缩尺寸
    ///
    /// - Returns: Image
    func compressImageSize() -> UIImage {
        let ratio :CGFloat = size.width/size.height
        var targetW :CGFloat = 1280
        var targetH :CGFloat = 1280
        if size.width < targetW && size.height < targetH {
            return self
        }
        else if size.height > targetH && size.width > targetW {
            if ratio > 1 {
                targetH = 1280
                targetW = targetH * ratio
            }else{
                targetW = 1280
                targetH = targetW/ratio
            }
        }else{
            if ratio > 2 {
                targetW = size.height
                targetH = size.width
            }else if ratio < 0.5 {
                targetW = size.height
                targetH = size.width
            }else if ratio > 1 {
                targetW = 1280
                targetH = targetW/ratio
            }else{
                targetH = 1280
                targetW = targetH * ratio
            }
        }
        
        return compressImageTo(CGSize(width: targetW, height: targetW))
        
    }
    /// 压缩图片
    ///
    /// - Parameter targetSize: 目标大小
    /// - Returns: UIImage
    func compressImageTo(_ targetSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContext(targetSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: targetSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage!
    }
    func compressImageQuality(_ quality:CGFloat) -> UIImage {
        let newImge = compressImageSize()
        let imageData = newImge.jpegData(compressionQuality: quality)
        return UIImage(data: imageData!)!
    }
}
