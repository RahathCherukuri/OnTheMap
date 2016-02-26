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
        let username = self.usernameTextField!.text!
        let password = self.passwordTextField!.text!
        
        UdacityClient.sharedInstance().getSessionID(username, password: password) { (success, sessionID, errorString) in
                if success {
                    print("sessionID: ", UdacityClient.sharedInstance().sessionID!)
                } else {
                    print("errorString: ", errorString)
                }
        }
        
//      code to launch table/mapviews
        
        ParseClient.sharedInstance().getstudentInformation () { (success, results, errorString) in
            if success {
                print("success: ", success)
                ParseClient.sharedInstance().parseResultsAndSaveInStudentInfo(results!)
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
                self.presentViewController(controller, animated: true, completion: nil)
            } else {
                print("errorString: ", errorString)
            }
        }
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
}

