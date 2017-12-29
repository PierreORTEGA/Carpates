//
//  ViewControllerDescriptionMonu.swift
//  Application Carpates
//
//  Created by ORTEGA Pierre on 20/04/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//
import MapKit
import CoreLocation

class ViewControllerDescriptionMonu: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
  
  @IBOutlet weak var imageURL: UIImageView!
  
  @IBOutlet weak var SendButton: UIButton!
  @IBOutlet weak var NoteGeneral: RatingAvis!
  @IBOutlet weak var goToMap: UIBarButtonItem!
  @IBOutlet weak var ButtonAddFavoris: UIBarButtonItem!
  @IBOutlet weak var NoteRatingbar: RatingControl!
  @IBOutlet weak var secView: UIView!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var ScrollBar: UIScrollView!
  @IBOutlet weak var Nav: UINavigationItem!
  @IBOutlet weak var LBDesc: UILabel!
  @IBOutlet weak var IMGMonu: UIImageView!
  @IBOutlet weak var LBTitre: UILabel!
  @IBOutlet weak var TFCom: UITextField!
  @IBOutlet weak var TableViewCom: UITableView!
  var strTitle:String=""
  var strIdMonu:String=""
  var data:Data?
  var tabCom:[String]=[]
  var tabuser:[String]=[]
  var tabNote:[String]=[]
  var tabDate:[String]=[]
  var theLatitude : Double? = nil
  var theLongitude : Double? = nil

  override func viewDidLoad() {
    SendButton.setTitle("Send", for: UIControlState())
    ScrollBar.contentSize.height=875
    LBTitre.text=strTitle
    self.getDescMonument(strIdMonu)
    super.viewDidLoad()
    let url = URL(string:"http://carpati.16mb.com/img/\(self.strIdMonu).jpg")
    data = try? Data(contentsOf: url!)
    if data != nil {
      imageURL?.image = UIImage(data:data!)
    }
    if idCate != ""{
      ButtonAddFavoris.isEnabled=true
    }else{
      ButtonAddFavoris.isEnabled=false
    }
    NotificationCenter.default.addObserver(self, selector: #selector(ViewControllerDescriptionMonu.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(ViewControllerDescriptionMonu.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    self.getComInDataBase()
    self.TableViewCom.tableFooterView = UIView(frame: CGRect.zero)
    self.TableViewCom.tableFooterView?.isHidden = true
    self.TableViewCom.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    

    // Do any additional setup after loading the view.
  }
  override func viewWillDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
  }
  @objc func keyboardWillShow(_ notification:Notification){
    
    var userInfo = (notification as NSNotification).userInfo!
    var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
    keyboardFrame = self.view.convert(keyboardFrame, from: nil)
    
    var contentInset:UIEdgeInsets = self.ScrollBar.contentInset
    contentInset.bottom = keyboardFrame.size.height
    self.ScrollBar.contentInset = contentInset
    
  }
  
  @objc func keyboardWillHide(_ notification:Notification){
    
    let contentInset:UIEdgeInsets = UIEdgeInsets.zero
    self.ScrollBar.contentInset = contentInset
  }
  func getDescMonument(_ idMonu:String){
    let myUrl = URL(string: "\(Url)/DescriptionMonu.php")
    var request = URLRequest(url: myUrl!)
    
    request.httpMethod = "POST";
    
    let bodyData = "idMonu=\(idMonu)"
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
            DispatchQueue.main.async(execute: {
              self.LBDesc.text=i["description"] as? String
              self.theLatitude=Double(i["latitude"] as! String)!
              self.theLongitude=Double(i["longitude"] as! String)!
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
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let aCell : CommentaireTableViewCell = TableViewCom.dequeueReusableCell(withIdentifier: "CellCommentaire") as! CommentaireTableViewCell
    aCell.UserNameLabel.text=tabuser[(indexPath as NSIndexPath).row]
    aCell.DescriptionLabel.text=tabCom[(indexPath as NSIndexPath).row]
    aCell.DateLabel.text=tabDate[(indexPath as NSIndexPath).row]
    aCell.NoteRatingBar.rating=Int(tabNote[(indexPath as NSIndexPath).row])!
    
    return aCell
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tabCom.count
  }
  func getComInDataBase(){
    tabCom=[]
    tabuser=[]
    tabNote=[]
    tabDate=[]
    let myUrl = URL(string: "\(Url)/GetCommentaire.php")
    var request = URLRequest(url: myUrl!)
    
    request.httpMethod = "POST";
    
    let bodyData = "idMonu=\(self.strIdMonu)"
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: {
      data, response, error in
      
      if error != nil {
        print("error\(String(describing: error))")
        return
      } else {
        do {
          var totalNote:Int=0
          let jsonResult:NSArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
          print(jsonResult)
          for i in (jsonResult as? [[String:Any]])!{
              print(i["commentaire"] as! String)
              self.tabCom.append(i["commentaire"] as! String)
              self.tabNote.append(i["note"] as! String)
            
              self.tabDate.append(i["dateAjout"] as! String)
              self.tabuser.append(i["name"] as! String)

          }
          for i in self.tabNote {
            totalNote+=Int(i)!
          }
          DispatchQueue.main.async(execute: {
            print(totalNote)
            if self.tabNote.count != 0 {
              self.NoteGeneral.rating=Int(totalNote/self.tabNote.count)
            } else {
              self.NoteGeneral.rating=totalNote
            }
            self.TableViewCom.reloadData()
          })
          // success ...
        } catch let error as NSError {
          // failure
          print("Fetch failed: \(error.localizedDescription)")
        }
      }
    }) 
    task.resume()
  }
  
  func sendComInDataBase(){
    let myUrl = URL(string: "\(Url)/SendCom.php")
    var request = URLRequest(url: myUrl!)
    
    request.httpMethod = "POST";
    
    let bodyData = "IdMonu=\(self.strIdMonu)&IdUser=\(Pseudo)&note=\(self.NoteRatingbar.rating)&commentaire=\(self.TFCom.text!)"
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
            print(i["commentaire"] as! String)
            self.tabCom.append(i["commentaire"] as! String)
            self.tabNote.append(i["note"] as! String)
            self.tabDate.append(i["dateAjout"] as! String)
            self.tabuser.append(i["name"] as! String)
            
          }
          
          // success ...
        } catch let error as NSError {
          // failure
          print("Fetch failed: \(error.localizedDescription)")
        }
      }
    }) 
    task.resume()
    self.AlertUser("Success", pStrMessage:"Commentaire sending.")
    self.viewDidLoad()
  }
  @IBAction func SendCom(_ sender: AnyObject) {
    if log==true {
      if TFCom.text != ""{
        self.sendComInDataBase()
        TFCom.text=""
      } else {
        AlertUser("Warning", pStrMessage: "Please write a commentaire.")
      }
    }else {
      AlertUser("Warning", pStrMessage: "You are not login.")
    }
  }
  @IBAction func AddFavories(_ sender: AnyObject) {
    if log == true{
      self.addFavories()
    } else {
      self.AlertUser("Favoris", pStrMessage: "Vous n'êtes pas connecté")
    }
  }
  func AlertUser(_ pStrTitle:String?,pStrMessage:String?){
    let alertView:UIAlertView = UIAlertView()
    alertView.title = pStrTitle!
    alertView.message = pStrMessage!
    alertView.delegate = self
    alertView.addButton(withTitle: "OK")
    alertView.show()
  }
  func addFavories(){
    let myUrl = URL(string: "\(Url)/AddFavoris.php")
    var request = URLRequest(url: myUrl!)
    
    request.httpMethod = "POST";
    
    let bodyData = "IdMonu=\(self.strIdMonu)&IdUser=\(Iduser)&nomMonu=\(strTitle)"
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
          if jsonResult["error"] as! Bool != true {
            DispatchQueue.main.async(execute: {
              self.AlertUser("Favoris", pStrMessage: "This monument is saving in your favoris.")
            })
          } else {
            DispatchQueue.main.async(execute: {
              self.AlertUser("Favoris", pStrMessage: jsonResult["error_msg"] as? String)
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
  
  
  @IBAction func GoToMonument(_ sender: AnyObject) {
    let coordinate = CLLocationCoordinate2DMake(theLatitude!,theLongitude!)
    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
    mapItem.name = self.strTitle
    mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeDriving : MKLaunchOptionsDirectionsModeKey])
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
