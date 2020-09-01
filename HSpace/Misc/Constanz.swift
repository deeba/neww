//
//  Constanz.swift
//  Reachability
//
//  Created by DEEBA on 16.03.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
import UIKit
import SQLite3
class DBConstanz: NSObject  {
    let instanceOfUser = readWrite()
    func writeAny(){
         let TABLE_NAME_ORDERS: String = "    tbl_orders";
        let TABLE_NAME_CHECKLIST: String = " tbl_checklist";
        let TABLE_NAME_TIMESHEET: String = " tbl_timesheet";

        let COLUMN_ID: String = "id";
        let COLUMN_UNIQUE_ID: String = "unq_id";
        let COLUMN_ORDERID: String = "orderId";
        let COLUMN_DESC: String = "desc";
        let COLUMN_ASSIGNEDBY: String = "assignedby";
        let COLUMN_CREATED_DATE: String = "created_date";
        let COLUMN_STATUS: String = "status";
        let COLUMN_CATEGORY: String = "category";
        let COLUMN_LOCATION: String = "location";
        let COLUMN_PRIORITY: String = "priority";
        let COLUMN_ASSIGNEDTO: String = "assigned_to";
        let COLUMN_ASSETNAME: String = "asset_name";
        let COLUMN_PREVENTIVE: String = "preventive";
        let COLUMN_STARTTIME: String = "start_time";
        let COLUMN_ENDTIME: String = "end_time";
        let COLUMN_ACCEPTSTATUS: String = "accept_status";
        let COLUMN_ISFLAG: String = "is_flag";
        let COLUMN_SYNC_STATUS: String = "sync_status";
        let COLUMN_COMPANYNAME: String = "comapny_name";
        let COLUMN_QR: String = "qr_code";
        let COLUMN_START_MRO: String = "at_start_mro";
        let COLUMN_DONE_MRO: String = "at_done_mro";
        let COLUMN_REVIEW_MRO: String = "at_review_mro";
        let COULUMN_IS_MODIFIED_STATUS: String = "is_modified_status";
        let COLUMN_TEAMID: String = "team_id";
        let COLUMN_HELPDESKID: String = "helpdesk_id";
        let COLUMN_ORDER_ENFORCE_TIME: String = "enforce_time";

        let COLUMN_PAUSE_REASON_ID = "pause_reason_id"
        let COLUMN_PAUSE_SELECTED_REASON = "pause_selected_reason"
        let COLUMN_PAUSE_REASON = "pause_reason"
        let COLUMN_CHECKLISTIDS: String = "checklist_ids";
        let COLUMN_ASSETID: String = "asset_id";
        let COLUMN_MESSAGEIDS: String = "message_ids";

        let COLUMN_CHECKLIST_ID: String = "checklist_id";
        let COLUMN_CHECKLIST_TYPE: String = "checklist_type";
        let COLUMN_QUESTION: String = "question";
        let COLUMN_ANSWER: String = "answer";
        let COLUMN_SUGGESTION: String = "suggestion_array";
        let COLUMN_ISSUBMITTED: String = "is_submitted";
        let COLUMN_ISHEADERGROUP: String = "header_group";
        let CREATE_TABLE_ORDERS: String =
        "CREATE TABLE IF NOT EXISTS " + TABLE_NAME_ORDERS + "("
                + COLUMN_ID + " INTEGER PRIMARY KEY AUTOINCREMENT,"
                + COLUMN_UNIQUE_ID + " INTEGER,"
                + COLUMN_ORDERID + " TEXT,"
                + COLUMN_DESC + " TEXT,"
                + COLUMN_ASSIGNEDBY + " TEXT,"
                + COLUMN_CREATED_DATE + " TEXT,"
                + COLUMN_STATUS + " TEXT,"
                + COLUMN_CATEGORY + " TEXT,"
                + COLUMN_LOCATION + " TEXT,"
                + COLUMN_PRIORITY + " TEXT,"
                + COLUMN_CHECKLISTIDS + " TEXT,"
                + COLUMN_ASSIGNEDTO + " TEXT,"
                + COLUMN_ASSETID + " TEXT,"
                + COLUMN_ASSETNAME + " TEXT,"
                + COLUMN_PREVENTIVE + " TEXT,"
                + COLUMN_STARTTIME + " TEXT,"
                + COLUMN_ENDTIME + " TEXT,"
                + COLUMN_ACCEPTSTATUS + " Bool,"
                + COLUMN_ISFLAG + " Bool,"
                + COLUMN_SYNC_STATUS + " Bool,"
                + COLUMN_COMPANYNAME + " TEXT,"
                + COLUMN_QR + " TEXT,"
                + COLUMN_MESSAGEIDS + " TEXT,"
                + COLUMN_START_MRO + " Bool,"
                + COLUMN_DONE_MRO + " Bool,"
                + COLUMN_REVIEW_MRO + " Bool,"
                + COULUMN_IS_MODIFIED_STATUS + " Bool,"
                + COLUMN_TEAMID + " TEXT,"
                + COLUMN_HELPDESKID + " TEXT,"
                + COLUMN_ORDER_ENFORCE_TIME + " Bool,"
                + COLUMN_PAUSE_REASON_ID + " TEXT,"
                + COLUMN_PAUSE_SELECTED_REASON + " TEXT,"
                + COLUMN_PAUSE_REASON + " TEXT"
            
                + ")";
    let TABLE_NAME_UPLOADS: String  = " tbl_uploads";

       let COLUMN_IMAGE_GUID: String = "guid";
       let COLUMN_FILENAME: String = "file_name";
       let COLUMN_DATAFNAME: String = "data_file_name";
       let COLUMN_DATA: String = "file_data";
       let COLUMN_PATH: String = "path";
       let COLUMN_IMAGETYPE: String = "image_type";
       let COLUMN_CHKLSTID: String = "checklist_id";


       // Create table SQL query for main
       let CREATE_TABLE_UPLOAD: String =
               "CREATE TABLE IF NOT EXISTS " + " " + TABLE_NAME_UPLOADS + "("
                       + COLUMN_ID + " INTEGER PRIMARY KEY AUTOINCREMENT,"
                       + COLUMN_IMAGE_GUID + " TEXT,"
                       + COLUMN_UNIQUE_ID + " INTEGER,"
                       + COLUMN_FILENAME + " TEXT,"
                       + COLUMN_DATAFNAME + " TEXT,"
                       + COLUMN_DATA + " TEXT,"
                       + COLUMN_PATH + " TEXT,"
                       + COLUMN_IMAGETYPE + " TEXT,"
                       + COLUMN_CHKLSTID + " TEXT,"
                       + COLUMN_SYNC_STATUS + " Bool"
                       + ")";
       
       let CREATE_TABLE_CHECKLIST: String = "CREATE TABLE IF NOT EXISTS " + TABLE_NAME_CHECKLIST + "("
               + "shift_id" + " TEXT,"
               + "checklist_id" + " TEXT,"
               + "checklist_type" + " TEXT,"
               + "question" + " TEXT,"
               + "suggestion_array" + " TEXT,"
               + "answer" + " TEXT,"
               + "is_submitted" + " TEXT,"
               + "header_group" + " TEXT,"
               + "expected_ans" + " TEXT,"
               + "sync_status" + " Bool" +
               ")";

       //time sheet entries
       let COLUMN_GUID: String = "guid";
       let COLUMN_STARTDATE: String = "start_date";
       let COLUMN_ENDDATE: String = "end_date";
       let COLUMN_REASON : String = "reason";
       let COLUMN_LATITUDE: String = "latitude";
       let COLUMN_LONGITUDE: String = "longitude";
       let COLUMN_TIMESHEET_ORDER_STATUS: String = "job_order_status";
       let COLUMN_TIMESHEET_IDS: String = "timesheet_ids";
       let COLUMN_ISSYNCSTATUS: String = "sync_stats";

       let CREATE_TABLE_TIMESHEET: String =
               "CREATE TABLE IF NOT EXISTS " + TABLE_NAME_TIMESHEET + "("
                       + COLUMN_ID + " INTEGER PRIMARY KEY AUTOINCREMENT,"
                       + COLUMN_GUID + " TEXT,"
                       + COLUMN_UNIQUE_ID + " INTEGER,"
                       + COLUMN_STARTDATE + " TEXT,"
                       + COLUMN_ENDDATE + " TEXT,"
                       + COLUMN_REASON + " TEXT,"
                       + COLUMN_LATITUDE + " TEXT,"
                       + COLUMN_LONGITUDE + " TEXT,"
                       + COLUMN_TIMESHEET_ORDER_STATUS + " TEXT,"
                       + COLUMN_TIMESHEET_IDS + " TEXT,"
                       + COLUMN_ISSYNCSTATUS + " Bool"
                       + ")";

       //smart logger main table
       let TABLE_NAME_SMARTLOGGER: String = " tbl_smartlogger";
       let COLUMN_AUTO_INCREMENT_ID: String = "id";
       let COLUMN_UNIQ_ID: String = "uniq_id";
       let COLUMN_NAME: String = "name";
       let COLUMN_SEQUENCE: String = "sequence_name"; //(i.e barcode value)
       let COLUMN_LOCAITON: String = "location";
       let COLUMN_LAST_UPDATED_VALUE: String = "last_update";

       //smart logger details table
       let TABLE_NAME_SMARTLOGGER_DETAILS: String = " tbl_smartlogger_details";
       let COLUMN_TYPE: String = "type"; //(i.e type either meter or gauge)
       let COLUMN_TYPE_ID: String = "type_id"; // either meter id or gauge id
       let COLUMN_TYPE_NAME: String = "type_name"; // either meter name or guage name
       let COLUMN_LAST_UPDATE_DATE: String = "last_update_date";
       let COLUMN_LAST_VALUE: String = "last_captured_value";

       //smart logger captured data table
       let TABLE_NAME_SMARTLOGGER_CAPTURED: String = " tbl_smartlogger_captured";
       let COULUMN_GUID: String = "guid";
       let COLUMN_CAPTURED_VALUE: String = "current_captured_value";
       let COLUMN_CAPTURED_DATE: String = "current_captured_date";
       let COLUMN_CREATE_TYPE: String = "create_type";
       let COLUMN_IS_SYNC: String = "is_sync";

       let CREATE_TABLE_SMARTLOGGER: String =
               "CREATE TABLE IF NOT EXISTS " + TABLE_NAME_SMARTLOGGER + "("
                       + COLUMN_AUTO_INCREMENT_ID + " INTEGER PRIMARY KEY AUTOINCREMENT,"
                       + COLUMN_UNIQ_ID + " TEXT,"
                       + COLUMN_NAME + " TEXT,"
                       + COLUMN_SEQUENCE + " TEXT,"
                       + COLUMN_LOCAITON + " TEXT,"
                       + COLUMN_LAST_UPDATED_VALUE + " TEXT"
                       + ")";

       let CREATE_TABLE_SMARTLOGGER_DETAILS: String =
               "CREATE TABLE IF NOT EXISTS " + TABLE_NAME_SMARTLOGGER_DETAILS + "("
                       + COLUMN_AUTO_INCREMENT_ID + " INTEGER PRIMARY KEY AUTOINCREMENT,"
                       + COLUMN_UNIQ_ID + " TEXT,"
                       + COLUMN_TYPE + " TEXT,"
                       + COLUMN_TYPE_ID + " TEXT,"
                       + COLUMN_TYPE_NAME + " TEXT,"
                       + COLUMN_LAST_UPDATE_DATE + " TEXT,"
                       + COLUMN_LAST_VALUE + " TEXT"
                       + ")";

       let CREATE_TABLE_SMARTLOGGER_CAPTURED: String =
               "CREATE TABLE IF NOT EXISTS " + TABLE_NAME_SMARTLOGGER_CAPTURED + "("
                       + COLUMN_AUTO_INCREMENT_ID + " INTEGER PRIMARY KEY AUTOINCREMENT,"
                       + COULUMN_GUID + " TEXT,"
                       + COLUMN_UNIQ_ID + " TEXT,"
                       + COLUMN_TYPE_ID + " TEXT,"
                       + COLUMN_CAPTURED_VALUE + " TEXT,"
                       + COLUMN_CAPTURED_DATE + " TEXT,"
                       + COLUMN_CREATE_TYPE + " TEXT,"
                       + COLUMN_IS_SYNC + " Bool"
                       + ")";


       //category and sub category lists
       let TABLE_NAME_CATEGORY: String = " tbl_category";
       let COULUMN_CATEGORY_ID: String = "cat_id";
       let COLUMN_CATEGORY_NAME: String = "cat_name";
       let COLUMN_SUB_ID: String = "cat_sub_id";
       let COLUMN_SUB_NAME: String = "cat_sub_name";
       let COLUMN_SUB_PRIORITY: String = "priority";
       let COLUMN_SLA_TIMER: String = "sla_timer";
       let CREATE_TABLE_CATEGORY_SUBCATEGORY: String =
               "CREATE TABLE IF NOT EXISTS " + TABLE_NAME_CATEGORY + "("
                       + COLUMN_AUTO_INCREMENT_ID + " INTEGER PRIMARY KEY AUTOINCREMENT,"
                       + COULUMN_CATEGORY_ID + " TEXT,"
                       + COLUMN_CATEGORY_NAME + " TEXT,"
                       + COLUMN_SUB_ID + " TEXT,"
                       + COLUMN_SUB_NAME + " TEXT,"
                       + COLUMN_SUB_PRIORITY + " TEXT,"
                       + COLUMN_SLA_TIMER + " TEXT"
                       + ")";

       //shift handover details
       let TABLE_NAME_SHIFTHANDONVER: String = " tbl_shift_handover";
       let COULUMN_SHIFT_GUID: String = "shift_guid";
       let COLUMN_SHIFT_TEAM_ID: String = "shift_team_id";
       let COLUMN_SHIFT_TEAM_NAME: String = "shift_team_name";
       let COLUMN_SHIFT_NOTES_ID: String = "shift_notes_id";
       let COLUMN_SHIFT_NOTES_NAME: String = "shift_notes_name";
       let COLUMN_SHIFT_FIELD_TYPE: String = "shift_field_type";
       let COLUMN_SHIFT_IS_ACCEPTED: String = "shift_is_accepted";
       let COLUMN_SHIFT_SYNC_STATUS: String = "is_sync";
       let COLUMN_SHIFT_IS_OFFLINE: String = "is_offline";
       let CREATE_TABLE_SHIFT_HANDOVER: String =
               "CREATE TABLE IF NOT EXISTS " + TABLE_NAME_SHIFTHANDONVER + "("
                       + COLUMN_AUTO_INCREMENT_ID + " INTEGER PRIMARY KEY AUTOINCREMENT,"
                       + COULUMN_SHIFT_GUID + " TEXT,"
                       + COLUMN_SHIFT_TEAM_ID + " TEXT,"
                       + COLUMN_SHIFT_TEAM_NAME + " TEXT,"
                       + COLUMN_SHIFT_NOTES_ID + " TEXT,"
                       + COLUMN_SHIFT_NOTES_NAME + " TEXT,"
                       + COLUMN_SHIFT_FIELD_TYPE + " TEXT,"
                       + COLUMN_SHIFT_IS_ACCEPTED + " Bool,"
                       + COLUMN_SHIFT_SYNC_STATUS + " Bool,"
                       + COLUMN_SHIFT_IS_OFFLINE + " Bool"
                       + ")";

       //last update value information
       let TABLE_NAME_LAST_UPDATE_VALUE: String = " tbl_last_update_data";
       let COULUMN_LAST_UPDATE_DATA_TIME: String = "last_update_date_time";
       let COULUMN_LAST_UPDATE_DATA_TIME_SPACE: String = "last_update_date_time_space";
       let COULUMN_LAST_UPDATE_DATE_TIME_CAT: String = "last_update_date_time_cat";
       let COULUMN_COMPANY_ID: String = "company_id";
       let CREATE_TABLE_LAST_UPDATE_VALUE: String =
               "CREATE TABLE IF NOT EXISTS " + TABLE_NAME_LAST_UPDATE_VALUE + "("
                       + COLUMN_AUTO_INCREMENT_ID + " INTEGER PRIMARY KEY AUTOINCREMENT,"
                       + COULUMN_LAST_UPDATE_DATA_TIME + " TEXT,"
                       + COULUMN_LAST_UPDATE_DATA_TIME_SPACE + " TEXT,"
                       + COULUMN_LAST_UPDATE_DATE_TIME_CAT + " TEXT,"
                       + COULUMN_COMPANY_ID + " INTEGER"
                       + ")";

       //space details
       let TABLE_NAME_SPACE_DETAILS: String = " tbl_space_details";
       let COULUMN_SPACEID: String = "space_id";
       let COULUMN_SPACESEQID: String = "space_seqid";
       let COULUMN_SPACENAME: String = "space_name";
       let COULUMN_SPACESHORT_CODE: String = "space_short_code";
       let COULUMN_SPACEDISPLAYNAME: String = "space_display_name";
       let COULUMN_SPACECATEGORYTYPE: String = "space_category_type";
       let COULUMN_SPACEPARENTID: String = "space_parent_id";
       let COULUMN_SPACEPARENTNAME: String = "space_parent_name";
        
       let COULUMN_SPACEMAINTENANCETEAMID: String = "space_maintenance_team_id";
       let COULUMN_SPACEMAINTENANCETEAM: String = "space_maintenance_team";
        let COULUMN_SPACEASSETCATEGORYID: String = "space_asset_category_id";
        let COULUMN_SPACEASSETCATEGORYNAME: String = "space_asset_category_name";
       let CREATE_TABLE_SPACE_DETAILS: String =
               "CREATE TABLE IF NOT EXISTS " + TABLE_NAME_SPACE_DETAILS + "("
                       + COLUMN_AUTO_INCREMENT_ID + " INTEGER PRIMARY KEY AUTOINCREMENT,"
                       + COULUMN_SPACEID + " INTEGER,"
                       + COULUMN_SPACESEQID + " INTEGER,"
                       + COULUMN_SPACENAME + " TEXT,"
                       + COULUMN_SPACESHORT_CODE + " TEXT,"
                       + COULUMN_SPACEDISPLAYNAME + " TEXT,"
                       + COULUMN_SPACECATEGORYTYPE + " TEXT,"
                       + COULUMN_SPACEPARENTID + " TEXT,"
                       + COULUMN_SPACEPARENTNAME + " TEXT,"
                       + COULUMN_SPACEMAINTENANCETEAMID + " TEXT,"
                       + COULUMN_SPACEMAINTENANCETEAM + " TEXT,"
                       + COULUMN_SPACEASSETCATEGORYID + " TEXT,"
                       + COULUMN_SPACEASSETCATEGORYNAME + " TEXT"
                       + ")";
        //creating table
        if(instanceOfUser.readStringData(key: "CREATE_TABLE_SPACE_DETAILS").isEmpty)
        {
            instanceOfUser.writeAnyData(key: "CREATE_TABLE_SPACE_DETAILS", value: CREATE_TABLE_SPACE_DETAILS)
        }
    if(instanceOfUser.readStringData(key: "CREATE_TABLE_ORDERS").isEmpty)
    {
        instanceOfUser.writeAnyData(key: "CREATE_TABLE_ORDERS", value: CREATE_TABLE_ORDERS)
    }
        if(instanceOfUser.readStringData(key: "CREATE_TABLE_UPLOAD").isEmpty)
        {
            instanceOfUser.writeAnyData(key: "CREATE_TABLE_UPLOAD", value: CREATE_TABLE_UPLOAD)
        }
        if(instanceOfUser.readStringData(key: "CREATE_TABLE_CHECKLIST").isEmpty)
        {
            instanceOfUser.writeAnyData(key: "CREATE_TABLE_CHECKLIST", value: CREATE_TABLE_CHECKLIST)
       }
        if(instanceOfUser.readStringData(key: "CREATE_TABLE_TIMESHEET").isEmpty)
        {
            instanceOfUser.writeAnyData(key: "CREATE_TABLE_TIMESHEET", value: CREATE_TABLE_TIMESHEET)
        }
        if(instanceOfUser.readStringData(key: "CREATE_TABLE_SMARTLOGGER").isEmpty)
        {
            instanceOfUser.writeAnyData(key: "CREATE_TABLE_SMARTLOGGER", value: CREATE_TABLE_SMARTLOGGER)
        }
        if(instanceOfUser.readStringData(key: "CREATE_TABLE_SMARTLOGGER_DETAILS").isEmpty)
        {
            instanceOfUser.writeAnyData(key: "CREATE_TABLE_SMARTLOGGER_DETAILS", value: CREATE_TABLE_SMARTLOGGER_DETAILS)
       }
       if(instanceOfUser.readStringData(key: "CREATE_TABLE_SMARTLOGGER_CAPTURED").isEmpty)
        {
            instanceOfUser.writeAnyData(key: "CREATE_TABLE_SMARTLOGGER_CAPTURED", value: CREATE_TABLE_SMARTLOGGER_CAPTURED)
        }
        if(instanceOfUser.readStringData(key: "CREATE_TABLE_CATEGORY_SUBCATEGORY").isEmpty)
        {
            instanceOfUser.writeAnyData(key: "CREATE_TABLE_CATEGORY_SUBCATEGORY", value: CREATE_TABLE_CATEGORY_SUBCATEGORY)
        }
        if(instanceOfUser.readStringData(key: "CREATE_TABLE_SHIFT_HANDOVER").isEmpty)
        {
            instanceOfUser.writeAnyData(key: "CREATE_TABLE_SHIFT_HANDOVER", value: CREATE_TABLE_SHIFT_HANDOVER)
       }
       if(instanceOfUser.readStringData(key: "CREATE_TABLE_LAST_UPDATE_VALUE").isEmpty)
        {
            instanceOfUser.writeAnyData(key: "CREATE_TABLE_LAST_UPDATE_VALUE", value: CREATE_TABLE_LAST_UPDATE_VALUE)
        }
    }
}
