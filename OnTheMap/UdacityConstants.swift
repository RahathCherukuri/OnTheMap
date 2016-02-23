//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Rahath cherukuri on 2/20/16.
//  Copyright © 2016 Rahath cherukuri. All rights reserved.
//

// MARK: - TMDBClient (Constants)

extension TMDBClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let BaseURL : String = "http://www.udacity.com/api/"
        static let BaseURLSecure : String = "https://www.udacity.com/api/"
        static let AuthorizationURL : String = "https://www.udacity.com/account/auth#!/signin"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Account
//        static let Account = "account"
//        static let AccountIDFavoriteMovies = "account/{id}/favorite/movies"
//        static let AccountIDFavorite = "account/{id}/favorite"
//        static let AccountIDWatchlistMovies = "account/{id}/watchlist/movies"
//        static let AccountIDWatchlist = "account/{id}/watchlist"
        
        // MARK: Authentication
        static let AuthenticationSession = "session"
        
        // MARK: GetUserData
        static let getUserData = "users/{user_id}"
    }

//    // MARK: URL Keys
//    struct URLKeys {
//        
//        static let UserID = "id"
//    }
    
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
        
//        // MARK: Account
//        static let UserID = "id"
//        
//        // MARK: Config
//        static let ConfigBaseImageURL = "base_url"
//        static let ConfigSecureBaseImageURL = "secure_base_url"
//        static let ConfigImages = "images"
//        static let ConfigPosterSizes = "poster_sizes"
//        static let ConfigProfileSizes = "profile_sizes"
//        
//        // MARK: Movies
//        static let MovieID = "id"
//        static let MovieTitle = "title"        
//        static let MoviePosterPath = "poster_path"
//        static let MovieReleaseDate = "release_date"
//        static let MovieReleaseYear = "release_year"
//        static let MovieResults = "results"
        
    }
    
//    // MARK: Poster Sizes
//    struct PosterSizes {
//        
//        static let RowPoster = TMDBClient.sharedInstance().config.posterSizes[2]
//        static let DetailPoster = TMDBClient.sharedInstance().config.posterSizes[4]
//        
//    }

}