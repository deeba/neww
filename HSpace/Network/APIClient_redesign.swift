//
//  APIClient_redesign.swift
//  HSpace
//
//  Created by DEEBA on 14.08.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
import Foundation
import  Alamofire
import  SwiftyJSON
enum HeaderTypez {
    case json
    case formUrlencoded
    case formData
}
class APIClient_redesign {
    var token : String?
   let interNt = Internt()
    let instanceOfUser = readWrite()
    private static var sharedNetworkManager: APIClient_redesign = {
                   let networkManager = APIClient_redesign()
                   return networkManager
               }()
               class func shared() -> APIClient_redesign {
                   return sharedNetworkManager
               }
               private init() { }
    func header(type: HeaderTypez? = nil, authorization: Bool = false) -> [String:String] {
        var header = [String:String]()
        switch type {
        case .json:
            header["Content-Type"] = "application/json"
        case .formData:
            header["Content-Type"] = "form-data"
        case .formUrlencoded:
            header["Content-Type"] = "application/x-www-form-urlencoded"
        default:
            break
        }
        if authorization {
            header["Authorization"] = "Bearer \(token ?? "")"
        }
        return header
    }
     func renewToken(_ result: Any?, completion: ((Bool) -> Void)? = nil) {
        if (result as? NSDictionary)?["code"] as? Int == 401 {
            getToken { status in
                completion?(status)
            }
        } else {
            completion?(false)
        }
    }
    func getSpaceListAvailable(space_id: String? = nil,from_date: String? = nil,to_date: String? = nil,type: String? = nil,completion: @escaping ([SpaceDetails]) -> Void) {
      var values = [SpaceDetails]()
      let headers = header(authorization: true)
      Alamofire.request(APIBuilder.SpaceListAvailable(space_id: space_id,from_date: from_date,to_date:to_date ,type:type ), method: .get, headers: headers)
      .responseJSON { response in
          if response.data != nil {
          do {
              let jsonc = try JSON(data: response.data!)
             let title = jsonc["data"]
             if (title.count > 0)
                    {
                      for i in 0..<title.count {
                        let str = ""
                        values.append(SpaceDetails.init(id: String(title[i]["id"].intValue),
                                    name: title[i]["space_name"].stringValue,
                                    displayName: str,
                                    type: title[i]["asset_categ_type"].stringValue,
                                    pathname: title[i]["path_name"].stringValue,
                                    countt: String(title[i]["count"].intValue), statts: title[i]["status"].stringValue, employeeid: title[i]["employee_id"].stringValue, employeeName: title[i]["employee_name"].stringValue, availablestatus: String(title[i]["available_status"].boolValue),
                                    haveChilds: title[i]["is_parent"].boolValue))
                  }
            }

            completion(values)
               }
            catch let error as NSError {
                completion([])
               print("Failed to load: \(error.localizedDescription)")
            }
          }
      }
              }
    func putPrescreenDon(Tkn:String,completion: @escaping (Bool) -> Void) {
        let idy =  curntSchedulModll.id
        let  ids1 = "&ids=["
        //  let  stringRole5 = "&model=hr.attendance"
        let  stringRole2 = "&values="
        let stringFields1 = """
        {"prescreen_status":true}
        """
        let    offsetFields2 = """
        ]
        """
        let    stringFields =  "\(String(describing:stringRole2))\(stringFields1)\(String(describing: ids1))\(idy)\(String(describing:offsetFields2))"
        let combinedOffset = "\(stringFields)"
        let varRole = "\(String(describing: combinedOffset))"
        let url = NSURL(string: APIBuilder.clsgPrescreenURL()) //Remember to put ATS exception if the URL is not https
      let request = NSMutableURLRequest(url: url! as URL)
      let string1 = "Bearer "
      let string2 = instanceOfUser.readStringData(key: "accessTokenz")
      let combined2 = "\(string1) \(String(describing: string2))"

      request.addValue(combined2, forHTTPHeaderField: "Authorization")
      request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //Optional

      request.httpMethod = "PUT"
      let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
      let data = varRole.data(using: String.Encoding.utf8)
      request.httpBody = data


      let task1 = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
      guard let data = data else {
      print(String(describing: error))
      return
      }
      do {

      let jsonStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
      
      let nwFlds = """
      "data": true
      """
      let varstts =  jsonStr?.contains("\(String(describing: nwFlds))") ?? false

      if varstts
      {


      }

      }

      }

                   
            task1.resume()

            }
    func putOccpied(Tkn:String,completion: @escaping (Bool) -> Void) {
        let idy =  curntSchedulModll.space_id
        let  ids1 = "&ids=["
        //  let  stringRole5 = "&model=hr.attendance"
        let  stringRole2 = "&values="
        let stringFields1 = """
        {"space_status":"Occupied"}
        """
        let    offsetFields2 = """
        ]
        """
        let    stringFields =  "\(String(describing:stringRole2))\(stringFields1)\(String(describing: ids1))\(idy)\(String(describing:offsetFields2))"
        let combinedOffset = "\(stringFields)"
        let varRole = "\(String(describing: combinedOffset))"
        let url = NSURL(string: APIBuilder.OccpiedURL()) //Remember to put ATS exception if the URL is not https
      let request = NSMutableURLRequest(url: url! as URL)
      let string1 = "Bearer "
      let string2 = instanceOfUser.readStringData(key: "accessTokenz")
      let combined2 = "\(string1) \(String(describing: string2))"

      request.addValue(combined2, forHTTPHeaderField: "Authorization")
      request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //Optional

      request.httpMethod = "PUT"
      let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
      let data = varRole.data(using: String.Encoding.utf8)
      request.httpBody = data


      let task1 = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
      guard let data = data else {
      print(String(describing: error))
      return
      }
      do {

      let jsonStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
      
      let nwFlds = """
      "data": true
      """
      let varstts =  jsonStr?.contains("\(String(describing: nwFlds))") ?? false

      if varstts
      {


      }

      }

      }

                   
            task1.resume()

            }
        func getUserRepo(completion: @escaping ([repoUser]) -> Void) {
        var values = [repoUser]()
        let headers = header(authorization: true)
            Alamofire.request(userInfo_URL, method: .get, headers: headers)
            .responseJSON { response in
                if response.data != nil {
                do {
                    let jsonc = try JSON(data: response.data!)
                              values.append(repoUser( company_name: jsonc["company_name"].stringValue ,employee_name: jsonc["employee_name"].stringValue,username:jsonc["username"].stringValue, company_id:jsonc["company_id"].int!,employee_id: jsonc["employee_id"].int!, usrId: jsonc["sub"].int!))
                              usrInfoModl.compId = jsonc["company_id"].int!
                              usrInfoModl.compName = jsonc["company_name"].stringValue
                              usrInfoModl.employee_id = jsonc["employee_id"].int!
                              usrInfoModl.empName = jsonc["employee_name"].stringValue
                              usrInfoModl.usrId = jsonc["sub"].int!
                              usrInfoModl.userName = jsonc["username"].stringValue
                              self.instanceOfUser.writeAnyData(key: "UsrId", value: jsonc["sub"].int!)
                  completion(values)
                     }
                  catch let error as NSError {
                      completion([])
                     print("Failed to load: \(error.localizedDescription)")
                  }
                }
            }
        }
    func getShftListAvailable(completion: @escaping ([repoShft]) -> Void) {
        var values = [repoShft]()
        availableshftListModl.duration.removeAll()
        availableshftListModl.id.removeAll()
        availableshftListModl.name.removeAll()
        availableshftListModl.planned_in.removeAll()
        availableshftListModl.planned_out.removeAll()
        availableshftListModl.start_time.removeAll()
        availableshftListModl.ttlDis.removeAll()
        let dateFormatter1 : DateFormatter = DateFormatter()
        let dateFormatter : DateFormatter = DateFormatter()
         //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
         dateFormatter1.dateFormat = "dd-MM-yyyy HH:mm:ss"
         let date = Date()
         let dateString = dateFormatter.string(from: date)

        let lstDatetime = interNt.convertToUTC(dateToConvert: dateString)
       let trimmed1 =  lstDatetime.trimmingCharacters(in: .whitespacesAndNewlines)
      //  let trimmed1 =   "2020-08-21 08:18:02"
      let headers = header(authorization: true)
      Alamofire.request(APIBuilder.ShftListAvailable(datez:trimmed1), method: .get, headers: headers)
      .responseJSON { response in
          if response.data != nil {
          do {
              let jsonc = try JSON(data: response.data!)
             // let title = jsonc["data"][0]["name"].stringValue
             //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
             let title = jsonc["data"]
             if (title.count > 0)
                    {
                    for i in 0..<title.count {

                        values.append(repoShft(name: title[i]["name"].stringValue ,planned_in: title[i]["planned_in"].stringValue,planned_out:title[i]["planned_out"].stringValue,ttl:"Shift " + title[i]["name"].stringValue + "(" + title[i]["planned_in"].stringValue + "-" + title[i]["planned_out"].stringValue + ")",id: title[i]["id"].intValue, start_time: title[i]["start_time"].doubleValue,duration: title[i]["duration"].doubleValue ))
                        availableshftListModl.duration.append(title[i]["duration"].doubleValue)
                        availableshftListModl.id.append(title[i]["id"].intValue)
                        availableshftListModl.name.append(title[i]["name"].stringValue)
                        availableshftListModl.planned_in.append(title[i]["planned_in"].stringValue)
                        availableshftListModl.planned_out.append(title[i]["planned_out"].stringValue)
                        availableshftListModl.start_time.append(title[i]["start_time"].doubleValue)
                        let inptDte = self.interNt.convertToLocal(incomingFormat: title[i]["planned_in"].stringValue)
                        let arrsplit = inptDte.components(separatedBy: " ")
                        
                        let outptDte = self.interNt.convertToLocal(incomingFormat: title[i]["planned_out"].stringValue)
                         let arrsplitOut = outptDte.components(separatedBy: " ")
                        availableshftListModl.ttlDis.append("Shift " + title[i]["name"].stringValue + "(" + title[i]["planned_in"].stringValue + "-" + title[i]["planned_out"].stringValue + ")")
                     //for
                            
                        }
                      //if
                        
            }
           completion(values)
                         }
                      catch let error as NSError {
                          completion([])
                         print("Failed to load: \(error.localizedDescription)")
                      }
                    }
                }
            }
    
    func postSymptomsLst(chkLst_id: String? = nil,completion: @escaping ([symptmsChecklist]) -> Void) {
       let headers = header(authorization: true)
        AFWrapper.getRequest(APIBuilder.getSymptoms(chkLstid:chkLst_id!), headers: headers, success: { (result) in
       // LoaderSpin.shared.showLoader()
            if let data = (result as? NSDictionary)?["data"] as? NSArray {
                var values = [symptmsChecklist]()
                for i in data {
                    if let dic = i as? NSDictionary {
                        values.append(symptmsChecklist(symptmsType:dic["type"]  as! String, question: dic["display_name"] as! String, answer: "no", symptmsId: dic["id"] as! Int,syncStatus: 0))
                       
                       
                    }
                                        }
                                        completion(values)
                                    }
                                 //  self.renewToken(result)
                                }) { (error) in
                                    print(error.debugDescription)
                                    completion([])
                                }
                            }
    func getCurrentSchedule_new(completion: @escaping (Bool) -> Void){
       let headers = header(authorization: true)
       AFWrapper.getRequest(APIBuilder.getcrntSchedule(), headers: headers, success: { (result) in
       // LoaderSpin.shared.showLoader()
            if let data = (result as? NSDictionary)?["data"] as? NSArray {
                for i in data {
                    if let dic = i as? NSDictionary {
                        curntSchedulModll.access_status = (dic["access_status"] != nil)
                        curntSchedulModll.actual_in = (dic["actual_in"] != nil)
                        curntSchedulModll.actual_out = (dic["actual_out"] != nil)
                        print(dic["employee_id"] as? String as Any)
                        if (dic["employee_id"] as? String) != nil {
                        curntSchedulModll.employee_id = (dic["employee_id"]!) as! Int
                        }
                        
                        if (dic["id"] as? String) != nil {
                        curntSchedulModll.id = (dic["id"]!) as! Int
                        }
                        curntSchedulModll.planned_in = "\(dic["planned_in"] ?? "")"
                        curntSchedulModll.planned_out = "\(dic["planned_out"] ?? "")"
                        curntSchedulModll.planned_status = "\(dic["planned_status"] ?? "")"
                        curntSchedulModll.prescreen_status = (dic["prescreen_status"] != nil)
                        
                        if (dic["shift_id"] as? String) != nil {
                        curntSchedulModll.shift_id = (dic["shift_id"]!) as! Int
                        }
                        curntSchedulModll.shift_name = "\(dic["shift_name"] ?? "")"
                        if (dic["space_id"] as? String) != nil {
                            curntSchedulModll.space_id = (dic["space_id"]!) as! Int
                        }
                        curntSchedulModll.space_name = "\(dic["space_name"] ?? "")"
                        curntSchedulModll.space_number = "\(dic["space_number"] ?? "")"
                        curntSchedulModll.space_path_name = "\(dic["space_path_name"] ?? "")"
                        curntSchedulModll.space_status = "\(dic["space_status"] ?? "")"
                        curntSchedulModll.user_defined = (dic["user_defined"] != nil)
                        if (dic["working_hours"] as? String) != nil {
                        curntSchedulModll.working_hours = (dic["working_hours"]!) as! Double
                        }
                        completion(true)
                        return
                    }
                                        }

                               
                                    }
                     completion(false)
                    
                                 //  self.renewToken(result)
                                }) { (error) in
                                    print(error.debugDescription)
                                    completion(false)
                                }
                            }
                            
    func getCurrentSchedule(completion: @escaping ([repoCrntSchedul]) -> Void) {
        var values = [repoCrntSchedul]()
        /*
        curntSchedulModll.access_status = false
        curntSchedulModll.actual_in = false
        curntSchedulModll.actual_out = false
        curntSchedulModll.employee_id = 0
        curntSchedulModll.id = 0
        curntSchedulModll.planned_in = ""
        curntSchedulModll.planned_out = ""
        curntSchedulModll.planned_status = ""
        curntSchedulModll.prescreen_status = false
        curntSchedulModll.shift_id = 0
        curntSchedulModll.shift_name = ""
        curntSchedulModll.space_id = 0
        curntSchedulModll.space_name = ""
        curntSchedulModll.space_number = ""
        curntSchedulModll.space_path_name = ""
        curntSchedulModll.space_status = ""
        curntSchedulModll.user_defined = false
        curntSchedulModll.working_hours = 0.0
 */
    var statuz = false
    let headers = header(authorization: true)
    // LoaderSpin.shared.showLoader()
    Alamofire.request(APIBuilder.getcrntSchedule(), method: .get, headers: headers)
    .responseJSON { response in
        if response.data != nil {
        do {
            let jsonc = try JSON(data: response.data!)
           // let title = jsonc["data"][0]["name"].stringValue
           //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
           let title = jsonc["data"]
           if (title.count > 0)
           {
            values.append(repoCrntSchedul(access_status: title[0]["access_status"].boolValue ,actual_in: title[0]["actual_in"].boolValue,actual_out:title[0]["actual_out"].boolValue,prescreen_status: title[0]["prescreen_status"].boolValue ,user_defined: title[0]["user_defined"].boolValue, employee_id: title[0]["employee_id"].intValue,id: title[0]["id"].intValue ,
            shift_id: title[0]["shift_id"].intValue ,space_id: title[0]["space_id"].intValue,planned_in:title[0]["planned_in"].stringValue,planned_out: title[0]["planned_out"].stringValue ,planned_status: title[0]["planned_status"].stringValue, shift_name: title[0]["shift_name"].stringValue,space_name: title[0]["space_name"].stringValue
            ,   space_number: title[0]["space_number"].stringValue ,space_path_name: title[0]["space_path_name"].stringValue,space_status:title[0]["space_status"].stringValue,working_hours: title[0]["working_hours"].doubleValue
            ))
            statuz = true
           /* curntSchedulModll.access_status = title[0]["access_status"].boolValue
            curntSchedulModll.actual_in = title[0]["actual_in"].boolValue
            curntSchedulModll.actual_out = title[0]["actual_out"].boolValue
            curntSchedulModll.employee_id = title[0]["employee_id"].intValue
            curntSchedulModll.id = title[0]["id"].intValue
            curntSchedulModll.planned_in = title[0]["planned_in"].stringValue
            curntSchedulModll.planned_out = title[0]["planned_out"].stringValue
            curntSchedulModll.planned_status = title[0]["planned_status"].stringValue
            curntSchedulModll.prescreen_status = title[0]["prescreen_status"].boolValue
            curntSchedulModll.shift_id = title[0]["shift_id"].intValue
            curntSchedulModll.shift_name = title[0]["shift_name"].stringValue
            curntSchedulModll.space_id = title[0]["space_id"].intValue
            curntSchedulModll.space_name = title[0]["space_name"].stringValue
            curntSchedulModll.space_number = title[0]["space_number"].stringValue
            curntSchedulModll.space_path_name = title[0]["space_path_name"].stringValue
            curntSchedulModll.space_status = title[0]["space_status"].stringValue
            curntSchedulModll.user_defined = title[0]["user_defined"].boolValue
            curntSchedulModll.working_hours = title[0]["working_hours"].doubleValue
 */
            }
            else
           {
            statuz = false
            }
            completion(values)
         // LoaderSpin.shared.hideLoader()
             }
          catch let error as NSError {
            completion([])
             print("Failed to load: \(error.localizedDescription)")
          }
        }
    }

        }
    func getConfiguration(completion: @escaping ([repoConfgrn]) -> Void) {
        var values = [repoConfgrn]()
        configurationModls.access_type = ""
       configurationModls.enable_access = false
       configurationModls.skip_occupy = false
       configurationModls.attendance_source = ""
       configurationModls.attendance_with_face_detection = false
       configurationModls.require_attendance = false
       configurationModls.allow_onspot_space_booking = false
       configurationModls.book_from_outlook = false
       configurationModls.create_work_schedule = false
       configurationModls.onspot_booking_grace_period = 0
       configurationModls.show_occupant = false
       configurationModls.work_schedule_grace_period = 0
       configurationModls.building_id = 0
       configurationModls.building_name =  ""
       configurationModls.conference_room_space_id = 0
       configurationModls.conference_room_space_name = ""
       configurationModls.conference_room_sub_type_id = 0
       configurationModls.conference_room_sub_type_name = ""
           configurationModls.office_room_space_id = 0
           configurationModls.office_room_space_name = ""
       configurationModls.office_room_sub_type_id = 0
       configurationModls.office_room_sub_type_name = ""
       configurationModls.workstation_space_id = 0
       configurationModls.workstation_space_name = ""
       configurationModls.workstation_sub_type_id = 0
       configurationModls.workstation_sub_type_name = ""
       configurationModls.allow_after_non_compliance = false
        configurationModls.allowed_occupancy_per  = 0.0
       configurationModls.enable_landing_page_id = 0
       configurationModls.enable_landing_page_name = ""
       configurationModls.enable_other_resources_id = 0
       configurationModls.enable_other_resources_name = ""
       configurationModls.enable_other_resources_url = ""
       configurationModls.enable_report_covid_incident = false
       configurationModls.enable_screening = false
       configurationModls.enable_workspace_instruction_id = 0
       configurationModls.enable_workspace_instruction_name = ""
       configurationModls.help_line_id = 0
       configurationModls.help_line_mobile = ""
       configurationModls.help_line_name = ""
       configurationModls.maintenance_team_id = 0
       configurationModls.maintenance_team_name = ""
       configurationModls.safety_resources_id = 0
       configurationModls.safety_resources_name = ""
       configurationModls.safety_resources_url = ""
       configurationModls.sub_category_id = 0
       configurationModls.sub_category_name = ""
       configurationModls.ticket_category_id = 0
       configurationModls.ticket_category_name =  ""
       configurationModls.title = ""
       configurationModls.detect_mask = false
       configurationModls.face_detection_mandatory = false
       configurationModls.mask_mandatory = false
        configurationModls.prerelease_period   = 0.0
       configurationModls.prerelease_required = false
       configurationModls.check_list_ids = 0
       configurationModls.check_list_name = ""
       configurationModls.enable_prescreen = false
       configurationModls.prescreen_is_manadatory = false
        configurationModls.prescreen_period = 0.0
       configurationModls.require_checklist = false
       configurationModls.auto_release = false
       configurationModls.auto_release_grace_period = 0
       configurationModls.generate_mor_after_release = false
      let headers = header(authorization: true)
       // LoaderSpin.shared.showLoader()
      Alamofire.request(APIBuilder.Configuration(), method: .get, headers: headers)
      .responseJSON { response in
          if response.data != nil {
          do {
              let jsonc = try JSON(data: response.data!)
             // let title = jsonc["data"][0]["name"].stringValue
             //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
             let title = jsonc["data"]
             if (title.count > 0)
                    {
                        var offic_rm_sp_id = 0
                        var offic_rm_sp_nam = ""
                        if jsonc["data"]["Building"]["office_room_space_id"].isEmpty == false
                        {
                            offic_rm_sp_id = jsonc["data"]["Building"]["office_room_space_id"]["id"].int!
                            offic_rm_sp_nam = jsonc["data"]["Building"]["office_room_space_id"]["name"].stringValue
                        }
                        values.append(repoConfgrn(
                            enable_access: title[0]["enable_access"].boolValue, skip_occupy:jsonc["data"]["Access"]["skip_occupy"].boolValue,attendance_with_face_detection:jsonc["data"]["Attendance"]["attendance_with_face_detection"].boolValue,
                            require_attendance:jsonc["data"]["Attendance"]["require_attendance"].boolValue,allow_onspot_space_booking:jsonc["data"]["Booking"]["allow_onspot_space_booking"].boolValue,book_from_outlook:jsonc["data"]["Booking"]["book_from_outlook"].boolValue,create_work_schedule:jsonc["data"]["Booking"]["create_work_schedule"].boolValue,show_occupant:jsonc["data"]["Booking"]["show_occupant"].boolValue,allow_after_non_compliance:jsonc["data"]["Covid"]["allow_after_non_compliance"].boolValue,enable_report_covid_incident:jsonc["data"]["Covid"]["enable_report_covid_incident"].boolValue,enable_screening:jsonc["data"]["Covid"]["enable_screening"].boolValue,detect_mask:jsonc["data"]["Occupy"]["detect_mask"].boolValue,face_detection_mandatory:jsonc["data"]["Occupy"]["face_detection_mandatory"].boolValue,mask_mandatory:jsonc["data"]["Occupy"]["mask_mandatory"].boolValue,prerelease_required:jsonc["data"]["Prerelease"]["prerelease_required"].boolValue,enable_prescreen:jsonc["data"]["Prescreen"]["enable_prescreen"].boolValue,prescreen_is_manadatory:jsonc["data"]["Prescreen"]["prescreen_is_manadatory"].boolValue,require_checklist:jsonc["data"]["Prescreen"]["require_checklist"].boolValue,auto_release:jsonc["data"]["Release"]["auto_release"].boolValue,generate_mor_after_release:jsonc["data"]["Release"]["generate_mor_after_release"].boolValue
                            ,onspot_booking_grace_period:jsonc["data"]["Booking"]["onspot_booking_grace_period"].int!,work_schedule_grace_period:jsonc["data"]["Booking"]["work_schedule_grace_period"].int!,building_id:jsonc["data"]["Building"]["building_ids"][0]["id"].int!,conference_room_space_id:jsonc["data"]["Building"]["conference_room_space_id"]["id"].int!,conference_room_sub_type_id:jsonc["data"]["Building"]["conference_room_sub_type_id"]["id"].int!,office_room_space_id:offic_rm_sp_id,office_room_sub_type_id:jsonc["data"]["Building"]["office_room_sub_type_id"]["id"].int!,workstation_space_id:jsonc["data"]["Building"]["workstation_space_id"]["id"].int!,workstation_sub_type_id:jsonc["data"]["Building"]["workstation_sub_type_id"]["id"].int!,enable_landing_page_id:jsonc["data"]["Covid"]["enable_landing_page_id"]["id"].int!,enable_other_resources_id:jsonc["data"]["Covid"]["enable_other_resources_id"]["id"].int!,enable_workspace_instruction_id:jsonc["data"]["Covid"]["enable_workspace_instruction_id"]["id"].int!,help_line_id:jsonc["data"]["Covid"]["help_line_id"]["id"].int!,maintenance_team_id:jsonc["data"]["Covid"]["maintenance_team_id"]["id"].int!,safety_resources_id:jsonc["data"]["Covid"]["safety_resources_id"]["id"].int!,sub_category_id:jsonc["data"]["Covid"]["sub_category_id"]["id"].int!,ticket_category_id:jsonc["data"]["Covid"]["ticket_category_id"]["id"].int!,check_list_ids:jsonc["data"]["Prescreen"]["check_list_ids"][0]["id"].int!,auto_release_grace_period:jsonc["data"]["Release"]["auto_release_grace_period"].int!
                            ,
                             access_type:jsonc["data"]["Access"]["access_type"].stringValue,attendance_source:jsonc["data"]["Attendance"]["attendance_source"].stringValue,building_name:jsonc["data"]["Building"]["building_ids"][0]["name"].stringValue,
                             conference_room_space_name:jsonc["data"]["Building"]["conference_room_space_id"]["name"].stringValue,conference_room_sub_type_name:jsonc["data"]["Building"]["conference_room_sub_type_id"]["name"].stringValue,office_room_space_name:offic_rm_sp_nam,
                             office_room_sub_type_name:jsonc["data"]["Building"]["office_room_sub_type_id"]["name"].stringValue,workstation_space_name:jsonc["data"]["Building"]["workstation_space_id"]["name"].stringValue,workstation_sub_type_name:jsonc["data"]["Building"]["workstation_sub_type_id"]["name"].stringValue,enable_landing_page_name:jsonc["data"]["Covid"]["enable_landing_page_id"]["name"].stringValue,enable_other_resources_name:jsonc["data"]["Covid"]["enable_other_resources_id"]["name"].stringValue,enable_other_resources_url:jsonc["data"]["Covid"]["enable_other_resources_id"]["url"].stringValue,enable_workspace_instruction_name:jsonc["data"]["Covid"]["enable_workspace_instruction_id"]["name"].stringValue,help_line_mobile:jsonc["data"]["Covid"]["help_line_id"]["mobile"].stringValue,help_line_name:jsonc["data"]["Covid"]["help_line_id"]["name"].stringValue,maintenance_team_name:jsonc["data"]["Covid"]["maintenance_team_id"]["name"].stringValue,safety_resources_name:jsonc["data"]["Covid"]["safety_resources_id"]["name"].stringValue,safety_resources_url:jsonc["data"]["Covid"]["safety_resources_id"]["url"].stringValue,sub_category_name:jsonc["data"]["Covid"]["sub_category_id"]["name"].stringValue,ticket_category_name:jsonc["data"]["Covid"]["ticket_category_id"]["name"].stringValue,title:jsonc["data"]["Covid"]["title"].stringValue,check_list_name:jsonc["data"]["Prescreen"]["check_list_ids"][0]["name"].stringValue,
                             allowed_occupancy_per:jsonc["data"]["Covid"]["allowed_occupancy_per"].doubleValue,prerelease_period:jsonc["data"]["prerelease"]["prerelease_period"].doubleValue,prescreen_period:jsonc["data"]["Prescreen"]["prescreen_period"].doubleValue
                        
                        ))
                        configurationModls.access_type = jsonc["data"]["Access"]["access_type"].stringValue
                        configurationModls.enable_access = jsonc["data"]["Access"]["enable_access"].boolValue
                        configurationModls.skip_occupy = jsonc["data"]["Access"]["skip_occupy"].boolValue
                        configurationModls.attendance_source = jsonc["data"]["Attendance"]["attendance_source"].stringValue
                        configurationModls.attendance_with_face_detection = jsonc["data"]["Attendance"]["attendance_with_face_detection"].boolValue
                        configurationModls.require_attendance = jsonc["data"]["Attendance"]["require_attendance"].boolValue
                        configurationModls.allow_onspot_space_booking = jsonc["data"]["Booking"]["allow_onspot_space_booking"].boolValue
                        configurationModls.book_from_outlook = jsonc["data"]["Booking"]["book_from_outlook"].boolValue
                        configurationModls.create_work_schedule = jsonc["data"]["Booking"]["create_work_schedule"].boolValue
                        configurationModls.onspot_booking_grace_period = jsonc["data"]["Booking"]["onspot_booking_grace_period"].int!
                        configurationModls.show_occupant = jsonc["data"]["Booking"]["show_occupant"].boolValue
                        configurationModls.work_schedule_grace_period = jsonc["data"]["Booking"]["work_schedule_grace_period"].int!
                        configurationModls.building_id = jsonc["data"]["Building"]["building_ids"][0]["id"].int!
                        configurationModls.building_name =  jsonc["data"]["Building"]["building_ids"][0]["name"].stringValue
                        configurationModls.conference_room_space_id = jsonc["data"]["Building"]["conference_room_space_id"]["id"].int!
                        configurationModls.conference_room_space_name = jsonc["data"]["Building"]["conference_room_space_id"]["name"].stringValue
                        configurationModls.conference_room_sub_type_id = jsonc["data"]["Building"]["conference_room_sub_type_id"]["id"].int!
                        configurationModls.conference_room_sub_type_name = jsonc["data"]["Building"]["conference_room_sub_type_id"]["name"].stringValue
                        if jsonc["data"]["Building"]["office_room_space_id"].isEmpty == false
                        {
                            configurationModls.office_room_space_id = jsonc["data"]["Building"]["office_room_space_id"]["id"].int!
                            configurationModls.office_room_space_name = jsonc["data"]["Building"]["office_room_space_id"]["name"].stringValue
                        }
                        configurationModls.office_room_sub_type_id = jsonc["data"]["Building"]["office_room_sub_type_id"]["id"].int!
                        configurationModls.office_room_sub_type_name = jsonc["data"]["Building"]["office_room_sub_type_id"]["name"].stringValue
                        configurationModls.workstation_space_id = jsonc["data"]["Building"]["workstation_space_id"]["id"].int!
                        configurationModls.workstation_space_name = jsonc["data"]["Building"]["workstation_space_id"]["name"].stringValue
                        configurationModls.workstation_sub_type_id = jsonc["data"]["Building"]["workstation_sub_type_id"]["id"].int!
                        configurationModls.workstation_sub_type_name = jsonc["data"]["Building"]["workstation_sub_type_id"]["name"].stringValue
                        configurationModls.allow_after_non_compliance = jsonc["data"]["Covid"]["allow_after_non_compliance"].boolValue
                        configurationModls.allowed_occupancy_per  = jsonc["data"]["Covid"]["allowed_occupancy_per"].doubleValue
                        configurationModls.enable_landing_page_id = jsonc["data"]["Covid"]["enable_landing_page_id"]["id"].int!
                        configurationModls.enable_landing_page_name = jsonc["data"]["Covid"]["enable_landing_page_id"]["name"].stringValue
                        configurationModls.enable_other_resources_id = jsonc["data"]["Covid"]["enable_other_resources_id"]["id"].int!
                        configurationModls.enable_other_resources_name = jsonc["data"]["Covid"]["enable_other_resources_id"]["name"].stringValue
                        configurationModls.enable_other_resources_url = jsonc["data"]["Covid"]["enable_other_resources_id"]["url"].stringValue
                        configurationModls.enable_report_covid_incident = jsonc["data"]["Covid"]["enable_report_covid_incident"].boolValue
                        configurationModls.enable_screening = jsonc["data"]["Covid"]["enable_screening"].boolValue
                        configurationModls.enable_workspace_instruction_id = jsonc["data"]["Covid"]["enable_workspace_instruction_id"]["id"].int!
                        configurationModls.enable_workspace_instruction_name = jsonc["data"]["Covid"]["enable_workspace_instruction_id"]["name"].stringValue
                        configurationModls.help_line_id = jsonc["data"]["Covid"]["help_line_id"]["id"].int!
                        configurationModls.help_line_mobile = jsonc["data"]["Covid"]["help_line_id"]["mobile"].stringValue
                        configurationModls.help_line_name = jsonc["data"]["Covid"]["help_line_id"]["name"].stringValue
                        configurationModls.maintenance_team_id = jsonc["data"]["Covid"]["maintenance_team_id"]["id"].int!
                        configurationModls.maintenance_team_name = jsonc["data"]["Covid"]["maintenance_team_id"]["name"].stringValue
                        configurationModls.safety_resources_id = jsonc["data"]["Covid"]["safety_resources_id"]["id"].int!
                        configurationModls.safety_resources_name = jsonc["data"]["Covid"]["safety_resources_id"]["name"].stringValue
                        configurationModls.safety_resources_url = jsonc["data"]["Covid"]["safety_resources_id"]["url"].stringValue
                        configurationModls.sub_category_id = jsonc["data"]["Covid"]["sub_category_id"]["id"].int!
                        configurationModls.sub_category_name = jsonc["data"]["Covid"]["sub_category_id"]["name"].stringValue
                        configurationModls.ticket_category_id = jsonc["data"]["Covid"]["ticket_category_id"]["id"].int!
                        configurationModls.ticket_category_name =  jsonc["data"]["Covid"]["ticket_category_id"]["name"].stringValue
                        configurationModls.title = jsonc["data"]["Covid"]["title"].stringValue
                        configurationModls.detect_mask = jsonc["data"]["Occupy"]["detect_mask"].boolValue
                        configurationModls.face_detection_mandatory = jsonc["data"]["Occupy"]["face_detection_mandatory"].boolValue
                        configurationModls.mask_mandatory = jsonc["data"]["Occupy"]["mask_mandatory"].boolValue
                        configurationModls.prerelease_period   = jsonc["data"]["prerelease"]["prerelease_period"].doubleValue
                        configurationModls.prerelease_required = jsonc["data"]["Prerelease"]["prerelease_required"].boolValue
                        configurationModls.check_list_ids = jsonc["data"]["Prescreen"]["check_list_ids"][0]["id"].int!
                        configurationModls.check_list_name = jsonc["data"]["Prescreen"]["check_list_ids"][0]["name"].stringValue
                        configurationModls.enable_prescreen = jsonc["data"]["Prescreen"]["enable_prescreen"].boolValue
                        configurationModls.prescreen_is_manadatory = jsonc["data"]["Prescreen"]["prescreen_is_manadatory"].boolValue
                        configurationModls.prescreen_period = jsonc["data"]["Prescreen"]["prescreen_period"].doubleValue
                        configurationModls.require_checklist = jsonc["data"]["Prescreen"]["require_checklist"].boolValue
                        configurationModls.auto_release = jsonc["data"]["Release"]["auto_release"].boolValue
                        configurationModls.auto_release_grace_period = jsonc["data"]["Release"]["auto_release_grace_period"].int!
                        configurationModls.generate_mor_after_release = jsonc["data"]["Release"]["generate_mor_after_release"].boolValue
                        
                      }
            completion(values)
         //   LoaderSpin.shared.hideLoader()
               }
            catch let error as NSError {
                completion([])
               print("Failed to load: \(error.localizedDescription)")
            }
          }
      }
              }
    func getTokenz(completion: @escaping (Bool) -> Void) {
                           var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/authentication/oauth2/token")!,timeoutInterval: Double.infinity)
              request.httpMethod = "POST"
              let postData = NSMutableData(data: "grant_type=password".data(using: String.Encoding.utf8)!)
              let stringDomain1 = "&username="
              let varDomain = "\(stringDomain1)\(String(describing:self.instanceOfUser.readStringData(key: "Userz")))"
              let stringDomain2 = "&password="
              let varDomain2 = "\(stringDomain2)\(String(describing:self.instanceOfUser.readStringData(key: "Pwdz")))"
              postData.append("&client_id=clientkey".data(using: String.Encoding.utf8)!)
              postData.append("&client_secret=clientsecret".data(using: String.Encoding.utf8)!)
              let trimmed1 = varDomain.trimmingCharacters(in: .whitespacesAndNewlines)
              let trimmed2 = varDomain2.trimmingCharacters(in: .whitespacesAndNewlines)
              postData.append(trimmed1.data(using: String.Encoding.utf8)!)
              postData.append(trimmed2.data(using: String.Encoding.utf8)!)
              request.httpMethod = "POST"
              request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
              request.setValue("application/json", forHTTPHeaderField: "Accept")
              request.httpBody = postData as Data
              let task = URLSession.shared.dataTask(with: request as URLRequest){
                    data, response, error in

                    if error != nil {
                       print("error=\(String(describing: error))")
                        return
                    }

                    var err: NSError?
                    do
                    {
                       let myJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                   if  (myJson["code"] as? Int64)   != Int64(500)  {//5A1!!!
                                       self.instanceOfUser.writeAnyData(key: "accessTokenz", value: myJson["access_token"]!!)
                                       self.instanceOfUser.writeAnyData(key: "refreshTokenz", value: myJson["refresh_token"]!!)
                                       self.token = (myJson["access_token"]!! as! String)
                                      completion(true)
                                     }
                                  else {
                                          completion(false)
                                      }
                        }

                    catch let error as NSError {
                        err = error
                        print("error=\(String(describing: err))")
                    }
                }
           task.resume()
         
         sleep(1)
     }
     func getToken(completion: @escaping (Bool) -> Void) {
        print(credentlsModl.usrId)
        let param: [String : Any] = [
            "grant_type" : "password",
            "client_id" : "clientkey",
            "client_secret" : "clientsecret",
            "username" : credentlsModl.usrId,
            "password" : credentlsModl.pwd
        ]
        AFWrapper.postRequest("https://demo.helixsense.com/api/authentication/oauth2/token", params: param, headers: header(type: .formUrlencoded), isJsonEncoding: false, success: { (result) in
            if let tokenz = (result as? NSDictionary)?["access_token"] as? String {
               self.token = tokenz
                completion(true)
            } else {
                completion(false)
            }
        }) { (error) in
            print(error.debugDescription)
            completion(false)
        }
    }
    func postSpaceIdBooked_new(Tkn:String,compid: String,vndrId: String,spacId: String,shftId: String ,PlndIn: String,PlndOut: String,empId: String,completion: @escaping (Bool) -> Void) {
    var request = URLRequest(url: URL(string: APIBuilder.SpaceIdBooked(compid: compid,vndrId: vndrId,spacId: spacId,shftId: shftId ,PlndIn: PlndIn,PlndOut: PlndOut,empId: empId))!,timeoutInterval: Double.infinity)
    let string1 = "Bearer "
    let string2 = Tkn
    let combined2 = "\(string1) \(String(describing: string2))"
    request.addValue(combined2, forHTTPHeaderField: "Authorization")
    let str = ""
    let postData = NSMutableData(data: str.data(using: String.Encoding.utf8)!)
    //postData.append(varRole.data(using: String.Encoding.utf8)!)
    request.httpBody = postData as Data
    request.httpMethod = "POST"
       let task1 = URLSession.shared.dataTask(with: request) { data, response, error in
                  guard let data = data else {
                    print(String(describing: error))
                    return
                  }
                  do {
                     // make sure this JSON is in the format we expect
                  let jsonc = try JSON(data: data)
                    if jsonc["data"][0].count > 0
                    {

                       completion(true)
                       
                   }
    
                     }

                  catch let error as NSError {

                    completion(false)
                     print("Failed to load: \(error.localizedDescription)")
                  }
                  }
                     task1.resume()
    }
    func postSymptomAnswers(activtyId:String,answr:String,completion: @escaping (Int?) -> Void) {
        let typ = "boolean"
        let headers = header(type: .formData, authorization: true)
        let param = [ "values" : "{\"employee_id\":\(usrInfoModls.employee_id),\"vendor_id\":\(usrInfoModls.vendor_id),\"type\":\"\(typ)\",\"answer\":\"\(answr)\",\"check_list_id\":\(configurationModls.check_list_ids),\"mro_activity_id\":\(activtyId),\"shift_id\":\(curntSchedulModll.shift_id)}"]
        AFWrapper.multipartRequest(APIBuilder.submtSymptomAnswerz(), params: param, headers: headers, success: { (result) in
         //print(result as Any)
            if let id = (result as? NSArray)?.firstObject as? Int {
                completion(id)
            }
        }) { (error) in
            print(error.debugDescription)
            completion(nil)
        }
    }
       func postIncidnt_new(Tkn:String,subj:String,category:String,categoryId:Int,subcategoryId:Int,channel:String,issue_type:String ,tenant_id:Int,asset_id:String,maintenance_team_id:Int,at_done_mro:Bool,completion: @escaping (Bool?) -> Void) {
      let  stringRole2 = "&values="
          let idy = curntSHift.space_id
          let tmId = tenantModl.maintenance_team_id
      let stringFields = """
       {"subject":"
       """
       let stringFields1 = """
        ","type_category":"
        """
        let stringFields2 = """
         ","category_id":
         """
         let stringFields3 = """
          ,"sub_category_id":
          """
          let stringFields4 = """
           ,"channel":"
           """
        

        let stringFields5 = """
         ","issue_type":"
         """
         let stringFields6 = """
          ","tenant_id":
          """
          let stringFields7 = """
           ,"asset_id":"
           """
           let stringFields8 = """
            ","maintenance_team_id":"
            """
            let stringFields9 = """
             ","at_done_mro":
             """
        let closg1 = """
         }
         """
      /* let stringFields1 = """
           [{"space_id":\(curntSHift.space_id),"team_id":\(tenantModl.maintenance_team_id)}]
           """
    */
       
       let  ids1 = "&method=mro_order_create_for_shift"
       let  stringRole5 = "&model=website.support.ticket"
       //let    stringFields = "\(String(describing:stringRole5))\(String(describing:stringRole2))\(String(describing:stringFields1))\(String(describing:ids1))\(curntSHift.space_id)\(String(describing:offsetFields2))"
          let    stringFieldz = "\(String(describing:stringRole5))\(String(describing:stringRole2))\(String(describing:stringFields))\(subj)\(String(describing:stringFields1))\(category)\(String(describing:stringFields2))\(categoryId)\(String(describing:stringFields3))\(subcategoryId)\(String(describing:stringFields4))\(channel)\(String(describing:stringFields5))\(issue_type)\(String(describing:stringFields6))\(tenant_id)\(String(describing:stringFields7))\(asset_id)\(String(describing:stringFields8))\(maintenance_team_id)\(String(describing:stringFields9))\(at_done_mro)\(closg1)"
            let headers = header(type: .formData, authorization: true)
           let param = (stringFieldz)
                let url = NSURL(string: APIBuilder.createID()) //Remember to put ATS exception if the URL is not https
                let request = NSMutableURLRequest(url: url! as URL)
                      let string1 = "Bearer "

                      let string2 = Tkn
                      let combined2 = "\(string1) \(String(describing: string2))"

                    request.addValue(combined2, forHTTPHeaderField: "Authorization")
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //Optional

                request.httpMethod = "POST"
                let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
                let data = param.data(using: String.Encoding.utf8)
                request.httpBody = data


            let task1 = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
              guard let data = data else {
                print(String(describing: error))
                return
              }
             do {
                let jsonStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                print(jsonStr as Any)
                 let nwFlds = """
                 "status": true
                 """
                 let varstts =  jsonStr?.contains("\(String(describing: nwFlds))") ?? false
                 if varstts
                     {
                       completion(varstts)

              }

                 }
                 
             }

                                                                           
      task1.resume()

      }
   func getAccessCheck(siteid: String? = nil,shftid: String? = nil,empid: String? = nil,completion: @escaping (Bool) -> Void) {
      let headers = header(authorization: true)
        Alamofire.request(APIBuilder.AccessCheck(siteId: siteid,shftId: shftid,empId: empid), method: .get, headers: headers)
      .responseJSON { response in
          if response.data != nil {
          do {
              let jsonc = try JSON(data: response.data!)
             let title = jsonc["data"]
             if (title.count > 0)
                    {
                      //  print(title["status"])
                      }
            completion(title["status"].boolValue)
               }
            catch let error as NSError {
                completion(false)
               print("Failed to load: \(error.localizedDescription)")
            }
          }
      }
              }
    
    func getUserinformation(completion: @escaping ([repousrInfo]) -> Void) {
        var values = [repousrInfo]()
      let headers = header(authorization: true)
     //  LoaderSpin.shared.showLoader()
      Alamofire.request(APIBuilder.Userinformation(), method: .get, headers: headers)
      .responseJSON { response in
          if response.data != nil {
          do {
              let jsonc = try JSON(data: response.data!)
             let title = jsonc["data"]
             if (title.count > 0)
                    {
                        values.append(repousrInfo(company_id: title["company_id"]["id"].int! ,employee_id: title["employee"]["id"].int!,user_id:title["user_id"].int!,vendor_id: title["vendor"]["id"].int! ,company_name: title["company_id"]["name"].stringValue,company_tz: title["company_tz"].stringValue ,
                                                  email: title["email"].stringValue ,employee_name: title["employee"]["name"].stringValue,locale:title["locale"].stringValue,name: title["name"].stringValue ,phone_number: title["phone_number"].stringValue, updated_at: title["updated_at"].stringValue,user_role: title["user_role"].stringValue
                            ,   username: title["username"].stringValue,vendor_name: title["vendor"]["name"].stringValue,website:title["website"].stringValue,zoneinfo: title["zoneinfo"].stringValue
                        ))
                              usrInfoModls.company_id = title["company_id"]["id"].int!
                              usrInfoModls.company_name = title["company_id"]["name"].stringValue
                              usrInfoModls.company_tz = title["company_tz"].stringValue
                              usrInfoModls.email = title["email"].stringValue
                              usrInfoModls.employee_id = title["employee"]["id"].int!
                              usrInfoModls.employee_name = title["employee"]["name"].stringValue
                              usrInfoModls.locale = title["locale"].stringValue
                              usrInfoModls.name = title["name"].stringValue
                              usrInfoModls.phone_number = title["phone_number"].stringValue
                              usrInfoModls.updated_at = title["updated_at"].stringValue
                              usrInfoModls.user_id = title["user_id"].int!
                              usrInfoModls.user_role = title["user_role"].stringValue
                              usrInfoModls.username = title["username"].stringValue
                              usrInfoModls.vendor_id = title["vendor"]["id"].int!
                              usrInfoModls.vendor_name = title["vendor"]["name"].stringValue
                              usrInfoModls.website = title["website"].stringValue
                              usrInfoModls.zoneinfo = title["zoneinfo"].stringValue
                      }
            completion(values)
               }
            catch let error as NSError {
                completion([])
               print("Failed to load: \(error.localizedDescription)")
            }
          }
      }
              }
}


