//
//  ViewController.swift
//  Application Carpates
//
//  Created by ORTEGA Pierre on 25/03/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


var log : Bool = false
var Iduser : String = ""
var Pseudo: String=""
var TitleCate:String=""
var idCate:String=""
var tabIdMonuFav:[String]=[]
var Url:String="http://carpati.16mb.com/iphone"
var UrlImg:String="http://carpati.16mb.com/img"
class ViewController: UIViewController, CLLocationManagerDelegate,UIPopoverPresentationControllerDelegate {
  @IBOutlet weak var Map: MKMapView!
  var dicIdMonu:[String:String]=[:]
  @IBOutlet weak var menuButton: UIBarButtonItem!
  var locationManager=CLLocationManager()
  var strTitle:String=""

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
      self.Map.delegate=self
    self.locationManager.delegate = self
    self.locationManager.requestAlwaysAuthorization()
    
    
    // 2
    // set initial location in Saint-dié
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.startUpdatingLocation()
    }
    //self.centerMapOnLocation(locationManager)

    if self.revealViewController() != nil {
      menuButton.target = self.revealViewController()
      menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
      self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
      self.connectionReadMonuments(idCate)
    }
    print(Iduser)
  }
  let regionRadius: CLLocationDistance = 1000
  func centerMapOnLocation(_ location: CLLocation) {
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
    Map.setRegion(coordinateRegion, animated: true)
  }
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    Map.showsUserLocation = (status == .authorizedAlways)
  }
  
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
  {
    
    let location = locations.last! as CLLocation
    
    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    self.Map.setRegion(region, animated: true)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  func connectionReadMonuments(_ pStrConnect:String){
    if pStrConnect != ""{
      let myUrl = URL(string: "\(Url)/CoorMonu.php")
      var request = URLRequest(url: myUrl!)
      
      request.httpMethod = "POST";
      
      let bodyData = "idCate=\(idCate)"
      request.httpBody = bodyData.data(using: String.Encoding.utf8)
      
      let task = URLSession.shared.dataTask(with: request, completionHandler: {
        data, response, error in
        
        if error != nil {
          print("error\(String(describing: error))")
          return
        } else {
          do {
            let jsonResult:NSArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
            print(jsonResult)
            for i in (jsonResult as? [[String:Any]])!{
              let artwork = Artwork(title: TitleCate,
                                    nom:i["name"] as! String,
                                    description: i["description"] as! String ,
                                    coordinate: CLLocationCoordinate2D(latitude: Double(i["latitude"] as! String)!,
                                      longitude: Double(i["longitude"] as! String)!),
                                    pStrIdCate:"\(Url)/tests/Carpates/icons/\(i["idCategorie"] as! String).jpeg")
              //affichage des points sur la carte
              self.Map.addAnnotation(artwork)
              self.dicIdMonu[i["name"] as! String]=i["id"] as? String

            }
            // success ...
          } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
          }
        }
      }) 
      task.resume()
    }else{
      print(tabIdMonuFav)
      if tabIdMonuFav != [] {
        for j in tabIdMonuFav {
          
          let myUrl = URL(string: "\(Url)/CoorFav.php")
          var request = URLRequest(url: myUrl!)
        
          request.httpMethod = "POST";
          let bodyData = "idMonu=\(j)"
          request.httpBody = bodyData.data(using: String.Encoding.utf8)
          let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
          
            if error != nil {
              print("error\(String(describing: error))")
              return
            } else {
              do {
                let jsonResult:NSArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                print(jsonResult)
                for i in (jsonResult as? [[String:Any]])!{
                  let artwork = Artwork(title: "Favoris",
                                        nom:i["name"] as! String,
                                        description: i["description"] as! String ,
                                        coordinate: CLLocationCoordinate2D(latitude: Double(i["latitude"] as! String)!,
                                        longitude: Double(i["longitude"] as! String)!),
                                        pStrIdCate:"\(Url)/tests/Carpates/icons/\(i["idCategorie"] as! String).jpeg")
                  //affichage des points sur la carte
                  self.Map.addAnnotation(artwork)
                  self.dicIdMonu[i["name"] as! String]=i["id"] as? String
                }
                // success ...
              } catch let error as NSError {
                // failure
                print("Fetch failed: \(error.localizedDescription)")
              }
            }
          }) 
          task.resume()
        }
      } else {
        let myUrl = URL(string: "\(Url)/CoorMonu.php")
        var request = URLRequest(url: myUrl!)
      
        request.httpMethod = "POST";
      
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
          data, response, error in
        
          if error != nil {
            print("error\(String(describing: error))")
            return
          } else {
            do {
              let jsonResult:NSArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
              print(jsonResult)
              for i in (jsonResult as? [[String:Any]])!{
                let artwork = Artwork(title: "Monument",
                                      nom:i["name"] as! String,
                                      description: i["description"] as! String ,
                                      coordinate: CLLocationCoordinate2D(latitude: Double(i["latitude"] as! String)!,
                                      longitude: Double(i["longitude"] as! String)!),
                                      pStrIdCate:"\(Url)/tests/Carpates/icons/\(i["idCategorie"] as! String).jpeg")
                //affichage des points sur la carte
                self.Map.addAnnotation(artwork)
                self.dicIdMonu[i["name"] as! String]=i["id"] as? String
              }
              // success ...
            } catch let error as NSError {
              // failure
              print("Fetch failed: \(error.localizedDescription)")
            }
          }
        }) 
        task.resume()
      }
    }
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showPop" {
      let vc = segue.destination as! UITableViewController

      vc.preferredContentSize = CGSize(width: 300, height: 600)
      let controller = vc.popoverPresentationController
      controller?.delegate=self
      
    }
    if segue.identifier == "Info" {
      let navigationController = segue.destination as! ViewControllerDescriptionMonu
      navigationController.strIdMonu=self.dicIdMonu[strTitle]!
      navigationController.strTitle=self.strTitle
    }
  }
  @IBAction func Popover(_ sender: AnyObject) {
    self.performSegue(withIdentifier: "showPop", sender: self)
  }
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
  

}

