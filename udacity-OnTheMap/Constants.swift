//
//  Constants.swift
//  udacity-OnTheMap
//
//  Created by Techniexe on 18/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import Foundation

struct Constants {
  struct Segues {
    static let successfulLogin = "successfulLogin"
    static let goToEnterLink = "goToEnterLink"
  }
  
  struct OfflineDataKeys {
    static let sessionId = "sessionId"
    static let expiration = "sessionExpirationDate"
    static let udacityAccountId = "udacityAccountId"
    static let facebookToken = "facebookToken"
  }
  
  struct CellIdentifiers {
    static let pins = "pins"
  }
  
  struct PinIdentifiers {
    static let mapPin = "mapPin"
  }
}
