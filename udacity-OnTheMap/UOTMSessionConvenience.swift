//
//  UOTMConvenience.swift
//  udacity-OnTheMap
//
//  Created by Techniexe on 18/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import Foundation
import FacebookLogin

extension UOTMClient {
  func loginUsingEmail(username: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
    let body = [
      "udacity": [
        "username": username,
        "password": password
      ]
    ]
    
    let _ = taskForPostMethod(method: Methods.session, queryParameters: nil, headers: nil, body: body, extractSubdata: true, completionForPost: {
      response, error in
      
      guard error == nil else {
        completion(error)
        return
      }
      
      self.saveSessionInfo(from: response, completion: completion)
    })
  }
  
  func loginUsingFacebook(token: String, completion: @escaping (_ error: Error?) -> Void) {
    let body = [
      "facebook_mobile": [
        "access_token": token
      ]
    ]
    
    let _ = taskForPostMethod(method: Methods.session, queryParameters: nil, headers: nil, body: body, extractSubdata: true, completionForPost: {
      response, error in
      
      guard error == nil else {
        completion(error)
        return
      }
      
      self.saveSessionInfo(from: response, completion: completion)
    })
  }
  
  func getDetailsOfUser(withId id: String, completion: @escaping (_ firstName: String?, _ lastName: String?, _ error: Error?) -> Void) {

    guard let methodName = prepareMethod(withName: Methods.user, byReplacing: "{id}", with: id) else {
      return
    }
    
    let _ = taskForGetMethod(method: methodName, queryParameters: nil, headers: nil, extractSubdata: true, completionForGet: {
      result, error in
      
      guard error == nil else {
        completion(nil, nil, error)
        return
      }
      
      guard let result = result as? [String:Any],
        let userDictionary = result[ResponseParameterKeys.user] as? [String:Any],
        let firstName = userDictionary[ResponseParameterKeys.userFirstName] as? String,
        let lastName = userDictionary[ResponseParameterKeys.userLastName] as? String else {
          let userInfo = [NSLocalizedDescriptionKey: "Error while parsing data from user details get request"]
          completion(nil, nil, NSError(domain: NSURLErrorDomain, code: NSURLErrorBadServerResponse, userInfo: userInfo))
          return
      }
      
      completion(firstName, lastName, nil)
    })
  }
  
  func deleteSession(completion: @escaping (_ response: Any?, _ error: Error?) -> Void) {
    guard let url = createUrl(forMethodName: Methods.session, withQueryParamters: nil) else {
      let userInfo = [NSLocalizedDescriptionKey: "Could not generate url for the Delete request."]
      completion(nil, NSError(domain: "taskForDeleteMethod", code: NSURLErrorBadURL, userInfo: userInfo))
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
      
      guard let data = data, let statusCode = (response as? HTTPURLResponse)?.statusCode, error == nil else {
        completion(nil, error)
        return
      }
      
      guard statusCode >= 200, statusCode <= 299 else {
        let userInfo = [NSLocalizedDescriptionKey: "Error while executing Delete request"]
        completion(nil, NSError(domain: "taskForDeleteMethod", code: NSURLErrorBadServerResponse, userInfo: userInfo))
        return
      }
      
      guard let newData = self.deserializeToJson(from: data, extractSubdata: true) else {
        let userInfo = [NSLocalizedDescriptionKey: "Error while parsing response data from Delete request"]
        completion(nil, NSError(domain: "taskForDeleteMethod", code: NSURLErrorCannotDecodeRawData, userInfo: userInfo))
        return
      }
      
      StudentLocation.locations = []
      UserDefaults.standard.removeObject(forKey: Constants.OfflineDataKeys.sessionId)
      UserDefaults.standard.removeObject(forKey: Constants.OfflineDataKeys.expiration)
      UserDefaults.standard.removeObject(forKey: Constants.OfflineDataKeys.udacityAccountId)
      UserDefaults.standard.removeObject(forKey: Constants.OfflineDataKeys.firstName)
      UserDefaults.standard.removeObject(forKey: Constants.OfflineDataKeys.lastName)
      
      if let _ = UserDefaults.standard.object(forKey: Constants.OfflineDataKeys.facebookToken) {
        let loginManager = LoginManager()
        loginManager.logOut()
        UserDefaults.standard.removeObject(forKey: Constants.OfflineDataKeys.facebookToken)
      }
      
      completion(newData, nil)
    })
    
    task.resume()
  }
  
  func saveSessionInfo(from response: Any?, completion: @escaping (_ error: Error?) -> Void) {
    guard let response = response as? [String:Any],
      let account = response[ResponseParameterKeys.account] as? [String:Any],
      let key = account[ResponseParameterKeys.accountKey] as? String,
      let session = response[ResponseParameterKeys.session] as? [String:String],
      let id = session[ResponseParameterKeys.id],
      let expiration = session[ResponseParameterKeys.expiration] else {
        return
    }
    
    getDetailsOfUser(withId: key, completion: {
      firstName, lastName, error in
      
      guard let firstName = firstName, let lastName = lastName, error == nil else {
        completion(error)
        return
      }
      
      UserDefaults.standard.set(id, forKey: Constants.OfflineDataKeys.sessionId)
      UserDefaults.standard.set(expiration, forKey: Constants.OfflineDataKeys.expiration)
      UserDefaults.standard.set(key, forKey: Constants.OfflineDataKeys.udacityAccountId)
      UserDefaults.standard.set(firstName, forKey: Constants.OfflineDataKeys.firstName)
      UserDefaults.standard.set(lastName, forKey: Constants.OfflineDataKeys.lastName)
      
      completion(nil)
    })
  }
}
