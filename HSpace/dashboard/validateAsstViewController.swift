//
//  validateAsstViewController.swift
//  HelixSense
//
//  Created by DEEBA on 25.06.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import  SwiftyJSON
import DropDown
import SQLite3

@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
class validateAsstViewController: UIViewController {
    var selctdLcn: String!
    var selctdPath: String!
    var selctdId: String!
    var validnStts = ""
    var db:OpaquePointer? = nil
    @IBAction func btnGoBck() {
        self.dismiss(animated: true, completion: nil)
    }
    let instanceOfUser = readWrite()
     
    @IBOutlet weak var shrtCde: FloatingLabelInput!
    @IBOutlet weak var lblLcn: FloatingLabelInput!
    @IBOutlet weak var btnValidUpdte: UIButton!
    
    @IBOutlet weak var lblTtl: UILabel!
    @IBOutlet weak var txtFldMTeam: FloatingLabelInput!
    @IBOutlet weak var txtFldSpacCategry: FloatingLabelInput!
    @IBOutlet weak var txtFldParentSpc: FloatingLabelInput!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rootLocationTitle: UILabel!
    @IBOutlet weak var lastLocationTitle: UILabel!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var issueTypeLabel: UILabel!
    @IBOutlet weak var subcategoryTitle: UILabel!
    @IBOutlet weak var subcategoryTimeLabel: UILabel!
    @IBOutlet weak var subcategoryPriorityLabel: UILabel!
    @IBOutlet weak var subcategoryPriorityColorView: DesignableView!
    @IBOutlet weak var pickImageButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewPlaceholderLabel: UILabel!
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet var collectionBottomConstraint: NSLayoutConstraint!
    var parentSpcArray: [String] = []
    var spcCategryArray: [String] = []
    var mTeamArray: [String] = []
    var ticketData: TicketData!
    
