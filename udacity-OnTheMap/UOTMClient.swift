//
//  UOTMClient.swift
//  udacity-OnTheMap
//
//  Created by Techniexe on 17/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import Foundation

class UOTMClient {
  
  var shared = URLSession.shared
  
//  func taskForGetMethod() -> URLSessionTask {
//  
//  }
  
  func taskForPostMethod(method: String, queryParameters: [String:String]?, body: Any?, completionForPost: @escaping (_ response: Any?, _ error: Error?) -> Void) -> URLSessionTask? {
    
    guard let url = createUrl(forMethodName: method, withQueryParamters: queryParameters) else {
      return nil
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "content-type")
    request.addValue("application/json", forHTTPHeaderField: "accept")
    
    if let body = body {
      request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    }
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: {
      data, response, error in
      
      guard let data = data, let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200, error == nil else {
        print(error?.localizedDescription)
        completionForPost(nil, error)
        return
      }
      
      completionForPost(self.deserializeJSON(from: data), error)
    })
    
    task.resume()
    
    return task
  }
  
  func deserializeJSON(from data: Data) -> Any? {
    let newData = data.subdata(in: Range<Int>(5..<data.count))
    return try? JSONSerialization.jsonObject(with: newData, options: .allowFragments)
  }
  
  func createUrl(forMethodName methodName: String, withQueryParamters queryParameters: [String:String]?) -> URL? {
    guard var urlComponents = URLComponents(string: methodName) else {
      return nil
    }
    
    var queryItems = [URLQueryItem]()
    
    if let queryParameters = queryParameters {
      for (key, value) in queryParameters {
        queryItems.append(URLQueryItem(name: key, value: value))
      }
    }
    
    urlComponents.queryItems = queryItems
    
    guard let urlString = urlComponents.string, let url = URL(string: urlString) else {
      return nil
    }
    
    return url
  }
  
//  func taskForPutMethod() -> URLSessionTask {
//    
//  }
  
  static let shared = UOTMClient()
}
