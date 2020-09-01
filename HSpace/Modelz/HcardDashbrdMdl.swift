//
//  HcardDashbrd.swift
//  AMTfm
//
//  Created by DEEBA on 15.06.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
struct hCardData {
    var Hcard: HcardMdlDta?
}
struct HcardMdlDta {
    let category_id: String
    let category_nam: String
    let criticality: String
    let display_name: String
    let equipment_seq: String
    let id: String
    let location_id: String
     let location_nam   : String
    let maintenance_team_id : String
     let maintenance_team_nam : String
    let manufacturer_id: String
     let manufacturer_nam: String
    let model: String
    let mro_equ_tmpl_lines: String
    let mroord_count: String
    let mtbf_hours: String
    let mttf_hours: String
    let mttr_hours: String
    let note: String
    let purchase_date: String
    let serial: String
    let state: String
    let vendor_id: String
    let vendor_nam: String
    let warranty_end_date: String
    }


