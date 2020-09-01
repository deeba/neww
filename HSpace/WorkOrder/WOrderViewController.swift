//
//  WOrderViewController.swift
//  AMTfm
//
//  Created by DEEBA on 02.04.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import SwiftyJSON
import SQLite3
extension WOrderViewController:  DataCollectionProtocol
{
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
    func passDataPndg(indx: Int) {
        TmId = TmNm[indx]
        MTmId = TmIdz[indx]
        self.instanceOfUser.writeAnyData(key: "TmNm", value:TmId )
        self.instanceOfUser.writeAnyData(key: "MTmId", value:MTmId)
        if  Pndg[indx]  !=  "0"
        {
            //5R
                   let viewController:
                   UIViewController = UIStoryboard(
                       name: "PausWOStoryboard", bundle: nil
                   ).instantiateViewController(withIdentifier: "PausWOStory") as! PausWOViewController
                   // .instantiatViewControllerWithIdentifier() returns AnyObject!
                   // this must be downcast to utilize it

                   let appDelegate = UIApplication.shared.delegate as! AppDelegate
                   //show window
                   appDelegate.window?.rootViewController = viewController
        }
       else
        {
            showToast(message: "No pending work orders are available for " + TmId)
            
        }
    }
    func passDataNw(indx: Int) {
        TmId = TmNm[indx]
         
        MTmId = TmIdz[indx]
        self.instanceOfUser.writeAnyData(key: "TmNm", value:TmId )
        self.instanceOfUser.writeAnyData(key: "MTmId", value:MTmId)
        if  Nww[indx]  !=  "0"
        {
            let viewController:
            UIViewController = UIStoryboard(
                name: "Tbl", bundle: nil
            ).instantiateViewController(withIdentifier: "tblStory") as! TblViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                          //show window
                          appDelegate.window?.rootViewController = viewController
            }
                  else
                   {
                       showToast(message: "No New work orders are available for " + TmId)
                       
                   }
    }
    func passDataStr(indx: Int) {
        TmId = TmNm[indx]
        MTmId = TmIdz[indx]
        self.instanceOfUser.writeAnyData(key: "TmNm", value:TmId )
        self.instanceOfUser.writeAnyData(key: "MTmId", value:MTmId)
        if  hjg[indx]  !=  "0"
        {
        
        let viewController:
                      UIViewController = UIStoryboard(
                          name: "StrtdWO", bundle: nil
                      ).instantiateViewController(withIdentifier: "StrtdStory") as! StrtdWOViewController
                      // .instantiatViewControllerWithIdentifier() returns AnyObject!
                      // this must be downcast to utilize it

                      let appDelegate = UIApplication.shared.delegate as! AppDelegate
                      //show window
                      appDelegate.window?.rootViewController = viewController
        }
              else
               {
                   showToast(message: "No Inprogress work orders are available for " + TmId)
                   
               }
      //  self.AssgndWorder(Tkn: tknz)
    }
    func passDataDon(indx: Int) {
        TmId = TmNm[indx]
        MTmId = TmIdz[indx]
        self.instanceOfUser.writeAnyData(key: "TmNm", value:TmId )
        self.instanceOfUser.writeAnyData(key: "MTmId", value:MTmId)
        if  Dne[indx]  !=  "0"
        {
        let viewController:
                      UIViewController = UIStoryboard(
                          name: "DoneWOStoryboard", bundle: nil
                      ).instantiateViewController(withIdentifier: "DnWOStory") as! DoneWOViewController
                      // .instantiatViewControllerWithIdentifier() returns AnyObject!
                      // this must be downcast to utilize it

                      let appDelegate = UIApplication.shared.delegate as! AppDelegate
                      //show window
                      appDelegate.window?.rootViewController = viewController
        }
        else
         {
             showToast(message: "No Completed work orders are available for " + TmId)
             
         }
    }
    }
extension WOrderViewController: UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return    TmNm.count
    }
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
     }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let bounds  = collectionView.bounds
         return CGSize(width: bounds.width , height: 100)
     }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 0
     }
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // print(TmNm[indexPath.row])
     }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 0
     }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
         
         cell.lblDn.text = Dne[indexPath.row]
         cell.lblnw.text = Nww[indexPath.row]
         cell.lblPndg.text = Pndg[indexPath.row]
         cell.tmNam.text = TmNm[indexPath.row]
         cell.strt.text = hjg[indexPath.row]
        cell.index = indexPath
        cell.delegate = self
         cell.contentView.layer.cornerRadius = 4.0
         cell.contentView.layer.borderWidth = 1.0
         cell.contentView.layer.borderColor = UIColor.clear.cgColor
         cell.contentView.layer.masksToBounds = false
         cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 0.15
         cell.layer.shadowOpacity = 0.25
         cell.layer.masksToBounds = false
         cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    return cell
     }
    
    
  
    }
