//
//  rprtIssuSpaceViewController.swift
//  HSpace
//
//  Created by DEEBA on 29.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import UIKit
import SQLite3

class rprtIssuSpaceViewController: UIViewController {
        
        @IBOutlet weak var lbLcnz: UILabel!
        let instanceOfUser = readWrite()
        var db:OpaquePointer? = nil
        @IBOutlet weak var parentTblView: UITableView!
        @IBOutlet weak var childTblView: UITableView!
        @IBOutlet weak var titleLbl: UILabel!
        @IBOutlet weak var validateLbl: UILabel!
        var lcny = ""
        var lcnpthy = ""
        var lcnidy = ""
        @IBAction func btnNxt(_ sender: UIButton) {
            if lbLcnz.text == ""
             {
                showToast(message: "Please choose a location to report")
                 }
            else
            {
                
                self.performSegue(withIdentifier: "rprtInciseg", sender: nil)
            }

        }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            if (segue.identifier == "rprtInciseg") {
                let vc = segue.destination as! rprtIncidntViewController
                vc.lcn = lcnpthy
                vc.lcnPth = lcny
                vc.lcnidz = lcnidy
            }
            
            }
        var childDetail  = DbHandler.getSpaceName()
        var parentDetail = [SpaceDetails(displayName: usrInfoModl.compName)]
        var selectedParent = 0
        var selectedChild = -1
        override func viewDidLoad() {
            super.viewDidLoad()
            instanceOfUser.writeAnyData(key: "lcnId", value: "")
            instanceOfUser.writeAnyData(key: "LcnParent", value: "")
            instanceOfUser.writeAnyData(key: "selLocn", value: "")
            instanceOfUser.writeAnyData(key: "selLocnId", value: "")
            instanceOfUser.writeAnyData(key: "lcnSel", value: "")
                APIClient.shared().getToken { status in
                    if status {
                        APIClient.shared().getCategory { _ in }
                        APIClient.shared().getUNSPSC { _ in }
                        APIClient.shared().getLocation { _ in }
                        APIClient.shared().getTeam { _ in }
                        APIClient.shared().getPartner { _ in }
                    }
                }
            }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.configNavigationBar(title: "Select a Location")
        }
        
        @IBAction func onClickBack(_ sender: Any) {
             self.dismiss(animated: true, completion: nil)    }
        func showToast(message: String) {
                let toastLabel = UITextView(frame: CGRect(x: self.view.frame.size.width/16, y: self.view.frame.size.height-150, width: self.view.frame.size.width * 7/8, height: 50))
                toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                toastLabel.textColor = UIColor.white
                toastLabel.textAlignment = .center;
                toastLabel.text = "   \(message)   "
                toastLabel.alpha = 1.0
                toastLabel.layer.cornerRadius = 10;
                toastLabel.clipsToBounds  =  true
                toastLabel.font = UIFont(name: (toastLabel.font?.fontName)!, size: 16)
                toastLabel.center.x = self.view.frame.size.width/2
                self.view.addSubview(toastLabel)
                UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
                    toastLabel.alpha = 0.0
                }, completion: {(isCompleted) in
                    toastLabel.removeFromSuperview()
                })
        }
        
    }

    extension rprtIssuSpaceViewController: UITableViewDataSource, UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 20
        }
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let view = UIView()
            view.backgroundColor = .clear
            return view
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tableView.tag == 0 ? parentDetail.count : childDetail.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            guard tableView.tag == 0 else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ChildDetailsCellRprtIssu
                cell.nameLbl.text = childDetail[indexPath.row].name
                cell.editImg.isHidden = true
                /*
                cell.editImg.isHidden = childDetail[indexPath.row].haveChilds
                cell.editImg.addGestureRecognizer(GestureRecognizerWithClosure.init(action: {

                    let storyBoard: UIStoryboard = UIStoryboard(name: "MainSdeStoryboard", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "validateAsst") as! validateAsstViewController
                    newViewController.selctdLcn = self.childDetail[indexPath.row].name ?? ""
                    newViewController.selctdPath = self.childDetail[indexPath.row].displayName ?? ""
                    newViewController.selctdId = self.childDetail[indexPath.row].id ?? ""
                    
                    self.present(newViewController, animated: true, completion: nil)
                    print("Edit icon clicked", self.childDetail[indexPath.row].name ?? "", self.childDetail[indexPath.row].displayName ?? "")
                }))
                */
                let enable = parentDetail[min(selectedParent + 1, parentDetail.count - 1)].id == childDetail[indexPath.row].id
                cell.selectionBtn.setImage(enable ? Constants.Image.radioOn : Constants.Image.radioOff, for: .normal)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ParentDetailsCellRprtIssu
            cell.nameLbl.text = parentDetail[indexPath.row].name
            cell.typeImg.image = UIImage(named: parentDetail[indexPath.row].type ?? "Chambers") ?? #imageLiteral(resourceName: "building")
            cell.editImg.isHidden = true
            /* cell.editImg.isHidden = indexPath.row == 0
           
            cell.editImg.addGestureRecognizer(GestureRecognizerWithClosure.init(action: {
                let storyBoard: UIStoryboard = UIStoryboard(name: "MainSdeStoryboard", bundle: nil)
                               let newViewController = storyBoard.instantiateViewController(withIdentifier: "validateAsst") as! validateAsstViewController
                               newViewController.selctdLcn = self.parentDetail[indexPath.row].name ?? ""
                                              newViewController.selctdPath = self.parentDetail[indexPath.row].displayName ?? ""
                                              newViewController.selctdId = self.parentDetail[indexPath.row].id ?? ""
                               self.present(newViewController, animated: true, completion: nil)
                print("Edit icon clicked", self.parentDetail[indexPath.row].name ?? "", self.parentDetail[indexPath.row].displayName ?? "")
            }))
            */
            cell.contentView.backgroundColor = indexPath.row == selectedParent ? .white : Constants.Color.lightGray
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            guard tableView.tag == 0 else {
                let data = childDetail[indexPath.row]
                //if data.haveChilds {
                    parentDetail = Array(parentDetail.prefix(selectedParent + 1))
                    parentDetail.append(data)
                    selectedParent += 1
                   selectedChild = indexPath.row
                    childTblView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.parentTblView.reloadData()
                        self.tableView(self.parentTblView, didSelectRowAt: IndexPath(row: self.selectedParent, section: 0))
                    }
                //}
                return
            }
            
            let data = parentDetail[indexPath.row]
            
            if indexPath.row == 0 {
                /*
                APIClient.getValidationCount { count in
                    self.validateLbl.text = count
                }
                */
               // titleLbl.text = "Selected workspace :  " + data.name
                lbLcnz.text  = "Selected Location :  " + data.displayName
                lcny = data.displayName
                lcnpthy = ""
                lcnidy = ""
                childDetail = DbHandler.getSpaceName()
            } else {
                /*
                APIClient.getValidationCount(displayName: data.displayName) { count in
                    self.validateLbl.text = count
                }
                */
                
                titleLbl.text = "Selected workspace :  " + data.name
                lbLcnz.text  = "Selected Location :  " + data.displayName
                lcny = data.displayName
                lcnpthy = data.name
                lcnidy = data.id
                childDetail = DbHandler.getChildOf(parentId: data.id)
            }
            let index = selectedParent
            selectedParent = indexPath.row
            selectedChild = -1
            parentTblView.reloadRows(at: [indexPath, IndexPath(row: index, section: 0)], with: .none)
            childTblView.reloadData()
        }
    }

    class ParentDetailsCellRprtIssu: UITableViewCell {
        @IBOutlet weak var typeImg: UIImageView!
        @IBOutlet weak var nameLbl: UILabel!
        @IBOutlet weak var editImg: UIImageView!
    }

    class ChildDetailsCellRprtIssu: UITableViewCell {
        @IBOutlet weak var selectionBtn: UIButton!
        @IBOutlet weak var nameLbl: UILabel!
        @IBOutlet weak var editImg: UIImageView!
    }

