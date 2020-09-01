//
//  MaskdetctnViewController.swift
//  HSpace
//
//  Created by DEEBA on 22.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import UIKit
import CoreML
import Vision
import AVFoundation
import Accelerate
import Fritz

extension Double {
  func format(f: String) -> String {
    return String(format: "%\(f)f", self)
  }
}
public extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(vc: self.rootViewController)
    }

    public static func getVisibleViewControllerFrom(vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(vc: nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(vc: tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: pvc)
            } else {
                return vc
            }
        }
    }
}

func getTopViewController() -> UIViewController? {
    let appDelegate = UIApplication.shared.delegate
    if let window = appDelegate!.window {
        return window?.visibleViewController
    }
    return nil
}

extension MaskRecognition: SwiftIdentifiedModel {
   static let modelIdentifier = "f361a07db99e480198621240a8e5ecd1"
   static let packagedModelVersion = 2
}
extension MaskdetctnViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
        mainTabBarController.modalPresentationStyle = .fullScreen
        self.present(mainTabBarController, animated: true, completion: nil)
    }
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let newImage =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        APIClient.shared().getTokenz
          {status in}
          APIClient.shared().writemasqData(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz")) { status in
             if(status)
              {
                sleep(1)
                APIClient.shared().upldMaskPhto(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"), img: newImage!)
              }
              
          }
        sleep(1)
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

class MaskdetctnViewController: UIViewController , AVCaptureVideoDataOutputSampleBufferDelegate {
  @IBOutlet weak var cameraView: UIView!
  @IBOutlet weak var fpsLabel: UILabel!
  let instanceOfUser = readWrite()
  @IBOutlet weak var predictionLabel: UILabel! {
      didSet { predictionLabel.text = "Loading..." }
  }
    @IBAction func btnCncl(_ sender: UIButton) {
        LoaderSpin.shared.showLoader(self)
         APIClient.shared().getToken { status in
                   if status {
                       APIClient.shared().dashBrdApi()
                     }
                   }
        sleep(2)
        let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
        mainTabBarController.modalPresentationStyle = .fullScreen
        self.present(mainTabBarController, animated: true, completion: nil)
    }
    
    @IBAction func btnOk(_ sender: UIButton) {
    }
    @IBOutlet weak var confidenceLabel: UILabel! {
      didSet { confidenceLabel.text = nil }
  }

  var lastExecution = Date()
  var screenHeight: Double?
  var screenWidth: Double?

  lazy var visionModel = FritzVisionLabelPredictor(model: MaskRecognition().fritz())

  // Only show labels above a certain confidence threshold. For new models in development,
  // you may need to lower this to see predictions. As you improve your model, you can
  // increase this reduce false positives.
  let confidenceThreshold = 0.1

  private lazy var cameraLayer: AVCaptureVideoPreviewLayer = {
    let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    layer.videoGravity = .resizeAspectFill
    return layer
  }()

  private lazy var captureSession: AVCaptureSession = {
    let session = AVCaptureSession()

    guard
      let backCamera = AVCaptureDevice.default(
        .builtInWideAngleCamera,
        for: .video,
        position: .front
      ),
      let input = try? AVCaptureDeviceInput(device: backCamera)
      else { return session }
    session.addInput(input)
    return session
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.cameraView?.layer.addSublayer(self.cameraLayer)
    // Setup model labels
    self.cameraView?.bringSubviewToFront(self.fpsLabel)
    self.fpsLabel.textAlignment = .center
    
    // Setup prediction labels
    self.cameraView?.bringSubviewToFront(self.predictionLabel)
    self.predictionLabel.textAlignment = .center
    self.cameraView?.bringSubviewToFront(self.confidenceLabel)
    self.confidenceLabel.textAlignment = .center

    // Setup video capture.
    let videoOutput = AVCaptureVideoDataOutput()
    videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "MyQueue"))
    self.captureSession.addOutput(videoOutput)
    self.captureSession.startRunning()

    screenWidth = Double(view.frame.width)
    screenHeight = Double(view.frame.height)
  }

    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      cameraLayer.frame = cameraView.layer.bounds
    }

    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      self.cameraLayer.frame = self.cameraView?.bounds ?? .zero
    }

    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
    }

    func updateLabels() {
      let thisExecution = Date()
      let executionTime = thisExecution.timeIntervalSince(self.lastExecution)
      let framesPerSecond: Double = 1 / executionTime
      self.lastExecution = thisExecution

      DispatchQueue.main.async {
       self.fpsLabel.text = "FPS: \(framesPerSecond.format(f: ".3"))"
      }
    }


    
      @IBOutlet weak var btnDone: UIButton!
      
      @IBAction func btnDneClick(_ sender: UIButton) {
          let storyBoard: UIStoryboard = UIStoryboard(name: "OccpyStoryboard", bundle: nil)
          let ImagePickerVC = storyBoard.instantiateViewController(withIdentifier: "ImagePicker") as! ImagePickerViewController
        
         /*
          ImagePickerVC.onImageSelect = { newImage in
              APIClient.shared().getTokenz
              {status in}
              APIClient.shared().writemasqData(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz")) { status in
                 if(status)
                  {
                    sleep(1)
                      APIClient.shared().upldMaskPhto(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"), img: newImage)
                  }
                  
              }
            sleep(1)
            

           //   self.btnDone.setImage(UIImage(named: "okSelect"), for: .normal)
            //    self.btnDone.isHidden = false
              
          }
          self.present(ImagePickerVC, animated: true)

 */
      }
      func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection) {
        let image = FritzVisionImage(sampleBuffer: sampleBuffer, connection: connection)
        let options = FritzVisionLabelModelOptions()
        options.threshold = confidenceThreshold


        guard let results = try? visionModel.predict(image, options: options) else { return }
        
        // Display results
        if results.count > 0 {
          let observation = results[0]
          let confidence = Int(observation.confidence * 100)
            print(confidence)
            if observation.label == "mask" && confidence > 85
            {//if mask detected (UIImage(named: "radio_off"), for: .normal)

                self.setResult(text: observation.label, confidence: confidence)
                self.captureSession.stopRunning()
              DispatchQueue.main.async {
             //   self.btnDone.setImage(UIImage(named: "cameraSelect"), for: .normal)
                let picker: UIImagePickerController = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .camera
                picker.cameraDevice = .front
                self.addChild(picker)
                picker.didMove(toParent: self)
                self.view!.addSubview(picker.view!)
                picker.modalPresentationStyle = .overCurrentContext
                picker.delegate = self
               // self.present(picker, animated: true, completion: nil)
                /*
                 ImagePickerVC.onImageSelect = { newImage in
                     APIClient.shared().getTokenz
                     {status in}
                     APIClient.shared().writemasqData(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz")) { status in
                        if(status)
                         {
                             APIClient.shared().upldMaskPhto(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"), img: newImage)
                         }
                         
                     }
                   sleep(1)
                   Loader.show()
                  
                  let viewController:
                         UIViewController = UIStoryboard(
                             name: "OccpyStoryboard", bundle: nil
                         ).instantiateViewController(withIdentifier: "symptomsLstStory") as! symptomsViewController
                         // .instantiatViewControllerWithIdentifier() returns AnyObject!
                         // this must be downcast to utilize it

                         let appDelegate = UIApplication.shared.delegate as! AppDelegate
                         //show window
                         appDelegate.window?.rootViewController = viewController
                 }*/
               //  self.present(ImagePickerVC, animated: true)
                }
            }
        } else {
          self.setNoResult()
        }

        updateLabels()
      }
   func pickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           let image1 =  info[UIImagePickerController.InfoKey.editedImage] as? UIImage
           self.dismiss(animated: true, completion: nil)
       }
       func pickerControllerDidCancel(_ picker: UIImagePickerController) {

           print("Cancel")
           self.dismiss(animated: true, completion: nil)
    }
    func topMostController() -> UIViewController {
           var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
           while (topController.presentedViewController != nil) {
               topController = topController.presentedViewController!
           }
           return topController
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.captureSession.stopRunning()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        
        print(self.instanceOfUser.readStringData(key: "returnFromPhoto"))
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.configNavigationBar(title: "Click a Picture")
    }
      private func setResult(text: String, confidence: Int) {
       
          DispatchQueue.main.async {
              self.predictionLabel.text = text.capitalized
              self.confidenceLabel.text = self.confidenceString(confidence)
              self.confidenceLabel.textColor = self.confidenceColor(confidence)
          }

      }

    private func setNoResult() {
        DispatchQueue.main.async {
            self.predictionLabel.text = "?????"
            self.confidenceLabel.text = ""
        }
 
    }

   private func confidenceString(_ value: Int) -> String {
        return "\(value)%"
    }

    private func confidenceColor(_ value: Int) -> UIColor {
        switch value {
        case ...33: return .red
        case 34...66: return .orange
        default: return .green
        }
    }
  }

