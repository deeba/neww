//
//  MainSdeViewController.swift
//  HelixSense
//
//  Created by DEEBA on 22.06.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class MainSdeViewController: UIViewController {

    let instanceOfUser = readWrite()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let temp = instanceOfUser.readStringData(key: "CompLogoz").components(separatedBy: ",")
             var dataDecoded : Data = Data(base64Encoded: temp[0], options: .ignoreUnknownCharacters)!
            var decodedimage = UIImage(data: dataDecoded)
             
           //  dataDecoded = resize(image: decodedimage!)!
             
             decodedimage = UIImage(data: dataDecoded)
             //   self.imgVw.image = decodedimage
             //// Do any additional setup after loading the view.
             self.instanceOfUser.writeAnyData(key: "CompLogoz", value: "")
        print("ok")
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
                  let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: .done, target: self, action: #selector(onClickMenu))
              leftBarButtonItem.tintColor = .red
              self.navigationItem.leftBarButtonItem  = leftBarButtonItem
              }

              override func viewWillAppear(_ animated: Bool) {
                  super.viewWillAppear(animated)
                  self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1)
                  self.navigationController?.setNavigationBarHidden(false, animated: false)
              }

              @objc func onClickMenu() {
                  SJSwiftSideMenuController.toggleLeftSideMenu()
              }
              
          }
