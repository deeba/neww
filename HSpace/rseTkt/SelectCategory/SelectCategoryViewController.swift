//
//  SelectCategoryViewController.swift
//  AMTfm
//
//  Created by Serge Vysotsky on 04.06.2020.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import SQLite3

final class SelectCategoryViewController: UIViewController {
    let instanceOfUser = readWrite()
    var db:OpaquePointer? = nil
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchView: UIView!
    var ticketData: TicketData!
    var searchQuery = ""
    var categories = [ProblemCategory]()
    var completion: ((ProblemCategory) -> Void)?
    var CategrisArray:[String] =  Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        categories = [
            ProblemCategory(name: "Plumbing-Common"),
            ProblemCategory(name: "Lightning Exterior"),
            ProblemCategory(name: "Elevator/Lift"),
        ]
        
        for i in 0...100 {
            categories.append(ProblemCategory(name: "Problem \(i)"))
        }
        */
        poplateCategoriz()
       
    }
    func poplateCategoriz()
    {
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
                {
                  let queryStatementString = "SELECT DISTINCT(cat_name),cat_id from tbl_category;"
                   var queryStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                       SQLITE_OK {
                            //5F1!!!
                               // 2
                   
                    // sqlite3_bind_int(queryStatement, 1, (Int32(chsStrtMdl.idWO)))
                             // 2
                             while  sqlite3_step(queryStatement) == SQLITE_ROW {
                                      let stringNam = String(cString: sqlite3_column_text(queryStatement, 0))
                                let CatId = String(cString: sqlite3_column_text(queryStatement, 1))
                                categories.append(ProblemCategory(name: stringNam, Id: CatId))
                                     }
                      
                           }

                    sqlite3_finalize(queryStatement)
                    sqlite3_close(db)
                    db = nil
               }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.configNavigationBar(title: "Select a Location")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination = segue.destination as? SelectSubcategoryViewController, let selectedIndex = categoriesTableView.indexPathForSelectedRow?.row {
            ticketData.category = filteredCategories[selectedIndex]
            destination.ticketData = ticketData
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let completion = completion, let selectedIndex = categoriesTableView.indexPathForSelectedRow?.row {
            completion(filteredCategories[selectedIndex])
            return false
        }
        
        return true
    }
    
    @IBAction func showSearchView() {
        searchView.isHidden = false
        searchTextField.becomeFirstResponder()
    }
    
    @IBAction func closeSearchView() {
        searchView.isHidden = true
        searchTextField.resignFirstResponder()
        searchQuery = ""
        categoriesTableView.reloadData()
    }
}

extension SelectCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    var filteredCategories: [ProblemCategory] {
        searchQuery.isEmpty ? categories : categories.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCategories.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SelectCategoryCell.dequeue(from: tableView, for: indexPath)
        cell.categoryLabel.text = filteredCategories[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension SelectCategoryViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchQuery = textField.text ?? ""
        categoriesTableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
