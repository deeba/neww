//
//  HeaderWrapper.swift
//  HSpace
//
//  Created by DEEBA on 30.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
class HeaderWrapper {
    
     var token : String?
    
    private init() {
        
    }
    
     func header(type: HeaderType? = nil, authorization: Bool = false) -> [String:String] {
        var header = [String:String]()
        switch type {
        case .json:
            header["Content-Type"] = "application/json"
        case .formData:
            header["Content-Type"] = "form-data"
        case .formUrlencoded:
            header["Content-Type"] = "application/x-www-form-urlencoded"
        default:
            break
        }
        if authorization {
            header["Authorization"] = "Bearer \(token ?? "")"
        }
        return header
    }
}



