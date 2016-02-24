//
//  ViewController.swift
//  OnTheMap
//
//  Created by Rahath cherukuri on 2/20/16.
//  Copyright © 2016 Rahath cherukuri. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButton(sender: AnyObject) {
//        let username = self.usernameTextField!.text!
//        let password = self.passwordTextField!.text!
        
//        UdacityClient.sharedInstance().getSessionID(username, password: password) { (success, sessionID, errorString) in
//                if success {
//                    print("sessionID: ", UdacityClient.sharedInstance().sessionID!)
//                } else {
//                    print("errorString: ", errorString)
//                }
//        }
        
        // code to launch table/mapviews
//        ParseClient.sharedInstance().getstudentInformation () { (success, results, errorString) in
//            if success {
//                print("success: ", success)
//                print("results: ", results)
//            } else {
//                print("errorString: ", errorString)
//            }
//        }

        //Code to parse data and store in Struct.
        
        let results: [[String: AnyObject]] =
        [
            [
            "createdAt": "2015-02-25T01:10:38.103Z",
            "firstName": "Jarrod",
            "lastName": "Parkes",
            "latitude": 34.7303688,
            "longitude": -86.5861037,
            "mapString": "Huntsville, Alabama ",
            "mediaURL": "https://www.linkedin.com/in/jarrodparkes",
            "objectId": "JhOtcRkxsh",
            "uniqueKey": "996618664",
            "updatedAt": "2015-03-09T22:04:50.315Z"
            ],
            [
                "createdAt":"2015-02-24T22:27:14.456Z",
                "firstName":"Jessica",
                "lastName":"Uelmen",
                "latitude":28.1461248,
                "longitude":-82.756768,
                "mapString":"Tarpon Springs, FL",
                "mediaURL":"www.linkedin.com/in/jessicauelmen/en",
                "objectId":"kj18GEaWD8",
                "uniqueKey":"872458750",
                "updatedAt":"2015-03-09T22:07:09.593Z"
            ],
            [
                "createdAt":"2015-02-24T22:30:54.442Z",
                "firstName":"Jason",
                "lastName":"Schatz",
                "latitude":37.7617,
                "longitude":-122.4216,
                "mapString":"18th and Valencia, San Francisco, CA",
                "mediaURL":"http://en.wikipedia.org/wiki/Swift_%28programming_language%29",
                "objectId":"hiz0vOTmrL",
                "uniqueKey":"2362758535",
                "updatedAt":"2015-03-10T17:20:31.828Z"
            ]
        ]
        
        ParseClient.sharedInstance().parseResultsAndSaveInStudentInfo(results)
    }
    
    @IBAction func signUpButton(sender: UIButton) {
        UdacityClient.sharedInstance().signUp(self) { (success, errorString) in
            if success {
                print("success: ", success)
            } else {
                print("errorString: ", errorString)
            }
        }
        
    }

}

