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
    
    let _ = taskForPostMethod(method: Methods.session, queryParameters: nil, body: body, extractSubdata: true, completionForPost: {
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
    
    let _ = taskForPostMethod(method: Methods.session, queryParameters: nil, body: body, extractSubdata: true, completionForPost: {
      response, error in
      
      self.saveSessionToken(from: response)
      completion(response, error)
    })
  }
  
  func deleteSession(completion: @escaping (_ response: Any?, _ error: Error?) -> Void) {
    guard let url = createUrl(forMethodName: Methods.session, withQueryParamters: nil) else {
      let userInfo = [NSLocalizedDescriptionKey: "Could not generate url for the Delete request."]
      completion(nil, NSError(domain: "taskForDeleteMethod", code: 0, userInfo: userInfo))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    
    var xsrfCookie: HTTPCookie? = nil
    
    if let cookies = HTTPCookieStorage.shared.cookies {
      for cookie in cookies {
        if cookie.name == "XSRF-TOKEN" {
          xsrfCookie = cookie
        }
      }
    }
    
    if let xsrfCookie = xsrfCookie {
      request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
    }
    
    showSystemNetworkIndicator()
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: {
      data, response, error in
      
      self.hideSystemNetworkIndicator()
      
      guard let data = data, error == nil else {
        completion(nil, error)
        return
      }
      
      guard let newData = self.deserializeToJson(from: data, extractSubdata: true) else {
        let userInfo = [NSLocalizedDescriptionKey: "Error while parsing response data from Delete request"]
        completion(nil, NSError(domain: "taskForDeleteMethod", code: 0, userInfo: userInfo))
        return
      }
      
      UserDefaults.standard.removeObject(forKey: Constants.OfflineDataKeys.sessionId)
      
      UserDefaults.standard.removeObject(forKey: Constants.OfflineDataKeys.expiration)
      
      completion(newData, nil)
    })
    
    task.resume()
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
