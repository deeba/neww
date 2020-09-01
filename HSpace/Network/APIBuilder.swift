//
//  APIBuilder.swift
//  HelixSense
//
//  Created by DEEBA on 08.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation

class APIBuilder {
    
    private init() {
        
    }
    
    private static let SpaceAvailablez  =
    "api/v3/space/list/availability?space_id="
    private static let SpaceAvailablez2  =
    "&from_date="
    private static let SpaceAvailablez3  =
    "&to_date="
    private static let SpaceAvailablez4  =
    "&type="
    private static let shftLstAvail =
    "api/v3/shift/list/available?start_time="
    private static let BASE_URL = "https://demo.helixsense.com/"
    private static let WRITEreles = "api/call"
    private static let SEARCH =  "api/v2/isearch_read"
    private static let VALIDATIONCOUNT = "api/v2/read_group?groupby=[%22validation_status%22]&model=mro.equipment&domain=["
    private static let Userinformationz = "api/v3/userinformation"
    private static let AccessCheckz = "api/v3/access/check?site_id="
    private static let AccessCheckz2 = "&shift_id="
    private static let AccessCheckz3 = "&employee_id="
    private static let configurationz = "api/v3/configuration"
    private static let clseBkg =
    "api/v2/iread?fields=[%22id%22,%22planned_in%22,%22planned_out%22,%22shift_name%22,%22space_id%22,%22space_name%22,%22planned_status%22,%22shift_id%22]&model=mro.shift.employee&ids=["
    private static let tenantLst =
        "api/v2/iread?fields=[%22id%22,%22name%22,%22allow_onspot_space_booking%22,%22onspot_booking_grace_period%22,%22detect_mask%22,%22mask_mandatory%22,%22create_work_schedule%22,%22work_schedule_grace_period%22,%22require_attendance%22,%22attendance_with_face_detection%22,%22face_detection_mandatory%22,%22auto_release%22,%22auto_release_grace_period%22,%22generate_mor_after_release%22,%22require_checklist%22,%22check_list_ids%22,%22enable_report_covid_incident%22,%22ticket_category_id%22,%22sub_category_id%22,%22maintenance_team_id%22]&model=res.partner&ids=["
    private static let VALIDATIONCOUNT2 = "]&fields=[%22display_name%22]"
    private static let DISPLAYNAME = "[%22location_id%22,%22child_of%22,%22"
    private static let CREATEID = "api/create"
    private static let PrescreenURL = "api/v3/booking/update"
    private static let occpidURL = "api/v3/space/update"
    
    private static let cncel = "api/v3/booking/update"
    private static let WRITEDATA = "api/write"
    private static let spcz = "api/v2/call"
    private static let WRITEmaskDATA = "api/v2/write"
    private static let submtSymptomAnswers = "api/v3/prescreen/questionnaire/response/create"
    private static let SPACE = "api/v2/isearch_read"
    
