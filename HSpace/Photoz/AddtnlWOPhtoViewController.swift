//
//  AddtnlWOPhtoViewController.swift
//  AMTfm
//
//  Created by DEEBA on 27.05.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import SQLite3
import UIKit
import MobileCoreServices
import CoreLocation
class AddtnlWOPhtoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var ImgView: UIImageView!
    
    let picker = UIImagePickerController()
    let instanceOfUser = readWrite()
    var db:OpaquePointer? = nil
    var fileName = ""
    var filPth = ""
    var lati  = 0.0
    var longi  = 0.0
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
                locationManager = CLLocationManager()
                       locationManager.delegate = self
                       locationManager.desiredAccuracy = kCLLocationAccuracyBest
                       locationManager.requestAlwaysAuthorization()

                       if CLLocationManager.locationServicesEnabled(){
                           locationManager.startUpdatingLocation()
                       }
            
            picker.delegate = self
            shoot()
        }
        func shoot(){
            picker.allowsEditing = false
            if self.instanceOfUser.readStringData(key: "PhtoOptn") ==  "Camra" {
                     picker.sourceType = UIImagePickerController.SourceType.camera

                picker.cameraCaptureMode = .photo
                 }
                 else if self.instanceOfUser.readStringData(key: "PhtoOptn") ==  "Gallry" {
                     picker.sourceType = .photoLibrary
                 }
            picker.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async{
                self.present(self.picker,animated: true,completion: nil)
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
        var documentsUrl: URL {
             return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
         }
         func save(image: UIImage) -> String? {
            let fileURL = documentsUrl.appendingPathComponent(fileName)
            filPth = fileURL.absoluteString
             if let imageData = image.jpegData(compressionQuality: 1.0) {
               try? imageData.write(to: fileURL, options: .atomic)
               return fileName // ----> Save fileName
            }
            print("Error saving image")
            return nil
        }
          func load(fileName: String) -> UIImage? {
             let fileURL = documentsUrl.appendingPathComponent(fileName)
             do {
                 let imageData = try Data(contentsOf: fileURL)
                 return UIImage(data: imageData)
             } catch {
                 print("Error loading image : \(error)")
             }
             return nil
         }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let uuid = UUID().uuidString
            let imageData: Data? = pickedImage.jpegData(compressionQuality: 0.4)
            let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
            let documentDirectory = documentsUrl
            let currentDate = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let convertedDate = dateFormatter.string(from: currentDate as Date)
            let imageURL = documentDirectory.appendingPathComponent(convertedDate)
            let imageUrlPath  = imageURL.path
            let dataDecoded : Data = Data(base64Encoded: imageStr, options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            // description
            
            fileName =  self.instanceOfUser.readStringData(key: "descriptn")
            save(image: decodedimage!)
               // ImgView.contentMode = .scaleAspectFit
               // ImgView.image = load(fileName: fileName)
            phtoMdl.guid = uuid
            phtoMdl.unq_id = chsStrtMdl.idWO
            phtoMdl.file_name = fileName
            phtoMdl.data_file_name = convertedDate
            phtoMdl.file_data = imageStr
            phtoMdl.pathz = filPth
            insertTblTimSht()
            insertTblUplds()
            updteTblOrders()
            
            self.instanceOfUser.writeAnyData(key: "Phtotkn", value: true)
             let viewController:
                                   UIViewController = UIStoryboard(
                                       name: "phtoLstStoryboard", bundle: nil
                                   ).instantiateViewController(withIdentifier: "phtoLstStory") as! phtoLstViewController
                                   // .instantiatViewControllerWithIdentifier() returns AnyObject!
                                   // this must be downcast to utilize it

                                   let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                   //show window
                                   appDelegate.window?.rootViewController = viewController
            }
            

           dismiss(animated: true, completion: nil)
           }
           func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           self.showCurrentLocationonMap()
           self.locationManager.stopUpdatingLocation()
           }
           func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
               dismiss(animated: true, completion: nil)
           }
        func showCurrentLocationonMap() {
            lati = self.locationManager.location?.coordinate.latitude as! Double
            longi = self.locationManager.location?.coordinate.longitude as! Double

        }
        func insertTblTimSht(){
           
                   let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                   .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
                   //opening the database
                   if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                      print("There's error in opening the database")
                   }
                    else
                    {
                        if self.instanceOfUser.readBoolData(key: "Finsh"){
                                let updateStatementString = "UPDATE tbl_timesheet SET end_date  = ?,is_submitted = ? WHERE unq_id =? ;"
                                var updateStatement: OpaquePointer?
                                // 1
                                if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
                                    SQLITE_OK {
                                  // 3
                                 sqlite3_bind_text(updateStatement, 1, (phtoMdl.data_file_name as NSString).utf8String, -1, nil)
                                 sqlite3_bind_int(updateStatement, 2, (Int32(phtoMdl.unq_id)))
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
                                sqlite3_bind_text(insertStatement, 1, (phtoMdl.guid as NSString).utf8String, -1, nil)
                                sqlite3_bind_int(insertStatement, 2, (Int32(phtoMdl.unq_id)))
                                sqlite3_bind_text(insertStatement, 3,(phtoMdl.data_file_name as NSString).utf8String, -1, nil)
                                sqlite3_bind_text(insertStatement, 4,(phtoMdl.data_file_name as NSString).utf8String, -1, nil)
                                sqlite3_bind_text(insertStatement, 5,("" as NSString).utf8String, -1, nil)
                                sqlite3_bind_text(insertStatement, 6,(String(lati) as NSString).utf8String, -1, nil)
                                sqlite3_bind_text(insertStatement, 7,(String(longi) as NSString).utf8String, -1, nil)
                                sqlite3_bind_text(insertStatement, 8,("in_progress"  as NSString).utf8String, -1, nil)
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
                                              
                                            let unqId: Int = Int(Int32(phtoMdl.unq_id))
                                                let updateStatementString = "UPDATE tbl_orders SET status  = ?,is_flag = ?,sync_status = ?, is_modified_status = ? WHERE unq_id =? ;"
                                                var updateStatement: OpaquePointer?
                                                if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
                                                    SQLITE_OK {
                                                   let accptStts: Int
                                                   accptStts = 1
                                                    // is_flag, sync_status,is_modified_status
                                                   let isflag: Int
                                                   isflag = 0
                                                    sqlite3_bind_text(updateStatement, 1, ("in_progress"  as NSString).utf8String, -1, nil)
                                                    sqlite3_bind_int(updateStatement, 2,1)
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
        func insertTblUplds(){
           
                   let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                   .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
                   //opening the database
                   if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                      print("There's error in opening the database")
                   }
                    else
                    {
                       let syncSrNo: Int = 0
                       let insertStatementString = "INSERT INTO tbl_uploads (guid,unq_id,file_name,data_file_name ,file_data,path,image_type,checklist_id,sync_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);"
                       var insertStatement: OpaquePointer?
                       // 1
                       if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
                           SQLITE_OK {
                         // 3
                        sqlite3_bind_text(insertStatement, 1, (phtoMdl.guid as NSString).utf8String, -1, nil)
                        sqlite3_bind_int(insertStatement, 2, (Int32(phtoMdl.unq_id)))
                        sqlite3_bind_text(insertStatement, 3,(phtoMdl.file_name as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStatement, 4,(phtoMdl.data_file_name as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStatement, 5,(phtoMdl.file_data as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStatement, 6,(phtoMdl.pathz as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStatement, 7,("image" as NSString).utf8String, -1, nil)
                        if self.instanceOfUser.readStringData(key: "WOphtochkLst" ) ==  "WOphto"
                        {
                            sqlite3_bind_text(insertStatement, 8,("" as NSString).utf8String, -1, nil)
                            }
                        else if self.instanceOfUser.readStringData(key: "WOphtochkLst" ) ==  "phtochkLst"
                        {
                            sqlite3_bind_text(insertStatement, 8,(String(self.instanceOfUser.readIntData(key: "chkLstId"))   as NSString).utf8String, -1, nil)
                            }
                         sqlite3_bind_int(insertStatement, 9,(Int32(syncSrNo)))
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
                       sqlite3_close(db)
                       db = nil
               }

               
        
           
          }
