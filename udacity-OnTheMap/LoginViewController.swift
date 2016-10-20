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
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var signupButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    facebookButton.imageView?.contentMode = .scaleAspectFit
  }
  
  @IBAction func loginViaEmail(_ sender: UIButton) {
    guard let username = emailTextField.text, let password = passwordTextField.text else {
      return
    }
    
    prepareUiForNetworkRequest()
    
    UOTMClient.shared.loginUsingEmail(username: username, password: password, completion: {
      response, error in
      
      self.updateUiAfterNetworkRequest()
      
      guard error == nil else {
        
        DispatchQueue.main.async {
          if let error = error as? URLError, error.errorCode == NSURLErrorNotConnectedToInternet {
            showBasicAlert(onController: self, withTitle: "No Internet", message: "You'll need internet connection to Sign In. Please make sure you are connected.", onOkPressed: nil)
          } else {
            showBasicAlert(onController: self, withTitle: "Sorry", message: "Error while Signing In. Please try again.", onOkPressed: nil)
          }
        }
        
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
        showBasicAlert(onController: self, withTitle: "Sorry", message: "Error while Signing In using Facebook. Please try again.", onOkPressed: nil)
      case .cancelled:
        print("Cancelled")
      case .success(let grantedPermissions, let declinedPermissions, let token):
        print(grantedPermissions, declinedPermissions, token)
        
        UserDefaults.standard.set(token.authenticationToken, forKey: Constants.OfflineDataKeys.facebookToken)
        
        self.prepareUiForNetworkRequest()
        
        UOTMClient.shared.loginUsingFacebook(token: token.authenticationToken, completion: {
          response, error in
          
          self.updateUiAfterNetworkRequest()
          
          guard error == nil else {
            
            DispatchQueue.main.async {
              if let error = error as? URLError, error.errorCode == NSURLErrorNotConnectedToInternet {
                showBasicAlert(onController: self, withTitle: "No Internet", message: "You'll need Internet connection to Sign In. Please make sure you are connected to the Internet.", onOkPressed: nil)
              } else {
                showBasicAlert(onController: self, withTitle: "Sorry", message: "Error while Signing In using Facebook. Please try again.", onOkPressed: nil)
              }
            }
            
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
  
  func prepareUiForNetworkRequest() {
    DispatchQueue.main.async {
      self.loginButton.isEnabled = false
      self.signupButton.isEnabled = false
      self.facebookButton.isEnabled = false
    }
  }
  
  func updateUiAfterNetworkRequest() {
    DispatchQueue.main.async {
      self.loginButton.isEnabled = true
      self.signupButton.isEnabled = true
      self.facebookButton.isEnabled = true
    }
  }
}

extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
