//
//  AppDelegate.swift
//  Reachability
//
//  Created by Leo Dabus on 2/9/19.
//  Copyright © 2019 Dabus.tv. All rights reserved.
//

    import UIKit
    import OneSignal
    import Fritz
//import IQKeyboardManagerSwift
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?

        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     //       IQKeyboardManager.shared.enable = true
            FritzCore.configure()
         
             let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
                print(notification as Any)
                /*
                 {
                     "shift_id": 3401,
                     "type": "Hspace"
                 }
                 */
              //  print(notification!.payload.additionalData["type"] ?? "code")
              //  print(notification!.payload.additionalData["mro_id"] ?? "code")
              //  print(notification!.payload.additionalData["id"] ?? "code")
               // print(notification!.payload.additionalData["ticket"] ?? "code")
              //  print(notification!.payload.additionalData["code"] ?? "code")
                //let json = try JSONSerialization.jsonObject(with: (String(describing: notification!.payload.additionalData)), options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                //self.jsonToString(json: json)
            }

            let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
               // This block gets called when the user reacts to a notification received
               let payload: OSNotificationPayload = result!.notification.payload

               var fullMessage = payload.body
                print("Message = \(String(describing: fullMessage))")

               if payload.additionalData != nil {
                  if payload.title != nil {
                     let messageTitle = payload.title
                        print("Message Title = \(messageTitle!)")
                  }

                  let additionalData = payload.additionalData
                  if additionalData?["actionSelected"] != nil {
                    fullMessage = fullMessage! + "\nPressed ButtonID: \(String(describing: additionalData!["actionSelected"]))"
                  }
               }
            }

            let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]

            // Replace 'YOUR_APP_ID' with your OneSignal App ID.
            OneSignal.initWithLaunchOptions(launchOptions,
      //      appId: "6f28b224-5b2c-4572-9992-a2c14c8f3282",
           appId: "34603bb9-40dc-4bc6-9cad-7d496820af6e",
                
            handleNotificationReceived: notificationReceivedBlock,
            handleNotificationAction: notificationOpenedBlock,
            settings: onesignalInitSettings)

            OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

            // Recommend moving the below line to prompt for push after informing the user about
            //   how your app will use them.
            OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
            })
            do {
                try Network.reachability = Reachability(hostname: "www.google.com")
            }
            catch {
                switch error as? Network.Error {
                case let .failedToCreateWith(hostname)?:
                    print("Network error:\nFailed to create reachability object With host named:", hostname)
                case let .failedToInitializeWith(address)?:
                    print("Network error:\nFailed to initialize reachability object With address:", address)
                case .failedToSetCallout?:
                    print("Network error:\nFailed to set callout")
                case .failedToSetDispatchQueue?:
                    print("Network error:\nFailed to set DispatchQueue")
                case .none:
                    print(error)
                }
            }
        //     loadRootViewController()
            return true
        }
   
}


//        func applicationWillResignActive(_ application: UIApplication) {
//            // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//            // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//        }
//
//        func applicationDidEnterBackground(_ application: UIApplication) {
//            // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//            // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        }
//
//        func applicationWillEnterForeground(_ application: UIApplication) {
//            // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//        }
//
//        func applicationDidBecomeActive(_ application: UIApplication) {
//            // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        }
//
//        func applicationWillTerminate(_ application: UIApplication) {
//            // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        }
//
//
//    }

