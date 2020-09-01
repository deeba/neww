//
//  ImagePickerViewController.swift
//  HSpace
//
//  Created by DEEBA on 20.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import Photos

class ImagePickerViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var galleryView: UIView!
    
    var onImageSelect : ((UIImage)->Void)?
    let instanceOfUser = readWrite()
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {

    picker.view!.removeFromSuperview()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.instanceOfUser.writeAnyData(key: "returnFromPhoto", value: "YES")

      /*  cameraView.addGestureRecognizer(GestureRecognizerWithClosure.init(action: {
            self.openCamera()
        }))
        
        galleryView.addGestureRecognizer(GestureRecognizerWithClosure.init(action: {
            self.openPhotos()
        }))
 */
        showToast(message:"Please take a picture of Yourself")
        self.openCamera()
    }
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
    @IBAction func onClickClose() {
        self.dismiss(animated: true)
    }
    
    func openCamera(mediaTypes:[String] = ["public.image"]) {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.cameraDevice = .front
                imagePicker.mediaTypes = mediaTypes
                self.present(imagePicker, animated: true, completion: nil)
            }
        case .denied, .restricted:
            Alert.show(Constants.cameraPermissions, Constants.inIphoneSettingsTapThisAppTurnCamera, Constants.cancel, Constants.openSettings) { _ in
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (status) in
                if status {
                    self.openCamera(mediaTypes: mediaTypes)
                }
            })
        default:
            break
        }
    }
    
    func openPhotos(mediaTypes:[String] = ["public.image"]) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.mediaTypes = mediaTypes
                self.present(imagePicker, animated: true, completion: nil)
            }
        case .denied, .restricted:
            
            Alert.show(Constants.photosPermissions, Constants.inIphoneSettingsTapThisAppTurnPhotos, Constants.cancel, Constants.openSettings) { _ in
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    self.openPhotos(mediaTypes: mediaTypes)
                }
            })
        default:
            break
        }
    }
}

extension ImagePickerViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.global(qos: .background).async {
            guard let selectedImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else {
                return
            }
            
            DispatchQueue.main.async {
                self.onImageSelect?(selectedImage)
                
                    APIClient.shared().getTokenz
                    {status in}
                    APIClient.shared().writemasqData(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz")) { status in
                       if(status)
                        {
                            APIClient.shared().upldMaskPhto(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"), img: selectedImage)
                        }
                        
                    }
                 
                  LoaderSpin.shared.showLoader(self)
                 let viewController:
                        UIViewController = UIStoryboard(
                            name: "OccpyStoryboard", bundle: nil
                        ).instantiateViewController(withIdentifier: "symptomsLstStory") as! symptomsViewController
                        // .instantiatViewControllerWithIdentifier() returns AnyObject!
                        // this must be downcast to utilize it

                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        //show window
                        appDelegate.window?.rootViewController = viewController
                
               
            }
        }
    }
}
