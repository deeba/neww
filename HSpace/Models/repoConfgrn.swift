//
//  repoConfgrn.swift
//  HSpace
//
//  Created by DEEBA on 10.09.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
struct repoConfgrn: Codable {
    var  enable_access, skip_occupy,attendance_with_face_detection,
    require_attendance,allow_onspot_space_booking,book_from_outlook,create_work_schedule,show_occupant,allow_after_non_compliance,enable_report_covid_incident,enable_screening,detect_mask,face_detection_mandatory,mask_mandatory,prerelease_required,enable_prescreen,prescreen_is_manadatory,require_checklist,auto_release,generate_mor_after_release : Bool
    var onspot_booking_grace_period,work_schedule_grace_period,building_id,conference_room_space_id,conference_room_sub_type_id,office_room_space_id,office_room_sub_type_id,workstation_space_id,workstation_sub_type_id,enable_landing_page_id,enable_other_resources_id,enable_workspace_instruction_id,help_line_id,maintenance_team_id,safety_resources_id,sub_category_id,ticket_category_id,check_list_ids,auto_release_grace_period: Int
    var access_type,attendance_source,building_name,
    conference_room_space_name,conference_room_sub_type_name,office_room_space_name,
    office_room_sub_type_name,workstation_space_name,workstation_sub_type_name,enable_landing_page_name,enable_other_resources_name,enable_other_resources_url,enable_workspace_instruction_name,help_line_mobile,help_line_name,maintenance_team_name,safety_resources_name,safety_resources_url,sub_category_name,ticket_category_name,title,check_list_name:String
    var allowed_occupancy_per,prerelease_period,prescreen_period:Double
    enum CodingKeys: String, CodingKey {
        case access_type = "access_type"
        case enable_access = "enable_access"
        case skip_occupy = "skip_occupy"
        case attendance_source = "attendance_source"
        case attendance_with_face_detection = "attendance_with_face_detection"
        case require_attendance = "require_attendance"
        case allow_onspot_space_booking = "allow_onspot_space_booking"
        case book_from_outlook = "book_from_outlook"
        case create_work_schedule = "create_work_schedule"
        case onspot_booking_grace_period = "onspot_booking_grace_period"
        case show_occupant = "show_occupant"
        case work_schedule_grace_period = "work_schedule_grace_period"
        case building_id = "building_id"
        case building_name = "building_name"
        case conference_room_space_id = "conference_room_space_id"
        case conference_room_space_name = "conference_room_space_name"
        case conference_room_sub_type_id = "conference_room_sub_type_id"
        case conference_room_sub_type_name = "conference_room_sub_type_name"
        case office_room_space_id = "office_room_space_id"
        case office_room_space_name = "office_room_space_name"
        case office_room_sub_type_id = "office_room_sub_type_id"
        case office_room_sub_type_name = "office_room_sub_type_name"
        case workstation_space_id = "workstation_space_id"
        case workstation_space_name = "workstation_space_name"
        case workstation_sub_type_id = "workstation_sub_type_id"
        case workstation_sub_type_name = "workstation_sub_type_name"
        case allow_after_non_compliance = "allow_after_non_compliance"
        case allowed_occupancy_per = "allowed_occupancy_per"
        case enable_landing_page_id = "enable_landing_page_id"
        case enable_landing_page_name = "enable_landing_page_name"
        case enable_other_resources_id = "enable_other_resources_id"
        case enable_other_resources_name = "enable_other_resources_name"
        case enable_other_resources_url = "enable_other_resources_url"
        case enable_report_covid_incident = "enable_report_covid_incident"
        case enable_screening = "enable_screening"
        case enable_workspace_instruction_id = "enable_workspace_instruction_id"
        case enable_workspace_instruction_name = "enable_workspace_instruction_name"
        case help_line_id = "help_line_id"
        case help_line_mobile = "help_line_mobile"
        case help_line_name = "help_line_name"
        case maintenance_team_id = "maintenance_team_id"
        case maintenance_team_name = "maintenance_team_name"
        case safety_resources_id = "safety_resources_id"
        case safety_resources_name = "safety_resources_name"
        case safety_resources_url = "safety_resources_url"
        case sub_category_id = "sub_category_id"
        case sub_category_name = "sub_category_name"
        case ticket_category_id = "ticket_category_id"
        case ticket_category_name = "ticket_category_name"
        case title = "title"
        case detect_mask = "detect_mask"
        case face_detection_mandatory = "face_detection_mandatory"
        case mask_mandatory = "mask_mandatory"
        case prerelease_period = "prerelease_period"
        case prerelease_required = "prerelease_required"
        case check_list_ids = "check_list_ids"
        case check_list_name = "check_list_name"
        case enable_prescreen = "enable_prescreen"
        case prescreen_is_manadatory = "prescreen_is_manadatory"
        case prescreen_period = "prescreen_period"
        case require_checklist = "require_checklist"
        case auto_release = "auto_release"
        case auto_release_grace_period = "auto_release_grace_period"
        case generate_mor_after_release = "generate_mor_after_release"
    }
}
