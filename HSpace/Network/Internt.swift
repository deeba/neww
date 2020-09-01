//
//  Internt.swift
//  HSpace
//
//  Created by DEEBA on 01.09.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
class Internt : NSObject
{
    let instanceOfUser = readWrite()
    func InterNt(){
    if (Network.reachability.isReachable){
        self.instanceOfUser.writeAnyData(key: "Internt", value: "Connected")
    }
    else{
        self.instanceOfUser.writeAnyData(key: "Internt", value: "NoInternet")
    }
        }
    func convertToLocal (incomingFormat: String) -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

      let dt = dateFormatter.date(from: incomingFormat)
      dateFormatter.timeZone = TimeZone.current
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

      return dateFormatter.string(from: dt ?? Date())
    }
    
    func deleteDB()
           {
                              let filemManager = FileManager.default
                             do {
                               let file_URLx = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                                 .appendingPathComponent("db_ifmp.sqlite")
                                 try filemManager.removeItem(at: file_URLx as URL)
                                 print("Database Deleted!")
                              } catch {
                                  print("Error on Delete Database!!!")
                             }
           }
    func convertToUTC(dateToConvert:String) -> String {
     let formatter = DateFormatter()
     formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
     let convertedDate = formatter.date(from: dateToConvert)
     formatter.timeZone = TimeZone(identifier: "UTC")
     return formatter.string(from: convertedDate!)
        
    }
    func jsonToString(json: AnyObject) -> String{
            do {
                let data1 = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) as NSString? ?? ""
                return convertedString as String
            } catch let myJSONError {
                debugPrint(myJSONError)
                return ""
            }
        }
}

