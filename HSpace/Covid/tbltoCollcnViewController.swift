//
//  tbltoCollcnViewController.swift
//  HSpace
//
//  Created by DEEBA on 10.08.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class tbltoCollcnViewController: UIViewController {
    var spaceId: Int!
    var spaceName: String!
    @IBOutlet weak var parentCollectionView: UICollectionView!{
    didSet{
        settingServiceCollectionView()
    }
         }
    
    @IBOutlet weak var childTblView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var nxtBtn: UIButton!
    @IBOutlet weak var validateLbl: UILabel!
    @IBAction func btnNxt(_ sender: UIButton) {
        if titleLbl.text == ""
         {
           showToast(message: "Please choose a location to report")
             }
        else
        {

          self.instanceOfUser.writeAnyData(key: "chsnSpace", value: self.titleLbl.text as Any)
              let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
              let mainTabBarController = storyboard.instantiateViewController(identifier: "cofrmScreenaftrQR") as! cofrmScreenaftrQRViewController
              self.navigationController?.isNavigationBarHidden = false
                    mainTabBarController.spacebkdId = self.idy
            self.nxtBtn.isEnabled = false
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
                          //show window
            appDelegate.window?.rootViewController = mainTabBarController
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
    let instanceOfUser = readWrite()
    var db:OpaquePointer? = nil
    var lcny = ""
    var lcnpthy = ""
    var lcnidy = ""
    var childDetail = [SpaceDetails]()
    var parentDetail = [SpaceDetails(name: usrInfoModl.compName)]
    var selectedParent = 0
    var selectedChild = -1
    var selectedLocation = ""
   
    var idy  = ""
    var shftId = ""
    var strt = ""
    var endd = ""
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "rprtInciseg") {
            let vc = segue.destination as! rprtIncidntViewController
            vc.lcn = lcnpthy
            vc.lcnPth = lcny
            vc.lcnidz = lcnidy
        }
        
        }
    */
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
    private func settingServiceCollectionView(){
            
            let cellSize = CGSize(width:70 , height:70)
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal //.vertical
            layout.itemSize = cellSize
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            //         layout.minimumLineSpacing = 1.0
            //         layout.minimumInteritemSpacing = 1.0
        parentCollectionView.backgroundColor = UIColor.white
            parentCollectionView.allowsMultipleSelection = false
            parentCollectionView.allowsSelection = true
            //parentCollectionView.setCollectionViewLayout(layout, animated: true)
        }
    func getSpaceName(completion: @escaping ([SpaceDetails]) -> Void) {

    var values = [SpaceDetails]()
    values.append(SpaceDetails.init(id: String(spaceId ),
                                                           name: spaceName ,
                                                           displayName: spaceName ,
                                                           haveChilds: true))
    completion(values)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.instanceOfUser.writeAnyData(key: "chsnSpace", value: "")
        idy  = ""
               shftId = self.instanceOfUser.readStringData(key: "chsnShftId")
               strt = self.instanceOfUser.readStringData(key: "chsnShftStart")
               endd = self.instanceOfUser.readStringData(key: "chsnShftEnd")
        self.getSpaceName(completion: { (spaces) in
            self.parentDetail =  spaces
            self.idy = spaces[0].id
           //print("bef",self.idy)
            self.parentCollectionView.reloadData()
        })
        sleep(1)
        APIClient_redesign.shared().getTokenz { status in
            if status {
                
                DbHandler.get_Child_Of(id: self.idy,shftId: self.shftId,strt: self.strt,endd: self.endd,type: "") { arr in
                    self.childDetail = arr
                    self.childTblView.reloadData()
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.configNavigationBar(title: "Choose a Space")
    }
    override func viewWillLayoutSubviews() {
         let width = self.view.frame.width
         let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 40, width: width, height: 44))
         self.view.addSubview(navigationBar);
         let navigationItem = UINavigationItem(title: "Book a Space")
         navigationItem.leftBarButtonItem = UIBarButtonItem(
             image: UIImage(named: "Back"),
             style: .plain,
             target: self,
             action: #selector(selectorX)
         )
         navigationBar.setItems([navigationItem], animated: false)
      }
     @objc func selectorX() {
       let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
       let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
       mainTabBarController.modalPresentationStyle = .fullScreen
       self.present(mainTabBarController, animated: true, completion: nil)
    }
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension tbltoCollcnViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parentDetail.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        let cell = parentCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ParentDetailsCelltbltoCollcn
        
        var img = "global"
         for i in ["Zone", "Row"] {
                   if parentDetail[indexPath.row].name.contains(i) {
                       img = i
                       break
                   }
               }
        cell.typeImg.image = UIImage(named: img)
        if indexPath.row == 0 {
            cell.nameLbl.text = usrInfoModl.compName
        }
        else {
        cell.nameLbl.text = parentDetail[indexPath.row].name
          }
        cell.layer.cornerRadius=10 //set corner radius here
             cell.layer.borderColor = UIColor.gray.cgColor
             cell.layer.borderWidth = 1
           //   cell.typeImg.image = UIImage(named: parentDetail[indexPath.row].type ?? "Floor Ground") ?? UIImage(named: parentDetail[indexPath.row].type ?? "Floor Ground")
           //   cell.typeImg.image = UIImage(named: parentDetail[indexPath.row].type ?? "global") ?? #imageLiteral(resourceName: "floor")
        //     cell.editImg.isHidden = true
         cell.layer.cornerRadius=10 //set corner radius here
         cell.layer.borderColor = UIColor.darkGray.cgColor
         cell.layer.borderWidth = 2
             cell.layer.borderColor = indexPath.row == selectedParent ?
                 #colorLiteral(red: 0, green: 0.3774753511, blue: 0.8284870982, alpha: 1) :
                 #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
      
        return cell
    }
    
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    nxtBtn.isHidden = true
        
        let data = parentDetail[indexPath.row]
    /*
        if indexPath.row == 0 {
            titleLbl.text = data.displayName
            DbHandler.get_Space_Name { arr in
                self.childDetail = arr
                self.childTblView.reloadData()
            }
        } else {
            */
            titleLbl.text = selectedLocation
    DbHandler.get_Child_Of(id: data.id,shftId: shftId,strt: strt,endd: endd, type: "") { arr in
                if data.haveChilds
                {//dont allow parent to b booked
                    self.nxtBtn.isHidden = true
                }
                else
                {
                    self.nxtBtn.isHidden = false
                }
                self.childDetail = arr
                self.childTblView.reloadData()
               // print(data.id)
            //}
        }
        let index = selectedParent
        selectedParent = indexPath.row
        selectedChild = -1
        parentCollectionView.reloadData()      //parentCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        childTblView.reloadData()
        self.view.layoutIfNeeded()
    }
}
extension tbltoCollcnViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ChildDetailsCelltbltoCollcn
            
            cell.nameLbl.text = childDetail[indexPath.row].name
         //   cell.editImg.isHidden = childDetail[indexPath.row].availablestatus
            if childDetail[indexPath.row].availablestatus! == "true" && childDetail[indexPath.row].statts ==  "Ready"
          {
          //  cell.backgroundColor = UIColor.green
            
            cell.cntrImag.isHidden = false
            cell.lblCnt.isHidden = false
            cell.selectionBtn.isHidden = false
            cell.lblCnt.text =  (childDetail[indexPath.row].countt as Any as! String)
        }
        else
        {
         //   cell.backgroundColor = UIColor.red
            cell.cntrImag.isHidden = true
            cell.lblCnt.isHidden = true
            cell.selectionBtn.isHidden = true
        }
          /*  cell.editImg.addGestureRecognizer(GestureRecognizerWithClosure.init(action: {
                print("Edit icon clicked", self.childDetail[indexPath.row].name ?? "", self.childDetail[indexPath.row].displayName ?? "")
            }))*/

        let enable = indexPath.row == selectedChild//parentDetail[min(selectedParent + 1, parentDetail.count - 1)].id == childDetail[indexPath.row].id
            cell.selectionBtn.setImage(enable ? Constants.Image.radioOn : Constants.Image.radioOff, for: .normal)
        

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        nxtBtn.isHidden = true
        let data = childDetail[indexPath.row]
        if data.haveChilds
        {//dont allow parent to b booked
            nxtBtn.isHidden = true
        }
        else
        {
            nxtBtn.isHidden = false
        }
        
        selectedLocation = data.name
        if data.haveChilds {
            parentDetail = Array(parentDetail.prefix(selectedParent + 1))
            parentDetail.append(data)
            selectedParent += 1
            selectedChild = indexPath.row
            idy = data.id
            childTblView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.parentCollectionView.reloadData()
                self.collectionView(self.parentCollectionView, didSelectItemAt: IndexPath(row: self.selectedParent, section: 0))
                self.view.layoutIfNeeded()
//                self.tableView(self.parentCollectionView, didSelectRowAt: IndexPath(row: self.selectedParent, section: 0))
            }
        } else {
            selectedChild = indexPath.row
            childTblView.reloadData()
            titleLbl.text = selectedLocation
        }
    }
}
class ParentDetailsCelltbltoCollcn: UICollectionViewCell {
    
    @IBOutlet weak var typeImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var editImg: UIImageView!
}

class ChildDetailsCelltbltoCollcn: UITableViewCell {
    
    @IBOutlet weak var cntrImag: UIImageView!
    @IBOutlet weak var lblCnt: UILabel!
    @IBOutlet weak var selectionBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var editImg: UIImageView!
}
