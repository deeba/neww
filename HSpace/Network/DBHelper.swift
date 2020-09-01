//
//  DBHelper.swift
//  HSpace
//
//  Created by DEEBA on 27.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
     //   createTable()
    }

    let dbPath: String = "db_ifmp.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
 
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS tbl_checklist(shift_id TEXT,checklist_id TEXT,checklist_type TEXT,question TEXT,suggestion_array TEXT,answer TEXT,is_submitted TEXT,header_group TEXT,expected_ans TEXT,sync_status Bool);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Checklist table created.")
            } else {
                print("Checklist table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
  
    func insert(shiftId: String, checklistId: String, checklistType: String, question: String, suggestionArray: String, answer: String, isSubmitted: String, headerGroup: String, expectedAns: String, syncStatus: Int)
    {
        let checklist = read()
        /*
        for p in checklist
        {
            if p.checklistId == checklistId
            {
                return
            }
        }
        */
        let insertStatementString = "INSERT INTO tbl_checklist (shift_id, checklist_id, checklist_type, question, suggestion_array, answer, is_submitted, header_group, expected_ans, sync_status) VALUES (?, ?, ?,?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (shiftId as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (checklistId as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (checklistType as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (question as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (suggestionArray as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (answer as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (isSubmitted as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, (headerGroup as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 9, (expectedAns as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 10, Int32(syncStatus))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [symptmsChecklist] {
        let queryStatementString = "SELECT * FROM tbl_checklist;"
        var queryStatement: OpaquePointer? = nil
        var chklist : [symptmsChecklist] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let shiftId = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let checklistId = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let checklistType = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                 let question = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                 let suggestionArray = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                 let answer = String(describing: "no")
                 let isSubmitted = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                 let headerGroup = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                 let expectedAns = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
                 let syncStatus = sqlite3_column_int(queryStatement, 9)
//                chklist.append(symptmsChecklist(shiftId: shiftId, checklistId: checklistId, checklistType: checklistType, question: question, suggestionArray: suggestionArray, answer: answer, isSubmitted: isSubmitted, headerGroup: headerGroup, expectedAns: expectedAns, syncStatus: Int(syncStatus)))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return chklist
    }

    
}