    var images = [UIImage]()
    @IBAction func btnMdl(_ sender: UIButton) {
        
        if lblLcn.text == "" || shrtCde.text == ""  || txtFldMTeam.text == ""  || txtFldSpacCategry.text == "" || txtFldParentSpc.text == ""
        {
            showToast(message: "Please fill in the fields " )
        }
        else
        {
            if  btnValidUpdte.titleLabel?.text != "VALIDATE"
            {//popup for confirmation
                let storyBoard: UIStoryboard = UIStoryboard(name: "MainSdeStoryboard", bundle: nil)
                let ValidationVC = storyBoard.instantiateViewController(withIdentifier: "ValidationViewController") as! ValidationViewController
                               ValidationVC.userName = self.instanceOfUser.readStringData(key: "employeeNamez")
                               ValidationVC.spaceName = self.lblLcn.text!
                               ValidationVC.shrtCod = self.shrtCde.text!
                               ValidationVC.prntSpcName = self.txtFldParentSpc.text!
                               ValidationVC.prntCateg = self.txtFldSpacCategry.text!
                               ValidationVC.mTeam = self.txtFldMTeam.text!
                               ValidationVC.onSuccess = {
                                   self.navigationController?.popViewController(animated: true)
                               }
                               self.present(ValidationVC, animated: false)
            }
            else
                {
                    self.EditLcnwriteAPI(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"))
                    sleep(1)
                    writtoDB()
                    OperationQueue.main.addOperation {
                         let appDelegate = UIApplication.shared.delegate as! AppDelegate
                         appDelegate.loadRootViewController()
                     }
                }
            
        }
         }
    //instanceOfUser.readStringData(key: "lcnId")
   func writtoDB() {
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
                {
                    // let    stringFields = "\(String(describing:stringRole5))\(String(describing:stringRole2))\(String(describing:stringFields1))\(String(describing:lblLcn.text!))\(String(describing:stringFields2))\(String(describing:shrtCde.text!))\(String(describing:stringFields3))\(String(describing: prntSpacVldteModl.spcId[find(value: self.txtFldParentSpc.text!, in: prntSpacVldteModl.spcNam)!]))\(String(describing:stringFields4))\(String(describing: ctgrySpacVldteModl.ctgId[find(value: self.txtFldSpacCategry.text!, in: ctgrySpacVldteModl.ctgNam)!]))\(String(describing:stringFields5))\(String(describing: tmNamesModl.TmId[find(value: self.txtFldMTeam.text!, in: tmNamesModl.TmNam)!]))\(String(describing:stringFields6))\(String(describing:validnStts))\(String(describing:stringFields7))\(self.instanceOfUser.readIntData(key: "uIdz"))\(String(describing:stringFields8))\(String(describing:convertedDate))\(String(describing:stringFields9))\(String(describing:""))\(String(describing:stringFields10))"
                    let queryStatementString = "SELECT * FROM tbl_space_details WHERE space_id=? ;"
                    var queryStatement: OpaquePointer?
                    // 1
                    if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                        SQLITE_OK {
                        // 5G1
                     sqlite3_bind_int(queryStatement, 1, (Int32(instanceOfUser.readStringData(key: "lcnId"))!))
                      // 2
                      if sqlite3_step(queryStatement) == SQLITE_ROW {
                         
                      let updateStatementString = "UPDATE tbl_space_details SET space_name = ?,space_short_code = ?, space_parent_id = ?,space_parent_name = ?,space_maintenance_team_id = ?,space_maintenance_team = ?, space_asset_category_id = ?,space_asset_category_name = ? WHERE space_id=? ;"
                      var updateStatement: OpaquePointer?
                      if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
                          SQLITE_OK {
                           //    let catNam: String = "hello"
                        print(self.txtFldParentSpc.text!)
                        print(self.txtFldMTeam.text!)
                        print(self.txtFldSpacCategry.text!)
                        sqlite3_bind_text(updateStatement, 1,(String(self.lblLcn.text!) as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement, 2,(String(self.shrtCde.text!) as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement, 3, (String(prntSpacVldteModl.spcId[find(value: self.txtFldParentSpc.text!, in: prntSpacVldteModl.spcNam)!]) as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement, 4, (String(self.txtFldParentSpc.text!) as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement, 5,(String(tmNamesModl.TmId[find(value: self.txtFldMTeam.text!, in: tmNamesModl.TmNam)!]) as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement, 6, (String(self.txtFldMTeam.text!) as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(updateStatement,7, (String(ctgrySpacVldteModl.ctgId[find(value: self.txtFldSpacCategry.text!, in: ctgrySpacVldteModl.ctgNam)!]) as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(updateStatement, 8,(String(self.txtFldSpacCategry.text!) as NSString).utf8String, -1, nil)
                         sqlite3_bind_int(updateStatement, 9, (Int32(instanceOfUser.readStringData(key: "lcnId"))!))
                        if sqlite3_step(updateStatement) == SQLITE_DONE {
                         //print("\nSuccessfully updated row.")
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
      func poplteCategry(Tkn: String)
      {
      var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/isearch_read")!,timeoutInterval: Double.infinity)
      let string1 = "Bearer "
      let string2 = Tkn
          var closg = ""
      let combined2 = "\(string1) \(String(describing: string2))"
      request.addValue(combined2, forHTTPHeaderField: "Authorization")
      let stringFields = """
      ["display_name"]
      """
    
      let stringDomain1 = "&fields="
      let varDomain = "\(stringDomain1)\(String(describing: stringFields))"
      let postData = NSMutableData(data: "model=mro.asset.category".data(using: String.Encoding.utf8)!)
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
               let title = jsonc["data"]
               //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
               if (title.count > 0){
                   for i in 0..<title.count {
                    ctgrySpacVldteModl.ctgNam.append(jsonc["data"][i]["display_name"].stringValue)
                    ctgrySpacVldteModl.ctgId.append(jsonc["data"][i]["id"].int!)
                       }
                   }
               
                 }
              catch let error as NSError {
                 print("Failed to load: \(error.localizedDescription)")
              }
              }
                 task1.resume()

        }
      func ConstrctDta(Tkn: String)
          
      {
      var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/isearch_read")!,timeoutInterval: Double.infinity)
      let string1 = "Bearer "
      let string2 = Tkn
          var closg = ""
      let combined2 = "\(string1) \(String(describing: string2))"
      request.addValue(combined2, forHTTPHeaderField: "Authorization")
      let stringFields = """
      []
      """
    
       closg = """
      ["name"]
      """
        
          
      let  stringRole1 = "&domain="
      let varRole = "\(stringRole1)\(String(describing: stringFields))"
      let stringDomain1 = "&fields="
      let varDomain = "\(stringDomain1)\(String(describing: closg))"
      let postData = NSMutableData(data: "model=mro.maintenance.team".data(using: String.Encoding.utf8)!)
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
               let title = jsonc["data"]
               //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
               if (title.count > 0){
                   for i in 0..<title.count {
                      tmNamesModl.TmNam.append(jsonc["data"][i]["name"].stringValue)
                    tmNamesModl.TmId.append(jsonc["data"][i]["id"].int!)
                       }
                   }
               
                 }
              catch let error as NSError {
                 print("Failed to load: \(error.localizedDescription)")
              }
              }
                 task1.resume()

        }
    func poplteLcn(Tkn: String) {
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
                {
                    
                  let queryStatementString = "SELECT DISTINCT space_parent_id,space_parent_name FROM tbl_space_details WHERE space_parent_id != ? AND space_name != ? ;"
                   var queryStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                       SQLITE_OK {
                            //5F1!!!
                               // 2
                     //  sqlite3_bind_text(queryStatement, 1,(qryFld  as NSString).utf8String, -1, nil)
                    let qry = ""
                    sqlite3_bind_text(queryStatement, 1,(qry  as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(queryStatement, 2,(qry  as NSString).utf8String, -1, nil)
                             // 2
                             while  sqlite3_step(queryStatement) == SQLITE_ROW {
                                prntSpacVldteModl.spcId.append(Int(sqlite3_column_int(queryStatement, 0)))
                                prntSpacVldteModl.spcNam.append(String(cString: sqlite3_column_text(queryStatement, 1)))
                                     }
                      
                           }

                    sqlite3_finalize(queryStatement)
                    sqlite3_close(db)
                    db = nil
               }
    }
    func find(value searchValue: String, in array: [String]) -> Int?
    {
        for (index, value) in array.enumerated()
        {
            if value == searchValue {
                return index
            }
        }

        return nil
    }
    func EditLcnwriteAPI(Tkn: String) {
        var tmId:Int=0
        var prntId:Int=0
        var catgrId:Int=0
      //  {"space_name":"F5_Passenger Lift Lobby","name":"F5_PLL","parent_id":"4025","asset_category_id":"63","maintenance_team_id":"308","validation_status":"Valid","validated_by": 852,"validated_on":"2020-07-04 06:09:09","comment":""}ids -> [1057]model -> mro.equipment.location self.instanceOfUser.writeAnyData(key: "uIdz", value: title["uid"].int!)(instanceOfUser.readStringData(key: "lcnId"))


    let idy = selectdEqp.id
                                  let stringFields1 = """
                                    {"space_name":"
                                    """
                                  let stringFields2 = """
                                  ","name":"
                                  """
                                  let stringFields3 = """
                                  ","parent_id":"
                                  """
                                  let stringFields4 = """
                                  ","asset_category_id":"
                                  """
                                  let stringFields5 = """
                                  ","maintenance_team_id":
                                  """
                                  let stringFields6 = """
                                  ,"validation_status":"
                                  """
                                  let stringFields7 = """
                                  ","validated_by":
                                  """
                                  let stringFields8 = """
                                  ,"validated_on":"
                                  """
                                  let stringFields9 = """
                                  ","comment":"
                                  """
                                  let stringFields10 = """
                                  "}
                                  """
                                   let combined = ""
                                   
                                let    offsetFields1 = """
                                "}
                                """
    let    offsetFields2 = """
           ]
           """
        let  ids1 = "&ids=["
     let  stringRole5 = "&model=mro.equipment"
        let currentDate = NSDate()
                                  let dateFormatter = DateFormatter()
                                  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                  let convertedDate = dateFormatter.string(from: currentDate as Date)
        print( prntSpacVldteModl.spcId[find(value: self.txtFldParentSpc.text!, in: prntSpacVldteModl.spcNam)!])
    let  stringRole2 = "&values="
        let    stringFields = "\(String(describing:stringRole5))\(String(describing:stringRole2))\(String(describing:stringFields1))\(String(describing:lblLcn.text!))\(String(describing:stringFields2))\(String(describing:shrtCde.text!))\(String(describing:stringFields3))\(String(describing: prntSpacVldteModl.spcId[find(value: self.txtFldParentSpc.text!, in: prntSpacVldteModl.spcNam)!]))\(String(describing:stringFields4))\(String(describing: ctgrySpacVldteModl.ctgId[find(value: self.txtFldSpacCategry.text!, in: ctgrySpacVldteModl.ctgNam)!]))\(String(describing:stringFields5))\(String(describing: tmNamesModl.TmId[find(value: self.txtFldMTeam.text!, in: tmNamesModl.TmNam)!]))\(String(describing:stringFields10))"
                                 let combinedOffset = "\(stringFields)"
                                                                let varRole = "\(String(describing: combinedOffset))"
                                                                print(varRole)
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
                                                                           // print(jsonStr)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selctdLcn!)
        print(selctdPath!)
        print(selctdId!)
        let disNam = fndDisNam(selLocn: selctdLcn!)
        instanceOfUser.writeAnyData(key: "lcnId", value: disNam.components(separatedBy: ",")[0])
        instanceOfUser.writeAnyData(key: "LcnParent", value: selctdLcn! as Any)
        instanceOfUser.writeAnyData(key: "selLocn", value: disNam.components(separatedBy: ",")[1])
        instanceOfUser.writeAnyData(key: "selLocnId", value:  disNam.components(separatedBy: ",")[0])
        instanceOfUser.writeAnyData(key: "lcnSel", value: disNam.components(separatedBy: ",")[1])
        lblTtl.text = self.instanceOfUser.readStringData(key:  "CompNamez") +  " -" +  " Space"
        valid_invalidAPI(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
        prntSpacVldteModl.spcId.removeAll()
        prntSpacVldteModl.spcNam.removeAll()
        ctgrySpacVldteModl.ctgNam.removeAll()
        ctgrySpacVldteModl.ctgId.removeAll()
       tmNamesModl.TmNam.removeAll()
       tmNamesModl.TmId.removeAll()
        ConstrctDta(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
        poplteLcn(Tkn: self.instanceOfUser.readStringData(key: "accessTokenz"))
        poplteCategry(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
        lblLcn.text = instanceOfUser.readStringData(key: "LcnParent")
        shrtCde.text  =  instanceOfUser.readStringData(key: "lcnShrtcde")
        sleep(1)
        setupUI()
       setBorder(of: txtFldParentSpc)
        txtFldParentSpc.text   =
        instanceOfUser.readStringData(key: "lcnPrntName")
        txtFldSpacCategry.text   =
        instanceOfUser.readStringData(key: "spcCtrgNam")
        txtFldMTeam.text   =
        instanceOfUser.readStringData(key: "spcMTmNam")
       setDropDown(in: txtFldParentSpc, dataSource: prntSpacVldteModl.spcNam)
       setBorder(of: txtFldSpacCategry)
       setDropDown(in: txtFldSpacCategry, dataSource: ctgrySpacVldteModl.ctgNam)
       setBorder(of: txtFldMTeam)
       setDropDown(in: txtFldMTeam, dataSource: tmNamesModl.TmNam)
        if validnStts == "Valid"
        {
            btnValidUpdte.setTitle("UPDATE", for: .normal)
        }
        else
        {
            btnValidUpdte.setTitle("VALIDATE", for: .normal)
        }
    }
    func fndDisNam(selLocn: String) -> String
    {
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
         var spacdisNam = ""
         var spcId =  0
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
                {
                  let queryStatementString = "SELECT space_id,space_display_name,space_parent_id,space_short_code,space_parent_name,space_asset_category_id,space_maintenance_team_id,space_maintenance_team,space_asset_category_name  FROM tbl_space_details WHERE space_name = ?  ORDER BY space_seqid ASC ;"
                   var queryStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                       SQLITE_OK {
                            //5F1!!!
                               // 2
                      sqlite3_bind_text(queryStatement, 1,(selLocn  as NSString).utf8String, -1, nil)
                    // sqlite3_bind_int(queryStatement, 1, (Int32(chsStrtMdl.idWO)))
                             // 2
                             while  sqlite3_step(queryStatement) == SQLITE_ROW {
                                     spcId  = Int(sqlite3_column_int(queryStatement, 0))
                                     spacdisNam = String(cString: sqlite3_column_text(queryStatement, 1))
                                     spacdisNam = String(sqlite3_column_int(queryStatement, 0)) + "," + spacdisNam
                                     instanceOfUser.writeAnyData(key: "lcnPrntId", value: String(cString: sqlite3_column_text(queryStatement, 2)))
                                     instanceOfUser.writeAnyData(key: "lcnShrtcde", value: String(cString: sqlite3_column_text(queryStatement, 3)))
                                     instanceOfUser.writeAnyData(key: "lcnPrntName", value: String(cString: sqlite3_column_text(queryStatement, 4)))
                                     instanceOfUser.writeAnyData(key: "spcCtrgId", value: String(cString: sqlite3_column_text(queryStatement, 5)))
                                     instanceOfUser.writeAnyData(key: "spcMTmId", value: String(cString: sqlite3_column_text(queryStatement, 6)))
                                     instanceOfUser.writeAnyData(key: "spcMTmNam", value: String(cString: sqlite3_column_text(queryStatement, 7)))
                                     instanceOfUser.writeAnyData(key: "spcCtrgNam", value: String(cString: sqlite3_column_text(queryStatement, 8)))
                                
                                     }
                      
                           }

                    sqlite3_finalize(queryStatement)
                    sqlite3_close(db)
                    db = nil
               }
        return spacdisNam
    }
    func setupUI() {
        setBorder(of: txtFldSpacCategry)
        setBorder(of: txtFldParentSpc)
        setBorder(of: txtFldMTeam)
        setDropDown(in: txtFldSpacCategry, dataSource:  categryModl.categryNam)
        setDropDown(in: txtFldParentSpc, dataSource: lcnModl.lcnNam)
        setDropDown(in: txtFldMTeam, dataSource: tmNamesModl.TmNam)
    }
    func valid_invalidAPI(Tkn: String) {
      var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/iread")!,timeoutInterval: Double.infinity)
      let string1 = "Bearer "
      let string2 = Tkn
          var closg = ""
      let combined2 = "\(string1) \(String(describing: string2))"
      request.addValue(combined2, forHTTPHeaderField: "Authorization")
      let stringFields = """
      ["validation_status"]
      """
    
       closg = """
      [
      """
      let  closg1 = """
        ]
        """
      let  stringRole1 = "&ids="
      let varRole = "\(stringRole1)\(String(describing: closg))\(instanceOfUser.readStringData(key: "lcnId"))\(String(describing: closg1))"
      let stringDomain1 = "&fields="
      let varDomain = "\(stringDomain1)\(String(describing: stringFields))"
      let postData = NSMutableData(data: "model=mro.equipment.location".data(using: String.Encoding.utf8)!)
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
               let title = jsonc["data"]
               //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
               if (title.count > 0){
                self.validnStts = title[0]["validation_status"].stringValue
                   }
               
                 }
              catch let error as NSError {
                 print("Failed to load: \(error.localizedDescription)")
              }
              }
                 task1.resume()

        }
    func setBorder(of tf: FloatingLabelInput) {
        tf.canShowBorder = true
        tf.borderColor = .darkGray
        tf.dtborderStyle = .rounded
        tf.paddingYFloatLabel = -7
    }
    func setTrailingView(in tf: FloatingLabelInput, image: UIImage?, tintColor: UIColor? = nil) {
        tf.rightViewMode = .always
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: tf.frame.height))
        leftView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.center = leftView.center
        if let color = tintColor {
            imageView.tintColor = color
        } else {
            imageView.tintColor = .black
        }
        tf.rightView = leftView
    }
    func setDropDown(in tf: FloatingLabelInput, dataSource: [String] = ["1", "2", "3"]) {
        setTrailingView(in: tf, image: UIImage(systemName: "chevron.down"), tintColor: .gray)
        
        let dropDown = DropDown()
        dropDown.dataSource = dataSource
        dropDown.backgroundColor = UIColor.white
        dropDown.anchorView = tf
        
        tf.addGestureRecognizer(GestureRecognizerWithClosure {
            dropDown.show()
        })
        
        dropDown.selectionAction = { (index: Int, item: String) in
            dropDown.hide()
            tf.text = item
        }
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIApplication.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset.bottom = frame.height
        
        let bottomPoint = textView.frame.origin.y + textView.frame.height + 20
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset.y += frame.height - bottomPoint
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset.bottom = 0
        }
    }
    func poplteSpcCategry(Tkn: String) {
        //https://demo.helixsense.com/api/v2/isearch_read?model=mro.asset.category&fields=["display_name"]
        let stringFields = """
        &fields=["display_name"]
        """
    var request = URLRequest(url: URL(string:"https://demo.helixsense.com/api/v2/isearch_read")!,timeoutInterval: Double.infinity)
    let string1 = "Bearer "
    let string2 = Tkn
    let combined2 = "\(string1) \(String(describing: string2))"
    request.addValue(combined2, forHTTPHeaderField: "Authorization")
    let varRole = "\(String(describing: stringFields))"
        print(varRole)
    let postData = NSMutableData(data: "model=mro.asset.category".data(using: String.Encoding.utf8)!)
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
                                    for ih in 0..<title.count{
                                        print(jsonc["data"][ih]["display_name"])
                                        }
                                    }
              }
             
            catch let error as NSError {
               print("Failed to load: \(error.localizedDescription)")
            }
            }
               task1.resume()

      }
    func attachPhoto(_ sourceType: UIImagePickerController.SourceType) {
       // resignResponder()
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
   /* @IBAction func submit() {
        navigationController?.popToRootViewController(animated: true)
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination = segue.destination as? PickSourceViewController {
            destination.completion = { [weak self] sourceType in
                self?.attachPhoto(sourceType)
            }
        }
        
        if let destination = segue.destination as? PickIssueTypeViewController {
            destination.completion = { [weak self] issue in
                self?.issueTypeLabel.text = issue
            }
        }
        
        if let destination = segue.destination as? SelectCategoryViewController {
            destination.completion = { [weak self] category in
                self?.ticketData.category = category
                self?.categoryTitle.text = category.name
                self?.navigationController?.popToViewController(self!, animated: true)
            }
        }
        
        if let destination = segue.destination as? SelectSubcategoryViewController {
            destination.ticketData = ticketData
            destination.completion = { [weak self] subcategory in
                self?.ticketData.subcategory = subcategory
                self?.subcategoryTitle.text = subcategory.name
                self?.subcategoryTimeLabel.text = subcategory.formattedTime
                self?.subcategoryPriorityLabel.text = subcategory.priority.title
                self?.subcategoryPriorityColorView.backgroundColor = subcategory.priority.color
                self?.navigationController?.popToViewController(self!, animated: true)
            }
        }
    }
}

extension validateAsstViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer { picker.dismiss(animated: true, completion: nil) }
        guard let pickedImage = info[.originalImage] as? UIImage else { return }
        images.append(pickedImage)
        reloadCollection()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension validateAsstViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textViewPlaceholderLabel.isHidden = !textView.text.isEmpty
    }
}

extension validateAsstViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ImageCollectionCell.dequeue(from: collectionView, for: indexPath)
        cell.imageView.image = images[indexPath.row]
        cell.deleteCompletion = { [weak self] in
            self?.images.remove(at: indexPath.row)
            self?.reloadCollection()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 86, height: 92)
    }
    
    func reloadCollection() {
        imagesCollectionView.isHidden = images.isEmpty
        collectionBottomConstraint.isActive = !images.isEmpty
        imagesCollectionView.reloadData()
        view.layoutIfNeeded()
    }
}

