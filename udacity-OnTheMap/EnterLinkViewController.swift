//
//  EnterLinkViewController.swift
//  udacity-OnTheMap
//
//  Created by Techniexe on 20/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import UIKit
import MapKit

class EnterLinkViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var urlTextField: UITextField!
  @IBOutlet weak var cancelButton: UIBarButtonItem!
  @IBOutlet weak var submitButton: UIButton!
  
  /// (segue!)
  var studentLocationPin: StudentLocationPin!
  
  override func viewDidLoad() {
    mapView.addAnnotation(studentLocationPin)
  }
  
  @IBAction func postNewPin(_ sender: UIButton) {
    guard let mediaUrlString = urlTextField.text else {
      return
    }
    
    studentLocationPin.subtitle = mediaUrlString
    
    prepareUiForNetWorkRequest()
    
    UOTMClient.shared.postStudentLocation(studentLocationPin: studentLocationPin, completion: {
      error in
      
      self.updateUiAfterNetworkRequest()
      
      guard error == nil else {
        //TODO: Handle Error
        return
      }
      
      DispatchQueue.main.async {
        self.dismiss(animated: true, completion: nil)
      }
      
    })
  }
  
  @IBAction func cancelPostingNewPin(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  func prepareUiForNetWorkRequest() {
    DispatchQueue.main.async {
      self.urlTextField.isEnabled = false
      self.cancelButton.isEnabled = false
      self.submitButton.isEnabled = false
      self.submitButton.backgroundColor = UIColor.darkGray
      self.submitButton.setTitleColor(UIColor.gray, for: .normal)
    }
  }
  
  func updateUiAfterNetworkRequest() {
    DispatchQueue.main.async {
      self.urlTextField.isEnabled = true
      self.cancelButton.isEnabled = true
      self.submitButton.isEnabled = true
      self.submitButton.backgroundColor = UIColor.white
      self.submitButton.setTitleColor(Constants.Colors.blue, for: .normal)
    }
  }
}

extension EnterLinkViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
