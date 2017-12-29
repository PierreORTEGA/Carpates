//
//  InscriptionViewController.swift
//  Application Carpates
//
//  Created by ORTEGA Pierre on 15/04/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//

import UIKit

class InscriptionViewController: UIViewController,NSURLConnectionDelegate {
  var data = NSMutableData()
  @IBOutlet weak var menuButton: UIBarButtonItem!
  @IBOutlet weak var TFAdresse: UITextField!
  @IBOutlet weak var TFmdp: UITextField!
  @IBOutlet weak var TFmdpConfirm: UITextField!
  var strNameUser : String = ""

  @IBOutlet weak var TFid: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
      
      // Do any additional setup after loading the view, typically from a nib.
      if self.revealViewController() != nil {
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
      }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
    print("connection error = \(error)")
  }
  func AlertUser(_ pStrTitle:String?,pStrMessage:String?){
    let alertView:UIAlertView = UIAlertView()
    alertView.title = pStrTitle!
    alertView.message = pStrMessage!
    alertView.delegate = self
    alertView.addButton(withTitle: "OK")
    alertView.show()
  }

  func writeInDatabase(){
    let myUrl = URL(string: "\(Url)/register.php")
    var request = URLRequest(url: myUrl!)
    
    request.httpMethod = "POST";
    
    let bodyData = "name=\(self.TFid.text!)&email=\(self.TFAdresse.text!)&password=\(self.TFmdp.text!)"
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: {
      data, response, error in
      
      if error != nil {
        print("error\(String(describing: error))")
        return
      }else {
        do {
          let jsonResult:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
          print(jsonResult)
          //self.strNameUser=jsonResult["user"]!["name"] as! String
          if jsonResult["error"] as! Bool == false {
            DispatchQueue.main.async(execute: {
              self.AlertUser("Warning", pStrMessage: "Inscritpion réussit !")
              self.performSegue(withIdentifier: "MapInsc", sender: self)
            })
          }else {
            DispatchQueue.main.async(execute: {
              self.AlertUser("Warning", pStrMessage:jsonResult["error_msg"] as? String)
            })
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

  @IBAction func InscriptionButton(_ sender: AnyObject) {
    if self.TFid.text != "" && self.TFAdresse.text != "" && self.TFmdp.text != "" && self.TFmdpConfirm.text != "" {
      if self.TFmdp.text == self.TFmdpConfirm.text {
        self.writeInDatabase()
      } else {
        self.AlertUser("Warning", pStrMessage:"Mots de passe incorrecte")
      }
    } else {
      self.AlertUser("Warning", pStrMessage:"Veuillez remplir tous les champs")
    }
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  
  /**
   * Called when the user click on the view (outside the UITextField).
   */
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(false)
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
