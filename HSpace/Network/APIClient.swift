 //
//  APIClient.swift
//  HelixSense
//
//  Created by DEEBA on 08.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

 import Foundation
import  Alamofire
 import  SwiftyJSON
 enum HeaderType {
     case json
     case formUrlencoded
     case formData
 }

 class APIClient {
     var token : String?

    let interNt = Internt()
     let instanceOfUser = readWrite()
      var category : [(Int, String)]?
    var shfttt : [(Double,Int, String, String, String,Double)]?
      var code : [(Int, String)]?
      var location : [(Int, String)]?
      var team : [(Int, String)]?
      var partner : [(Int, String)]?
     var bldgs : [( String,Int,Array<Any>,String)]?
     var usry : [( Int,String,Array<Any>)]?
     var spacez : [( String,Int,Int,Bool,String,Int,Bool,Int,String,String,String)]?
     private static var sharedNetworkManager: APIClient = {
                let networkManager = APIClient()
                return networkManager
            }()
            class func shared() -> APIClient {
                return sharedNetworkManager
            }
            private init() { }
    func header(type: HeaderType? = nil, authorization: Bool = false) -> [String:String] {
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
    func confrmSpacBkg(id: String,shftId: String,strt: String ,completion: @escaping (Int) -> Void) {
    
    let headers = header(type: .json, authorization: true)
    let idy = 0
   // LoaderSpin.shared.showLoader()
    AFWrapper.multipartRequest(APIBuilder.bkgSpace(id: id,shftId: shftId,strt: strt), params: [:], headers: headers, success: { (result) in
        print(result as Any)
          if let arr = (result as? NSDictionary)?["data"] as? NSArray {

            print(arr[1])
                completion(idy)
                LoaderSpin.shared.hideLoader()
            } else {
                self.renewToken(result) { status in
                    if status {
                        self.getSpaceName() { arr in
                            completion(0)
                            LoaderSpin.shared.hideLoader()
                        }
                    } else {
                        completion(0)
                        LoaderSpin.shared.hideLoader()
                    }
                }
            }
        }) { (error) in
            print(error.debugDescription)
            completion(0)
            LoaderSpin.shared.hideLoader()
        }
    }
    func getSpaceName(completion: @escaping ([SpaceDetails]) -> Void) {
        
        let headers = header(type: .formData, authorization: true)
        
        let param = [ "model" : "mro.equipment.location",
                      "fields" : "[\"space_name\",\"display_name\",\"maintenance_team_id\"]",
                      "domain" : "[[\"asset_categ_type\",\"=\",\"building\"]]"] as [String : Any]
        
       // LoaderSpin.shared.showLoader()
        AFWrapper.multipartRequest(APIBuilder.getSpace(), params: param, headers: headers, success: { (result) in
            if let arr = (result as? NSDictionary)?["data"] as? NSArray {
                var values = [SpaceDetails]()
                for data in arr {
                    if let sd = data as? NSDictionary {
                        values.append(SpaceDetails.init(id: String(sd["id"] as? Int ?? 0),
                                                        name: sd["space_name"] as? String,
                                                        displayName: sd["display_name"] as? String,
                                                        haveChilds: true))
                    }
                }
                completion(values)
                LoaderSpin.shared.hideLoader()
            } else {
                self.renewToken(result) { status in
                    if status {
                        self.getSpaceName() { arr in
                            completion(arr)
                            LoaderSpin.shared.hideLoader()
                        }
                    } else {
                        completion([])
                        LoaderSpin.shared.hideLoader()
                    }
                }
            }
        }) { (error) in
            print(error.debugDescription)
            completion([])
            LoaderSpin.shared.hideLoader()
        }
    }
     func getSpaceIdBooked(compid: String,vndrId: String,spacId: String,shftId: String ,PlndIn: String,PlndOut: String,empId: String, completion: @escaping (Int?) -> Void) {
        let headers = header(type: .json, authorization: true)
        
       // LoaderSpin.shared.showLoader()
        AFWrapper.multipartRequest(APIBuilder.SpaceIdBooked(compid: compid,vndrId: vndrId,spacId: spacId,shftId: shftId ,PlndIn: PlndIn,PlndOut: PlndOut,empId: empId), params: [:], headers: headers, success: { (result) in
            print(result as Any)
            if let data = (result as? NSDictionary)?["data"] as? NSArray {
                completion((data[0] as! Int))
            }
            else {
                self.renewToken(result) { status in
                    if status {
                       /*
                        self.getSpaceName() { arr in
                            completion(arr)
                            Loader.hide()
                        }
                       */
                    } else {
                        completion(0)
                        LoaderSpin.shared.hideLoader()
                    }
                }
            }
        }) { (error) in
            print(error.debugDescription)
            completion(0)
            LoaderSpin.shared.hideLoader()
        }
    }
      func getChildOf(id: String,strt: String,endd: String ,completion: @escaping ([SpaceDetails]) -> Void) {
       let headers = header(authorization: true)
        
        var arr = [SpaceDetails]()
      //  LoaderSpin.shared.showLoader()
       Alamofire.request(APIBuilder.getAvailableSpace(id: id,strt: strt,endd: endd), method: .get, headers: headers)
       .responseJSON { response in
           if response.data != nil {
           do {
               let jsonc = try JSON(data: response.data!)
              // let title = jsonc["data"][0]["name"].stringValue
              //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
              let title = jsonc["data"]
              if (title.count > 0)
                     {
                         
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
             completion(arr)
                }
             catch let error as NSError {
                 completion([])
                print("Failed to load: \(error.localizedDescription)")
             }
           }
       }
               }
     func dashBrdApi() {
        let headers = header(type: .json, authorization: true)
        //Loader.show()
        AFWrapper.multipartRequest(APIBuilder.getcrntShfty(), params: [:], headers: headers, success: { (result) in
            if let arr = (result as? NSDictionary)?["data"] as? NSArray {
                for data in arr {
                    if let sd = data as? NSDictionary {
                        curntSHift.empId = sd["employee_id"] as? Int ?? 0
                        curntSHift.idx = sd["id"] as? Int ?? 0
                        curntSHift.planned_in = (sd["planned_in"] as? String)!
                        curntSHift.planned_out = (sd["planned_out"]  as? String)!
                        curntSHift.planned_status = (sd["planned_status"]  as? String)!
                        curntSHift.shift_id = sd["shift_id"]  as? Int ?? 0
                        curntSHift.shift_name = (sd["shift_name"]   as? String)!
                        if (sd["space_name"]   as? Int != 0)  {
                            curntSHift.space_id  = sd["space_id"] as? Int ?? 0
                            curntSHift.space_name = (sd["space_name"]   as? String)!
                            curntSHift.space_number = (sd["space_number"]    as? String)!
                            curntSHift.space_path_name = (sd["space_path_name"]   as? String)!
                            curntSHift.space_status = (sd["space_status"]    as? String)!
                         }
                        else{
                            curntSHift.space_id  = 0
                            curntSHift.space_name = ""
                            curntSHift.space_number = ""
                            curntSHift.space_path_name = ""
                            curntSHift.space_status = ""
                                    
                        }
                    }
                }
                            LoaderSpin.shared.hideLoader()
                        } else {
                            self.renewToken(result) { status in
                                if status {
                                    self.dashBrdApi()
                                        LoaderSpin.shared.hideLoader()
                                } else {
                                    LoaderSpin.shared.hideLoader()
                                }
                            }
                        }
                    }) { (error) in
                        print(error.debugDescription)
                        LoaderSpin.shared.hideLoader()
                    }
                }
    func dashBrdApi_old(Tkn:String)
{
// https://demo.helixsense.com/api/v2/call?model=mro.shift.employee&method=get_current_employee_shift
var request = URLRequest(url: URL(string: SHIFTS_URL)!,timeoutInterval: Double.infinity)
let string1 = "Bearer "
let string2 = Tkn
var closg = ""
let combined2 = "\(string1) \(String(describing: string2))"
request.addValue(combined2, forHTTPHeaderField: "Authorization")
let stringFields1 = """
&method=get_current_employee_shift
"""
let combinedOffset = "\(stringFields1)"
let varRole = "\(String(describing: combinedOffset))"
let postData = NSMutableData(data: "model=mro.shift.employee".data(using: String.Encoding.utf8)!)
postData.append(varRole.data(using: String.Encoding.utf8)!)
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
                             curntSHift.empId = (jsonc["data"][0]["employee_id"]).int!

                            curntSHift.idx = (jsonc["data"][0]["id"]).int!
                            curntSHift.planned_in = jsonc["data"][0]["planned_in"].stringValue
                            curntSHift.planned_out = jsonc["data"][0]["planned_out"].stringValue
                            curntSHift.planned_status = jsonc["data"][0]["planned_status"].stringValue
                           curntSHift.shift_id = (jsonc["data"][0]["shift_id"]).int!
                          curntSHift.shift_name = jsonc["data"][0]["shift_name"].stringValue
                            if (jsonc["data"][0]["space_name"].stringValue != "false")  {
                                curntSHift.space_id  = (jsonc["data"][0]["space_id"]).int!
                                curntSHift.space_name = jsonc["data"][0]["space_name"].stringValue
                                curntSHift.space_number = jsonc["data"][0]["space_number"].stringValue
                                curntSHift.space_path_name = jsonc["data"][0]["space_path_name"].stringValue
                                curntSHift.space_status = jsonc["data"][0]["space_status"].stringValue
                             }
                            else{
                                        curntSHift.space_id  = 0
                                        curntSHift.space_name = ""
                                        curntSHift.space_number = ""
                                        curntSHift.space_path_name = ""
                                        curntSHift.space_status = ""
                                        
                            }
                    
                            
                            //self.updteImgz(Tkn:Tkn)
                             }
                 }

              catch let error as NSError {
                 print("Failed to load: \(error.localizedDescription)")
              }
              }
                 task1.resume()
}
    func getShiftz_old(Tkn:String) {
       shiftzModl.id.removeAll()
       shiftzModl.duratn.removeAll()
       shiftzModl.endTim.removeAll()
       shiftzModl.name.removeAll()
       shiftzModl.strtTim.removeAll()
       shiftzModl.ttlDis.removeAll()
       var request = URLRequest(url: URL(string: SHIFTS_URL)!,timeoutInterval: Double.infinity)
          let string1 = "Bearer "
          let string2 = Tkn
               let combined2 = "\(string1)\(String(describing: string2))"
               request.addValue(combined2, forHTTPHeaderField: "Authorization")
       let dateFormatter1 : DateFormatter = DateFormatter()
       let dateFormatter : DateFormatter = DateFormatter()
        //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter1.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
       let lstDatetime = interNt.convertToUTC(dateToConvert: dateString)
       let trimmed1 =  lstDatetime.trimmingCharacters(in: .whitespacesAndNewlines)
       
              let stringFields = """
              get_current_shift_template
              """
              let closg1 = """
              [{"start_time":"\(trimmed1)"}]
              """
       let  stringRole1 = "&method="
       let stringargs1 = "&args="
       let varRole = "\(stringRole1)\(String(describing: stringFields))\(stringargs1)\(String(describing: closg1))"
       let postData = NSMutableData(data: "model=mro.shift.employee".data(using: String.Encoding.utf8)!)
     postData.append(varRole.data(using: String.Encoding.utf8)!)
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
                                            
                                                    let title = jsonc["data"]
                                              if (title.count > 0)
                                              {
                                                for i in 0..<title.count {
                                                   shiftzModl.id.append(title[i]["id"].int!)
                                                   shiftzModl.name.append(title[i]["name"].stringValue)
                                                   shiftzModl.strtTim.append(title[i]["planned_in"].stringValue)
                                                   shiftzModl.endTim.append(title[i]["planned_out"].stringValue)

                                                   let inptDte = self.interNt.convertToLocal(incomingFormat: title[i]["planned_in"].stringValue)
                                                   let arrsplit = inptDte.components(separatedBy: " ")
                                                   let strDate = arrsplit[1]
                                                   let outptDte = self.interNt.convertToLocal(incomingFormat: title[i]["planned_out"].stringValue)
                                                    let arrsplitOut = outptDte.components(separatedBy: " ")
                                                   let strDateOut = arrsplitOut[1]
                                                   shiftzModl.ttlDis.append("Shift " + title[i]["name"].stringValue + "(" + strDate + "-" + strDateOut + ")")
                                                   shiftzModl.duratn.append(title[i]["duration"].doubleValue)
                                                   }
                                               }
                                             }
                                             catch let error as NSError {
                                                print("Failed to load: \(error.localizedDescription)")
                                            }
                                           }
                                    task1.resume()
                     
                     
             }
    func getShiftz(completion: @escaping ([newShftzMdl]) -> Void) {
        var cnt = 0
       let id = self.instanceOfUser.readStringData(key: "ShftTiminpt")
        shiftzModl.id.removeAll()
        shiftzModl.duratn.removeAll()
        shiftzModl.endTim.removeAll()
        shiftzModl.name.removeAll()
        shiftzModl.strtTim.removeAll()
        shiftzModl.ttlDis.removeAll()
        let values = [newShftzMdl]()
     let headers = header(type: .json, authorization: true)
    // LoaderSpin.shared.showLoader()

     AFWrapper.multipartRequest(APIBuilder.getShftList(id: id), params: [:], headers: headers, success: { (result) in
         if let arr = (result as? NSDictionary)?["data"] as? NSArray {
            for data in arr {
                cnt = cnt + 1
                if let sd = data as? NSDictionary {
            shiftzModl.id.append(sd["id"] as? Int ?? 0)
                    shiftzModl.name.append((sd["name"] as? String)!)
                    shiftzModl.strtTim.append((sd["planned_in"] as? String)!)
            shiftzModl.endTim.append((sd["planned_out"] as? String)!)

            let inptDte = self.interNt.convertToLocal(incomingFormat: (sd["planned_in"] as? String)!)
            let arrsplit = inptDte.components(separatedBy: " ")
            let strDate = arrsplit[1]
            let outptDte = self.interNt.convertToLocal(incomingFormat: (sd["planned_out"] as? String)!)
             let arrsplitOut = outptDte.components(separatedBy: " ")
            let strDateOut = arrsplitOut[1]
            shiftzModl.ttlDis.append("Shift " + (sd["name"] as? String)! + "(" + strDate + "-" + strDateOut + ")")
                    shiftzModl.duratn.append(sd["id"] as? Double ?? 0.0)
                  //  print(cnt)
                }
            }
           /*  for data in arr {
                if let sd = data as? NSDictionary {
                    values.append(newShftzMdl.init(id: String(sd["id"] as? Int ?? 0),
                    name: sd["name"] as? String, strtTim: sd["planned_in"] as? String,
                    endTim: sd["planned_out"] as? String,duratn: String(sd["duration"] as? Double ?? 0)))
                }
             }*/
            completion(values)
                         LoaderSpin.shared.hideLoader()
                     } else {
                         self.renewToken(result) { status in
                             if status {
                                self.getShiftz() { arr in
                                     completion(values)
                                     LoaderSpin.shared.hideLoader()
                                 }
                                
                             } else {
                                 completion([])
                                 LoaderSpin.shared.hideLoader()
                             }
                         }
                     }
                 }) { (error) in
                     print(error.debugDescription)
                             completion([])
                             LoaderSpin.shared.hideLoader()
                         }
                     }
    func getSymptomslist(Tkn:String)
    {
       // https://demo.helixsense.com/api/v2/call?model=mro.shift.employee&method=get_current_employee_shift
        symptmsListModl.display_name.removeAll()
        symptmsListModl.expected_type.removeAll()
        symptmsListModl.id.removeAll()
        symptmsListModl.mro_quest_grp_id.removeAll()
        symptmsListModl.mro_quest_grp_nam.removeAll()
        symptmsListModl.type.removeAll()
    var request = URLRequest(url: URL(string: tnnt_URL)!,timeoutInterval: Double.infinity)
    let string1 = "Bearer "
    let string2 = Tkn
        var closg = ""
         let combined2 = "\(string1) \(String(describing: string2))"
         request.addValue(combined2, forHTTPHeaderField: "Authorization")
        
          closg = """
         ["id","display_name","type","mro_quest_grp_id","expected_type"]
         """
           
             
         let  stringRole1 = "&ids="
         let stringDomain1 = "&fields="
         let varRole = "\(stringRole1)\(symptomsModl.activity_lines)\(stringDomain1)\(String(describing: closg))"
                                   let postData = NSMutableData(data: "model=mro.activity".data(using: String.Encoding.utf8)!)
                                   postData.append(varRole.data(using: String.Encoding.utf8)!)
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
                                                        for j in 0..<jsonc["data"].count {
                                                            symptmsListModl.display_name.append(jsonc["data"][j]["display_name"].stringValue)
                                                            symptmsListModl.expected_type.append(jsonc["data"][j]["expected_type"].boolValue)
                                                            symptmsListModl.id.append(jsonc["data"][j]["id"].int!)
                                                            
                                                            if jsonc["data"][j]["mro_quest_grp_id"] ==  false
                                                            {
                                                                symptmsListModl.mro_quest_grp_id.append(0)
                                                                symptmsListModl.mro_quest_grp_nam.append("")
                                                                }
                                                            else
                                                            {
                                                                symptmsListModl.mro_quest_grp_id.append(jsonc["data"][j]["mro_quest_grp_id"][0].int!)
                                                                symptmsListModl.mro_quest_grp_nam.append(jsonc["data"][j]["mro_quest_grp_id"][1].stringValue)
                                                            }
                                                            symptmsListModl.type.append(jsonc["data"][j]["type"].stringValue)
                                                        }
                                                         }
                                                      catch let error as NSError {
                                                         print("Failed to load: \(error.localizedDescription)")
                                                      }
                                                      }
                                                         task1.resume()
        
        }
     func getBldg(){
        var arr = [SpaceDetails]()
        let headers = header(type: .formData, authorization: true)
        let param = [ "model" : "mro.equipment.location",
                      "domain" : "[[\"asset_categ_type\",\"=\",\"building\"]]",
                      "fields" : "[\"space_name\",\"display_name\",\"maintenance_team_id\"]"]
         AFWrapper.multipartRequest(APIBuilder.search(), params: param, headers: headers, success: { (result) in
            if let data = (result as? NSDictionary)?["data"] as? NSArray {
                for i in data {
                    print(data)
                }
            } else {
                self.renewToken(result)
            }
        }) { (error) in
            print(error.debugDescription)
        }
    }


    func getchklist(Tkn:String)
    {
        symptomsModl.activity_lines.removeAll()
        symptomsModl.chklstId = 0
       // https://demo.helixsense.com/api/v2/call?model=mro.shift.employee&method=get_current_employee_shift
    var request = URLRequest(url: URL(string: tnnt_URL)!,timeoutInterval: Double.infinity)
    let string1 = "Bearer "
    let string2 = Tkn
        var closg = ""
         let combined2 = "\(string1) \(String(describing: string2))"
         request.addValue(combined2, forHTTPHeaderField: "Authorization")
         let stringFields = """
         [\(tenantModl.chkLstid)]
         """
       
          closg = """
         ["activity_lines"]
         """
         let  stringRole1 = "&ids="
         let stringDomain1 = "&fields="
         let varRole = "\(stringRole1)\(String(describing: stringFields))\(stringDomain1)\(String(describing: closg))"
                                   let postData = NSMutableData(data: "model=mro.check.list".data(using: String.Encoding.utf8)!)
                                   postData.append(varRole.data(using: String.Encoding.utf8)!)
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
                                                        for j in 0..<jsonc["data"][0]["activity_lines"].count {
                                                              symptomsModl.activity_lines.append(jsonc["data"][0]["activity_lines"][j].int ?? 0)
                                                        }
                                                        symptomsModl.chklstId = jsonc["data"][0]["id"].int!
                                                         }
                                                      catch let error as NSError {
                                                         print("Failed to load: \(error.localizedDescription)")
                                                      }
                                                      }
                                                         task1.resume()
        }
    func getSpaceIdBooked_new(Tkn:String,compid: String,vndrId: String,spacId: String,shftId: String ,PlndIn: String,PlndOut: String,empId: String,completion: @escaping (Bool) -> Void) {
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
     func postRelsed(Tkn:String){
        let spcId = curntSchedulModll.space_id
        let team_id  = configurationModls.maintenance_team_id
     var request = URLRequest(url: URL(string: pstRlsed)!,timeoutInterval: Double.infinity)
     let string1 = "Bearer "
     let string2 = Tkn
     var closg = ""
     let combined2 = "\(string1) \(String(describing: string2))"
     request.addValue(combined2, forHTTPHeaderField: "Authorization")
     let stringFields1 = """
     &space_id=
     """
     let stringFields2 = """
     &team_id=
     """
     let combinedOffset = "\(stringFields1)\(spcId)\(stringFields2)\(team_id)"
     let varRole = "\(String(describing: combinedOffset))"
     let str = ""
     let postData = NSMutableData(data: str.data(using: String.Encoding.utf8)!)
     postData.append(varRole.data(using: String.Encoding.utf8)!)
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
                        
                        
                    }
                      }

                   catch let error as NSError {
                      print("Failed to load: \(error.localizedDescription)")
                   }
                   }
                      task1.resume()
     }
    func getusrRoleAlom(completion: @escaping ([newShftzMdl]) -> Void) {
        let headers = header(type: .formData, authorization: true)
        let param = [ "model" : "user.management",
        "domain" : "[[\"user_id\",\"=\",\(self.instanceOfUser.readIntData(key: "UsrId"))]]",
        "fields" : "[\"roles\",\"vendor_id\"]"]
        AFWrapper.multipartRequest(APIBuilder.search(), params: param, headers: headers, success: { (result) in
            if let data = (result as? NSDictionary)?["data"] as? NSArray {
                let arrz = [( Int,String,Array<Any>)]()
                for i in data {
                    if let dic = i as? NSDictionary, let roles = dic["roles"] as? String, let id = dic["id"] as? Int , let vendor_id = dic["vendor_id"] as? Array<Any> {
                       // arrz.append((name,id,maintenance_team_id,space_name))
                        usrRlrModl.usrId = id
                        usrRlrModl.usrRol = roles
                        usrRlrModl.vndrId = vendor_id[0] as! Int
                        usrRlrModl.vndrNam = vendor_id[1] as! String
                        
                    }
                }
                completion([])
                LoaderSpin.shared.hideLoader()
                self.usry = arrz
            } else {
                self.renewToken(result) { status in
                    if status {
                       self.getusrRoleAlom() { arr in
                            completion([])
                            LoaderSpin.shared.hideLoader()
                        }
                       
                    } else {
                        completion([])
                        LoaderSpin.shared.hideLoader()
                    }
                }
            }
        }) { (error) in
            print(error.debugDescription)
        }
    }
    func getusrRole(usrId: Int, Tkn:String)
    {
       // https://demo.helixsense.com/api/v2/call?model=mro.shift.employee&method=get_current_employee_shift
    var request = URLRequest(url: URL(string: usrRol_URL)!,timeoutInterval: Double.infinity)
    let string1 = "Bearer "
    let string2 = Tkn
        var closg = ""
         let combined2 = "\(string1) \(String(describing: string2))"
         request.addValue(combined2, forHTTPHeaderField: "Authorization")
         let stringFields = """
         [[\"user_id\",\"=\",\(usrId)]]
         """
       
          closg = """
         [\"roles\",\"vendor_id\"]
         """
           
             
         let  stringRole1 = "&domain="
         let stringDomain1 = "&fields="
         let varRole = "\(stringRole1)\(String(describing: stringFields))\(stringDomain1)\(String(describing: closg))"
                                   let postData = NSMutableData(data: "model=user.management".data(using: String.Encoding.utf8)!)
                                   postData.append(varRole.data(using: String.Encoding.utf8)!)
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
                                                       usrRlrModl.usrId = jsonc["data"][0]["id"].int!
                                                       usrRlrModl.usrRol = jsonc["data"][0]["roles"].stringValue
                                                       usrRlrModl.vndrId = jsonc["data"][0]["vendor_id"][0].int!
                                                       usrRlrModl.vndrNam = jsonc["data"][0]["vendor_id"][1].stringValue
                                                        //self.updteImgz(Tkn:Tkn)
                                                         }
                                                      catch let error as NSError {
                                                         print("Failed to load: \(error.localizedDescription)")
                                                      }
                                                      }
                                                         task1.resume()
        }
    func getUserInfo(Tkn:String) {
    
                                   var request = URLRequest(url: URL(string: userInfo_URL)!,timeoutInterval: Double.infinity)
                                   let string1 = "Bearer "
                                   let string2 = Tkn
                                   let combined2 = "\(string1) \(String(describing: string2))"
                                  request.addValue(combined2, forHTTPHeaderField: "Authorization")
                                  request.httpMethod = "GET"
                                  let task1 = URLSession.shared.dataTask(with: request) { data, response, error in
                                    guard let data = data else {
                                      print(String(describing: error))
                                      return
                                    }
                                   do {
                                       // make sure this JSON is in the format we expect
                                          let jsonc = try JSON(data: data)
                                    //print(json["data"][0]["validation_status_count"].stringValue)
                                           let title = jsonc["data"]
                                     /*  In userinfo read following objects
                                       employee_name
                                       employee_id
                                       sub is userid
                                       company_id
                                       company_name*/
                                       usrInfoModl.compId = jsonc["company_id"].int!
                                       usrInfoModl.compName = jsonc["company_name"].stringValue
                                       usrInfoModl.employee_id = jsonc["employee_id"].int!
                                       usrInfoModl.empName = jsonc["employee_name"].stringValue
                                       usrInfoModl.usrId = jsonc["sub"].int!
                                       usrInfoModl.userName = jsonc["username"].stringValue
                                       self.instanceOfUser.writeAnyData(key: "UsrId", value: jsonc["sub"].int!)
                                    }
                                    catch let error as NSError {
                                       print("Failed to load: \(error.localizedDescription)")
                                   }
                                  }
                           task1.resume()
            
            
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
   /*https://demo.helixsense.com/api/v2/iread?model=res.partner&fields=["id","name","allow_onspot_space_booking","onspot_booking_grace_period","detect_mask","mask_mandatory","create_work_schedule","work_schedule_grace_period","require_attendance","attendance_with_face_detection","face_detection_mandatory", "auto_release",
    "auto_release_grace_period",
    "generate_mor_after_release",
    "require_checklist","check_list_ids",
    "enable_report_covid_incident",
    "ticket_category_id","sub_category_id",
    "maintenance_team_id"]
    &ids=[1450]
  
    func getTenantdtls_old(Tkn:String,vndrId:Int) {
       // https://demo.helixsense.com/api/v2/call?model=mro.shift.employee&method=get_current_employee_shift
    var request = URLRequest(url: URL(string: tnnt_URL)!,timeoutInterval: Double.infinity)
    let string1 = "Bearer "
    let string2 = Tkn
        var closg = ""
         let combined2 = "\(string1) \(String(describing: string2))"
         request.addValue(combined2, forHTTPHeaderField: "Authorization")
         let stringFields = """
         ["id","name","allow_onspot_space_booking","onspot_booking_grace_period","detect_mask","mask_mandatory","create_work_schedule","work_schedule_grace_period",
         "require_attendance","attendance_with_face_detection","face_detection_mandatory",
         "auto_release",
         "auto_release_grace_period",
         "generate_mor_after_release",
         "require_checklist","check_list_ids",
         "enable_report_covid_incident",
         "ticket_category_id","sub_category_id",
         "maintenance_team_id"]
         """
          closg = """
         [\(vndrId)]
         """
           
             
         let  stringRole1 = "&fields="
         let stringDomain1 = "&ids="
         let varRole = "\(stringRole1)\(String(describing: stringFields))\(stringDomain1)\(String(describing: closg))"
                                   let postData = NSMutableData(data: "model=res.partner".data(using: String.Encoding.utf8)!)
                                   postData.append(varRole.data(using: String.Encoding.utf8)!)
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
tenantModl.allow_onspot_space_booking = jsonc["data"][0]["allow_onspot_space_booking"].boolValue
tenantModl.attendance_with_face_detection = jsonc["data"][0]["attendance_with_face_detection"].boolValue
tenantModl.auto_release = jsonc["data"][0]["auto_release"].boolValue
tenantModl.create_work_schedule = jsonc["data"][0]["create_work_schedule"].boolValue
tenantModl.detect_mask = jsonc["data"][0]["detect_mask"].boolValue
tenantModl.enable_report_covid_incident = jsonc["data"][0]["enable_report_covid_incident"].boolValue
tenantModl.face_detection_mandatory = jsonc["data"][0]["face_detection_mandatory"].boolValue
tenantModl.generate_mor_after_release = jsonc["data"][0]["generate_mor_after_release"].boolValue

tenantModl.mask_mandatory = jsonc["data"][0]["mask_mandatory"].boolValue
tenantModl.require_attendance = jsonc["data"][0]["require_attendance"].boolValue
tenantModl.require_checklist = jsonc["data"][0]["require_checklist"].boolValue
tenantModl.work_schedule_grace_period = jsonc["data"][0]["work_schedule_grace_period"].int!
if jsonc["data"][0]["ticket_category_id"] != "" ||  jsonc["data"][0]["ticket_category_id"] != "false"
{
tenantModl.ticket_category_id = jsonc["data"][0]["ticket_category_id"][0].int!
tenantModl.ticket_category_nam = jsonc["data"][0]["ticket_category_id"][1].stringValue
}
else
{
tenantModl.ticket_category_id = 0
tenantModl.ticket_category_nam = ""
}
if jsonc["data"][0]["sub_category_id"] != "" ||  jsonc["data"][0]["sub_category_id"] != "false"
{
   tenantModl.sub_category_id = jsonc["data"][0]["sub_category_id"][0].int!
   tenantModl.sub_category_nam = jsonc["data"][0]["sub_category_id"][1].stringValue
   }
else
{
   tenantModl.sub_category_id = 0
   tenantModl.sub_category_nam = ""
}
if jsonc["data"][0]["maintenance_team_id"] != "" ||  jsonc["data"][0]["maintenance_team_id"] != "false"
         {
             tenantModl.maintenance_team_id = jsonc["data"][0]["maintenance_team_id"][0].int!
             tenantModl.maintenance_team_nam = jsonc["data"][0]["maintenance_team_id"][1].stringValue
             }
         else
         {
             tenantModl.maintenance_team_id = 0
             tenantModl.maintenance_team_nam = ""
         }
tenantModl.onspot_booking_grace_period = jsonc["data"][0]["onspot_booking_grace_period"].int!
tenantModl.id = jsonc["data"][0]["id"].int!
tenantModl.check_list_ids = jsonc["data"][0]["check_list_ids"][0].int!
tenantModl.auto_release_grace_period = jsonc["data"][0]["auto_release_grace_period"].int!
tenantModl.name = jsonc["data"][0]["name"].stringValue
}
catch let error as NSError {
print("Failed to load: \(error.localizedDescription)")
}
}
                                                         task1.resume()
        }
  */
    func clseBooking(clsgId: String? = nil, completion: @escaping (String?) -> Void) {
     let headers = header(type: .json, authorization: true)
        AFWrapper.multipartRequest(APIBuilder.clsBookg(clsgId: clsgId ), params: [:], headers: headers, success: { (result) in
     if let arr = (result as? NSDictionary)?["data"] as? NSArray {
        }
                     else {
                                 self.renewToken(result)
                             }
                         }) { (error) in
                             print(error.debugDescription)
                         }
                     }
        
    func getTenantdtls(vndrId: String? = nil, completion: @escaping (String?) -> Void) {
        let headers = header(type: .json, authorization: true)
       AFWrapper.multipartRequest(APIBuilder.getTenant(vndrId: vndrId ), params: [:], headers: headers, success: { (result) in
        if let arr = (result as? NSDictionary)?["data"] as? NSArray {
                   for data in arr {
                       if let sd = data as? NSDictionary {
                        tenantModl.allow_onspot_space_booking = (sd["allow_onspot_space_booking"] as? Bool)!
                         tenantModl.attendance_with_face_detection = (sd["attendance_with_face_detection"] as? Bool)!
                          tenantModl.auto_release = (sd["auto_release"] as? Bool)!
                          tenantModl.create_work_schedule = (sd["create_work_schedule"] as? Bool)!
                          tenantModl.detect_mask = (sd["detect_mask"] as? Bool)!
                          tenantModl.enable_report_covid_incident = (sd["enable_report_covid_incident"] as? Bool)!
                          tenantModl.face_detection_mandatory = (sd["face_detection_mandatory"] as? Bool)!
                          tenantModl.generate_mor_after_release = (sd["generate_mor_after_release"] as? Bool)!

                          tenantModl.mask_mandatory = (sd["mask_mandatory"] as? Bool)!
                          tenantModl.require_attendance = (sd["require_attendance"] as? Bool)!
                          tenantModl.require_checklist = (sd["require_checklist"] as? Bool)!
                          tenantModl.work_schedule_grace_period = (sd["work_schedule_grace_period"] as? Int ?? 0)
                        let ticketcategoryid = sd["ticket_category_id"] as? Array<Any>
                        if ((sd["ticket_category_id"]  as? Array<Any>) != nil)
                            
                          {
                            tenantModl.ticket_category_id =  ticketcategoryid![0] as! Int
                            tenantModl.ticket_category_nam =  ticketcategoryid![1] as! String
                          }
                          else
                          {
                          tenantModl.ticket_category_id = 0
                          tenantModl.ticket_category_nam = ""
                          }
                        
                        
                        let subcategoryid = sd["sub_category_id"] as? Array<Any>
                          if ((sd["sub_category_id"]  as? Array<Any>) != nil)
                          {
                             tenantModl.sub_category_id = subcategoryid![0] as! Int
                             tenantModl.sub_category_nam = subcategoryid![1] as! String
                             }
                          else
                          {
                             tenantModl.sub_category_id = 0
                             tenantModl.sub_category_nam = ""
                          }
                        let maintenanceteamid = sd["maintenance_team_id"] as? Array<Any>
                          if ((sd["maintenance_team_id"]  as? Array<Any>) != nil)
                                   {
                                       tenantModl.maintenance_team_id = maintenanceteamid![0] as! Int
                                       tenantModl.maintenance_team_nam = maintenanceteamid![1]  as! String
                                       }
                                   else
                                   {
                                       tenantModl.maintenance_team_id = 0
                                       tenantModl.maintenance_team_nam = ""
                                   }
                          tenantModl.onspot_booking_grace_period = (sd["onspot_booking_grace_period"] as? Int ?? 0)
                          tenantModl.id = (sd["id"] as? Int ?? 0)
                        tenantModl.check_list_ids = ((sd["check_list_ids"] as? Array<Any>)! )
                        let dft = tenantModl.check_list_ids
                        tenantModl.chkLstid = dft[0] as? Int ?? 0
                          tenantModl.auto_release_grace_period = (sd["auto_release_grace_period"] as? Int ?? 0)
                          tenantModl.name = (sd["name"] as? String)!
                       }
                   }
               }
              else {
                          self.renewToken(result)
                      }
                  }) { (error) in
                      print(error.debugDescription)
                  }
              }
      func getValidationCount(displayName: String? = nil, completion: @escaping (String?) -> Void) {
         
         let headers = header(authorization: true)
         
         AFWrapper.getRequest(APIBuilder.validationCount(displayName: displayName), headers: headers, success: { (result) in
             if let data = (result as? NSDictionary)?["data"] as? NSArray {
                 for i in data {
                     if let dic = i as? NSDictionary, dic["validation_status"] as? String == "None" {
                         completion("\(dic["validation_status_count"] as? Int ?? 0)")
                         return
                     }
                 }
             }
            self.renewToken(result)
             completion("0")
         }) { (error) in
             print(error.debugDescription)
             completion(nil)
         }
     }
     
      func getLocation(completion: @escaping ([String]) -> Void) {
         
         if let data = location {
             completion(data.map{$0.1})
             return
         }
         
         let headers = header(type: .formData, authorization: true)
         let param = [ "model" : "mro.equipment.location",
                       "fields" : "[\"display_name\"]"]
         
         AFWrapper.multipartRequest(APIBuilder.search(), params: param, headers: headers, success: { (result) in
             if let data = (result as? NSDictionary)?["data"] as? NSArray {
                 var arr = [(Int, String)]()
                 for i in data {
                     if let dic = i as? NSDictionary, let name = dic["display_name"] as? String, let id = dic["id"] as? Int {
                         arr.append((id,name))
                     }
                 }
                self.location = arr
                 completion(arr.map{$0.1})
             } else {
                self.renewToken(result)
                 completion([])
             }
         }) { (error) in
             print(error.debugDescription)
             completion([])
         }
     }

      func getTeam(completion: @escaping ([String]) -> Void) {
         
         if let data = team {
             completion(data.map{$0.1})
             return
         }
         
         let headers = header(type: .formData, authorization: true)
         let param = [ "model" : "mro.maintenance.team",
                       "fields" : "[\"name\"]"]
         
         AFWrapper.multipartRequest(APIBuilder.search(), params: param, headers: headers, success: { (result) in
             if let data = (result as? NSDictionary)?["data"] as? NSArray {
                 var arr = [(Int, String)]()
                 for i in data {
                     if let dic = i as? NSDictionary, let name = dic["name"] as? String, let id = dic["id"] as? Int {
                         arr.append((id,name))
                     }
                 }
                self.team = arr
                 completion(arr.map{$0.1})
             } else {
                self.renewToken(result)
                 completion([])
             }
         }) { (error) in
             print(error.debugDescription)
             completion([])
         }
     }
     func getSpaceLst(spcId:Int,shftId:Int,strt:String,endd:String)  -> [SpaceDetails] {
        var arr = [SpaceDetails]()
        let headers = header(type: .formData, authorization: true)
        let param = [ "model" : "mro.shift.employee",
                      "args" : "[{\"space_id\":\(spcId),\"shift_id\":\(shftId),\"start_time\":\"\(strt)\",\"stop_time\":\"\(endd)\"}]",
                      "method" : "get_child_spaces_with_status"]
        
        AFWrapper.multipartRequest(APIBuilder.spaceZ(), params: param, headers: headers, success: { (result) in
            if let data = (result as? NSDictionary)?["data"] as? NSArray {
                var arrz = [( String,Int,Int,Bool,String,Int,Bool,Int,String,String,String)]()
                for i in data {
                    var data = SpaceDetails()
                    if let dic = i as? NSDictionary, let asset_categ_type = dic["asset_categ_type"] as? String, let available_status = dic["available_status"] as? Int , let count = dic["count"] as? Int,let employee_id = dic["employee_id"] as? Bool,let employee_name = dic["employee_name"] as? String,let id = dic["id"] as? Int ,let is_parent = dic["is_parent"] as? Bool ,let parent_id = dic["parent_id"] as? Int,let path_name = dic["path_name"] as? String,let space_name = dic["space_name"] as? String,let status = dic["status"] as? String{
                        arrz.append((asset_categ_type,available_status,count,employee_id,employee_name,id,is_parent,parent_id,path_name,space_name,status))
                     //   SpaceDetailsModl.available_status.append(dic["available_status"]! as! Bool)
                        data.type = asset_categ_type
                        data.displayName = path_name
                        data.name = space_name
                        data.id = String(id)
                        data.haveChilds = is_parent
                        arr.append(data)
                    }
                    print(arr)
                }
                self.spacez = arrz
            } else {
                self.renewToken(result)
            }
        }) { (error) in
            print(error.debugDescription)
        }

        return arr
    }
    
      func getbldgLst() -> [SpaceDetails] {
         var arr = [SpaceDetails]()
         
         let headers = header(type: .formData, authorization: true)
         let param = [ "model" : "mro.equipment.location",
                       "domain" : "[[\"asset_categ_type\",\"=\",\"building\"]]",
                       "fields" : "[\"space_name\",\"display_name\",\"maintenance_team_id\"]"]
         
         AFWrapper.multipartRequest(APIBuilder.search(), params: param, headers: headers, success: { (result) in
             if let data = (result as? NSDictionary)?["data"] as? NSArray {
                 var arrz = [( String,Int,Array<Any>,String)]()
                 for i in data {
                     var data = SpaceDetails()
                     if let dic = i as? NSDictionary, let name = dic["display_name"] as? String, let id = dic["id"] as? Int , let maintenance_team_id = dic["maintenance_team_id"] as? Array<Any>,let space_name = dic["space_name"] as? String {
                         arrz.append((name,id,maintenance_team_id,space_name))
                         
                         data.type = "building"
                         data.displayName = name
                         data.name = space_name
                         data.id = String(id)
                         data.haveChilds = true
                         arr.append(data)
                     }
                 }
                self.bldgs = arrz
             } else {
                self.renewToken(result)
             }
         }) { (error) in
             print(error.debugDescription)
         }
         return arr
     }
     /*
     func getbldgLst(completion: @escaping ([String]) -> Void) {
        
        if let data = bldgs {
            completion(data.map{$0.0})
            return
        }
        
        let headers = header(type: .formData, authorization: true)
        let param = [ "model" : "mro.equipment.location",
                      "domain" : "[[\"asset_categ_type\",\"=\",\"building\"]]",
                      "fields" : "[\"space_name\",\"display_name\",\"maintenance_team_id\"]"]
        
        AFWrapper.multipartRequest(APIBuilder.search(), params: param, headers: headers, success: { (result) in
            if let data = (result as? NSDictionary)?["data"] as? NSArray {
                var arr = [( String,Int,Array<Any>,String)]()
                for i in data {
                    if let dic = i as? NSDictionary, let name = dic["display_name"] as? String, let id = dic["id"] as? Int , let maintenance_team_id = dic["maintenance_team_id"] as? Array<Any>,let space_name = dic["space_name"] as? String {
                        arr.append((name,id,maintenance_team_id,space_name))
                    }
                }
                bldgs = arr
                completion(arr.map{$0.0})
            } else {
                renewToken(result)
                completion([])
            }
        }) { (error) in
            print(error.debugDescription)
            completion([])
        }
    }
    */
      func getCategory(completion: @escaping ([String]) -> Void) {
         
         if let data = category {
             completion(data.map{$0.1})
             return
         }
         
         let headers = header(type: .formData, authorization: true)
         let param = [ "model" : "mro.equipment.category",
                       "fields" : "[\"display_name\"]"]
         
         AFWrapper.multipartRequest(APIBuilder.search(), params: param, headers: headers, success: { (result) in
             if let data = (result as? NSDictionary)?["data"] as? NSArray {
                 var arr = [(Int, String)]()
                 for i in data {
                     if let dic = i as? NSDictionary, let name = dic["display_name"] as? String, let id = dic["id"] as? Int {
                         arr.append((id,name))
                     }
                 }
                self.category = arr
                 completion(arr.map{$0.1})
             } else {
                self.renewToken(result)
                 completion([])
             }
         }) { (error) in
             print(error.debugDescription)
             completion([])
         }
     }
     
      func getUNSPSC(completion: @escaping ([String]) -> Void) {
         
         if let data = code {
             completion(data.map{$0.1})
             return
         }
         
         let headers = header(type: .formData, authorization: true)
         let param = [ "model" : "code.unspsc",
                       "fields" : "[\"display_name\"]"]
         
         AFWrapper.multipartRequest(APIBuilder.search(), params: param, headers: headers, success: { (result) in
             if let data = (result as? NSDictionary)?["data"] as? NSArray {
                 var arr = [(Int, String)]()
                 for i in data {
                     if let dic = i as? NSDictionary, let name = dic["display_name"] as? String, let id = dic["id"] as? Int {
                         arr.append((id,name))
                     }
                 }
                self.code = arr
                 completion(arr.map{$0.1})
             } else {
                self.renewToken(result)
                 completion([])
             }
         }) { (error) in
             print(error.debugDescription)
             completion([])
         }
     }
     
      func getPartner(completion: @escaping ([String]) -> Void) {
         
         if let data = partner {
             completion(data.map{$0.1})
             return
         }
         
         let headers = header(type: .formData, authorization: true)
         let param = [ "model" : "res.partner",
                       "fields" : "[\"display_name\"]",
                       "domain" : "[[\"supplier\", \"=\", true]]"]
         
         AFWrapper.multipartRequest(APIBuilder.search(), params: param, headers: headers, success: { (result) in
             if let data = (result as? NSDictionary)?["data"] as? NSArray {
                 var arr = [(Int, String)]()
                 for i in data {
                     if let dic = i as? NSDictionary, let name = dic["display_name"] as? String, let id = dic["id"] as? Int {
                         arr.append((id,name))
                     }
                 }
                self.partner = arr
                 completion(arr.map{$0.1})
             } else {
                self.renewToken(result)
                 completion([])
             }
         }) { (error) in
             print(error.debugDescription)
             completion([])
         }
     }
       func submtSymptomAnswers(activtyId:String,answr:String,completion: @escaping (Int?) -> Void) {
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
     func submtIncidnt(Tkn:String,subj:String,category:String,categoryId:Int,subcategoryId:Int,channel:String,issue_type:String ,tenant_id:Int,asset_id:String,maintenance_team_id:Int,at_done_mro:Bool,completion: @escaping (Int?) -> Void) {
        /* https://demo.helixsense.com/api/create?model=website.support.ticket&values={"subject":"test","type_category":"asset","category_id":55,"sub_category_id":352,"channel":"mobile_app","issue_type":"request","tenant_id":1450,"asset_id":"9104","maintenance_team_id":"547","at_done_mro":true}
  */
         let headers = header(type: .formData, authorization: true)
         let param = [ "model" : "website.support.ticket",
                       "values" : "{\"subject\":\"\(subj)\",\"type_category\":\"\(category)\",\"category_id\":\(categoryId),\"sub_category_id\":\(subcategoryId),\"channel\":\"\(channel)\",\"issue_type\":\"\(issue_type)\",\"tenant_id\":\(tenant_id),\"asset_id\":\(asset_id),\"maintenance_team_id\":\(maintenance_team_id),\"at_done_mro\":\(at_done_mro)}"]
         AFWrapper.multipartRequest(APIBuilder.createID(), params: param, headers: headers, success: { (result) in
            print(result as Any)
             if let id = (result as? NSArray)?.firstObject as? Int {
                 completion(id)
             }
         }) { (error) in
             print(error.debugDescription)
             completion(nil)
         }
     }
      func createID(data: Equipment, completion: @escaping (Int?) -> Void) {
         
         let headers = header(type: .formData, authorization: true)
         let param = [ "model" : "mro.equipment",
                       "values" : "{\"name\":\"\(data.eqName ?? "")\",\"serial\":\"\(data.num ?? "")\",\"model\":\"\(data.model ?? "")\",\"location_id\":\(data.location ?? ""),\"maintenance_team_id\":\(data.team ?? ""),\"mtbf_hours\":\(data.mtbf ?? ""),\"category_id\":\(data.category ?? ""),\"warranty_start_date\":\"\(data.fromDate ?? "")\",\"warranty_end_date\":\"\(data.toDate ?? "")\",\"purchase_date\":\"\(data.date ?? "")\",\"purchase_value\":\"\(data.value ?? "")\",\"risk_cost\":\(data.cost ?? ""),\"commodity_id\":\"\(data.code ?? "")\",\"equipment_number\":\"\(data.eqNum ?? "")\",\"amc_type\":\"\(data.type ?? "")\",\"vendor_id\":\(data.vendor ?? ""),\"manufacturer_id\":\(data.manuf ?? "")}"]
        // LoaderSpin.shared.showLoader()
         AFWrapper.multipartRequest(APIBuilder.createID(), params: param, headers: headers, success: { (result) in
             if let id = (result as? NSArray)?.firstObject as? Int {
                 completion(id)
                 LoaderSpin.shared.hideLoader()
             } else {
                self.renewToken(result) { status in
                     if status {
                        self.createID(data: data) { id in
                             completion(id)
                            LoaderSpin.shared.hideLoader()
                         }
                     } else {
                         completion(nil)
                         LoaderSpin.shared.hideLoader()
                     }
                 }
             }
         }) { (error) in
             print(error.debugDescription)
             completion(nil)
             LoaderSpin.shared.hideLoader()
         }
     }
    func resize(image: UIImage, maxHeight: Float = 350.0, maxWidth: Float = 350.0, compressionQuality: Float = 0.5) -> Data? {
       var actualHeight: Float = Float(image.size.height)
       var actualWidth: Float = Float(image.size.width)
       var imgRatio: Float = actualWidth / actualHeight
       let maxRatio: Float = maxWidth / maxHeight

       if actualHeight > maxHeight || actualWidth > maxWidth {
         if imgRatio < maxRatio {
           //adjust width according to maxHeight
           imgRatio = maxHeight / actualHeight
           actualWidth = imgRatio * actualWidth
           actualHeight = maxHeight
         }
         else if imgRatio > maxRatio {
           //adjust height according to maxWidth
           imgRatio = maxWidth / actualWidth
           actualHeight = imgRatio * actualHeight
           actualWidth = maxWidth
         }
         else {
           actualHeight = maxHeight
           actualWidth = maxWidth
         }
       }
       let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
       UIGraphicsBeginImageContext(rect.size)
       image.draw(in:rect)
       let img = UIGraphicsGetImageFromCurrentImageContext()
       let imageData = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
       UIGraphicsEndImageContext()
       return imageData
     }
    func upldMaskPhto(Tkn: String,img:UIImage) {
                           let currentDate = NSDate()
                           let dateFormatter = DateFormatter()
                           dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                           let convertedDate = dateFormatter.string(from: currentDate as Date)
        
         var  imageData: Data? = self.resize(image: img)
                         var imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
                           
                        
        let dnam = "\(curntSHift.idx)" + "_profile_image_" + "\(convertedDate)"
                             imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
                         imageStr =  imageStr.trimmingCharacters(in: .whitespacesAndNewlines)
                        imageStr =  String(imageStr.filter { !"\r\n\n\t\r".contains($0) })
                              let dataDecoded : Data = Data(base64Encoded: imageStr, options: .ignoreUnknownCharacters)!
                             let decodedimage = UIImage(data: dataDecoded)
                              let stringFields = """
                                  {"name":"
                                  """
                             let stringFields2 = """
                             ","display_name":"
                             """
                             let stringFields3 = """
                             ","datas_fname":"
                             """
                             let stringFields4 = """
                             ","res_id":
                             """
                             let stringFields5 = """
                             ,"res_model":"mro.shift.employee","type":"binary","res_field":"image_medium","mimetype":"image/png","datas":"
                             """
        
        
                           var request = URLRequest(url: URL(string: APIBuilder.createID())!,timeoutInterval: Double.infinity)
                           let string1 = "Bearer "
                           let string2 = Tkn
                           let combined2 = "\(string1) \(String(describing: string2))"
                           request.addValue(combined2, forHTTPHeaderField: "Authorization")
                           
                              let closg = """
                              ",
                              "res_model":"website.support.ticket",
                               "ir_attachment_categ":"",
                              "res_id":
                              """
                              let closg1 = """
                           "}
                           """
                            let closg2 = """
                           ,"mimetype":"image/png","datas":"
                           """
                           let  stringRole1 = "&values="
                           let varRole = "\(stringRole1)\(stringFields)\(dnam)\(String(describing: stringFields2))\(dnam)\(String(describing: stringFields3))\(dnam)\(String(describing: stringFields4))\(curntSHift.idx)\(String(describing: stringFields5))\(String(describing:imageStr))\(closg1)"
                           let postData = NSMutableData(data: "model=ir.attachment".data(using: String.Encoding.utf8)!)
                           postData.append(varRole.data(using: String.Encoding.utf8)!)
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
                                       // let title = jsonc["data"][0]["name"].stringValue
                                       //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
                                       let title = jsonc["data"]
                                       if (title.count > 0)
                                              {
                                                }
                                         }
                                      catch let error as NSError {
                                         print("Failed to load: \(error.localizedDescription)")
                                      }
                                   }
                                      task1.resume()

                             
                       
        }
    func  logoutAPI(Tkn: String)
{
let idy = Int(chsStrtMdl.idWO)
let stringFields1 = """
{"source":"api","check_out":"
"""
let  stringFields2 = """
","co_lat":"
"""
let  stringFields3 = """
","co_long":"
"""
let  stringFields4 = """
","co_status":"
"""
let    offsetFields = """
","co_desc":""}
"""
let    offsetFields1 = """
"}
"""
let    offsetFields2 = """
]
"""


let  ids1 = "&ids=["
let  stringRole5 = "&model=hr.attendance"
let  stringRole2 = "&values="

let dateFormatter1 : DateFormatter = DateFormatter()
let dateFormatter : DateFormatter = DateFormatter()
//  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
dateFormatter1.dateFormat = "dd-MM-yyyy HH:mm:ss"
let date = Date()
let dateString = dateFormatter.string(from: date)
let dateString1 = dateFormatter1.string(from: date)
let lstDatetime = interNt.convertToUTC(dateToConvert: dateString)
let trimmed1 = lstDatetime.trimmingCharacters(in: .whitespacesAndNewlines)
self.instanceOfUser.writeAnyData(key: "lati", value: "")
self.instanceOfUser.writeAnyData(key: "longi", value: "")
let    stringFields = "\(String(describing:stringRole5))\(String(describing:stringRole2))\(stringFields1)\(String(describing:trimmed1))\(String(describing:stringFields2))\(self.instanceOfUser.readStringData(key: "lati"))\(String(describing:stringFields3))\(self.instanceOfUser.readStringData(key: "longi"))\(String(describing: stringFields4))\(String(describing: ""))\(String(describing: offsetFields))\(String(describing: ids1))\(self.instanceOfUser.readStringData(key: "ChekInTim"))\(String(describing:offsetFields2))"
let combinedOffset = "\(stringFields)"
let varRole = "\(String(describing: combinedOffset))"
let url = NSURL(string: "https://demo.helixsense.com/api/v2/write") //Remember to put ATS exception if the URL is not https
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
"status": true
"""
let varstts =  jsonStr?.contains("\(String(describing: nwFlds))") ?? false

if varstts
{


}

}

}

                 
          task1.resume()

          }
       func submtIncidnt_new(Tkn:String,subj:String,category:String,categoryId:Int,subcategoryId:Int,channel:String,issue_type:String ,tenant_id:Int,asset_id:String,maintenance_team_id:Int,at_done_mro:Bool,completion: @escaping (Bool?) -> Void) {
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
     func writeReleas(Tkn:String,completion: @escaping (Bool) -> Void) {
    let  stringRole2 = "&args="
        let idy = curntSHift.space_id
        let tmId = tenantModl.maintenance_team_id
     let stringFields1 = """
     [{"space_id":\(idy),"team_id":\(tmId)}]
     """
    /* let stringFields1 = """
         [{"space_id":\(curntSHift.space_id),"team_id":\(tenantModl.maintenance_team_id)}]
         """
  */
     let    offsetFields2 = """
     ]
     """
     let  ids1 = "&method=mro_order_create_for_shift"
     let  stringRole5 = "&model=mro.shift.employee"
     //let    stringFields = "\(String(describing:stringRole5))\(String(describing:stringRole2))\(String(describing:stringFields1))\(String(describing:ids1))\(curntSHift.space_id)\(String(describing:offsetFields2))"
        let    stringFields = "\(String(describing:stringRole5))\(String(describing:stringRole2))\(String(describing:stringFields1))\(String(describing:ids1))"
          let headers = header(type: .formData, authorization: true)
         let param = (stringFields)
              let url = NSURL(string: APIBuilder.WRITErelesz()) //Remember to put ATS exception if the URL is not https
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
     func cnclBkg(Tkn:String,completion: @escaping (Bool) -> Void) {
    let  stringRole2 = "&values="
     let stringFields1 = """
     {"is_cancelled":true}
     """
     
     let    offsetFields2 = """
     ]
     """
     let  ids1 = "&ids=["
        let idy = curntSchedulModll.id
        let    stringFields = "\(String(describing:stringRole2))\(String(describing:stringFields1))\(String(describing:ids1))\(idy)\(String(describing:offsetFields2))"
         let param = (stringFields)
              let url = NSURL(string: APIBuilder.cncl()) //Remember to put ATS exception if the URL is not https
                              let request = NSMutableURLRequest(url: url! as URL)
                                    let string1 = "Bearer "

                                    let string2 = Tkn
                                    let combined2 = "\(string1) \(String(describing: string2))"

                                  request.addValue(combined2, forHTTPHeaderField: "Authorization")
                              request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //Optional

                              request.httpMethod = "PUT"
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
     func writeOccpd(Tkn:String,completion: @escaping (Bool) -> Void) {
    let  stringRole2 = "&values="
     let stringFields1 = """
     {"space_status":"Occupied"}
     """
     
     let    offsetFields2 = """
     ]
     """
     let  ids1 = "&ids=["
     let  stringRole5 = "&model=mro.equipment.location"
     //let    stringFields = "\(String(describing:stringRole5))\(String(describing:stringRole2))\(String(describing:stringFields1))\(String(describing:ids1))\(curntSHift.space_id)\(String(describing:offsetFields2))"
        let idy = curntSHift.space_id
        let    stringFields = "\(String(describing:stringRole5))\(String(describing:stringRole2))\(String(describing:stringFields1))\(String(describing:ids1))\(idy)\(String(describing:offsetFields2))"
          let headers = header(type: .formData, authorization: true)
         let param = (stringFields)
              let url = NSURL(string: APIBuilder.writeData()) //Remember to put ATS exception if the URL is not https
                                                                                              let request = NSMutableURLRequest(url: url! as URL)
                                                                                                    let string1 = "Bearer "

                                                                                                    let string2 = Tkn
                                                                                                    let combined2 = "\(string1) \(String(describing: string2))"

                                                                                                  request.addValue(combined2, forHTTPHeaderField: "Authorization")
                                                                                              request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //Optional

                                                                                              request.httpMethod = "PUT"
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
                                                                           let nwFlds = """
                                                                           "status": true
                                                                           """
                                                                           let varstts =  jsonStr?.contains("\(String(describing: nwFlds))") ?? false
                                                                           if varstts
                                                                               {
                                                                                print(varstts)
                                                                                 completion(varstts)

                                                                        }

                                                                           }
                                                                           
                                                                       }

                                                                         
                                                                  task1.resume()

                                                                  }
    func writemasqData(Tkn:String,completion: @escaping (Bool) -> Void) {
         let subj = "true"
   let  stringRole2 = "&values="
    let stringFields1 = """
    {"is_mask":true}
    """
    
    let    offsetFields2 = """
    ]
    """
    let  ids1 = "&ids=["
    let  stringRole5 = "&model=mro.shift.employee"
    let    stringFields = "\(String(describing:stringRole5))\(String(describing:stringRole2))\(String(describing:stringFields1))\(String(describing:ids1))\(curntSHift.idx)\(String(describing:offsetFields2))"
         let headers = header(type: .formData, authorization: true)
        let param = (stringFields)
             let url = NSURL(string: APIBuilder.writemskData()) //Remember to put ATS exception if the URL is not https
                                                                                             let request = NSMutableURLRequest(url: url! as URL)
                                                                                                   let string1 = "Bearer "

                                                                                                   let string2 = Tkn
                                                                                                   let combined2 = "\(string1) \(String(describing: string2))"

                                                                                                 request.addValue(combined2, forHTTPHeaderField: "Authorization")
                                                                                             request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //Optional

                                                                                             request.httpMethod = "PUT"
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
      func writeData(data: Equipment, cmnt: String, valid: String, completion: @escaping (Bool) -> Void) {
         
         let today = Date().description.convertDateFormat(from: .yyyyMMddHHmmssSSSS, to: .yyyyMMddHHmmss)
         let headers = header(type: .formData, authorization: true)
         let param = [ "ids" : "[\(data.id ?? "")]",
                       "model" : "mro.equipment",
                       "values" : "{\"name\":\"\(data.eqName ?? "")\",\"serial\":\"\(data.num ?? "")\",\"model\":\"\(data.model ?? "")\",\"location_id\":\(data.location ?? ""),\"maintenance_team_id\":\(data.team ?? ""),\"mtbf_hours\":\(data.mtbf ?? ""),\"category_id\":\(data.category ?? ""),\"warranty_start_date\":\"\(data.fromDate ?? "")\",\"warranty_end_date\":\"\(data.toDate ?? "")\",\"purchase_date\":\"\(data.date ?? "")\",\"purchase_value\":\"\(data.value ?? "")\",\"risk_cost\":\(data.cost ?? ""),\"commodity_id\":\"\(data.code ?? "")\",\"equipment_number\":\"\(data.eqNum ?? "")\",\"amc_type\":\"\(data.type ?? "")\",\"vendor_id\":\(data.vendor ?? ""),\"manufacturer_id\":\(data.manuf ?? ""),\"validation_status\":\"\(valid)\",\"validated_by\":852,\"validated_on\":\"\(today)\",\"comment\":\"\(cmnt)\"}"] as [String : Any]
       //  LoaderSpin.shared.showLoader()
         AFWrapper.multipartRequest(APIBuilder.writeData(), method: .put, params: param, headers: headers, success: { (result) in
            self.renewToken(result) { status in
                 if status {
                    self.writeData(data: data, cmnt: cmnt, valid: valid) { status in
                         completion(status)
                         LoaderSpin.shared.hideLoader()
                     }
                 } else {
                     completion((result as? Bool) == true)
                     LoaderSpin.shared.hideLoader()
                 }
             }
         }) { (error) in
             print(error.debugDescription)
             completion(false)
             LoaderSpin.shared.hideLoader()
         }
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
     
      func getToken(completion: @escaping (Bool) -> Void) {
         let param: [String : Any] = [
             "grant_type" : "password",
             "client_id" : "clientkey",
             "client_secret" : "clientsecret",
             "username" : "samy11@gmail.com",
             "password" : "12345"
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
 }

 
