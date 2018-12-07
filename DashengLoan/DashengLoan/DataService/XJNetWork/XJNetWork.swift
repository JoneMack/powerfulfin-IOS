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
        self.url = url
        self.method = method
        guard let parameter = parameters else {  return }
        self.parameters = parameter
        
        guard let header = httpHeader else {  return }
        self.httpHeader = header
    }
}


class XJNetWork {
    class func request(_ method:XJHTTPMethod = .get,URL:String, parameters:[String:String] ,successHandler:@escaping((Any) ->Void),failHandler:@escaping((Error)->Void)) {
        Alamofire.request(URL).responseJSON { (response) in
            handlerResult(response: response, successHandler: successHandler, failHandler: failHandler)
        }
    }
    class func request(_ requst:XJRequest,successHandler:@escaping((Any) ->Void),failHandler:@escaping((Error)->Void)) {
        Alamofire.request(requst.url, method:.get, parameters: requst.parameters, headers: requst.httpHeader).responseJSON { (response) in
            handlerResult(response: response, successHandler: successHandler, failHandler: failHandler)
        }
    }
    fileprivate class func handlerResult(response:DataResponse<Any>,successHandler:@escaping((Any) ->Void),failHandler:@escaping((Error)->Void)) {
        
        response.result.ifSuccess {
                successHandler(response.result.value as Any)
            }.ifFailure {
                failHandler(response.error ?? XJNetError.netFail)
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
            print("不行啊，映射不成功")
            throw XJNetError.mapError
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

enum XJNetError:Error {
    case netFail
    case mapError
    var localizedDescription: String {
        let desc = self == .mapError ? "映射数据失败" :"请求失败了"
        return "\(self): \(desc)"
    }
    
}

struct UserInfo : Decodable {
    
    
}
