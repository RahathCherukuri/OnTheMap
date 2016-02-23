//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Rahath cherukuri on 2/20/16.
//  Copyright © 2016 Rahath cherukuri. All rights reserved.
//

import UIKit
import Foundation

// MARK: - TMDBClient (Convenient Resource Methods)

extension TMDBClient {
    
    func getSessionID(username: String, password: String, completionHandler: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
            let method: String = Methods.AuthenticationSession
        let jsonData: [String : AnyObject] = [ParameterKeys.Username : username, ParameterKeys.Password : password]
        let jsonBody = ["udacity": jsonData]
        let parameters: [String : AnyObject] = [ : ]
        
        taskForPOSTMethod(method, parameters: parameters, jsonBody: jsonBody) { (JSONResult, error) in
                /* 3. Send the desired value(s) to completion handler */
                if let error = error {
                    print("error: ", error)
                    completionHandler(success: false, sessionID: nil, errorString: "Login Failed (SessionID).")
                } else {
                    if let session = JSONResult[TMDBClient.JSONResponseKeys.Session] as? NSDictionary {
                        if let id = session[TMDBClient.JSONResponseKeys.id] as? String {
                            self.sessionID = id
                            completionHandler(success: true, sessionID: id, errorString: nil)
                        } else {
                            print("Could not find \(TMDBClient.JSONResponseKeys.id) in \(JSONResult)")
                            completionHandler(success: false, sessionID: nil, errorString: "Login Failed (SessionID).")
                        }
                    } else {
                        print("Could not find \(TMDBClient.JSONResponseKeys.Session) in \(JSONResult)")
                        completionHandler(success: false, sessionID: nil, errorString: "Login Failed (SessionID).")
                    }
                    
                }
        }
    }
    
    
    /* This function opens a WebView to handle the signUp */
    func signUp(hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let authorizationURL = NSURL(string: "\(TMDBClient.Constants.AuthorizationURL)")
        let request = NSURLRequest(URL: authorizationURL!)
        let webAuthViewController = hostViewController.storyboard!.instantiateViewControllerWithIdentifier("WebAuthViewController") as! WebAuthViewController
        webAuthViewController.urlRequest = request
        webAuthViewController.completionHandler = completionHandler
        
        let webAuthNavigationController = UINavigationController()
        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
        
        dispatch_async(dispatch_get_main_queue(), {
            hostViewController.presentViewController(webAuthNavigationController, animated: true, completion: nil)
        })
    }
    
}





    // MARK: Authentication (GET) Methods
//    /*
//    Steps for Authentication...
//    https://www.themoviedb.org/documentation/api/sessions
//    
//    Step 1: Create a new request token
//    Step 2a: Ask the user for permission via the website
//    Step 3: Create a session ID
//    Bonus Step: Go ahead and get the user id 😎!
//    */
//    func authenticateWithViewController(hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
//        
//        /* Chain completion handlers for each request so that they run one after the other */
//        self.getRequestToken() { (success, requestToken, errorString) in
//            
//            if success {
//                print("requestToken: \(requestToken)")
//                self.loginWithToken(requestToken, hostViewController: hostViewController) { (success, errorString) in
//                    if success {
//                        self.getSessionID(requestToken!) { (success, sessionID,errorString) in
//                            if success {
//                                self.sessionID = sessionID!
//                                print("Valid Session ID!!\(sessionID)")
//                                self.getUserID(sessionID!) { (success, userID, errorString) in
//                                    if success {
//                                        self.userID = userID!
//                                        print("valid UserID!!\(userID)")
//                                        completionHandler (success: success, errorString: errorString)
//                                    } else {
//                                        completionHandler(success: success, errorString: errorString)
//                                    }
//                                }
//                            } else {
//                                completionHandler(success: success, errorString: errorString)
//                            }
//                        }
//                    } else {
//                        completionHandler(success: success, errorString: errorString)
//                    }
//                }
//            } else {
//                completionHandler(success: success, errorString: errorString)
//            }
//        }
//    }
//    
//    func getRequestToken(completionHandler: (success: Bool, requestToken: String?, errorString: String?) -> Void) {
//        
//        let method = Methods.AuthenticationTokenNew
//        let parameters: [String : AnyObject] = [ : ]
//        taskForGETMethod(method, parameters: parameters) { (JSONResult, error) in
//            
//            /* 3. Send the desired value(s) to completion handler */
//            if let error = error {
//                print(error)
//                completionHandler(success: false, requestToken: nil, errorString: "Login Failed (Request Token).")
//            } else {
//                if let requestToken = JSONResult[TMDBClient.JSONResponseKeys.RequestToken] as? String {
//                    completionHandler(success: true, requestToken: requestToken, errorString: nil)
//                } else {
//                    print("Could not find \(TMDBClient.JSONResponseKeys.RequestToken) in \(JSONResult)")
//                    completionHandler(success: false, requestToken: nil, errorString: "Login Failed (Request Token).")
//                }
//            }
//        }
//    }
    
    // TODO: Make the following methods into convenience functions!
    
