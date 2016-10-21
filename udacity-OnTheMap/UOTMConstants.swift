//
//  UOTMConstants.swift
//  udacity-OnTheMap
//
//  Created by Techniexe on 17/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import Foundation

extension UOTMClient {
  struct Methods {
    static let studentLocation = "https://parse.udacity.com/parse/classes/StudentLocation"
    static let session = "https://www.udacity.com/api/session"
    static let user = "https://www.udacity.com/api/users/{id}"
  }
  
  struct BodyKeys {
    // POST Session Body Keys
    static let udacity = "udacity"
    static let username = "username"
    static let password = "password"
    
    // POST Student Location Body Keys
    static let uniqueKey = "uniqueKey"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let mapString = "mapString"
    static let mediaUrl = "mediaURL"
    static let latitude = "latitude"
    static let longitude = "longitude"
  }
  
  struct ParameterKeys {
    static let udacity = "udacity"
    static let username = "username"
    static let password = "password"
    static let facebookMobile = "facebook_mobile"
    static let accessToken = "access_token"
  }
  
  struct ResponseParameterKeys {
    // Session Keys
    static let session = "session"
    static let accountKey = "key"
    static let account = "account"
    static let id = "id"
    static let expiration = "expiration"
    
    // Student Location Keys
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let mapString = "mapString"
    static let mediaUrl = "mediaURL"
    static let objectId = "objectId"
    static let uniqueKey = "uniqueKey"
    static let updatedAt = "updatedAt"
    static let createdAt = "createdAt"
    static let results = "results"
    
    // User Info Keys
    static let user = "user"
    static let userFirstName = "first_name"
    static let userLastName = "last_name"
  }
}
