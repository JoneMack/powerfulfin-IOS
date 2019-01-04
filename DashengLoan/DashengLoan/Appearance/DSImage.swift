//
//  DSImage.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/3.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func ds_image(color:UIColor,size:CGSize = CGSize(width: 4, height: 4)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return theImage!;
    }
    
    class func ds_backgroundImage(_ size:CGSize) -> UIImage {
        return ds_gradientImage(size, colors: [UIColor(hex: "ec471b"),UIColor(hex: "ea3434")], direction: 1)
    }
    /// 生成一个渐变色的图片
    ///
    /// - Parameters:
    ///   - size: 图片大小
    ///   - colors: 颜色值们，初始值，中间值，结束值等
    ///   - direction: 方向：0 从上到下。 1：从左到右
    /// - Returns: 图片
    class func ds_gradientImage(_ size:CGSize, colors:[UIColor],direction:NSInteger) -> UIImage {
        
        var cgcolors = [CGColor]()
        for color in colors {
            cgcolors.append(color.cgColor)
        }
        UIGraphicsBeginImageContextWithOptions(size, true, 1)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: cgcolors as CFArray, locations: nil)
        
        let start = CGPoint(x: 0, y: 0)
        var end:CGPoint
        if direction == 0 {
            end = CGPoint(x: 0, y: size.height)
        }else{
            end = CGPoint(x: size.width, y: 0)
        }
        context?.drawLinearGradient(gradient!, start: start, end: end, options: [.drawsBeforeStartLocation,.drawsAfterEndLocation])
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return theImage!
        
    }
}
