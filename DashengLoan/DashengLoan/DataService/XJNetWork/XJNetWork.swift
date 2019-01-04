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

    //请求
    //大圣分期 公共参数：lng，lat，version，phoneid，ssid，mac，_t
    class func request(_ requst:XJRequest,successHandler:@escaping((Any) ->Void),failHandler:@escaping((XJError)->Void)) {
        var paramrters = requst.parameters
        paramrters["lng"] = DSLoactionManager.manager.longitude
        paramrters["lat"] = DSLoactionManager.manager.latitude
        paramrters["version"] = XJDeviceInfo.appVersion
        paramrters["phoneid"] = XJDeviceInfo.deviceId
        let wifiInfo = XJDeviceInfo.wifiInfo
        paramrters["ssid"] = wifiInfo.ssid
        paramrters["mac"] = wifiInfo.mac
        paramrters["_t"] = Date().milliStamp
        
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
                    print("上传进度L：", aValue)
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
