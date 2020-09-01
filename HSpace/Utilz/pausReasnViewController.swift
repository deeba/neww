//
//  pausReasnViewController.swift
//  AMTfm
//
//  Created by DEEBA on 28.05.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import SQLite3
import UIKit
import MobileCoreServices
import CoreLocation
class pausReasnViewController: UIViewController, UITextFieldDelegate , UITableViewDelegate, UITableViewDataSource {
    
    var locationManager = CLLocationManager()
    var lati  = 0.0
    var longi  = 0.0
  // var choices = ["Sent for service","Vendor Support","Weekend Activity","Procurement Support","Spares parts not available","water leakage from pump and abnormal","Replacement required","Material required", "Not in Operative"]
    
    let instanceOfUser = readWrite()
    var db:OpaquePointer? = nil
    @IBOutlet weak var tblDropDownHC: NSLayoutConstraint!
    @IBOutlet weak var btnNumberOfRooms: UIButton!
    @IBOutlet weak var tblDropDown: UITableView!
    @IBOutlet weak var txtRsn: UITextField!
    var isTableVisible = false
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tagBasedTextField(textField)
        return true
    }
    func showCurrentLocationonMap() {
        lati = self.locationManager.location?.coordinate.latitude as! Double
        longi = self.locationManager.location?.coordinate.longitude as! Double

    }
    private func tagBasedTextField(_ textField: UITextField) {
            textField.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        txtRsn.delegate = self
        
        tblDropDown.delegate = self
        tblDropDown.dataSource = self
        tblDropDownHC.constant = 0
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pausRsnzModl.pauzNam.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "numberofrooms")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "numberofrooms")
            }
            cell?.textLabel?.text =  pausRsnzModl.pauzNam[indexPath.row]
            return cell!
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            btnNumberOfRooms.setTitle("\( pausRsnzModl.pauzNam[indexPath.row])", for: .normal)
            UIView.animate(withDuration: 0.5) {
                self.tblDropDownHC.constant = 0
                self.isTableVisible = false
                self.view.layoutIfNeeded()
            }
            
        }
    @IBAction func btnOk(_ sender: UIButton) {
        if btnNumberOfRooms.titleLabel?.text != "--Select Reason Type--" && txtRsn.text != "" {
            updteTblOrders()
            insertTblTimSht()
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
        else
        {
            showToast(message: "Please fill in the details " )
        }
    }
    func updteTblOrders()  {
         let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                                      .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
                                      //opening the database
                                       if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                                             print("There's error in opening the database")
                                          }
                                       else
                                       {
                                      if sqlite3_open(file_URL.path, &db) == SQLITE_OK {
                                          
                                        let unqId: Int = Int(Int32(chsStrtMdl.idWO))
                                            let updateStatementString = "UPDATE tbl_orders SET status  = ?,is_flag = ?,sync_status = ?, is_modified_status = ? WHERE unq_id =? ;"
                                            var updateStatement: OpaquePointer?
                                            if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
                                                SQLITE_OK {
                                               let accptStts: Int
                                               accptStts = 1
                                                // is_flag, sync_status,is_modified_status
                                               let isflag: Int
                                               isflag = 0
                                                sqlite3_bind_text(updateStatement, 1, ("pause"  as NSString).utf8String, -1, nil)
                                                sqlite3_bind_int(updateStatement, 2,2)
                                                sqlite3_bind_int(updateStatement, 3,0)
                                                sqlite3_bind_int(updateStatement, 4,1)
                                                sqlite3_bind_int(updateStatement, 5,(Int32(unqId)))
                                               
                                               if sqlite3_step(updateStatement) == SQLITE_DONE {
                                                                   //print("\nSuccessfully updated row.")
                                                                 } else {

                                                                   
                                                                   print("\nCould not update row.")
                                                                 }
                                            }
                                               sqlite3_finalize(updateStatement)
                                      }
                                      }
                                   sqlite3_close(db)
                                   db = nil
    }
    func insertTblTimSht(){
            let uuid = UUID().uuidString
            let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
            //opening the database
            if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
               print("There's error in opening the database")
            }
             else
             {
                let currentDate = NSDate()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                let convertedDate = dateFormatter.string(from: currentDate as Date)

                 if self.instanceOfUser.readBoolData(key: "Finsh"){
                         let updateStatementString = "UPDATE tbl_timesheet SET end_date  = ?,is_submitted = ? WHERE unq_id =? ;"
                         var updateStatement: OpaquePointer?
                         // 1
                         if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
                             SQLITE_OK {
                           // 3
                            
                          sqlite3_bind_text(updateStatement, 1, (convertedDate as NSString).utf8String, -1, nil)
                          sqlite3_bind_int(updateStatement, 2, (Int32(chsStrtMdl.idWO)))
                            if sqlite3_step(updateStatement) == SQLITE_DONE {
                                                                                                    print("\nSuccessfully updated row.")
                                                                                                  } else {

                                                                                                    
                                                                                                    print("\nCould not update row.")
                                                                                                  }
                                                                             }
                         // 5
                         sqlite3_finalize(updateStatement)
                  
                 }
                     else{
                        let syncSrNo: Int = 0
                        let insertStatementString = "INSERT INTO tbl_timesheet (guid ,unq_id,start_date,end_date ,reason,latitude,longitude,job_order_status,timesheet_ids,sync_stats) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
                        var insertStatement: OpaquePointer?
                        // 1
                        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
                            SQLITE_OK {
                          // 3
                         sqlite3_bind_text(insertStatement, 1, (uuid as NSString).utf8String, -1, nil)
                         sqlite3_bind_int(insertStatement, 2, (Int32(chsStrtMdl.idWO)))
                         sqlite3_bind_text(insertStatement, 3,(convertedDate as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 4,(convertedDate as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 5,("" as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 6,(String(lati) as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 7,(String(longi) as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 8,("pause"  as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(insertStatement, 9,(""  as NSString).utf8String, -1, nil)
                         sqlite3_bind_int(insertStatement, 10,(Int32(syncSrNo)))
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
                 
                }
            }
                sqlite3_close(db)
                db = nil
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
    @IBAction func selectNumberOfRooms(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5) {
            if self.isTableVisible == false {
                self.isTableVisible = true
             self.tblDropDownHC.constant = 44.0 * 3.0
            } else {
                self.tblDropDownHC.constant = 0
                self.isTableVisible = false
            }
            self.view.layoutIfNeeded()
        }
    }


    }
