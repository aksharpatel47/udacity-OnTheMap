//
//  LoginViewController.swift
//  udacity-OnTheMap
//
//  Created by Techniexe on 14/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import UIKit
import FacebookLogin

class LoginViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func loginViaUsernamePassword(_ sender: UIButton) {
    
  }
  
  @IBAction func loginViaFacebook(_ sender: UIButton) {
    let loginManager = LoginManager()
    loginManager.logIn([.publicProfile, .email], viewController: self, completion: {
      loginResult in
      switch loginResult {
      case .failed(let error):
        print(error)
      case .cancelled:
        print("Cancelled")
      case .success(let grantedPermissions, let declinedPermissions, let token):
        print(grantedPermissions, declinedPermissions, token)
      }
    })
  }
}

extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
