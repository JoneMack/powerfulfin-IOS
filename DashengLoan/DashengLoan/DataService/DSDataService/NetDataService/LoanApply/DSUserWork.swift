//
//  DSUserWork.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/28.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
struct DSUserWork:Codable {
    /// 最高学历
    var highest_education:String?
    /// 职业
    var profession:String?
    /// 工作状态
    var working_status:String?
    /// 月收入
    var monthly_income:String?
    /// 学历证明路径
    var edu_pic:String?
    /// 学历证明URL，具有时效性，仅用于展示图片
    var edu_pic_url:String?
    /// 单位名称
    var work_name:String?
    /// 单位所在省ID
    var work_province:String?
    /// 单位所在市ID
    var work_city:String?
    /// 单位所在区ID
    var work_area:String?
    /// 单位详细地址
    var work_address:String?
    /// 入职时间
    var work_entry_time:String?
    /// 级别
    var work_profession:String?
    /// 单位联系方式
    var work_contact:String?
    /// 学校名称
    var school_name:String?
    /// 学校所在省ID
    var school_province:String?
    /// 学校所在市ID
    var school_city:String?
    /// 学校所在区ID
    var school_area:String?
    /// 学校详细地址
    var school_address:String?
    /// 学校联系方式
    var school_contact:String?
    /// 专业
    var school_major:String?
    /// 学制5
    var education_system:String?
    /// 入学时间，
    var entrance_time:String?
    /// 培训机构联系方式
    var train_contact:String?
}
