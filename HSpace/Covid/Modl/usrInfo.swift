//
//  usrInfo.swift
//  HelixSense
//{

import Foundation
struct usrInfoMdl
{
    var country_id:Int //
    var country_name:String //
    var formatted:String
    var locality:String //
    var postal_code:String
    var region:String //
    var street_address:String
    var compId:Int //
    var compName:String
    var email:String //
    var employee_id:Int
    var empName:String //
    var locale:String
    var phone_number:String //
    var usrId:Int
    var updated_at:String //
    var userName:String
    var website:String //
    var zoneinfo:String
    
    init() {
           country_id   = 0 //
           country_name   = "" //
           formatted  = ""
           locality  = "" //
           postal_code  = ""
           region  = "" //
           street_address  = ""
           compId  =  0 //
           compName  = ""
           email  = "" //
           employee_id  =  0
           empName  = "" //
           locale  = ""
           phone_number  = "" //
           usrId  =  0
           updated_at  = "" //
           userName  = ""
           website  = "" //
           zoneinfo  = ""
    }
}
var usrInfoModl = usrInfoMdl()
