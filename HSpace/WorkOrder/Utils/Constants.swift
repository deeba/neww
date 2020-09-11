//
//  Constants.swift
//  sideMnu
//
//  Created by DEEBA on 22.06.20.
//  Copyright © 2020 DEEBA. All rights reserved.
//

import Foundation
import UIKit
enum StringFormats:String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    case numeric = "[0-9]*"
}
struct Constants {
    
    static let cancel = "Cancel"
    static let Ok = "Ok"
    
    static let openSettings = "Open Settings"
    static let cameraPermissions = "Camera Permissions"
    static let inIphoneSettingsTapThisAppTurnCamera = "In iPhone settings, tap This app and turn on Camera"
    static let photosPermissions = "Photos Permissions"
    static let inIphoneSettingsTapThisAppTurnPhotos = "In iPhone settings, tap This app and turn on Photos"
    static let ackTitle = "I,%@ validate %@ at %@"
}

//Images
extension Constants {
    
    struct Image {
        static let radioOff = #imageLiteral(resourceName: "radio-off")
        static let radioOn = #imageLiteral(resourceName: "radio-on")
    }
    
}

//Colors
extension Constants {
    
    struct Color {
        static let lightBlue = UIColor(named: "ColorLightBlue")!
        static let darkBlue = UIColor(named: "ColorDarkBlue")!
        static let gray = #colorLiteral(red: 0.7154692411, green: 0.7154692411, blue: 0.7154692411, alpha: 1)
        static let lightGray = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 0.5)
    }
    
}

//Storyboards
extension Constants {
    
    struct Storyboard {
        static let main = UIStoryboard(name: "Main", bundle: nil)
        static let sideMenu = UIStoryboard(name: "SideMenu", bundle: nil)
        static let dshBrd = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
        static let categrySubcategry = UIStoryboard(name: "rseTkyStoryboard", bundle: nil)
    }
    
    struct Ids {
        static let  cofrmScreenaftrQR = "cofrmScreenaftrQR"
        static let  tbltoCollcn = "tbltoCollcn"
        static let  ItemSelectionViewController = "ItemSelection"
        static let  bkSpaceViewController = "dshBrdbkSpace"
        static let  gnrlpractizViewController =  "gnrlpractizViewController"
        static let  confirmOccpy =  "confrmOccpy"
        static let symptomsLstViewController = "symptomsLstStory"
        static let rprtincidntViewController = "rprtIncidntViewController"
        static let webviewController = "WebViewController"
        static let viewController = "ViewController"
        static let selectLocationviewController = "rprtIssy"
        static let occpyRedesign = "OccpyRedesign"
        static let sideMenuViewController = "SideMenuViewController"
        static let scanqrOccpySpace = "scanQROccpySpace"
        static let assetRegistryViewController = "AssetRegistry"
        static let addEquipmentViewController = "addEqpmntStoryboard"
        static let imagePickerViewController = "ImagePickerViewController"
        static let dateSelectViewController = "DateSelectViewController"
        static let validationViewController = "ValidationViewControllerz"
        static let itemSelectionViewController = "ItemSelectionViewController"
    }
}
