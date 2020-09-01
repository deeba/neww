//
//  curntSchedulModl.swift
//  HSpace
//
//  Created by DEEBA on 18.08.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
struct curntSchedulModl
{
    var access_status:Bool
    var actual_in:Bool
    var actual_out:Bool
    var employee_id:Int
    var id:Int
    var planned_in:String
    var planned_out:String
    var planned_status:String
    var prescreen_status:Bool
    var shift_id:Int
    var shift_name:String
    var space_id:Int
    var space_name:String
    var space_number:String
    var space_path_name:String
    var space_status:String
    var user_defined:Bool
    var working_hours:Double
    init() {
                access_status = false
                actual_in = false
                actual_out = false
                employee_id = 0
                id = 0
                planned_in = ""
                planned_out = ""
                planned_status = ""
                prescreen_status = false
                shift_id = 0
                shift_name = ""
                space_id = 0
                space_name = ""
                space_number = ""
                space_path_name = ""
                space_status = ""
                user_defined = false
        working_hours = 0.0
    }
}
var curntSchedulModll = curntSchedulModl()
