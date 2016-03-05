//
//  PostInformationViewController.swift
//  OnTheMap
//
//  Created by Rahath cherukuri on 2/29/16.
//  Copyright © 2016 Rahath cherukuri. All rights reserved.
//

import UIKit
import MapKit

class PostInformationViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var linkTextField: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var findOnTheMapButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    // Handling Taps
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    //Keyboard Notifications
    var keyboardAdjusted = false
    var lastKeyboardOffset: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }
    
    override func viewWillAppear(animated: Bool) {
        
        /* Add tap recognizer */
        addKeyboardDismissRecognizer();
        
        /* Subscribe to all keyboard events */
        subscribeToKeyboardNotifications()
        
        mapView.hidden = true
        linkTextField.hidden = true
        submitButton.hidden = true
        activityView.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        /* Remove tap recognizer */
        removeKeyboardDismissRecognizer()
        
        /* Unsubscribe to all keyboard events */
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func searchOnTheMap(sender: UIButton) {
        
        let location = locationTextField.text!
        
        if locationTextField!.text!.isEmpty {
            dispatch_async(dispatch_get_main_queue(),{
                self.showAlertView("Please enter Location")
            })
        }
        activityView.hidden = false
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(),{
                    self.showAlertView("Please check your internet connection.")
                })
            } else {
                dispatch_async(dispatch_get_main_queue(),{
                    self.addUserLocation(placemarks!)
                    self.setSecondaryView()
                })
            }
        })
    }
    
    @IBAction func submitButtonPressed(sender: UIButton) {
        if linkTextField!.text!.isEmpty {
            dispatch_async(dispatch_get_main_queue(),{
                self.showAlertView("Please enter URL")
            })
        } else {
            PostStudentInfo.sharedInstance().mediaURL = linkTextField!.text!
            ParseClient.sharedInstance().postStudentInformation() { (success, objectID, createdAt, errorString) in
                if success {
                    dispatch_async(dispatch_get_main_queue(),{
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(),{
                        self.showAlertView(errorString!)
                    })
                }

            }
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setSecondaryView() {
        locationLabel.text = "Enter the URL:"
        activityView.hidden = true
        bottomView.alpha = 0.3
        locationTextField.hidden = true
        findOnTheMapButton.hidden = true
        mapView.hidden = false
        linkTextField.hidden = false
        submitButton.hidden = false
    }
    
    // Drops pin on the map for user provided location.
    func addUserLocation(placemarks: [AnyObject]) {
        
        let placemarks = placemarks as! [CLPlacemark]
        var region = MKCoordinateRegion?()
        region = self.setRegion(placemarks)

        
        let annotation = MKPointAnnotation()
        let latitude = region!.center.latitude
        let longitude = region!.center.longitude
        PostStudentInfo.sharedInstance().latitude = latitude
        PostStudentInfo.sharedInstance().longitude = longitude
        PostStudentInfo.sharedInstance().mapString = locationTextField.text!
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        mapView.setRegion(region!, animated: true)
        mapView.addAnnotation(annotation)
    }
    
    // Zooms into the provided location.
    func setRegion(placemarks: [CLPlacemark]) -> MKCoordinateRegion? {
        
        var regions = [MKCoordinateRegion]()
        
        for placemark in placemarks {
            
            let coordinate: CLLocationCoordinate2D = placemark.location!.coordinate
            let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            regions.append(MKCoordinateRegion(center: coordinate, span: span))
        }
        return regions.first
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
    
    func showAlertView(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let dismiss = UIAlertAction (title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(dismiss)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

// Mark: - Keyboard Methods
extension PostInformationViewController {
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
            self.view.superview?.frame.origin.y -= lastKeyboardOffset
            keyboardAdjusted = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if keyboardAdjusted == true {
            self.view.superview?.frame.origin.y += lastKeyboardOffset
            keyboardAdjusted = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
}
