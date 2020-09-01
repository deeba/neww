//
//  HCardViewController.swift
//  AMTfm
//
//  Created by DEEBA on 12.06.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON

class HCardViewController: UIViewController {
 let instanceOfUser = readWrite()
    
    var hcrdMdl: hCardData!
     var hcrdMdlz = [HcardMdlDta]()
    var task1 = URLSessionDataTask()
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
    @IBOutlet weak var camView: UIView!
    @IBOutlet weak var Img: UIImageView!
    
    @IBAction func BTNCNCL(_ sender: UIButton) {
    }
    @IBAction func btnFlas(_ sender: UIButton) {
        toggleFlash()
    }
    override func viewDidLoad() {
            super.viewDidLoad()
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
         func DownldSpace(Tkn: String,Asstnam: String) {

                   var request = URLRequest(url: URL(string:"https://demo.helixsense.com/api/v2/create")!,timeoutInterval: Double.infinity)
                   let string1 = "Bearer "
                   let string2 = Tkn
                   let combined2 = "\(string1) \(String(describing: string2))"
                   request.addValue(combined2, forHTTPHeaderField: "Authorization")
                   let stringFields = """

                   &values={"name": "Test_File_Name","display_name": "DCS-E-00006After13-06-2020 17:51:32","type": "binary","datas_fname": "DCS-E-00006After13-06-2020 17:51:32","res_model": "mro.order","ir_attachment_categ": "","res_id": 438033,"mimetype":"image/png","datas":"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"}

                   """
                         
                   let varRole = "\(String(describing: stringFields))"
                   let postData = NSMutableData(data: "model=ir.attachment".data(using: String.Encoding.utf8)!)
                   postData.append(varRole.data(using: String.Encoding.utf8)!)
                   request.httpBody = postData as Data
                   request.httpMethod = "POST"
                           let task1 = URLSession.shared.dataTask(with: request) { data, response, error in
                           guard let data = data else {
                             print(String(describing: error))
                             return
                           }
                           do {
                              // make sure this JSON is in the format we expect
                           let jsonc = try JSON(data: data)
                             let array = jsonc[0]
                             let InsrtWOArrayz = array.compactMap{ $0  }
                             var substring = ""
                        
                                                 
                             }
                            
                           catch let error as NSError {
                              print("Failed to load: \(error.localizedDescription)")
                           }
                           }
                              task1.resume()

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
extension HCardViewController: AVCaptureMetadataOutputObjectsDelegate {
    
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
                if  metadataObj.stringValue! != ""
                {
                    self.DownldSpace(Tkn: self.instanceOfUser.readStringData(key: "accessTokenz"), Asstnam:metadataObj.stringValue! )
                    
                }

                let raiseTicket = UIStoryboard(name: "HCardStoryboard", bundle: .main).instantiateInitialViewController()!
                        navigationController?.pushViewController(raiseTicket, animated: true)

                
                }
        }
    }
    
}
