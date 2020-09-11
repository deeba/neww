//
//  OccpyViewController.swift
//  HSpace
//
//  Created by DEEBA on 15.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class OccpyViewController: UIViewController {
    let instanceOfUser = readWrite()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.configNavigationBar(title: "PreScreen ")
    }
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }

    @IBAction func btnSymp(_ sender: UIButton) {
      let storyboard = UIStoryboard(name: "OccpyStoryboard", bundle: nil)
      let mainTabBarController = storyboard.instantiateViewController(identifier: "symptomsLstStory")
      self.navigationController?.isNavigationBarHidden = true
      self.navigationController?.pushViewController(mainTabBarController, animated: true)
    }
    
    @IBAction func btnGo(_ sender: UIButton) {
                                          DispatchQueue.main.sync {
                                               
                                               LoaderSpin.shared.showLoader(self)
                                                let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                                                let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
                                                self.navigationController?.isNavigationBarHidden = true
                                                self.navigationController?.pushViewController(mainTabBarController, animated: true)
        //                                        mainTabBarController.modalPresentationStyle = .fullScreen
        //                                        self.present(mainTabBarController, animated: true, completion: nil)
                                            }
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
