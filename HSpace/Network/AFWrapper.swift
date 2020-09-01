//
//  AFWrapper.swift
//  HelixSense
//
//  Created by DEEBA on 08.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
import Alamofire

class AFWrapper : NSObject{
    
    private override init() {
        
    }
    
    class func multipartRequest(_ strURL:String, method: HTTPMethod = .post, params : [String : Any], headers : HTTPHeaders, progress:((Progress) -> Void)? = nil, success:@escaping (Any?) -> Void, failure:@escaping (Error?) -> Void) {
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in params {
                if let temp = value as? String {
                    multipartFormData.append("\(temp)".data(using: .utf8, allowLossyConversion: false)!, withName: key)
                }
            }
        }, usingThreshold:UInt64.init(), to: strURL, method: method, headers: headers, encodingCompletion: { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (currentProgress) in
                    progress?(currentProgress)
                })
                upload.responseJSON { response in
                    switch response.result {
                        case .success: success(response.result.value)
                        case .failure: failure(response.result.error)
                    }
                }
            case .failure(let encodingError): failure(encodingError)
            }
        })
    }
    
    class func postRequest(_ strURL:String,
                           params : [String : Any]? = nil,
                           headers : HTTPHeaders? = nil,
                           isJsonEncoding: Bool = true,
                           success:@escaping (Any?) -> Void,
                           failure:@escaping (Any?) -> Void) {
        
        Alamofire.request(strURL, method: .post, parameters: params,
                          encoding: isJsonEncoding ? JSONEncoding.default : URLEncoding.default  ,
                          headers: headers).responseJSON { (response) -> Void in
            switch response.result {
                case .success: success(response.value)
                case .failure: failure(response.error)
            }
        }
    }
    
    class func getRequest(_ strURL:String,
                          params : [String : Any]? = nil,
                          headers : HTTPHeaders? = nil,
                          success:@escaping (Any?) -> Void,
                          failure:@escaping (Any?) -> Void) {
        
        Alamofire.request(strURL, method: .get, parameters: params, headers: headers).responseJSON { (response) -> Void in
            switch response.result {
                case .success: success(response.value)
                case .failure: failure(response.error)
            }
        }
    }
}
