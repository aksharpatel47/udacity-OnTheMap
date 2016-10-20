//
//  StudentLocationPin.swift
//  udacity-OnTheMap
//
//  Created by Techniexe on 20/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import Foundation
import MapKit

class StudentLocationPin: NSObject, MKAnnotation {
  var title: String?
  var subtitle: String?
  var coordinate: CLLocationCoordinate2D
  
  init(studentLocation: StudentLocation) {
    coordinate = CLLocationCoordinate2D(latitude: studentLocation.latitude, longitude: studentLocation.longitude)
    title = studentLocation.fullName
    subtitle = studentLocation.mediaUrl
    
    super.init()
  }
}