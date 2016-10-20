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
    
    UOTMClient.shared.postStudentLocation(studentLocationPin: studentLocationPin, completion: {
      error in
      
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
}

extension EnterLinkViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