    private static let crntShfty = "api/v2/call?method=get_current_employee_shift&model=mro.shift.employee"
      private static let crntSchedule = "api/v3/booking/currentschedule"
    private static let AVAILABLESPACE = "api/v3/space/list/availability?space_id=%@&from_date=%@&to_date=%@&type=2"
    private static let spaceIdBooked = "api/v4/booking?values={\"company_id\":%@,\"vendor_id\":%@,\"space_id\":%@,\"shift_id\":%@, \"planned_in\":\"%@\",\"planned_out\":\"%@\",\"employee_id\":%@}"
    private static let bkSPACE = "api/v2/call?model=mro.shift.employee&args=[{\"space_id\":%@,\"shift_id\":%@,\"start_time\":\"%@\"}]&method=create_shift_schedule"
    private static let Symptoms =
        "api/v3/prescreen/questionnaire/?ids=[%@]"
    private static let shftLst =
    "api/v2/call?method=get_current_shift_template&model=mro.shift.employee&args=[{\"start_time\":\"%@\"}]"
        private static let tenantLst2 = "]"
        private static let clseBkg2 = "]"
    static func SpaceListAvailable(space_id: String?,from_date: String?,to_date: String?,type: String?) -> String {
        let typ = "2"
        var data =  self.BASE_URL + String(format: self.SpaceAvailablez)
        data += (space_id!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? space_id)!
        data += self.SpaceAvailablez2
        data += (from_date!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? from_date)!
        data += self.SpaceAvailablez3
        data += (to_date!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? to_date)!
        data += self.SpaceAvailablez4
        data += (type!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? type)!
        data += typ
        return data
    }
    static func ShftListAvailable(datez: String?) -> String {
           var data =  self.BASE_URL + String(format: self.shftLstAvail)
           data += (datez!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? datez)!
           return data
       }
    static func search() -> String {
        return self.BASE_URL + self.SEARCH
    }
    static func getSpace() -> String {
           return self.BASE_URL + self.SPACE
       }
    static func spaceZ() -> String {
        return self.BASE_URL + self.spcz
    }
    static func validationCount(displayName: String?) -> String {
        var data = self.BASE_URL + self.VALIDATIONCOUNT
        if displayName != nil {
            data += DISPLAYNAME
            data += displayName!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? displayName!
            data += "%22]"
        }
        data += self.VALIDATIONCOUNT2
        
        print(data)
        return data
    }
    static func AccessCheck(siteId: String?,shftId: String?,empId: String?) -> String {
           var data = self.BASE_URL + AccessCheckz
            data += siteId!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? siteId!
           data += self.AccessCheckz2
        data += shftId!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? shftId!
           data += self.AccessCheckz3
        data += empId!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? empId!
           return data
       }
    static func Userinformation() -> String {
        let data = self.BASE_URL + self.Userinformationz
        return data
    }
    static func Configuration() -> String {
        let data = self.BASE_URL + self.configurationz
        return data
    }
    static func clsBookg(clsgId: String?) -> String {
         var data = self.BASE_URL + self.clseBkg
        data += (clsgId!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? clsgId)!
        data += "]"
        return data
    }
    static func getTenant(vndrId: String?) -> String {
         var data = self.BASE_URL + self.tenantLst
        
        data += (vndrId!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? vndrId)!
        data += "]"
        return data
    }
    static func submtSymptomAnswerz() -> String {
        return self.BASE_URL + self.submtSymptomAnswers
    }
    static func shtLsty() -> String {
        return self.BASE_URL + self.shftLst
    }
    static func WRITErelesz() -> String {
        return self.BASE_URL + self.WRITEreles
    }
    static func createID() -> String {
        return self.BASE_URL + self.CREATEID
    }
    static func clsgPrescreenURL() -> String {
        return self.BASE_URL + self.PrescreenURL
    }
    static func OccpiedURL() -> String {
        print(self.BASE_URL + self.occpidURL)
        return self.BASE_URL + self.occpidURL
    }
    static func writemskData() -> String {
        return self.BASE_URL + self.WRITEmaskDATA
    }
    static func cncl() -> String {
        return self.BASE_URL + self.cncel
    }
    static func writeData() -> String {
        return self.BASE_URL + self.WRITEDATA
    }
    static func getAvailableSpace(id: String,strt: String,endd: String) -> String {
        return (self.BASE_URL + String(format: self.AVAILABLESPACE, id,strt,endd))
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    static func SpaceIdBooked(compid: String,vndrId: String,spacId: String,shftId: String ,PlndIn: String,PlndOut: String,empId: String) -> String {
        return (self.BASE_URL + String(format: self.spaceIdBooked, compid,vndrId,spacId,shftId,PlndIn,PlndOut,empId))
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
    }
    static func getcrntShfty() -> String {
        return (self.BASE_URL + String(format: self.crntShfty))
    }
    static func getcrntSchedule() -> String {
           return (self.BASE_URL + String(format: self.crntSchedule))
       }
    static func getShftList(id: String) -> String {
        return (self.BASE_URL + String(format: self.shftLst, id))
        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    static func getSymptoms(chkLstid: String) -> String {
        return (self.BASE_URL + String(format: self.Symptoms, chkLstid))
        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    static func bkgSpace(id: String,shftId: String,strt: String) -> String {
        return (self.BASE_URL + String(format: self.bkSPACE, id,shftId,strt))
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
    }
    }
