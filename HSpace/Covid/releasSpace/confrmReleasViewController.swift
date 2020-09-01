//
//  confrmReleasViewController.swift
//  HSpace
//
//  Created by DEEBA on 25.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
class confrmReleasViewController: UIViewController {
    let instanceOfUser = readWrite()
    @IBOutlet weak var titleLbl: UILabel!
    
    var userName: String!
    var data = Equipment()
    var spaceName: String!
    var onSuccess: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let ackTitle = "Release the  %@ assigned to You for %@  Shift %@"
        titleLbl.text = String(format: ackTitle, curntSHift.space_name , curntSHift.planned_in , curntSHift.shift_name )
        */
             // create the alert
            let ackTitle = "Release the  %@ assigned to You for %@  Shift %@"
           let titleLbl  = String(format: ackTitle, curntSHift.space_name , curntSHift.planned_in , curntSHift.shift_name )
                  let alert = UIAlertController(title: "Release Workspace", message:titleLbl, preferredStyle: UIAlertController.Style.alert)
                  
                  // add the actions (buttons)
                  alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                  alert.addAction(UIAlertAction.init(title: "Confirm", style: .default, handler: { (action) in
                      APIClient.shared().getTokenz
                             {status in}
                          APIClient.shared().writeReleas(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz")){ _ in
                                 }
                             sleep(1)
                             APIClient.shared().logoutAPI(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"))
                             
                             LoaderSpin.shared.showLoader(self)
                             APIClient.shared().getToken { status in
                                        if status {
                                            APIClient.shared().dashBrdApi()
                                          }
                                        }
                             sleep(2)
                             let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                             let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
                             mainTabBarController.modalPresentationStyle = .fullScreen
                             self.present(mainTabBarController, animated: true, completion: nil)
                                           
                    //  self.switchToMonthView()
                      
                  }))
        
    }
    
    @IBAction func onClickCancel() {
        self.dismiss(animated: true)
    }
    
    @IBAction func onClickAck() {
        APIClient.shared().getTokenz
        {status in}
     APIClient.shared().writeReleas(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz")){ _ in
            }
        sleep(1)
        APIClient.shared().logoutAPI(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"))
        
        LoaderSpin.shared.showLoader(self)
        APIClient.shared().getToken { status in
                   if status {
                       APIClient.shared().dashBrdApi()
                     }
                   }
        sleep(2)
        let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
        mainTabBarController.modalPresentationStyle = .fullScreen
        self.present(mainTabBarController, animated: true, completion: nil)
                      
    }
}
