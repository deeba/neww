//
//  SelectSubcategoryViewController.swift
//  AMTfm
//
//  Created by Serge Vysotsky on 04.06.2020.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import SQLite3

final class SelectSubcategoryViewController: UIViewController {
    let instanceOfUser = readWrite()
    var db:OpaquePointer? = nil
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subcategoriesTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchView: UIView!
    var ticketData: TicketData!
    var searchQuery = ""
    var categories = [ProblemSubcategory]()
    var completion: ((ProblemSubcategory) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        poplateSubCategoriz()
        /*
        categories = [
            ProblemSubcategory(name: "Floor Drains", priority: .low, duration: 60 * 60 * 10 + 60 * 11),
            ProblemSubcategory(name: "Leaks", priority: .normal, duration: 60 * 60 * 13 + 60 * 12),
            ProblemSubcategory(name: "Sewage", priority: .high, duration: 60 * 60 * 6 + 60 * 33),
        ]
        
        for i in 0...100 {
            categories.append(ProblemSubcategory(name: "Subproblem \(i)", priority: .high, duration: 60 * 60 * 6 + 60 * 33))
        }
         
        categoryLabel.text = ticketData.category?.name
 */
    }
    func poplateSubCategoriz()
    {
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
                {
                  let queryStatementString = "SELECT cat_sub_name,priority,sla_timer,cat_sub_id from tbl_category where cat_name=?;"
                   var queryStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                       SQLITE_OK {
                            //5F1!!!
                               // 2
                    sqlite3_bind_text(queryStatement, 1,(ticketData.category!.name  as NSString).utf8String, -1, nil)
                    // sqlite3_bind_int(queryStatement, 1, (Int32(chsStrtMdl.idWO)))
                             // 2
                             while  sqlite3_step(queryStatement) == SQLITE_ROW {
                                      let stringNam = String(cString: sqlite3_column_text(queryStatement, 0))
                                      var stringPrior = String(cString: sqlite3_column_text(queryStatement, 1))
                                      let stringSla = String(cString: sqlite3_column_text(queryStatement, 2))
                                      let stringId = String(cString: sqlite3_column_text(queryStatement, 3))
                                      let myDouble = Double(stringSla)
                                        if stringPrior == "0" {
                                            categories.append(ProblemSubcategory(name: stringNam, priority: .Low, duration:  60 * 60 * myDouble! ,Id: stringId ))
                                                }
                                        else if stringPrior == "1" {
                                            categories.append(ProblemSubcategory(name: stringNam, priority: .Normal, duration: 60 * 60 * myDouble!,Id: stringId))
                                        }
                                        else if stringPrior == "2" {
                                            categories.append(ProblemSubcategory(name: stringNam, priority: .High, duration: 60 * 60 * myDouble! ,Id: stringId))
                                        }
                                        else if stringPrior == "3" {
                                            categories.append(ProblemSubcategory(name: stringNam, priority: .Breakdown, duration: 60 * 60 * myDouble! ,Id: stringId))
                                        }
                                
                                      
                                        }
                      
                           }

                    sqlite3_finalize(queryStatement)
                    sqlite3_close(db)
                    db = nil
               }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination = segue.destination as? ReviewTicketViewController, let subcategoryIndex = subcategoriesTableView.indexPathForSelectedRow?.row {
            ticketData.subcategory = filteredCategories[subcategoryIndex]
            destination.ticketData = ticketData
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.configNavigationBar(title: "Select a Location")
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let completion = completion, let selectedIndex = subcategoriesTableView.indexPathForSelectedRow?.row {
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
        subcategoriesTableView.reloadData()
    }
}

extension SelectSubcategoryViewController: UITableViewDelegate, UITableViewDataSource {
    var filteredCategories: [ProblemSubcategory] {
        searchQuery.isEmpty ? categories : categories.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SelectSubcategoryCell.dequeue(from: tableView, for: indexPath)
        let subcategory = filteredCategories[indexPath.row]
        cell.nameLabel.text = subcategory.name
        cell.priorityLabel.text = subcategory.priority.title
        cell.priorityColorView.backgroundColor = subcategory.priority.color
        cell.timeLabel.text = subcategory.formattedTime
        //cell.timeLabel.text = subcategory.duration
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ticketData.subcategory = filteredCategories[indexPath.row]
    }
}

extension SelectSubcategoryViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchQuery = textField.text ?? ""
        subcategoriesTableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
