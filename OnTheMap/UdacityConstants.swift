//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Rahath cherukuri on 2/20/16.
//  Copyright © 2016 Rahath cherukuri. All rights reserved.
//

// MARK: - OTMClient (Constants)

extension OTMClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let BaseURL : String = "http://www.udacity.com/api/"
        static let BaseURLSecure : String = "https://www.udacity.com/api/"
        static let AuthorizationURL : String = "https://www.udacity.com/account/auth#!/signin"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Authentication
        static let AuthenticationSession = "session"
        
        // MARK: GetUserData
        static let getUserData = "users/{user_id}"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        
        static let Username = "username"
        static let Password = "password"
        
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        
        static let Username = "username"
        static let Password = "password"
        
    }

    // MARK: JSON Response Keys
    struct JSONResponseKeys {
      
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Authorization
        static let Session = "session"
        static let id = "id"
    }

}