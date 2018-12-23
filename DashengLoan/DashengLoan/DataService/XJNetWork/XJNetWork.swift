//
//  XJNetWork.swift
//  SwiftDemo
//
//  Created by liuxiangjing on 2018/12/3.
//  Copyright © 2018 zhijian. All rights reserved.
//

import UIKit
import Alamofire

public enum XJHTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

// MARK: - 网络请求
class XJRequest {
    var url :String = ""
    var method:XJHTTPMethod = .get
    var parameters:[String:Any] = [:]
    var httpHeader:[String:String]?
    var timeoutInterval: TimeInterval = 10
    
    init(_ url:String,method:XJHTTPMethod = .get,parameters:[String:Any]? = nil,httpHeader:[String:String]?=nil) {
        self.url = DSNetConfiger.requestURL(absoluteURL: url)
        self.method = method
        guard let parameter = parameters else {  return }
        self.parameters = parameter
        
        guard let header = httpHeader else {  return }
        self.httpHeader = header
    }
}


class XJNetWork {
    class func request(_ method:XJHTTPMethod = .get,URL:String, parameters:[String:String] ,successHandler:@escaping((Any) ->Void),failHandler:@escaping((XJError)->Void)) {
        
        Alamofire.request(URL, method: HTTPMethod(rawValue: method.rawValue)!, parameters: parameters).responseJSON { (response) in
            handlerResult(response: response, successHandler: successHandler, failHandler: failHandler)
        }
    }
    class func request(_ requst:XJRequest,successHandler:@escaping((Any) ->Void),failHandler:@escaping((XJError)->Void)) {
        
        Alamofire.request(requst.url, method:HTTPMethod(rawValue: requst.method.rawValue)!, parameters: requst.parameters, headers: requst.httpHeader).responseJSON { (response) in
            handlerResult(response: response, successHandler: successHandler, failHandler: failHandler)
        }
    }
    fileprivate class func handlerResult(response:DataResponse<Any>,successHandler:@escaping((Any) ->Void),failHandler:@escaping((XJError)->Void)) {
        
        response.result.ifSuccess {
            let resultDic = response.result.value as? Dictionary<String, Any>
            let code  = resultDic?["code"] as! NSInteger
            let msg = resultDic?["msg"] as! String
            
            if code == 0 {
                let data = resultDic?["data"] as Any
                successHandler(data)
            }else{
                failHandler(XJError(code: code, errorMsg: msg))
            }
            }.ifFailure {
                failHandler(XJError(code: -1, errorMsg: response.error?.localizedDescription ?? "") )
                
        }
    }
}

// MARK: - 数据映射 Json->Model
class XJDecoder {
    class func xj_decode<T:Decodable>(_ someClass: T.Type, from jsonDic: Any) throws -> T {
        do {
            let jsonDecoder = JSONDecoder()
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDic, options: [])
            let obj = try jsonDecoder.decode(someClass, from: jsonData)
            return obj
        } catch {
            throw XJError(code: -2, errorMsg: "数据映射失败")
        }
    }
}
// MARK: - 请求示例
extension XJNetWork {
    func login(name:String,password:String, successHandler: @escaping(_ userInfo:UserInfo?) -> (),failHandler: @escaping(_ error : Error) -> ()) {
        let request = XJRequest("", method: .get, parameters: ["name":name,"password":password])
        XJNetWork.request(request, successHandler: { (jsonDic) in
            
            do {
                let userInfo = try XJDecoder.xj_decode(UserInfo.self, from: jsonDic)
                successHandler(userInfo)
            } catch let error {
                print("不行啊，映射不成功:\(error.localizedDescription)")
                failHandler(error)
            }
        }) { (error) in
            failHandler(error)
        }
        
    }
}
struct XJError:Error {
    
    /// 0是成功
    let code:NSInteger
    let errorMsg:String
    
}

struct UserInfo : Decodable {
    
    
}