//    /* This function opens a TMDBAuthViewController to handle Step 2a of the auth flow */
//    func loginWithToken(requestToken: String?, hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
//
//        let authorizationURL = NSURL(string: "\(TMDBClient.Constants.AuthorizationURL)\(requestToken!)")
//        let request = NSURLRequest(URL: authorizationURL!)
//        let webAuthViewController = hostViewController.storyboard!.instantiateViewControllerWithIdentifier("TMDBAuthViewController") as! TMDBAuthViewController
//        webAuthViewController.urlRequest = request
//        webAuthViewController.requestToken = requestToken
//        webAuthViewController.completionHandler = completionHandler
//
//        let webAuthNavigationController = UINavigationController()
//        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
//
//        dispatch_async(dispatch_get_main_queue(), {
//            hostViewController.presentViewController(webAuthNavigationController, animated: true, completion: nil)
//        })
//    }
    
    
//    func getSessionID(requestToken: String, completionHandler: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
//        let method: String = Methods.AuthenticationSessionNew
//        let parameters: [String : AnyObject] = [ParameterKeys.RequestToken: requestToken]
//        
//        taskForGETMethod(method, parameters: parameters) { (JSONResult, error) in
//            /* 3. Send the desired value(s) to completion handler */
//            if let error = error {
//                print(error)
//                completionHandler(success: false, sessionID: nil, errorString: "Login Failed (SessionID).")
//            } else {
//                if let sessionID = JSONResult[TMDBClient.JSONResponseKeys.SessionID] as? String {
//                    completionHandler(success: true, sessionID: sessionID, errorString: nil)
//                } else {
//                    print("Could not find \(TMDBClient.JSONResponseKeys.SessionID) in \(JSONResult)")
//                    completionHandler(success: false, sessionID: nil, errorString: "Login Failed (SessionID).")
//                }
//                
//            }
//        }
//    }
    
//    func getUserID(session_id: String, completionHandler: (success: Bool, userID: Int?, errorString: String?) -> Void) {
//        let method: String = Methods.Account
//        let parameters: [String: AnyObject] = [ParameterKeys.SessionID:session_id]
//        
//        taskForGETMethod(method , parameters: parameters){ (JSONResult, error) in
//            /* 3. Send the desired value(s) to completion handler */
//            if let error = error {
//                print(error)
//                completionHandler(success: false, userID: nil, errorString: "Login Failed (UserID).")
//            } else {
//                if let userID = JSONResult[TMDBClient.JSONResponseKeys.UserID] as? Int {
//                    completionHandler(success: true, userID: userID, errorString: nil)
//                } else {
//                    print("Could not find \(TMDBClient.JSONResponseKeys.SessionID) in \(JSONResult)")
//                    completionHandler(success: false, userID: nil, errorString: "Login Failed (UserID).")
//                }
//            }
//        }
//        
//    }
//
//    func getConfig(completionHandler: (didSucceed: Bool, error: NSError?) -> Void) {
//        
//        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
//        let parameters = [String: AnyObject]()
//        
//        /* 2. Make the request */
//        taskForGETMethod(Methods.Config, parameters: parameters) { JSONResult, error in
//            
//            /* 3. Send the desired value(s) to completion handler */
//            if let error = error {
//                completionHandler(didSucceed: false, error: error)
//            } else if let newConfig = TMDBConfig(dictionary: JSONResult as! [String : AnyObject]) {
//                self.config = newConfig
//                completionHandler(didSucceed: true, error: nil)
//            } else {
//                completionHandler(didSucceed: false, error: NSError(domain: "getConfig parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getConfig"]))
//            }
//        }
//    }
    
//    // MARK: POST Convenience Methods
//    
//    func postToFavorites(movie: TMDBMovie, favorite: Bool, completionHandler: (result: Int?, error: NSError?) -> Void)  {
//        
//        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
//        let parameters = [TMDBClient.ParameterKeys.SessionID : TMDBClient.sharedInstance().sessionID!]
//        var mutableMethod : String = Methods.AccountIDFavorite
//        mutableMethod = TMDBClient.substituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.UserID, value: String(TMDBClient.sharedInstance().userID!))!
//        let jsonBody : [String:AnyObject] = [
//            TMDBClient.JSONBodyKeys.MediaType: "movie",
//            TMDBClient.JSONBodyKeys.MediaID: movie.id as Int,
//            TMDBClient.JSONBodyKeys.Favorite: favorite as Bool
//        ]
//        
//        /* 2. Make the request */
//        taskForPOSTMethod(mutableMethod, parameters: parameters, jsonBody: jsonBody) { JSONResult, error in
//            
//            /* 3. Send the desired value(s) to completion handler */
//            if let error = error {
//                completionHandler(result: nil, error: error)
//            } else {
//                if let results = JSONResult[TMDBClient.JSONResponseKeys.StatusCode] as? Int {
//                    completionHandler(result: results, error: nil)
//                } else {
//                    completionHandler(result: nil, error: NSError(domain: "postToFavoritesList parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToFavoritesList"]))
//                }
//            }
//        }
//    }
//    
//    func postToWatchlist(movie: TMDBMovie, watchlist: Bool, completionHandler: (result: Int?, error: NSError?) -> Void) {
//        
//        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
//        let parameters = [TMDBClient.ParameterKeys.SessionID : TMDBClient.sharedInstance().sessionID!]
//
//        var mutableMethod : String = Methods.AccountIDWatchlist
//        mutableMethod = TMDBClient.substituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.UserID, value: String(TMDBClient.sharedInstance().userID!))!
//        let jsonBody : [String:AnyObject] = [
//            TMDBClient.JSONBodyKeys.MediaType: "movie",
//            TMDBClient.JSONBodyKeys.MediaID: movie.id as Int,
//            TMDBClient.JSONBodyKeys.Watchlist: watchlist as Bool
//        ]
//        
//        /* 2. Make the request */
//        taskForPOSTMethod(mutableMethod, parameters: parameters, jsonBody: jsonBody) { JSONResult, error in
//            
//            /* 3. Send the desired value(s) to completion handler */
//            if let error = error {
//                completionHandler(result: nil, error: error)
//            } else {
//                if let results = JSONResult[TMDBClient.JSONResponseKeys.StatusCode] as? Int {
//                    completionHandler(result: results, error: nil)
//                } else {
//                    completionHandler(result: nil, error: NSError(domain: "postToWatchList parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToWatchList"]))
//                }
//            }
//        }
//    }