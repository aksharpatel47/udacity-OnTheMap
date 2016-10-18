//
//  PinsMapViewController.swift
//  udacity-OnTheMap
//
//  Created by Akshar Patel on 18/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import UIKit

class PinsOnMapViewController: UIViewController {
  
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func logOutOfSession(_ sender: UIBarButtonItem) {
    UOTMClient.shared.deleteSession(completion: {
      result, error in
      
      guard error == nil else {
        return
      }
      
      DispatchQueue.main.async {
        self.appDelegate.window?.rootViewController = self.storyboard?.instantiateInitialViewController()
      }
    })
  }
  
}
