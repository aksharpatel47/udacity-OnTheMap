//
//  Constants.swift
//  udacity-OnTheMap
//
//  Created by Techniexe on 18/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import Foundation
import UIKit

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
    static let firstName = "firstName"
    static let lastName = "lastName"
  }
  
  struct CellIdentifiers {
    static let pins = "pins"
  }
  
  struct PinIdentifiers {
    static let mapPin = "mapPin"
  }
  
  struct Colors {
    static let blue = UIColor(colorLiteralRed: 57 / 255.0, green: 112 / 255.0, blue: 147 / 255.0, alpha: 1.0)
  }
  
  struct ErrorMessages {
    static let sorryTitle = "Sorry"
    static let noInternetTitle = "No Internet"
    static let noInternetMessage = "Please make sure you are connected to the Internet."
    
    static let logOutMessage = "Error while Logging Out. Please try again."
    static let studentLocationsMessage = "Error while getting Student Locations. Please try again."
    static let newStudentLocationMessage = "Error while posting new Student Location. Please try again."
    
  }
}
