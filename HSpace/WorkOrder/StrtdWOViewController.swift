        //
        //  StrtdWOViewController.swift
        //  AMTfm
        //satheesh@dcs.kf.in
        //  Created by DEEBA on 17.04.20.
        //  Copyright © 2020 Dabus.tv. All rights reserved.
        //

        import SQLite3
        import UIKit
        import SwiftyJSON
        class StrtdWOViewController:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
            
            @IBAction func btnGobck(_ sender: Any) {
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
            @IBOutlet weak var collectionViewStrt: UICollectionView!
            var idTbl:[Int] =  Array(),display_nameTbl :[String] =  Array()
            ,causeTbl:[String] =  Array(),mAssignedByTbl:[String] =  Array(),date_scheduledTbl:[String] =  Array(),stateTbl:[String] =  Array(),type_categoryTbl:[String] =  Array(),equipment_location_namTbl:[String] =  Array(),priorityTbl:[String] =  Array(),mAssignedToTbl:[String] =  Array(),mAssetNamTbl:[String] =  Array(),maintenance_typeTbl:[String] =  Array(),mStarttmTbl:[String] =  Array(),mEndtmTbl:[String] =  Array(),StatuzTbl:[Bool] =  Array(),boolz1Tbl:[Bool] =  Array(),boolz2Tbl:[Bool] =  Array(),mCompanyNamTbl:[String] =  Array(),strchkListTbl:[String] =  Array(),mAssetIdTbl:[String] =  Array(),QRcdeTbl:[String] =  Array(),strMsgIdsTbl:[String] =  Array(),at_start_mroTbl:[Bool] =  Array(),at_done_mroTbl:[Bool] =  Array(),at_review_mroTbl:[Bool] =  Array(),maintenance_team_idTbl:[String] =  Array(),hlpDskId_idTbl:[String] =  Array(),enforce_timeTbl:[Bool] =  Array(),boolz3Tbl:[Bool] =  Array(),strReasonTbl:[String] =  Array(),strReasonIdTbl:[String] =  Array(),strSelectdReasonTbl:[String] =  Array()
            var   orderIdChkStrtd:[String] =  Array(), checklist_idChkStrtd:[String] =  Array(),checklist_typeChkStrtd:[String] =  Array(),questionChkStrtd:[String] =  Array(),
                        suggestion_arrayChkStrtd:[String] =  Array(),is_submittedChkStrtd:[String] =  Array(),header_groupChkStrtd:[String] =  Array(),sync_statusChkStrtd:[Bool] =  Array()
            var interNt = Internt()
             var db:OpaquePointer? = nil
             var instanceOfWOrder = WOglobal()
             var limitStrt = 20
             var totalStrt = 0
             var indexStrt = 0
             var totalIniStrt = 0
            let instanceOfUser = readWrite()
            var recorsArray:[String] =  Array()
            var DisNmStrt:[String] =  Array()
            var TmNamStrt:[String] =  Array()
            var EqNamStrt:[String] =  Array()
            var CausStrt:[String] =  Array()
            var EqLcnStrt:[String] =  Array()
            var PrioritzStrt:[String] =  Array()
            var dtScheduleStrt:[String] =  Array()
            var tknz = ""
            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                print(self.indexStrt)
                return self.indexStrt
            }
            func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            
                if indexPath.row == DisNmStrt.count - 1
                {

                    TblOrderStrt(Tkn: tknz)
                    
                }
                
            }
           
            
            
            override func viewDidLoad() {
                super.viewDidLoad()
                collectionViewStrt.dataSource = self
                collectionViewStrt.delegate = self
                self.instanceOfUser.writeAnyData(key: "MsgIds", value: "" )
                
                DisNmStrt.removeAll()
                TmNamStrt.removeAll()
                EqNamStrt.removeAll()
                EqLcnStrt.removeAll()
                CausStrt.removeAll()
                dtScheduleStrt.removeAll()
                PrioritzStrt.removeAll()
                self.orderIdChkStrtd.removeAll()
                 self.checklist_idChkStrtd.removeAll()
                 self.checklist_typeChkStrtd.removeAll()
                self.questionChkStrtd.removeAll()
                 self.suggestion_arrayChkStrtd.removeAll()
                 self.is_submittedChkStrtd.removeAll()
                 self.header_groupChkStrtd.removeAll()
                self.sync_statusChkStrtd.removeAll()
                self.idTbl.removeAll()
                self.display_nameTbl.removeAll()
                self.causeTbl.removeAll()
                self.mAssignedByTbl.removeAll()
                self.date_scheduledTbl.removeAll()
                self.stateTbl.removeAll()
                self.type_categoryTbl.removeAll()
                self.equipment_location_namTbl.removeAll()
                self.priorityTbl.removeAll()
                self.mAssignedToTbl.removeAll()
                self.mAssetNamTbl.removeAll()
                self.maintenance_typeTbl.removeAll()
                self.mStarttmTbl.removeAll()
                self.mEndtmTbl.removeAll()
                self.StatuzTbl.removeAll()
                self.boolz1Tbl.removeAll()
                self.boolz2Tbl.removeAll()
                self.mCompanyNamTbl.removeAll()
                self.strchkListTbl.removeAll()
                self.mAssetIdTbl.removeAll()
                self.QRcdeTbl.removeAll()
                self.strMsgIdsTbl.removeAll()
                self.at_start_mroTbl.removeAll()
                self.at_done_mroTbl.removeAll()
                self.at_review_mroTbl.removeAll()
                self.maintenance_team_idTbl.removeAll()
                self.hlpDskId_idTbl.removeAll()
                self.enforce_timeTbl.removeAll()
                self.boolz3Tbl.removeAll()
                self.strReasonTbl.removeAll()
                self.strReasonIdTbl.removeAll()
                self.strSelectdReasonTbl.removeAll()
                tknz = instanceOfUser.readStringData(key: "accessTokenz")
                
                instanceOfUser.writeAnyData(key: "offsetzTblStrt", value: 0)
                TblOrderStrt(Tkn: tknz)
            }
            
            @objc func loadTbl()
            {
                self.collectionViewStrt.reloadData()
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
                    let selectedCell:UICollectionViewCell = collectionViewStrt.cellForItem(at: indexPath)!
                          selectedCell.contentView.backgroundColor = UIColor(red: 102/256, green: 255/256, blue: 255/256, alpha: 0.66)
                            let chkdTimSel  = dtScheduleStrt[indexPath.row]
                            let eqpp  = QRcdeTbl[indexPath.row]
                            let mroFlg = at_start_mroTbl[indexPath.row]
                            let dnemroFlg = at_done_mroTbl[indexPath.row]
                            let idWO = idTbl[indexPath.row]
                            let idOrder = self.display_nameTbl[indexPath.row]
                            self.instanceOfUser.writeAnyData(key: "MsgIds", value: strMsgIdsTbl[indexPath.row] )
                    
                            let dateFormatter = DateFormatter()
                             dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

                             let date = Date()
                             let dateString = dateFormatter.string(from: date)
                          let lstDatetime = interNt.convertToUTC(dateToConvert: dateString)
                             let dateString1 = chkdTimSel
                             let dateString2 = lstDatetime

                             let Dateformatter = DateFormatter()
                             Dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"


                          let date1 = Dateformatter.date(from: dateString1 )
                          let date2 = Dateformatter.date(from: dateString2  )


                             let distanceBetweenDates: TimeInterval? = date1?.timeIntervalSince(date2!)
                             let secbetweenDates = Int(distanceBetweenDates!)
                            var statsy  = ""
                            var lblTim  = ""

                            if(Int(distanceBetweenDates!)
                             > 0){
                                 statsy  = "Group-13"
                            }
                            else
                            {
                                statsy  = "Group-14"
                            }
                           lblTim  = timeString(time: TimeInterval(abs(secbetweenDates)))
                           chsStrtMdl.strEqp = ""
                           chsStrtMdl.strTim = ""
                           chsStrtMdl.ImgTim = ""
                             chsStrtMdl.mainTyp    = ""
                            chsStrtMdl.mrFlg = false
                            chsStrtMdl.dnemrFlg = false
                            chsStrtMdl.idWO = 0
                           chsStrtMdl.idOrdr = ""
                            chsStrtMdl.asstNam = ""
                           chsStrtMdl.strEqp = eqpp  
                           chsStrtMdl.strTim = lblTim
                           chsStrtMdl.ImgTim = statsy
                            chsStrtMdl.mrFlg = mroFlg
                            chsStrtMdl.dnemrFlg = dnemroFlg
                            chsStrtMdl.idWO = idWO
                            chsStrtMdl.idOrdr = idOrder
                            chsStrtMdl.asstNam = mAssetNamTbl[indexPath.row]
                            chsStrtMdl.mainTyp    = maintenance_typeTbl[indexPath.row]
                           let viewController:
                            UIViewController = UIStoryboard(
                                name: "chkLstStoryboard", bundle: nil
                            ).instantiateViewController(withIdentifier: "chkLstStory") as! chkListViewController
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                          //show window
                                          appDelegate.window?.rootViewController = viewController
                          

                }
                func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                    return 0
            }
        func timeString(time: TimeInterval) -> String {
            
            var hour = Int(time) / 3600
            var minute = Int(time) / 60 % 60
            if hour  > 24
            {
                let day = Int(time) / 86400
                hour = (Int(time) % 86400) / 3600
                 minute = (Int(time) % 3600) / 60
               return String(format: "%02id %02ih %02im ",day, hour, minute)
            }
            else
            {
            // return formated string
            return String(format: "%02ih %02im ", hour, minute)
                }
        }
               func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellStrtd", for: indexPath) as! StrtdWOCollectionViewCell
             cell.disNamStrtd.text = DisNmStrt[indexPath.row]
               cell.tmNamStrtd.text = TmNamStrt[indexPath.row]
                cell.eqpNamStrtd.text = EqNamStrt[indexPath.row] + CausStrt[indexPath.row]
                 // cell.causStrtd.text = CausStrt[indexPath.row] as? String
                let message: String = EqLcnStrt[indexPath.row]
               //set the text and style if any.
                cell.eqpLcnStrtd.text = message
               let prioriti: String = PrioritzStrt[indexPath.row]
               if(prioriti == "0"){
                   cell.imgSttsStrtd.image = UIImage(named: "Rectangle 15-2")
                   cell.lblStatusStrtd.text = "Low"
                   }
               if(prioriti == "1"){
                   cell.imgSttsStrtd.image = UIImage(named: "Rectangle 15-3")
                   cell.lblSttsStrtd.text = "Normal"
               }
               if(prioriti == "2"){
                   cell.imgSttsStrtd.image = UIImage(named: "Rectangle 15-1")
                   cell.lblSttsStrtd.text? = "High"
               }
               if(prioriti == "3"){
                   cell.imgSttsStrtd.image = UIImage(named: "Rectangle 15-4")
                   cell.lblSttsStrtd.text? = "Breakdown"
               }
               let chkdTim  = dtScheduleStrt[indexPath.row]
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
                  cell.imgTimStrtd.image = UIImage(named: "Group-13")
              }
              else
              {
                  cell.imgTimStrtd.image = UIImage(named: "Group-14")
              }
         cell.lblTimStrtd?.text = timeString(time: TimeInterval(abs(secbetweenDates)))
                cell.contentView.layer.cornerRadius = 4.0
                cell.contentView.layer.borderWidth = 1.0
                cell.contentView.layer.borderColor = UIColor.clear.cgColor
               
            return cell
        }
        func TblOrderStrt(Tkn: String){
        //5O
                                        // read the last updated value from the table and if update value is empty  the domain filed should be [] array otherwise send the last update value in the domain field like this [["write_date",">","2020-02-23 08:27:08"]] and the time should send UTC format.
                                       var  display_namey: String = "",chkList:[Int] =  Array(), statey: String = "",Statuzy: Bool  = false, boolzy: Bool  = false, boolz1y: Bool  = false,mAssignedByy: String = "",MtTm_idy: String = "" , causey: String = "", type_categoryy: String = "", equipment_location_namy: String = "", priorityy: String = "",  mCompanyNamy: String = "", maintenance_team_idy: String = "", TmId: String = "", date_start_scheduled: String = "",company_id: String = "",stringFields: String = "",equipment_namy: String = "", Idy: Int = 0,strSelectdReasony: String = "", strReasony: String = "", strReasonIdy: String = "",hlpDskId_idy: String = "", enforce_timey: Bool  = false,at_start_mroy: Bool  = false, at_done_mroy: Bool  = false, at_review_mroy: Bool  = false,mStarttmy: String = "", mEndtmy: String = "",MsgIds:[Int] =  Array(),strMsgIdsy: String = "",date_scheduledy: String = "",maintenance_typey: String = "",strchkListy: String = "", mAssignedToy: String = "",mAssetNamy: String = "",mAssetIdy: String = "", QRcdey: String = "",equipment_idy: String = "", equipment_seqy: String = "",equipment_location_id: String = ""
                                        
                                        TmId = self.instanceOfUser.readStringData(key: "MTmId")
                                         
                                         
                                           let stringFields1 = """
                                                                                                               &domain=["%26","%26",["employee_id","=",
                                                                                                               """
                                                                                                               var   trimmed1  : Int
                                                                                                               trimmed1 = Int(self.instanceOfUser.readStringData(key: "employeeIdz")) ?? 0
                                                                                                               let stringFieldsMt = """
                                                                                                               ],["maintenance_team_id","=",
                                                                                                               """
                                                                                                               var   MtTmId  : Int
                                                                                                               MtTmId = Int(TmId) ?? 0
                                                                                                               let  stringFields2 = """
                                                                                                               ],"|",["state","=","assigned"],["state","=","in_progress"]]
                                                                                                               """
                                                                                                                    stringFields = "\(stringFields1)\(trimmed1)\(stringFieldsMt)\(MtTmId)\(String(describing: stringFields2))"
                                                                                       
                                                                                                            let    offsetFields = """
                                                                                                               &groupby=["company_id"]&order=date_planned DESC&fields=["display_name","cause","maintenance_team_id","date_scheduled","state","type_category","equipment_location_id","priority","employee_id","check_list_ids","equipment","equipment_id","equipment_seq","asset_id","asset_seq","id","maintenance_type","date_start_scheduled","date_scheduled","company_id","message_ids","at_start_mro","at_done_mro","at_review_mro","help_desk_id","enforce_time"]&limit=20&offset=
                                                                                                               """
                                                                                                           var request = URLRequest(url: URL(string:"https://demo.helixsense.com/api/v2/isearch_read")!,timeoutInterval: Double.infinity)
                                                                                                           
                                                                                                           let stringOff = instanceOfUser.readIntData(key:  "offsetzTblStrt")
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
                                                                    let        task1 = URLSession.shared.dataTask(with: request) { data, response, error in
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
                                                self.indexStrt =  0
                                                print(title.count)
                                                 for i in 0..<title.count {

                                                    chkList.removeAll()
                                                    MsgIds.removeAll()
                                                     display_namey = title[i]["display_name"].stringValue /////
                                                     if title[i]["cause"].stringValue == "false"
                                                   {
                                                       causey = ""
                                                        }
                                                   else
                                                   {
                                                       causey = title[i]["cause"].stringValue /////
                                                        }

                                                 if title[i]["equipment_location_id"].stringValue == "false"
                                                   {
                                                       equipment_location_namy = ""
                                                        }
                                                   else
                                                   {
                                                       equipment_location_namy = title[i]["equipment_location_id"][1].stringValue
                                                     } /////
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
                                                     priorityy = title[i]["priority"].stringValue
                                                     let tmIid  =  self.instanceOfUser.readStringData(key: "TmNm")
                                                     self.DisNmStrt.append(display_namey)
                                                      self.TmNamStrt.append(tmIid)
                                                      self.EqNamStrt.append(equipment_namy)
                                                      self.CausStrt.append(causey)
                                                      self.EqLcnStrt.append(equipment_location_namy)
                                                      self.PrioritzStrt.append(priorityy)
                                                      self.dtScheduleStrt.append(title[i]["date_scheduled"].stringValue)
                                                    
                                                     self.indexStrt = self.indexStrt  + 1
                                                     self.totalStrt = self.totalStrt  + 1
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
                                                       self.idTbl.append(Idy)
                                                       self.display_nameTbl.append(display_namey)
                                                       self.causeTbl.append(causey)
                                                       self.mAssignedByTbl.append(mAssignedByy)
                                                       self.date_scheduledTbl.append(date_scheduledy)
                                                       self.stateTbl.append(statey)
                                                       self.type_categoryTbl.append(type_categoryy)
                                                       self.equipment_location_namTbl.append(equipment_location_namy)
                                                       self.priorityTbl.append(priorityy)
                                                       self.mAssignedToTbl.append(mAssignedToy)
                                                       self.mAssetNamTbl.append(mAssetNamy)
                                                       self.maintenance_typeTbl.append(maintenance_typey)
                                                       self.mStarttmTbl.append(mStarttmy)
                                                       self.mEndtmTbl.append(mEndtmy)
                                                       self.StatuzTbl.append(Statuzy)
                                                       self.boolz1Tbl.append(boolz)
                                                       self.boolz2Tbl.append(boolz)
                                                       self.mCompanyNamTbl.append(mCompanyNamy)
                                                       self.strchkListTbl.append(strchkListy)
                                                       self.mAssetIdTbl.append(mAssetIdy)
                                                       self.QRcdeTbl.append(QRcdey)
                                                       self.strMsgIdsTbl.append(strMsgIdsy)
                                                       self.at_start_mroTbl.append(at_start_mroy)
                                                       self.at_done_mroTbl.append(at_done_mroy)
                                                       self.at_review_mroTbl.append(at_review_mroy)
                                                       self.maintenance_team_idTbl.append(maintenance_team_idy)
                                                       self.hlpDskId_idTbl.append(hlpDskId_idy)
                                                       self.enforce_timeTbl.append(enforce_timey)
                                                       self.boolz3Tbl.append(boolz)
                                                       self.strReasonTbl.append(strReasony)
                                                       self.strReasonIdTbl.append(strReasonIdy)
                                                       self.strSelectdReasonTbl.append(strSelectdReasony)
                                                    
                                                      
                                                       }
                                                     }

                                                 DispatchQueue.main.sync {
                                                    //Update UI
                                                    self.collectionViewStrt.reloadData()
                                                }
                                                    
                                                    //Here call your function
                                                    self.insertTblOrders()
                                                    self.insertTblChklst(Tkn: self.tknz)
                                               
                                                  self.instanceOfUser.writeAnyData(key: "offsetzTblStrt", value: self.instanceOfUser.readIntData(key:  "offsetzTblStrt") + 20)

                                                 
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
        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */
        override var prefersStatusBarHidden: Bool {
            return false
        }
            
      func insertTblChklst(Tkn: String)
      {//5S
         /* if let strings =
          self.instanceOfWOrder.userDefaults.object(forKey: "InsrtWOArrayz") as? [Any]{
          
          let InsrtWOArrayz = strings.compactMap{ $0 as? [String: Any] }
              
              let  total = InsrtWOArrayz[0]["display_namey"]
              print(total ?? "")
              }*/

        for j in 0..<idTbl.count {
                  let dispnam = self.display_nameTbl[j]
                  let stringFields1 = """
                                                            &fields=["mro_activity_id","id","answer_type","answer_common","mro_quest_grp_id","value_suggested_ids"]&ids=
                                                            """
                                                            var   trimmed1  : String
                                                             trimmed1 = strchkListTbl[j]
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
                                                                      
                                                                              self.orderIdChkStrtd.append(dispnam)
                                                                              self.checklist_idChkStrtd.append(jsonc["data"][i]["id"].stringValue)
                                                                              self.checklist_typeChkStrtd.append(jsonc["data"][i]["answer_type"].stringValue)
                                                                              if jsonc["data"][i]["mro_activity_id"].stringValue != "false" {
                                                                                  self.questionChkStrtd.append(jsonc["data"][i]["mro_activity_id"][1].stringValue)
                                                                                  }
                                                                              else{
                                                                                      self.questionChkStrtd.append("")
                                                                                  }
                                                                              if jsonc["data"][i]["answer_type"].stringValue == "suggestion" {
                                                                                  let jsonResults = jsonc["data"][i]["value_suggested_ids"].array
                                                                                  let suggestion_array = "\(String(describing: jsonResults))"
                                                                                  self.suggestion_arrayChkStrtd.append(suggestion_array)
                                                                                  }
                                                                              else{
                                                                                      self.suggestion_arrayChkStrtd.append("")
                                                                              }
                                                                      
                                                                              self.is_submittedChkStrtd.append("false")
                                                                              if jsonc["data"][i]["mro_quest_grp_id"].stringValue != "false" {
                                                                                  
                                                                                  self.header_groupChkStrtd.append(jsonc["data"][i]["mro_quest_grp_id"][1].stringValue)
                                                                                  }
                                                                              else{
                                                                                      self.header_groupChkStrtd.append("")
                                                                                  }
                                                                              self.sync_statusChkStrtd.append(false)
                                                                      
                                                                  }
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
      func insertChklstTbl(){
         /* if let strings =
          self.instanceOfWOrder.userDefaults.object(forKey: "InsrtWOArrayz") as? [Any]{
          
          let InsrtWOArrayz = strings.compactMap{ $0 as? [String: Any] }
              
              let  total = InsrtWOArrayz[0]["display_namey"]
              print(total ?? "")
              }*/
          
          for i in 0..<checklist_idChkStrtd.count {
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
              let checklistid: String = checklist_idChkStrtd[i]
                 // 1
                 if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                     SQLITE_OK {
                   sqlite3_bind_text(queryStatement, 1, (checklistid as NSString).utf8String, -1, nil)                 // 2
                   if sqlite3_step(queryStatement) == SQLITE_ROW {
                      //5Q
                      let syncstatusChk: Int
                      if sync_statusChkStrtd[i]{
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
                       sqlite3_bind_text(updateStatement, 1, (orderIdChkStrtd[i] as NSString).utf8String, -1, nil)
                       sqlite3_bind_text(updateStatement, 2,(checklist_typeChkStrtd[i] as NSString).utf8String, -1, nil)
                       sqlite3_bind_text(updateStatement, 3,(questionChkStrtd[i] as NSString).utf8String, -1, nil)
                       sqlite3_bind_text(updateStatement, 4,(suggestion_arrayChkStrtd[i] as NSString).utf8String, -1, nil)
                       sqlite3_bind_text(updateStatement, 5,(is_submittedChkStrtd[i] as NSString).utf8String, -1, nil)
                       sqlite3_bind_text(updateStatement, 6,(header_groupChkStrtd[i] as NSString).utf8String, -1, nil)
                      
                      sqlite3_bind_int(updateStatement, 7,Int32(syncstatusChk))
                      sqlite3_bind_text(updateStatement, 8,(checklistid as NSString).utf8String, -1, nil)
                      if sqlite3_step(updateStatement) == SQLITE_DONE {
                         //               print("\nSuccessfully updated row.")
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
                      let syncstatusChk: Int
                      if sync_statusChkStrtd[i]{
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
                      sqlite3_bind_text(insertStatement, 1, (orderIdChkStrtd[i] as NSString).utf8String, -1, nil)
                       sqlite3_bind_text(insertStatement, 2,(checklistid as NSString).utf8String, -1, nil)
                       sqlite3_bind_text(insertStatement, 3,(checklist_typeChkStrtd[i] as NSString).utf8String, -1, nil)
                       sqlite3_bind_text(insertStatement, 4,(questionChkStrtd[i] as NSString).utf8String, -1, nil)
                       sqlite3_bind_text(insertStatement, 5,(suggestion_arrayChkStrtd[i] as NSString).utf8String, -1, nil)
                       sqlite3_bind_text(insertStatement, 6,(is_submittedChkStrtd[i] as NSString).utf8String, -1, nil)
                       sqlite3_bind_text(insertStatement, 7,(header_groupChkStrtd[i] as NSString).utf8String, -1, nil)
                       sqlite3_bind_int(insertStatement, 8,Int32(syncstatusChk))
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
          self.orderIdChkStrtd.removeAll()
           self.checklist_idChkStrtd.removeAll()
           self.checklist_typeChkStrtd.removeAll()
          self.questionChkStrtd.removeAll()
           self.suggestion_arrayChkStrtd.removeAll()
           self.is_submittedChkStrtd.removeAll()
           self.header_groupChkStrtd.removeAll()
          self.sync_statusChkStrtd.removeAll()
         }

        func insertTblOrders()
        {
           /* if let strings =
            self.instanceOfWOrder.userDefaults.object(forKey: "InsrtWOArrayz") as? [Any]{
            
            let InsrtWOArrayz = strings.compactMap{ $0 as? [String: Any] }
                
                let  total = InsrtWOArrayz[0]["display_namey"]
                print(total ?? "")
                }*/
            for i in 0..<idTbl.count {
                
                            var isFlg: String = ""
                                    if  stateTbl[i] == "in_progress"
                                        {
                                        isFlg = "1"
                                        }
                                        else if  stateTbl[i] == "pause"
                                        {
                                        isFlg = "2"
                                        }
                                        else if  stateTbl[i] == "done"
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
                let unqId: Int = idTbl[i]
                   // 1
                   if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                       SQLITE_OK {
                    sqlite3_bind_int(queryStatement, 1,(Int32(unqId)))
                     // 2
                     if sqlite3_step(queryStatement) == SQLITE_ROW {
                        //5Q
                        let Intval: Int
                        if StatuzTbl[i]{
                        Intval = 1
                            }
                        else {
                        Intval = 0
                            }
                        let Strt: Int
                        if at_start_mroTbl[i]{
                        Strt = 1
                            }
                        else {
                        Strt = 0
                            }
                        let Dnee: Int
                        if at_done_mroTbl[i]{
                        Dnee = 1
                            }
                        else {
                        Dnee = 0
                            }
                        let rvw: Int
                        if at_review_mroTbl[i]{
                        rvw = 1
                            }
                        else {
                        rvw = 0
                            }
                        let enfrce: Int
                        if enforce_timeTbl[i]{
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
                         sqlite3_bind_text(updateStatement, 1, (display_nameTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement, 2,(causeTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement, 3,(mAssignedByTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement, 4,(date_scheduledTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement, 5,(stateTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement, 6,(type_categoryTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement, 7,(equipment_location_namTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement, 8,(priorityTbl[i] as NSString).utf8String, -1, nil)
                        
                        sqlite3_bind_text(updateStatement, 9,(mAssignedToTbl[i] as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(updateStatement, 10,(mAssetNamTbl[i] as NSString).utf8String, -1, nil)
                        
                         sqlite3_bind_text(updateStatement, 11, (maintenance_typeTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement, 12,(mStarttmTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement, 13,(mEndtmTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement, 14,(strchkListTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement, 15,(mAssetIdTbl[i] as NSString).utf8String, -1, nil)
                        sqlite3_bind_int(updateStatement, 16,Int32(Intval))
                        sqlite3_bind_text(updateStatement, 17,(isFlg as NSString).utf8String, -1, nil)
                        sqlite3_bind_int(updateStatement, 18,Int32(0))
                        sqlite3_bind_text(updateStatement, 19,(mCompanyNamTbl[i] as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(updateStatement, 20,(QRcdeTbl[i] as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(updateStatement, 21,(strMsgIdsTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_int(updateStatement, 22,Int32(Strt))
                         sqlite3_bind_int(updateStatement, 23,Int32(Dnee))
                         sqlite3_bind_int(updateStatement, 24,Int32(rvw))
                         sqlite3_bind_text(updateStatement, 25,(maintenance_team_idTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement, 26,(hlpDskId_idTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_int(updateStatement, 27,Int32(enfrce))
                         sqlite3_bind_text(updateStatement, 28,(strReasonTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement, 29,(strReasonIdTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement, 30,(strSelectdReasonTbl[i] as NSString).utf8String, -1, nil)
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
                        if StatuzTbl[i]{
                        Intval = 1
                            }
                        else {
                        Intval = 0
                            }
                        let Strt: Int
                        if at_start_mroTbl[i]{
                        Strt = 1
                            }
                        else {
                        Strt = 0
                            }
                        let Dnee: Int
                        if at_done_mroTbl[i]{
                        Dnee = 1
                            }
                        else {
                        Dnee = 0
                            }
                        let rvw: Int
                        if at_review_mroTbl[i]{
                        rvw = 1
                            }
                        else {
                        rvw = 0
                            }
                        let enfrce: Int
                        if enforce_timeTbl[i]{
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
                         sqlite3_bind_int(insertStatement, 1,(Int32(idTbl[i])))
                         sqlite3_bind_text(insertStatement, 2, (display_nameTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 3,(causeTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 4,(mAssignedByTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 5,(date_scheduledTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 6,(stateTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 7,(type_categoryTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 8,(equipment_location_namTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 9,(priorityTbl[i] as NSString).utf8String, -1, nil)
                        
                        sqlite3_bind_text(insertStatement, 10,(mAssignedToTbl[i] as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStatement, 11,(mAssetNamTbl[i] as NSString).utf8String, -1, nil)
                        
                         sqlite3_bind_text(insertStatement, 12, (maintenance_typeTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 13,(mStarttmTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 14,(mEndtmTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 15,(strchkListTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 16,(mAssetIdTbl[i] as NSString).utf8String, -1, nil)
                        sqlite3_bind_int(insertStatement, 17,Int32(Intval))
                        sqlite3_bind_text(insertStatement, 18,(isFlg as NSString).utf8String, -1, nil)
                        sqlite3_bind_int(insertStatement, 19,Int32(0))
                        sqlite3_bind_text(insertStatement, 20,(mCompanyNamTbl[i] as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStatement, 21,(QRcdeTbl[i] as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStatement, 22,(strMsgIdsTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_int(insertStatement, 23,Int32(Strt))
                         sqlite3_bind_int(insertStatement, 24,Int32(Dnee))
                         sqlite3_bind_int(insertStatement, 25,Int32(rvw))
                         sqlite3_bind_text(insertStatement, 26,(maintenance_team_idTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 27,(hlpDskId_idTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_int(insertStatement, 28,Int32(enfrce))
                         sqlite3_bind_text(insertStatement, 29,(strReasonTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 30,(strReasonIdTbl[i] as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 31,(strSelectdReasonTbl[i] as NSString).utf8String, -1, nil)
                         
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
           }
    }
