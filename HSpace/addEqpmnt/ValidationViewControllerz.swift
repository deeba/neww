//
//  ValidationViewControllerz.swift
//  HSpace
//
//  Created by DEEBA on 20.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ValidationViewControllerz: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var sgmtCtrl: UISegmentedControl!
    @IBOutlet weak var commentsTextView: IQTextView!
    
    var userName: String!
    var data = Equipment()
    var spaceName: String!
    var onSuccess: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = String(format: Constants.ackTitle, userName ?? "", data.eqName ?? "", spaceName ?? "")
    }
    
    @IBAction func onClickCancel() {
        self.dismiss(animated: true)
    }
    
    @IBAction func onClickAck() {
        if sgmtCtrl.selectedSegmentIndex == 1, commentsTextView.text ?? "" == "" {
            Alertz.show("", "comments are mandatory if INVALID selected")
            return
        }
        APIClient.shared().writeData(data: data, cmnt: commentsTextView.text ?? "", valid: sgmtCtrl.selectedSegmentIndex == 0 ? "Valid" : "Invalid") { status in
            if status {
                self.onSuccess?()
                self.dismiss(animated: true)
            } else {
                Alertz.show("", "try again")
            }
        }
    }
}
