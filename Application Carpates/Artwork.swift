//
//  Artwork.swift
//  Application Carpates
//
//  Created by ORTEGA Pierre on 22/04/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//

import Foundation
import MapKit
import AddressBook

class Artwork: NSObject, MKAnnotation {
  let title: String?
  let subtitle: String?
  let Description: String
  let coordinate: CLLocationCoordinate2D
  let ImageView : String?
  init(title: String,nom:String , description: String, coordinate: CLLocationCoordinate2D, pStrIdCate:String) {
    self.title = title
    self.subtitle = nom
    self.Description = description
    self.coordinate = coordinate
    self.ImageView=pStrIdCate
    super.init()
  }
  var Subtitle: String {
    return subtitle!
  }
  var Title: String {
    return title!
  }
  var getDescription: String {
    return Description
  }
  // annotation callout info button opens this mapItem in Maps app
  func mapItem() -> MKMapItem {
    let addressDictionary = [String(kABPersonAddressStreetKey): subtitle!]
    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = self.Title
    
    return mapItem
  }
  
}