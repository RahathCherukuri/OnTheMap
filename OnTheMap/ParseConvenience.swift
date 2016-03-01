//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Rahath cherukuri on 2/22/16.
//  Copyright © 2016 Rahath cherukuri. All rights reserved.
//
import UIKit
import Foundation

// MARK: - ParseClient (Convenient Resource Methods)

extension ParseClient {
    
    //TODO: Save UniqueKey, firstname and lastname into postStudentInfo
    func getstudentInformation(completionHandler: (success: Bool, results: [[String: AnyObject]]?, errorString: String?) -> Void) {
        let method: String = ParseClient.Methods.studentLocation
        let parameters: [String: AnyObject] = [ : ]
        
        taskForGETMethod(method , parameters: parameters){ (JSONResult, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandler(success: false, results: nil, errorString: "Student Information Retreival Failed")
            } else {
                if let results = JSONResult[ParseClient.JSONResponseKeys.Results] as? [[String: AnyObject]] {
                    completionHandler(success: true, results: results, errorString: nil)
                } else {
                    print("Could not find \(ParseClient.JSONResponseKeys.Results) in \(JSONResult)")
                    completionHandler(success: false, results: nil, errorString: "Student Information Retreival Failed.")
                }
            }
        }
    }
    
    
    func postStudentInformation(completionHandler: (success: Bool, objectId: String?, errorString: String?) -> Void) {
        let parameters: [String: AnyObject] = [ : ]
        let method: String = ParseClient.Methods.studentLocation
        
        // TODO: Add uniquekey to pass in the jsonBody
        let jsonBody: [String: AnyObject] = [
        "firstName": PostStudentInfo.sharedInstance().firstName,
        "lastName": PostStudentInfo.sharedInstance().lastName,
        "mapString": PostStudentInfo.sharedInstance().mapString,
        "mediaURL": PostStudentInfo.sharedInstance().mediaURL,
        "latitude": PostStudentInfo.sharedInstance().latitude,
        "longitude": PostStudentInfo.sharedInstance().longitude
        ]
        
        /* 2. Make the request */
        taskForPOSTMethod(method, parameters: parameters, jsonBody: jsonBody) { (JSONResult, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print("error: ", error)
                completionHandler(success: false, objectId: nil, errorString: "Posting student information failed!")
            } else {
                if let objectId = JSONResult[ParseClient.JSONResponseKeys.ObjectID] as? String {
                        completionHandler(success: true, objectId: objectId, errorString: nil)
                } else {
                    print("Could not find \(UdacityClient.JSONResponseKeys.Session) in \(JSONResult)")
                    completionHandler(success: false, objectId: nil, errorString: "Posting student information failed!")
                }
            }
        }

    }
    
    func parseResultsAndSaveInStudentInfo(results: [[String: AnyObject]]) {
        
        for (result) in results {
            guard let createdAt = result[ParseClient.JSONResponseKeys.CreatedAt] as? String,
                    let firstName = result[ParseClient.JSONResponseKeys.FirstName] as? String,
                    let lastName = result[ParseClient.JSONResponseKeys.LastName] as? String,
                    let latitude = result[ParseClient.JSONResponseKeys.Latitude] as? Double,
                    let longitude = result[ParseClient.JSONResponseKeys.Longitude] as? Double,
                    let mapString = result[ParseClient.JSONResponseKeys.MapString] as? String,
                    let mediaURL = result[ParseClient.JSONResponseKeys.MediaURL] as? String,
                    let objectId = result[ParseClient.JSONResponseKeys.ObjectId] as? String,
                    let uniqueKey = result[ParseClient.JSONResponseKeys.UniqueKey] as? String,
                    let updatedAt = result[ParseClient.JSONResponseKeys.UpdatedAt] as? String
                else {
                    print("Error in parsing results")
                    return
                }
            StudentInfo(createdAt: createdAt, firstName: firstName, lastName: lastName, latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL, objectId: objectId, uniqueKey: uniqueKey, updatedAt: updatedAt)
        }
    }

}
