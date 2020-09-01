//
//  DateSelectViewController.swift
//  HelixSense
//
//  Created by DEEBA on 01.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import DropDown

class DateSelectViewController: UIViewController {
    let interNt = Internt()
    var tstDte = ""
    let instanceOfUser = readWrite()
    @IBOutlet weak var datePicker: UIDatePicker!
    var onDateSelect: ((Date)->Void)?
    @IBOutlet weak var btndte: UIButton!
    var maximumDate: Date?
    var minimumDate: Date?
    override func viewDidLoad() {
        super.viewDidLoad()
/*
               Loader.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let date = self.maximumDate {
                self.datePicker.maximumDate = date
        }
            if let date = self.minimumDate {
                self.datePicker.minimumDate = date
        }
        }
 */
    }
    
    
    @IBAction func onClickDone() {
    onDateSelect?(datePicker.date)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    self.tstDte = formatter.string(from: datePicker.date)
    self.instanceOfUser.writeAnyData(key: "chsnShftdte", value: self.tstDte )

    let vc = UIStoryboard(name: "addEqpmntStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ItemSelection") as! ItemSelectionViewController

    LoaderSpin.shared.showLoader(self)
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    APIClient_redesign.shared().getTokenz { status in
    LoaderSpin.shared.hideLoader()
    if status {
    APIClient_redesign.shared().getShftListAvailable(){ count in
    vc.items = availableshftListModl.ttlDis
    vc.type = .Types
    vc.selectionTitle = "Select a shift "
    vc.onItemSelect = { item in
    let arrsplitOut = item.components(separatedBy: " ")
    let shft = arrsplitOut[1].components(separatedBy: "(")
    let chsnShftId = availableshftListModl.id[find(value: shft[0], in: availableshftListModl.name)!]
    let chsnShftStart = availableshftListModl.planned_in[find(value: shft[0], in: availableshftListModl.name)!]
    let chsnShftEnd = availableshftListModl.planned_out[find(value: shft[0], in: availableshftListModl.name)!]
    self.instanceOfUser.writeAnyData(key: "chsnShftId", value: chsnShftId)
    self.instanceOfUser.writeAnyData(key: "chsnShftStart", value: chsnShftStart)
    self.instanceOfUser.writeAnyData(key: "chsnShftEnd", value: chsnShftEnd)
    self.instanceOfUser.writeAnyData(key: "chsnShft", value: shft[0])
    self.instanceOfUser.writeAnyData(key: "chsnShfttim", value: item.components(separatedBy: "(")[1])
    sleep(1)
    }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.window?.rootViewController = vc
    }
    }
    }
    }
    }
    
    @IBAction func onClickCancel() {
        let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
        mainTabBarController.modalPresentationStyle = .fullScreen
        self.present(mainTabBarController, animated: true, completion: nil)
    }
    
}
