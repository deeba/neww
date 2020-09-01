//
//  globals.swift
//  HelixSense
//
//  Created by DEEBA on 14.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
let SERVER = "demo.helixsense.com" // :- Staging
//let SERVER = ""  // :- LIVE

let BASE_URL_userInfo = "https://\(SERVER)/api/"
let BASE_URL = "https://\(SERVER)/api/v2/"
let pstRlsed = "\(BASE_URL_userInfo)v3/space/release"
let userInfo_URL = "\(BASE_URL_userInfo)userinfo"
let SHIFTS_URL = "\(BASE_URL)call"
let usrRol_URL = "\(BASE_URL)isearch_read"
let tnnt_URL = "\(BASE_URL)iread"
func find(value searchValue: String, in array: [String]) -> Int?
{
    for (index, value) in array.enumerated()
    {
        if value == searchValue {
            return index
        }
    }

    return nil
}
