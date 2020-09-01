//
//  LogOutViewController.swift
//  HSpace
//
//  Created by DEEBA on 03.08.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class LogOutViewController: UIViewController {
let instanceOfUser = readWrite()
    override func viewDidLoad() {
        super.viewDidLoad()
        APIClient_redesign.shared().getTokenz { status in
               sleep(1)
               APIClient.shared().logoutAPI(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"))
        }
        exit(0)
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
