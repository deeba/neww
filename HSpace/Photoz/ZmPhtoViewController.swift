//
//  ZmPhtoViewController.swift
//  AMTfm
//
//  Created by DEEBA on 27.05.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class ZmPhtoViewController: UIViewController {
    let instanceOfUser = readWrite()
    @IBOutlet weak var ImgVw: UIImageView!
    @IBAction func btnGoBac(_ sender: UIButton) {
        let viewController:
                                      UIViewController = UIStoryboard(
                                          name: "phtoLstStoryboard", bundle: nil
                                      ).instantiateViewController(withIdentifier: "phtoLstStory") as! phtoLstViewController
                                      // .instantiatViewControllerWithIdentifier() returns AnyObject!
                                      // this must be downcast to utilize it

                                      let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                      //show window
                                      appDelegate.window?.rootViewController = viewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataDecoded : Data = Data(base64Encoded: self.instanceOfUser.readStringData(key: "ImagSel"), options: .ignoreUnknownCharacters)!
        let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
        ImgVw.image = decodedimage
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
