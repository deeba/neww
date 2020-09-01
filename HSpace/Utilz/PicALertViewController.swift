//
//  AlertViewController.swift
//  Custom Alerts
//satheesh@dcs.kf.in
//  Created by Kyle Lee on 2/13/19.
//  Copyright © 2019 Kilo Loco. All rights reserved.
//

import UIKit

class PicALertViewController: UIViewController {

    @IBAction func btnOk(_ sender: UIButton) {
    }
    @IBAction func butN(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func butS(_ sender: Any) {
            
        let viewController:
                              UIViewController = UIStoryboard(
                                  name: "PhotoStoryboard", bundle: nil
                              ).instantiateViewController(withIdentifier: "phtoStory") as! PhotoViewController
                              // .instantiatViewControllerWithIdentifier() returns AnyObject!
                              // this must be downcast to utilize it

                              let appDelegate = UIApplication.shared.delegate as! AppDelegate
                              //show window
                              appDelegate.window?.rootViewController = viewController
            }
    
    
    @IBOutlet weak var Img: UIImageView!
    var buttonAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    func setupView() {
        
       
    }
    
   
    
}
