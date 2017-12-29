//
//  ConnexionViewController.swift
//  Application Carpates
//
//  Created by ORTEGA Pierre on 25/03/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//

import UIKit

class ConnexionViewController: UIViewController {

  @IBOutlet weak var TFpassw: UITextField!
  @IBOutlet weak var TFid: UITextField!
  @IBOutlet weak var menuButton: UIBarButtonItem!
  var logConnect : Bool = false
  var strNameUser : String = ""
  var strIdUser : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
      UIGraphicsBeginImageContext(self.view.frame.size)
      UIImage(named: "PageAccueil.jpg")?.draw(in: self.view.bounds)
      
      let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
      
      UIGraphicsEndImageContext()
      
      view.backgroundColor = UIColor(patternImage: image)
      // Do any additional setup after loading the view, typically from a nib.
      if self.revealViewController() != nil {
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  func AlertUser(_ pStrTitle:String?,pStrMessage:String?){
    let alertView:UIAlertView = UIAlertView()
    alertView.title = pStrTitle!
    alertView.message = pStrMessage!
    alertView.delegate = self
    alertView.addButton(withTitle: "OK")
    alertView.show()
  }
  func connectionLogin(){
    let myUrl = URL(string: "\(Url)/login.php")
    var request = URLRequest(url: myUrl!)
    
    request.httpMethod = "POST";
    
    let bodyData = "email=\(self.TFid.text!)&password=\(self.TFpassw.text!)"
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: {
      data, response, error in
      
      if error != nil {
        print("error\(String(describing: error))")
        return
      } else {
        do {
          let jsonResult:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
          print(jsonResult)
//          let jsonUser=jsonResult["user"] as! [String:Any]
//         self.strNameUser=jsonUser["name"]  as! String
//        
//         self.strIdUser=jsonUser["id"] as! String
//          if jsonResult["error"] as! String == "FALSE" {
//            DispatchQueue.main.async(execute: {
//              self.AlertUser("Warning", pStrMessage: "Bonjour \(self.strNameUser)")
//              self.logConnect=true
//              self.performSegue(withIdentifier: "MapCon", sender: self)
//              
//            })
//          }else {
//            DispatchQueue.main.async(execute: {
//              self.AlertUser("Warning", pStrMessage:jsonResult["error_msg"] as? String)
//            })
//          }
          
          // success ...
        } catch let error as NSError {
          // failure
          print("Fetch failed: \(error.localizedDescription)")
        }
      }
      
    }) 
    
    task.resume()

  }
  @IBAction func login(_ sender: AnyObject) {
    if  TFpassw.text! != "" || TFid.text! != ""  {
      self.connectionLogin()
      
    } else {
      self.AlertUser("Sign in Failed!", pStrMessage:"Please enter Username and Password")
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
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "MapCon" {
        log=self.logConnect
        Pseudo=self.strNameUser
        Iduser=self.strIdUser
      }
    }
}
