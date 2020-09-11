//
//  repousrInfo.swift
//  HSpace
//
//  Created by DEEBA on 11.09.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
// MARK: - Checklist
struct repousrInfo: Codable {
    var  company_id, employee_id,user_id,vendor_id  : Int
    var company_name,company_tz,email,employee_name,locale,name,phone_number,updated_at,user_role,username,vendor_name,website,zoneinfo: String
    enum CodingKeys: String, CodingKey {
         case   company_id = "id" //
         case      company_name = "company_name" //
         case      company_tz = "company_tz"
         case      email = "email" //
         case      employee_id = "employee_id"
         case      employee_name = "employee_name"
         case      locale = "locale" //
         case      name = "name"
         case      phone_number = "phone_number" //
         case      updated_at = "updated_at"
         case      user_id = "user_id" //
         case      user_role = "user_role"
         case      username = "username" //
         case      vendor_id = "vendor_id"
         case      vendor_name = "vendor_name" //
         case      website = "website"
         case      zoneinfo = "zoneinfo"
    }
}
