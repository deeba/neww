//
//  DViewController.swift
//  Reachability
//
//  Created by DEEBA on 17.03.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

import SQLite3
import SwiftyJSON
@available(iOS 10.0, *)
class DViewController: UIViewController {

    var db:OpaquePointer? = nil
    var task1 = URLSessionDataTask()
    @IBOutlet weak var lblComp: UILabel!
    @IBOutlet weak var lblEmp: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    let instanceOfUser = readWrite()
    @IBOutlet weak var txtCompany: UITextField!
    @IBOutlet weak var txtUser: UITextField!
   /* {
        super.viewDidLoad()
        //set the text and style if any.
        lblEmp.text = "Hi " + self.instanceOfUser.readStringData(key:  "employeeNamez")
        lblComp.text = "Welcome to " +  self.instanceOfUser.readStringData(key:  "CompNamez")
       let closg = """
              /9j/4AAQSkZJRgABAQAASABIAAD/4QBYRXhpZgAATU0AKgAAAAgAAgESAAMAAAAB
              AAEAAIdpAAQAAAABAAAAJgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAABB6AD
              AAQAAAABAAABXgAAAAD/7QA4UGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAAA4QklN
              BCUAAAAAABDUHYzZjwCyBOmACZjs+EJ+/8AAEQgBXgEHAwEiAAIRAQMRAf/EAB8A
              AAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAAB
              fQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYn
              KCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeI
              iYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh
              4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYH
              CAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRC
              kaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZX
              WFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKz
              tLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/bAEMA
              BgYGBgYGCgYGCg4KCgoOEg4ODg4SFxISEhISFxwXFxcXFxccHBwcHBwcHCIiIiIi
              IicnJycnLCwsLCwsLCwsLP/bAEMBBwcHCwoLEwoKEy4fGh8uLi4uLi4uLi4uLi4u
              Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLv/dAAQAEf/aAAwD
              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
              """
        
        
        let test = String(closg.filter { !" \n\t\r".contains($0) })
        let temp = closg.components(separatedBy: ",")
        
        var dataDecoded : Data = Data(base64Encoded: temp[0], options: .ignoreUnknownCharacters)!
       var decodedimage = UIImage(data: dataDecoded)
        
        dataDecoded = resize(image: decodedimage!)!
        
        decodedimage = UIImage(data: dataDecoded)
           self.imgVw.image = decodedimage
        //// Do any additional setup after loading the view.
        self.instanceOfUser.writeAnyData(key: "CompLogoz", value: "")
        instanceOfUser.writeAnyData(key: "offsetz", value: 0)
         self.DownldCategory(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"))
    }
 */
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the text and style if any.
     /*    lblEmp.text = "Hi " + self.instanceOfUser.readStringData(key:  "employeeNamez")
        lblComp.text = "Welcome to " +  self.instanceOfUser.readStringData(key:  "CompNamez")
       let temp = instanceOfUser.readStringData(key: "CompLogoz").components(separatedBy: ",")
       var dataDecoded : Data = Data(base64Encoded: temp[0], options: .ignoreUnknownCharacters)!
       var decodedimage = UIImage(data: dataDecoded)
        
      //  dataDecoded = resize(image: decodedimage!)!
        
        decodedimage = UIImage(data: dataDecoded)
           self.imgVw.image = decodedimage
        */
        //// Do any additional setup after loading the view.
       self.instanceOfUser.writeAnyData(key: "CompLogoz", value: "")
        instanceOfUser.writeAnyData(key: "offsetz", value: 0)
         self.DownldCategory(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"))
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the vd bv new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func resize(image: UIImage, maxHeight: Float = 350.0, maxWidth: Float = 350.0, compressionQuality: Float = 0.5) -> Data? {
      var actualHeight: Float = Float(image.size.height)
      var actualWidth: Float = Float(image.size.width)
      var imgRatio: Float = actualWidth / actualHeight
      let maxRatio: Float = maxWidth / maxHeight

      if actualHeight > maxHeight || actualWidth > maxWidth {
        if imgRatio < maxRatio {
          //adjust width according to maxHeight
          imgRatio = maxHeight / actualHeight
          actualWidth = imgRatio * actualWidth
          actualHeight = maxHeight
        }
        else if imgRatio > maxRatio {
          //adjust height according to maxWidth
          imgRatio = maxWidth / actualWidth
          actualHeight = imgRatio * actualHeight
          actualWidth = maxWidth
        }
        else {
          actualHeight = maxHeight
          actualWidth = maxWidth
        }
      }
      let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
      UIGraphicsBeginImageContext(rect.size)
      image.draw(in:rect)
      let img = UIGraphicsGetImageFromCurrentImageContext()
      let imageData = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
      UIGraphicsEndImageContext()
      return imageData
    }
    func getlastUpdateDateTimeSpace() -> String {

                  var string1 = ""
                   let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                   .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
                   //opening the database
                   if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                      print("There's error in opening the database")
                   }
                else
                {
                   let queryStatementString = "SELECT last_update_date_time_space FROM tbl_last_update_data WHERE id = (SELECT MAX(id) FROM tbl_last_update_data);"
                   var queryStatement: OpaquePointer?
                   if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                       SQLITE_OK {
                     // 2
                     if sqlite3_step(queryStatement) == SQLITE_ROW{
                         string1 =    String(cString: sqlite3_column_text(queryStatement, 0))
                        instanceOfUser.writeAnyData(key: "lastUpdtdDtTimSpace", value: string1)
                    }
                    else{//if the tbl is empty
                         string1 = ""
                        instanceOfUser.writeAnyData(key: "lastUpdtdDtTimSpace", value: "")
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
        return (string1)
        }
    func DownldCategory(Tkn: String) {
                           // read the last updated value from the table and if update value is empty  the domain filed should be [] array otherwise send the last update value in the domain field like this [["write_date",">","2020-02-23 08:27:08"]] and the time should send UTC format.
                            //5F1
                            getlastUpdateDateTimeSpace()
                            var stringFields = ""
                            if (instanceOfUser.readStringData(key: "lastUpdtdDtTimSpace") == "" )
                            {
                                 stringFields = """
                                &domain=[]&fields=["parent_category_id","name","priority","sla_timer"]&limit=80&offset=
                                """
                            }
                            else
                            {
                                let stringFields1 = """
                                &domain=[["write_date",">","
                                """

                                let trimmed1 = instanceOfUser.readStringData(key: "lastUpdtdDtTimSpace").trimmingCharacters(in: .whitespacesAndNewlines)
                                let  stringFields2 = """
                                "]]&fields=["parent_category_id","name","priority","sla_timer"]&limit=80&offset=
                                """
                                     stringFields = "\(stringFields1)\(trimmed1)\(String(describing: stringFields2))"
                            }
        
                             let    offsetFields = """
                                &order=parent_category_id ASC
                                """
                            var request = URLRequest(url: URL(string:"https://demo.helixsense.com/api/isearch_read_v1")!,timeoutInterval: Double.infinity)
                            
                            let stringOff = instanceOfUser.readIntData(key:  "offsetz")
                            let combinedOffset = "\(stringFields)\(stringOff)\(String(describing: offsetFields))"
                            let varRole = "\(String(describing: combinedOffset))"
                            let string1 = "Bearer "
                            let string2 = Tkn
                            let combined2 = "\(string1) \(String(describing: string2))"
                            request.addValue(combined2, forHTTPHeaderField: "Authorization")
                            let postData = NSMutableData(data: "model=website.support.ticket.subcategory".data(using: String.Encoding.utf8)!)
                            postData.append(varRole.data(using: String.Encoding.utf8)!)
                            request.httpBody = postData as Data
                            request.httpMethod = "POST"
/*https://demo.helixsense.com/api/isearch_read_v1?model=website.support.ticket.subcategory&domain=[["write_date",">","2020-01-23 18:14:25"]]&fields=["parent_category_id","name","priority","sla_timer"]&limit=80&offset=0&order=parent_category_id ASC*/
                              task1 = URLSession.shared.dataTask(with: request) { data, response, error in
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
                                //let lngth = jsonc["length"]
                                if (title.count > 0){
                                    for i in 0..<title.count {
                                //if (lngth.intValue > 0){
                                  //      for i in 0..<lngth.intValue {
                                            var catId, Id, slaTmr ,catName, Name, priority: String
                                            catId = title[i]["parent_category_id"][0].stringValue
                                            catName = title[i]["parent_category_id"][1].stringValue
                                            Id = title[i]["id"].stringValue
                                            Name = title[i]["name"].stringValue
                                            priority = title[i]["priority"].stringValue
                                            slaTmr = title[i]["sla_timer"].stringValue
                                            // set your values into models property like this
 //5F2
                                            self.insertCategorySubcategory(Id: Id,Name: Name,catId: catId,catName: catName,priority: priority,slaTmr: slaTmr)
                                            
                                        }
                                            self.instanceOfUser.writeAnyData(key: "offsetz", value: self.instanceOfUser.readIntData(key:  "offsetz") + 80)
                                     self.DownldCategory(Tkn: Tkn)
                                    }
                                else{
                                 self.instanceOfUser.writeAnyData(key: "offsetz", value: 0)
                                    //5F3
                                    self.task1.cancel()
                                self.DownldSpace(Tkn:  Tkn)
                                self.instanceOfUser.writeAnyData(key: "offsetz", value: 0)
                                        }
                                  }
                               catch let error as NSError {
                                  print("Failed to load: \(error.localizedDescription)")
                              }
                             }
                      task1.resume()

    }
    func DownldSpace(Tkn: String) {
       // https://demo.helixsense.com/api/isearch_read_v1?model=mro.equipment.location&domain=[]&fields=["space_name","name","display_name","maintenance_team_id","asset_categ_type","asset_category_id","parent_id","asset_categ_type","sort_sequence"]&limit=10&offset=0&order=id ASC
                            var stringFields = ""
                            if (instanceOfUser.readStringData(key: "lastUpdtdDtTimSpace") == "" )
                            {
                                 stringFields = """
                                &domain=[]&fields=["space_name","display_name","name","maintenance_team_id","parent_id","asset_categ_type","asset_category_id","sort_sequence"]&limit=80&offset=
                                """
                            }
                            else
                            {
                                let stringFields1 = """
                                &domain=[["write_date",">","
                                """

                                let trimmed1 = instanceOfUser.readStringData(key: "lastUpdtdDtTimSpace").trimmingCharacters(in: .whitespacesAndNewlines)
                                let  stringFields2 = """
                                "]]&fields=["space_name","display_name","name","maintenance_team_id","parent_id","asset_categ_type","asset_category_id","sort_sequence"]&limit=10&offset=
                                """
                                     stringFields = "\(stringFields1)\(trimmed1)\(String(describing: stringFields2))"
                            }

                            var request = URLRequest(url: URL(string:"https://demo.helixsense.com/api/isearch_read_v1")!,timeoutInterval: Double.infinity)
                            let    offsetFields = """
                            &order=id ASC
                            """
                            let stringOff = instanceOfUser.readIntData(key:  "offsetz")
                            let combinedOffset = "\(stringFields)\(stringOff)\(String(describing: offsetFields))"
                            let varRole = "\(String(describing: combinedOffset))"
                            let string1 = "Bearer "
                                                  let string2 = Tkn
                                                  let combined2 = "\(string1) \(String(describing: string2))"
                                                         request.addValue(combined2, forHTTPHeaderField: "Authorization")
                             let postData = NSMutableData(data: "model=mro.equipment.location".data(using: String.Encoding.utf8)!)
                             postData.append(varRole.data(using: String.Encoding.utf8)!)
                            request.httpBody = postData as Data
                             request.httpMethod = "POST"
                              task1 = URLSession.shared.dataTask(with: request) { data, response, error in
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
                                 //let lngth = jsonc["length"]

                                if (title.count > 0){
                                    for i in 0..<title.count {

                                     // if (lngth.intValue > 0){
                                      //   for i in 0..<lngth.intValue{
                                            var spacId, seqId, spaceName ,displayName, categoryTyp, maintTeamId,maintTeamName, parentId,spaceShrtcde,spcPrntNam,spcCgryId,spcCgryNam: String
                                            spacId = title[i]["id"].stringValue
                                            seqId = title[i]["sort_sequence"].stringValue
                                            spaceName = title[i]["space_name"].stringValue
                                            spaceShrtcde = title[i]["name"].stringValue
                                            displayName = title[i]["display_name"].stringValue
                                            categoryTyp = title[i]["asset_categ_type"].stringValue
                                            parentId = title[i]["parent_id"][0].stringValue
                                           if (parentId == "false" || parentId == ""){
                                                parentId = ""
                                                spcPrntNam = ""
                                            }
                                            else{
                                                parentId = title[i]["parent_id"][0].stringValue
                                                spcPrntNam = title[i]["parent_id"][1].stringValue
                                            }
                                            maintTeamId = title[i]["maintenance_team_id"][0].stringValue
                                            if (maintTeamId == "false" || maintTeamId == ""){
                                                maintTeamId = ""
                                                maintTeamName = ""
                                            }
                                            else{
                                                maintTeamId = title[i]["maintenance_team_id"][0].stringValue
                                                maintTeamName = title[i]["maintenance_team_id"][1].stringValue
                                            }
                                        spcCgryId = title[i]["asset_category_id"][0].stringValue
                                        if (spcCgryId == "false" || spcCgryId == ""){
                                                                                       spcCgryId = ""
                                                                                       spcCgryNam = ""
                                                                                   }
                                                                                   else{
                                                                                       spcCgryId = title[i]["asset_category_id"][0].stringValue
                                                                                       
                                                                                       spcCgryNam = title[i]["asset_category_id"][1].stringValue
                                                                                   }
                                        self.insertSpaces(spacId: spacId, seqId: seqId, spaceName: spaceName ,spacShrtCde:spaceShrtcde,displayName: displayName, categoryTyp: categoryTyp, parentId: parentId,parentNam: spcPrntNam,maintTeamId: maintTeamId,maintTeamName: maintTeamName,spcCtrgyId: spcCgryId,spcCtrgyName: spcCgryNam )
                                        }
                                        
                                               self.instanceOfUser.writeAnyData(key: "offsetz", value: self.instanceOfUser.readIntData(key:  "offsetz") + 80)
                                        self.DownldSpace(Tkn:  Tkn)
                                     }
                                    else
                                    {
                                        //5F4
                                        self.task1.cancel()
                                        self.moveNextt()
                                    }
                                  }
                               catch let error as NSError {
                                  print("Failed to load: \(error.localizedDescription)")
                              }
                             }
                      task1.resume()

    }
    func convertToUTC(dateToConvert:String) -> String {
     let formatter = DateFormatter()
     formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
     let convertedDate = formatter.date(from: dateToConvert)
     formatter.timeZone = TimeZone(identifier: "UTC")
     return formatter.string(from: convertedDate!)
        
    }
    func UpdateLastUpdte() {
        //get last_update_date_time_space
        
              let dateFormatter : DateFormatter = DateFormatter()
              //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              let date = Date()
              let dateString = dateFormatter.string(from: date)
              let lstDatetime = convertToUTC(dateToConvert: dateString)

           
            let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
            {
                  let UpdStatementString = "UPDATE tbl_last_update_data SET  last_update_date_time =  ?  WHERE id = (SELECT MAX(id) FROM tbl_last_update_data);"
                var UpdStatement: OpaquePointer?
                // 1
                if sqlite3_prepare_v2(db, UpdStatementString, -1, &UpdStatement, nil) ==
                    SQLITE_OK {
                    let name1: NSString = lstDatetime as NSString
                    // 2
                  sqlite3_bind_text(UpdStatement, 1, (name1 as NSString).utf8String, -1, nil)
                  // 4
                  if sqlite3_step(UpdStatement) == SQLITE_DONE {
                   // print("\nSuccessfully updated row.")
                    instanceOfUser.writeAnyData(key: "IS_DOWNLOADED", value: true)
                  } else {
                    print("\nCould not update row.")
                  }
                } else {
                  print("\nUPDATE statement is not prepared.")
                }
                // 5
                sqlite3_finalize(UpdStatement)
                sqlite3_close(db)
                db = nil
            }
            
        }
    func UpdateCatLastUpdte() {
        //get last_update_date_time_space
        
              let dateFormatter : DateFormatter = DateFormatter()
              //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              let date = Date()
              let dateString = dateFormatter.string(from: date)
              let lstDatetime = convertToUTC(dateToConvert: dateString)

           
            let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
            {
                  let UpdStatementString = "UPDATE tbl_last_update_data SET  last_update_date_time_cat =  ?  WHERE id = (SELECT MAX(id) FROM tbl_last_update_data);"
                var UpdStatement: OpaquePointer?
                // 1
                if sqlite3_prepare_v2(db, UpdStatementString, -1, &UpdStatement, nil) ==
                    SQLITE_OK {
                    let name1: NSString = lstDatetime as NSString
                    // 2
                  sqlite3_bind_text(UpdStatement, 1, (name1 as NSString).utf8String, -1, nil)
                  // 4
                  if sqlite3_step(UpdStatement) == SQLITE_DONE {
                   // print("\nSuccessfully updated row.")
                   // instanceOfUser.writeAnyData(key: "IS_DOWNLOADED", value: true)
                  } else {
                    print("\nCould not update row.")
                  }
                } else {
                  print("\nUPDATE statement is not prepared.")
                }
                // 5
                sqlite3_finalize(UpdStatement)
                sqlite3_close(db)
                db = nil
            }
            
        }
    func UpdateSpaceLastUpdte() {
        //get last_update_date_time_space
        
              let dateFormatter : DateFormatter = DateFormatter()
              //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              let date = Date()
              let dateString = dateFormatter.string(from: date)
              let lstDatetime = convertToUTC(dateToConvert: dateString)

           
            let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
            //print(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
            {
                  let UpdStatementString = "UPDATE tbl_last_update_data SET  last_update_date_time_space =  ?  WHERE id = (SELECT MAX(id) FROM tbl_last_update_data);"
                var UpdStatement: OpaquePointer?
                // 1
                if sqlite3_prepare_v2(db, UpdStatementString, -1, &UpdStatement, nil) ==
                    SQLITE_OK {
                    let name1: NSString = lstDatetime as NSString
                    // 2
                  sqlite3_bind_text(UpdStatement, 1, (name1 as NSString).utf8String, -1, nil)
                  // 4
                  if sqlite3_step(UpdStatement) == SQLITE_DONE {
                 //   print("\nSuccessfully updated row.")
                    instanceOfUser.writeAnyData(key: "IS_DOWNLOADED", value: true)
                  } else {
                    print("\nCould not update row.")
                  }
                } else {
                  print("\nUPDATE statement is not prepared.")
                }
                // 5
                sqlite3_finalize(UpdStatement)
                sqlite3_close(db)
                db = nil
            }
            
        }
     func moveNextt(){
        
        let stry = getlastUpdateDateTimeSpace()
        print(stry)
              let dateFormatter : DateFormatter = DateFormatter()
              //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              let date = Date()
              let dateString = dateFormatter.string(from: date)
              let lstDatetime = convertToUTC(dateToConvert: dateString)
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
            {
                var queryStatement: OpaquePointer?
               // 1
               
                   // 2
                 // 2
                if (stry != "")
                    {
                        UpdateLastUpdte()
                        UpdateSpaceLastUpdte()
                        UpdateCatLastUpdte()
                       
                       OperationQueue.main.addOperation {
                        
                        let storyBoard: UIStoryboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabBarStory") as! demoDash
                        self.present(newViewController, animated: true, completion: nil)
                                                        }
                    }
                    else {
                   let insertStatementString = "INSERT INTO tbl_last_update_data (last_update_date_time, last_update_date_time_space, last_update_date_time_cat, company_id) VALUES (?, ?, ?, ?);"
                   var insertStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
                       SQLITE_OK {
                     // 3
                      sqlite3_bind_text(insertStatement, 1, ("" as NSString).utf8String, -1, nil)
                      sqlite3_bind_text(insertStatement, 2,(lstDatetime as NSString).utf8String, -1, nil)
                      sqlite3_bind_text(insertStatement, 3,(lstDatetime as NSString).utf8String, -1, nil)
                    sqlite3_bind_int(insertStatement, 4,(Int32(instanceOfUser.readIntData(key: "CompIdz"))))
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
                    sqlite3_close(db)
                    db = nil
                    OperationQueue.main.addOperation {
                        
                        let storyBoard: UIStoryboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                                              let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabBarStory") as! demoDash
                                              self.present(newViewController, animated: true, completion: nil)
                    }
               }
           }
    }
    
     func insertSpaces(spacId: String, seqId: String, spaceName: String ,spacShrtCde:String,displayName: String, categoryTyp: String, parentId: String,parentNam: String,maintTeamId: String,maintTeamName: String,spcCtrgyId: String,spcCtrgyName: String )
        
          {
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
            {
               let queryStatementString = "SELECT * FROM tbl_space_details WHERE space_id=? ;"
               var queryStatement: OpaquePointer?
               // 1
               if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                   SQLITE_OK {
                   // 5G1
                sqlite3_bind_int(queryStatement, 1, (Int32(spacId)!))
                 // 2
                 if sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                 let updateStatementString = "UPDATE tbl_space_details SET space_seqid = ?,space_name = ?,space_short_code = ?, space_display_name = ?,space_category_type = ?,space_parent_id = ?,space_parent_name = ?,space_maintenance_team_id = ?,space_maintenance_team = ?,space_category_id = ?,space_category_name = ? WHERE space_id=? ;"
                 var updateStatement: OpaquePointer?
                 if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
                     SQLITE_OK {
                      //    let catNam: String = "hello"
                    sqlite3_bind_int(updateStatement, 1, (Int32(seqId)!))
                    sqlite3_bind_text(updateStatement, 2,(spaceName as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 3, (spacShrtCde as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 4, (displayName as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 5,(categoryTyp as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 6, (parentId as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 7, (parentNam as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 8,(maintTeamId as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 9,(maintTeamName as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 10, (spcCtrgyId as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 11, (spcCtrgyName as NSString).utf8String, -1, nil)
                    sqlite3_bind_int(updateStatement, 12,(Int32(spacId)!))
                   if sqlite3_step(updateStatement) == SQLITE_DONE {
                   //   print("\nSuccessfully updated row.")
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
               } else {// 5G2
                   let insertStatementString = "INSERT INTO tbl_space_details (space_id, space_seqid, space_name,space_short_code, space_display_name, space_category_type, space_parent_id,space_parent_name,space_maintenance_team_id,space_maintenance_team,space_asset_category_id,space_asset_category_name) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"

                   var insertStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
                       SQLITE_OK {
                     // 3
                     sqlite3_bind_int(insertStatement, 1, (Int32(spacId)!))
                     sqlite3_bind_int(insertStatement, 2,(Int32(seqId)!))
                     sqlite3_bind_text(insertStatement, 3,(spaceName as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 4, (spacShrtCde as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 5, (displayName as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 6,(categoryTyp as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 7, (parentId as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 8, (parentNam as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 9,(maintTeamId as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 10,(maintTeamName as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 11, (spcCtrgyId as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 12, (spcCtrgyName as NSString).utf8String, -1, nil)
                     // 4
                     if sqlite3_step(insertStatement) == SQLITE_DONE {
                   //     print("\nSuccessfully inserted row.")
                     } else {
                       print("\nCould not insert row.")
                     }
                   } else {
                     print("\nINSERT statement is not prepared.")

                    }
                   // 5
                   sqlite3_finalize(insertStatement)
                    sqlite3_close(db)
                    db = nil
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
    func insertCategorySubcategory(Id: String,Name: String,catId: String,catName: String,priority: String,slaTmr: String)
          {
               // self.insertCategorySubcategory(Id: "26",Name: "Floor Drains",catId: "5",catName: "Plumbing-Common",priority: "1",slaTmr: "8")
               
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
                {
                    
                   let queryStatementString = "SELECT * FROM tbl_category WHERE cat_id=? AND cat_sub_id=?;"
                   var queryStatement: OpaquePointer?
                   let catid: String = catId
                   let catSubid: String = Id
                   // 1
                   if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                       SQLITE_OK {
                            //5F1!!!
                               // 2
                               sqlite3_bind_text(queryStatement, 1, (catid as NSString).utf8String, -1, nil)
                               sqlite3_bind_text(queryStatement, 2, (catSubid as NSString).utf8String, -1, nil)
                             // 2
                             if sqlite3_step(queryStatement) == SQLITE_ROW {
                                
                                     let updateStatementString = "UPDATE tbl_category SET cat_name = ?,cat_sub_name = ?,priority = ?,sla_timer = ? WHERE cat_id=? AND cat_sub_id=?;"
                                     var updateStatement: OpaquePointer?
                                     if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
                                         SQLITE_OK {
                                          //    let catNam: String = "hello"
                                        sqlite3_bind_text(updateStatement, 1, (catName as NSString).utf8String, -1, nil)
                                        sqlite3_bind_text(updateStatement, 2, (Name as NSString).utf8String, -1, nil)
                                        sqlite3_bind_text(updateStatement, 3,(priority as NSString).utf8String, -1, nil)
                                        sqlite3_bind_text(updateStatement, 4, (slaTmr as NSString).utf8String, -1, nil)
                                        sqlite3_bind_text(updateStatement, 5, (catid as NSString).utf8String, -1, nil)
                                        sqlite3_bind_text(updateStatement, 6,(Id as NSString).utf8String, -1, nil)
                                       if sqlite3_step(updateStatement) == SQLITE_DONE {
                                     //     print("\nSuccessfully updated row.")
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
                           } else {//5F2 !!!
                                   let insertStatementString = "INSERT INTO tbl_category (cat_id, cat_name, cat_sub_id, cat_sub_name, priority, sla_timer) VALUES (?, ?, ?, ?, ?, ?);"
                                   var insertStatement: OpaquePointer?
                                   // 1
                                   if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
                                       SQLITE_OK {
                                       
                                     // 3
                                     sqlite3_bind_text(insertStatement, 1, (catId as NSString).utf8String, -1, nil)
                                     sqlite3_bind_text(insertStatement, 2,(catName as NSString).utf8String, -1, nil)
                                     sqlite3_bind_text(insertStatement, 3,(Id as NSString).utf8String, -1, nil)
                                     sqlite3_bind_text(insertStatement, 4,(Name as NSString).utf8String, -1, nil)
                                     sqlite3_bind_text(insertStatement, 5,(priority as NSString).utf8String, -1, nil)
                                     sqlite3_bind_text(insertStatement, 6,(slaTmr as NSString).utf8String, -1, nil)
                                     // 4
                                     if sqlite3_step(insertStatement) == SQLITE_DONE {
                                 //       print("\nSuccessfully inserted row.")
                                     } else {
                                       print("\nCould not insert row.")
                                     }
                                   } else {
                                     print("\nINSERT statement is not prepared.")
                                   }
                                   // 5
                                sqlite3_finalize(insertStatement)
                                sqlite3_close(db)
                                db = nil
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
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
