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
  var studentLocationPins = [StudentLocationPin]()
  
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    UOTMClient.shared.getStudentLocations(completion: {
      studentLocations, error in
      
      guard let studentLocations = studentLocations, error == nil else {
        //TODO: Handle Error
        return
      }
      
      self.pinOnMap(locations: studentLocations)
    })
  }
  
  @IBAction func logOutOfSession(_ sender: UIBarButtonItem) {
    UOTMClient.shared.deleteSession(completion: {
      result, error in
      
      guard error == nil else {
        //TODO: Handle Error
        return
      }
      
      DispatchQueue.main.async {
        self.appDelegate.window?.rootViewController = self.storyboard?.instantiateInitialViewController()
      }
    })
  }
  
  @IBAction func reloadStudentLocations(_ sender: UIBarButtonItem) {
    UOTMClient.shared.getStudentLocationsFromServer(completion: {
      studentLocations, error in
      
      guard let studentLocations = studentLocations, error == nil else {
        // TODO Handle error
        return
      }
      
      self.pinOnMap(locations: studentLocations)
    })
  }
  
  func pinOnMap(locations: [StudentLocation]) {
    
    self.studentLocationPins = []
    
    for location in locations {
      self.studentLocationPins.append(StudentLocationPin(studentLocation: location))
    }
    
    DispatchQueue.main.async {
      self.mapView.removeAnnotations(self.mapView.annotations)
      self.mapView.addAnnotations(self.studentLocationPins)
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
