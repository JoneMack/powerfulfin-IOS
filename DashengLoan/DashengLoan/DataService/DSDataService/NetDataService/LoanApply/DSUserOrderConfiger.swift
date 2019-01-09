//
//  DSUserOrderConfiger.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/2.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSUserOrderConfiger: Codable {
    /// 分期的产品们
    var loanProducts:[DSLoanProductInfo]?
    /// 课程们
    var course:[DSCourseInfo]?
    /// 是否需要开课时间
    var course_open_time_switch:Bool = true
    
    /// 默认开课时间
    var courseOpenDefaultTime:String?
    /// 是否需要声明照片
    var statement_pic:Bool = true
    /// 是否上传培训协议
    var train:Bool = true
    /// 是否上传手持身份证照片
    var idcard_person_pic_switch:Bool = true
    /// 是否上传场景照片
    var school_pic_switch:Bool = true
    
    var org:DSApplyOrgationInfo?
    
}

struct DSLoanProductInfo:Codable {
    /// 金融产品名称，需在提交申请是上报
    var loan_product:String?
    /// 金融产品名称
    var name:String?
    /// 金融产品描述
    var desp:String?
    /// 金融产品类型，1=》弹性，2=》贴息，3=》等额
    var loan_type:Int?
    /// x期期数
    var rate_time_x:Int?
    /// x期费率
    var rate_x:String?
    /// y期期数
    var rate_time_y:Int?
    /// y期费率
    var rate_y:String?
    /// 资方名字
    var resource_company:String?
    /// 资方id
    var resource:Int?
}
struct DSCourseInfo:Codable {
    var cid:Int?
    var class_name:String?
    var money_apply_max:Int?
    var money_apply_min:Int?
}
struct DSApplyOrgationInfo:Codable {
    
    var oid:Int?
    var org_name:String?
}
