//
//  ItemSelectionViewController.swift
//  HSpace
//
//  Created by DEEBA on 20.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import UIKit
import IQKeyboardManagerSwift
enum ItemType {
    case Location
    case Team
    case Category
    case Code
    case Manuf
    case Vendor
    case Types
}

class ItemSelectionViewController: UIViewController {
    let instanceOfUser = readWrite()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var itemsTblView: UITableView!
    
    var selectionTitle: String?
    var dataSource: [String]? {
        didSet {
            self.itemsTblView?.reloadData()
        }
    }
    var items: [String]? {
        didSet {
            dataSource = items
        }
    }
    var timer: Timer?
    var type: ItemType!
    var selectedItem: String?
    var onItemSelect: ((String)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoaderSpin.shared.hideLoader()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func onClickClose() {
        let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
        mainTabBarController.modalPresentationStyle = .fullScreen
        self.present(mainTabBarController, animated: true, completion: nil)
    }
    
}

extension ItemSelectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = nil
        if searchText == "" {
            dataSource = items
            return
        }
        let text = searchText
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.dataSource = self.items?.filter{
                $0.lowercased().contains(text.lowercased())
            }
        })
    }
}

extension ItemSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ItemDetailCellv
        cell.nameLbl.text = dataSource?[indexPath.row] ?? ""
        cell.selectionBtn.setImage(dataSource?[indexPath.row] ?? "" == selectedItem ? Constants.Image.radioOn :  Constants.Image.radioOff, for: .normal)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = dataSource?[indexPath.row] ?? ""
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.onItemSelect?(self.dataSource?[indexPath.row] ?? "")
            let arrsplitOut = self.selectedItem!.components(separatedBy: " ")
            let shft =  arrsplitOut[1].components(separatedBy: "(")
           // print(self.selectedItem as Any)//shft[0]
            let chsnShftId = availableshftListModl.id[find(value: shft[0], in: availableshftListModl.name)!]
            let chsnShftStart = availableshftListModl.planned_in[find(value: shft[0], in: availableshftListModl.name)!]
            let chsnShftEnd = availableshftListModl.planned_out[find(value: shft[0], in: availableshftListModl.name)!]
            
            self.instanceOfUser.writeAnyData(key: "chsnShftId", value: chsnShftId)
            self.instanceOfUser.writeAnyData(key: "chsnShftStart", value: chsnShftStart)
            self.instanceOfUser.writeAnyData(key: "chsnShftEnd", value: chsnShftEnd)
            self.instanceOfUser.writeAnyData(key: "chsnShft", value: shft[0])
            /*
            DbHandler.getSpaces(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"),id:mainBldgModl.Id,shftId:chsnShftId,strt:chsnShftStart,endd:chsnShftEnd )
            */
            
            self.instanceOfUser.writeAnyData(key: "chsnShfttim", value: self.selectedItem?.components(separatedBy: "(")[1] as Any)
                let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "dshBrdbkSpace") as! dshBrdbkSpace
                mainTabBarController.modalPresentationStyle = .fullScreen
            mainTabBarController.chosenShift = (self.selectedItem as Any as! String)
            let doubley = availableshftListModl.duration[find(value: shft[0], in: availableshftListModl.name)!]
            mainTabBarController.chosenDurn = String(doubley)
            self.present(mainTabBarController, animated: true, completion: nil)
            
        }
    }
}

class ItemDetailCellv: UITableViewCell {
    
    @IBOutlet weak var selectionBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
}
