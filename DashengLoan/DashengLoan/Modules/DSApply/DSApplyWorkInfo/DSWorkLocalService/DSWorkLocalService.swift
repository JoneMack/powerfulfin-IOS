//
//  DSWorkLocalService.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSWorkLocalService: DSApplyLocalService {
    fileprivate var incumbentModels = [DSInputModel]()
    fileprivate var studentModels = [DSInputModel]()
    fileprivate var unemployedModels = [DSInputModel]()
    fileprivate var cuttentIndex = 0
    override init() {
        super.init()
        cuttentIndex = 0
        models.insert(incumbentModels, at: 1)
    }
    override func fileName() -> String {
        return "degree"
    }
    override func loadLocalData() {
        super.loadLocalData()
        incumbentModels += loadSectionData(fileName: "incumbent")
        studentModels += loadSectionData(fileName: "student")
        unemployedModels += loadSectionData(fileName: "unemployed")
    }
    func changeItem(index:Int)  {
        var monthInCome = ""
        
        if cuttentIndex == 0 {
            monthInCome = incumbentModels.last?.content ?? ""
        }else if cuttentIndex == 1 {
            monthInCome = studentModels.last?.content ?? ""
        }else if cuttentIndex == 2 {
            monthInCome = unemployedModels.first?.content ?? ""
        }
        
        if index == 0 {
            incumbentModels.last?.content = monthInCome
            models[1] = incumbentModels
        }else if index == 1 {
            studentModels.last?.content = monthInCome
            models[1] = studentModels
        }else if index == 2 {
            unemployedModels.first?.content = monthInCome
            models[1] = unemployedModels
        }
        cuttentIndex = index
    }
    
}
