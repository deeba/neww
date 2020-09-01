//
//  ValidationViewController.swift
//  HelixSense
//
//  Created by DEEBA on 06.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
//import IQKeyboardManagerSwift
import SQLite3

class ValidationViewController: UIViewController {
    var db:OpaquePointer? = nil
    let instanceOfUser = readWrite()
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var sgmtCtrl: UISegmentedControl!
 //   @IBOutlet weak var commentsTextView: IQTextView!
    var shrtCod: String!
    var userName: String!
    var prntSpcName: String!
    var prntCateg: String!
    var mTeam: String!
    var spaceName: String!
    var onSuccess: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "I, " +  userName + " validate " + spaceName + " at "  + self.instanceOfUser.readStringData(key: "CompNamez")  //String(format: "I, ", userName ?? "", self.instanceOfUser.readStringData(key: "CompNamez") ?? "", spaceName ?? "")
    }
    
    @IBAction func onClickCancel() {
        self.dismiss(animated: true)
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
        print( prntSpacVldteModl.spcId[find(value: self.prntSpcName!, in: prntSpacVldteModl.spcNam)!])
    let  stringRole2 = "&values="
        let    stringFields = "\(String(describing:stringRole5))\(String(describing:stringRole2))\(String(describing:stringFields1))\(String(describing:spaceName!))\(String(describing:stringFields2))\(String(describing:shrtCod!))\(String(describing:stringFields3))\(String(describing: prntSpacVldteModl.spcId[find(value: self.prntSpcName!, in: prntSpacVldteModl.spcNam)!]))\(String(describing:stringFields4))\(String(describing: ctgrySpacVldteModl.ctgId[find(value: self.prntCateg!, in: ctgrySpacVldteModl.ctgNam)!]))\(String(describing:stringFields5))\(String(describing: tmNamesModl.TmId[find(value: self.mTeam!, in: tmNamesModl.TmNam)!]))\(String(describing:stringFields6))\(String(describing:"Valid"))\(String(describing:stringFields7))\(self.instanceOfUser.readIntData(key: "uIdz"))\(String(describing:stringFields8))\(String(describing:convertedDate))\(String(describing:stringFields9))\(String(describing: stringFields8))\(String(describing:stringFields10))"
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
    @IBAction func onClickAck() {
        if sgmtCtrl.selectedSegmentIndex == 1 {
            Alert.show("", "comments are mandatory if INVALID selected")
            return
        }
        //call the write API
        self.EditLcnwriteAPI(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"))
        sleep(1)
        writtoDB()
                       OperationQueue.main.addOperation {
                           let storyBoard: UIStoryboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                                                                               let newViewController = storyBoard.instantiateViewController(withIdentifier: "cvdDash") as! cvdDashbrdViewController
                                                                               self.present(newViewController, animated: true, completion: nil)
                                                         
                        }
    }
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
                         print(self.prntSpcName!)
                         print(self.mTeam!)
                         print(self.prntCateg!)
                         sqlite3_bind_text(updateStatement, 1,(String(self.prntSpcName!) as NSString).utf8String, -1, nil)
                          sqlite3_bind_text(updateStatement, 2,(String(self.shrtCod!) as NSString).utf8String, -1, nil)
                          sqlite3_bind_text(updateStatement, 3, (String(prntSpacVldteModl.spcId[find(value: self.prntSpcName!, in: prntSpacVldteModl.spcNam)!]) as NSString).utf8String, -1, nil)
                          sqlite3_bind_text(updateStatement, 4, (String(self.prntSpcName!) as NSString).utf8String, -1, nil)
                          sqlite3_bind_text(updateStatement, 5,(String(tmNamesModl.TmId[find(value: self.mTeam!, in: tmNamesModl.TmNam)!]) as NSString).utf8String, -1, nil)
                          sqlite3_bind_text(updateStatement, 6, (String(self.mTeam!) as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement,7, (String(ctgrySpacVldteModl.ctgId[find(value: self.prntCateg!, in: ctgrySpacVldteModl.ctgNam)!]) as NSString).utf8String, -1, nil)
                         sqlite3_bind_text(updateStatement, 8,(String(self.prntCateg!) as NSString).utf8String, -1, nil)
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
}
