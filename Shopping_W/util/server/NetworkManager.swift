//
//  NetworkManager.swift
//  popTest
//
//  Created by wanwu on 17/3/14.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import ObjectMapper

class NetworkManager: NSObject {
    
    static let SERBERURL = "http://111.161.41.28:8088/tjgy/api"
    
    static let REQUEST_ERROR = "请求失败"
    
//    static let SERBERURL = "http://192.168.0.102:8080/tjgy/api"
    
    static var sessionId = ""
    private static let version = "1.0"
    private static let format = "json"
    private static let locale = "0"
    private static let sign = "0"
    
    static func JsonGetRequest(params : [String : Any]?, success : @escaping (_ response : JSON)->(), failture : @escaping (_ error : Error)->()) {
        let allp = getAllparams(params: params)
        request(urlString: SERBERURL, method: .get, params: allp, success: success, failture: failture)
    }
    
    static  func JsonPostRequest(params : [String : Any]?, success : @escaping (_ response : JSON)->(), failture : @escaping (_ error : Error)->()) {
        let allp = getAllparams(params: params)
        request(urlString: SERBERURL, method: .post, params: allp, success: success, failture: failture)
    }
    
    static func DataRequest(urlString: String, method: HTTPMethod, params : [String : Any]?, success : @escaping (_ response : Data)->(), failture : @escaping (_ error : Error)->()) {
        Alamofire.request(urlString, method: method, parameters: params)
            .responseData(completionHandler: { (response) in
                switch response.result {
                case .success(let data):
                    success(data)
                case .failure(let error):
                    failture(error)
                }
        })
    }
    
    static func request(urlString: String, method: HTTPMethod, params : [String : Any]?, success : @escaping (_ response : JSON)->(), failture : @escaping (_ error : Error)->()) {
        Alamofire.request(urlString, method: method, parameters: params)
            .responseString { (response) in
                switch response.result {
                case .success(let value):
                    let j = JSON(parseJSON: value)
                    success(j)
                case .failure(let error):
                    failture(error)
                }
        }
    }
    
    fileprivate static func setupBaseModel<T: ParseModelProtocol>(model: BaseModel<T>, json: JSON){
        model.code = json["code"].stringValue
        model.message = json["message"].stringValue
        model.sessionId = json["sessionId"].stringValue
        model.currentPage = json["currentPage"].intValue
        model.pageSize = json["pageSize"].intValue
        model.pageCount = json["pageCount"].intValue
        model.total = json["total"].intValue
    }
    
    ///必须是json
    static func requestModel<T: ParseModelProtocol>(method: HTTPMethod = .post, params : [String : Any]?, success : @escaping (_ response : BaseModel<T>)->(), failture : @escaping (_ error : Error)->()) {
        
        let allp = getAllparams(params: params)
        
        Alamofire.request(SERBERURL, method: method, parameters: allp)
            .responseString { (response) in
                switch response.result {
                case .success:
                    let model = BaseModel<T>()
                    let json = JSON(parseJSON: response.result.value ?? "")
                    setupBaseModel(model: model, json: json)
                    success(model)
                case .failure(let error):
                    failture(error)
                }
        }
    }
    
    static func getAllparams(params: [String : Any]?) -> [String : Any] {
        var allp = params ?? [String : Any]()
        allp["appKey"] = "ios_app"
        allp["v"] = version
        allp["format"] = format
        allp["locale"] = locale
        allp["sign"] = sign
        allp["sessionId"] = sessionId
        
        if !Tools.stringIsNotBlank(text: sessionId) {
            //登录
        }
    
        return allp
    }
        
    static func upload(data: Data, url: String, progressHander: ((Progress) -> Void)?) {
        Alamofire.upload(data, to: url)
            .uploadProgress { progress in // main queue by default
                progressHander?(progress)
            }
            .responseJSON { response in
                debugPrint(response)
        }
        
        
//        Alamofire.upload(
//            multipartFormData: { multipartFormData in
//                multipartFormData.append(unicornImageURL, withName: "unicorn")
//                multipartFormData.append(rainbowImageURL, withName: "rainbow")
//        },
//            to: "https://httpbin.org/post",
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON { response in
//                        debugPrint(response)
//                    }
//                case .failure(let encodingError):
//                    print(encodingError)
//                }
//        }
//        )
    }
    
}



extension NetworkManager {
    ///必须是json
    static func requestListModel<T: ParseModelProtocol>(method: HTTPMethod = .post, params : [String : Any]?, success : @escaping (_ response : BaseModel<T>)->(), failture : @escaping (_ error : Error)->()) {
        
        let allp = getAllparams(params: params)
        
        Alamofire.request(SERBERURL, method: method, parameters: allp)
            .responseString { (response) in
                switch response.result {
                case .success:
                    let model = BaseModel<T>()
                    let json = JSON(parseJSON: response.result.value ?? "")
                    setupBaseModel(model: model, json: json)
                    
                    var list = [T]()
                    for item in json["list"].arrayValue {
                        let t = T()
                        if let dic = item.dictionaryObject as NSDictionary? {
                            t.parse(dic: dic)
                        }
                        list.append(t)
                    }
                    model.list = list
                    success(model)
                case .failure(let error):
                    failture(error)
                }
        }
    }
    
    static func requestTModel<T: ParseModelProtocol>(method: HTTPMethod = .post, params : [String : Any]?, success : @escaping (_ response : BaseModel<T>)->(), failture : @escaping (_ error : Error)->()) {
        
        let allp = getAllparams(params: params)
        
        Alamofire.request(SERBERURL, method: method, parameters: allp)
            .responseString { (response) in
                switch response.result {
                case .success:
                    let model = BaseModel<T>()
                    let json = JSON(parseJSON: response.result.value ?? "")
                    setupBaseModel(model: model, json: json)
                    let t = T()
                    if let dic = json["t"].dictionaryObject as NSDictionary? {
                        t.parse(dic: dic)
                    }
                    model.t = t
                    
                    success(model)
                case .failure(let error):
                    failture(error)
                }
        }
    }
}



class BaseModel<T: ParseModelProtocol>: NSObject {
    var code = "-1"
    var message = ""
    var t: T?
    var list: [T]?
    
    var sessionId = ""
    var currentPage = 0
    var pageSize = 0
    var pageCount = 0
    var total = 0
    
    var isSuccess: Bool {
        return code == "0"
    }

    @discardableResult
    func whenSuccess(action: () -> Void) -> Self {
        if self.isSuccess {
            if let _ = t {
                action()
            }
        } else {
            MBProgressHUD.show(errorText: self.message)
        }
        return self
    }
    
    @discardableResult
    func whenNoData(action: () -> Void) -> Self {
        if t == nil {
            action()
        }
        return self
    }
    
    required override init() {
        super.init()
    }
}










