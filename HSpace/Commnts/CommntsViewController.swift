//
//  CommntsViewController.swift
//  AMTfm
//
//  Created by DEEBA on 25.05.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import SQLite3
import UIKit
import SwiftyJSON
extension UICollectionView {

  func validate(indexPath: IndexPath) -> Bool {
    if indexPath.section >= numberOfSections {
      return false
    }

    if indexPath.row >= numberOfItems(inSection: indexPath.section) {
      return false
    }

    return true
  }
    func scrollToBottom(animated: Bool = true) {
        let sections = self.numberOfSections
        let rows = self.numberOfItems(inSection: sections - 1)
        if (rows > 0){
            self.scrollToItem(at: NSIndexPath(row: rows - 1, section: sections - 1) as IndexPath, at: .top, animated: true)
        }
    }
}
extension CommntsViewController: UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  comntMdl.lblNam.count
    }
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCommen", for: indexPath) as! CommntsCollectionViewCell
        cell.lblBot.text = comntMdl.lblNam[indexPath.row]
        cell.lblTim.text = comntMdl.lblDt[indexPath.row]
        cell.lblStat.text = comntMdl.lblState[indexPath.row]
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
    return cell
     }
    
    
  
    }

class CommntsViewController: UIViewController , UITextFieldDelegate {
    let instanceOfUser = readWrite()
    var db:OpaquePointer? = nil
    @IBOutlet weak var txtnewCommn: UITextField!
    @IBOutlet weak var collectionview: UICollectionView!

    @IBAction func btnAdd(_ sender: UIButton) {
        AdCommnts(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
    }
    func AdCommnts(Tkn: String)
     {
        let stringFields = """
            {"model":"mro.order","res_id":
            """
        
         let msgs = chsStrtMdl.idWO
     var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/create")!,timeoutInterval: Double.infinity)
     let string1 = "Bearer "
     let string2 = Tkn
     let combined2 = "\(string1) \(String(describing: string2))"
     request.addValue(combined2, forHTTPHeaderField: "Authorization")
     
        let closg = """
        ,"message_type":"comment","body":"
        """
        let closg1 = """
     "}
     """
         
     let  stringRole1 = "&values="
        let varRole = "\(stringRole1)\(stringFields)\(msgs)\(closg)\(String(describing: txtnewCommn.text!))\(closg1)"
     let postData = NSMutableData(data: "model=mail.message".data(using: String.Encoding.utf8)!)
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
                 if (title.count > 0)
                        {
                            self.instanceOfUser.writeAnyData(key: "newCmnt", value: true)
                            let strMsg:String = self.instanceOfUser.readStringData(key: "MsgIds")
                            let r = strMsg.index(strMsg.startIndex, offsetBy: 0)..<strMsg.index(strMsg.endIndex, offsetBy: -1)
                            let r1 = strMsg.index(strMsg.startIndex, offsetBy: 1)..<strMsg.index(strMsg.endIndex, offsetBy: -1)
                            // Access the string by the range.
                            let substring = strMsg[r] + "," + jsonc["data"][0].stringValue  + "]"
                            let substring1 = strMsg[r1] + "," + jsonc["data"][0].stringValue
                            let array = substring1.components(separatedBy: ",")
                            var intArray:[Int] =  Array()
                            for ih in 0..<array.count{
                                intArray.append(Int(array[ih].trimmingCharacters(in: .whitespacesAndNewlines))!)
                                }
                            let varRole = "\(intArray.sorted())"
                            self.instanceOfUser.writeAnyData(key: "MsgIds", value: varRole)
                            self.fetchCommnts(Tkn: self.instanceOfUser.readStringData(key: "accessTokenz") )
                            self.insertTblOrders()
                          }
                   }
                catch let error as NSError {
                   print("Failed to load: \(error.localizedDescription)")
                }
             }
                task1.resume()

       }
    func insertTblOrders()
    {
       /* if let strings =
        self.instanceOfWOrder.userDefaults.object(forKey: "InsrtWOArrayz") as? [Any]{
        
        let InsrtWOArrayz = strings.compactMap{ $0 as? [String: Any] }
            
            let  total = InsrtWOArrayz[0]["display_namey"]
            print(total ?? "")
            }*/
       
            
                       
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
               // 1
               if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                   SQLITE_OK {
                sqlite3_bind_int(queryStatement, 1,(Int32(chsStrtMdl.idWO)))
                 // 2
                 if sqlite3_step(queryStatement) == SQLITE_ROW {
                    //5Q
                   
                    
                 let updateStatementString = "UPDATE tbl_orders SET message_ids = ?  WHERE unq_id =? ;"
                 var updateStatement: OpaquePointer?
                 if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
                     SQLITE_OK {
                    
                    sqlite3_bind_text(updateStatement, 1,(self.instanceOfUser.readStringData(key: "MsgIds") as NSString).utf8String, -1, nil)
                    
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
    func fetchCommnts(Tkn: String)
     {
        comntMdl.lblDt.removeAll()
        comntMdl.lblNam.removeAll()
        comntMdl.lblState.removeAll()
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
                         DispatchQueue.main.sync {
                            
                           //  self.collectionview.transform = CGAffineTransform(scaleX: 1, y: -1)
                            self.collectionview.reloadData()
                            let indexPath = NSIndexPath(row: comntMdl.lblNam.count-1, section: 0)
                            self.collectionview.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
                          //
                         /*    self.collectionview.reloadData()
                            let indexPath = NSIndexPath(row: comntMdl.lblNam.count-1, section: 0)
                               self.collectionview.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
 */
                            }
 
                       }
                }
             catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
             }
             }
                task1.resume()

       }
  
    @IBAction func btnGoBac(_ sender: UIButton) {
        let viewController:
                                      UIViewController = UIStoryboard(
                                          name: "chkLstStoryboard", bundle: nil
                                      ).instantiateViewController(withIdentifier: "chkLstStory") as! chkListViewController
                                      // .instantiatViewControllerWithIdentifier() returns AnyObject!
                                      // this must be downcast to utilize it

                                      let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                      //show window
                                      appDelegate.window?.rootViewController = viewController
    }
    @IBOutlet weak var lblEqp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.instanceOfUser.writeAnyData(key: "newCmnt", value: false)
        lblEqp.text = chsStrtMdl.idOrdr
        let myColor = UIColor.darkGray
        txtnewCommn.layer.borderWidth = 1.0
        txtnewCommn.layer.borderColor = myColor.cgColor
        txtnewCommn.delegate =  self
        //to arrange tbl in desc
        collectionview.transform = CGAffineTransform(scaleX: 1, y: -1)

        let indexPath = NSIndexPath(row: comntMdl.lblNam.count-1, section: 0)
        self.collectionview.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
        
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
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                   textField.resignFirstResponder()
                   return true
               }
              
    }
