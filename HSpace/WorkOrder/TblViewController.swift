//
//  TblViewController.swift
//  AMTfm
//
//  Created by DEEBA on 29.04.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//


import SQLite3
import UIKit
import SwiftyJSON
class TblViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectArr = [String]()
    var selectRec = [Int]()
    var assgndEmp: String = ""
    var assgndStts: String = ""
    var cntg : Int = 0
    @IBAction func btnGo(_ sender: UIButton)
    {
            let viewController:
            UIViewController = UIStoryboard(
                name: "WOrderStoryboard", bundle: nil
            ).instantiateViewController(withIdentifier: "WOStory") as! WOrderViewController
            // .instantiatViewControllerWithIdentifier() returns AnyObject!
            // this must be downcast to utilize it

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //show window
            appDelegate.window?.rootViewController = viewController
        }
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func btnAccept(_ sender: UIButton) {
        if selectArr.count > 0{
            btn.isEnabled = false
            for i in 0..<selectArr.count{
                               let stringFields1 = """
                                   &ids=[
                                   """
                                   var   trimmed1  : Int
                trimmed1 = Int(nwOMdl.idee[i]) ?? 0
                                   let  stringFields2 = """
                                   ]
                                   """
                                    let    stringFields = "\(stringFields1)\(trimmed1)\(stringFields2)"
                               let    offsetFields = """
                               &fields=["state","employee_id"]
                               """
                               let combinedOffset = "\(String(describing: offsetFields))\(stringFields)"

                               let varRole = "\(String(describing: combinedOffset))"
                               var request = URLRequest(url: URL(string:"https://demo.helixsense.com/api/v2/iread")!,timeoutInterval: Double.infinity)
                               
                               let string1 = "Bearer "
                               let string2 = tknz
                               let combined2 = "\(string1) \(String(describing: string2))"
                               request.addValue(combined2, forHTTPHeaderField: "Authorization")
                               let postData = NSMutableData(data: "model=mro.order".data(using: String.Encoding.utf8)!)
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
                                  if (title.count > 0){
                                   let empAssgnd = title[0]["employee_id"].stringValue
                                   if empAssgnd == "false"//this wo is not assigned still
                                   {
                                       self.assgndStts = title[0]["state"].stringValue
                                       if (self.assgndStts == "ready"){
                                            self.WritAPI(idey: trimmed1)
                                           }
                                   }
                                           }
                                   }
                                   catch let error as NSError {
                                      print("Failed to load: \(error.localizedDescription)")
                                  }
                                   }
                                   task1.resume()
                    
            }
                
            }
        
    }
    func WritAPI(idey: Int)
    {
                                let stringFields1 = """
                                  model=mro.order&values={"state":"assigned","employee_id":"
                                  """
                                  let nwFlds = """
                                  &ids=[
                                  """
                                  let  stringFields2 = """
                                  ]
                                  """
                                   
                              let    offsetFields = """
                              "}
                              """
                               let    stringFields = "\(stringFields1)\(self.instanceOfUser.readStringData(key: "employeeIdz"))\(offsetFields)"
                              let combinedOffset = "\(stringFields)\(String(describing: nwFlds))\(idey)\(String(describing: stringFields2))"

                              let varRole = "\(String(describing: combinedOffset))"
                                let url = NSURL(string: "https://demo.helixsense.com/api/v2/write") //Remember to put ATS exception if the URL is not https
                                let request = NSMutableURLRequest(url: url! as URL)
                                    let string1 = "Bearer "
                                      let string2 = tknz
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
             self.cntg = self.cntg + 1
             if varstts
                 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                     self.updatTblOrdersStts(idey: idey)
                        }
             }
             
         }

           }
    task1.resume()

    }
    
    func updatTblOrdersStts(idey: Int)  {
        
                               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
                               //opening the database
                                if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                                      print("There's error in opening the database")
                                   }
                                else
                                {
                               if sqlite3_open(file_URL.path, &db) == SQLITE_OK {
                                   
                                    let unqId: Int = idey
                                   // 1
                                     // 2
                                    let empNam  =  self.instanceOfUser.readStringData(key: "employeeNamez" )
                                     let updateStatementString = "UPDATE tbl_orders SET assigned_to = ?,accept_status  = ?,is_flag = ?,sync_status = ?, is_modified_status = ? WHERE unq_id =? ;"
                                     var updateStatement: OpaquePointer?
                                     if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
                                         SQLITE_OK {
                                        let accptStts: Int
                                        accptStts = 1
                                         // is_flag, sync_status,is_modified_status
                                        let isflag: Int
                                        isflag = 0
                                         sqlite3_bind_text(updateStatement, 1, (empNam as NSString).utf8String, -1, nil)
                                         sqlite3_bind_int(updateStatement, 2,Int32(accptStts))
                                         sqlite3_bind_int(updateStatement, 3,Int32(isflag))
                                         sqlite3_bind_int(updateStatement, 4,Int32(isflag))
                                         sqlite3_bind_int(updateStatement, 5,Int32(isflag))
                                         sqlite3_bind_int(updateStatement, 6,(Int32(unqId)))
                                        
                                        if sqlite3_step(updateStatement) == SQLITE_DONE {
                                                            print(unqId)
                                                            print("\nSuccessfully updated row.")
                                                          } else {

                                                            print(unqId)
                                                            print("\nCould not update row.")
                                                          }
                                     }
                                        sqlite3_finalize(updateStatement)
                               }
                               }
                            sqlite3_close(db)
                            db = nil

                            print(self.cntg)
                            print(selectArr.count)
                            if self.cntg == selectArr.count
                            {
                            if #available(iOS 10.0, *) {
                                let viewController:
                                    UIViewController = UIStoryboard(
                                        name: "HomeStoryboard", bundle: nil
                                    ).instantiateViewController(withIdentifier: "HomeStory") as! HomeScreenz
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                     //show window
                                                     appDelegate.window?.rootViewController = viewController
                            } else {
                                // Fallback on earlier versions
                            }
                                
                            }
                    
    }
    
    var   orderIdChk:[String] =  Array(), checklist_idChk:[String] =  Array(),checklist_typeChk:[String] =  Array(),questionChk:[String] =  Array(),
             suggestion_arrayChk:[String] =  Array(),is_submittedChk:[String] =  Array(),header_groupChk:[String] =  Array(),sync_statusChk:[Bool] =  Array()
                
    var interNt = Internt()
     var db:OpaquePointer? = nil
     var instanceOfWOrder = WOglobal()
     var limit = 20
     var total = 0
     var index = 0
     var totalIni = 0
    let instanceOfUser = readWrite()
    var recorsArray:[String] =  Array()
    var tknz = ""
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return   self.index
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            btn.isHidden = false
            tableView.allowsMultipleSelection = true
            tableView.allowsMultipleSelectionDuringEditing = true
            self.selectDeslectCell(tableView: tableView, indexPath: indexPath)
       }

    
  
       func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
           self.selectDeslectCell(tableView: tableView, indexPath: indexPath)
       }
    func timeString(time: TimeInterval) -> String {
        let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60

        // return formated string
        return String(format: "%02ih %02im ", hour, minute)
    }
    func insertTblOrders()
    {
       /* if let strings =
        self.instanceOfWOrder.userDefaults.object(forKey: "InsrtWOArrayz") as? [Any]{
        
        let InsrtWOArrayz = strings.compactMap{ $0 as? [String: Any] }
            
            let  total = InsrtWOArrayz[0]["display_namey"]
            print(total ?? "")
            }*/
        for i in 0..<nwOMdl.idTbl.count {
            
                        var isFlg: String = ""
                                if  nwOMdl.stateTbl[i] == "in_progress"
                                    {
                                    isFlg = "1"
                                    }
                                    else if  nwOMdl.stateTbl[i] == "pause"
                                    {
                                    isFlg = "2"
                                    }
                                    else if  nwOMdl.stateTbl[i] == "done"
                                    {
                                    isFlg = "3"
                                    }
                                    else
                                    {
                                    isFlg = "0"
                                     }
                                    
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
            {
               let queryStatementString = "SELECT * FROM tbl_orders WHERE unq_id=? ;"
               var queryStatement: OpaquePointer?
                let unqId: Int = nwOMdl.idTbl[i]
               // 1
               if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                   SQLITE_OK {
                sqlite3_bind_int(queryStatement, 1,(Int32(unqId)))
                 // 2
                 if sqlite3_step(queryStatement) == SQLITE_ROW {
                    //5Q
                    let Intval: Int
                    if nwOMdl.StatuzTbl[i]{
                    Intval = 1
                        }
                    else {
                    Intval = 0
                        }
                    let Strt: Int
                    if nwOMdl.at_start_mroTbl[i]{
                    Strt = 1
                        }
                    else {
                    Strt = 0
                        }
                    let Dnee: Int
                    if nwOMdl.at_done_mroTbl[i]{
                    Dnee = 1
                        }
                    else {
                    Dnee = 0
                        }
                    let rvw: Int
                    if nwOMdl.at_review_mroTbl[i]{
                    rvw = 1
                        }
                    else {
                    rvw = 0
                        }
                    let enfrce: Int
                    if nwOMdl.enforce_timeTbl[i]{
                    enfrce = 1
                        }
                    else {
                    enfrce = 0
                        }
                    
                 let updateStatementString = "UPDATE tbl_orders SET orderId = ?,desc = ?,assignedby = ?,created_date = ?,status = ?, category = ?,location = ?,priority = ?,assigned_to = ?,asset_name = ?,preventive = ?,start_time = ?,end_time = ?,checklist_ids = ?,asset_id = ?,accept_status = ?,is_flag = ?,sync_status = ?,comapny_name = ?,qr_code = ?,message_ids = ?,at_start_mro = ?,at_done_mro = ?,at_review_mro = ?,team_id = ?,helpdesk_id = ?,enforce_time    = ?,pause_reason = ?,pause_reason_id  = ?,pause_selected_reason = ? WHERE unq_id =? ;"
                 var updateStatement: OpaquePointer?
                 if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
                     SQLITE_OK {
                    
                     // 3
                     sqlite3_bind_text(updateStatement, 1, (nwOMdl.display_nameTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 2,(nwOMdl.causeTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 3,(nwOMdl.mAssignedByTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 4,(nwOMdl.date_scheduledTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 5,(nwOMdl.stateTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 6,(nwOMdl.type_categoryTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 7,(nwOMdl.equipment_location_namTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 8,(nwOMdl.priorityTbl[i] as NSString).utf8String, -1, nil)
                    
                    sqlite3_bind_text(updateStatement, 9,(nwOMdl.mAssignedToTbl[i] as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 10,(nwOMdl.mAssetNamTbl[i] as NSString).utf8String, -1, nil)
                    
                     sqlite3_bind_text(updateStatement, 11, (nwOMdl.maintenance_typeTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 12,(nwOMdl.mStarttmTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 13,(nwOMdl.mEndtmTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 14,(nwOMdl.strchkListTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 15,(nwOMdl.mAssetIdTbl[i] as NSString).utf8String, -1, nil)
                    sqlite3_bind_int(updateStatement, 16,Int32(Intval))
                    sqlite3_bind_text(updateStatement, 17,(isFlg as NSString).utf8String, -1, nil)
                    sqlite3_bind_int(updateStatement, 18,Int32(0))
                    sqlite3_bind_text(updateStatement, 19,(nwOMdl.mCompanyNamTbl[i] as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 20,(nwOMdl.QRcdeTbl[i] as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 21,(nwOMdl.strMsgIdsTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_int(updateStatement, 22,Int32(Strt))
                     sqlite3_bind_int(updateStatement, 23,Int32(Dnee))
                     sqlite3_bind_int(updateStatement, 24,Int32(rvw))
                     sqlite3_bind_text(updateStatement, 25,(nwOMdl.maintenance_team_idTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 26,(nwOMdl.hlpDskId_idTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_int(updateStatement, 27,Int32(enfrce))
                     sqlite3_bind_text(updateStatement, 28,(nwOMdl.strReasonTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 29,(nwOMdl.strReasonIdTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 30,(nwOMdl.strSelectdReasonTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_int(updateStatement, 31,(Int32(unqId)))
                    
                    if sqlite3_step(updateStatement) == SQLITE_DONE {
                  //                      print("\nSuccessfully updated row.")
                                      } else {
                                        print("\nCould not update row.")
                                      }
                 } else {
                   print("\nUPDATE statement is not prepared")
                 }
                    sqlite3_finalize(updateStatement)
                    sqlite3_close(db)
                    db = nil
                   // 3
                  //  let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                   // 5
                  //  print("\nQuery Result:")
                 //   print("\(catid) | \(catSubid)")
               } else {//5P
                    let Intval: Int
                    if nwOMdl.StatuzTbl[i]{
                    Intval = 1
                        }
                    else {
                    Intval = 0
                        }
                    let Strt: Int
                    if nwOMdl.at_start_mroTbl[i]{
                    Strt = 1
                        }
                    else {
                    Strt = 0
                        }
                    let Dnee: Int
                    if nwOMdl.at_done_mroTbl[i]{
                    Dnee = 1
                        }
                    else {
                    Dnee = 0
                        }
                    let rvw: Int
                    if nwOMdl.at_review_mroTbl[i]{
                    rvw = 1
                        }
                    else {
                    rvw = 0
                        }
                    let enfrce: Int
                    if nwOMdl.enforce_timeTbl[i]{
                    enfrce = 1
                        }
                    else {
                    enfrce = 0
                        }
                   let insertStatementString = "INSERT INTO tbl_orders (unq_id,orderId,desc,assignedby,created_date,status,category,location,priority,assigned_to,asset_name,preventive,start_time,end_time,  checklist_ids,asset_id,accept_status,is_flag,sync_status,comapny_name,qr_code,message_ids,at_start_mro,at_done_mro,at_review_mro,team_id,helpdesk_id,enforce_time,pause_reason,pause_reason_id,pause_selected_reason) VALUES (?, ?, ?, ?, ?, ?, ?, ?,?, ?, ?, ?, ?, ?, ?, ?,?, ?, ?, ?, ?, ?, ?, ?,?, ?, ?, ?, ?, ?, ?);"
                   var insertStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
                       SQLITE_OK {
                     // 3
                     sqlite3_bind_int(insertStatement, 1,(Int32(nwOMdl.idTbl[i])))
                     sqlite3_bind_text(insertStatement, 2, (nwOMdl.display_nameTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 3,(nwOMdl.causeTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 4,(nwOMdl.mAssignedByTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 5,(nwOMdl.date_scheduledTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 6,(nwOMdl.stateTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 7,(nwOMdl.type_categoryTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 8,(nwOMdl.equipment_location_namTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 9,(nwOMdl.priorityTbl[i] as NSString).utf8String, -1, nil)
                    
                    sqlite3_bind_text(insertStatement, 10,(nwOMdl.mAssignedToTbl[i] as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 11,(nwOMdl.mAssetNamTbl[i] as NSString).utf8String, -1, nil)
                    
                     sqlite3_bind_text(insertStatement, 12, (nwOMdl.maintenance_typeTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 13,(nwOMdl.mStarttmTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 14,(nwOMdl.mEndtmTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 15,(nwOMdl.strchkListTbl[i] as NSString).utf8String, -1, nil)
                    
                     sqlite3_bind_text(insertStatement, 16,(nwOMdl.mAssetIdTbl[i] as NSString).utf8String, -1, nil)
                    sqlite3_bind_int(insertStatement, 17,Int32(Intval))
                    sqlite3_bind_text(insertStatement, 18,(isFlg as NSString).utf8String, -1, nil)
                    sqlite3_bind_int(insertStatement, 19,Int32(0))
                    sqlite3_bind_text(insertStatement, 20,(nwOMdl.mCompanyNamTbl[i] as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 21,(nwOMdl.QRcdeTbl[i] as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 22,(nwOMdl.strMsgIdsTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_int(insertStatement, 23,Int32(Strt))
                     sqlite3_bind_int(insertStatement, 24,Int32(Dnee))
                     sqlite3_bind_int(insertStatement, 25,Int32(rvw))
                     sqlite3_bind_text(insertStatement, 26,(nwOMdl.maintenance_team_idTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 27,(nwOMdl.hlpDskId_idTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_int(insertStatement, 28,Int32(enfrce))
                     sqlite3_bind_text(insertStatement, 29,(nwOMdl.strReasonTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 30,(nwOMdl.strReasonIdTbl[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 31,(nwOMdl.strSelectdReasonTbl[i] as NSString).utf8String, -1, nil)
                     
                     // 4
                     if sqlite3_step(insertStatement) == SQLITE_DONE {
                       print("\nSuccessfully inserted row.")
                     } else {
                       print("\nCould not insert row.")
                     }
                   } else {
                     print("\nINSERT statement is not prepared.")
                   }
                   // 5
                   sqlite3_finalize(insertStatement)
                    sqlite3_close(db)
                    db = nil
               }

                
               } else {
                   // 6
                 let errorMessage = String(cString: sqlite3_errmsg(db))
                 print("\nQuery is not prepared \(errorMessage)")
               }

            sqlite3_finalize(queryStatement)
                sqlite3_close(db)
                db = nil
           }
    }
       
       }
    func insertChklstTbl(){
       /* if let strings =
        self.instanceOfWOrder.userDefaults.object(forKey: "InsrtWOArrayz") as? [Any]{
        
        let InsrtWOArrayz = strings.compactMap{ $0 as? [String: Any] }
            
            let  total = InsrtWOArrayz[0]["display_namey"]
            print(total ?? "")
            }*/
        
        for i in 0..<checklist_idChk.count {
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
            {
               let queryStatementString = "SELECT * FROM tbl_checklist WHERE checklist_id=? ;"
               var queryStatement: OpaquePointer?
            let checklistid: String = checklist_idChk[i]
               // 1
               if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                   SQLITE_OK {
                 sqlite3_bind_text(queryStatement, 1, (checklistid as NSString).utf8String, -1, nil)                 // 2
                 if sqlite3_step(queryStatement) == SQLITE_ROW {
                    //5Q
                    let syncstatusChk: Int
                    if sync_statusChk[i]{
                    syncstatusChk = 1
                        }
                    else {
                    syncstatusChk = 0
                        }
                    
                 let updateStatementString = "UPDATE tbl_checklist SET orderId = ?,checklist_type = ?,question = ?,suggestion_array = ?,is_submitted = ?, header_group = ?,sync_status = ? WHERE checklist_id=? ;"
                 var updateStatement: OpaquePointer?
                 if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
                     SQLITE_OK {
                    
                     // 3
                     sqlite3_bind_text(updateStatement, 1, (orderIdChk[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 2,(checklist_typeChk[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 3,(questionChk[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 4,(suggestion_arrayChk[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 5,(is_submittedChk[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 6,(header_groupChk[i] as NSString).utf8String, -1, nil)
                    
                    sqlite3_bind_int(updateStatement, 7,Int32(syncstatusChk))
                    sqlite3_bind_text(updateStatement, 8,(checklistid as NSString).utf8String, -1, nil)
                    if sqlite3_step(updateStatement) == SQLITE_DONE {
                                  //      print("\nSuccessfully updated row.")
                                      } else {
                                        print("\nCould not update row.")
                                      }
                 } else {
                   print("\nUPDATE statement is not prepared")
                 }
                    sqlite3_finalize(updateStatement)
                   // 3
                  //  let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                   // 5
                  //  print("\nQuery Result:")
                 //   print("\(catid) | \(catSubid)")
               } else {//5P
                    let syncstatusChk: Int
                    if sync_statusChk[i]{
                    syncstatusChk = 1
                        }
                    else {
                    syncstatusChk = 0
                        }
                   let insertStatementString = "INSERT INTO tbl_checklist (orderId ,checklist_id,checklist_type,question ,suggestion_array,is_submitted, header_group,sync_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?);"
                   var insertStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
                       SQLITE_OK {
                     // 3
                    sqlite3_bind_text(insertStatement, 1, (orderIdChk[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 2,(checklistid as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 3,(checklist_typeChk[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 4,(questionChk[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 5,(suggestion_arrayChk[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 6,(is_submittedChk[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 7,(header_groupChk[i] as NSString).utf8String, -1, nil)
                     sqlite3_bind_int(insertStatement, 8,Int32(syncstatusChk))
                     // 4
                     if sqlite3_step(insertStatement) == SQLITE_DONE {
                    //   print("\nSuccessfully inserted row.")
                     } else {
                       print("\nCould not insert row.")
                     }
                   } else {
                     print("\nINSERT statement is not prepared.")
                   }
                   // 5
                   sqlite3_finalize(insertStatement)
               }

                
               } else {
                   // 6
                 let errorMessage = String(cString: sqlite3_errmsg(db))
                 print("\nQuery is not prepared \(errorMessage)")
               }

            sqlite3_finalize(queryStatement)
           }

            sqlite3_close(db)
            db = nil
    }
         self.orderIdChk.removeAll()
         self.checklist_idChk.removeAll()
         self.checklist_typeChk.removeAll()
         self.questionChk.removeAll()
         self.suggestion_arrayChk.removeAll()
         self.is_submittedChk.removeAll()
         self.header_groupChk.removeAll()
         self.sync_statusChk.removeAll()
       }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == nwOMdl.DisNm.count - 1
        {

            TblOrder(Tkn: tknz)
        }
    }
    func insertTblChklst(Tkn: String)
    {//5S
       /* if let strings =
        self.instanceOfWOrder.userDefaults.object(forKey: "InsrtWOArrayz") as? [Any]{
        x
        let InsrtWOArrayz = strings.compactMap{ $0 as? [String: Any] }
            
            let  total = InsrtWOArrayz[0]["display_namey"]
            print(total ?? "")
            }*/

        for j in 0..<nwOMdl.idTbl.count {
                let dispnam = nwOMdl.display_nameTbl[j]
                let stringFields1 = """
                                                          &fields=["mro_activity_id","id","answer_type","answer_common","mro_quest_grp_id","value_suggested_ids"]&ids=
                                                          """
                                                          var   trimmed1  : String
                                                           trimmed1 = nwOMdl.strchkListTbl[j]
                                                           let    stringFields = "\(stringFields1)\(trimmed1)"
                                                      var request = URLRequest(url: URL(string:"https://demo.helixsense.com/api/v2/iread_checklist")!,timeoutInterval: Double.infinity)
                                                      
                                                      let string1 = "Bearer "
                                                      let string2 = Tkn
                                                      let combined2 = "\(string1) \(String(describing: string2))"
                                                      request.addValue(combined2, forHTTPHeaderField: "Authorization")
                                                      let postData = NSMutableData(data: "model=mro.order.check.list".data(using: String.Encoding.utf8)!)
                                                      postData.append(stringFields.data(using: String.Encoding.utf8)!)
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
                                                         if (title.count > 0){
                                                                for i in 0..<title.count {
                                                                    
                                                                            self.orderIdChk.append(dispnam)
                                                                            self.checklist_idChk.append(jsonc["data"][i]["id"].stringValue)
                                                                            self.checklist_typeChk.append(jsonc["data"][i]["answer_type"].stringValue)
                                                                            if jsonc["data"][i]["mro_activity_id"].stringValue != "false" {
                                                                                self.questionChk.append(jsonc["data"][i]["mro_activity_id"][1].stringValue)
                                                                                }
                                                                            else{
                                                                                    self.questionChk.append("")
                                                                                }
                                                                            if jsonc["data"][i]["answer_type"].stringValue == "suggestion" {
                                                                                let jsonResults = jsonc["data"][i]["value_suggested_ids"].array
                                                                                let suggestion_array = "\(String(describing: jsonResults))"
                                                                                self.suggestion_arrayChk.append(suggestion_array)
                                                                                }
                                                                            else{
                                                                                    self.suggestion_arrayChk.append("")
                                                                            }
                                                                    
                                                                            self.is_submittedChk.append("false")
                                                                            if jsonc["data"][i]["mro_quest_grp_id"].stringValue != "false" {
                                                                                
                                                                                self.header_groupChk.append(jsonc["data"][i]["mro_quest_grp_id"][1].stringValue)
                                                                                }
                                                                            else{
                                                                                    self.header_groupChk.append("")
                                                                                }
                                                                            self.sync_statusChk.append(false)
                                                                    
                                                                }
                                                            nwOMdl.idTbl.removeAll()
                                                            nwOMdl.display_nameTbl.removeAll()
                                                            nwOMdl.causeTbl.removeAll()
                                                            nwOMdl.mAssignedByTbl.removeAll()
                                                            nwOMdl.date_scheduledTbl.removeAll()
                                                            nwOMdl.stateTbl.removeAll()
                                                            nwOMdl.type_categoryTbl.removeAll()
                                                            nwOMdl.equipment_location_namTbl.removeAll()
                                                           nwOMdl.priorityTbl.removeAll()
                                                            nwOMdl.mAssignedToTbl.removeAll()
                                                            nwOMdl.mAssetNamTbl.removeAll()
                                                           nwOMdl.maintenance_typeTbl.removeAll()
                                                            nwOMdl.mStarttmTbl.removeAll()
                                                            nwOMdl.mEndtmTbl.removeAll()
                                                           nwOMdl.StatuzTbl.removeAll()
                                                            nwOMdl.boolz1Tbl.removeAll()
                                                            nwOMdl.boolz2Tbl.removeAll()
                                                            nwOMdl.mCompanyNamTbl.removeAll()
                                                           nwOMdl.strchkListTbl.removeAll()
                                                            nwOMdl.mAssetIdTbl.removeAll()
                                                            nwOMdl.QRcdeTbl.removeAll()
                                                            nwOMdl.strMsgIdsTbl.removeAll()
                                                            nwOMdl.at_start_mroTbl.removeAll()
                                                            nwOMdl.at_done_mroTbl.removeAll()
                                                            nwOMdl.at_review_mroTbl.removeAll()
                                                            nwOMdl.maintenance_team_idTbl.removeAll()
                                                            nwOMdl.hlpDskId_idTbl.removeAll()
                                                            nwOMdl.enforce_timeTbl.removeAll()
                                                            nwOMdl.boolz3Tbl.removeAll()
                                                            nwOMdl.strReasonTbl.removeAll()
                                                            nwOMdl.strReasonIdTbl.removeAll()
                                                            nwOMdl.strSelectdReasonTbl.removeAll()
                                                            self.insertChklstTbl()
                                                            }
                                                            }
                                                         catch let error as NSError {
                                                            print("Failed to load: \(error.localizedDescription)")
                                                        }
                                                        }
                                                            
             task1.resume()
       }

               
               
       }
    
    func fetchFromAPI(paramy: String,reqsty: String,mdlz: String,htpMthd: String) {
        var  display_namey: String = "",chkList:[Int] =  Array(), statey: String = "",Statuzy: Bool  = false, boolzy: Bool  = false, boolz1y: Bool  = false,mAssignedByy: String = "",MtTm_idy: String = "" , causey: String = "", type_categoryy: String = "", equipment_location_namy: String = "", priorityy: String = "",  mCompanyNamy: String = "", maintenance_team_idy: String = "", TmId: String = "", date_start_scheduled: String = "",company_id: String = "",stringFields: String = "",equipment_namy: String = "", Idy: Int = 0,strSelectdReasony: String = "", strReasony: String = "", strReasonIdy: String = "",hlpDskId_idy: String = "", enforce_timey: Bool  = false,at_start_mroy: Bool  = false, at_done_mroy: Bool  = false, at_review_mroy: Bool  = false,mStarttmy: String = "", mEndtmy: String = "",MsgIds:[Int] =  Array(),strMsgIdsy: String = "",date_scheduledy: String = "",maintenance_typey: String = "",strchkListy: String = "", mAssignedToy: String = "",mAssetNamy: String = "",mAssetIdy: String = "", QRcdey: String = "",equipment_idy: String = "", equipment_seqy: String = "",equipment_location_id: String = ""
        tknz = instanceOfUser.readStringData(key: "accessTokenz")
        var title : JSON = [:]
        var request = URLRequest(url: URL(string:reqsty)!,timeoutInterval: Double.infinity)
        let varRole = "\(String(describing: paramy))"
        let string1 = "Bearer "
        let string2 = tknz
        let combined2 = "\(string1) \(String(describing: string2))"
        request.addValue(combined2, forHTTPHeaderField: "Authorization")
        let postData = NSMutableData(data: mdlz.data(using: String.Encoding.utf8)!)
        postData.append(varRole.data(using: String.Encoding.utf8)!)
        request.httpBody = postData as Data
        request.httpMethod = htpMthd
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

         title = jsonc["data"]
            if (title.count > 0){
            for i in 0..<title.count {

                chkList.removeAll()
            MsgIds.removeAll()
            //if (lngth.intValue > 0){
            //      for i in 0..<lngth.intValue {

            Idy = title[i]["id"].int ?? 0
                let strId = String(Idy)
            /*  ["display_name","cause","maintenance_team_id","date_scheduled","state","type_category","equipment_location_id","priority","employee_id","check_list_ids","equipment","equipment_id","equipment_seq","asset_id","asset_seq","id","maintenance_type","date_start_scheduled","date_scheduled","company_id","message_ids","at_start_mro","at_done_mro","at_review_mro","help_desk_id","enforce_time"]*/
            display_namey = title[i]["display_name"].stringValue /////
            if title[i]["cause"].stringValue == "false"
            {
            causey = ""
            }
            else
            {
            causey = title[i]["cause"].stringValue /////
            }

            if title[i]["type_category"].stringValue == "equipment"
            {
            if title[i]["equipment_id"] == "false"
            {

            }
            else
            {

            equipment_namy = title[i]["equipment_id"][1].stringValue
            }
            }
            else
            {
            if title[i]["asset_id"] == "false"
            {

            }
            else
            {
            equipment_location_namy = title[i]["asset_id"][1].stringValue

            }
            }
            if title[i]["equipment_location_id"].stringValue == "false"
            {
            equipment_location_namy = ""
            }
            else
            {
            equipment_location_namy = title[i]["equipment_location_id"][1].stringValue
            } /////
            priorityy = title[i]["priority"].stringValue
            let tmIid  =  self.instanceOfUser.readStringData(key: "TmNm")
            nwOMdl.DisNm.append(display_namey)
            nwOMdl.TmNam.append(tmIid)
            nwOMdl.EqNam.append(equipment_namy)
            nwOMdl.Caus.append(causey)
            nwOMdl.EqLcn.append(equipment_location_namy)
            nwOMdl.Prioritz.append(priorityy)
            nwOMdl.dtSchedule.append(title[i]["date_scheduled"].stringValue)
            nwOMdl.idee.append(strId)
                self.index = self.index  + 1
                self.total = self.total  + 1
            var boolz: Bool
            boolz =  false
            mAssignedByy = ""


            if title[i]["maintenance_team_id"].stringValue == "false"
            {
            mAssignedByy = ""
            MtTm_idy = ""
            }
            else
            {
            MtTm_idy = title[i]["maintenance_team_id"][0].stringValue
           mAssignedByy = title[i]["maintenance_team_id"][1].stringValue
            }
            MtTm_idy = title[i]["maintenance_team_id"][0].stringValue
          statey = title[i]["state"].stringValue
            if title[i]["state"].stringValue == "ready"
            {
            Statuzy = false
            }
            else
            {
            Statuzy = true
            }
            type_categoryy = title[i]["type_category"].stringValue
            if title[i]["equipment_location_id"].stringValue == "false"
            {

            equipment_location_id = ""

            equipment_location_namy = ""
            }
            else
            {
            equipment_location_id = title[i]["equipment_location_id"][0].stringValue

            equipment_location_namy = title[i]["equipment_location_id"][1].stringValue /////
            }
            if title[i]["type_category"].stringValue == "equipment"
            {
            if title[i]["equipment_id"] == "false"
            {

            }
            else
            {

            equipment_idy = title[i]["equipment_id"][0].stringValue
            equipment_namy = title[i]["equipment_id"][1].stringValue
            equipment_seqy = title[i]["equipment_seq"].stringValue
            mAssetNamy = equipment_namy
            mAssetIdy =  equipment_idy
            QRcdey = equipment_seqy
            }
            }
            else
            {
            if title[i]["asset_id"] == "false"
            {
                
            }
            else
            {
            equipment_location_namy = title[i]["asset_id"][1].stringValue
            mAssetNamy = title[i]["asset_id"][1].stringValue
            mAssetIdy =  title[i]["asset_id"][0].stringValue
           QRcdey = title[i]["asset_seq"].stringValue

            }
            }
            priorityy = title[i]["priority"].stringValue
            if title[i]["employee_id"].stringValue == "false"
            {
            mAssignedToy = ""
            }
            else
            {
            mAssignedToy = title[i]["employee_id"][1].stringValue
            }
            if title[i]["check_list_ids"].stringValue == "false"
            {
            strchkListy = "[]"
            }else
            {
            for j in 0..<title[i]["check_list_ids"].count {
            chkList.append(title[i]["check_list_ids"][j].int ?? 0)
            }
            strchkListy = "\(chkList)" // string == "[1,2,3,4]"
            }
            maintenance_typey = title[i]["maintenance_type"].stringValue
            date_start_scheduled = title[i]["date_start_scheduled"].stringValue
            // converttolocal
            date_scheduledy = self.interNt.convertToLocal(incomingFormat: title[i]["date_scheduled"].stringValue)
            if title[i]["company_id"] == "false"
            {

            }
            else
            {
            mCompanyNamy = title[i]["company_id"][1].stringValue
            company_id = title[i]["company_id"][0].stringValue
            if title[i]["company_id"][1].stringValue == "false"
            {
            mAssetNamy = ""
            }

            }
            if title[i]["message_ids"].stringValue == "false"
            {
            strMsgIdsy = "[]"
            }else
            {
            for j in 0..<title[i]["message_ids"].count {
            MsgIds.append(title[i]["message_ids"][j].int ?? 0)
            }
            strMsgIdsy = "\(MsgIds)" // string == "[1,2,3,4]"
            }
            //  message_ids = title[i]["message_ids"].stringValue
            // for k in 0..<title[i]["message_ids"].count {
            //  print(title[i]["message_ids"][k])
            //     }
            if title[i]["date_start_execution"].stringValue == "false"
            {
            mStarttmy = ""
            }
            else
            {
            mStarttmy = self.interNt.convertToLocal(incomingFormat:title[i]["date_start_execution"].stringValue)
            }
            if title[i]["date_execution"].stringValue == "false"
            {
            mEndtmy = ""
            }
            else
            {
            mEndtmy = self.interNt.convertToLocal(incomingFormat:title[i]["date_execution"].stringValue)
            }
            at_start_mroy = title[i]["at_start_mro"].bool ?? false
            at_done_mroy = title[i]["at_done_mro"].bool ?? false
            at_review_mroy = title[i]["at_review_mro"].bool ?? false

            if title[i]["help_desk_id"].stringValue == "false"
            {
            hlpDskId_idy = ""
            }
            else{
            hlpDskId_idy = title[i]["help_desk_id"][0].stringValue
            }
            enforce_timey = title[i]["enforce_time"].bool ?? false
            if title[i]["pause_reason_id"].stringValue == "false"
            {
            }
            else{
            strReasony = title[i]["reason"].stringValue
            strReasonIdy = title[i]["pause_reason_id"][0].stringValue
            strSelectdReasony = title[i]["pause_reason_id"][1].stringValue

            }

            if statey == "draft"
            {
            }
            else{
            nwOMdl.idTbl.append(Idy)
            nwOMdl.display_nameTbl.append(display_namey)
            nwOMdl.causeTbl.append(causey)
            nwOMdl.mAssignedByTbl.append(mAssignedByy)
            nwOMdl.date_scheduledTbl.append(date_scheduledy)
            nwOMdl.stateTbl.append(statey)
            nwOMdl.type_categoryTbl.append(type_categoryy)
            nwOMdl.equipment_location_namTbl.append(equipment_location_namy)
            nwOMdl.priorityTbl.append(priorityy)
            nwOMdl.mAssignedToTbl.append(mAssignedToy)
            nwOMdl.mAssetNamTbl.append(mAssetNamy)
            nwOMdl.maintenance_typeTbl.append(maintenance_typey)
            nwOMdl.mStarttmTbl.append(mStarttmy)
            nwOMdl.mEndtmTbl.append(mEndtmy)
            nwOMdl.StatuzTbl.append(Statuzy)
            nwOMdl.boolz1Tbl.append(boolz)
            nwOMdl.boolz2Tbl.append(boolz)
                nwOMdl.mCompanyNamTbl.append(mCompanyNamy)
            nwOMdl.strchkListTbl.append(strchkListy)
            nwOMdl.mAssetIdTbl.append(mAssetIdy)
            nwOMdl.QRcdeTbl.append(QRcdey)
            nwOMdl.strMsgIdsTbl.append(strMsgIdsy)
            nwOMdl.at_start_mroTbl.append(at_start_mroy)
            nwOMdl.at_done_mroTbl.append(at_done_mroy)
            nwOMdl.at_review_mroTbl.append(at_review_mroy)
            nwOMdl.maintenance_team_idTbl.append(maintenance_team_idy)
            nwOMdl.hlpDskId_idTbl.append(hlpDskId_idy)
            nwOMdl.enforce_timeTbl.append(enforce_timey)
            nwOMdl.boolz3Tbl.append(boolz)
            nwOMdl.strReasonTbl.append(strReasony)
            nwOMdl.strReasonIdTbl.append(strReasonIdy)
            nwOMdl.strSelectdReasonTbl.append(strSelectdReasony)


            }

            }
            self.instanceOfUser.writeAnyData(key: "MsgIds", value: strMsgIdsy )
            DispatchQueue.main.sync {
            //Update UI
            self.tableView.reloadData()
            }

            //Here call your function
            self.insertTblOrders()
            self.insertTblChklst(Tkn: self.tknz)

            self.instanceOfUser.writeAnyData(key: "offsetzTbl", value: self.instanceOfUser.readIntData(key:  "offsetzTbl") + 20)


            }
            }
            catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
                title = "error"
            }
         }
        task1.resume()
        // return formated string
    }
   
func TblOrder(Tkn: String){
        //5N
        // read the last updated value from the table and if update value is empty  the domain filed should be [] array otherwise send the last update value in the domain field like this [["write_date",">","2020-02-23 08:27:08"]] and the time should send UTC format.
        var   TmId: String = "",stringFields: String = ""

        TmId = self.instanceOfUser.readStringData(key: "MTmId")


        let stringFields1 = """
        &domain=["%26",["maintenance_team_id.id","=",
        """
        var   trimmed1  : Int
        trimmed1 = Int(TmId) ?? 0
        let  stringFields2 = """
        ],["state","=","ready"]]
        """
        stringFields = "\(stringFields1)\(trimmed1)\(String(describing: stringFields2))"


        let    offsetFields = """
        &groupby=["company_id"]&order=date_planned DESC&fields=["display_name","cause","maintenance_team_id","date_scheduled","state","type_category","equipment_location_id","priority","employee_id","check_list_ids","equipment","equipment_id","equipment_seq","asset_id","asset_seq","id","maintenance_type","date_start_scheduled","date_scheduled","company_id","message_ids","at_start_mro","at_done_mro","at_review_mro","help_desk_id","date_start_execution","date_execution","enforce_time"]&limit=20&offset=
        """
        let reqstStr = "https://demo.helixsense.com/api/v2/isearch_read"
        let stringOff = instanceOfUser.readIntData(key:  "offsetzTbl")
        let combinedOffset = "\(stringFields)\(String(describing: offsetFields))\(stringOff)"
        let varRole = "\(String(describing: combinedOffset))"
        let mdl = "model=mro.order"
        let mthd = "POST"
        fetchFromAPI(paramy: varRole,reqsty: reqstStr,mdlz: mdl,htpMthd: mthd)
}

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tblcell", for: indexPath) as! TblTableViewCell
        cell.DisNam.text = nwOMdl.DisNm[indexPath.row]
           cell.TmNam.text = nwOMdl.TmNam[indexPath.row]
           cell.eqpNam.text = nwOMdl.EqNam[indexPath.row]  + "  " +  nwOMdl.Caus[indexPath.row]
            cell.Caus.text = nwOMdl.idee[indexPath.row]
            let message: String = nwOMdl.EqLcn[indexPath.row]
           //set the text and style if any.
          
            cell.eqpLcn.text = message
           let prioriti: String = nwOMdl.Prioritz[indexPath.row]
           if(prioriti == "0"){
               cell.ImgStts.image = UIImage(named: "Rectangle 15-2")
               cell.lblstatus.text = "Low"
               }
           if(prioriti == "1"){
               cell.ImgStts.image = UIImage(named: "Rectangle 15-3")
               cell.lblstatus.text = "Normal"
           }
           if(prioriti == "2"){
               cell.ImgStts.image = UIImage(named: "Rectangle 15-1")
               cell.lblstatus.text? = "High"
           }
           if(prioriti == "3"){
               cell.ImgStts.image = UIImage(named: "Rectangle 15-4")
               cell.lblstatus.text? = "Breakdown"
           }
           let chkdTim  = nwOMdl.dtSchedule[indexPath.row]
          let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

           let date = Date()
           let dateString = dateFormatter.string(from: date)
        let lstDatetime = interNt.convertToUTC(dateToConvert: dateString)
           let dateString1 = chkdTim
           let dateString2 = lstDatetime

           let Dateformatter = DateFormatter()
           Dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"


        let date1 = Dateformatter.date(from: dateString1 )
        let date2 = Dateformatter.date(from: dateString2  )


           let distanceBetweenDates: TimeInterval? = date1?.timeIntervalSince(date2!)
           let secbetweenDates = Int(distanceBetweenDates!)
          
          if(Int(distanceBetweenDates!)
           > 0){
              cell.ImgTim.image = UIImage(named: "Group-13")
          }
          else
          {
              cell.ImgTim.image = UIImage(named: "Group-14")
          }
            cell.lblTim?.text = timeString(time: TimeInterval(abs(secbetweenDates)))
            cell.contentView.layer.cornerRadius = 4.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor

            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.red
            cell.selectedBackgroundView = backgroundView
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.instanceOfUser.writeAnyData(key: "MsgIds", value: "" )
        nwOMdl.strMsgIdsTbl = []
        nwOMdl.mAssetIdTbl = []
        nwOMdl.QRcdeTbl = []
        nwOMdl.DisNm = []
        nwOMdl.TmNam = []
        nwOMdl.EqNam = []
       nwOMdl.Caus = []
       nwOMdl.EqLcn = []
       nwOMdl.Prioritz = []
       nwOMdl.dtSchedule = []
       nwOMdl.idee = []
       nwOMdl.idTbl = []
       nwOMdl.causeTbl = []
       nwOMdl.stateTbl = []
       nwOMdl.display_nameTbl = []
       nwOMdl.mAssignedByTbl = []
       nwOMdl.date_scheduledTbl = []
       nwOMdl.type_categoryTbl = []
       nwOMdl.equipment_location_namTbl = []
       nwOMdl.priorityTbl = []
       nwOMdl.mAssignedToTbl = []
       nwOMdl.mAssetNamTbl = []
       nwOMdl.maintenance_typeTbl = []
       nwOMdl.mStarttmTbl = []
       nwOMdl.mEndtmTbl = []
       nwOMdl.StatuzTbl = []
       nwOMdl.boolz1Tbl = []
       nwOMdl.boolz2Tbl = []
       nwOMdl.mCompanyNamTbl = []
       nwOMdl.strchkListTbl = []
       nwOMdl.at_start_mroTbl = []
       nwOMdl.at_done_mroTbl = []
       nwOMdl.at_review_mroTbl = []
       nwOMdl.maintenance_team_idTbl = []
       nwOMdl.hlpDskId_idTbl = []
       nwOMdl.enforce_timeTbl = []
       nwOMdl.boolz3Tbl = []
       nwOMdl.strReasonTbl = []
       nwOMdl.strReasonIdTbl = []
       nwOMdl.strSelectdReasonTbl = []
        tableView.delegate = self
        tableView.dataSource = self
        btn.isHidden = true
        tknz = instanceOfUser.readStringData(key: "accessTokenz")
        
        instanceOfUser.writeAnyData(key: "offsetzTbl", value: 0)
        TblOrder(Tkn: tknz)
        
        // Do any additional setup after loading the view.
    }
    func showToast(message: String) {
            let toastLabel = UITextView(frame: CGRect(x: self.view.frame.size.width/16, y: self.view.frame.size.height-150, width: self.view.frame.size.width * 7/8, height: 50))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center;
            toastLabel.text = "   \(message)   "
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            toastLabel.font = UIFont(name: (toastLabel.font?.fontName)!, size: 16)
            toastLabel.center.x = self.view.frame.size.width/2
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
    }
    func selectDeslectCell(tableView: UITableView,indexPath: IndexPath){
        self.selectArr.removeAll()
        self.selectRec.removeAll()
        if let arr = tableView.indexPathsForSelectedRows
        {
            self.btn.isHidden = false
            for index in arr
            {
                //check for status n if not assigned accept btn visible else msg that the wo is assigned already
                    btn.isHidden = false
                selectArr.append(nwOMdl.idee[index.row])
            }
        
        }
        else
        {
            btn.isHidden = true
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
