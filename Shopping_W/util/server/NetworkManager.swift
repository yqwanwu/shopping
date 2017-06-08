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
    
    static func JsonGetRequest(urlString: String, params : [String : Any], success : @escaping (_ response : [String : Any])->(), failture : @escaping (_ error : Error)->()) {
        request(urlString: urlString, method: .get, params: params, success: success, failture: failture)
    }
    
    static  func JsonPostRequest(urlString: String, params : [String : Any], success : @escaping (_ response : [String : Any])->(), failture : @escaping (_ error : Error)->()) {
        request(urlString: urlString, method: .post, params: params, success: success, failture: failture)
    }
    
    static func DataRequest(urlString: String, method: HTTPMethod, params : [String : Any], success : @escaping (_ response : Data)->(), failture : @escaping (_ error : Error)->()) {
        
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
    
    static func request(urlString: String, method: HTTPMethod, params : [String : Any], success : @escaping (_ response : [String : Any])->(), failture : @escaping (_ error : Error)->()) {
        
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
