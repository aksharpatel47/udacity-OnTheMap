//
//  UOTMStudentLocationConvenience.swift
//  udacity-OnTheMap
//
//  Created by Techniexe on 19/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import Foundation

extension UOTMClient {
  
  func getStudentLocationsFromServer(completion: @escaping(_ locations: [StudentLocation]?, _ error: Error?) -> Void) {
    let queryParams: [String:Any] = ["limit": 100, "order": "-updatedAt"]
    
    let _ = taskForGetMethod(method: Methods.studentLocation, queryParameters: queryParams, headers: studentLocationRequestHeaders, extractSubdata: false, completionForGet: {
      response, error in
      
      guard let response = response as? [String:Any], error == nil else {
        completion(nil, error)
        return
      }
      
      guard let results = response[ResponseParameterKeys.results] as? [[String:Any]] else {
        //FIXME: Create error for not finding results key
        completion(nil, nil)
        return
      }
      
      UOTMClient.shared.studentLocations = StudentLocation.parseStudentLocationsFromResults(result: results)
      completion(UOTMClient.shared.studentLocations, nil)
    })
  }
  
  func getStudentLocations(completion: @escaping (_ locations: [StudentLocation]?, _ error: Error?) -> Void) {
    if UOTMClient.shared.studentLocations.count > 0 {
      completion(UOTMClient.shared.studentLocations, nil)
      return
    }
    
    getStudentLocationsFromServer(completion: completion)
  }
  
  func getStudentLocation(uniqueKey: String) {
    //TODO: Implement get student location
  }
  
  func postStudentLocation(studentLocationPin: StudentLocationPin, completion: @escaping (_ error: Error?) -> Void) {
    let body = [
      BodyKeys.uniqueKey: UserDefaults.standard.object(forKey: Constants.OfflineDataKeys.udacityAccountId)!,
      BodyKeys.firstName: "Akshar",
      BodyKeys.lastName: "Patel",
      BodyKeys.mapString: studentLocationPin.mapString!,
      BodyKeys.mediaUrl: studentLocationPin.subtitle!,
      BodyKeys.latitude: studentLocationPin.coordinate.latitude,
      BodyKeys.longitude: studentLocationPin.coordinate.longitude
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
  
  func updateStudentLocation() {
    //TODO: update student location
  }
}
