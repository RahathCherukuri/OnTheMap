//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Rahath cherukuri on 2/20/16.
//  Copyright © 2016 Rahath cherukuri. All rights reserved.
//

import UIKit
import Foundation

// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    
    func getSessionID(username: String, password: String, completionHandler: (success: Bool, sessionID: String?, errorString: String?) -> Void) {

        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters: [String : AnyObject] = [ : ]
        let method: String = Methods.AuthenticationSession
        let jsonData: [String : AnyObject] = [ParameterKeys.Username : username, ParameterKeys.Password : password]
        let jsonBody = ["udacity": jsonData]
        
        /* 2. Make the request */
        taskForPOSTMethod(method, parameters: parameters, jsonBody: jsonBody) { (JSONResult, error) in
                /* 3. Send the desired value(s) to completion handler */
                if let error = error {
                    print("error: ", error)
                    completionHandler(success: false, sessionID: nil, errorString: "Login Failed (SessionID).")
                } else {
                    if let session = JSONResult[UdacityClient.JSONResponseKeys.Session] as? NSDictionary {
                        if let id = session[UdacityClient.JSONResponseKeys.id] as? String {
                            self.sessionID = id
                            completionHandler(success: true, sessionID: id, errorString: nil)
                        } else {
                            print("Could not find \(UdacityClient.JSONResponseKeys.id) in \(JSONResult)")
                            completionHandler(success: false, sessionID: nil, errorString: "Login Failed (SessionID).")
                        }
                    } else {
                        print("Could not find \(UdacityClient.JSONResponseKeys.Session) in \(JSONResult)")
                        completionHandler(success: false, sessionID: nil, errorString: "Login Failed (SessionID).")
                    }
                }
        }
    }
}