//
//  rseTkyViewController.swift
//  AMTfm
//
//  Created by DEEBA on 30.05.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class rseTkyViewController: UIViewController {
    @IBOutlet weak var btnNfz: UIButton!
    
    @IBAction func btnGoBck(_ sender: UIButton) {
            let viewController:
                UIViewController = UIStoryboard(
                    name: "HomeStoryboard", bundle: nil
                ).instantiateViewController(withIdentifier: "HomeStory") as! HomeScreenz
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                 //show window
                                 appDelegate.window?.rootViewController = viewController
       
                     
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnNFC(_ sender: UIButton) {
       //  if let button = sender as? UIButton {
          //         button.backgroundColor = UIColor.gray
        //   }
    }

}
