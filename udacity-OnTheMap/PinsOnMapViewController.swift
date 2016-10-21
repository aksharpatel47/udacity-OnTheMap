//
//  PinsMapViewController.swift
//  udacity-OnTheMap
//
//  Created by Akshar Patel on 18/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import UIKit
import MapKit

class PinsOnMapViewController: UIViewController {
  
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var reloadButton: UIBarButtonItem!
  @IBOutlet weak var logoutButton: UIBarButtonItem!
  @IBOutlet weak var newPinButton: UIBarButtonItem!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if StudentLocation.locations.count == 0 {
      reloadStudentLocations(reloadButton)
    } else {
      pinOnMap(studentLocations: StudentLocation.locations)
    }
  }
  
  @IBAction func logOutOfSession(_ sender: UIBarButtonItem) {
    
    prepareUiForNetworkRequest()
    
    UOTMClient.shared.deleteSession(completion: {
      result, error in
      
      self.updateUiAfterNetworkRequest()
      
      guard error == nil else {
        
        DispatchQueue.main.async {
          if let error = error as? URLError, error.errorCode == NSURLErrorNotConnectedToInternet {
            showBasicAlert(onController: self, withTitle: Constants.ErrorMessages.noInternetTitle, message: Constants.ErrorMessages.noInternetMessage, onOkPressed: nil)
          } else {
            showBasicAlert(onController: self, withTitle: Constants.ErrorMessages.sorryTitle, message: Constants.ErrorMessages.logOutMessage, onOkPressed: nil)
          }
        }
        
        return
      }
      
      DispatchQueue.main.async {
        self.appDelegate.window?.rootViewController = self.storyboard?.instantiateInitialViewController()
      }
    })
  }
  
  @IBAction func reloadStudentLocations(_ sender: UIBarButtonItem) {
    
    prepareUiForNetworkRequest()
    
    UOTMClient.shared.getStudentLocationsFromServer(completion: {
      error in
      
      self.updateUiAfterNetworkRequest()
      
      guard error == nil else {
        
        handleStudentLocationsRequestError(onViewController: self, error: error!)
        
        return
      }
      
      self.pinOnMap(studentLocations: StudentLocation.locations)
    })
  }
  
  func pinOnMap(studentLocations: [StudentLocation]) {
    
    var studentLocationPins = [StudentLocationPin]()
    
    for studentLocation in studentLocations {
      studentLocationPins.append(StudentLocationPin(title: studentLocation.fullName, subtitle: studentLocation.mediaUrlString, coordinate: studentLocation.coordinate))
    }
    
    DispatchQueue.main.async {
      self.mapView.removeAnnotations(self.mapView.annotations)
      self.mapView.addAnnotations(studentLocationPins)
    }
  }
  
  func prepareUiForNetworkRequest() {
    DispatchQueue.main.async {
      self.newPinButton.isEnabled = false
      self.logoutButton.isEnabled = false
      self.reloadButton.isEnabled = false
    }
  }
  
  func updateUiAfterNetworkRequest() {
    DispatchQueue.main.async {
      self.newPinButton.isEnabled = true
      self.logoutButton.isEnabled = true
      self.reloadButton.isEnabled = true
    }
  }
}

func handleStudentLocationsRequestError(onViewController viewCtrl: UIViewController, error: Error) {
  DispatchQueue.main.async {
    if let error = error as? URLError, error.errorCode == NSURLErrorNotConnectedToInternet {
      showBasicAlert(onController: viewCtrl, withTitle: Constants.ErrorMessages.noInternetTitle, message: Constants.ErrorMessages.noInternetMessage, onOkPressed: nil)
    } else {
      showBasicAlert(onController: viewCtrl, withTitle: Constants.ErrorMessages.sorryTitle, message: Constants.ErrorMessages.studentLocationsMessage, onOkPressed: nil)
    }
  }
}

extension PinsOnMapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? StudentLocationPin else {
      return nil
    }
    
    guard let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.PinIdentifiers.mapPin) as? MKPinAnnotationView else {
      let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.PinIdentifiers.mapPin)
      view.canShowCallout = true
      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
      return view
    }
    
    dequeuedView.annotation = annotation
    return dequeuedView
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    guard let annotation = view.annotation as? StudentLocationPin,
      let mediaUrlString = annotation.subtitle,
      let mediaUrl = URL(string: mediaUrlString) else {
        return
    }
    
    UIApplication.shared.open(mediaUrl, options: [:], completionHandler: nil)
  }
}
