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

class NetworkManager: NSObject {
    
    static let SERBERURL = "http://111.161.41.28:8088/tjgy/api"
    
//    static let SERBERURL = "http://192.168.1.37:8080/tjgy/api"
    
    private static var sessionId = ""
    private static let version = "1.0"
    private static let format = "json"
    private static let locale = "0"
    private static let sign = "0"
    
    static func JsonGetRequest(params : [String : Any]?, success : @escaping (_ response : [String : Any])->(), failture : @escaping (_ error : Error)->()) {
        let allp = getAllparams(params: params)
        request(urlString: SERBERURL, method: .get, params: allp, success: success, failture: failture)
    }
    
    static  func JsonPostRequest(params : [String : Any]?, success : @escaping (_ response : [String : Any])->(), failture : @escaping (_ error : Error)->()) {
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
    
    static func request(urlString: String, method: HTTPMethod, params : [String : Any]?, success : @escaping (_ response : [String : Any])->(), failture : @escaping (_ error : Error)->()) {
        Alamofire.request(urlString, method: method, parameters: params)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    success(value as! [String : Any])
                case .failure(let error):
                    failture(error)
                }
        }
    }
    
    ///必须是json
    static func requestModel<T: BaseModel>(method: HTTPMethod = .post, params : [String : Any]?, success : @escaping (_ response : T)->(), failture : @escaping (_ error : Error)->()) {
        
        let allp = getAllparams(params: params)
        
        Alamofire.request(SERBERURL, method: method, parameters: allp)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    let model = T()
                    if let dic = response.result.value as? NSDictionary {
                        model.parse(dic: dic)
                        success(model)
                    } else {
                        failture(NSError(domain: "模型转换失败: \(response.result.value ?? "")", code: 10010, userInfo: nil))
                    }
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
    static func requestListModel<T: BaseModel>(method: HTTPMethod = .post, params : [String : Any]?, success : @escaping (_ response : T)->(), failture : @escaping (_ error : Error)->()) {
        
        let allp = getAllparams(params: params)
        
        Alamofire.request(SERBERURL, method: method, parameters: allp)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    let model = T()
                    if let dic = response.result.value as? NSDictionary {
                        model.parse(dic: dic)
                        success(model)
                    } else {
                        failture(NSError(domain: "模型转换失败: \(response.result.value ?? "")", code: 10010, userInfo: nil))
                    }
                case .failure(let error):
                    failture(error)
                }
        }
    }
    
    static func requestTModel<T: BaseModel>(method: HTTPMethod = .post, params : [String : Any]?, success : @escaping (_ response : T)->(), failture : @escaping (_ error : Error)->()) {
        
        let allp = getAllparams(params: params)
        
        Alamofire.request(SERBERURL, method: method, parameters: allp)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    let model = T()
                    if let dic = response.result.value as? NSDictionary {
                        model.parse(dic: dic)
                        success(model)
                    } else {
                        failture(NSError(domain: "模型转换失败: \(response.result.value ?? "")", code: 10010, userInfo: nil))
                    }
                case .failure(let error):
                    failture(error)
                }
        }
    }
}



class BaseModel: NSObject, ParseModelProtocol{
    var code = "-1"
    var message = ""
    var t: ParseModelProtocol?
    var list: [ParseModelProtocol]?

    required override init() {
        super.init()
    }
}










