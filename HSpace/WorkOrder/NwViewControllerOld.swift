//
//  NwViewController.swift
//  AMTfm
//
//  Created by DEEBA on 03.04.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import SQLite3
import UIKit
import SwiftyJSON


class NwViewController:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var interNt = Internt()
     var db:OpaquePointer? = nil
     var instanceOfWOrder = WOglobal()
     var limit = 20
     var total = 0
     var index = 0
     var totalIni = 0
    let instanceOfUser = readWrite()
    var recorsArray:[String] =  Array()
    var DisNm:[String] =  Array()
    var TmNam:[String] =  Array()
    var EqNam:[String] =  Array()
    var Caus:[String] =  Array()
    var EqLcn:[String] =  Array()
    var Prioritz:[String] =  Array()
    var dtSchedule:[String] =  Array()
    var tknz = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        tknz = instanceOfUser.readStringData(key: "accessTokenz")
        
        instanceOfUser.writeAnyData(key: "offsetzTbl", value: 0)
        TblOrder(Tkn: tknz)
        // Do any additional setup after loading the view.
    }
   
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return    self.index
        }
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
            if indexPath.row == DisNm.count - 1
            {

                TblOrder(Tkn: tknz)
            }
            
        }
        @objc func loadTbl()
        {
            self.collectionView.reloadData()
        }
          func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                let bounds  = collectionView.bounds
                return CGSize(width: bounds.width , height: 100)
            }
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
                return 0
            }
            func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
               // print(TmNm[indexPath.row])
            }
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return 0
            }
        func timeString(time: TimeInterval) -> String {
            let hour = Int(time) / 3600
            let minute = Int(time) / 60 % 60

            // return formated string
            return String(format: "%02ih %02im ", hour, minute)
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellNw", for: indexPath) as! NwCollectionViewCell
             cell.DisNam.text = DisNm[indexPath.row] as? String
               cell.TmNam.text = TmNam[indexPath.row] as? String
               cell.eqpNam.text = EqNam[indexPath.row] as? String
               cell.Caus.text = Caus[indexPath.row] as? String
                let message: String = EqLcn[indexPath.row] as? String ?? ""
               //set the text and style if any.
                cell.eqpLcn.text = message
               let prioriti: String = Prioritz[indexPath.row] as? String ?? ""
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
               let chkdTim  = dtSchedule[indexPath.row]
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
            return cell
        }
        func TblOrder(Tkn: String){
        //5N
                                        // read the last updated value from the table and if update value is empty  the domain filed should be [] array otherwise send the last update value in the domain field like this [["write_date",">","2020-02-23 08:27:08"]] and the time should send UTC format.
                                       var  display_namey: String = "",chkList:[String] =  Array(), statey: String = "",Statuzy: Bool  = false, boolzy: Bool  = false, boolz1y: Bool  = false,mAssignedByy: String = "",MtTm_idy: String = "" , causey: String = "", type_categoryy: String = "", equipment_location_namy: String = "", priorityy: String = "",  mCompanyNamy: String = "", maintenance_team_idy: String = "", TmId: String = "", date_start_scheduled: String = "",company_id: String = "",stringFields: String = "",equipment_namy: String = "", Idy: Int = 0,strSelectdReasony: String = "", strReasony: String = "", strReasonIdy: String = "",hlpDskId_idy: String = "", enforce_timey: Bool  = false,at_start_mroy: Bool  = false, at_done_mroy: Bool  = false, at_review_mroy: Bool  = false,mStarttmy: String = "", mEndtmy: String = "",MsgIds:[String] =  Array(),strMsgIdsy: String = "",date_scheduledy: String = "",maintenance_typey: String = "",strchkListy: String = "", mAssignedToy: String = "",mAssetNamy: String = "",mAssetIdy: String = "", QRcdey: String = "",equipment_idy: String = "", equipment_seqy: String = "",equipment_location_id: String = ""
                                        
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
                                         var request = URLRequest(url: URL(string:"https://demo.helixsense.com/api/v2/isearch_read")!,timeoutInterval: Double.infinity)
                                          let stringOff = instanceOfUser.readIntData(key:  "offsetzTbl")
                                         let combinedOffset = "\(stringFields)\(String(describing: offsetFields))\(stringOff)"
                                         let varRole = "\(String(describing: combinedOffset))"
                                         let string1 = "Bearer "
                                         let string2 = Tkn
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
                                                 for i in 0..<title.count {
                                                     
                                             //if (lngth.intValue > 0){
                                               //      for i in 0..<lngth.intValue {
                                                  
                                                   
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
                                                     self.DisNm.append(display_namey)
                                                      self.TmNam.append(tmIid)
                                                      self.EqNam.append(equipment_namy)
                                                      self.Caus.append(causey)
                                                      self.EqLcn.append(equipment_location_namy)
                                                      self.Prioritz.append(priorityy)
                                                      self.dtSchedule.append(title[i]["date_scheduled"].stringValue)
                                                    
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
                                                                  chkList.append(title[i]["check_list_ids"][j].stringValue)
                                                            }
                                                            strchkListy = "\(chkList)" // string == "[1,2,3,4]"
                                                    }
                                                Idy = title[i]["id"].int ?? 0
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
                                                              MsgIds.append(title[i]["message_ids"][j].stringValue)
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
                                                        self.insertTblOrders(idy: Idy,display_name: display_namey,cause:causey,mAssignedBy:mAssignedByy,date_scheduled:date_scheduledy,state:statey,type_category:type_categoryy,equipment_location_nam:equipment_location_namy,priority:priorityy,mAssignedTo:mAssignedToy,mAssetNam:mAssetNamy,maintenance_type:maintenance_typey,mStarttm:mStarttmy,mEndtm:mEndtmy,Statuz:Statuzy,boolz1:boolz,boolz2:boolz,mCompanyNam:mCompanyNamy,strchkList:strchkListy,mAssetId:mAssetIdy,QRcde:QRcdey,strMsgIds:strMsgIdsy,at_start_mro:at_start_mroy,at_done_mro:at_done_mroy,at_review_mro:at_review_mroy,maintenance_team_id:maintenance_team_idy,hlpDskId_id:hlpDskId_idy,enforce_time:enforce_timey,boolz3:boolz,strReason:strReasony,strReasonId:strReasonIdy,strSelectdReason:strSelectdReasony)
                                                        }
                                                     }
                                                 DispatchQueue.main.async {
                                                    
                                                    self.collectionView.reloadData()
                                                 }
                                                  self.instanceOfUser.writeAnyData(key: "offsetzTbl", value: self.instanceOfUser.readIntData(key:  "offsetzTbl") + 20)

                                                 
                                                 }

                                             else{
                                                 
                                             }
                                               }
                                            catch let error as NSError {
                                               print("Failed to load: \(error.localizedDescription)")
                                           }
                                          }
           task1.resume()
                 }
    func insertTblOrders(idy: Int,display_name: String,cause: String,mAssignedBy: String,date_scheduled: String,state: String,type_category: String,equipment_location_nam: String,
                         priority: String,
                         
                         mAssignedTo: String,mAssetNam: String,maintenance_type: String,mStarttm: String,mEndtm: String,
                         Statuz: Bool,boolz1: Bool,boolz2: Bool,mCompanyNam: String,
                         strchkList: String,mAssetId: String,QRcde: String,strMsgIds: String,at_start_mro: Bool,
                         at_done_mro: Bool,at_review_mro: Bool,maintenance_team_id: String,hlpDskId_id: String,enforce_time: Bool,boolz3: Bool,
                         strReason: String,strReasonId: String,strSelectdReason: String)
    {
       /* if let strings =
        self.instanceOfWOrder.userDefaults.object(forKey: "InsrtWOArrayz") as? [Any]{
        
        let InsrtWOArrayz = strings.compactMap{ $0 as? [String: Any] }
            
            let  total = InsrtWOArrayz[0]["display_namey"]
            print(total ?? "")
            }*/
                        var isFlg: String = ""
                                if  state == "in_progress"
                                    {
                                    isFlg = "1"
                                    }
                                    else if  state == "pause"
                                    {
                                    isFlg = "2"
                                    }
                                    else if  state == "done"
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
            let unqId: Int = idy
               // 1
               if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                   SQLITE_OK {
                sqlite3_bind_int(queryStatement, 1,(Int32(unqId)))
                 // 2
                 if sqlite3_step(queryStatement) == SQLITE_ROW {
                    //5Q
                    let Intval: Int
                    if Statuz{
                    Intval = 1
                        }
                    else {
                    Intval = 0
                        }
                    let Strt: Int
                    if at_start_mro{
                    Strt = 1
                        }
                    else {
                    Strt = 0
                        }
                    let Dnee: Int
                    if at_done_mro{
                    Dnee = 1
                        }
                    else {
                    Dnee = 0
                        }
                    let rvw: Int
                    if at_review_mro{
                    rvw = 1
                        }
                    else {
                    rvw = 0
                        }
                    let enfrce: Int
                    if enforce_time{
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
                     sqlite3_bind_text(updateStatement, 1, (display_name as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 2,(cause as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 3,(mAssignedBy as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 4,(date_scheduled as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 5,(state as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 6,(type_category as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 7,(equipment_location_nam as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 8,(priority as NSString).utf8String, -1, nil)
                    
                    sqlite3_bind_text(updateStatement, 9,(mAssignedTo as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 10,(mAssetNam as NSString).utf8String, -1, nil)
                    
                     sqlite3_bind_text(updateStatement, 11, (maintenance_type as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 12,(mStarttm as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 13,(mEndtm as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 14,(strchkList as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 15,(mAssetId as NSString).utf8String, -1, nil)
                    sqlite3_bind_int(updateStatement, 16,Int32(Intval))
                    sqlite3_bind_text(updateStatement, 17,(isFlg as NSString).utf8String, -1, nil)
                    sqlite3_bind_int(updateStatement, 18,Int32(0))
                    sqlite3_bind_text(updateStatement, 19,(mCompanyNam as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 20,(QRcde as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 21,(strMsgIds as NSString).utf8String, -1, nil)
                     sqlite3_bind_int(updateStatement, 22,Int32(Strt))
                     sqlite3_bind_int(updateStatement, 23,Int32(Dnee))
                     sqlite3_bind_int(updateStatement, 24,Int32(rvw))
                     sqlite3_bind_text(updateStatement, 25,(maintenance_team_id as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 26,(hlpDskId_id as NSString).utf8String, -1, nil)
                     sqlite3_bind_int(updateStatement, 27,Int32(enfrce))
                     sqlite3_bind_text(updateStatement, 28,(strReason as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 29,(strReasonId as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(updateStatement, 30,(strSelectdReason as NSString).utf8String, -1, nil)
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
                    if Statuz{
                    Intval = 1
                        }
                    else {
                    Intval = 0
                        }
                    let Strt: Int
                    if at_start_mro{
                    Strt = 1
                        }
                    else {
                    Strt = 0
                        }
                    let Dnee: Int
                    if at_done_mro{
                    Dnee = 1
                        }
                    else {
                    Dnee = 0
                        }
                    let rvw: Int
                    if at_review_mro{
                    rvw = 1
                        }
                    else {
                    rvw = 0
                        }
                    let enfrce: Int
                    if enforce_time{
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
                     sqlite3_bind_int(insertStatement, 1,(Int32(idy)))
                     sqlite3_bind_text(insertStatement, 2, (display_name as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 3,(cause as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 4,(mAssignedBy as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 5,(date_scheduled as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 6,(state as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 7,(type_category as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 8,(equipment_location_nam as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 9,(priority as NSString).utf8String, -1, nil)
                    
                    sqlite3_bind_text(insertStatement, 10,(mAssignedTo as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 11,(mAssetNam as NSString).utf8String, -1, nil)
                    
                     sqlite3_bind_text(insertStatement, 12, (maintenance_type as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 13,(mStarttm as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 14,(mEndtm as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 15,(strchkList as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 16,(mAssetId as NSString).utf8String, -1, nil)
                    sqlite3_bind_int(insertStatement, 17,Int32(Intval))
                    sqlite3_bind_text(insertStatement, 18,(isFlg as NSString).utf8String, -1, nil)
                    sqlite3_bind_int(insertStatement, 19,Int32(0))
                    sqlite3_bind_text(insertStatement, 20,(mCompanyNam as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 21,(QRcde as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 22,(strMsgIds as NSString).utf8String, -1, nil)
                     sqlite3_bind_int(insertStatement, 23,Int32(Strt))
                     sqlite3_bind_int(insertStatement, 24,Int32(Dnee))
                     sqlite3_bind_int(insertStatement, 25,Int32(rvw))
                     sqlite3_bind_text(insertStatement, 26,(maintenance_team_id as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 27,(hlpDskId_id as NSString).utf8String, -1, nil)
                     sqlite3_bind_int(insertStatement, 28,Int32(enfrce))
                     sqlite3_bind_text(insertStatement, 29,(strReason as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 30,(strReasonId as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 31,(strSelectdReason as NSString).utf8String, -1, nil)
                     
                     // 4
                     if sqlite3_step(insertStatement) == SQLITE_DONE {
                     //  print("\nSuccessfully inserted row.")
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
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


