//
//  dashBoardMdl.swift
//  HelixSense
//
//  Created by DEEBA on 11.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
struct dashBoardMdl
{
    var empId:Int
    var idx:Int
    var planned_in:String
    var planned_out:String
    var planned_status:String
    var shift_id:Int
    var shift_name:String
    var space_id:Int //chklstId
    var space_name:String
    var space_number:String
    var space_path_name:String
    var space_status:String
    var user_defined:Bool
    init() {
                empId   =  0
                idx   =  0
                planned_in   =  ""
                planned_out   =  ""
                planned_status   =  ""
                shift_id   =  0
                shift_name   =  ""
                space_id   =  0 //chklstId
                space_name   =  ""
                space_number   =  ""
                space_path_name   =  ""
                space_status   =  ""
                user_defined = false
    }
}
var curntSHift = dashBoardMdl()
