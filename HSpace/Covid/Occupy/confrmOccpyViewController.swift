//
//  confrmOccpyViewController.swift
//  HSpace
//
//  Created by DEEBA on 01.08.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class confrmOccpyViewController: UIViewController {
    let instanceOfUser = readWrite()
    var symptms: Bool!
    @IBOutlet weak var lblSymp: UILabel!
    @IBAction func btnClse(_ sender: UIButton) {
        let vc = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil).instantiateViewController(withIdentifier: "tabBarStory") 
        LoaderSpin.shared.showLoader(self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                APIClient_redesign.shared().getTokenz
                   {status in
               APIClient_redesign.shared().getPrescreenDon(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz")) { cnt in
               LoaderSpin.shared.hideLoader()
                 if cnt {
                  }
                  }
                }
                  }
        sleep(2)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = vc
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if symptms!
        {
            lblSymp.text = "Symptoms found"
        }
        else
        {
            lblSymp.text = "No Symptoms found"
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.configNavigationBar(title: "Prescreen")
    }
}
