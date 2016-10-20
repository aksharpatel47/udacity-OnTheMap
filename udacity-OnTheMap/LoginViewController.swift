//
//  LoginViewController.swift
//  udacity-OnTheMap
//
//  Created by Techniexe on 14/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import Foundation
import UIKit
import FacebookLogin

class LoginViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var facebookButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    facebookButton.imageView?.contentMode = .scaleAspectFit
  }
  
  @IBAction func loginViaEmail(_ sender: UIButton) {
    guard let username = emailTextField.text, let password = passwordTextField.text else {
      return
    }
    
    UOTMClient.shared.loginUsingEmail(username: username, password: password, completion: {
      response, error in
      
      if let error = error as? URLError {
        if error.errorCode == -1009 {
        
          showBasicAlert(onController: self, withTitle: "No Internet", message: "You'll need internet connection to log in.", onOkPressed: nil)
        } else {
          print("Your error code is ", error.errorCode)
        }
      }
      
      guard error == nil else {
        return
      }
      
      DispatchQueue.main.async {
        self.successfulLogin()
      }
      
    })
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
        
        UserDefaults.standard.set(token.authenticationToken, forKey: Constants.OfflineDataKeys.facebookToken)
        
        UOTMClient.shared.loginUsingFacebook(token: token.authenticationToken, completion: {
          response, error in
          
          guard error == nil else {
            return
          }
          
          DispatchQueue.main.async {
            self.successfulLogin()
          }
        })
      }
    })
  }
  
  func successfulLogin() {
    performSegue(withIdentifier: Constants.Segues.successfulLogin, sender: nil)
  }
}

extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
