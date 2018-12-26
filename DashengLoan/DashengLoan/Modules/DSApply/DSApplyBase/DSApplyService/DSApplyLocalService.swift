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
