//
//  NetworkRequests.swift
//  HelixSense
//
//  Created by DEEBA on 14.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import ObjectMapper
import AlamofireObjectMapper

class NetworkManager {

    let instanceOfUser = readWrite()
    // MARK: - Properties
    private static var sharedNetworkManager: NetworkManager = {
        let networkManager = NetworkManager()
        return networkManager
    }()
    
    // MARK: - Initialization
    
    private init(){
        
    }
    
    private var success: ((_ data: [ShiftsData]?) -> Void)?
    private var failure: ((_ error: Error?) -> Void)?
    private var message: ((_ mess: String?) -> Void)?
    
    // MARK: - Accessors
    class func shared() -> NetworkManager {
        return sharedNetworkManager
    }
    
    func GET_SHIFTS_DATA(params: [String: Any], onSuccess success: @escaping (_ data: [ShiftsData]?) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void, onError message: @escaping (_ mess: String?) -> Void) {
        
        self.success = success
        self.failure = failure
        self.message = message

        if let token = UserDefaults.standard.object(forKey: "access_token"){
            let token = token as! String
            self.GET_SHIFTS_DATA_WITH_TOKEN(params: params, access_token: token)
        }else{
            getToken(params: params)
        }
    }
    
    func getToken(params: [String: Any]) {
        // Build the body message to request the token to the web app
        let userName = self.instanceOfUser.readStringData(key: "Userz")
        let userPassword = self.instanceOfUser.readStringData(key: "Pwdz")
       // let userName = "thejesh.wmb@ml.in"
       // let userPassword = "12345"
        let oAuthURL = "https://demo.helixsense.com/api/authentication/oauth2/token"
        
        let bodyStr = "grant_type=password&client_id=clientkey&client_secret=clientsecret&username=" + userName + "&password=" + userPassword
        
        // Setup the request
        let myURL = URL(string: oAuthURL)!
        var request = URLRequest(url: myURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = bodyStr.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) -> Void in
            if error != nil{
                self.message!("Can't authenticate")
                return
            }
            if let unwrappedData = data {
                
                guard let json = try? JSONSerialization.jsonObject(with: unwrappedData) as? [String: Any],
                    let accessToken = json["access_token"] as? String,
                    let _ = json["refresh_token"] as? String,
                    let tokenType = json["token_type"] as? String
                    else {
                        self.message!("Can't authenticate")
                        return
                }
                let token = "\(tokenType) \(accessToken)"
                self.GET_SHIFTS_DATA_WITH_TOKEN(params: params, access_token: token)
            }
        }
        task.resume()
    }
    
    func GET_SHIFTS_DATA_WITH_TOKEN(params: [String: Any], access_token:String) {
        UserDefaults.standard.set(access_token, forKey: "access_token")
        
        let headers: HTTPHeaders = [
            "Authorization": access_token
        ]
        
        Alamofire.request(SHIFTS_URL, method: .post, parameters: params, encoding: URLEncoding.queryString, headers: headers).responseObject{(response:DataResponse<ShiftsResponse>) in
            
            switch response.result {
            case .success(let value):
                if let status = value.status {
                    if status == true {
                        self.success!(value.data)
                        return
                    }
                }
                
                if let code = value.code {
                    if code == 401{
                        //can't authenticate
                        self.getToken(params: params)
                    }else{
                        self.message!(value.error?.message)
                    }
                }else {
                    self.message!(value.error?.message)
                }
                
            case .failure(let error):
                self.failure!(error)
            }
        }
    }
}
