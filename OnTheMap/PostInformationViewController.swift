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
    
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    @IBAction func searchOnTheMap(sender: UIButton) {
        
        let location = locationTextField.text!
        print(location)
        
        mapView.hidden = false
        linkTextField.hidden = false
        bottomView.hidden = true
        locationTextField.hidden = true
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if error != nil {
                print("Its an error")
            } else {
                self.addUserLocation(placemarks!)
                self.locationLabel.text = "Enter the URL:"
                print("placemarks: ", placemarks)
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        mapView.hidden = true
        linkTextField.hidden = true
    }
    
    
    // Drops pin on the map for user provided location.
    func addUserLocation(placemarks: [AnyObject]) {
        
        let placemarks = placemarks as! [CLPlacemark]
        var region = MKCoordinateRegion?()
        region = self.setRegion(placemarks)

        
        let annotation = MKPointAnnotation()
        let latitude = region!.center.latitude
        let longitude = region!.center.longitude
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        mapView.setRegion(region!, animated: true)
        mapView.addAnnotation(annotation)
    }
    
    // Zooms into the provided location.
    func setRegion(placemarks: [CLPlacemark]) -> MKCoordinateRegion? {
        
        var regions = [MKCoordinateRegion]()
        
        for placemark in placemarks {
            
            let coordinate: CLLocationCoordinate2D = placemark.location!.coordinate
            //let latitude: CLLocationDegrees = placemark.location!.coordinate.latitude
            //let longitude: CLLocationDegrees = placemark.location!.coordinate.longitude
            let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            
            regions.append(MKCoordinateRegion(center: coordinate, span: span))
        }
        
        return regions.first
    }
    
}
