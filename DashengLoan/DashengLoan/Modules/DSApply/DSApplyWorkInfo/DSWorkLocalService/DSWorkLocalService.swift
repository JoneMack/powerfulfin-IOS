//
//  DSWorkLocalService.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSWorkLocalService: DSApplyLocalService {
    
    var workAddress = DSAddressLocalInfo()
    var schoolAddressInfo = DSAddressLocalInfo()
    var imagesArray = [DSImageInfo]()
    var maxCount = 1
    
    
    fileprivate var incumbentModels = [DSInputModel]()
    fileprivate var studentModels = [DSInputModel]()
    fileprivate var unemployedModels = [DSInputModel]()
    fileprivate(set) var cuttentIndex = 1
    override init() {
        super.init()
        cuttentIndex = 1
        models.insert(incumbentModels, at: 1)
        
        var placeHolderInfo = DSImageInfo()
        placeHolderInfo.type = defaultImageType
        addImageInfo(imageInfo: placeHolderInfo, atIndexPath: IndexPath(row: 0, section: 2))
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
    
    /// 切换tab
    ///
    /// - Parameter index: 0是在职 1 是学生 2 是待业
    func changeItem(index:Int)  {
        var monthInCome = ""
        
        if cuttentIndex == 2 {//当前是学生
            monthInCome = studentModels.last?.content ?? ""
        }else if cuttentIndex == 3 {//当前是待业
            monthInCome = unemployedModels.first?.content ?? ""
        }else{//当前是在职
            monthInCome = incumbentModels.last?.content ?? ""
        }
        
        if index == 1 {//选中的是学生
            studentModels.last?.content = monthInCome
            models[1] = studentModels
        }else if index == 2 {//待业
            unemployedModels.first?.content = monthInCome
            models[1] = unemployedModels
        }else{//在职
            incumbentModels.last?.content = monthInCome
            models[1] = incumbentModels
        }
        cuttentIndex = index + 1
    }
    func updateWordAddress()  {
        let wordAddress = incumbentModels[1]
        wordAddress.content = workAddress.address
    }
    override func reloadData(info: Any) {
        if let workInfo = info as? DSUserWork {
            let wordModel = models[0][0]
            let eduModel = models[0][1]
            let eduPicModel = models[2][0]
            
            wordModel.content = workInfo.profession
            eduModel.content = workInfo.highest_education
            eduPicModel.content = workInfo.edu_pic_url
            eduPicModel.subContent = workInfo.edu_pic
            
            var imageInfo = DSImageInfo()
            imageInfo.url = workInfo.edu_pic_url ?? ""
            imageInfo.path = workInfo.edu_pic ?? ""
            imageInfo.type = "edu_pic"
            replaceImageInfo(imageInfo: imageInfo, atIndex: 0, atIndexPath: IndexPath(row: 0, section: 2))
            
            if workInfo.working_status == "2" {
                changeItem(index: 1)
            }else if workInfo.working_status == "3"{
                changeItem(index: 2)
            }else{
                changeItem(index: 0)
            }
            let workName = incumbentModels[0]
            let wordAddress = incumbentModels[1]
            let workDetailAddress = incumbentModels[2]
            let workTime = incumbentModels[3]
            let workProfession = incumbentModels[4]
            let workPhone = incumbentModels[5]
            let workIncome = incumbentModels[6]
            workName.content = workInfo.work_name
            workAddress.province = workInfo.work_province ?? ""
            workAddress.city = workInfo.work_city ?? ""
            workAddress.area = workInfo.work_area ?? ""
            workAddress.address = (workInfo.work_province_name ?? "") + (workInfo.work_city_name ?? "") + (workInfo.work_area_name ?? "")
            wordAddress.content = workAddress.address
            workDetailAddress.content = workInfo.work_address
            workTime.content = workInfo.work_entry_time
            workProfession.content = workInfo.work_profession
            workPhone.content = workInfo.work_contact
            workIncome.content = workInfo.monthly_income
            
            
            let schoolName = studentModels[0]
            let schoolAddress = studentModels[1]
            let schoolDetailAddress = studentModels[2]
            let schoolPhone = studentModels[3]
            let schoolMajor = studentModels[4]
            let schoolSystem = studentModels[5]
            let schoolTime = studentModels[6]
            let schoolIncom = studentModels[7]
            schoolName.content = workInfo.school_name
            schoolAddressInfo.province = workInfo.school_province ?? ""
            schoolAddressInfo.city = workInfo.school_city ?? ""
            schoolAddressInfo.area = workInfo.school_area ?? ""
            schoolAddressInfo.address = (workInfo.school_province_name ?? "") + (workInfo.school_city_name ?? "") + (workInfo.school_area_name ?? "")
            schoolAddress.content = schoolAddressInfo.address
            schoolDetailAddress.content = workInfo.school_address
            schoolPhone.content = workInfo.school_contact
            schoolMajor.content = workInfo.school_major
            schoolSystem.content = workInfo.education_system
            schoolTime.content = workInfo.entrance_time
            schoolIncom.content = workInfo.monthly_income
            
            let trainIncom = unemployedModels[0]
            let trainPhone = unemployedModels[1]
            trainIncom.content = workInfo.monthly_income
            trainPhone.content = workInfo.train_contact
        }
    }
    override func getDataInfo() -> [String : String] {
        let wordModel = models[0][0]
        let eduModel = models[0][1]
        let eduPicModel = models[2][0]
        
        let workName = incumbentModels[0]
//        let wordAddress = incumbentModels[1]
        let workDetailAddress = incumbentModels[2]
        let workTime = incumbentModels[3]
        let workProfession = incumbentModels[4]
        let workPhone = incumbentModels[5]
        let workIncome = incumbentModels[6]
        
//        let schoolName = studentModels[0]
        let schoolAddress = studentModels[2]
        let schoolPhone = studentModels[3]
        let schoolMajor = studentModels[4]
        let schoolSystem = studentModels[5]
        let schoolTime = studentModels[6]
        let schoolIncom = studentModels[7]
        
        let trainIncom = unemployedModels[0]
        let trainPhone = unemployedModels[1]
        
        var income = workIncome.content ?? ""
        
        if cuttentIndex == 2 {
            income = schoolIncom.content ?? ""
        }else if cuttentIndex == 3 {
            income = trainIncom.content ?? ""
        }
        
        return ["highest_education":eduModel.content ?? "",
                "profession":wordModel.content ?? "",
                "working_status":cuttentIndex.description,
                "monthly_income":income,
                "edu_pic":eduPicModel.images?[0].path ?? "",
                "work_name":workName.content ?? "",
                "work_province":workAddress.province,
                "work_city":workAddress.city,
                "work_area":workAddress.area,
                "work_address":workDetailAddress.content ?? "",
                "work_entry_time":workTime.content ?? "",
                "work_profession":workProfession.content ?? "",
                "work_contact":workPhone.content ?? "",
                "school_name":workName.content ?? "",
                "school_province":schoolAddressInfo.province,
                "school_city":schoolAddressInfo.city,
                "school_area":schoolAddressInfo.area,
                "school_address":schoolAddress.content ?? "",
                "school_contact":schoolPhone.content ?? "",
                "school_major":schoolMajor.content ?? "",
                "education_system":schoolSystem.content ?? "",
                "entrance_time":schoolTime.content ?? "",
                "train_contact":trainPhone.content ?? ""
        ]
    }
    
}
