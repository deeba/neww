//
//  QRViewController.swift
//  AMTfm
//
//  Created by DEEBA on 12.05.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import AVFoundation

class QRViewController: UIViewController{
    let instanceOfUser = readWrite()
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
    @IBAction func btnGoBck(_ sender: UIButton) {
        
        let viewController:
                                      UIViewController = UIStoryboard(
                                          name: "chkLstStoryboard", bundle: nil
                                      ).instantiateViewController(withIdentifier: "chkLstStory") as! chkListViewController
                                      // .instantiatViewControllerWithIdentifier() returns AnyObject!
                                      // this must be downcast to utilize it

                                      let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                      //show window
                                      appDelegate.window?.rootViewController = viewController
    }
    @IBAction func btnCncl(_ sender: UIButton) {
    let viewController:
                        UIViewController = UIStoryboard(
                            name: "chkLstStoryboard", bundle: nil
                        ).instantiateViewController(withIdentifier: "chkLstStory") as! chkListViewController
                        // .instantiatViewControllerWithIdentifier() returns AnyObject!
                        // this must be downcast to utilize it

                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        //show window
                        appDelegate.window?.rootViewController = viewController
      }
    
    @IBAction func btnFlas(_ sender: UIButton) {
        toggleFlash()
    }
    //
    
    @IBAction func btnn(_ sender: UIButton) {
    let viewController:
                        UIViewController = UIStoryboard(
                            name: "chkLstStoryboard", bundle: nil
                        ).instantiateViewController(withIdentifier: "chkLstStory") as! chkListViewController
                        // .instantiatViewControllerWithIdentifier() returns AnyObject!
                        // this must be downcast to utilize it

                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        //show window
                        appDelegate.window?.rootViewController = viewController
      }
    @IBOutlet weak var Img: UIImageView!
    
    @IBOutlet weak var camView: UIView!
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
self.instanceOfUser.writeAnyData(key: "Rescanz", value: false)
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
        videoPreviewLayer?.frame = camView.layer.bounds
        camView.layer.addSublayer(videoPreviewLayer!)
        camView.bringSubviewToFront(Img)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    override var prefersStatusBarHidden: Bool {
        return false
    }
}

extension QRViewController: AVCaptureMetadataOutputObjectsDelegate {
    
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
                if chsStrtMdl.strEqp != metadataObj.stringValue!
                {
                    self.instanceOfUser.writeAnyData(key: "Rescanz", value: true)
                }
                else
                {
                 // if match
                    if self.instanceOfUser.readBoolData(key: "Finsh"){
                            self.instanceOfUser.writeAnyData(key: "QRFnsh", value: true)
                    }
                    else{
                            self.instanceOfUser.writeAnyData(key: "QRfound", value: true)
                    }
                    
                }
                 let viewController:
                                       UIViewController = UIStoryboard(
                                           name: "chkLstStoryboard", bundle: nil
                                       ).instantiateViewController(withIdentifier: "chkLstStory") as! chkListViewController
                // .instantiatViewControllerWithIdentifier() returns AnyObject!
                // this must be downcast to utilize it

                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                //show window
                appDelegate.window?.rootViewController = viewController
                
                }
        }
    }
    
}

