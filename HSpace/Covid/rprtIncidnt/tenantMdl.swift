//
//  tenantMdl.swift
//  HSpace
//
//  Created by DEEBA on 21.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
struct tenantMdl
{
        var allow_onspot_space_booking:Bool
        var attendance_with_face_detection:Bool
        var auto_release: Bool
        var auto_release_grace_period: Int
        var check_list_ids: Array<Any>
        var chkLstid: Int
        var create_work_schedule:Bool
        var detect_mask:Bool
        var enable_report_covid_incident:Bool
        var face_detection_mandatory:Bool
        var generate_mor_after_release:Bool
        var id: Int
        var maintenance_team_id: Int
        var maintenance_team_nam: String
        var mask_mandatory:Bool
        var name: String
        var onspot_booking_grace_period: Int
        var require_attendance:Bool
        var require_checklist:Bool
        var sub_category_id: Int
        var ticket_category_nam: String
        var ticket_category_id: Int
        var sub_category_nam: String
        var work_schedule_grace_period: Int
        init() {
                 allow_onspot_space_booking = false
                 attendance_with_face_detection = false
                 auto_release = false
                 auto_release_grace_period = 0
                 check_list_ids = []
                 chkLstid = 0
                 create_work_schedule = false
                 detect_mask = false
                 enable_report_covid_incident = false
                 face_detection_mandatory = false
                 generate_mor_after_release = false
                 id = 0
                 maintenance_team_id = 0
                 maintenance_team_nam = ""
                 mask_mandatory = false
                 name = ""
                 onspot_booking_grace_period = 0
                 require_attendance = false
                 require_checklist = false
                 sub_category_id = 0
                 ticket_category_nam = ""
                 ticket_category_id = 0
                 sub_category_nam = ""
                 work_schedule_grace_period = 0
        }
    }
    var tenantModl = tenantMdl()

           