class WOrderViewController: UIViewController{
    /*var sample = Worders?.self
    var sample1 = Usez?.self
 */
    
    @available(iOS 10.0, *)
    @IBAction func btnGobck(_ sender: UIButton) {
            let viewController:
                UIViewController = UIStoryboard(
                    name: "HomeStoryboard", bundle: nil
                ).instantiateViewController(withIdentifier: "HomeStory") as! HomeScreenz
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                 //show window
                                 appDelegate.window?.rootViewController = viewController
       
                     
    }
    var MTmId: String = ""
    let instanceOfUser = readWrite()
    var db:OpaquePointer? = nil
    let interNt = Internt()
    var instanceOfWOrder = WOglobal()
    var TmId = ""
    var task1 = URLSessionDataTask()
    var delegate: DataCollectionProtocol?
    var index: IndexPath?
    var at_start_mro: Bool = false,extFlg: Bool = false,at_done_mro: Bool = false,at_review_mro: Bool = false,enforce_time: Bool = false
   
    @IBAction func btnNw(_ sender: Any) {
        
    }
    var TmNm: [String] = []
    var Pndg: [String] = []
    var Dne: [String] = []
    var hjg: [String] = []
    var Nww: [String] = []
    var TmIdz: [String] = []
    private func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        pausOMdl.strMsgIdsTbl.removeAll()
               pausOMdl.mAssetIdTbl.removeAll()
               pausOMdl.QRcdeTbl.removeAll()
        pausOMdl.DisNm.removeAll()
               pausOMdl.TmNam.removeAll()
               pausOMdl.EqNam.removeAll()
              pausOMdl.Caus.removeAll()
              pausOMdl.EqLcn.removeAll()
              pausOMdl.Prioritz.removeAll()
              pausOMdl.dtSchedule.removeAll()
              pausOMdl.idee.removeAll()
              pausOMdl.idTbl.removeAll()
              pausOMdl.causeTbl.removeAll()
              pausOMdl.stateTbl.removeAll()
              pausOMdl.display_nameTbl.removeAll()
              pausOMdl.mAssignedByTbl.removeAll()
              pausOMdl.date_scheduledTbl.removeAll()
              pausOMdl.type_categoryTbl.removeAll()
              pausOMdl.equipment_location_namTbl.removeAll()
              pausOMdl.priorityTbl.removeAll()
              pausOMdl.mAssignedToTbl.removeAll()
              pausOMdl.mAssetNamTbl.removeAll()
              pausOMdl.maintenance_typeTbl.removeAll()
              pausOMdl.mStarttmTbl.removeAll()
              pausOMdl.mEndtmTbl.removeAll()
              pausOMdl.StatuzTbl.removeAll()
              pausOMdl.boolz1Tbl.removeAll()
              pausOMdl.boolz2Tbl.removeAll()
              pausOMdl.mCompanyNamTbl.removeAll()
              pausOMdl.strchkListTbl.removeAll()
              pausOMdl.at_start_mroTbl.removeAll()
              pausOMdl.at_done_mroTbl.removeAll()
              pausOMdl.at_review_mroTbl.removeAll()
              pausOMdl.maintenance_team_idTbl.removeAll()
              pausOMdl.hlpDskId_idTbl.removeAll()
              pausOMdl.enforce_timeTbl.removeAll()
              pausOMdl.boolz3Tbl.removeAll()
              pausOMdl.strReasonTbl.removeAll()
              pausOMdl.strReasonIdTbl.removeAll()
              pausOMdl.strSelectdReasonTbl.removeAll()
        for j in 0..<wOrderMdl.strNwCnt.count {
            TmNm.append(wOrderMdl.strTmNam[j] )
            Nww.append(wOrderMdl.strNwCnt[j] )
            Pndg.append(wOrderMdl.strPndgCnt[j] )
            hjg.append(wOrderMdl.strPrgCntz[j] )
            Dne.append(wOrderMdl.strCompltdCnt[j] )
            TmIdz.append(wOrderMdl.strTmId[j] )
             }
        // Do any additional setup after loading the view.
    }
   
  
    override var prefersStatusBarHidden: Bool {
        return false
    }

}
