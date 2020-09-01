//
//  relsSrNoViewController.swift
//  AMTfm
//
//  Created by DEEBA on 28.05.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import SQLite3

class relsSrNoViewController: UIViewController {
    let instanceOfUser = readWrite()
    var db:OpaquePointer? = nil
    @IBAction func btnS(_ sender: UIButton) {
        if  self.instanceOfUser.readStringData(key: "PausRlz") == "Relz"{
                            let stringFields1 = """
                                                  model=mro.order&values={"state":"ready","employee_id":false"
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
                                               let    stringFields = "\(stringFields1)\(offsetFields)"
                                              let combinedOffset = "\(stringFields)\(String(describing: nwFlds))\(chsStrtMdl.idWO)\(String(describing: stringFields2))"

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
                             "data": true
                             """
                             let varstts =  jsonStr?.contains("\(String(describing: nwFlds))") ?? false
                              if varstts
                                 {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                                     self.updatTblOrdersStts(idey: chsStrtMdl.idWO)
                                        }
                             }
                             
                         }

                           }
                    task1.resume()
            }
        else  if  self.instanceOfUser.readStringData(key: "PausRlz") == "Pauz"{
            let storyBoard: UIStoryboard = UIStoryboard(name: "pausReasnStoryboard", bundle: nil)
                           let newViewController = storyBoard.instantiateViewController(withIdentifier: "pausReasnStory") as! pausReasnViewController
                           self.present(newViewController, animated: true, completion: nil)
        
            
             }
        }
        func updatTblOrdersStts(idey: Int) {
            
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
                                        let stts  =  "ready"
                                         let updateStatementString = "UPDATE tbl_orders SET accept_status  = ?,is_flag = ?,status = ? WHERE unq_id =? ;"
                                         var updateStatement: OpaquePointer?
                                         if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
                                             SQLITE_OK {
                                            let accptStts: Int
                                            accptStts = 0
                                             // is_flag, sync_status,is_modified_status
                                            let isflag: Int
                                            isflag = 0
                                             sqlite3_bind_int(updateStatement, 1,Int32(accptStts))
                                             sqlite3_bind_int(updateStatement, 2,Int32(isflag))
                                             sqlite3_bind_text(updateStatement, 3, (stts as NSString).utf8String, -1, nil)
                                             sqlite3_bind_int(updateStatement, 4,(Int32(unqId)))
                                            
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

                                    let viewController:
                                        UIViewController = UIStoryboard(
                                            name: "HomeStoryboard", bundle: nil
                                        ).instantiateViewController(withIdentifier: "HomeStory") as! HomeScreenz
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                         //show window
                                                         appDelegate.window?.rootViewController = viewController
                                
                        
        }
    @IBAction func btnNo(_ sender: UIButton) {
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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

}
