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
    
    /// 在职
    fileprivate var incumbentModels = [DSInputModel]()
    /// 学生
    fileprivate var studentModels = [DSInputModel]()
    /// 待业
    fileprivate var unemployedModels = [DSInputModel]()
    /// 1是在职 2 是学生 3 是待业
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
    
    /// 切换tab 0是在职 1 是学生 2 是待业
    ///
    /// - Parameter index: 0是在职 1 是学生 2 是待业
    func changeItem(index:Int)  {
        var monthInCome = ""
        
        if cuttentIndex == 2 {//当前是学生
            monthInCome = studentModels.last?.content ?? "2000"
        }else if cuttentIndex == 3 {//当前是待业
            monthInCome = unemployedModels.first?.content ?? "2000"
        }else{//当前是在职
            monthInCome = incumbentModels.last?.content ?? "2000"
        }
        if monthInCome.hasSuffix(".00") {
            let count = monthInCome.count - 1
            monthInCome = monthInCome[0...count-2]
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
    
    func updateSchoolAddress()  {
        let wordAddress = studentModels[1]
        wordAddress.content = schoolAddressInfo.address
    }
   // MARK: - 刷新数据
    override func reloadData(info: Any) {
        if let workInfo = info as? DSUserWork {
            let eduModel = models[0][0]
            let workModel = models[0][1]
            let eduPicModel = models[2][0]
            
            workModel.content = workInfo.profession
            eduModel.content = workInfo.highest_education
            eduPicModel.content = workInfo.edu_pic_url
            eduPicModel.subContent = workInfo.edu_pic
            
            var imageInfo = DSImageInfo()
            imageInfo.type = eduModel.servicename
            imageInfo.url =  workInfo.edu_pic_url
            imageInfo.path = workInfo.edu_pic
            addImageInfo(imageInfo: imageInfo, atIndexPath: IndexPath(row: 0, section: 2))
            
             var monthInCome = workInfo.monthly_income ?? "2000"
            if monthInCome.hasSuffix(".00") {
                let count = monthInCome.count - 4
                monthInCome = monthInCome[0...count]
            }
            
      
            
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
            workIncome.content = monthInCome
            
            
            let schoolName = studentModels[0]
            let schoolAddress = studentModels[1]
            let schoolDetailAddress = studentModels[2]
            let schoolPhone = studentModels[3]
            let schoolMajor = studentModels[4]
            let schoolTime = studentModels[5]
            let schoolSystem = studentModels[6]
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
            if workInfo.entrance_time?.hasSuffix("年") == false {
                schoolTime.content = "\(workInfo.entrance_time ?? "")年"
            }else{
                schoolTime.content = workInfo.entrance_time
            }
            schoolIncom.content = monthInCome
            
            let trainIncom = unemployedModels[0]
            let trainPhone = unemployedModels[1]
            trainIncom.content = monthInCome
            trainPhone.content = workInfo.train_contact
        }
    }
    
    // MARK: - 获取要上传的参数
    override func checkUploadParameters(_ showTips: Bool) -> DSApplyParamtersChecker {
        var checker = DSApplyParamtersChecker()
        
        let eduModel = models[0][0]
        checker = checkeModelContentParamters(model: eduModel, show: showTips, checker: checker)
        if checker.canUpload == false {
            return checker
        }
        
        let professionModel = models[0][1]
        checker = checkeModelContentParamters(model: professionModel, show: showTips, checker: checker)
        if checker.canUpload == false {
            return checker
        }
        
        checker.paramters["working_status"] = cuttentIndex.description
        if cuttentIndex == 1 {
            let workName = incumbentModels[0]
            checker = checkeModelContentParamters(model: workName, show: showTips, checker: checker)
            if checker.canUpload == false {
                return checker
            }
            if workAddress.province.isEmpty == true {
                let workAddress = incumbentModels[1]
                if showTips {
                    XJToast.showToastAction(message: workAddress.placeholder!)
                }
                checker.canUpload = false
                return checker
            }else{
                checker.paramters["work_province"] = workAddress.province
                checker.paramters["work_city"] = workAddress.city
                checker.paramters["work_area"] = workAddress.area
            }
            let count = incumbentModels.count - 1
            for index in 2...count {
                let model = incumbentModels[index]
                checker = checkeModelContentParamters(model: model, show: showTips, checker: checker)
                if checker.canUpload == false {
                    return checker
                }
            }
            
        }else if cuttentIndex == 2 {
            let schoolName = studentModels[0]
            checker = checkeModelContentParamters(model: schoolName, show: showTips, checker: checker)
            if checker.canUpload == false {
                return checker
            }
            if schoolAddressInfo.province.isEmpty == true {
                let schoolAddress = studentModels[1]
                if showTips {
                    XJToast.showToastAction(message: schoolAddress.placeholder!)
                }
                checker.canUpload = false
                return checker
            }else{
                checker.paramters["school_province"] = schoolAddressInfo.province
                checker.paramters["school_city"] = schoolAddressInfo.city
                checker.paramters["school_area"] = schoolAddressInfo.area
            }
            
            let count = studentModels.count - 1
            for index in 2...count {
                let model = studentModels[index]
                checker = checkeModelContentParamters(model: model, show: showTips, checker: checker)
                if checker.canUpload == false {
                    return checker
                }
            }
            let yearModel = studentModels[5]
            var yeas = yearModel.content ?? ""
            if yeas.hasSuffix("年") == true {
                yeas = yeas.replacingOccurrences(of: "年", with: "")
            }
            checker.paramters[yearModel.servicename] = yeas
            
            
        }else if cuttentIndex == 3 {
            let count = unemployedModels.count - 1
            for index in 0...count {
                let model = unemployedModels[index]
                checker = checkeModelContentParamters(model: model, show: showTips, checker: checker)
                if checker.canUpload == false {
                    return checker
                }
            }
        }
        
        let edupicModel = models[2][0]
        let images = edupicModel.images?.first
        if images?.type == defaultImageType {
            checker.canUpload = false
            if showTips {
                XJToast.showToastAction(message: edupicModel.placeholder!)
            }
            return checker
        }
        edupicModel.subContent = images?.path
        checker.paramters[edupicModel.servicename] = images?.path
        
        return checker
    }
}
