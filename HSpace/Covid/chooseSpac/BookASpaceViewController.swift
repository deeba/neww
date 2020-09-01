//
//  BookASpaceViewController.swift
//  HSpace
//
//  Created by DEEBA on 19.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class BookASpaceViewController: UIViewController {
    
    @IBOutlet weak var lbLcnz: UILabel!
    let instanceOfUser = readWrite()
    var db:OpaquePointer? = nil
    @IBOutlet weak var parentTblView: UITableView!
    @IBOutlet weak var nxtBtn: UIButton!
    @IBOutlet weak var childTblView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var validateLbl: UILabel!
    var lcny = ""
    var lcnpthy = ""
    var lcnidy = ""
    @IBAction func btnNxt(_ sender: UIButton) {
        if titleLbl.text == ""
         {
           showToast(message: "Please choose a location to report")
             }
        else
        {
            self.instanceOfUser.writeAnyData(key: "chsnSpace", value: titleLbl.text as Any)
            self.performSegue(withIdentifier: "confrmBkg", sender: nil)
           
             APIClient.shared().getToken { status in
                sleep(1)
             if status {
                APIClient.shared().confrmSpacBkg(id: self.idy, shftId: self.shftId, strt: self.strt) { id in
                        print(id)
                    }
                }
                
             }
            
            nxtBtn.isEnabled = false
            /*
            Loader.show()
            APIClient.shared().getTokenz
            {status in}
            APIClient.shared().dashBrdApi(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
            sleep(2)
            let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
            mainTabBarController.modalPresentationStyle = .fullScreen
            self.present(mainTabBarController, animated: true, completion: nil)
            //self.performSegue(withIdentifier: "rprtInciseg", sender: nil)
            */
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
     var childDetail = [SpaceDetails]()
     var parentDetail = [SpaceDetails(name: usrInfoModl.compName)]
       var selectedParent = 0
       var selectedChild = -1
    var idy  = ""
    var shftId = ""
    var strt = ""
    var endd = ""
    @IBOutlet weak var baseView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.instanceOfUser.writeAnyData(key: "chsnSpace", value: "")

      //  parentTblView.layer.borderWidth = 2.0
       // baseView.layer.borderWidth = 1.0
       // baseView.layer.borderColor = UIColor.gray.cgColor
     //   parentTblView.layer.borderColor = UIColor.gray.cgColor
        idy  = ""
        shftId = self.instanceOfUser.readStringData(key: "chsnShftId")
        strt = self.instanceOfUser.readStringData(key: "chsnShftStart")
        endd = self.instanceOfUser.readStringData(key: "chsnShftEnd")
       /*shftId = "6"
        strt = "2020-07-06 08:15:38"
        endd = "2020-07-27 21:30:00"
 */
        DbHandler.get_Space_Name(completion: { (spaces) in
            self.parentDetail =  spaces
            self.idy = spaces[0].id
            self.parentTblView.reloadData()
        })
        sleep(1)
        APIClient.shared().getToken { status in
            if status {
                
                DbHandler.get_Child_Of(id: self.idy,shftId: self.shftId,strt: self.strt,endd: self.endd, type: "") { arr in
                    self.childDetail = arr
                    self.childTblView.reloadData()
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
       // self.configNavigationBar(title: "Choose Space")
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

extension BookASpaceViewController: UITableViewDataSource, UITableViewDelegate {
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ChildDetailsCellx
            
                cell.nameLbl.text = childDetail[indexPath.row].name
            /*
                cell.editImg.isHidden = childDetail[indexPath.row].availablestatus
            cell.editImg.addGestureRecognizer(GestureRecognizerWithClosure.init(action: {
                print("Edit icon clicked", self.childDetail[indexPath.row].name ?? "", self.childDetail[indexPath.row].displayName ?? "")
            }))
 */
              if childDetail[indexPath.row].availablestatus! == "1" && childDetail[indexPath.row].statts ==  "Ready"
              {
               // cell.backgroundColor = UIColor.green
                cell.selectionBtn.isHidden = false
            }
            else
            {
               // cell.backgroundColor = UIColor.red
                cell.selectionBtn.isHidden = true
            }
                

                let enable = parentDetail[min(selectedParent + 1, parentDetail.count - 1)].id == childDetail[indexPath.row].id
                cell.selectionBtn.setImage(enable ? Constants.Image.radioOn : Constants.Image.radioOff, for: .normal)
            
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ParentDetailsCellx
        cell.nameLbl.text = parentDetail[indexPath.row].name
        cell.typeImg.image = UIImage(named: parentDetail[indexPath.row].type ?? "global") ?? #imageLiteral(resourceName: "global")
        /*
        cell.editImg.isHidden = indexPath.row == 0
        cell.editImg.addGestureRecognizer(GestureRecognizerWithClosure.init(action: {
            print("Edit icon clicked", self.parentDetail[indexPath.row].name ?? "", self.parentDetail[indexPath.row].displayName ?? "")
        }))
        */
        cell.contentView.backgroundColor = indexPath.row == selectedParent ? .white : Constants.Color.lightGray
        
        childDetail.removeAll()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.tag == 0 else {
            let data = childDetail[indexPath.row]
            if data.haveChilds
            {//dont allow parent to b booked
                nxtBtn.isHidden = true
            }
            else
                {
                    nxtBtn.isHidden = false
                }
                 
            //if data.haveChilds {
                parentDetail = Array(parentDetail.prefix(selectedParent + 1))
                parentDetail.append(data)
                selectedParent += 1
                selectedChild = indexPath.row
                    idy = data.id
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
            titleLbl.text = data.displayName
            DbHandler.get_Space_Name { arr in
                self.childDetail = arr
                self.childTblView.reloadData()
            }
        } else {
            titleLbl.text = data.name
            //titleLbl.text = String(format: "%@ (%@)", data.name, data.displayName)
            DbHandler.get_Child_Of(id: data.id,shftId: shftId,strt: strt,endd: endd, type: "") { arr in
                self.childDetail = arr
                self.childTblView.reloadData()
            }
        }
        let index = selectedParent
        selectedParent = indexPath.row
        selectedChild = -1
        parentTblView.reloadRows(at: [indexPath, IndexPath(row: index, section: 0)], with: .none)
        childTblView.reloadData()
    }
}

class ParentDetailsCellx: UITableViewCell {
    @IBOutlet weak var typeImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var editImg: UIImageView!
}

class ChildDetailsCellx: UITableViewCell {
    @IBOutlet weak var selectionBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var editImg: UIImageView!
}
