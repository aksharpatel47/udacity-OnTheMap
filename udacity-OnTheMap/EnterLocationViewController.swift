//
//  EnterLocationViewController.swift
//  udacity-OnTheMap
//
//  Created by Techniexe on 20/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class EnterLocationViewController: UIViewController {
  
  @IBOutlet weak var locationTextView: UITextView!
  
  let textViewPlaceholder = "Enter Your Location Here..."
  
  @IBAction func cancelPostingNewPin(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func findLocationOnMap(_ sender: UIButton) {
    let locationText = locationTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    let geoCoder = CLGeocoder()
    geoCoder.geocodeAddressString(locationText, completionHandler: {
      placeMarks, error in
      
      guard let placeMarks = placeMarks, let placeMarkCoordinate = placeMarks.first?.location?.coordinate, error == nil else {
        showBasicAlert(onController: self, withTitle: "Error", message: "Sorry! Could not find the location you entered. Please try a different One", onOkPressed: nil)
        return
      }
      
      let studentLocationPin = StudentLocationPin(coordinate: placeMarkCoordinate)
      studentLocationPin.mapString = locationText
      self.performSegue(withIdentifier: Constants.Segues.goToEnterLink, sender: studentLocationPin)
    })
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else {
      return
    }
    
    if identifier == Constants.Segues.goToEnterLink {
      guard let enterLinkController = segue.destination as? EnterLinkViewController,
        let studentLocationPin = sender as? StudentLocationPin else {
        return
      }
      
      enterLinkController.studentLocationPin = studentLocationPin
    }
  }
}

extension EnterLocationViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == textViewPlaceholder {
      textView.text = ""
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
      textView.text = textViewPlaceholder
    }
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      textView.resignFirstResponder()
      return false
    }
    
    return true
  }
}
