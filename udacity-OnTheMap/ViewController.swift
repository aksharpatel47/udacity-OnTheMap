//
//  ViewController.swift
//  udacity-OnTheMap
//
//  Created by Techniexe on 14/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import UIKit
import FacebookLogin

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let button = LoginButton(readPermissions: [.publicProfile, .email])
    button.delegate = self
    button.center = view.center
    view.addSubview(button)
  }
}

extension ViewController : LoginButtonDelegate {
  func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
    switch result {
    case .success(let grantedPermissions, let declinedPermissions, let token):
      print(grantedPermissions, declinedPermissions, token)
    case .failed(let error):
      print(error)
    case .cancelled:
      print("Login Cancelled")
    }
  }
  
  func loginButtonDidLogOut(_ loginButton: LoginButton) {
    
  }
}
