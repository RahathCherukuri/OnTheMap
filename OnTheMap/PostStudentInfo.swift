//
//  PostStudentInfo.swift
//  OnTheMap
//
//  Created by Rahath cherukuri on 2/29/16.
//  Copyright © 2016 Rahath cherukuri. All rights reserved.
//

import Foundation


class PostStudentInfo: NSObject {
    
    var firstName: String!
    var lastName: String!
    var mapString: String!
    var mediaURL: String!
    var latitude: Double!
    var longitude: Double!
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> PostStudentInfo {
        
        struct Singleton {
            static var sharedInstance = PostStudentInfo()
        }
        
        return Singleton.sharedInstance
    }
}