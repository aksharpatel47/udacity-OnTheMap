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
  }
  
  struct ParameterKeys {
    static let udacity = "udacity"
    static let username = "username"
    static let password = "password"
    static let facebookMobile = "facebook_mobile"
    static let accessToken = "access_token"
  }
}
