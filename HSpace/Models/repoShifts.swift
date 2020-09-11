//
//  repoShifts.swift
//  HSpace
//
//  Created by DEEBA on 04.09.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
// MARK: - Checklist
struct repoShft: Codable {
    var   name,planned_in,planned_out,ttl : String
    var id : Int
    var start_time,duration:Double
    enum CodingKeys: String, CodingKey {
        case duration = "duration"
        case name = "company_name"
        case planned_in = "employee_id"
        case planned_out = "employee_name"
        case ttl = "ttl"
        case id = "sub"
        case start_time = "username"
        
    }
}
