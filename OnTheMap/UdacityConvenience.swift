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
                    completionHandler(success: false, sessionID: nil, errorString: "Please check your internet connection and try again.")
                } else {
                    if let session = JSONResult[UdacityClient.JSONResponseKeys.Session] as? NSDictionary,
                        let account = JSONResult[UdacityClient.JSONResponseKeys.Account] as? NSDictionary
                    {
                        if let id = session[UdacityClient.JSONResponseKeys.id] as? String,
                            let key = account[UdacityClient.JSONResponseKeys.Key] as? String
                        {
                            self.sessionID = id
                            self.key = key
                            completionHandler(success: true, sessionID: id, errorString: nil)
                        } else {
                            print("Could not find \(UdacityClient.JSONResponseKeys.id) or \(UdacityClient.JSONResponseKeys.Key) in \(JSONResult)")
                            completionHandler(success: false, sessionID: nil, errorString: "Incorrect Username or Password")
                        }
                    } else {
                        print("Could not find \(UdacityClient.JSONResponseKeys.Session) in \(JSONResult)")
                        completionHandler(success: false, sessionID: nil, errorString: "Incorrect Username or Password")
                    }
                }
        }
    }
    
    func deleteSession(completionHandler: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters: [String : AnyObject] = [ : ]
        let method: String = Methods.AuthenticationSession
        /* 2. Make the request */
        taskForDeleteMethod(method, parameters: parameters){(JSONResult, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print("error: ", error)
                completionHandler(success: false, sessionID: nil, errorString: "Please check your internet connection and try again.")
            } else {
                if let session = JSONResult[UdacityClient.JSONResponseKeys.Session] as? NSDictionary {
                    if let id = session[UdacityClient.JSONResponseKeys.id] as? String {
                        self.sessionID = nil
                        completionHandler(success: true, sessionID: id, errorString: nil)
                    } else {
                        print("Could not find \(UdacityClient.JSONResponseKeys.id) in \(JSONResult)")
                        completionHandler(success: false, sessionID: nil, errorString: "Server error try again later.")
                    }
                } else {
                    print("Could not find \(UdacityClient.JSONResponseKeys.Session) in \(JSONResult)")
                    completionHandler(success: false, sessionID: nil, errorString: "Server error try again later.")
                }
            }
        }
    }
    
    
    func getUserData(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters: [String : AnyObject] = [ : ]
        let method: String = Methods.getUserData
        /* 2. Make the request */
        taskForGETMethod(method, parameters: parameters) {(JSONResult, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print("error: ", error)
                completionHandler(success: false, errorString: "Please check your internet connection and try again.")
            } else {
                if let user = JSONResult[UdacityClient.JSONResponseKeys.User] as? NSDictionary {
                    if let firstname = user[UdacityClient.JSONResponseKeys.FirstName] as? String,
                        let lastname = user[UdacityClient.JSONResponseKeys.LastName] as? String
                    {
                        PostStudentInfo.sharedInstance().firstName = firstname
                        PostStudentInfo.sharedInstance().lastName = lastname
                        completionHandler(success: true, errorString: nil)
                    } else {
                        print("Could not find \(UdacityClient.JSONResponseKeys.id) in \(JSONResult)")
                        completionHandler(success: false, errorString: "Server error try again later.")
                    }
                } else {
                    print("Could not find \(UdacityClient.JSONResponseKeys.Session) in \(JSONResult)")
                    completionHandler(success: false, errorString: "Server error try again later.")
                }
            }
        }
    }
    
}