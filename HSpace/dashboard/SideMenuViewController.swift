//
//  SideMenuViewController.swift
//  HelixSense
//
//  Created by DEEBA on 22.06.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {

    @IBAction func btnAsst(_ sender: UIButton) {
     let storyBoard: UIStoryboard = UIStoryboard(name: "MainSdeStoryboard", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "asstSelLcn") as! asstSelLcnViewController
                    self.present(newViewController, animated: true, completion: nil)
  /*let viewController:
                             UIViewController = UIStoryboard(
                                 name: "MainSdeStoryboard", bundle: nil
                             ).instantiateViewController(withIdentifier: "asstSelLcn") as! asstSelLcnViewController
                         let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                              //show window
                                              appDelegate.window?.rootViewController = viewController
        */
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
