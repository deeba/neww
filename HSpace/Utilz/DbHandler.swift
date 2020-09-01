//
//  DbHandler.swift
//  HelixSense
//
//  Created by DEEBA on 07.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import SQLite3
import  SwiftyJSON
class DbHandler: NSObject {
    
    let instanceOfUser = readWrite()
    var arr = 0
    static func get_Space_Name(completion: @escaping ([SpaceDetails]) -> Void) {
        APIClient.shared().getSpaceName { arr in
            completion(arr)
        }
    }
    
       static func get_Child_Of(id: String,shftId: String,strt: String,endd: String,type: String, completion: @escaping ([SpaceDetails]) -> Void) {
        APIClient_redesign.shared().getSpaceListAvailable(space_id: id,from_date: strt,to_date: endd,type: "") { arr in
            completion(arr)
        }
    }

    static func getBldg(Tkn:String)  -> [SpaceDetails] {

    var arr = [SpaceDetails]()
       // https://demo.helixsense.com/api/v2/call?model=mro.shift.employee&method=get_current_employee_shift
    var request = URLRequest(url: URL(string: usrRol_URL)!,timeoutInterval: Double.infinity)
    let string1 = "Bearer "
    let string2 = Tkn
        var closg = ""
         let combined2 = "\(string1) \(String(describing: string2))"
         request.addValue(combined2, forHTTPHeaderField: "Authorization")
         let stringFields = """
         [["asset_categ_type","=","building"]]
         """
       
          closg = """
         ["space_name","display_name","maintenance_team_id"]
         """
           let closg1 = """
           sort_sequence ASC
           """

         let  stringRole1 = "&domain="
         let stringDomain1 = "&fields="
         let stringDomain2 = "&order="
         let varRole = "\(stringRole1)\(String(describing: stringFields))\(stringDomain1)\(String(describing: closg))\(stringDomain2)\(String(describing: closg1))"
                                   let postData = NSMutableData(data: "model=mro.equipment.location".data(using: String.Encoding.utf8)!)
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
                                                        for j in 0..<jsonc["data"].count {
                                                            var data = SpaceDetails()
                                                            data.displayName = jsonc["data"][j]["display_name"].stringValue
                                                           data.name = jsonc["data"][j]["space_name"].stringValue
                                                           data.id = jsonc["data"][j]["id"].stringValue
                                                        data.haveChilds = true
                                                            mainBldgModl.Id = jsonc["data"][0]["id"].int!
                                                            mainBldgModl.disNam = jsonc["data"][0]["display_name"].stringValue
                                                            mainBldgModl.MTmId  = jsonc["data"][0]["maintenance_team_id"][0].int!
                                                            mainBldgModl.MTmNam = jsonc["data"][0]["maintenance_team_id"][1].stringValue
                                                            mainBldgModl.bldgNam = jsonc["data"][0]["space_name"].stringValue

                                                            arr.append(data)
                                                        }
                                                        
                                                         }
                                                      catch let error as NSError {
                                                         print("Failed to load: \(error.localizedDescription)")
                                                      }
                                                      }
                                                        task1.resume()
        return arr
        }
    static func getSpaceNamez() -> [SpaceDetails] {
        var  strCount = 0
        var idy = ""
        var arr = [SpaceDetails]()
        var db :OpaquePointer? = nil
        let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
           .appendingPathComponent("db_ifmp.sqlite")
           //opening the database
           if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
              print("There's error in opening the database")
           }
        else
            {
                
                let tst =  usrInfoModls.company_name
                let query = "SELECT * FROM tbl_space_details WHERE space_category_type ='building' and space_name = ?  ORDER BY space_seqid ASC"
                 var stmt : OpaquePointer? = nil
                if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
                    sqlite3_bind_text(stmt, 1, (tst as NSString).utf8String, -1, nil)
                    while sqlite3_step(stmt) == SQLITE_ROW {
                        var data = SpaceDetails()
                        data.type = String(cString: sqlite3_column_text(stmt, 6))
                        data.displayName = String(cString: sqlite3_column_text(stmt, 5))
                        data.name = String(cString: sqlite3_column_text(stmt, 3))
                        data.id = String(cString: sqlite3_column_text(stmt, 1))
                        idy = String(cString: sqlite3_column_text(stmt, 1))
                        data.haveChilds = getChildCountOf(parentId: data.id) > 0
                      //  arr.append(data)
                    }
                    sqlite3_finalize(stmt)
                }
                let queryStatementString = "SELECT COUNT(*) AS total_count  FROM tbl_space_details WHERE  space_category_type ='building'  and space_name = ?   ORDER BY space_seqid ASC"
                var queryStatement: OpaquePointer?
                // 1
                if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                    SQLITE_OK {
                         //5F1!!!
                            // 2
                          // 2
                            sqlite3_bind_text(queryStatement, 1, (tst as NSString).utf8String, -1, nil)
                                                    
                          if sqlite3_step(queryStatement) == SQLITE_ROW {
                                         strCount =  Int(sqlite3_column_int(queryStatement, 0))
                                  } else {
                                    print("\nUPDATE statement is not prepared")
                                  }
                        }

                 sqlite3_finalize(queryStatement)
                if strCount > 0
                {
                    let query = "SELECT * FROM tbl_space_details WHERE space_parent_id =\(idy) ORDER BY space_seqid ASC"
                     var stmt : OpaquePointer? = nil
                    if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
                        while sqlite3_step(stmt) == SQLITE_ROW {
                            var data = SpaceDetails()
                            data.type = String(cString: sqlite3_column_text(stmt, 6))
                            data.displayName = String(cString: sqlite3_column_text(stmt, 5))
                            data.name = String(cString: sqlite3_column_text(stmt, 3))
                            data.id = String(cString: sqlite3_column_text(stmt, 1))
                            data.haveChilds = getChildCountOf(parentId: data.id) > 0
                            arr.append(data)
                        }
                        sqlite3_finalize(stmt)
                    }
                }
                
                sqlite3_close(db)
            }
        return arr
    }
    static func getSpaceName() -> [SpaceDetails] {
        var  strCount = 0
        var idy = ""
        var arr = [SpaceDetails]()
        var db :OpaquePointer? = nil
        let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
           .appendingPathComponent("db_ifmp.sqlite")
           //opening the database
           if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
              print("There's error in opening the database")
           }
        else
            {
                let query = "SELECT * FROM tbl_space_details WHERE space_category_type ='building' ORDER BY space_seqid ASC"
                 var stmt : OpaquePointer? = nil
                if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
                    while sqlite3_step(stmt) == SQLITE_ROW {
                        var data = SpaceDetails()
                        data.type = String(cString: sqlite3_column_text(stmt, 6))
                        data.displayName = String(cString: sqlite3_column_text(stmt, 5))
                        data.name = String(cString: sqlite3_column_text(stmt, 3))
                        data.id = String(cString: sqlite3_column_text(stmt, 1))
                        idy = String(cString: sqlite3_column_text(stmt, 1))
                        data.haveChilds = getChildCountOf(parentId: data.id) > 0
                      //  arr.append(data)
                    }
                    sqlite3_finalize(stmt)
                }
                let queryStatementString = "SELECT COUNT(*) AS total_count  FROM tbl_space_details WHERE  space_category_type ='building' ORDER BY space_seqid ASC"
                var queryStatement: OpaquePointer?
                // 1
                if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                    SQLITE_OK {
                         //5F1!!!
                            // 2
                          // 2
                          if sqlite3_step(queryStatement) == SQLITE_ROW {
                                         strCount =  Int(sqlite3_column_int(queryStatement, 0))
                                  } else {
                                    print("\nUPDATE statement is not prepared")
                                  }
                        }

                 sqlite3_finalize(queryStatement)
                if strCount == 1
                {
                    let query = "SELECT * FROM tbl_space_details WHERE space_parent_id =\(idy) ORDER BY space_seqid ASC"
                     var stmt : OpaquePointer? = nil
                    if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
                        while sqlite3_step(stmt) == SQLITE_ROW {
                            var data = SpaceDetails()
                            data.type = String(cString: sqlite3_column_text(stmt, 6))
                            data.displayName = String(cString: sqlite3_column_text(stmt, 5))
                            data.name = String(cString: sqlite3_column_text(stmt, 3))
                            data.id = String(cString: sqlite3_column_text(stmt, 1))
                            data.haveChilds = getChildCountOf(parentId: data.id) > 0
                            arr.append(data)
                        }
                        sqlite3_finalize(stmt)
                    }
             }
                
                sqlite3_close(db)
            }
        return arr
    }
    static   func getChildzOf(parentId: String) -> [SpaceDetails] {
        var arr = [SpaceDetails]()
        var db :OpaquePointer? = nil
       let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
           .appendingPathComponent("db_ifmp.sqlite")
           //opening the database
           if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
              print("There's error in opening the database")
           }
        else
            {
                let query = "SELECT * FROM tbl_space_details WHERE space_parent_id =\(parentId) ORDER BY space_seqid ASC"
                var stmt : OpaquePointer? = nil
                if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
                    while sqlite3_step(stmt) == SQLITE_ROW {
                        var data = SpaceDetails()
                        data.type = String(cString: sqlite3_column_text(stmt, 6))
                        data.displayName = String(cString: sqlite3_column_text(stmt, 5))
                        data.name = String(cString: sqlite3_column_text(stmt, 3))
                        data.id = String(cString: sqlite3_column_text(stmt, 1))
                        data.haveChilds = getChildCountOf(parentId: data.id) > 0
                        arr.append(data)
                    }
                    sqlite3_finalize(stmt)
                }
                sqlite3_close(db)
            }
        return arr
     
    }
     static   func getChildOf(parentId: String) -> [SpaceDetails] {
           var arr = [SpaceDetails]()//symptmsListModl
           var db :OpaquePointer? = nil
          let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
              .appendingPathComponent("db_ifmp.sqlite")
              //opening the database
              if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                 print("There's error in opening the database")
              }
           else
               {
                   let query = "SELECT * FROM tbl_space_details WHERE space_parent_id =\(parentId) ORDER BY space_seqid ASC"
                   var stmt : OpaquePointer? = nil
                   if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
                       while sqlite3_step(stmt) == SQLITE_ROW {
                           var data = SpaceDetails()
                           data.type = String(cString: sqlite3_column_text(stmt, 6))
                           data.displayName = String(cString: sqlite3_column_text(stmt, 5))
                           data.name = String(cString: sqlite3_column_text(stmt, 3))
                           data.id = String(cString: sqlite3_column_text(stmt, 1))
                           data.haveChilds = getChildCountOf(parentId: data.id) > 0
                           arr.append(data)
                       }
                       sqlite3_finalize(stmt)
                   }
                   sqlite3_close(db)
               }
           return arr
        
       }
    static   func getChildCountOf(parentId: String) -> Int {
       var arr = 0
       var db :OpaquePointer? = nil
       let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                 .appendingPathComponent( "db_ifmp.sqlite")
                 //opening the database
                 if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                    print("There's error in opening the database")
                 }
              else
                  {
                      let query = "SELECT * FROM tbl_space_details WHERE space_parent_id =\(parentId) ORDER BY space_seqid ASC"
                      var stmt : OpaquePointer? = nil
                      if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
                          while sqlite3_step(stmt) == SQLITE_ROW {
                              arr += 1
                          }
                          sqlite3_finalize(stmt)
                      }
                      sqlite3_close(db)
                      
                   }
           return arr
          }
    
 }
