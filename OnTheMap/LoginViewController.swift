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
    @IBOutlet weak var debugLabel: UILabel!
    
    // Handling Taps
    var tapRecognizer: UITapGestureRecognizer? = nil

    // Handling View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        /* Add tap recognizer */
        self.addKeyboardDismissRecognizer();
        
        /* Subscribe to all keyboard events */
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        /* Remove tap recognizer */
        self.removeKeyboardDismissRecognizer()
        
        /* Unsubscribe to all keyboard events */
        self.unsubscribeToKeyboardNotifications()
    }

    // MARK: Actions
    @IBAction func loginButton(sender: AnyObject) {
        
//        let username = self.usernameTextField!.text!
//        let password = self.passwordTextField!.text!

        let username = "rcheruku@syr.edu"
        let password = "amanteddu"
        
        if usernameTextField!.text!.isEmpty {
            debugLabel.text = "Please enter your email."
        } else if passwordTextField!.text!.isEmpty {
            debugLabel.text = "Please enter your password."
        } else {
        UdacityClient.sharedInstance().getSessionID(username, password: password) { (success, sessionID, errorString) in
                if success {
                    print("sessionID: ", UdacityClient.sharedInstance().sessionID!)
                    dispatch_async(dispatch_get_main_queue(),{
                     self.completeLogin()
                    })
                } else {
                    print("errorString: ", errorString)
                    dispatch_async(dispatch_get_main_queue(),{
                        self.showAlertView(errorString!)
                    })
                }
        }
        }
        
    }
    
    @IBAction func signUpButton(sender: UIButton) {
        
        let app = UIApplication.sharedApplication()
        let toOpen = UdacityClient.Constants.AuthorizationURL
        app.openURL(NSURL(string:toOpen)!)
    }
    
    // Additional Methods
    
    func completeLogin() {
        usernameTextField!.text = ""
        passwordTextField!.text = ""
        debugLabel.text = ""
        openTabBarController();
    }
    
    func openTabBarController() {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: Show/Hide Keyboard
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0.0 {
            self.view.frame.origin.y -= self.getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0.0 {
            self.view.frame.origin.y = 0.0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

}

extension LoginViewController {
    func dismissAnyVisibleKeyboards() {
        if usernameTextField.isFirstResponder() || passwordTextField.isFirstResponder(){
            self.view.endEditing(true)
        }
    }
    
    func showAlertView(message: String) {
        let alert = UIAlertController(title: "Login Failed", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction (title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

