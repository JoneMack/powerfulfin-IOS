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
open class XJRequest {
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
        
        if httpHeader == nil {
            self.httpHeader = XJRequest.defaultHTTPHeaders
        }else{
            self.httpHeader = httpHeader
        }
        
    }
    public static let defaultHTTPHeaders: HTTPHeaders = {
        
        var headers = SessionManager.defaultHTTPHeaders
        headers["DS-User-Agent"] = XJRequest.ds_defaultUserAgent
        return headers
    }()
    public static let ds_defaultUserAgent:String = {
        //Bundle Identifier|App版本号|Build号|设备名字|机型|系统|版本|设备唯一标识号
        var agent = "\(XJDeviceInfo.appBundleId)|\(XJDeviceInfo.appVersion)|\(XJDeviceInfo.appBuildVersion)|\(XJDeviceInfo.deviceName)|\(XJDeviceInfo.deviceType)|\(XJDeviceInfo.systemName)|\(XJDeviceInfo.systemVersion)|\(XJDeviceInfo.deviceId)"
        return agent.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }()
}


class XJNetWork {

    //请求
    //大圣分期 公共参数：lng，lat，version，phoneid，ssid，mac，_t
    class func request(_ requst:XJRequest,successHandler:@escaping((Any) ->Void),failHandler:@escaping((XJError)->Void)) {
        let paramrters = configPublicParameters(parameters: requst.parameters)
        
        Alamofire.request(requst.url, method:HTTPMethod(rawValue: requst.method.rawValue)!, parameters: paramrters, headers: requst.httpHeader).responseJSON { (response) in
            handlerResult(response: response, successHandler: successHandler, failHandler: failHandler)
        }
    }
    //上传请求
    class func uploadRequest(_ request:XJRequest,progressHandler:@escaping((CGFloat) -> Void),successHandler:@escaping((Any) ->Void),failHandler:@escaping((XJError)->Void))
    {
        let imageName = request.parameters["name"] as! String
        
        let imageData = request.parameters["data"] as? Data
        if imageData == nil {
            failHandler(XJError(code: -1, errorMsg: "图片为空，换一张试试"))
            return
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imageData!, withName: imageName, fileName: imageName, mimeType: "image/png")
        }, to: request.url) { (encodingResult) in
            switch encodingResult {
            case .success(let upload,_,_) :
                upload.uploadProgress(closure: { (progerss) in
                    
                    let aValue :Double = Double(progerss.completedUnitCount)/Double(progerss.totalUnitCount)
                    progressHandler(CGFloat(aValue))
                    
                }).responseJSON(completionHandler: { (response) in
                    handlerResult(response: response, successHandler: successHandler, failHandler: failHandler)
                })
            case.failure(let error):
                print("\(error.localizedDescription)")
            }
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
            XJToast.hiddenToastAction()

            }.ifFailure {
                failHandler(XJError(code: -1, errorMsg: response.error?.localizedDescription ?? "") )
                XJToast.hiddenToastAction()
        }
    }
}
extension XJNetWork {
    // 增加公共参数
    static fileprivate func configPublicParameters(parameters:[String:Any]) -> [String:Any] {
        var paramDic = parameters
        // 移除首尾空格
        for (key,value) in paramDic {
            if let stringValue = value as? String {
                let aStr = stringValue.trimmingCharacters(in: .whitespaces)
                paramDic[key] = aStr
            }
            
        }
        paramDic["lng"] = DSLocationManager.manager.longitude
        paramDic["lat"] = DSLocationManager.manager.latitude
        paramDic["version"] = XJDeviceInfo.appVersion
        paramDic["phoneid"] = XJDeviceInfo.deviceId
        let wifiInfo = XJDeviceInfo.wifiInfo
        paramDic["ssid"] = wifiInfo.ssid
        paramDic["mac"] = wifiInfo.mac
        paramDic["_t"] = Date().milliStamp
        return paramDic
    }
}
// MARK: - 数据映射 Json->Model
class XJDecoder {
    class func xj_decode<T:Decodable>(_ someClass: T.Type, from jsonDic: Any) throws -> T {
        do {
            let jsonDecoder = JSONDecoder()
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDic, options: [])
            let objc = try jsonDecoder.decode(someClass, from: jsonData)
            return objc
        } catch {
            XJToast.showToastAction(message: "数据格式错误")
            XJToast.hiddenToastAction()
            throw XJError(code: -2, errorMsg: "数据格式错误")
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
