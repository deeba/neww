//
//  phtoLstViewController.swift
//  AMTfm
//
//  Created by DEEBA on 26.05.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import SwiftyJSON
import SQLite3
import UIKit
extension phtoLstViewController: UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  phtoLstMdl.imgPhto.count
    }
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
     }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 0
     }
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.instanceOfUser.writeAnyData(key: "ImagSel", value: phtoLstMdl.imgPhto[indexPath.row])
        let viewController:
        UIViewController = UIStoryboard(
            name: "ZmPhtoStoryboard", bundle: nil
        ).instantiateViewController(withIdentifier: "ZmPhtoStory") as! ZmPhtoViewController
        // .instantiatViewControllerWithIdentifier() returns AnyObject!
        // this must be downcast to utilize it

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //show window
        appDelegate.window?.rootViewController = viewController
        // print(TmNm[indexPath.row])
     }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 0
     }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPhtoLst", for: indexPath) as! phtoLstCollectionViewCell
        //
        cell.lblName.text = phtoLstMdl.lblNam[indexPath.row] + ".jpg"
        cell.lblTim.text = phtoLstMdl.lblTim[indexPath.row]
        let dataDecoded : Data = Data(base64Encoded: phtoLstMdl.imgPhto[indexPath.row], options: .ignoreUnknownCharacters)!
        let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
        cell.imgPhto.image = decodedimage
    return cell
     }
    
    
  
    }
class phtoLstViewController: UIViewController {
    
    @IBAction func btnPlus(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "camraGallryStoryboard", bundle: nil)
                                 let newViewController = storyBoard.instantiateViewController(withIdentifier: "cameraGallStory") as! camraGallryViewController
                                 self.present(newViewController, animated: true, completion: nil)
       
    }
    let instanceOfUser = readWrite()
    var db:OpaquePointer? = nil
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func btnGobck(_ sender: UIButton) {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.instanceOfUser.writeAnyData(key: "ImagSel", value: "")
        if self.instanceOfUser.readStringData(key: "WOphtochkLst" ) ==  "WOphto"
        {
                       let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                       .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
                       //opening the database
                       if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                          print("There's error in opening the database")
                       }
                    else
                        {
                            phtoLstMdl.lblNam.removeAll()
                            phtoLstMdl.lblTim.removeAll()
                            phtoLstMdl.imgPhto.removeAll()
                          let queryStatementString = "SELECT file_name,data_file_name,file_data FROM tbl_uploads WHERE  unq_id=? AND  checklist_id=? ;"
                           var queryStatement: OpaquePointer?
                            let  OdrId:Int = 366082
                           // 1
                           if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                               SQLITE_OK {
                                    //5F1!!!
                                       // 2
                            sqlite3_bind_int(queryStatement, 1, Int32((OdrId)))
                            sqlite3_bind_text(queryStatement, 2, ("" as NSString).utf8String, -1, nil)
                            // sqlite3_bind_int(queryStatement, 1, (Int32(chsStrtMdl.idWO)))
                                     // 2
                                     while  sqlite3_step(queryStatement) == SQLITE_ROW {
                                             let stringFil = String(cString: sqlite3_column_text(queryStatement, 0))
                                        let stringTim = String(cString: sqlite3_column_text(queryStatement, 1))
                                        let string = String(cString: sqlite3_column_text(queryStatement, 2))
                                                phtoLstMdl.lblNam.append(stringFil)
                                                phtoLstMdl.lblTim.append( stringTim)
                                                phtoLstMdl.imgPhto.append( string)
                                                     
                                                //    let id = sqlite3_column_int64(queryStatement, 0)
                                  
                                        
                                             }
                              
                                   }

                            sqlite3_finalize(queryStatement)
                            sqlite3_close(db)
                            db = nil
                       }
            }
        else if self.instanceOfUser.readStringData(key: "WOphtochkLst" ) ==  "phtochkLst"
        {
                       let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                       .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
                       //opening the database
                       if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                          print("There's error in opening the database")
                       }
                    else
                        {
                            phtoLstMdl.lblNam.removeAll()
                            phtoLstMdl.lblTim.removeAll()
                            phtoLstMdl.imgPhto.removeAll()
                          let queryStatementString = "SELECT file_name,data_file_name,file_data FROM tbl_uploads WHERE  unq_id=? AND  checklist_id=? ;"
                           var queryStatement: OpaquePointer?
                            let  OdrId:Int = 366082
                           // 1
                           if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                               SQLITE_OK {
                                    //5F1!!!
                                       // 2
                            sqlite3_bind_int(queryStatement, 1, Int32((OdrId)))
                            sqlite3_bind_int(queryStatement, 2, (Int32( self.instanceOfUser.readIntData(key: "chkLstId"))))
                            // sqlite3_bind_int(queryStatement, 1, (Int32(chsStrtMdl.idWO)))
                                     // 2
                                     while  sqlite3_step(queryStatement) == SQLITE_ROW {
                                             let stringFil = String(cString: sqlite3_column_text(queryStatement, 0))
                                        let stringTim = String(cString: sqlite3_column_text(queryStatement, 1))
                                        let string = String(cString: sqlite3_column_text(queryStatement, 2))
                                                phtoLstMdl.lblNam.append(stringFil)
                                                phtoLstMdl.lblTim.append( stringTim)
                                                phtoLstMdl.imgPhto.append( string)
                                                     
                                                //    let id = sqlite3_column_int64(queryStatement, 0)
                                  
                                        
                                             }
                              
                                   }

                            sqlite3_finalize(queryStatement)
                            sqlite3_close(db)
                            db = nil
                       }
            }
        
        
        
        
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
