//
//  cofrmScreenaftrQRViewController.swift
//  HSpace
//
//  Created by DEEBA on 18.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class cofrmScreenaftrQRViewController: UIViewController {
let instanceOfUser = readWrite()
    var  dtQ = ""
    var mnthQ = ""
    var dayQ = ""
    var timQ = ""
    var shftQ = ""
    var wrkSpceQ = ""
     var spacebkdId: String!
    @IBOutlet weak var lblTim: UILabel!
    @IBOutlet weak var lblwrkSpacePth: UILabel!
    
    @IBOutlet weak var lblwrkSpace: UILabel!
    @IBOutlet weak var lblShft: UILabel!
    @IBOutlet weak var lblDte: UILabel!
    @IBOutlet weak var lblMnth: UILabel!
    @IBAction func btnConfirm(_ sender: Any) {
        self.instanceOfUser.writeAnyData(key: "bk_rprtSpac", value: "")

       
       // Loader.show()
        /* APIClient.shared().getTokenz
        {status in}
        APIClient.shared().dashBrdApi(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
        sleep(2)
        
       LoaderSpin.shared.showLoader()
        let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(mainTabBarController, animated: true)
        */
        
        
        LoaderSpin.shared.showLoader(self)
        let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
           let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
           mainTabBarController.modalPresentationStyle = .fullScreen
           self.present(mainTabBarController, animated: true, completion: nil)
    }
      func splitDatestr(dteStr: String){
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateFormatter = DateFormatter()
      //      dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
            dateFormatter.dateFormat = "EEEE"
            let datew: Date? = dateFormatterGet.date(from: dteStr)
         //   print(dateFormatter.string(from: datew!))
            let dayx = dateFormatter.string(from: datew!)
            dayQ = String(dayx[dayx.index(dayx.startIndex, offsetBy: 0)..<dayx.index(dayx.startIndex, offsetBy: 3)])//Wed
        let dte = dteStr
        let newwq = dte.components(separatedBy: "-")[1]
        let monthNumber = Int(newwq)
        let fmt = DateFormatter()
        fmt.dateFormat = "M"
        let month = fmt.monthSymbols[monthNumber! - 1]
        let mnth = month[month.index(month.startIndex, offsetBy: 0)..<month.index(month.startIndex, offsetBy: 3)]
        mnthQ = String(mnth)
        dtQ = dte.components(separatedBy: "-")[2]//08
        dtQ = dtQ.components(separatedBy: " ")[0]
         }
    override func viewDidLoad() {
        super.viewDidLoad()
        let  shftId = self.instanceOfUser.readStringData(key: "chsnShftId")
        let  strt = self.instanceOfUser.readStringData(key: "chsnShftStart")
        let  endd = self.instanceOfUser.readStringData(key: "chsnShftEnd")
        LoaderSpin.shared.showLoader(self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
         APIClient_redesign.shared().getTokenz { status in
           if status {
            APIClient.shared().getSpaceIdBooked_new(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"),compid: String(usrInfoModls.company_id),vndrId: String(usrInfoModls.vendor_id),spacId: String(self.spacebkdId),shftId: String(shftId) ,PlndIn: strt,PlndOut: endd,empId: String(usrInfoModls.employee_id))
            {_ in
                          
                                LoaderSpin.shared.hideLoader()
                     
                }
            }
         }
             }
        //print(spacebkdId as Any)
        let dte = self.instanceOfUser.readStringData(key: "chsnShftdte")
        splitDatestr(dteStr: dte)
        lblMnth.text = mnthQ
        lblDte.text = dtQ
        let shftW = self.instanceOfUser.readStringData(key: "chsnShfttim")
        let arrsplitOut = shftW.components(separatedBy: " ")
        let shftQ = String(arrsplitOut[2][arrsplitOut[2].index(arrsplitOut[2].startIndex, offsetBy: 0)..<arrsplitOut[2].index(arrsplitOut[2].startIndex, offsetBy: arrsplitOut[2].count - 1)])
               let shft =  arrsplitOut[1].components(separatedBy: "-")[0]
        lblTim.text = dayQ + ", "  + shft + " - " + shftQ + "(" +   self.instanceOfUser.readStringData(key: "chsnShftdurn") + " h)"
        lblShft.text = "Regular" + "  " +
        self.instanceOfUser.readStringData(key: "chsnShft")
        lblwrkSpace.text =
        self.instanceOfUser.readStringData(key: "chsnSpace")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
