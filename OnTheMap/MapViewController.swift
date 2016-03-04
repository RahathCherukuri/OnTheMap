//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Rahath cherukuri on 2/26/16.
//  Copyright © 2016 Rahath cherukuri. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidload")
    }
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear")
        super.viewWillAppear(animated)
        getStudentInformation()
    }
    
    @IBAction func logOutButtonAction(sender: UIBarButtonItem) {
        logoutButton.enabled = false
        UdacityClient.sharedInstance().deleteSession(){ (success, id, errorString) in
            if success {
                print("success: ", success)
                print("id: ", id)
                dispatch_async(dispatch_get_main_queue(),{
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            } else {
                print("errorString: ", errorString)
                dispatch_async(dispatch_get_main_queue(),{
                    self.logoutButton.enabled = true
                    self.showAlertView(errorString!)
                })
            }
        }
    }
    
    @IBAction func postInformation(sender: UIBarButtonItem) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("PostInformationViewController") as! PostInformationViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonAction(sender: UIBarButtonItem) {
        getStudentInformation()
    }
    
    func populateStudentInfoOntheMap() {
        
        let studentInfo = StudentInfo.studentInfo
        print("mapViewCount: ", studentInfo.count)
        
        // Remove the annotations .
        if(annotations.count != 0) {
            self.mapView.removeAnnotations(annotations)
            annotations = [MKPointAnnotation]()
        }
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        
        for dictionary in studentInfo {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    
    func getStudentInformation() {
        ParseClient.sharedInstance().getstudentInformation () { (success, results, errorString) in
            if success {
                print("success: ", success)
                ParseClient.sharedInstance().parseResultsAndSaveInStudentInfo(results!)
                dispatch_async(dispatch_get_main_queue(),{
                    self.populateStudentInfoOntheMap()
                })

            } else {
                print("errorString: ", errorString)
                dispatch_async(dispatch_get_main_queue(),{
                    self.showAlertView(errorString!)
                })
            }
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                guard let url = NSURL(string:toOpen) as NSURL? else {
                    self.showAlertView("Invalid Link")
                    return
                }
                app.openURL(url)
            }
        }
    }
    
    func showAlertView(message: String) {
        let alert = UIAlertController(title: "Login Failed", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let dismiss = UIAlertAction (title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(dismiss)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    //
    //        if control == annotationView.rightCalloutAccessoryView {
    //            let app = UIApplication.sharedApplication()
    //            app.openURL(NSURL(string: annotationView.annotation.subtitle))
    //        }
    //    }
    
}
