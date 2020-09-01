//
//
//  Custom Alerts
//
//  Created by Kyle Lee on 2/13/19.
//  Copyright © 2019 Kilo Loco. All rights reserved.
//

import UIKit

class camraGallryViewController: UIViewController {
    let instanceOfUser = readWrite()
    @IBAction func btnCncl(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func btnCamra(_ sender: UIButton) {
        self.instanceOfUser.writeAnyData(key: "PhtoOptn", value: "Camra")
       let storyBoard: UIStoryboard = UIStoryboard(name: "AddtnlWOPhtoDescripStoryboard", bundle: nil)
                                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PhtoDescripStory") as! AddtnlWOPhtoDescripViewController
                                        self.present(newViewController, animated: true, completion: nil)
       
    }
    @IBAction func btnGallry(_ sender: UIButton) {
        self.instanceOfUser.writeAnyData(key: "PhtoOptn", value: "Gallry")
        let storyBoard: UIStoryboard = UIStoryboard(name: "AddtnlWOPhtoDescripStoryboard", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PhtoDescripStory") as! AddtnlWOPhtoDescripViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.instanceOfUser.writeAnyData(key: "PhtoOptn", value: "")
    }

}
