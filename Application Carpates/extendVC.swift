//
//  extendVC.swift
//  Application Carpates
//
//  Created by ORTEGA Pierre on 22/04/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//

import MapKit

extension ViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation {
      return nil
    }
    if let annotation = annotation as? Artwork {
      let identifier = "pin"
      var view: MKPinAnnotationView
      if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView { // 2
        dequeuedView.annotation = annotation
        view = dequeuedView
      } else {
        // 3
        view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        

        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        view.leftCalloutAccessoryView = UIButton(type: .contactAdd) as UIView
//        let cpa = annotation as Artwork
//        view.image = UIImage(named:cpa.ImageView!)
      }
      return view
    }
    return nil
  }
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,calloutAccessoryControlTapped control: UIControl) {
    if control != view.rightCalloutAccessoryView {
      let location = view.annotation as! Artwork
      let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
      print(location)
      location.mapItem().openInMaps(launchOptions: launchOptions)
    } else {
      self.performSegue(withIdentifier: "Info", sender: self)
    }
    
  }
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    if view.annotation is MKUserLocation{
      return
    } else {
      self.strTitle=((view.annotation?.subtitle)!)!
    }
  }
}
