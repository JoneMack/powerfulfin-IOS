//
//  DSUserIdInfo.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

/// 用户身份证信息
struct DSUserIdInfo: Codable {
    
    var uid:String?
    
    /// 姓名
    var full_name:String?
    /// 身份证号
    var identity_number:String?
    /// 有效起始日期
    var start_date:String?
    /// 有效截止日期
    var end_date:String?
    /// 地址
    var address:String?
    /// 身份证人脸面，标记
    var idcard_information_pic:String?
    var idcard_information_pic_url:String?
    /// 身份证背面，标记
    var idcard_national_pic:String?
    var idcard_national_pic_url:String?
    /// 民族
    var nationality:String?
    /// 签证机关
    var issuing_authority:String?
    
    /// 实名状态：1：未认证or待认证，2：认证成功，3：认证失败
    var user_real:Int?
    
    
    var phone:String?
    

}
