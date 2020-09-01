//
//  PickIssueTypeViewController.swift
//  AMTfm
//
//  Created by Serge Vysotsky on 04.06.2020.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
final class IssueTypeCell: UITableViewCell, ReusableView {
    @IBOutlet weak var issueTitleLabel: UILabel!
}

final class PickIssueTypeViewController: UIViewController {
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var issuesTableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    var issueTypes: [String] = []
    var completion: ((String) -> Void)?
    let instanceOfUser = readWrite()
    override func viewDidLoad() {
        super.viewDidLoad()
        issueTypes = [
            "Request",
            "Complaint",
            "Incident",
            "EHS"
        ]
        bottomView.transform = CGAffineTransform(translationX: 0, y: bottomView.frame.height)
        tableViewHeightConstraint.constant = CGFloat(issueTypes.count) * 44
        
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

extension PickIssueTypeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        issueTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = IssueTypeCell.dequeue(from: tableView, for: indexPath)
        cell.issueTitleLabel.text = issueTypes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let completion = self.completion
        let issue = issueTypes[indexPath.row]
        dismissSelf {
            completion?(issue)
        }
    }
}
