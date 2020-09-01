//
//  gnrlPractizViewController.swift
//  HSpace
//
//  Created by DEEBA on 01.08.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class gnrlPractizViewController: UIViewController {
    @IBOutlet weak var lblSymptms: UILabel!
    var symptms: Bool!
let instanceOfUser = readWrite()
    @IBAction func btnSend(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "OccpyStoryboard", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "confrmOccpy") as! confrmOccpyViewController
        mainTabBarController.symptms = symptms
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(mainTabBarController, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.configNavigationBar(title: "Prescreen")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if symptms!
        {
            lblSymptms.text = "Symptoms found"
        }
        else
        {
            lblSymptms.text = "No Symptoms found"
        }
        LoaderSpin.shared.hideLoader()
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
