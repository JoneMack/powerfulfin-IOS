//
//  DSUserDataSource.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/23.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

struct DSUserCellModel {
    var text:String
    var logo:String
    var action:Selector
    
}
class DSUserDataSource: NSObject {
    fileprivate var dataArray:[[DSUserCellModel]]?
    override init() {
        super.init()

        let userinfo = DSUserCellModel(text: "个人资料", logo: "user_icon_info", action: Selector(("showUserInfoViewController")))
        
        let bankModel = DSUserCellModel(text: "银行卡管理", logo: "user_icon_bank", action: Selector(("showBankCardsViewController")))
        let passModel = DSUserCellModel(text: "修改密码", logo: "user_icon_password", action: Selector(("showPasswordViewController")))
        let messageModel = DSUserCellModel(text: "系统消息", logo: "user_icon_msg", action: Selector(("showMessageViewController")))
        let serModel = DSUserCellModel(text: "常见问题", logo: "user_icon_service", action: Selector(("showSericeViewController")))
        let aboutModel = DSUserCellModel(text: "关于", logo: "user_icon_about", action: Selector(("showAboutViewController")))
        let logoutModel = DSUserCellModel(text: "退出登录", logo: "", action: Selector(("logoutAction")))
        
        let section1 = [userinfo,bankModel]
        let section2 = [passModel,messageModel,serModel,aboutModel]
        let section3 = [logoutModel]
        dataArray = [section1,section2,section3]
        
    }
    func numberOfSections() -> Int {
        if DSUserCenter.defalut.userInfo == nil {
            return (dataArray?.count ?? 1) - 1
        }
        return dataArray?.count ?? 1
    }
    func numberOfRows(_ section:Int) -> Int {
        return (dataArray?[section])?.count ?? 0
    }
    func cellModel(_ indexPath:IndexPath) -> DSUserCellModel? {
        return dataArray?[indexPath.section][indexPath.row]
    }
}
