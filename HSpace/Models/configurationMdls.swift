//
//  configurationMdls.swift
//  HSpace
//
//  Created by DEEBA on 14.08.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import Foundation
struct configurationMdls
{
    var access_type:String
    var enable_access:Bool
    var skip_occupy:Bool
    var attendance_source:String
    var attendance_with_face_detection:Bool
    var require_attendance:Bool
    var allow_onspot_space_booking:Bool
    var book_from_outlook:Bool
    var create_work_schedule:Bool
    var onspot_booking_grace_period:Int
    var show_occupant:Bool
    var work_schedule_grace_period:Int
    var building_id:Int
    var building_name:String
    var conference_room_space_id:Int
    var conference_room_space_name:String
    var conference_room_sub_type_id:Int
    var conference_room_sub_type_name:String
    var office_room_space_id:Int
    var office_room_space_name:String
    var office_room_sub_type_id:Int
    var office_room_sub_type_name:String
    var workstation_space_id:Int
    var workstation_space_name:String
    var workstation_sub_type_id:Int
    var workstation_sub_type_name:String
    var allow_after_non_compliance:Bool
    var allowed_occupancy_per:Double
    var enable_landing_page_id:Int
    var enable_landing_page_name:String
    var enable_other_resources_id:Int
    var enable_other_resources_name:String
    var enable_other_resources_url:String
    var enable_report_covid_incident:Bool
    var enable_screening:Bool
    var enable_workspace_instruction_id:Int
    var enable_workspace_instruction_name:String
    var help_line_id:Int
    var help_line_mobile:String
    var help_line_name:String
    var maintenance_team_id:Int
    var maintenance_team_name:String
    var safety_resources_id:Int
    var safety_resources_name:String
    var safety_resources_url:String
    var sub_category_id:Int
    var sub_category_name:String
    var ticket_category_id:Int
    var ticket_category_name:String
    var title:String
    var detect_mask:Bool
    var face_detection_mandatory:Bool
    var mask_mandatory:Bool
    var prerelease_period:Double
    var prerelease_required:Bool
    var check_list_ids:Int
    var check_list_name:String
    var enable_prescreen:Bool
    var prescreen_is_manadatory:Bool
    var prescreen_period:Double
    var require_checklist:Bool
    var auto_release:Bool
    var auto_release_grace_period:Int
    var generate_mor_after_release:Bool
    
    init() {
           access_type = ""
             enable_access = false
             skip_occupy = false
             attendance_source = ""
             attendance_with_face_detection = false
             require_attendance = false
             allow_onspot_space_booking = false
             book_from_outlook = false
             create_work_schedule = false
             onspot_booking_grace_period = 0
             show_occupant = false
             work_schedule_grace_period = 0
             building_id = 0
             building_name = ""
             conference_room_space_id = 0
             conference_room_space_name = ""
             conference_room_sub_type_id = 0
             conference_room_sub_type_name = ""
             office_room_space_id = 0
             office_room_space_name = ""
             office_room_sub_type_id = 0
             office_room_sub_type_name = ""
             workstation_space_id = 0
             workstation_space_name = ""
             workstation_sub_type_id = 0
             workstation_sub_type_name = ""
             allow_after_non_compliance = false
            allowed_occupancy_per = 0.0
             enable_landing_page_id = 0
             enable_landing_page_name = ""
             enable_other_resources_id = 0
             enable_other_resources_name = ""
             enable_other_resources_url = ""
             enable_report_covid_incident = false
             enable_screening = false
             enable_workspace_instruction_id = 0
             enable_workspace_instruction_name = ""
             help_line_id = 0
             help_line_mobile = ""
             help_line_name = ""
             maintenance_team_id = 0
             maintenance_team_name = ""
             safety_resources_id = 0
             safety_resources_name = ""
             safety_resources_url = ""
             sub_category_id = 0
             sub_category_name = ""
             ticket_category_id = 0
             ticket_category_name = ""
             title = ""
             detect_mask = false
             face_detection_mandatory = false
             mask_mandatory = false
             prerelease_period = 0.0
             prerelease_required = false
             check_list_ids = 0
             check_list_name = ""
             enable_prescreen = false
             prescreen_is_manadatory = false
             prescreen_period = 0.0
             require_checklist = false
             auto_release = false
             auto_release_grace_period = 0
             generate_mor_after_release = false
    }
}
var configurationModls = configurationMdls()
