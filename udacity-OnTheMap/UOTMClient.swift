//
//  UOTMClient.swift
//  udacity-OnTheMap
//
//  Created by Techniexe on 17/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import Foundation
import UIKit

class UOTMClient {
  
  var shared = URLSession.shared
  
  var studentLocationRequestHeaders = [
    "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
    "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
  ]
  
  func taskForGetMethod(method: String, queryParameters: [String:Any]?, headers: [String:Any]?, extractSubdata: Bool, completionForGet: @escaping (_ response: Any?, _ error: Error?) -> Void) -> URLSessionTask? {
    
    guard let url = createUrl(forMethodName: method, withQueryParamters: queryParameters) else {
      let userInfo = [NSLocalizedDescriptionKey: "Error while creating url from \(method)"]
      completionForGet(nil, NSError(domain: "taskForGetMethod", code: NSURLErrorBadURL, userInfo: userInfo))
      return nil
    }
    
    var request = URLRequest(url: url)
    
    if let headers = headers {
      for (key, value) in headers {
        request.addValue("\(value)", forHTTPHeaderField: key)
      }
    }
    
    showSystemNetworkIndicator()
    
    let task = shared.dataTask(with: request, completionHandler: {
      data, response, error in
      
      self.hideSystemNetworkIndicator()
      
      guard let data = data, let statusCode = (response as? HTTPURLResponse)?.statusCode, error == nil else {
        completionForGet(nil, error)
        return
      }
      
      guard statusCode >= 200, statusCode <= 299 else {
        let userInfo = [NSLocalizedDescriptionKey: "Error while making GET Request"]
        completionForGet(nil, NSError(domain: "taskForGetMethod", code: NSURLErrorBadServerResponse, userInfo: userInfo))
        return
      }
      
      guard let newData = self.deserializeToJson(from: data, extractSubdata: extractSubdata) else {
        let userInfo = [NSLocalizedDescriptionKey: "Error while deserializing data to JSON."]
        completionForGet(nil, NSError(domain: "taskForGetMethod", code: NSURLErrorCannotDecodeRawData, userInfo: userInfo))
        return
      }
      
      completionForGet(newData, nil)
    })
    
    task.resume()
    
    return task
  }
  
  func taskForPostMethod(method: String, queryParameters: [String:String]?, headers: [String:Any]?, body: Any?, extractSubdata: Bool, completionForPost: @escaping (_ response: Any?, _ error: Error?) -> Void) -> URLSessionTask? {
    
    guard let url = createUrl(forMethodName: method, withQueryParamters: queryParameters) else {
      let userInfo = [NSLocalizedDescriptionKey: "Error while creating url from \(method)"]
      completionForPost(nil, NSError(domain: "taskForPostMethod", code: NSURLErrorBadURL, userInfo: userInfo))
      return nil
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "content-type")
    request.addValue("application/json", forHTTPHeaderField: "accept")
    
    if let body = body {
      request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    }
    
    if let headers = headers {
      for (key, value) in headers {
        request.addValue("\(value)", forHTTPHeaderField: key)
      }
    }
    
    showSystemNetworkIndicator()
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: {
      data, response, error in
      
      self.hideSystemNetworkIndicator()
      
      guard let data = data, let statusCode = (response as? HTTPURLResponse)?.statusCode, error == nil else {
        completionForPost(nil, error)
        return
      }
      
      guard statusCode >= 200, statusCode <= 299 else {
        let userInfo = [NSLocalizedDescriptionKey: "Error while making POST request"]
        completionForPost(nil, NSError(domain: "taskForPostMethod", code: NSURLErrorBadServerResponse, userInfo: userInfo))
        return
      }
      
      guard let result = self.deserializeToJson(from: data, extractSubdata: extractSubdata) else {
        let userInfo = [NSLocalizedDescriptionKey: "Error while deserializing data to JSON."]
        completionForPost(nil, NSError(domain: "taskForPostMethod", code: NSURLErrorCannotDecodeRawData, userInfo: userInfo))
        return
      }
      
      completionForPost(result, nil)
    })
    
    task.resume()
    
    return task
  }
  
  func deserializeToJson(from data: Data, extractSubdata: Bool) -> Any? {
    let newData = extractSubdata ? data.subdata(in: Range<Int>(5..<data.count)) : data
    return try? JSONSerialization.jsonObject(with: newData, options: .allowFragments)
  }
  
  func createUrl(forMethodName methodName: String, withQueryParamters queryParameters: [String:Any]?) -> URL? {
    guard var urlComponents = URLComponents(string: methodName) else {
      return nil
    }
    
    var queryItems = [URLQueryItem]()
    
    if let queryParameters = queryParameters {
      for (key, value) in queryParameters {
        queryItems.append(URLQueryItem(name: key, value: "\(value)"))
      }
    }
    
    urlComponents.queryItems = queryItems
    
    guard let urlString = urlComponents.string, let url = URL(string: urlString) else {
      return nil
    }
    
    return url
  }
  
  func showSystemNetworkIndicator() {
    DispatchQueue.main.async {
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
  }
  
  func hideSystemNetworkIndicator() {
    DispatchQueue.main.async {
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
  }
  
//  func taskForPutMethod() -> URLSessionTask {
//    
//  }
  
  static let shared = UOTMClient()
}
