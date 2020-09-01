//
//  PickSourceViewController.swift
//  AMTfm
//
//  Created by Serge Vysotsky on 04.06.2020.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

final class PickSourceViewController: UIViewController {
    @IBOutlet weak var bottomView: UIView!
    var completion: ((UIImagePickerController.SourceType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.transform = CGAffineTransform(translationX: 0, y: bottomView.frame.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.bottomView.transform = .identity
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    
    @IBAction private func pickCamera() {
        let completion = self.completion
        dismissSelf {
            completion?(.camera)
        }
    }
    
    @IBAction private func pickLibrary() {
        let completion = self.completion
        dismissSelf {
            completion?(.photoLibrary)
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
