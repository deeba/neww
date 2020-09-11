//
//  repoUser.swift
//  HSpace
//
//  Created by DEEBA on 04.09.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
// MARK: - Checklist
struct repoUser: Codable {
    var  company_name, employee_name,username : String
    var company_id,employee_id,usrId: Int
    enum CodingKeys: String, CodingKey {
        case company_id = "company_id"
        case company_name = "company_name"
        case employee_id = "employee_id"
        case employee_name = "employee_name"
        case usrId = "sub"
        case username = "username"
    }
}
