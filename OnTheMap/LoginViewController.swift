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
    @IBOutlet weak var logInButton: UIButton!
    
    // Handling Taps
    var tapRecognizer: UITapGestureRecognizer? = nil
    //Keyboard Notifications
    var keyboardAdjusted = false
    var lastKeyboardOffset: CGFloat = 0.0

    // Handling View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        /* Add tap recognizer */
        addKeyboardDismissRecognizer();
        
        /* Subscribe to all keyboard events */
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        /* Remove tap recognizer */
        removeKeyboardDismissRecognizer()
        
        /* Unsubscribe to all keyboard events */
        unsubscribeFromKeyboardNotifications()
    }

    // MARK: Actions
    @IBAction func loginButton(sender: AnyObject) {
        
        let username = usernameTextField!.text!
        let password = passwordTextField!.text!

        if usernameTextField!.text!.isEmpty {
            debugLabel.text = "Please enter your email."
        } else if passwordTextField!.text!.isEmpty {
            debugLabel.text = "Please enter your password."
        } else {
            logInButton.enabled = false
            logInButton.alpha = 0.5
        UdacityClient.sharedInstance().getSessionID(username, password: password) { (success, sessionID, errorString) in
                if success {
                    UdacityClient.sharedInstance().getUserData() {(success, errorString) in
                        if success {
                            dispatch_async(dispatch_get_main_queue(),{
                                self.completeLogin()
                                self.logInButton.enabled = true
                                self.logInButton.alpha = 1
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(),{
                                self.showAlertView(errorString!)
                                self.logInButton.enabled = true
                                self.logInButton.alpha = 1
                            })
                        }
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(),{
                        self.showAlertView(errorString!)
                        self.logInButton.enabled = true
                        self.logInButton.alpha = 1
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
        let controller = storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: Show/Hide Keyboard
    
    func addKeyboardDismissRecognizer() {
        view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        view.removeGestureRecognizer(tapRecognizer!)
    }

    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func showAlertView(message: String) {
        let alert = UIAlertController(title: "Login Failed", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let dismiss = UIAlertAction (title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(dismiss)
        presentViewController(alert, animated: true, completion: nil)
    }
}

// Mark: - Keyboard Methods
extension LoginViewController {
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if keyboardAdjusted == false {
            lastKeyboardOffset = getKeyboardHeight(notification) / 2
            view.superview?.frame.origin.y -= lastKeyboardOffset
            keyboardAdjusted = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if keyboardAdjusted == true {
            view.superview?.frame.origin.y += lastKeyboardOffset
            keyboardAdjusted = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
}

