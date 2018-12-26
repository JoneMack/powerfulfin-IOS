//
//  DSSearchData.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/24.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

struct DSSearchData: Codable {
    var total:String?
    var page:String?
    var pagesize:String?
    var list:[DSOrgation]?
    
}
struct DSOrgation :Codable {
    var id:String?
    var name:String?
    var address:String?
}
