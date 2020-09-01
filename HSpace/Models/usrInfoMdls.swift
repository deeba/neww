//
//  usrInfoMdls.swift
//  HSpace
//
//  Created by DEEBA on 14.08.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//


import Foundation
struct usrInfoMdls
{
    var company_id:Int //
    var company_name:String //
    var company_tz:String
    var email:String //
    var employee_id:Int
    var employee_name:String
    var locale:String //
    var name:String
    var phone_number:String //
    var updated_at:String
    var user_id:Int //
    var user_role:String
    var username:String //
    var vendor_id:Int
    var vendor_name:String //
    var website:String
    var zoneinfo:String
    
    init() {
           company_id = 0 //
           company_name = "" //
           company_tz = ""
           email = "" //
           employee_id = 0
           employee_name = ""
           locale = "" //
           name = ""
           phone_number = "" //
           updated_at = ""
           user_id = 0 //
           user_role = ""
           username = "" //
           vendor_id = 0
           vendor_name = "" //
           website = ""
           zoneinfo = "" 
    }
}
var usrInfoModls = usrInfoMdls()
