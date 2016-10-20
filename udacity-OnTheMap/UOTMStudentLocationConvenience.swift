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
    
    let headers = [
      "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
      "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    ]
    
    let _ = taskForGetMethod(method: Methods.studentLocation, queryParameters: queryParams, headers: headers, extractSubdata: false, completionForGet: {
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
    
  }
  
  func postStudentLocation() {
    
  }
  
  func updateStudentLocation() {
    
  }
}
