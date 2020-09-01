//
//  chusStrtViewController.swift
//  AMTfm
//
//  Created by DEEBA on 08.05.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import SQLite3
import UIKit
import Foundation
import SwiftyJSON
class chusStrtViewController: UIViewController {
    
    @IBOutlet weak var lblPhto: UILabel!
    var db:OpaquePointer? = nil
    @IBAction func strtBtn(_ sender: UIButton) {
        
    let viewController:
                          UIViewController = UIStoryboard(
                              name: "QRStoryboard", bundle: nil
                          ).instantiateViewController(withIdentifier: "QRStory") as! QRViewController
                          // .instantiatViewControllerWithIdentifier() returns AnyObject!
                          // this must be downcast to utilize it

                          let appDelegate = UIApplication.shared.delegate as! AppDelegate
                          //show window
                          appDelegate.window?.rootViewController = viewController
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
    @IBOutlet weak var imgTimz: UIImageView!
    @IBOutlet weak var Commen: UILabel!
    let instanceOfUser = readWrite()
    @IBOutlet weak var ImgTim: UIImageView!
    @IBOutlet weak var lblTim: UILabel!
    @IBOutlet weak var lblEmp: UILabel!
    @IBOutlet weak var lblEqp: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
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
                OperationQueue.main.addOperation {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "PicAlertStoryboard", bundle: nil)
                    if #available(iOS 10.0, *) {
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PicAlertStory") as! PicALertViewController
                        self.present(newViewController, animated: true, completion: nil)
                    }
            else //if start mro flag false checklist shown with release pause finish butn
                    {
                        
                    }
                   
                }
            }
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

}
