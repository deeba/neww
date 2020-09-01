//
//  demoDash.swift
//  HSpace
//
//  Created by DEEBA on 17.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class demoDash: UIViewController {
    
    let instanceOfUser = readWrite()
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtComp: UITextView!
    @IBOutlet weak var txtFd: FloatingLabelInput!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblSpace: UILabel!
        var tableViewRowArray: [HomeVCCellz] = [ .covidInfo]
        func registerCell() {
            tableView.register(UINib(nibName: "CovidInformationTableViewCell", bundle: nil), forCellReuseIdentifier: "CovidInformationTableViewCell")
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            // Hide the navigation bar for current view controller
            self.navigationController?.isNavigationBarHidden = true;
        }
        override func viewDidLoad() {
            super.viewDidLoad()
      self.lblSpace.text = "You are in " + " " + instanceOfUser.readStringData(key: "CompNamez")
      self.lblName.text = "Hello " +  instanceOfUser.readStringData(key: "employeeNamez")
            tableView.estimatedRowHeight = 440.0
            tableView.rowHeight = UITableView.automaticDimension
           registerCell()
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
    extension demoDash: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tableViewRowArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            switch tableViewRowArray[indexPath.row] {
          
            case .covidInfo:
                let cell = tableView.dequeueReusableCell(withIdentifier: "CovidInformationTableViewCell", for: indexPath) as! CovidInformationTableViewCell
                return cell
                
            }
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        
    }

    enum HomeVCCellz {
        case covidInfo
    }
