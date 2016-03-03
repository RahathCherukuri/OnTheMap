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
    
    override func viewWillAppear(animated: Bool) {
        mapView.hidden = true
        linkTextField.hidden = true
        submitButton.hidden = true
        activityView.hidden = true
    }

    @IBAction func searchOnTheMap(sender: UIButton) {
        
        let location = locationTextField.text!
        
        bottomView.alpha = 0.3
        locationTextField.hidden = true
        findOnTheMapButton.hidden = true
        mapView.hidden = false
        activityView.hidden = false
        linkTextField.hidden = false
        submitButton.hidden = false
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if error != nil {
                print("Its an error")
            } else {
                dispatch_async(dispatch_get_main_queue(),{
                    self.addUserLocation(placemarks!)
                    self.locationLabel.text = "Enter the URL:"
                    self.activityView.hidden = true
                })
                print("placemarks: ", placemarks)
            }
        })
    }
    
    @IBAction func submitButtonPressed(sender: UIButton) {
        if linkTextField!.text!.isEmpty {
            print("linkTextField is Empty!!")
        } else {
            PostStudentInfo.sharedInstance().mediaURL = linkTextField!.text!
            ParseClient.sharedInstance().postStudentInformation() { (success, objectID, createdAt, errorString) in
                if success {
                    print("success: ", success)
                    print("objectID: ", objectID)
                    print("createdAt: ", createdAt)
                    dispatch_async(dispatch_get_main_queue(),{
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                } else {
                    print("errorString: ", errorString)
                }

            }
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
}
