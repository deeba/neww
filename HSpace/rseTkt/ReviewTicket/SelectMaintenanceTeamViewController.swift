//
//  SelectMaintenanceTeamViewController.swift
//  AMTfm
//
//  Created by Serge Vysotsky on 04.06.2020.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
final class MaintTypeCell: UITableViewCell, ReusableView {
    @IBOutlet weak var issueTitleLabel: UILabel!
}

final class SelectMaintenanceTeamViewController: UIViewController {
    let instanceOfUser = readWrite()
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var issuesTableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    var completion: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.transform = CGAffineTransform(translationX: 0, y: bottomView.frame.height)
        tableViewHeightConstraint.constant = CGFloat(tmNamesModl.TmNam.count) * 44
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.bottomView.transform = .identity
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    
   
    @IBAction private func dismissSelf() {
        dismissSelf(completion: nil)
    }
    
    private func dismissSelf(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomView.transform = CGAffineTransform(translationX: 0, y: self.bottomView.frame.height)
            self.view.backgroundColor = .clear
        }) { _ in
            self.dismiss(animated: false, completion: completion)
        }
    }
}

extension SelectMaintenanceTeamViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tmNamesModl.TmNam.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MaintTypeCell.dequeue(from: tableView, for: indexPath)
        cell.issueTitleLabel.text = tmNamesModl.TmNam[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let completion = self.completion
        let issue = tmNamesModl.TmNam[indexPath.row]
        instanceOfUser.writeAnyData(key: "selTemId", value: tmNamesModl.TmId[indexPath.row])
        dismissSelf {
            completion?(issue)
        }
    }
}

