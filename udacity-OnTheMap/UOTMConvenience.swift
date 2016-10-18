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
    
    let _ = taskForPostMethod(method: Methods.session, queryParameters: nil, body: body, completionForPost: completion)
  }
  
  func loginUsingFacebook(token: String, completion: @escaping (_ response: Any?, _ error: Error?) -> Void) {
    let body = [
      "facebook_mobile": [
        "access_token": token
      ]
    ]
    
    let _ = taskForPostMethod(method: Methods.session, queryParameters: nil, body: body, completionForPost: completion)
  }
}
