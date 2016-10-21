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
    guard let username = emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),
      let password = passwordTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), !username.isEmpty, !password.isEmpty else {
        showBasicAlert(onController: self, withTitle: "Login", message: "Please enter both Username and Password.", onOkPressed: nil)
        return
    }
    
    prepareUiForNetworkRequest()
    
    UOTMClient.shared.loginUsingEmail(username: username, password: password, completion: {
      response, error in
      
      self.updateUiAfterNetworkRequest()
      
      guard error == nil else {
        
        DispatchQueue.main.async {
          if let error = error as? URLError, error.errorCode == NSURLErrorNotConnectedToInternet {
            showBasicAlert(onController: self, withTitle: "No Internet", message: "You'll need internet connection to Log In. Please make sure you are connected.", onOkPressed: nil)
          } else {
            showBasicAlert(onController: self, withTitle: "Sorry", message: "Error while trying to Log In. Please check your Username and Password.", onOkPressed: nil)
          }
        }
        
        return
      }
      
      DispatchQueue.main.async {
        self.successfulLogin()
      }
    })
  }
  
  @IBAction func signupUser(_ sender: UIButton) {
    guard let url = URL(string: "https://www.udacity.com/account/auth#!/signup") else {
      return
    }
    
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
  
  @IBAction func loginViaFacebook(_ sender: UIButton) {
    let loginManager = LoginManager()
    loginManager.logIn([.publicProfile, .email], viewController: self, completion: {
      loginResult in
      switch loginResult {
      case .failed(let error):
        print(error)
        showBasicAlert(onController: self, withTitle: "Sorry", message: "Facebook Authentication Failed. Please try again.", onOkPressed: nil)
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
                showBasicAlert(onController: self, withTitle: "No Internet", message: "You'll need Internet connection to Log In. Please make sure you are connected to the Internet.", onOkPressed: nil)
              } else {
                showBasicAlert(onController: self, withTitle: "Sorry", message: "Error while trying to Log In using Facebook. Please try again.", onOkPressed: nil)
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
