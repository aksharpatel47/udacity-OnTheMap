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
  
  /// (segue!) Location String that was Geocoded
  var mapString: String!
  /// (segue!) Coordinate of the Location String got from Geocoding
  var coordinate: CLLocationCoordinate2D!
  let regionRadius = 10000.0
  
  override func viewDidLoad() {
    centerMapOnLocation(coordinate: coordinate)
    mapView.addAnnotation(StudentLocationPin(title: nil, subtitle: nil, coordinate: coordinate))
  }
  
  @IBAction func postNewPin(_ sender: UIButton) {
    guard let mediaUrlString = urlTextField.text else {
      return
    }
    
    prepareUiForNetWorkRequest()
    
    UOTMClient.shared.postStudentLocation(mapString: mapString, mediaUrlString: mediaUrlString, coordinate: coordinate, completion: {
      error in
      
      self.updateUiAfterNetworkRequest()
      
      guard error == nil else {
        
        DispatchQueue.main.async {
          if let error = error as? URLError, error.errorCode == NSURLErrorNotConnectedToInternet {
            showBasicAlert(onController: self, withTitle: Constants.ErrorMessages.noInternetTitle, message: Constants.ErrorMessages.noInternetMessage, onOkPressed: nil)
          } else {
            showBasicAlert(onController: self, withTitle: Constants.ErrorMessages.sorryTitle, message: Constants.ErrorMessages.newStudentLocationMessage, onOkPressed: nil)
          }
        }
        
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
  
  func centerMapOnLocation(coordinate: CLLocationCoordinate2D) {
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate,
                                                              regionRadius * 2.0, regionRadius * 2.0)
    mapView.setRegion(coordinateRegion, animated: true)
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
