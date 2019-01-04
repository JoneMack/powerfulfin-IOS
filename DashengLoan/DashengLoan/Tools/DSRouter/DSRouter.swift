
//
//  DSRouter.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/24.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
private let appHost = "powerfulfin"

/// 动作或者类型
enum DSAction:String {
    //无动作
    case none = ""
    //网页
    case web = "http"
    /// 进入消息列表
    case messageList = "msglist"
    /// 进入申请步骤
    case apply = "apply"
    /// 进入分期详情
    case loandetail = "loandetail"
    /// 进入分期确认页面
    case loanconfirm = "loanconfirm"
    /// 进入分期计划表
    case repaylist = "repaylist"
    /// 支付页
    case repay = "repay"
}
class DSRouter {
    class func openURL(url:String?,complete:((Any)->Void)? = nil) {
        let urlInfo = parsingURL(url: url)
        
        if urlInfo.0 == .none {
            return
        }
        switch urlInfo.0 {
        case .web :
            let webView = DSWebViewController()
            webView.urlString = url!
            UIApplication.shared.push(controller: webView)
        case .loandetail :
            if DSUserCenter.`default`.hasLogin == false {
                DSRouter.loginWithController {
                    DSRouter.openURL(url: url)
                }
                return
            }
            let orderDetailVC = DSOrderDetailViewController()
            orderDetailVC.orderId = (urlInfo.1)?["id"]
            UIApplication.shared.push(controller: orderDetailVC)
        case .messageList:
            let messageVC = DSMessageViewController()
            UIApplication.shared.push(controller: messageVC)
        case .apply:
            
            if let id = urlInfo.1!["id"] {
                DSApply.default.beginApply(id, fromController: UIApplication.shared.topViewController!)
            }
        default: break
        }
    }
    class func parsingURL(url:String?) -> (DSAction,[String:String]?) {
        if let urlStr = url {
            if urlStr.hasPrefix(DSAction.web.rawValue){
                return (.web,nil)
            }
            if urlStr.hasPrefix(appHost) {
                
                var actions = parsingURLContentAction(url: urlStr, action: .messageList)
                if actions.0 != .none { return actions}
                
                actions = parsingURLContentAction(url: urlStr, action: .apply)
                if actions.0 != .none { return actions}
                
                actions = parsingURLContentAction(url: urlStr, action: .loandetail)
                if actions.0 != .none { return actions}
                
                actions = parsingURLContentAction(url: urlStr, action: .loanconfirm)
                if actions.0 != .none { return actions}
                
                actions = parsingURLContentAction(url: urlStr, action: .repaylist)
                if actions.0 != .none { return actions}
                
                actions = parsingURLContentAction(url: urlStr, action: .repay)
                if actions.0 != .none { return actions}
               
            }
            
        }
        return (.none,nil)
    }
    class func parsingURLContentAction(url:String,action:DSAction)-> (DSAction,[String:String]?) {
        if url.contains(action.rawValue) {
            var parameterDic :[String:String]?
            if let parameterSrt = url.components(separatedBy: "?").last {
               let parametersArray = parameterSrt.components(separatedBy: "&")
                parameterDic = [String:String]()
                for parameter in parametersArray {
                   let tempArray = parameter.components(separatedBy: "=")
                    if let key = tempArray.first,let value = tempArray.last {
                        parameterDic?[key] = value
                    }
                }
            }
            return (action,parameterDic)
        }
        return (.none,nil)
    }
    
   class func loginWithController(comolete:(()->Void)?) {
        let loginVC = DSLoginViewController()
        let navi = DSNavigationController.init(rootViewController: loginVC)
        UIApplication.shared.present(controller: navi)
        loginVC.loginSuccess = {
            comolete?()
        }
    }
}
