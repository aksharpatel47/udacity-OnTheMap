//
//  StudentLocation.swift
//  udacity-OnTheMap
//
//  Created by Techniexe on 19/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import Foundation
import MapKit

struct StudentLocation {
  var firstName: String
  var lastName: String
  var fullName: String {
    get {
      return firstName + " " + lastName
    }
  }
  var latitude: Double
  var longitude: Double
  var mapString: String
  var mediaUrl: String
  var objectId: String
  var uniqueKey: String
  var updatedAt: String
  var createdAt: String
  
  init(dictionary: [String:Any]) {
    firstName = dictionary[UOTMClient.ResponseParameterKeys.firstName] as! String
    lastName = dictionary[UOTMClient.ResponseParameterKeys.lastName] as! String
    latitude = dictionary[UOTMClient.ResponseParameterKeys.latitude] as! Double
    longitude = dictionary[UOTMClient.ResponseParameterKeys.longitude] as! Double
    mapString = dictionary[UOTMClient.ResponseParameterKeys.mapString] as! String
    mediaUrl = dictionary[UOTMClient.ResponseParameterKeys.mediaUrl] as! String
    objectId = dictionary[UOTMClient.ResponseParameterKeys.objectId] as! String
    uniqueKey = dictionary[UOTMClient.ResponseParameterKeys.uniqueKey] as! String
    updatedAt = dictionary[UOTMClient.ResponseParameterKeys.updatedAt] as! String
    createdAt = dictionary[UOTMClient.ResponseParameterKeys.createdAt] as! String
    
    if !mediaUrl.hasPrefix("http://") && !mediaUrl.hasPrefix("https://") && !mediaUrl.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
      mediaUrl = "http://" + mediaUrl
    }
  }
  
  static func parseStudentLocationsFromResults(result: [[String:Any]]) -> [StudentLocation] {
    var studentLocations = [StudentLocation]()
    for locationData in result {
      studentLocations.append(StudentLocation(dictionary: locationData))
    }
    
    return studentLocations
  }
}
