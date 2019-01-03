//
//  DSOrderLocalService.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSOrderLocalService: DSApplyLocalService {
    override func fileName() -> String {
        return "order"
    }
    // MARK: 获取订单信息
    func getOrderDataInfo() -> [String:Any] {
        var paramDic = [String:Any]()
        let courseModel = models[0][0]
        let moneyModel = models[0][1]
        let productModel = models[0][2]
    
        let secotonModels = models[1]
        for model in secotonModels {
            if model.title == "开课日期" {
                paramDic[model.servicename] = model.content ?? ""
            }
            if model.title == "场景照片" {
                let imageInfos = getImagesPath(from: model.images!)
                paramDic[model.servicename] = imageInfos
            }
            if model.title == "培训协议" {
                let imageInfos = getImagesPath(from: model.images!)
                paramDic[model.servicename] = imageInfos
            }
            if model.title == "手持身份证照片" {
                let imageInfos = getImagesPath(from: model.images!)
                paramDic[model.servicename] = imageInfos
            }
            if model.title == "声明照片" {
                let imageInfos = getImagesPath(from: model.images!)
                paramDic[model.servicename] = imageInfos
            }
        }
        paramDic[courseModel.servicename] = courseModel.subContent ?? ""
        paramDic[moneyModel.servicename] = moneyModel.content ?? ""
        paramDic[productModel.servicename] = productModel.subContent ?? ""
        return paramDic
    }
    func getImagesPath(from images:[DSImageInfo]) -> String {
        var imageInfos = [String]()
        for imageInfo in images {
            if imageInfo.type != defaultImageType {
                imageInfos.append(imageInfo.path ?? "")
            }
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: imageInfos, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {}
        return ""
    }
}
// MARK: - 配置更新
extension DSOrderLocalService {
    func updateOrderConfig(_ configer:DSUserOrderConfiger)  {
        updateCourseOpenDateModel(title: "开课日期", show: configer.course_open_time_switch, content: configer.courseOpenDefaultTime)
        updateImageModel(title: "场景照片", show: configer.school_pic_switch)
        updateImageModel(title: "培训协议", show: configer.train)
        updateImageModel(title: "手持身份证照片", show: configer.idcard_person_pic_switch)
        updateImageModel(title: "声明照片", show: configer.statement_pic)
        
    }
    // MARK: 更新图片是否展示，如果展示，则设置上默认值
   fileprivate func updateImageModel(title:String,show:Bool) {
        var secotonModels = models[1]
        for model in secotonModels {
            if model.title == title {
                if show {
                    var placeHolderInfo = DSImageInfo()
                    placeHolderInfo.type = defaultImageType
                    model.images = [placeHolderInfo]
                }else{
                    secotonModels.remove(model)
                    models[1] = secotonModels
                }
                break;
            }
        }
    }
    // MARK: 更新开课日期是否展示，如果展示，则设置上默认值
    fileprivate func updateCourseOpenDateModel(title:String,show:Bool,content:String?)  {
        var secotonModels = models[1]
        for model in secotonModels {
            if model.title == title {
                if show {
                    model.content = content
                }else{
                    secotonModels.remove(model)
                }
                break;
            }
        }
    }
}
