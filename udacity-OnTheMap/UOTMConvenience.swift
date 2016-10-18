//
//  UOTMConvenience.swift
//  udacity-OnTheMap
//
//  Created by Techniexe on 18/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import Foundation

extension UOTMClient {
  func loginUsingEmail(username: String, password: String, completion: @escaping (_ reponse: Any?, _ error: Error?) -> Void) {
    let body = [
      "udacity": [
        "username": username,
        "password": password
      ]
    ]
    
    let _ = taskForPostMethod(method: Methods.session, queryParameters: nil, body: body, completionForPost: {
      response, error in
      
      self.saveSessionToken(from: response)
      completion(response, error)
    })
  }
  
  func loginUsingFacebook(token: String, completion: @escaping (_ response: Any?, _ error: Error?) -> Void) {
    let body = [
      "facebook_mobile": [
        "access_token": token
      ]
    ]
    
    let _ = taskForPostMethod(method: Methods.session, queryParameters: nil, body: body, completionForPost: {
      response, error in
      
      self.saveSessionToken(from: response)
      completion(response, error)
    })
  }
  
  func saveSessionToken(from response: Any?) {
    guard let response = response as? [String:Any],
      let session = response[ResponseParameterKeys.session] as? [String:String],
      let id = session[ResponseParameterKeys.id],
      let expiration = session[ResponseParameterKeys.expiration] else {
      return
    }
    
    UserDefaults.standard.set(id, forKey: Constants.OfflineDataKeys.sessionId)
    UserDefaults.standard.set(expiration, forKey: Constants.OfflineDataKeys.expiration)
  }
}
