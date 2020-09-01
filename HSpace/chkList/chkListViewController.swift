//
//  ViewController.swift
//  SvrollView
//
//  Created by Aivars Meijers on 22/02/2020.
//  Copyright © 2020 Aivars Meijers. All rights reserved.
//
import UIKit
import SQLite3
import SwiftyJSON
import MobileCoreServices
import CoreLocation
extension chkListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // don't force `endEditing` if you want to be asked for resigning
        // also return real flow value, not strict, like: true / false
        return textField.endEditing(false)
    }
}
extension String{
    var htmlStripped : String{
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
extension UINavigationController {

    var isHiddenHairline: Bool {
        get {
            guard let hairline = findHairlineImageViewUnder(navigationBar) else { return true }
            return hairline.isHidden
        }
        set {
            if let hairline = findHairlineImageViewUnder(navigationBar) {
                hairline.isHidden = newValue
            }
        }
    }

    private func findHairlineImageViewUnder(_ view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }

        for subview in view.subviews {
            if let imageView = self.findHairlineImageViewUnder(subview) {
                return imageView
            }
        }

        return nil
    }
}
class chkListViewController: UIViewController , CLLocationManagerDelegate {
    var imgMdl: imgData!
    var imgsync = [ImgSync]()
    let status = CLLocationManager.authorizationStatus()
     var imgId  = 0
    var lati  = 0.0
    var longi  = 0.0
    var locationManager = CLLocationManager()
    
