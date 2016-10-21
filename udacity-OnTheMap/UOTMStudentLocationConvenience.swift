//
//  UOTMStudentLocationConvenience.swift
//  udacity-OnTheMap
//
//  Created by Techniexe on 19/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import Foundation
import MapKit

extension UOTMClient {
  
  func getStudentLocationsFromServer(completion: @escaping(_ error: Error?) -> Void) {
    let queryParams: [String:Any] = ["limit": 100, "order": "-updatedAt"]
    
    let _ = taskForGetMethod(method: Methods.studentLocation, queryParameters: queryParams, headers: studentLocationRequestHeaders, extractSubdata: false, completionForGet: {
      response, error in
      
      guard let response = response as? [String:Any], error == nil else {
        completion(error)
        return
      }
      
      guard let results = response[ResponseParameterKeys.results] as? [[String:Any]] else {
        //FIXME: Create error for not finding results key
        completion(nil)
        return
      }
      
      StudentLocation.locations = StudentLocation.parseStudentLocationsFromResults(result: results)
      completion(nil)
    })
  }
  
  func getStudentLocations(completion: @escaping (_ error: Error?) -> Void) {
    if StudentLocation.locations.count > 0 {
      completion(nil)
      return
    }
    
    getStudentLocationsFromServer(completion: completion)
  }
  
  func postStudentLocation(mapString: String, mediaUrlString: String, coordinate: CLLocationCoordinate2D, completion: @escaping (_ error: Error?) -> Void) {
    let body = [
      BodyKeys.uniqueKey: UserDefaults.standard.object(forKey: Constants.OfflineDataKeys.udacityAccountId)!,
      BodyKeys.firstName: UserDefaults.standard.object(forKey: Constants.OfflineDataKeys.firstName)!,
      BodyKeys.lastName: UserDefaults.standard.object(forKey: Constants.OfflineDataKeys.lastName)!,
      BodyKeys.mapString: mapString,
      BodyKeys.mediaUrl: mediaUrlString,
      BodyKeys.latitude: coordinate.latitude,
      BodyKeys.longitude: coordinate.longitude
    ]
    
    let _ = taskForPostMethod(method: Methods.studentLocation, queryParameters: nil, headers: studentLocationRequestHeaders, body: body, extractSubdata: false, completionForPost: {
      result, error in
      
      guard let _ = result, error == nil else {
        completion(error)
        return
      }
      
      completion(nil)
    })
  }
}
