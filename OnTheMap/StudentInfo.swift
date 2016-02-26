//
//  StudentInfo.swift
//  OnTheMap
//
//  Created by Rahath cherukuri on 2/23/16.
//  Copyright © 2016 Rahath cherukuri. All rights reserved.
//

import Foundation

struct StudentInfo {
    
    static var studentInfo: [StudentInfo] = []
    var createdAt: String
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    var objectId: String
    var uniqueKey: String
    var updatedAt: String
    
    init(createdAt: String, firstName: String, lastName: String, latitude: Double, longitude: Double, mapString: String,
         mediaURL: String, objectId: String, uniqueKey: String, updatedAt: String) {
            self.createdAt = createdAt
            self.firstName = firstName
            self.lastName = lastName
            self.latitude = latitude
            self.longitude = longitude
            self.mapString = mapString
            self.mediaURL = mediaURL
            self.objectId = objectId
            self.uniqueKey = uniqueKey
            self.updatedAt = updatedAt
            StudentInfo.studentInfo.append(self)
    }
}