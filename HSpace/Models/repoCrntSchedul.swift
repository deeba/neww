//
//  repoCrntSchedul.swift
//  HSpace
//
//  Created by DEEBA on 08.09.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
// MARK: - Checklist
struct repoCrntSchedul: Codable {
    var  access_status, actual_in,actual_out,prescreen_status,user_defined : Bool
    var employee_id,id,shift_id,space_id: Int
    var planned_in,planned_out,planned_status,shift_name,space_name,space_number,space_path_name,space_status: String
    var working_hours:Double
    enum CodingKeys: String, CodingKey {
        case access_status = "access_status"
        case actual_in = "actual_in"
        case actual_out = "actual_out"
        case prescreen_status = "prescreen_status"
        case user_defined = "user_defined"
        case employee_id = "employee_id"
        case id = "id"
        case shift_id = "shift_id"
        case space_id = "space_id"
        case planned_in = "planned_in"
        case planned_out = "planned_out"
        case planned_status = "planned_status"
        case shift_name = "shift_name"
        case space_name = "space_name"
        case space_number = "space_number"
        case space_path_name = "space_path_name"
        case space_status = "space_status"
        case working_hours = "working_hours"
    }
}