    var txtcntr: Int  =  0
    var emptyAns: Bool  =  false
    @IBOutlet weak var lblOrdrnum: UILabel!
    @IBOutlet weak var lblMaintyp: UILabel!
    @IBOutlet weak var lblPausrsn: UILabel!
    @IBOutlet weak var lblAsstnam: UILabel!
    @IBOutlet weak var lblAssgnto: UILabel!
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            print("Current location: \(currentLocation)")
         /*   let userLocation :CLLocation = locations[0] as CLLocation

            print("user latitude = \(userLocation.coordinate.latitude)")
            print("user longitude = \(userLocation.coordinate.longitude)")

            self.labelLat.text = "\(userLocation.coordinate.latitude)"
            self.labelLongi.text = "\(userLocation.coordinate.longitude)"

            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
                if (error != nil){
                    print("error in reverseGeocode")
                }
                let placemark = placemarks! as [CLPlacemark]
                if placemark.count>0{
                    let placemark = placemarks![0]
                    print(placemark.locality!)
                    print(placemark.administrativeArea!)
                    print(placemark.country!)

                    self.labelAdd.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
                }
            }*/
        }
    }
    func showCurrentLocationonMap() {
           lati = self.locationManager.location?.coordinate.latitude as! Double
           longi = self.locationManager.location?.coordinate.longitude as! Double

       }

    @IBAction func btnCommen(_ sender: UIButton) {
        let viewController:
                                 UIViewController = UIStoryboard(
                                     name: "CommntsStoryboard", bundle: nil
                                 ).instantiateViewController(withIdentifier: "commenStory") as! CommntsViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                 //show window
                                 appDelegate.window?.rootViewController = viewController
    }
    
    let instanceOfUser = readWrite()
    @IBOutlet weak var btnPaus: UIButton!
    @IBOutlet weak var btnFinis: UIButton!
    @IBOutlet weak var btnRlsAftrPhto: UIButton!
    @IBOutlet weak var relsButn: UIButton!
    @IBOutlet weak var scrolVw: UIScrollView!
    @IBOutlet weak var strtButn: UIButton!
    
    @IBAction func btnPauz(_ sender: UIButton) {
                self.instanceOfUser.writeAnyData(key: "PausRlz", value: "Pauz")
               let storyBoard: UIStoryboard = UIStoryboard(name: "relsSrNoStoryboard", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "srNoVC") as! relsSrNoViewController
                self.present(newViewController, animated: true, completion: nil)
    }
    @IBAction func btnRelsAftrStrt(_ sender: UIButton) {
                self.instanceOfUser.writeAnyData(key: "PausRlz", value: "Relz")
               let storyBoard: UIStoryboard = UIStoryboard(name: "relsSrNoStoryboard", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "srNoVC") as! relsSrNoViewController
                self.present(newViewController, animated: true, completion: nil)
    }
    @IBAction func btnPhto(_ sender: UIButton) {
        self.instanceOfUser.writeAnyData(key: "WOphtochkLst", value:"WOphto" )
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
    
    @IBAction func btnRels(_ sender: UIButton)
    {
                self.instanceOfUser.writeAnyData(key: "PausRlz", value: "Relz")
               let storyBoard: UIStoryboard = UIStoryboard(name: "relsSrNoStoryboard", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "srNoVC") as! relsSrNoViewController
                self.present(newViewController, animated: true, completion: nil)
    }

    @IBAction func btnFnsh(_ sender: UIButton) {
           strtButn.isEnabled  =  false
         
         var strSlcn:String = ""
           for ih in 0..<chkLstModl.chkLstId.count {
               strSlcn = ""
             for er in 0..<selDeslMdl.rowId.count {
                     if selDeslMdl.rowId[er] == Int(chkLstModl.chkLstId[ih])
                     {
                         if selDeslMdl.selcnSorNo[er] {
                                 if selDeslMdl.selcnNam[er] == "" { // for text the initial values will be "" so get get correspndg values of txtbox array
                                     chkLstModl.suggsn[ih] = txtFlds[txtcntr].text!
                                     strSlcn = chkLstModl.suggsn[ih]
                                     txtcntr = txtcntr + 1
                                     }
                                 else
                                  {
                                      if strSlcn == "" {
                                              chkLstModl.suggsn[ih] =  selDeslMdl.selcnNam[er]
                                              strSlcn = chkLstModl.suggsn[ih]
                                          }
                                      else{
                                          chkLstModl.suggsn[ih] = strSlcn  + ","  + selDeslMdl.selcnNam[er]
                                          strSlcn = chkLstModl.suggsn[ih]
                                      }
                             }
                           }
                     }
                 
                 }
                 //update to db on checking if all qstns r answered
                 if chkLstModl.suggsn[ih] == "" {
                     
                     emptyAns = true
                     
                      }
                 else{
                     emptyAns = false
                 }
             
             }
           
           
           
           

           if emptyAns
             {
               let alert = UIAlertController(title: "Caution!", message: "All questions are not answered", preferredStyle: .alert)
               let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
               self.present(alert, animated: true, completion: nil)
           }
           else {

           self.instanceOfUser.writeAnyData(key: "Finsh" , value: true)
          let NotificationVC = UIStoryboard(
                     name: "QRStoryboard", bundle: nil
                 ).instantiateViewController(withIdentifier: "QRStory") as! QRViewController

                                self.present(NotificationVC, animated: true, completion: nil)

            }
           
           
       }
    func insertTblTimSht(){
          let currentDate = NSDate()
             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
             let convertedDate = dateFormatter.string(from: currentDate as Date)
             dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
             let strDate = dateFormatter.string(from: currentDate as Date)
                  let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                  .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
                  //opening the database
                  if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                     print("There's error in opening the database")
                  }
                   else
                   {
                       if self.instanceOfUser.readBoolData(key: "Finsh"){
                               let updateStatementString = "UPDATE tbl_timesheet SET end_date  = ?,job_order_status = ? WHERE unq_id =?  AND guid =?;"
                               var updateStatement: OpaquePointer?
                               // 1
                               if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
                                   SQLITE_OK {
                                self.instanceOfUser.writeAnyData(key: "endDte", value: strDate)
                                 // 3
                                sqlite3_bind_text(updateStatement, 1, (convertedDate as NSString).utf8String, -1, nil)
                                sqlite3_bind_text(updateStatement, 2, ("done" as NSString).utf8String, -1, nil)
                                sqlite3_bind_int(updateStatement, 3, (Int32(chsStrtMdl.idWO)))
                                sqlite3_bind_text(updateStatement, 4, (self.instanceOfUser.readStringData(key: "gUid") as NSString).utf8String, -1, nil)
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
                                    
                               

                                                              let queryStatementString = "SELECT * FROM tbl_timesheet WHERE unq_id =?  AND guid =?;"
                                                               var queryStatement: OpaquePointer?          // 1
                                                               if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                                                                   SQLITE_OK
                                                                {
                                                                    sqlite3_bind_int(queryStatement, 1, (Int32(chsStrtMdl.idWO)))
                                                                    sqlite3_bind_text(queryStatement, 2, (self.instanceOfUser.readStringData(key: "gUid") as NSString).utf8String, -1, nil)
                                                                    if  sqlite3_step(queryStatement) == SQLITE_ROW {

                                                                                                                 }
                                                                    else{
                                                                                                                            self.instanceOfUser.writeAnyData(key: "strtDte", value: strDate)
                                                                                                                            let syncSrNo: Int = 0
                                                                                                                            let insertStatementString = "INSERT INTO tbl_timesheet (guid ,unq_id,start_date,end_date ,reason,latitude,longitude,job_order_status,timesheet_ids,sync_stats) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
                                                                                                                            var insertStatement: OpaquePointer?
                                                                                                                            // 1
                                                                                                                            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
                                                                                                                                SQLITE_OK {
                                                                                                                                // 3
                                                                                                                                sqlite3_bind_text(insertStatement, 1, (self.instanceOfUser.readStringData(key: "gUid") as NSString).utf8String, -1, nil)
                                                                                                                                sqlite3_bind_int(insertStatement, 2, (Int32(chsStrtMdl.idWO)))
                                                                                                                                sqlite3_bind_text(insertStatement, 3,(convertedDate as NSString).utf8String, -1, nil)
                                                                                                                                sqlite3_bind_text(insertStatement, 4,(convertedDate as NSString).utf8String, -1, nil)
                                                                                                                                sqlite3_bind_text(insertStatement, 5,("" as NSString).utf8String, -1, nil)
                                                                                                                                sqlite3_bind_text(insertStatement, 6,(String(lati) as NSString).utf8String, -1, nil)
                                                                                                                                sqlite3_bind_text(insertStatement, 7,(String(longi) as NSString).utf8String, -1, nil)
                                                                                                                                sqlite3_bind_text(insertStatement, 8,("in_progress"  as NSString).utf8String, -1, nil)
                                                                                                                                sqlite3_bind_text(insertStatement, 9,(""  as NSString).utf8String, -1, nil)
                                                                                                                                sqlite3_bind_int(insertStatement, 10,(Int32(syncSrNo)))                              // 4
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
                                                                sqlite3_finalize(queryStatement)
                                                                sqlite3_close(db)
                                                                db = nil
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
                                                if self.instanceOfUser.readBoolData(key: "Finsh"){
                                                sqlite3_bind_text(updateStatement, 1, ("done"  as NSString).utf8String, -1, nil)
                                                sqlite3_bind_int(updateStatement, 2,3)
                                                sqlite3_bind_int(updateStatement, 3,1)
                                                sqlite3_bind_int(updateStatement, 4,1)
                                                sqlite3_bind_int(updateStatement, 5,(Int32(unqId)))
                                               }
                                                else
                                                    {
                                                     sqlite3_bind_text(updateStatement, 1, ("in_progress"  as NSString).utf8String, -1, nil)
                                                     sqlite3_bind_int(updateStatement, 2,1)
                                                     sqlite3_bind_int(updateStatement, 3,0)
                                                     sqlite3_bind_int(updateStatement, 4,1)
                                                     sqlite3_bind_int(updateStatement, 5,(Int32(unqId)))
                                                    }
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
    @IBAction func btnGoBac(_ sender: UIButton) {
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
    
    @IBAction func strtBtn(_ sender: UIButton) {
        let NotificationVC = UIStoryboard(
            name: "QRStoryboard", bundle: nil
        ).instantiateViewController(withIdentifier: "QRStory") as! QRViewController

                       self.present(NotificationVC, animated: true, completion: nil)
    
        }
    @IBOutlet weak var lblEqp: UILabel!
    @IBOutlet weak var lblPhto: UILabel!
    @IBOutlet weak var lblEmp: UILabel!
    @IBOutlet weak var lblTim: UILabel!
    @IBOutlet weak var Commen: UILabel!
    @IBOutlet weak var imgTimz: UIImageView!
    var px = 0
    var strSuggsn:String = ""
    var strBln:String = ""
    var indexz:Int = 0
    var offsetg = 20
    var  iJ :Int = 75
     var buttons = [UIButton]()
     var buttons2 = [UIButton]()
     var buttonY1: CGFloat = 40
       var db:OpaquePointer? = nil
    @IBOutlet weak var d: UIScrollView!
    var arrayOfVillains = ["santa", "bugs", "superman", "batman"]
    var arrayOfVillains2 = ["app", "egg", "oran", "pea"]
    var buttons1 = [UIButton]()
    var txtFlds = [UITextField]()
    var myButtonsArray : [String] = []
    let numberOfButtons = 20
    var start_date = ""
     var end_date = ""
    var latitude = ""
    var longitude = ""
    override func viewDidLoad() {
        var currentLocation: CLLocation!
        
            var locManager = CLLocationManager()
            locManager.requestWhenInUseAuthorization()
             if
                CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways
             {
                 currentLocation = locManager.location
             }
        lati = currentLocation.coordinate.latitude
        longi = currentLocation.coordinate.longitude

        super.viewDidLoad()
        let uuid = UUID().uuidString
               if self.instanceOfUser.readStringData(key: "gUid") == ""
               {
                   self.instanceOfUser.writeAnyData(key: "gUid", value: uuid)
               }
        self.instanceOfUser.writeAnyData(key: "WOphtochkLst", value: "")
        self.instanceOfUser.writeAnyData(key: "chkLstId", value: 0)
        self.instanceOfUser.writeAnyData(key: "PausRlz", value: "")
        if  self.instanceOfUser.readBoolData(key: "Finsh" )
        {
            
         }
        else
        {
            selDeslMdl.rowId.removeAll()
            selDeslMdl.btnSuggsnId.removeAll()
            selDeslMdl.selcnNam.removeAll()
            selDeslMdl.selcnSorNo.removeAll()
            chkLstModl.chkLstId.removeAll()
            chkLstModl.typ.removeAll()
            chkLstModl.Qustn.removeAll()
            chkLstModl.suggsn.removeAll()
            chkLstModl.selPhto.removeAll()
        }
        self.scrolVw.isHidden = true
        strtButn.isHidden = false
        relsButn.isHidden = false
        btnPaus.isHidden = true
        btnFinis.isHidden = true
        btnRlsAftrPhto.isHidden = true

        comntMdl.lblDt.removeAll()
        comntMdl.lblNam.removeAll()
        comntMdl.lblState.removeAll()
        
        if  self.instanceOfUser.readStringData(key: "PausRlz") == "Pauz"{
            lblOrdrnum.text = chsStrtMdl.idOrdr
            lblAssgnto.text = self.instanceOfUser.readStringData(key: "employeeNamez")
            lblMaintyp.text  = chsStrtMdl.mainTyp
            lblAsstnam.text  = chsStrtMdl.asstNam
            }
        if  self.instanceOfUser.readBoolData(key: "Rescanz")
              {
                self.instanceOfUser.writeAnyData(key: "Rescanz", value: false)
                  OperationQueue.main.addOperation {
                      let storyBoard: UIStoryboard = UIStoryboard(name: "AlertStoryboard", bundle: nil)
                      if #available(iOS 10.0, *) {
                          let newViewController = storyBoard.instantiateViewController(withIdentifier: "AlertVC") as! AlertViewController
                          self.present(newViewController, animated: true, completion: nil)
                      }
                     
                  }
              }
        
        
        
              if  self.instanceOfUser.readBoolData(key: "QRfound")
              {
                self.instanceOfUser.writeAnyData(key: "QRfound", value: false)
                //if start mro flag confirm to take photo
                if chsStrtMdl.mrFlg {
                    let viewController:
                        UIViewController = UIStoryboard(
                            name: "PicAlertStoryboard", bundle: nil
                        ).instantiateViewController(withIdentifier: "PicAlertStory") as! PicALertViewController
                    // .instantiatViewControllerWithIdentifier() returns AnyObject!
                    // this must be downcast to utilize it
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    //show window
                    appDelegate.window?.rootViewController = viewController
                    self.scrolVw.isHidden = false
                    strtButn.isHidden = true
                    relsButn.isHidden = true
                    btnPaus.isHidden = false
                    btnFinis.isHidden = false
                    btnRlsAftrPhto.isHidden = false
                    insertTblTimSht()
                    updteTblOrders()
                    
                }
                else //if start mro flag false checklist shown with release pause finish butn
                {
                    self.scrolVw.isHidden = false
                    strtButn.isHidden = true
                    relsButn.isHidden = true
                    btnPaus.isHidden = false
                    btnFinis.isHidden = false
                    btnRlsAftrPhto.isHidden = false
                    insertTblTimSht()
                    updteTblOrders()
                }
                
        }
         if  self.instanceOfUser.readBoolData(key: "QRFnsh")
                      {

                                      //if dne mro flag confirm to take photo
                                    if chsStrtMdl.dnemrFlg {
                                        if self.instanceOfUser.readBoolData(key: "PhtotknFnsh")
                                        {//updte to tbl chklist n sync
                                                 for ih in 0..<chkLstModl.chkLstId.count {

                                                     
                                                           
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
                                                                                               let updateStatementString = "UPDATE tbl_checklist SET answer  = ?,is_submitted = ?,sync_status = ? WHERE checklist_id =? ;"
                                                                                               var updateStatement: OpaquePointer?
                                                                                               if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
                                                                                                   SQLITE_OK {
                                                                                                  let accptStts: Int
                                                                                                  accptStts = 1
                                                                                                   // is_flag, sync_status,is_modified_status
                                                                                                  let isflag: Int
                                                                                                  isflag = 0
                                                                                                   sqlite3_bind_text(updateStatement, 1, (chkLstModl.suggsn[ih]  as NSString).utf8String, -1, nil)
                                                                                                   sqlite3_bind_text(updateStatement, 2, (""  as NSString).utf8String, -1, nil)
                                                                                                sqlite3_bind_int(updateStatement, 3, 1)
                                                                                                   sqlite3_bind_text(updateStatement, 4, (chkLstModl.chkLstId[ih]  as NSString).utf8String, -1, nil)
                                                                                                  
                                                                                                  if sqlite3_step(updateStatement) == SQLITE_DONE {
                                                                                                                      print("\nSuccessfully updated row.")
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
                                                 updteTblOrders()
                                                 insertTblTimSht()
                                                 ftchphtoFromdb()
                                            for ih in 0..<chkLstModl.chkLstId.count {
                                                 upLdtoServr(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"),chklstId:chkLstModl.chkLstId[ih],chklstTyp:chkLstModl.typ[ih],chklstSuggsn:chkLstModl.suggsn[ih] )
                                                   }
                                            for ih in 0..<imgsync.count {
                                                   imgSync(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"),imgFil:imgsync[ih].imgFil,imgFDat:imgsync[ih].imgDta)
                                                }
                                          updteWstat(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"))
                                            updteImg(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"))
                                            sleep(1)
                                             updteImgz(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"))
                                         }
                                        else
                                        {
                                                   let viewController:
                                                                                 UIViewController = UIStoryboard(
                                                                                     name: "PicAlertStoryboard", bundle: nil
                                                                                 ).instantiateViewController(withIdentifier: "PicAlertStory") as! PicALertViewController
                                                                                 // .instantiatViewControllerWithIdentifier() returns AnyObject!
                                                                                 // this must be downcast to utilize it

                                                                                 let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                                                 //show window
                                                                                 appDelegate.window?.rootViewController = viewController
                                                        
                                        }
                                        
                                        }
                                    else //if no dne mro flag
                                        {//updte to tbl chklist n sync
                                                for ih in 0..<chkLstModl.chkLstId.count {

                                                    
                                                          
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
                                                                                              let updateStatementString = "UPDATE tbl_checklist SET answer  = ?,is_submitted = ? WHERE checklist_id =? ;"
                                                                                              var updateStatement: OpaquePointer?
                                                                                              if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
                                                                                                  SQLITE_OK {
                                                                                                 let accptStts: Int
                                                                                                 accptStts = 1
                                                                                                  // is_flag, sync_status,is_modified_status
                                                                                                 let isflag: Int
                                                                                                 isflag = 0
                                                                                                  sqlite3_bind_text(updateStatement, 1, (chkLstModl.suggsn[ih]  as NSString).utf8String, -1, nil)
                                                                                                  sqlite3_bind_text(updateStatement, 2, (""  as NSString).utf8String, -1, nil)
                                                                                                  sqlite3_bind_text(updateStatement, 3, (chkLstModl.chkLstId[ih]  as NSString).utf8String, -1, nil)
                                                                                                 
                                                                                                 if sqlite3_step(updateStatement) == SQLITE_DONE {
                                                                                                                     print("\nSuccessfully updated row.")
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
                                                updteTblOrders()
                                                insertTblTimSht()
                                                ftchphtoFromdb()
                                                for ih in 0..<chkLstModl.chkLstId.count {
                                                       
                                                       upLdtoServr(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"),chklstId:chkLstModl.chkLstId[ih],chklstTyp:chkLstModl.typ[ih],chklstSuggsn:chkLstModl.suggsn[ih] )
                                                }
                                             for ih in 0..<imgsync.count {
                                                imgSync(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"),imgFil:imgsync[ih].imgFil,imgFDat:imgsync[ih].imgDta)
                                             }
                                            updteWstat(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"))
                                            updteImg(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"))
                                            sleep(1)
                                                                                        updteImgz(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"))
                                           self.instanceOfUser.readBoolData(key: "Finshd")
                                        }
                        if chsStrtMdl.dnemrFlg && self.instanceOfUser.readBoolData(key: "PhtotknFnsh") {
                            self.instanceOfUser.writeAnyData(key: "Finshd", value: true)
                        }
                      if self.instanceOfUser.readBoolData(key: "Finshd")
                       {
                           print("Finshd")
                        let viewController:
                                       UIViewController = UIStoryboard(
                                           name: "HomeStoryboard", bundle: nil
                                       ).instantiateViewController(withIdentifier: "HomeStory") as! HomeScreenz
                                   let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                        //show window
                                                        appDelegate.window?.rootViewController = viewController
                         //  let raiseTicket = UIStoryboard(name: "HomeStoryboard", bundle: .main).instantiateInitialViewController()!
                         //  navigationController?.pushViewController(raiseTicket, animated: true)
                       }
                            
        }
              if self.instanceOfUser.readBoolData(key: "Phtotkn")
              {
                  
                  self.scrolVw.isHidden = false
                  strtButn.isHidden = true
                  relsButn.isHidden = true
                  btnPaus.isHidden = false
                  btnFinis.isHidden = false
                  btnRlsAftrPhto.isHidden = false
              }
                  if chsStrtMdl.ImgTim == "Group-13"
                  {
                          imgTimz.image = UIImage(named: "Group-13")
                    }
                      else{
                          imgTimz.image = UIImage(named: "Group-14")
                      }
                  lblEqp.text = chsStrtMdl.strEqp + " - In Progress"
                  lblTim.text = chsStrtMdl.strTim
                  lblEmp.text = self.instanceOfUser.readStringData(key: "employeeNamez")
                  fetchCommnts(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
                  self.lblPhto.font =  UIFont(name: "Helvetica Neue Bold", size: 16)
                  self.lblPhto.text =    "(" +  "\(getPhotoCnt())"  + ")"
     
     
        // Display our 2D string array.
       
           d.isScrollEnabled = true
           d.isUserInteractionEnabled = true
            d.alwaysBounceVertical = true
        if  self.instanceOfUser.readBoolData(key: "Finsh" )
        {
            
         }
        else
        {
                         let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                         .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
                         //opening the database
                         if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                            print("There's error in opening the database")
                         }
                      else
                          {
                            let queryStatementString = "SELECT * FROM tbl_checklist WHERE  Orderid=? AND (checklist_type=? OR  checklist_type=? OR  checklist_type=? OR  checklist_type=?) ;"
                             var queryStatement: OpaquePointer?
                            let  OdrId = chsStrtMdl.idOrdr
                            let  suggst = "suggestion"
                            let  sugstBln = "boolean"
                            let  sugstTxt = "text"
                            let  sugstNum = "number"
                             // 1
                             if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                                 SQLITE_OK {
                                      //5F1!!!
                                         // 2
                               sqlite3_bind_text(queryStatement, 1, (OdrId as NSString).utf8String, -1, nil)
                                sqlite3_bind_text(queryStatement, 2, (suggst as NSString).utf8String, -1, nil)
                                sqlite3_bind_text(queryStatement, 3, (sugstBln as NSString).utf8String, -1, nil)
                                sqlite3_bind_text(queryStatement, 4, (sugstTxt as NSString).utf8String, -1, nil)
                                sqlite3_bind_text(queryStatement, 5, (sugstNum as NSString).utf8String, -1, nil)

                              // sqlite3_bind_int(queryStatement, 1, (Int32(chsStrtMdl.idWO)))
                                       // 2
                                    while  sqlite3_step(queryStatement) == SQLITE_ROW {
                                      let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                                       chkLstModl.chkLstId.append( String(cString: queryResultCol1!))
                                       let queryResultCol2 = sqlite3_column_text(queryStatement, 2)
                                       chkLstModl.typ.append( String(cString: queryResultCol2!))
                                       let queryResultCol3 = sqlite3_column_text(queryStatement, 3)
                                       chkLstModl.Qustn.append( String(cString: queryResultCol3!))
                                       let queryResultCol4 = sqlite3_column_text(queryStatement, 4)
                                      // chkLstModl.suggsn.append( String(cString: queryResultCol4!))
                                      chkLstModl.selPhto.append(false)
                                        
                                        var buttonY1: CGFloat = 10
                                                  //   photo
                                                let frame1 = CGRect(x: Int(buttonY1), y: iJ, width: 30, height: 30)
                                                         let button = UIButton(frame: frame1)
                                                         button.layer.cornerRadius = 5
                                                         button.setImage(UIImage(named: "Bitmap Copy 6"), for: .normal)
                                                // button.layer.borderWidth  = 1
                                                 //button.layer.borderColor = #colorLiteral(red: 0.3769986629, green: 0.3747626841, blue: 0.3787207901, alpha: 1)
                                                         button.isUserInteractionEnabled = true
                                                         button.tag = Int(String(cString: queryResultCol1!))!
                                                         buttons1.append(button)
                                                         button.addTarget(self, action: #selector(phtoAction(_:)), for: .touchUpInside)
                                                         self.d.addSubview(button)
                                                //   Qstn
                                        let lblQstn = UILabel(frame: CGRect(x: Int(buttonY1), y: offsetg, width: 370, height: 45))
                                         lblQstn.layer.cornerRadius = 10  // get some fancy pantsy rounding
                                        lblQstn.layer.cornerRadius = 10
                                        lblQstn.numberOfLines = 2
                                         lblQstn.text = String(cString: queryResultCol3!)
                                         self.d.addSubview(lblQstn)
                                        buttonY1 = buttonY1 + 40
                                        let fy  =  String(cString: queryResultCol4!)
                                        if fy != "" { //suggsn is not empty
                                        let r = fy.index(fy.startIndex, offsetBy: 9)..<fy.index(fy.endIndex, offsetBy: -1)
                                        // Access the string by the range.
                                        let substring = fy[r]
                                        let json = JSON.init(parseJSON:String(substring))
                                            strSuggsn = ""
                                                    for ih in 0..<json.count {
                                                                let frame1 = CGRect(x: Int(buttonY1), y: iJ, width: 100, height: 30 )
                                                                buttonY1 = buttonY1  + frame1.width + 2
                                                                let button = UIButton(frame: frame1)
                                                                button.layer.cornerRadius = 5
                                                                button.setTitle(json[ih]["name"].stringValue, for: .normal)
                                                                button.layer.backgroundColor = (UIColor.darkGray.cgColor)
                                                       // button.layer.borderWidth  = 1
                                                        //button.layer.borderColor = #colorLiteral(red: 0.3769986629, green: 0.3747626841, blue: 0.3787207901, alpha: 1)
                                                                button.isUserInteractionEnabled = true
                                                                button.tag = Int(json[ih]["id"].stringValue)!
                                                             //   i = i  + 1
                                                                px = px + Int(d.frame.width)/2 - 30
                                                                buttons.append(button)
                                                                selDeslMdl.rowId.append(Int(String(cString: queryResultCol1!))!)
                                                                selDeslMdl.btnSuggsnId.append(Int(json[ih]["id"].stringValue)!)
                                                                selDeslMdl.selcnNam.append(json[ih]["name"].stringValue)
                                                                selDeslMdl.selcnSorNo.append(false)
                                                                button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
                                                                self.d.addSubview(button)
                                                                if ih == json.count - 1{
                                                                        strSuggsn = strSuggsn  + json[ih]["id"].stringValue  + ":"  +  json[ih]["name"].stringValue + "$"
                                                                }
                                                                    else {
                                                                         strSuggsn = strSuggsn  + json[ih]["id"].stringValue  + ":"  +  json[ih]["name"].stringValue  + ","
                                                                    }
                                                          }
                                                     
                                           
                                            }
                                        else { //suggsn is empty
                                           if (String(cString: queryResultCol2!)) == "boolean"{
                                                        strBln = "yes"
                                                        for ih in 0..<2 {
                                                                    let frame1 = CGRect(x: Int(buttonY1), y: iJ, width: 100, height: 30 )
                                                                    buttonY1 = buttonY1  + frame1.width + 2
                                                                    let button = UIButton(frame: frame1)
                                                                    button.layer.cornerRadius = 5
                                                                    button.setTitle(strBln , for: .normal)
                                                                    button.layer.backgroundColor = (UIColor.darkGray.cgColor)
                                                                    button.layer.borderWidth = 1
                                                                    button.layer.borderColor = (UIColor.gray.cgColor)
                                                           // button.layer.borderWidth  = 1
                                                            //button.layer.borderColor = #colorLiteral(red: 0.3769986629, green: 0.3747626841, blue: 0.3787207901, alpha: 1)
                                                                    button.isUserInteractionEnabled = true
                                                                    button.tag = indexz
                                                                 //   i = i  + 1
                                                                    px = px + Int(d.frame.width)/2 - 30
                                                                    buttons.append(button)
                                                                    selDeslMdl.rowId.append(Int(String(cString: queryResultCol1!))!)
                                                                    selDeslMdl.btnSuggsnId.append(indexz)
                                                                    selDeslMdl.selcnNam.append(strBln)
                                                                    selDeslMdl.selcnSorNo.append(false)
                                                                    button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
                                                                    self.d.addSubview(button)
                                                              indexz = indexz + 1
                                                              strBln = "no"
                                                        }
                                            }
                                            else if (String(cString: queryResultCol2!)) == "number" || (String(cString: queryResultCol2!)) == "text"{ //   suggestion is text
                                                            let frame1 = CGRect(x: Int(buttonY1), y: iJ, width: 300, height: 30 )
                                                            buttonY1 = buttonY1  + frame1.width + 2
                                                            let button = UITextField(frame: frame1)
                                                            button.layer.cornerRadius = 5
                                                            button.layer.backgroundColor = (UIColor.white.cgColor)
                                                            button.layer.borderWidth = 1
                                                            button.layer.borderColor = (UIColor.gray.cgColor)
                                                   // button.layer.borderWidth  = 1
                                                    //button.layer.borderColor = #colorLiteral(red: 0.3769986629, green: 0.3747626841, blue: 0.3787207901, alpha: 1)
                                                            button.isUserInteractionEnabled = true
                                                            button.tag = indexz
                                                            button.delegate  =  self
                                                         //   i = i  + 1
                                                            px = px + Int(d.frame.width)/2 - 30
                                                            txtFlds.append(button)
                                            
                                                            selDeslMdl.rowId.append(Int(String(cString: queryResultCol1!))!)
                                                            selDeslMdl.btnSuggsnId.append(indexz)
                                                            selDeslMdl.selcnNam.append("")
                                                            selDeslMdl.selcnSorNo.append(false)
                                                            button.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                                                             for: UIControl.Event.editingChanged)
                                                            self.d.addSubview(button)
                                                      indexz = indexz + 1
                                                      strBln = "no"
                                                
                                            }
                                        }
                                                //   suggestion

                                              chkLstModl.suggsn.append("")
                                              offsetg = offsetg + 95
                                              iJ = iJ + 95
                                             
                               }
                                
                                /*for qw in 0..<chkLstModl.Qustn.count {
                                    if qw == 0
                                    {
                                       chkLstModl.Qustn[0] = "How r u"
                                    }
                                    }
                                */
                                    }
                             sqlite3_finalize(queryStatement)
                             sqlite3_close(db)
                             db = nil
                        }
        }
       //
        self.d.contentSize = CGSize(width: 0, height: px)
        
        } //End ViewDidload
    func  imgSync(Tkn: String,imgFil:String,imgFDat:String)
    {
                // let test = String(closg.filter { !" \n\t\r".contains($0) })
       
         
                 let stringFields = """
                  {"name":"
                 """
            let stringFields1 = imgFil
            let stringFields2 = """
                             ","display_name":"
                            """
            let stringFields3 = imgFDat.trimmingCharacters(in: .whitespacesAndNewlines)
            let stringFields4 = """
             ","type":"binary","datas_fname":"
            """
            let stringFields5 = """
             ","res_model":"mro.order","ir_attachment_categ":"","res_id":
            """
            
            let stringFields6 = """
            ,"mimetype": "image/png","datas":"
            """
            
            let stringFields7 = """
            "}
            """

                 
            let  stringRole1 = "&values="
            let test = String(stringFields3.filter { !"\r\n\n\t\r".contains($0) })
            let varRole = "\(stringRole1)\(String(describing: stringFields))\(String(describing: stringFields1))\(String(describing: stringFields2))\(String(describing: stringFields1))\(String(describing: stringFields4))\(String(describing: stringFields1))\(String(describing: stringFields5))\(chsStrtMdl.idWO)\(String(describing: stringFields6))\(String(describing:test ))\(String(describing: stringFields7))"
              var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/create")!,timeoutInterval: Double.infinity)
                   let string1 = "Bearer "
                   let string2 = Tkn
                       var closg = ""
                   let combined2 = "\(string1) \(String(describing: string2))"
                   request.addValue(combined2, forHTTPHeaderField: "Authorization")
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
                          let title = jsonc["data"]
                          //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
                          if (title.count > 0){
                              for i in 0..<title.count {
                                  }
                              }
                          
                            }
                         catch let error as NSError {
                            print("Failed to load: \(error.localizedDescription)")
                         }
                         }
                            task1.resume()

                   
        }
    func  updteImgz(Tkn: String)
       {
        let idy = Int(chsStrtMdl.idWO)
                                      let stringFields1 = """
                                        {"start_date":"
                                        """
                                         let convertedDate = self.instanceOfUser.readStringData(key: "strtDte")
                                                                               let convertedDateEnd = self.instanceOfUser.readStringData(key: "endDte")
                                       
                                        let  stringFields2 = """
                                        ","mro_order_id":
                                        """
                                         let  stringFields3 = """
                                         ,"end_date":"
                                         """
                                       let  stringFields4 = """
                                           ","reason":"","latitude":"
                                           """
                                       let    offsetFields = """
                                       ","longitude":"
                                       """
                                    let    offsetFields1 = """
                                    "}
                                    """
        let    offsetFields2 = """
               ]
               """
            let  ids1 = "&ids=["
         let  stringRole5 = "&model=mro.timesheet"
        let  stringRole2 = "&values="
        let    stringFields = "\(String(describing:stringRole5))\(String(describing:stringRole2))\(stringFields1)\(String(describing:convertedDate))\(String(describing:stringFields2))\(idy)\(String(describing:stringFields3))\(String(describing:convertedDateEnd))\(String(describing: stringFields4))\(String(describing: lati))\(String(describing: offsetFields))\(String(describing: longi))\(String(describing: offsetFields1))\(String(describing: ids1))\(self.imgId)\(String(describing:offsetFields2))"
                                     let combinedOffset = "\(stringFields)"
                                                                    let varRole = "\(String(describing: combinedOffset))"
                                                                    print(varRole)
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
                                                                                print(jsonStr)
                                                                                   let nwFlds = """
                                                                                   "status": true
                                                                                   """
                                                                                   let varstts =  jsonStr?.contains("\(String(describing: nwFlds))") ?? false
                                                                                   print(varstts)
                                                                                   if varstts
                                                                                       {


                                                                                }

                                                                                   }
                                                                                   
                                                                               }

                                                                                 
                                                                          task1.resume()

                                                                          }
    func  updteImg(Tkn: String)
       {

        var start_date = ""
             var end_date = ""
            var latitude = ""
            var longitude = ""
        let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
           .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
           //opening the database
           if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
              print("There's error in opening the database")
           }
        else
        {
                                       let queryStatementString = "SELECT start_date,end_date,latitude,longitude FROM tbl_timesheet WHERE unq_id = ?  AND guid = ?;"
                                        var queryStatement: OpaquePointer?          // 1
        
                                        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                                            SQLITE_OK
                                         {
                                             sqlite3_bind_int(queryStatement, 1, (Int32(chsStrtMdl.idWO)))
                                             sqlite3_bind_text(queryStatement, 2, (self.instanceOfUser.readStringData(key: "gUid") as NSString).utf8String, -1, nil)
                                             while  sqlite3_step(queryStatement) == SQLITE_ROW {
                                                  start_date = String(cString: sqlite3_column_text(queryStatement, 0))
                                                       end_date = String(cString: sqlite3_column_text(queryStatement, 1))
                                                      latitude = String(cString: sqlite3_column_text(queryStatement, 2))
                                                      longitude = String(cString: sqlite3_column_text(queryStatement, 3))
                                              }
                                              }
                                         sqlite3_finalize(queryStatement)
                                         sqlite3_close(db)
                                         db = nil
               
        var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/create")!,timeoutInterval: Double.infinity)
        let string1 = "Bearer "
        let string2 = instanceOfUser.readStringData(key: "accessTokenz")
            var closg = ""
        let combined2 = "\(string1) \(String(describing: string2))"
        request.addValue(combined2, forHTTPHeaderField: "Authorization")

        let idy = Int(chsStrtMdl.idWO)
                                      let stringFields1 = """
                                        {"start_date":"
                                        """
                                        let convertedDate = self.instanceOfUser.readStringData(key: "strtDte")
                                        let convertedDateEnd = self.instanceOfUser.readStringData(key: "endDte")
            
                                        let lati = latitude
                                        let longi = longitude
                                        let  stringFields2 = """
                                        ","mro_order_id":
                                        """
                                         let  stringFields3 = """
                                         ,"end_date":"
                                         """
                                       let  stringFields4 = """
                                           ","reason":"","latitude":"
                                           """
                                       let    offsetFields = """
                                       ","longitude":"
                                       """
                                    let    offsetFields1 = """
                                    "}
                                    """
        
        let  stringRole2 = "&values="
        let    stringFields = "\(String(describing:stringRole2))\(stringFields1)\(String(describing:convertedDate))\(String(describing:stringFields2))\(idy)\(String(describing:stringFields3))\(String(describing:convertedDateEnd))\(String(describing: stringFields4))\(String(describing: lati))\(String(describing: offsetFields))\(String(describing: longi))\(String(describing: offsetFields1))"
                                    let combinedOffset = "\(stringFields)"
                                    let varRole = "\(String(describing: combinedOffset))"
                                    print(varRole)
                                       let postData = NSMutableData(data: "model=mro.timesheet".data(using: String.Encoding.utf8)!)
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
                                                            print("first")
                                                            print(jsonc)
                                                           // let title = jsonc["data"][0]["name"].stringValue
                                                           //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
                                                            self.imgId = jsonc["data"][0].int!
                                                            //self.updteImgz(Tkn:Tkn)
                                                             }
                                                          catch let error as NSError {
                                                             print("Failed to load: \(error.localizedDescription)")
                                                          }
                                                          }
                                                             task1.resume()

                                                    }
        }
    func  updteWstat(Tkn: String)
    {

                                let msgs = Int(chsStrtMdl.idWO)
                                let stringFields1 = """
                                  model=mro.order&values={"state":"done"}&ids=[
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
                               let    stringFields = "\(stringFields1)\(msgs)\(String(describing: stringFields2))"
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
     func  upLdtoServr(Tkn: String,chklstId: String,chklstTyp: String,chklstSuggsn: String )
     {
        let stringFields = """
            [
            """
        
            let msgs = Int(chklstId)
    
     
        let closg = """
        model=mro.order.check.list&ids=[
        """
        var  closg1 = ""
            var closg3 = ""
            var answr = ""

            let  stringRole2 = "&values="
            let  stringRole1 = "&ids="
            if chklstTyp == "boolean"
            {
                if chklstSuggsn == "yes"
                {
                    answr = "true"
                    }
                    else
                    {
                    answr = "false"
                }
                closg1 = """
                {"type":
                """
                closg3 = """
                }
                """
            }
            if chklstTyp == "suggestion" ||  chklstTyp == "text"
            {
                answr = chklstSuggsn
                closg1 = """
                {"value_text":"
                """
                closg3 = """
                "}
                """
            }
            if chklstTyp == "number"
            {
                answr = chklstSuggsn
                closg1 = """
                {"value_number":
                """
                closg3 = """
                }
                """
            }
        let fnlcl = """
        ]
        """
     let varRole = "\(closg)\(msgs!)\(fnlcl)\(stringRole2)\(closg1)\(answr)\(closg3)"
        
                                    let url = NSURL(string: "https://demo.helixsense.com/api/v2/write") //Remember to put ATS exception if the URL is not https
                                    let request = NSMutableURLRequest(url: url! as URL)
                                        let string1 = "Bearer "
                                          let string2 = Tkn
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
                     }

                       }
                task1.resume()

                }
    func getPhotoCnt() -> String {
                   // self.insertCategorySubcategory(Id: "26",Name: "Floor Drains",catId: "5",catName: "Plumbing-Common",priority: "1",slaTmr: "8")
                   var  strCount = ""
                   let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                   .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
                   //opening the database
                   if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                      print("There's error in opening the database")
                   }
                else
                    {
                        
                       let queryStatementString = "SELECT COUNT(*) AS total_count  FROM tbl_uploads WHERE  unq_id=? ;"
                       var queryStatement: OpaquePointer?
                       // 1
                       if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                           SQLITE_OK {
                                //5F1!!!
                                   // 2

                         sqlite3_bind_int(queryStatement, 1, (Int32(chsStrtMdl.idWO)))
                                 // 2
                                 if sqlite3_step(queryStatement) == SQLITE_ROW {
                                                strCount =    String(cString: sqlite3_column_text(queryStatement, 0))
                                         } else {
                                           print("\nUPDATE statement is not prepared")
                                         }
                               }

                        sqlite3_finalize(queryStatement)
                        sqlite3_close(db)
                        db = nil
                   }
            return (strCount)
        }
    func fetchCommnts(Tkn: String)
     {
         let msgs = self.instanceOfUser.readStringData(key: "MsgIds")
     var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/iread")!,timeoutInterval: Double.infinity)
     let string1 = "Bearer "
     let string2 = Tkn
         var closg = ""
     let combined2 = "\(string1) \(String(describing: string2))"
     request.addValue(combined2, forHTTPHeaderField: "Authorization")
     let stringFields = """
     ]
     """
    
      closg = """
     ["body","date","author_id","compute_body"]
     """
         
     let  stringRole1 = "&ids="
     let varRole = "\(stringRole1)\(msgs)"
     let stringDomain1 = "&fields="
     let varDomain = "\(stringDomain1)\(String(describing: closg))"
     let postData = NSMutableData(data: "model=mail.message".data(using: String.Encoding.utf8)!)
     postData.append(varRole.data(using: String.Encoding.utf8)!)
     postData.append(varDomain.data(using: String.Encoding.utf8)!)
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
                                 OperationQueue.main.addOperation {
                                 self.Commen.font =  UIFont(name: "Helvetica Neue Bold", size: 16)
                                     
                                        self.Commen.text =    "(" +  "\(title.count)"  + ")"
                             }
                        
                        for ih in 0..<title.count{
                                if jsonc["data"][ih]["body"].stringValue != ""
                                {
                                  let htmlStringData = jsonc["data"][ih]["body"].stringValue
                                   let withoutHTMLString = htmlStringData.htmlStripped
                                       comntMdl.lblState.append(withoutHTMLString)
                                 }
                               else{
                                let htmlStringData = jsonc["data"][ih]["compute_body"].stringValue
                                let withoutHTMLString = htmlStringData.htmlStripped
                               
                                    comntMdl.lblState.append(withoutHTMLString)
                            }
                                comntMdl.lblDt.append(jsonc["data"][ih]["date"].stringValue)
                                comntMdl.lblNam.append(jsonc["data"][ih]["author_id"][1].stringValue)
                        }
                       }
                }
             catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
             }
             }
                task1.resume()

       }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
  
    @objc func textFieldDidChange(_ sender: UIButton) {
            //       let alert = UIAlertController(title: "Subscribed!", message: "Subscribed to ", preferredStyle: .alert)
             //      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
             //      alert.addAction(okAction)
            //       self.present(alert, animated: true, completion: nil)
        
        txtFlds.forEach { (button) in
             if button == sender {
                
                if(button.text != ""){
                   for ih in 0..<selDeslMdl.rowId.count{
                     if sender.tag == selDeslMdl.btnSuggsnId[ih] {
                        selDeslMdl.selcnSorNo[ih] = true
                            for ab in 0..<chkLstModl.chkLstId.count{
                                    if Int(chkLstModl.chkLstId[ab]) == selDeslMdl.rowId[ih] {
                                        chkLstModl.selPhto[ab] = true
                                    }
                                }
                        //sender.setTitleColor(UIColor.white, for: .selected)
                        button.layer.backgroundColor = (UIColor.white.cgColor)
                        //print(sender.titleLabel?.text)
                        }
                        }
                    }
                else
                {
                    for gk in 0..<selDeslMdl.rowId.count{
                        if sender.tag == selDeslMdl.btnSuggsnId[gk] {
                            selDeslMdl.selcnSorNo[gk] = false
                            for df in 0..<chkLstModl.chkLstId.count{
                                if Int(chkLstModl.chkLstId[df]) == selDeslMdl.rowId[gk] {
                                    chkLstModl.selPhto[df] = false
                                }
                            }
                           // sender.setTitleColor(UIColor.white, for: .selected)
                           button.layer.backgroundColor = (UIColor.red.cgColor)
                            }
                   }
                }
             }

          //   button.addTarget(self, action: #selector(resignFirstResponder), for: .editingDidEndOnExit)
          }
        
    }
        @objc func buttonAction(_ sender: UIButton) {
                //       let alert = UIAlertController(title: "Subscribed!", message: "Subscribed to ", preferredStyle: .alert)
                 //      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                 //      alert.addAction(okAction)
                //       self.present(alert, animated: true, completion: nil)
            
            buttons.forEach { (button) in
                 if button == sender {
                     button.isSelected = !button.isSelected
                    if(button.isSelected){
                       for ih in 0..<selDeslMdl.rowId.count{
                         if sender.tag == selDeslMdl.btnSuggsnId[ih] {
                            selDeslMdl.selcnSorNo[ih] = true
                                for ab in 0..<chkLstModl.chkLstId.count{
                                        if Int(chkLstModl.chkLstId[ab]) == selDeslMdl.rowId[ih] {
                                            chkLstModl.selPhto[ab] = true
                                        }
                                    }
                            sender.setTitleColor(UIColor.white, for: .selected)
                            button.layer.backgroundColor = (UIColor.red.cgColor)
                            //print(sender.titleLabel?.text)
                            }
                            }
                        }
                    else
                    {
                        for gk in 0..<selDeslMdl.rowId.count{
                            if sender.tag == selDeslMdl.btnSuggsnId[gk] {
                                selDeslMdl.selcnSorNo[gk] = false
                                for df in 0..<chkLstModl.chkLstId.count{
                                    if Int(chkLstModl.chkLstId[df]) == selDeslMdl.rowId[gk] {
                                        chkLstModl.selPhto[df] = false
                                    }
                                }
                                sender.setTitleColor(UIColor.white, for: .selected)
                                button.layer.backgroundColor = (UIColor.darkGray.cgColor)
                                }
                       }
                    }
                 }
              }
        }
    @objc func scrollButtonAction(_ sender: UIButton) {
           print("Hello \(sender.tag) is Selected")
       }
           @objc func buttonAction1(_ sender: UIButton) {
                  buttons1.forEach { (button) in
                       if button == sender {
                           button.isSelected = true
                          button.layer.backgroundColor = (UIColor.green.cgColor)
                          print(sender.titleLabel?.text)
                       } else {
                            button.isSelected = false
                            button.layer.backgroundColor = (UIColor.gray.cgColor)
                       }
                    }
              }
     @objc func phtoAction(_ sender: UIButton!) {
        buttons1.forEach { (button) in
             if button == sender {
                   for rt in 0..<chkLstModl.chkLstId.count{
                     if sender.tag == Int(chkLstModl.chkLstId[rt]){
                        if chkLstModl.selPhto[rt]{
                            //allow to take photo if photos r there(if chkLst id exsts in tbl_uploads ) display photos with + buttn (pop up camera n gallery),else take phto
                            self.instanceOfUser.writeAnyData(key: "chkLstId", value: Int(chkLstModl.chkLstId[rt]))
                              self.instanceOfUser.writeAnyData(key: "WOphtochkLst", value:"phtochkLst" )
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
                        else
                        {
                            let alert = UIAlertController(title: "Alert!", message: "Please Answer the questions ", preferredStyle: .alert)
                             let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                              alert.addAction(okAction)
                             self.present(alert, animated: true, completion: nil)
                        }
                        }
                        }
             }
          }
    }
    func ftchphtoFromdb()
    {
               // self.insertCategorySubcategory(Id: "26",Name: "Floor Drains",catId: "5",catName: "Plumbing-Common",priority: "1",slaTmr: "8")
               var  strCount = ""
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
                {
                  let queryStatementString = "SELECT file_name,file_data FROM tbl_uploads WHERE  unq_id=? ;"
                  var queryStatement: OpaquePointer?
                  // 1
                  if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                    SQLITE_OK {
                    //5F1!!!
                    // 2
                    sqlite3_bind_int(queryStatement, 1, (Int32(chsStrtMdl.idWO)))
                    // 2
                    if sqlite3_step(queryStatement) == SQLITE_ROW {
                        while  sqlite3_step(queryStatement) == SQLITE_ROW {
                            let filename = String(cString: sqlite3_column_text(queryStatement, 0))
                            let filedta = String(cString: sqlite3_column_text(queryStatement, 1))
                            imgsync.append(ImgSync(imgFil: filename, imgDta: filedta))
                            
                        }
                    }
                    
                    sqlite3_finalize(queryStatement)
                    sqlite3_close(db)
                    db = nil
                    // #warning Incomplete implementation, return the number of items
                   
                }
                }
    }
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isHiddenHairline = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isHiddenHairline = false
    }
    private func tagBasedTextField(_ textField: UITextField) {

            textField.resignFirstResponder()
    }
   
    }
