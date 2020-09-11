//
//  scanQRbookSpaceViewController.swift
//  HSpace
//
//  Created by DEEBA on 17.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import AVFoundation
extension scanQRbookSpaceViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
          //  messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                //   If the QR code doesn't match say "Asset scanning did not match the Asset for this Order" and give a option to rescan  or cancel
                if String(curntSchedulModll.space_number)  != metadataObj.stringValue!
                {
                }
                else
                {
                     // if match
                    LoaderSpin.shared.showLoader(self)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            APIClient_redesign.shared().getTokenz
                               {status in
                           APIClient_redesign.shared().putOccpied(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz")) { cnt in
                           LoaderSpin.shared.hideLoader()
                             if cnt {
                              }
                              }
                            }
                              }
                    let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                   let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
                   self.navigationController?.isNavigationBarHidden = true
                   self.navigationController?.pushViewController(mainTabBarController, animated: true)
                        
                    }
                
                }
        }
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
}
class scanQRbookSpaceViewController: UIViewController {
    let instanceOfUser = readWrite()
    @IBAction func btnFlsh() {
        
        toggleFlash()
    }
    func toggleFlash() {
        let device = AVCaptureDevice.default(for: AVMediaType.video)

        if (device != nil) {
            if (device!.hasTorch) {
                do {
                    try device!.lockForConfiguration()
                        if (device!.torchMode == AVCaptureDevice.TorchMode.on) {
                            device!.torchMode = AVCaptureDevice.TorchMode.off
                        } else {
                            do {
                                try device!.setTorchModeOn(level: 1.0)
                                } catch {
                                    print(error)
                                }
                        }

                        device!.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    @IBAction func btnCncl() {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBOutlet weak var camView: UIView!
    @IBOutlet weak var Img: UIImageView!
    var captureSession = AVCaptureSession()
     
     var videoPreviewLayer: AVCaptureVideoPreviewLayer?
     var qrCodeFrameView: UIView?

     private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                       AVMetadataObject.ObjectType.code39,
                                       AVMetadataObject.ObjectType.code39Mod43,
                                       AVMetadataObject.ObjectType.code93,
                                       AVMetadataObject.ObjectType.code128,
                                       AVMetadataObject.ObjectType.ean8,
                                       AVMetadataObject.ObjectType.ean13,
                                       AVMetadataObject.ObjectType.aztec,
                                       AVMetadataObject.ObjectType.pdf417,
                                       AVMetadataObject.ObjectType.itf14,
                                       AVMetadataObject.ObjectType.dataMatrix,
                                       AVMetadataObject.ObjectType.interleaved2of5,
                                       AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        camView.layer.borderWidth = 1

        camView.layer.borderColor = UIColor.blue.cgColor
            // Get the back-facing camera for capturing videos
            guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
                print("Failed to get the camera device")
                return
            }
            
            do {
                // Get an instance of the AVCaptureDeviceInput class using the previous device object.
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                // Set the input device on the capture session.
                captureSession.addInput(input)
                
                // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)
                
                // Set delegate and use the default dispatch queue to execute the call back
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
    //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
                
            } catch {
                // If any error occurs, simply print it out and don't continue any more.
                print(error)
                return
            }
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = camView.frame
            camView.layer.addSublayer(videoPreviewLayer!)
            // Start video capture.
            captureSession.startRunning()
            
            // Move the message label and top bar to the front
          //  view.bringSubviewToFront(messageLabel)
          //  view.bringSubviewToFront(topbar)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView?.layer.borderWidth = 2
            camView.addSubview(qrCodeFrameView!)
                camView.bringSubviewToFront(qrCodeFrameView!)
        }
  
    override public func viewWillDisappear(_ animated: Bool) {

      super.viewWillDisappear(animated)
      captureSession.stopRunning()
    }
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
      layer.videoOrientation = orientation
      videoPreviewLayer?.frame = self.camView.bounds
    }

    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      
      if let connection =  self.videoPreviewLayer?.connection  {
        let currentDevice: UIDevice = UIDevice.current
        let orientation: UIDeviceOrientation = currentDevice.orientation
        let previewLayerConnection : AVCaptureConnection = connection
        
        if previewLayerConnection.isVideoOrientationSupported {
          switch (orientation) {
          case .portrait:
            updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
            break
          case .landscapeRight:
            updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
            break
          case .landscapeLeft:
            updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
            break
          case .portraitUpsideDown:
            updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
            break
          default:
            updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
            break
          }
        }
      }
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
           self.navigationController?.isNavigationBarHidden = false
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
