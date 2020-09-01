//
//  cvdDashbrdViewController.swift
//  HelixSense
//
//  Created by DEEBA on 07.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import SwiftyJSON
import SQLite3
import OneSignal
/*class AdaptableSizeButton: UIButton {
 
    override var intrinsicContentSize: CGSize {
        let labelSize = titleLabel?.sizeThatFits(CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
        let desiredButtonSize = CGSize(width: labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right, height: labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
        
        return desiredButtonSize
    }
}
 */
class cvdDashbrdViewController: UIViewController {
    var frstApprnce: Bool!
    var prestats = false
    var enable_prescreen = false
    var tstDte = ""
    var btnStatuz = ""
    var drpDwnStatuz = false
    @IBAction func btnDropdownPrescreen(_ sender: UIButton) {
      //  print("btnDropdownPrescreen")
        if drpDwnStatuz {
                  let alert = UIAlertController(title: "Booking Options", message:"Please Select to reschedule or cancel the booking", preferredStyle: UIAlertController.Style.alert)
                  
                  // add the actions (buttons)
                  
                  alert.addAction(UIAlertAction.init(title: "Reschedule", style: .default, handler: { (action) in
                    self.reschedul()
                  }))
                  alert.addAction(UIAlertAction.init(title: "Cancel", style: .default, handler: { (action) in
                    self.cnclBkg()
                  }))


            self.present(alert, animated: true,completion: nil)
            }
        }
    @IBAction func btnPrescreen(_ sender: UIButton) {
        //print("btnPrescreen")
        if btnStatuz == "prescreen"{
                let storyboard = UIStoryboard(name: "OccpyStoryboard", bundle: nil)
               let mainTabBarController = storyboard.instantiateViewController(identifier: "occpyScreening")
               self.navigationController?.isNavigationBarHidden = true
               self.navigationController?.pushViewController(mainTabBarController, animated: true)
            }
        else if btnStatuz == "access"{
             let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "OccpyRedesign") as! OccpyRedesignViewController
            mainTabBarController.wrkSpac = wrkSpace.text
            mainTabBarController.wrkSpacPth = wrkSpaceNum.text
            mainTabBarController.Dte = lbldteOccupy.text
            mainTabBarController.Mnth = lblmonthOccupy.text
            mainTabBarController.Tim = tim.text
            mainTabBarController.Shft = lblplndStats.text!
            mainTabBarController.Dte = lbldteOccupy.text
            mainTabBarController.Mnth = lblmonthOccupy.text
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(mainTabBarController, animated: true)
          }
        else if btnStatuz == "occupy"{
            let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "scanQROccpySpace") as! scanQRbookSpaceViewController
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(mainTabBarController, animated: true)
        }
        else if btnStatuz == "Release"{
          // if match
         LoaderSpin.shared.showLoader(self)
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                 APIClient_redesign.shared().getTokenz
                    {status in
                APIClient.shared().postRelsed(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"))
                LoaderSpin.shared.hideLoader()
                   
                 }
                   }
            sleep(2)
         let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(mainTabBarController, animated: true)
             
         }
    }
    @IBOutlet weak var lblWrkschedul: UILabel!
    @IBOutlet weak var btnDropdown: UIButton!
    @IBOutlet weak var btnprescreen: UIButton!
    @IBOutlet weak var helpCenter: UILabel!
    @IBOutlet weak var covidInfo: UILabel!
    @IBOutlet weak var lblCovid: UILabel!
    var interNt = Internt()
    @IBOutlet weak var lblmonthOccupy: UILabel!
    var appMode = 0
    @IBOutlet weak var lbldteOccupy: UILabel!
    
    @IBOutlet weak var occupDte: UILabel!
    @IBOutlet weak var occupMnth: UILabel!
    @IBOutlet weak var wrkSpace: UILabel!
    @IBOutlet weak var lftDteImg: UIImageView!
    @IBOutlet weak var wrkSpaceNum: UILabel!
    @IBOutlet weak var lblplndStats: UILabel!
    @IBOutlet weak var tim: UILabel!
    @IBOutlet weak var btnOccu: UIButton!
    @IBOutlet weak var lbldtez: UILabel!
    @IBOutlet weak var mont: UILabel!
    @IBOutlet weak var dte: UILabel!
    
    @IBOutlet weak var lcnIcn: UIImageView!
    @IBOutlet weak var seprtrView: UIView!
    var employee_id = 0
    var id = 0
    var planned_in = ""
    var planned_out = ""
    var planned_status = ""
    var shift_id = 0
    var shift_name = ""
    var space_id  = 0
    var space_name = ""
    var space_number = ""
    var space_path_name = ""
    var space_status = ""
    var index: IndexPath?
    var task1 = URLSessionDataTask()
    var db:OpaquePointer? = nil
    var empId = 0
    
    func deleteTblchklst(){
        let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
           .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
           //opening the database
           if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
              print("There's error in opening the database")
           }
        else
        {
        let deleteStatementString = "DELETE FROM tbl_checklist;"
      var deleteStatement: OpaquePointer?
      if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) ==
          SQLITE_OK {
        if sqlite3_step(deleteStatement) == SQLITE_DONE {
          print("\nSuccessfully deleted table.")
        } else {
          print("\nCould not delete table.")
        }
      } else {
        print("\nDELETE statement could not be prepared")
      }
      
      sqlite3_finalize(deleteStatement)
            }
    }
    private func reschedul() {
        cnclBkg()
        let storyBoard: UIStoryboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
         let ValidationVC = storyBoard.instantiateViewController(withIdentifier: "DateSelect") as! DateSelectViewController
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         appDelegate.window?.rootViewController = ValidationVC
    }
    private func cnclBkg() {
         LoaderSpin.shared.showLoader(self)
         DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                 APIClient_redesign.shared().getTokenz
                    {status in
                APIClient.shared().cnclBkg(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"))
                {_ in
                    
                        }
                   
                 }
                   }
        sleep(2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
         APIClient_redesign.shared().getTokenz { status in
           if status {
             APIClient_redesign.shared().getUserinformation(){ count in
                if count {
                    self.lblSpace.text = "You are in " + " " + usrInfoModls.company_name
                    self.lblName.text = "Hello " +  usrInfoModls.name
                    let tags = [
                        "user_id": usrInfoModls.user_id,
                        "employee_id": usrInfoModls.employee_id,
                        "user_name": usrInfoModls.employee_name,
                        "build": "demo" ,
                       "instance": "demo.helixsense.com",
                       "current_company": usrInfoModls.company_id
                        ] as [String : Any]
                      OneSignal.sendTags(tags as [AnyHashable : Any], onSuccess: { (result) in
                        print("success!")
                    }) { (error) in
                      print("Fail!")
                    }
                        
                }
             }
                APIClient_redesign.shared().getConfiguration(){ count in
                   if count {
                            self.categories.removeAll()
                            self.enable_prescreen = configurationModls.enable_prescreen
                            self.instanceOfUser.writeAnyData(key: "covidDos", value: configurationModls.enable_other_resources_url)
                            self.categories.append(dshBrdList(name: configurationModls.enable_other_resources_name, Id: String(configurationModls.enable_other_resources_id),url:configurationModls.enable_other_resources_url))
                            self.instanceOfUser.writeAnyData(key: "covidsafety", value: configurationModls.safety_resources_url)
                            self.categories.append(dshBrdList(name: configurationModls.safety_resources_name, Id: String(configurationModls.safety_resources_id), url: configurationModls.safety_resources_url))
                            self.categories.append(dshBrdList(name: "Report COVID incident", Id: "incident", url: ""))
                            self.categories.append(dshBrdList(name: "Report an issue", Id: "issue", url: ""))
                            DispatchQueue.main.async {
                                //Update UI
                                self.tableView.reloadData()
                            }
                       self.lblCovid.text = configurationModls.title
                      var imageStr =  configurationModls.enable_landing_page_name.trimmingCharacters(in: .whitespacesAndNewlines)
                       imageStr =  String(imageStr.filter { !"\r\n\n\t\r".contains($0) })
                       self.covidInfo.text = imageStr
                            self.helpCenter.text  = "COVID Help Center"
                   }
                }
            APIClient_redesign.shared().getCurrentSchedule()
            { count in
                self.prestats = curntSchedulModll.prescreen_status
                if curntSchedulModll.space_path_name == "false"
                {
                    curntSchedulModll.space_path_name = ""
                }
                if curntSchedulModll.space_name == "false"
                {
                    curntSchedulModll.space_name = ""
                }

                self.lblWrkschedul.isHidden = false
                self.wrkSpace.text = curntSchedulModll.space_path_name // space_path_name
                self.lblplndStats.text = curntSchedulModll.planned_status + " " +  curntSchedulModll.shift_name
                self.wrkSpaceNum.text = curntSchedulModll.space_name

                if !count
                {//book
                    self.instanceOfUser.writeAnyData(key: "bkStatus", value: "book")
                    self.setupUIBook()
                }
                else
                {
                    self.instanceOfUser.writeAnyData(key: "bkStatus", value: "nobook")
                    self.setupUIOccupy()
                }
                }
                }

           }
         
          }

        LoaderSpin.shared.hideLoader()
    }
    private func callNumber(phoneNumber:String) {

      if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {

        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
        
      }
    }
       func insertCategorySubcategory(Id: String,Name: String,catId: String,catName: String,priority: String,slaTmr: String)
             {
                  // self.insertCategorySubcategory(Id: "26",Name: "Floor Drains",catId: "5",catName: "Plumbing-Common",priority: "1",slaTmr: "8")
                  
                  let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                  .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
                  //opening the database
                  if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                     print("There's error in opening the database")
                  }
               else
                   {
                       
                      let queryStatementString = "SELECT * FROM tbl_category WHERE cat_id=? AND cat_sub_id=?;"
                      var queryStatement: OpaquePointer?
                      let catid: String = catId
                      let catSubid: String = Id
                      // 1
                      if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                          SQLITE_OK {
                               //5F1!!!
                                  // 2
                                  sqlite3_bind_text(queryStatement, 1, (catid as NSString).utf8String, -1, nil)
                                  sqlite3_bind_text(queryStatement, 2, (catSubid as NSString).utf8String, -1, nil)
                                // 2
                                if sqlite3_step(queryStatement) == SQLITE_ROW {
                                   
                                        let updateStatementString = "UPDATE tbl_category SET cat_name = ?,cat_sub_name = ?,priority = ?,sla_timer = ? WHERE cat_id=? AND cat_sub_id=?;"
                                        var updateStatement: OpaquePointer?
                                        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
                                            SQLITE_OK {
                                             //    let catNam: String = "hello"
                                           sqlite3_bind_text(updateStatement, 1, (catName as NSString).utf8String, -1, nil)
                                           sqlite3_bind_text(updateStatement, 2, (Name as NSString).utf8String, -1, nil)
                                           sqlite3_bind_text(updateStatement, 3,(priority as NSString).utf8String, -1, nil)
                                           sqlite3_bind_text(updateStatement, 4, (slaTmr as NSString).utf8String, -1, nil)
                                           sqlite3_bind_text(updateStatement, 5, (catid as NSString).utf8String, -1, nil)
                                           sqlite3_bind_text(updateStatement, 6,(Id as NSString).utf8String, -1, nil)
                                          if sqlite3_step(updateStatement) == SQLITE_DONE {
                                        //     print("\nSuccessfully updated row.")
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
                              } else {//5F2 !!!
                                      let insertStatementString = "INSERT INTO tbl_category (cat_id, cat_name, cat_sub_id, cat_sub_name, priority, sla_timer) VALUES (?, ?, ?, ?, ?, ?);"
                                      var insertStatement: OpaquePointer?
                                      // 1
                                      if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
                                          SQLITE_OK {
                                          
                                        // 3
                                        sqlite3_bind_text(insertStatement, 1, (catId as NSString).utf8String, -1, nil)
                                        sqlite3_bind_text(insertStatement, 2,(catName as NSString).utf8String, -1, nil)
                                        sqlite3_bind_text(insertStatement, 3,(Id as NSString).utf8String, -1, nil)
                                        sqlite3_bind_text(insertStatement, 4,(Name as NSString).utf8String, -1, nil)
                                        sqlite3_bind_text(insertStatement, 5,(priority as NSString).utf8String, -1, nil)
                                        sqlite3_bind_text(insertStatement, 6,(slaTmr as NSString).utf8String, -1, nil)
                                        // 4
                                        if sqlite3_step(insertStatement) == SQLITE_DONE {
                                    //       print("\nSuccessfully inserted row.")
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
        func insertSpaces(spacId: String, seqId: String, spaceName: String ,spacShrtCde:String,displayName: String, categoryTyp: String, parentId: String,parentNam: String,maintTeamId: String,maintTeamName: String,spcCtrgyId: String,spcCtrgyName: String )
           
             {
                  let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                  .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
                  //opening the database
                  if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                     print("There's error in opening the database")
                  }
               else
               {
                  let queryStatementString = "SELECT * FROM tbl_space_details WHERE space_id=? ;"
                  var queryStatement: OpaquePointer?
                  // 1
                  if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                      SQLITE_OK {
                      // 5G1
                   sqlite3_bind_int(queryStatement, 1, (Int32(spacId)!))
                    // 2
                    if sqlite3_step(queryStatement) == SQLITE_ROW {
                       
                    let updateStatementString = "UPDATE tbl_space_details SET space_seqid = ?,space_name = ?,space_short_code = ?, space_display_name = ?,space_category_type = ?,space_parent_id = ?,space_parent_name = ?,space_maintenance_team_id = ?,space_maintenance_team = ?,space_asset_category_id = ?,space_asset_category_name = ? WHERE space_id=? ;"
                    var updateStatement: OpaquePointer?
                    if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
                        SQLITE_OK {
                         //    let catNam: String = "hello"
                       sqlite3_bind_int(updateStatement, 1, (Int32(seqId)!))
                       sqlite3_bind_text(updateStatement, 2,(spaceName as NSString).utf8String, -1, nil)
                       sqlite3_bind_text(updateStatement, 3, (spacShrtCde as NSString).utf8String, -1, nil)
                       sqlite3_bind_text(updateStatement, 4, (displayName as NSString).utf8String, -1, nil)
                       sqlite3_bind_text(updateStatement, 5,(categoryTyp as NSString).utf8String, -1, nil)
                       sqlite3_bind_text(updateStatement, 6, (parentId as NSString).utf8String, -1, nil)
                       sqlite3_bind_text(updateStatement, 7, (parentNam as NSString).utf8String, -1, nil)
                       sqlite3_bind_text(updateStatement, 8,(maintTeamId as NSString).utf8String, -1, nil)
                       sqlite3_bind_text(updateStatement, 9,(maintTeamName as NSString).utf8String, -1, nil)
                       sqlite3_bind_text(updateStatement, 10, (spcCtrgyId as NSString).utf8String, -1, nil)
                       sqlite3_bind_text(updateStatement, 11, (spcCtrgyName as NSString).utf8String, -1, nil)
                       sqlite3_bind_int(updateStatement, 12,(Int32(spacId)!))
                      if sqlite3_step(updateStatement) == SQLITE_DONE {
                      //   print("\nSuccessfully updated row.")
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
                  } else {// 5G2
                      let insertStatementString = "INSERT INTO tbl_space_details (space_id, space_seqid, space_name,space_short_code, space_display_name, space_category_type, space_parent_id,space_parent_name,space_maintenance_team_id,space_maintenance_team,space_asset_category_id,space_asset_category_name) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"

                      var insertStatement: OpaquePointer?
                      // 1
                      if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
                          SQLITE_OK {
                        // 3
                        sqlite3_bind_int(insertStatement, 1, (Int32(spacId)!))
                        sqlite3_bind_int(insertStatement, 2,(Int32(seqId)!))
                        sqlite3_bind_text(insertStatement, 3,(spaceName as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStatement, 4, (spacShrtCde as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStatement, 5, (displayName as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStatement, 6,(categoryTyp as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStatement, 7, (parentId as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStatement, 8, (parentNam as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStatement, 9,(maintTeamId as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStatement, 10,(maintTeamName as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStatement, 11, (spcCtrgyId as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStatement, 12, (spcCtrgyName as NSString).utf8String, -1, nil)
                        // 4
                        if sqlite3_step(insertStatement) == SQLITE_DONE {
                      //     print("\nSuccessfully inserted row.")
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
    func convertToUTC(dateToConvert:String) -> String {
     let formatter = DateFormatter()
     formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
     let convertedDate = formatter.date(from: dateToConvert)
     formatter.timeZone = TimeZone(identifier: "UTC")
     return formatter.string(from: convertedDate!)
        
    }
    func splitDatestr(dteStr: String) -> String {
        let dte = dteStr.components(separatedBy: " ")[0]
        let tme = dteStr.components(separatedBy: " ")[1]
        let ttlTim = tme.components(separatedBy: ":")[0]  + ":" + tme.components(separatedBy: ":")[1]
        let newwq = dte.components(separatedBy: "-")[1]
        let dayz = dte.components(separatedBy: "-")[2]
        let monthNumber = Int(newwq)
        let fmt = DateFormatter()
        fmt.dateFormat = "M"
        let month = fmt.monthSymbols[monthNumber! - 1]
        let mnth = month[month.index(month.startIndex, offsetBy: 0)..<month.index(month.startIndex, offsetBy: 3)]
        let dateAsString = ttlTim
        fmt.dateFormat = "HH:mm"
        let date = fmt.date(from: dateAsString)
        fmt.dateFormat = "h:mm a"
        let Datefrm = fmt.string(from: date!)
        fmt.dateFormat = "yyyy-MM-dd"
        let datey = fmt.date(from: dte)
        fmt.dateFormat = "EEEE"
        let dayx = fmt.string(from: datey!)
        return mnth + ">" + Datefrm  + ">" +  dayz +  ">" + dayx
         }
        func moveNextt(){
           
           let stry = getlastUpdateDateTimeSpace()
           print(stry)
                 let dateFormatter : DateFormatter = DateFormatter()
                 //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                 dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                 let date = Date()
                 let dateString = dateFormatter.string(from: date)
                 let lstDatetime = convertToUTC(dateToConvert: dateString)
                  let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                  .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
                  //opening the database
                  if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                     print("There's error in opening the database")
                  }
               else
               {
                   var queryStatement: OpaquePointer?
                  // 1
                  
                      // 2
                    // 2
                   if (stry != "")
                       {
                           UpdateLastUpdte()
                           UpdateSpaceLastUpdte()
                           UpdateCatLastUpdte()
                        /*
                          OperationQueue.main.addOperation {

                           let storyBoard: UIStoryboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                           let newViewController = storyBoard.instantiateViewController(withIdentifier: "cvdDash") as! cvdDashbrdViewController
                           self.present(newViewController, animated: true, completion: nil)
                                                           }
                           */
                       }
                       else {
                      let insertStatementString = "INSERT INTO tbl_last_update_data (last_update_date_time, last_update_date_time_space, last_update_date_time_cat, company_id) VALUES (?, ?, ?, ?);"
                      var insertStatement: OpaquePointer?
                      // 1
                      if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
                          SQLITE_OK {
                        // 3
                         sqlite3_bind_text(insertStatement, 1, ("" as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 2,(lstDatetime as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 3,(lstDatetime as NSString).utf8String, -1, nil)
                       sqlite3_bind_int(insertStatement, 4,(Int32(instanceOfUser.readIntData(key: "CompIdz"))))
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
                       /*
                       OperationQueue.main.addOperation {
                           
                          let storyBoard: UIStoryboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                           let newViewController = storyBoard.instantiateViewController(withIdentifier: "cvdDash") as! cvdDashbrdViewController
                           self.present(newViewController, animated: true, completion: nil)
                       }
                       */
                  }

                   
                  
              }
       }
     func writTochklstTble(){
        for j in 0..<symptmsListModl.display_name.count {
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
            {
               // header_group=Others checklist_id=16811 answer= checklist_type=boolean question=Do you have Cough? is_submitted=0 shift_id=87350 expected_ans=yes suggestion_array=
                var queryStatement: OpaquePointer?
               // (curntSHift.idx)
                 
                   let insertStatementString = "INSERT INTO tbl_checklist (shift_id ,checklist_id ,checklist_type ,question ,suggestion_array ,answer ,is_submitted ,header_group ,expected_ans ,sync_status )  VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
                   var insertStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
                       SQLITE_OK {
                     // 3
                    
                            let tst = String(curntSHift.idx)
                            let tst1 = String(symptmsListModl.id[j])
                            var hdrGrp = ""
                              sqlite3_bind_text(insertStatement, 1, (tst as NSString).utf8String, -1, nil)
                            sqlite3_bind_text(insertStatement, 2,(tst1 as NSString).utf8String, -1, nil)
                            sqlite3_bind_text(insertStatement, 3,(symptmsListModl.type[j] as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStatement, 4,(symptmsListModl.display_name[j] as NSString).utf8String, -1, nil)
                            sqlite3_bind_text(insertStatement, 5,("" as NSString).utf8String, -1, nil)
                            sqlite3_bind_text(insertStatement, 6,("" as NSString).utf8String, -1, nil)
                            sqlite3_bind_text(insertStatement, 7,("0" as NSString).utf8String, -1, nil)
                        if symptmsListModl.mro_quest_grp_nam[j] == ""
                        {
                            hdrGrp = "Others"
                        }
                        else
                        {
                            hdrGrp = symptmsListModl.mro_quest_grp_nam[j]
                        }
                        sqlite3_bind_text(insertStatement, 8,(hdrGrp as NSString).utf8String, -1, nil)
                            sqlite3_bind_text(insertStatement, 9,("yes" as NSString).utf8String, -1, nil)
                            sqlite3_bind_text(insertStatement, 10,("" as NSString).utf8String, -1, nil)
                             if sqlite3_step(insertStatement) == SQLITE_DONE {
                               print("\nSuccessfully inserted row.")
                             } else {
                               print("\nCould not insert row.")
                             }
                    
                    
                    //
                   } else {
                     print("\nINSERT statement is not prepared.")
                   }
                   // 5
                    sqlite3_close(db)
                    db = nil
                    /*
                    OperationQueue.main.addOperation {
                        
                       let storyBoard: UIStoryboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "cvdDash") as! cvdDashbrdViewController
                        self.present(newViewController, animated: true, completion: nil)
                    }
                    */
               

                
               
                }
           }
    }
       func UpdateSpaceLastUpdte() {
           //get last_update_date_time_space
           
                 let dateFormatter : DateFormatter = DateFormatter()
                 //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                 dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                 let date = Date()
                 let dateString = dateFormatter.string(from: date)
                 let lstDatetime = convertToUTC(dateToConvert: dateString)

              
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                  .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //print(instanceOfUser.readStringData(key: "dbNamez"))
                  //opening the database
                  if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                     print("There's error in opening the database")
                  }
               else
               {
                     let UpdStatementString = "UPDATE tbl_last_update_data SET  last_update_date_time_space =  ?  WHERE id = (SELECT MAX(id) FROM tbl_last_update_data);"
                   var UpdStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, UpdStatementString, -1, &UpdStatement, nil) ==
                       SQLITE_OK {
                       let name1: NSString = lstDatetime as NSString
                       // 2
                     sqlite3_bind_text(UpdStatement, 1, (name1 as NSString).utf8String, -1, nil)
                     // 4
                     if sqlite3_step(UpdStatement) == SQLITE_DONE {
                    //   print("\nSuccessfully updated row.")
                       instanceOfUser.writeAnyData(key: "IS_DOWNLOADED", value: true)
                     } else {
                       print("\nCould not update row.")
                     }
                   } else {
                     print("\nUPDATE statement is not prepared.")
                   }
                   // 5
                   sqlite3_finalize(UpdStatement)
                   sqlite3_close(db)
                   db = nil
               }
               
           }
       func UpdateCatLastUpdte() {
           //get last_update_date_time_space
           
                 let dateFormatter : DateFormatter = DateFormatter()
                 //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                 dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                 let date = Date()
                 let dateString = dateFormatter.string(from: date)
                 let lstDatetime = convertToUTC(dateToConvert: dateString)

              
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                  .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
                  //opening the database
                  if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                     print("There's error in opening the database")
                  }
               else
               {
                     let UpdStatementString = "UPDATE tbl_last_update_data SET  last_update_date_time_cat =  ?  WHERE id = (SELECT MAX(id) FROM tbl_last_update_data);"
                   var UpdStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, UpdStatementString, -1, &UpdStatement, nil) ==
                       SQLITE_OK {
                       let name1: NSString = lstDatetime as NSString
                       // 2
                     sqlite3_bind_text(UpdStatement, 1, (name1 as NSString).utf8String, -1, nil)
                     // 4
                     if sqlite3_step(UpdStatement) == SQLITE_DONE {
                      // print("\nSuccessfully updated row.")
                      // instanceOfUser.writeAnyData(key: "IS_DOWNLOADED", value: true)
                     } else {
                       print("\nCould not update row.")
                     }
                   } else {
                     print("\nUPDATE statement is not prepared.")
                   }
                   // 5
                   sqlite3_finalize(UpdStatement)
                   sqlite3_close(db)
                   db = nil
               }
               
           }
       func UpdateLastUpdte() {
           //get last_update_date_time_space
           
                 let dateFormatter : DateFormatter = DateFormatter()
                 //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                 dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                 let date = Date()
                 let dateString = dateFormatter.string(from: date)
                 let lstDatetime = convertToUTC(dateToConvert: dateString)

              
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                  .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
                  //opening the database
                  if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                     print("There's error in opening the database")
                  }
               else
               {
                     let UpdStatementString = "UPDATE tbl_last_update_data SET  last_update_date_time =  ?  WHERE id = (SELECT MAX(id) FROM tbl_last_update_data);"
                   var UpdStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, UpdStatementString, -1, &UpdStatement, nil) ==
                       SQLITE_OK {
                       let name1: NSString = lstDatetime as NSString
                       // 2
                     sqlite3_bind_text(UpdStatement, 1, (name1 as NSString).utf8String, -1, nil)
                     // 4
                     if sqlite3_step(UpdStatement) == SQLITE_DONE {
                      // print("\nSuccessfully updated row.")
                       instanceOfUser.writeAnyData(key: "IS_DOWNLOADED", value: true)
                     } else {
                       print("\nCould not update row.")
                     }
                   } else {
                     print("\nUPDATE statement is not prepared.")
                   }
                   // 5
                   sqlite3_finalize(UpdStatement)
                   sqlite3_close(db)
                   db = nil
               }
               
           }
       func DownldSpace(Tkn: String) {
          // https://demo.helixsense.com/api/isearch_read_v1?model=mro.equipment.location&domain=[]&fields=["space_name","name","display_name","maintenance_team_id","asset_categ_type","asset_category_id","parent_id","asset_categ_type","sort_sequence"]&limit=10&offset=0&order=id ASC
                               var stringFields = ""
                               if (instanceOfUser.readStringData(key: "lastUpdtdDtTimSpace") == "" )
                               {
                                    stringFields = """
                                   &domain=[]&fields=["space_name","display_name","name","maintenance_team_id","parent_id","asset_categ_type","asset_category_id","sort_sequence"]&limit=80&offset=
                                   """
                               }
                               else
                               {
                                   let stringFields1 = """
                                   &domain=[["write_date",">","
                                   """

                                   let trimmed1 = instanceOfUser.readStringData(key: "lastUpdtdDtTimSpace").trimmingCharacters(in: .whitespacesAndNewlines)
                                   let  stringFields2 = """
                                   "]]&fields=["space_name","display_name","name","maintenance_team_id","parent_id","asset_categ_type","asset_category_id","sort_sequence"]&limit=10&offset=
                                   """
                                        stringFields = "\(stringFields1)\(trimmed1)\(String(describing: stringFields2))"
                               }

                               var request = URLRequest(url: URL(string:"https://demo.helixsense.com/api/isearch_read_v1")!,timeoutInterval: Double.infinity)
                               let    offsetFields = """
                               &order=id ASC
                               """
                               let stringOff = instanceOfUser.readIntData(key:  "offsetz")
                               let combinedOffset = "\(stringFields)\(stringOff)\(String(describing: offsetFields))"
                               let varRole = "\(String(describing: combinedOffset))"
                               let string1 = "Bearer "
                                                     let string2 = Tkn
                                                     let combined2 = "\(string1) \(String(describing: string2))"
                                                            request.addValue(combined2, forHTTPHeaderField: "Authorization")
                                let postData = NSMutableData(data: "model=mro.equipment.location".data(using: String.Encoding.utf8)!)
                                postData.append(varRole.data(using: String.Encoding.utf8)!)
                               request.httpBody = postData as Data
                                request.httpMethod = "POST"
                                 task1 = URLSession.shared.dataTask(with: request) { data, response, error in
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
                                    //let lngth = jsonc["length"]

                                   if (title.count > 0){
                                       for i in 0..<title.count {

                                        // if (lngth.intValue > 0){
                                         //   for i in 0..<lngth.intValue{
                                               var spacId, seqId, spaceName ,displayName, categoryTyp, maintTeamId,maintTeamName, parentId,spaceShrtcde,spcPrntNam,spcCgryId,spcCgryNam: String
                                               spacId = title[i]["id"].stringValue
                                               seqId = title[i]["sort_sequence"].stringValue
                                               spaceName = title[i]["space_name"].stringValue
                                               spaceShrtcde = title[i]["name"].stringValue
                                               displayName = title[i]["display_name"].stringValue
                                               categoryTyp = title[i]["asset_categ_type"].stringValue
                                               parentId = title[i]["parent_id"][0].stringValue
                                              if (parentId == "false" || parentId == ""){
                                                   parentId = ""
                                                   spcPrntNam = ""
                                               }
                                               else{
                                                   parentId = title[i]["parent_id"][0].stringValue
                                                   spcPrntNam = title[i]["parent_id"][1].stringValue
                                               }
                                               maintTeamId = title[i]["maintenance_team_id"][0].stringValue
                                               if (maintTeamId == "false" || maintTeamId == ""){
                                                   maintTeamId = ""
                                                   maintTeamName = ""
                                               }
                                               else{
                                                   maintTeamId = title[i]["maintenance_team_id"][0].stringValue
                                                   maintTeamName = title[i]["maintenance_team_id"][1].stringValue
                                               }
                                           spcCgryId = title[i]["asset_category_id"][0].stringValue
                                           if (spcCgryId == "false" || spcCgryId == "")
                                           {
                                              spcCgryId = ""
                                              spcCgryNam = ""
                                          }
                                          else{
                                              spcCgryId = title[i]["asset_category_id"][0].stringValue
                                              
                                              spcCgryNam = title[i]["asset_category_id"][1].stringValue
                                          }
                                           self.insertSpaces(spacId: spacId, seqId: seqId, spaceName: spaceName ,spacShrtCde:spaceShrtcde,displayName: displayName, categoryTyp: categoryTyp, parentId: parentId,parentNam: spcPrntNam,maintTeamId: maintTeamId,maintTeamName: maintTeamName,spcCtrgyId: spcCgryId,spcCtrgyName: spcCgryNam )
                                           }
                                           
                                                  self.instanceOfUser.writeAnyData(key: "offsetz", value: self.instanceOfUser.readIntData(key:  "offsetz") + 80)
                                           self.DownldSpace(Tkn:  Tkn)
                                        }
                                       else
                                       {
                                           //5F4
                                           self.task1.cancel()
                                           self.moveNextt()
                                       }
                                     }
                                  catch let error as NSError {
                                     print("Failed to load: \(error.localizedDescription)")
                                 }
                                }
                         task1.resume()

       }
           func DownldCategory(Tkn: String) {
                                  // read the last updated value from the table and if update value is empty  the domain filed should be [] array otherwise send the last update value in the domain field like this [["write_date",">","2020-02-23 08:27:08"]] and the time should send UTC format.
                                   //5F1
                                   getlastUpdateDateTimeSpace()
                                   var stringFields = ""
                                   if (instanceOfUser.readStringData(key: "lastUpdtdDtTimSpace") == "" )
                                   {
                                        stringFields = """
                                       &domain=[]&fields=["parent_category_id","name","priority","sla_timer"]&limit=80&offset=
                                       """
                                   }
                                   else
                                   {
                                       let stringFields1 = """
                                       &domain=[["write_date",">","
                                       """

                                       let trimmed1 = instanceOfUser.readStringData(key: "lastUpdtdDtTimSpace").trimmingCharacters(in: .whitespacesAndNewlines)
                                       let  stringFields2 = """
                                       "]]&fields=["parent_category_id","name","priority","sla_timer"]&limit=80&offset=
                                       """
                                            stringFields = "\(stringFields1)\(trimmed1)\(String(describing: stringFields2))"
                                   }
               
                                    let    offsetFields = """
                                       &order=parent_category_id ASC
                                       """
                                   var request = URLRequest(url: URL(string:"https://demo.helixsense.com/api/isearch_read_v1")!,timeoutInterval: Double.infinity)
                                   
                                   let stringOff = instanceOfUser.readIntData(key:  "offsetz")
                                   let combinedOffset = "\(stringFields)\(stringOff)\(String(describing: offsetFields))"
                                   let varRole = "\(String(describing: combinedOffset))"
                                   let string1 = "Bearer "
                                   let string2 = Tkn
                                   let combined2 = "\(string1) \(String(describing: string2))"
                                   request.addValue(combined2, forHTTPHeaderField: "Authorization")
                                   let postData = NSMutableData(data: "model=website.support.ticket.subcategory".data(using: String.Encoding.utf8)!)
                                   postData.append(varRole.data(using: String.Encoding.utf8)!)
                                   request.httpBody = postData as Data
                                   request.httpMethod = "POST"
       /*https://demo.helixsense.com/api/isearch_read_v1?model=website.support.ticket.subcategory&domain=[["write_date",">","2020-01-23 18:14:25"]]&fields=["parent_category_id","name","priority","sla_timer"]&limit=80&offset=0&order=parent_category_id ASC*/
                                     task1 = URLSession.shared.dataTask(with: request) { data, response, error in
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
                                       //let lngth = jsonc["length"]
                                       if (title.count > 0){
                                           for i in 0..<title.count {
                                       //if (lngth.intValue > 0){
                                         //      for i in 0..<lngth.intValue {
                                                   var catId, Id, slaTmr ,catName, Name, priority: String
                                                   catId = title[i]["parent_category_id"][0].stringValue
                                                   catName = title[i]["parent_category_id"][1].stringValue
                                                   Id = title[i]["id"].stringValue
                                                   Name = title[i]["name"].stringValue
                                                   priority = title[i]["priority"].stringValue
                                                   slaTmr = title[i]["sla_timer"].stringValue
                                                   // set your values into models property like this
        //5F2
                                                   self.insertCategorySubcategory(Id: Id,Name: Name,catId: catId,catName: catName,priority: priority,slaTmr: slaTmr)
                                                   
                                               }
                                                   self.instanceOfUser.writeAnyData(key: "offsetz", value: self.instanceOfUser.readIntData(key:  "offsetz") + 80)
                                            self.DownldCategory(Tkn: Tkn)
                                           }
                                       else{
                                        self.instanceOfUser.writeAnyData(key: "offsetz", value: 0)
                                           //5F3
                                           self.task1.cancel()
                                       self.DownldSpace(Tkn:  Tkn)
                                       self.instanceOfUser.writeAnyData(key: "offsetz", value: 0)
                                               }
                                         }
                                      catch let error as NSError {
                                         print("Failed to load: \(error.localizedDescription)")
                                     }
                                    }
                             task1.resume()

           }
       func getlastUpdateDateTimeSpace() -> String {

                     var string1 = ""
                      let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                      .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
                      //opening the database
                      if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                         print("There's error in opening the database")
                      }
                   else
                   {
                      let queryStatementString = "SELECT last_update_date_time_space FROM tbl_last_update_data WHERE id = (SELECT MAX(id) FROM tbl_last_update_data);"
                      var queryStatement: OpaquePointer?
                      if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                          SQLITE_OK {
                        // 2
                        if sqlite3_step(queryStatement) == SQLITE_ROW{
                            string1 =    String(cString: sqlite3_column_text(queryStatement, 0))
                           instanceOfUser.writeAnyData(key: "lastUpdtdDtTimSpace", value: string1)
                       }
                       else{//if the tbl is empty
                            string1 = ""
                           instanceOfUser.writeAnyData(key: "lastUpdtdDtTimSpace", value: "")
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
           return (string1)
           }
    
       override func awakeFromNib() {
           super.awakeFromNib()
       }
    
    @IBAction func btnCall(_ sender: UIButton) {
        callNumber(phoneNumber: configurationModls.help_line_mobile)
    }
    var categories = [dshBrdList]()
    @IBAction func btnBook(_ sender: Any) {//book a space
        let storyBoard: UIStoryboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
         let ValidationVC = storyBoard.instantiateViewController(withIdentifier: "DateSelect") as! DateSelectViewController
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         appDelegate.window?.rootViewController = ValidationVC
        }
    
    let instanceOfUser = readWrite()
    var spcNam = ""
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtComp: UITextView!
    @IBOutlet weak var txtFd: FloatingLabelInput!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblSpace: UILabel!
    @IBOutlet weak var lcnIcon: UIImageView!
    @IBOutlet weak var btnBk: UIButton!
    
    @IBAction func btnBkSpace(_ sender: UIButton) {
    }
    @IBOutlet weak var bkSpaceImage: UIImageView!
    @IBAction func btnShfts() {
    }
    @IBAction func btnAttendnce() {
    }
    @IBAction func btnSttgs() {
    }
    
    @IBAction func btnreprtIssu() {
    }
    @IBAction func btnHom() {
    }
    func registerCell() {
      //  tableView.register(UINib(nibName: "WorkScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "WorkScheduleTableViewCell")
        tableView.register(UINib(nibName: "CovidInformationTableViewCell", bundle: nil), forCellReuseIdentifier: "CovidInformationTableViewCell")
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        sleep(1)
        if (frstApprnce != true)
        {
        // Hide the navigation bar for current view controller
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
         APIClient_redesign.shared().getTokenz { status in
           if status {
             APIClient_redesign.shared().getUserinformation(){ count in
                if count {
                    self.lblSpace.text = "You are in " + " " + usrInfoModls.company_name
                    self.lblName.text = "Hello " +  usrInfoModls.name
                    let tags = [
                        "user_id": usrInfoModls.user_id,
                        "employee_id": usrInfoModls.employee_id,
                        "user_name": usrInfoModls.employee_name,
                        "build": "demo" ,
                       "instance": "demo.helixsense.com",
                       "current_company": usrInfoModls.company_id
                        ] as [String : Any]
                      OneSignal.sendTags(tags as [AnyHashable : Any], onSuccess: { (result) in
                        print("success!")
                    }) { (error) in
                      print("Fail!")
                    }
                        
                }
             }
         //    sleep(1)
                APIClient_redesign.shared().getConfiguration(){ count in
                   if count {
                            self.categories.removeAll()
                            self.enable_prescreen = configurationModls.enable_prescreen
                            self.instanceOfUser.writeAnyData(key: "covidDos", value: configurationModls.enable_other_resources_url)
                            self.categories.append(dshBrdList(name: configurationModls.enable_other_resources_name, Id: String(configurationModls.enable_other_resources_id),url:configurationModls.enable_other_resources_url))
                            self.instanceOfUser.writeAnyData(key: "covidsafety", value: configurationModls.safety_resources_url)
                            self.categories.append(dshBrdList(name: configurationModls.safety_resources_name, Id: String(configurationModls.safety_resources_id), url: configurationModls.safety_resources_url))
                            self.categories.append(dshBrdList(name: "Report COVID incident", Id: "incident", url: ""))
                            self.categories.append(dshBrdList(name: "Report an issue", Id: "issue", url: ""))
                            DispatchQueue.main.async {
                                //Update UI
                                self.tableView.reloadData()
                            }
                       self.lblCovid.text = configurationModls.title
                      var imageStr =  configurationModls.enable_landing_page_name.trimmingCharacters(in: .whitespacesAndNewlines)
                       imageStr =  String(imageStr.filter { !"\r\n\n\t\r".contains($0) })
                       self.covidInfo.text = imageStr
                            self.helpCenter.text  = "COVID Help Center"
                   }
                }
            
          //   sleep(1)
            APIClient_redesign.shared().getCurrentSchedule()
            { count in
                self.prestats = curntSchedulModll.prescreen_status
                if curntSchedulModll.space_path_name == "false"
                {
                    curntSchedulModll.space_path_name = ""
                }
                if curntSchedulModll.space_name == "false"
                {
                    curntSchedulModll.space_name = ""
                }

                self.lblWrkschedul.isHidden = false
                self.wrkSpace.text = curntSchedulModll.space_path_name // space_path_name
                self.lblplndStats.text = curntSchedulModll.planned_status + " " +  curntSchedulModll.shift_name
                self.wrkSpaceNum.text = curntSchedulModll.space_name

                if !count
                {//book
                    self.instanceOfUser.writeAnyData(key: "bkStatus", value: "book")
                    self.setupUIBook()
                }
                else
                {
                    self.instanceOfUser.writeAnyData(key: "bkStatus", value: "nobook")
                    self.setupUIOccupy()
                }
                }
                }

           }
         
          }
    }
        
    }
    func setupUIBook(){
    //  if self.instanceOfUser.readStringData(key: "bkStatus") == "book" {//book a space
             // lftDteImg.isHidden = true
              self.mont.isHidden = false
              self.lbldtez.isHidden = false
              self.lblmonthOccupy.isHidden = true
              self.lbldteOccupy.isHidden = true
             // occupDte.isHidden = true
             // occupMnth.isHidden = true
              self.tim.isHidden = true
              self.lblplndStats.isHidden = true
              self.seprtrView.isHidden = true
              self.wrkSpaceNum.isHidden = true
              self.wrkSpace.isHidden = true
              self.btnOccu.isHidden = true
              self.btnDropdown.isHidden = true
              self.bkSpaceImage.isHidden = false
              self.btnBk.isHidden = false
              self.bkSpaceImage.image = UIImage(named: "3")
          let dateFormatter : DateFormatter = DateFormatter()
            //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
            let date = Date()
            let dateString = dateFormatter.string(from: date)
            let monthz = dateString.components(separatedBy: "-")
            let dtez = monthz[2].components(separatedBy: " ")
          self.mont.text =  monthz[1]
            self.lbldtez.text = dtez[0]
            self.lblmonthOccupy.text =  monthz[1]
              self.lbldteOccupy.text = dtez[0]
         self.lcnIcn.isHidden = true
        LoaderSpin.shared.hideLoader()
      }
    func setupUIOccupy()
        {
            print(prestats,enable_prescreen)
            if enable_prescreen && !prestats
            {//prescreen
                if wrkSpace.text != "" {
                    lcnIcn.isHidden = false
                }
                else{
                    lcnIcn.isHidden = true
                }
                self.btnDropdown.isHidden = false
                drpDwnStatuz = true
                self.btnOccu.setImage(
                          UIImage(named:"prescreenImg"),
                          for: .normal)
                self.bkSpaceImage.image = UIImage(named: "Group-37")
                btnStatuz = "prescreen"
            } else {
            //button status
                if curntSchedulModll.space_status == "Ready"
                 {
                    if curntSchedulModll.user_defined {
                            btnDropdown.isHidden = false
                            drpDwnStatuz = true
                            btnDropdown.isUserInteractionEnabled = true
                    }
                    else {
                            btnDropdown.isHidden = true
                            btnDropdown.isUserInteractionEnabled = false

                    }
                    if curntSchedulModll.access_status
                    {//Occupy
                         lcnIcn.isHidden = false
                        btnDropdown.isHidden = false
                        drpDwnStatuz = false
                        btnStatuz = "occupy"
                        self.btnOccu.setImage(
                        UIImage(named:"OccpyImg"),
                        for: .normal)
                        self.bkSpaceImage.image = UIImage(named: "Group-37")
                    }
                    else {//access
                        lcnIcn.isHidden = false
                        btnDropdown.isHidden = true
                        drpDwnStatuz = false
                        btnStatuz = "access"
                        self.btnOccu.setImage(
                        UIImage(named:"accessImg"),
                        for: .normal)
                        self.bkSpaceImage.image = UIImage(named: "Group-37")

                    }
                  }
                else if curntSchedulModll.space_status == "Occupied"
                    {//Release
                        lcnIcn.isHidden = false
                        btnDropdown.isHidden = true
                        btnStatuz = "Release"
                        drpDwnStatuz = false
                        self.btnOccu.setImage(
                        UIImage(named:"releasImg"),
                        for: .normal)
                        self.bkSpaceImage.image = UIImage(named: "Group-37")
                    }
                else if curntSchedulModll.space_status == "released"
                    {//Shift Ended
                    }
                else if curntSchedulModll.space_status == "Maintenance in Progress"
                    {//Cleaning in Progress
                    }
                else if curntSchedulModll.space_status == "elapsed"
                    {//Shift Elapsed
                    }

                }
            
            // print(Date().preciseLocalTime) // "09:13:17.385"  GMT-3
             //       print(Date().preciseGMTTime )  // "12:13:17.386"  GMT
                    
            let duration: TimeInterval = TimeInterval(TimeZone.current.secondsFromGMT())
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional // Use the appropriate positioning for the current locale
            formatter.allowedUnits = [ .hour, .minute ] // Units to display in the formatted string
            formatter.zeroFormattingBehavior = [ .pad ] // Pad with zeroes where appropriate for the locale

            let formattedDuration = formatter.string(from: duration)
                    //print(formattedDuration ?? "")
            
                 self.lblmonthOccupy.isHidden = false
                 self.lbldteOccupy.isHidden = false
                 self.mont.isHidden = true
                 self.lbldtez.isHidden = true
                 //occupDte.isHidden = false
                // occupMnth.isHidden = false
                 self.tim.isHidden = false
                 self.lblplndStats.isHidden = false
                 self.seprtrView.isHidden = false
                 self.wrkSpaceNum.isHidden = false
                 self.wrkSpace.isHidden = false
                 self.btnOccu.isHidden = false
                 self.btnBk.isHidden = true
                 self.bkSpaceImage.isHidden = false
        
            //Check enable_prescreen(configuration) is true and prescreen status(current scheduled) is false-> display prescreen text
           
                //Read planned_in object and convert UTC to local date format and display Month & Date
                let inptDte = self.interNt.convertToLocal(incomingFormat: curntSchedulModll.planned_in)
                  let Datefrm = self.splitDatestr(dteStr: inptDte)
                   
                   let ToDte = self.interNt.convertToLocal(incomingFormat: curntSchedulModll.planned_out)
                  let DateTo = self.splitDatestr(dteStr: ToDte)
                   self.mont.text = Datefrm.components(separatedBy: ">")[0]
                self.lblmonthOccupy.text = Datefrm.components(separatedBy: ">")[0]
                 //  self.occupMnth.text = Datefrm.components(separatedBy: ">")[0]
                
                  let dayCompo = Datefrm.components(separatedBy: ">")[3]
                let dateFormatterPlanned = DateFormatter()
                               dateFormatterPlanned.dateFormat = "YYYY-MM-dd HH:mm:ss"
                let inDate = dateFormatterPlanned.date(from: curntSchedulModll.planned_in)?.toLocalTime()
                let outDate = dateFormatterPlanned.date(from: curntSchedulModll.planned_out)?.toLocalTime()
                let hour = self.getMinutesDifferenceFromTwoDates(start: inDate!, end: outDate!)
                 
                 var neww = getCurrentTimeZone()
                 neww = neww.components(separatedBy: "(")[0]
                 var timm = ""
                    timm = dayCompo[dayCompo.index(dayCompo.startIndex, offsetBy: 0)..<dayCompo.index(dayCompo.startIndex, offsetBy: 3)] + ","
                    timm = timm + Datefrm.components(separatedBy: ">")[1] + "-" + DateTo.components(separatedBy: ">")[1]
                    timm = timm  + " GMT+" + formattedDuration! + "(\(hour)h)"
                //  self.tim.text = dayCompo[dayCompo.index(dayCompo.startIndex, offsetBy: 0)..<dayCompo.index(dayCompo.startIndex, offsetBy: 3)] + "," + Datefrm.components(separatedBy: ">")[1] + "-" + DateTo.components(separatedBy: ">")[1] + "GMT+" + formattedDuration + "(\(hour)h)"
                 self.tim.text = timm
                 self.lbldtez.text = Datefrm.components(separatedBy: ">")[2]
                 self.lbldteOccupy.text = Datefrm.components(separatedBy: ">")[2]
                if curntSchedulModll.space_path_name == "false"
                      {
                          self.lcnIcn.isHidden = true
                      }
                      if curntSchedulModll.space_name == "false"
                      {
                          self.lcnIcn.isHidden = true
                      }
            LoaderSpin.shared.hideLoader()
    }
    func getCurrentTimeZone() -> String{
           return TimeZone.current.identifier
    }
    override func viewDidLoad() {
            super.viewDidLoad()
            self.instanceOfUser.writeAnyData(key: "initlLogin", value: "No")
            self.instanceOfUser.writeAnyData(key: "chsnShfttim", value: "")
            self.instanceOfUser.writeAnyData(key: "chsnShft", value: "")
            self.instanceOfUser.writeAnyData(key: "chsnShftdurn", value: "")
            self.instanceOfUser.writeAnyData(key: "chsnShftId", value: "")
            self.instanceOfUser.writeAnyData(key: "chsnShftStart", value: "")
            self.instanceOfUser.writeAnyData(key: "chsnShftEnd", value: "")
                instanceOfUser.writeAnyData(key: "offsetz", value: 0)

            LoaderSpin.shared.showLoader(self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
             APIClient_redesign.shared().getTokenz { status in
               if status {
                 APIClient_redesign.shared().getUserinformation(){ count in
                    if count {
                        self.lblSpace.text = "You are in " + " " + usrInfoModls.company_name
                        self.lblName.text = "Hello " +  usrInfoModls.name
                        let tags = [
                            "user_id": usrInfoModls.user_id,
                            "employee_id": usrInfoModls.employee_id,
                            "user_name": usrInfoModls.employee_name,
                            "build": "demo" ,
                           "instance": "demo.helixsense.com",
                           "current_company": usrInfoModls.company_id
                            ] as [String : Any]
                          OneSignal.sendTags(tags as [AnyHashable : Any], onSuccess: { (result) in
                            print("success!")
                        }) { (error) in
                          print("Fail!")
                        }
                            
                    }
                 }
               // sleep(1)
                    APIClient_redesign.shared().getConfiguration(){ count in
                       if count {
                                self.categories.removeAll()
                                self.enable_prescreen = configurationModls.enable_prescreen
                                self.instanceOfUser.writeAnyData(key: "covidDos", value: configurationModls.enable_other_resources_url)
                                self.categories.append(dshBrdList(name: configurationModls.enable_other_resources_name, Id: String(configurationModls.enable_other_resources_id),url:configurationModls.enable_other_resources_url))
                                self.instanceOfUser.writeAnyData(key: "covidsafety", value: configurationModls.safety_resources_url)
                                self.categories.append(dshBrdList(name: configurationModls.safety_resources_name, Id: String(configurationModls.safety_resources_id), url: configurationModls.safety_resources_url))
                                self.categories.append(dshBrdList(name: "Report COVID incident", Id: "incident", url: ""))
                                self.categories.append(dshBrdList(name: "Report an issue", Id: "issue", url: ""))
                                DispatchQueue.main.async {
                                    //Update UI
                                    self.tableView.reloadData()
                                }
                           self.lblCovid.text = configurationModls.title
                          var imageStr =  configurationModls.enable_landing_page_name.trimmingCharacters(in: .whitespacesAndNewlines)
                           imageStr =  String(imageStr.filter { !"\r\n\n\t\r".contains($0) })
                           self.covidInfo.text = imageStr
                                self.helpCenter.text  = "COVID Help Center"
                       }
                    }
                
               //  sleep(1)
                APIClient_redesign.shared().getCurrentSchedule()
                { count in
                    self.prestats = curntSchedulModll.prescreen_status
                    if curntSchedulModll.space_path_name == "false"
                    {
                        curntSchedulModll.space_path_name = ""
                    }
                    if curntSchedulModll.space_name == "false"
                    {
                        curntSchedulModll.space_name = ""
                    }

                    self.lblWrkschedul.isHidden = false
                    self.wrkSpace.text = curntSchedulModll.space_path_name // space_path_name
                    self.lblplndStats.text = curntSchedulModll.planned_status + " " +  curntSchedulModll.shift_name
                    self.wrkSpaceNum.text = curntSchedulModll.space_name

                    if !count
                    {//book
                        self.instanceOfUser.writeAnyData(key: "bkStatus", value: "book")
                        self.setupUIBook()
                    }
                    else
                    {
                        self.instanceOfUser.writeAnyData(key: "bkStatus", value: "nobook")
                        self.setupUIOccupy()
                    }
                    }
                    }

               }
             
              }
            }
    func getMinutesDifferenceFromTwoDates(start: Date, end: Date) -> String
           {
               
               let diff = Int(end.timeIntervalSince1970 - start.timeIntervalSince1970)
               
               let hours = diff / 3600
               let minutes = (diff - hours * 3600) / 60
               
               return "\(hours):\(minutes)"
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
extension cvdDashbrdViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cvdMaindshcell", for: indexPath) as!  cvdMaindshcell
        cell.lblDos.text = categories[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    //https://www.9healthfair.org/blog/advice-from-a-doctor-coronavirus-dos-and-donts/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.instanceOfUser.writeAnyData(key: "dos_safty", value: "dos")
           // print(self.instanceOfUser.readStringData(key: "covidDos"))
            let vc = UIStoryboard(name: "webViewStoryboard", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! webViewController
            vc.dosLink = self.instanceOfUser.readStringData(key: "covidDos")
                   self.navigationController?.isNavigationBarHidden = true
                   self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if indexPath.row == 1 {
            self.instanceOfUser.writeAnyData(key: "dos_safty", value: "safty")
            let vc = UIStoryboard(name: "webViewStoryboard", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! webViewController
            vc.saftyLink = self.instanceOfUser.readStringData(key: "covidsafety")
                   self.navigationController?.isNavigationBarHidden = true
                   self.navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 2 {//report incidnt
                let vc = UIStoryboard(name: "addEqpmntStoryboard", bundle: nil).instantiateViewController(withIdentifier: "AssetRegistry") as! AssetRegistryViewController
                       self.navigationController?.isNavigationBarHidden = true
                       self.navigationController?.pushViewController(vc, animated: true)
                }
                else if indexPath.row == 3 {//report issu
                    let vc = UIStoryboard(name: "rseTkyStoryboard", bundle: nil).instantiateViewController(withIdentifier: "rprtIssy") as! SelectLocationViewController
                           self.navigationController?.isNavigationBarHidden = true
                           self.navigationController?.pushViewController(vc, animated: true)
                    }
        //addEqpmntStoryboard
    }
}

enum HomeVCCell {
    case covidInfo
}
