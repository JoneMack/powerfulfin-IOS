//
//  DSSignLocalService.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/9.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSSignLocalService: DSApplyLocalService {
    override func fileName() -> String {
        return "sign"
    }
    override func getDataInfo() -> [String : String] {
        let nameModel = models[0][0]
        let phoneModel = models[0][1]
        let classModel = models[0][2]
        return ["name":nameModel.content ?? "",
                "phone":phoneModel.content ?? "",
                "class_name":classModel.content ?? "",
                "cid":classModel.subContent ?? ""]
    }
}
