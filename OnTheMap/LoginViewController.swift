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
        
        TMDBClient.sharedInstance().getSessionID(username, password: password) { (success, sessionID, errorString) in
                if success {
                    print("sessionID: ", TMDBClient.sharedInstance().sessionID!)
                    
                } else {
                    print("errorString: ", errorString)
                }
        }
    }
    
    @IBAction func signUpButton(sender: UIButton) {
        TMDBClient.sharedInstance().signUp(self) { (success, errorString) in
            if success {
                print("success: ", success)
            } else {
                print("errorString: ", errorString)
            }
        }
        
    }
    
    
}

