//
//  LgOutViewController.swift
//  HSpace
//
//  Created by DEEBA on 15.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class LgOutViewController: UIViewController {

    @IBAction func btnOk() {
        exit(0);
    }
    
    @IBAction func btnCancel() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                              let newViewController = storyBoard.instantiateViewController(withIdentifier: "cvdDash") as! cvdDashbrdViewController
                              self.present(newViewController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
               // .instantiatViewControllerWithIdentifier() returns AnyObject!
               // this must be downcast to utilize it

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
