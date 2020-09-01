//
//  models.swift
//  HelixSense
//
//  Created by DEEBA on 14.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import UIKit
import ObjectMapper

class ShiftsResponse : Mappable {
    var data : [ShiftsData]?
    var error : ShiftError?
    var length : Int?
    var status : Bool?
    var code : Int?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        data <- map["data"]
        error <- map["error"]
        length <- map["length"]
        status <- map["status"]
        code <- map["code"]
    }
}

class ShiftsData : Mappable {
    var employee_id : Int?
    var id : Int?
    var planned_in : String?
    var planned_out : String?
    var planned_status : String?
    var shift_id : Int?
    var shift_name : String?
    var space_id : Int?
    var space_name : String?
    var space_number : String?
    var space_path_name : String?
    var space_status : String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        employee_id <- map["employee_id"]
        id <- map["id"]
        planned_in <- map["planned_in"]
        planned_out <- map["planned_out"]
        planned_status <- map["planned_status"]
        shift_id <- map["shift_id"]
        shift_name <- map["shift_name"]
        space_id <- map["space_id"]
        space_name <- map["space_name"]
        space_number <- map["space_number"]
        space_path_name <- map["space_path_name"]
        space_status <- map["space_status"]
    }

}

class ShiftError : Mappable {
    var message : String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        message <- map["message"]
    }

}
