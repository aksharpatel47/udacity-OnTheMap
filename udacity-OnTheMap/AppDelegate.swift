//
//  AppDelegate.swift
//  udacity-OnTheMap
//
//  Created by Techniexe on 14/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import UIKit
import FacebookCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    
    if let sessionId = UserDefaults.standard.object(forKey: Constants.OfflineDataKeys.sessionId) as? String , !sessionId.isEmpty {
      let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
      window?.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainTabViewController")
    }
    
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    UserDefaults.standard.synchronize()
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    AppEventsLogger.activate(application)
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    return SDKApplicationDelegate.shared.application(app, open: url, options: options)
  }
}

