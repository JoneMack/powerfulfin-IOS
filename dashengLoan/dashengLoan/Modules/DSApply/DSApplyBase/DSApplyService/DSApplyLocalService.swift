//
//  DSApplyLocalService.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSApplyLocalService: NSObject {
    var models = [[DSInputModel]]()
    override init() {
        super.init()
        loadLocalData()
    }
    func fileName() -> String {
        return ""
    }
    func loadLocalData() {
        if let filePath = Bundle.main.path(forResource: fileName(), ofType: "plist")  {
            models.removeAll()
            let dataArray = NSArray(contentsOfFile: filePath)
            for index in 0..<(dataArray?.count ?? 0) {
                let sections = dataArray?[index]
                if let sections = sections as? [[String:Any]] {
                   loadSections(sections: sections)
                }else if (sections as? [String:Any]) != nil {
                    loadSections(sections: dataArray as! [[String : Any]])
                    break
                }
            }
        }
    }
    
    /// 从plist文件中读取单个Section类型的数据
    ///
    /// - Parameter fileName: 文件名字
    /// - Returns: 一维数组
    func loadSectionData(fileName:String) -> [DSInputModel] {
        var sections = [DSInputModel]()
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "plist")  {
            let dataArray = NSArray(contentsOfFile: filePath)
            for index in 0..<(dataArray?.count ?? 0) {
                if let rowInfo = dataArray?[index] as? [String:Any] {
                    let model = DSInputModel(dic: rowInfo)
                    sections.append(model)
                }
            }
        }
        return sections
    }
    fileprivate func loadSections(sections:[[String:Any]]) {
        if sections.count == 0 {
            return
        }
        var sectionModel = [DSInputModel]()
        for row in 0..<sections.count  {
            let dic = sections[row]
            let model = DSInputModel(dic: dic)
            sectionModel.append(model)
        }
        models.append(sectionModel)
    }
    
    func reloadData(info:Any)  {
        
    }
    func getDataInfo() -> [String:String] {
        return [:]
    }
    func checkUploadParameters(_ showTips:Bool = false) -> DSApplyParamtersChecker {
        return DSApplyParamtersChecker()
    }
}
extension DSApplyLocalService {
    func numberOfSections() -> Int {
        return models.count
    }
    func numberOfRow(section:Int) -> Int {
        return models[section].count
    }
    func cellMode(indexPath:IndexPath) -> DSInputModel {
        return models[indexPath.section][indexPath.row]
    }
    func isLastRow(_ indexPath:IndexPath) -> Bool {
        if  indexPath.row == (numberOfRow(section: indexPath.section)-1) {
            return true
        }
        return false
    }
}

// MARK: - 多图相关的
extension DSApplyLocalService {
    
    func replaceImageInfo(imageInfo:DSImageInfo, atIndex index:Int,atIndexPath indexPath:IndexPath) {
        let model = models[indexPath.section][indexPath.row]
        model.images?[index] = imageInfo
    }
    func addImageInfo(imageInfo:DSImageInfo,atIndexPath indexPath:IndexPath)  {
        let model = models[indexPath.section][indexPath.row]
        let count = model.maxcount?.intValue ?? 9
        if model.images == nil {
            var placeHolderInfo = DSImageInfo()
            placeHolderInfo.type = defaultImageType
            model.images = [placeHolderInfo]
        }
        if model.images?.count == count {
            model.images?[0] = imageInfo
        }else{
            model.images?.append(imageInfo)
        }
    }
    func removeImageInfo(indexPath:IndexPath,atIndex index:Int) {
        let model = models[indexPath.section][indexPath.row]
        model.images?.remove(at: index)
    }
    
    func heightOfMutableImageRow(atIndexPath indexPath:IndexPath) -> CGFloat {
        var rowHeight:CGFloat = 87
        
        let model = models[indexPath.section][indexPath.row]
        let count = model.images?.count ?? 1
        let rightSpace :CGFloat = 15
        let space :CGFloat = 10
        
        var imageRowCount = count/3
        if count%3 > 0 {
            imageRowCount += 1
        }
        let labelWidth = XJDeviceInfo.screenWidth - 2*rightSpace
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: labelWidth, height: 50))
        label.font = UIFont.ds_font(ptSize: 14)
        label.numberOfLines = 0
        label.text = model.tips
        label.sizeToFit()
        let lebelHeight:CGFloat = label.frame.height
        
        let oneRowHeight = (XJDeviceInfo.screenWidth -  rightSpace*2 - inputCellTitleWidth - space*3)/3
        
        rowHeight = (space + oneRowHeight) * CGFloat(imageRowCount) + space*2 + lebelHeight
        
        return rowHeight
    }
    
}
extension DSApplyLocalService {
     func checkeModelContentParamters(model:DSInputModel,show:Bool,checker:DSApplyParamtersChecker) -> DSApplyParamtersChecker {
        var oldChecker = checker
        if model.content == nil || model.content?.isEmpty == true {
            if show == true {
                XJToast.showToastAction(message: model.placeholder!)
            }
            oldChecker.canUpload = false
        }else{
            oldChecker.canUpload = true
            oldChecker.paramters[model.servicename] = model.content
        }
        return oldChecker
    }
    
     func checkeModelSubContentParamters(model:DSInputModel,show:Bool,checker:DSApplyParamtersChecker) -> DSApplyParamtersChecker {
        var oldChecker = checker
        if model.subContent == nil || model.subContent?.isEmpty == true {
            if show == true {
                XJToast.showToastAction(message: model.placeholder!)
            }
            oldChecker.canUpload = false
        }else{
            oldChecker.canUpload = true
            oldChecker.paramters[model.servicename] = model.subContent
        }
        return oldChecker
    }
    
     func checkeModelImageParamters(model:DSInputModel,show:Bool,checker:DSApplyParamtersChecker) -> DSApplyParamtersChecker {
        var oldChecker = checker
        
        let images = model.images!
        var imageInfos = [String]()
        for imageInfo in images {
            if imageInfo.type != defaultImageType {
                imageInfos.append(imageInfo.path ?? "")
            }
        }
        
        if imageInfos.count == 0 {
            if show == true {
                XJToast.showToastAction(message: model.placeholder!)
            }
            oldChecker.canUpload = false
        }else{
            oldChecker.canUpload = true
            let jsonImage = getImagesJsonArray(from: imageInfos)
            oldChecker.paramters[model.servicename] = jsonImage
        }
        return oldChecker
    }
    fileprivate func getImagesJsonArray(from images:[String]) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: images, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {}
        return ""
    }
}

struct DSApplyParamtersChecker {
    var canUpload = false
    var paramters = [String:Any]()
    
}
