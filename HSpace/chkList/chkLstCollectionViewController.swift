//
//  chkLstCollectionViewController.swift
//  AMTfm
//
//  Created by DEEBA on 18.05.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import SwiftyJSON

import SQLite3
import UIKit

private let reuseIdentifier = "Cell"

class chkLstCollectionViewController: UICollectionViewController {
    let instanceOfUser = readWrite()
    var db:OpaquePointer? = nil
    func chklstDisply() {
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
                         let queryStatementString = "SELECT * FROM tbl_checklist WHERE  Orderid=? ;"
                          var queryStatement: OpaquePointer?
                         var  OdrId = "DCSMP2013001"
                          // 1
                          if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                              SQLITE_OK {
                                   //5F1!!!
                                      // 2
                            sqlite3_bind_text(queryStatement, 1, (OdrId as NSString).utf8String, -1, nil)
                           // sqlite3_bind_int(queryStatement, 1, (Int32(chsStrtMdl.idWO)))
                                    // 2
                                    while  sqlite3_step(queryStatement) == SQLITE_ROW {
                                                   let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                                                    chkLstModl.chkLstId.append( String(cString: queryResultCol1!))
                                                    let queryResultCol2 = sqlite3_column_text(queryStatement, 2)
                                                    chkLstModl.typ.append( String(cString: queryResultCol2!))
                                                    let queryResultCol3 = sqlite3_column_text(queryStatement, 3)
                                                    chkLstModl.Qustn.append( String(cString: queryResultCol3!))
                                        print(queryResultCol1)
                                                    let queryResultCol4 = sqlite3_column_text(queryStatement, 4)
                                                    chkLstModl.suggsn.append( String(cString: queryResultCol4!))
                                                    
                                               //    let id = sqlite3_column_int64(queryStatement, 0)
                                 
                                       
                                            }
                             
                                  }

                           sqlite3_finalize(queryStatement)
                           sqlite3_close(db)
                           db = nil
                      }
           }
    override func viewDidLoad() {
        super.viewDidLoad()
        chklstDisply()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

   


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return chkLstModl.chkLstId.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! chkLstCollectionViewCell
        cell.lblQstn.text = chkLstModl.Qustn[indexPath.row]
        // Configure the cell
    
     cell.contentView.layer.cornerRadius = 4.0
     cell.contentView.layer.borderWidth = 1.0
     cell.contentView.layer.borderColor = UIColor.clear.cgColor
     cell.contentView.layer.masksToBounds = false
     cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
    cell.layer.shadowRadius = 0.15
     cell.layer.shadowOpacity = 0.25
     cell.layer.masksToBounds = false
     cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
     }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let bounds  = collectionView.bounds
         return CGSize(width: bounds.width , height: 100)
     }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 0
     }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 0
     }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
