//
//  ViewControllerListeMonu.swift
//  Application Carpates
//
//  Created by ORTEGA Pierre on 30/03/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//

import UIKit

class ViewControllerListeMonu: UIViewController,UITableViewDataSource,UITableViewDelegate  {

  
  @IBOutlet weak var NavItem: UINavigationItem!
  @IBOutlet var tabListeMonu: UITableView!
  @IBOutlet weak var menuButton: UIBarButtonItem!
  var strTitle:String=""
  var tabListe:[String]=[]
  var tabidMonu:[String]=[]
  var strNomMonu:String=""
  var strIdMonu:String=""
  var data:Data?
  var canEdit:Bool=false

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.getMonument(idCate)
  }
    override func viewDidLoad() {
        super.viewDidLoad()
        NavItem.title=TitleCate
      
        // Do any additional setup after loading the view.
      // Do any additional setup after loading the view, typically from a nib.
      if self.revealViewController() != nil {
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
      }
      self.tabListeMonu.tableFooterView = UIView(frame: CGRect.zero)
      self.tabListeMonu.tableFooterView?.isHidden = true
     // self.tabListeMonu.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)

    }
  
  
  @IBAction func GoMap(_ sender: AnyObject) {
    self.performSegue(withIdentifier: "LCarte", sender: self)
  }
  func getMonument(_ idCate:String){
    if idCate != ""{
      canEdit=false
      tabIdMonuFav=[]
      let myUrl = URL(string: "\(Url)/ListeMonument.php")
      var request = URLRequest(url: myUrl!)
    
      request.httpMethod = "POST";
    
      let bodyData = "idCate=\(idCate)"
      request.httpBody = bodyData.data(using: String.Encoding.utf8)
      //let task = URLSession.shared.dat
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
              self.tabListe.append(i["name"] as! String)
              self.tabidMonu.append(i["id"] as! String)
            }
            // success ...
          } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
          }
        }
      }) 
    task.resume()
    } else {
      canEdit=true
      let myUrl = URL(string: "\(Url)/ListeFavoris.php")
      var request = URLRequest(url: myUrl!)
      
      request.httpMethod = "POST";
      
      let bodyData = "idUser=\(Iduser)"
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
              self.tabListe.append(i["name"] as! String)
              self.tabidMonu.append(i["id"] as! String)
            }
            tabIdMonuFav=self.tabidMonu
            print(tabIdMonuFav)
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  // MARK: - TableView
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let aCell : PrototypeCellListeMonu = tabListeMonu.dequeueReusableCell(withIdentifier: "CellListeMonu") as! PrototypeCellListeMonu
    aCell.labeltitre.text=tabListe[(indexPath as NSIndexPath).row]
    let url = URL(string:"http://carpati.16mb.com/img/leger/\(self.tabidMonu[(indexPath as NSIndexPath).row]).jpg")
    data = try? Data(contentsOf: url!)

    if data != nil {
      aCell.ImageCell!.image=UIImage(data: data!)
    }
    
    return aCell
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tabListe.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.strNomMonu=tabListe[(indexPath as NSIndexPath).row]
    self.strIdMonu=tabidMonu[(indexPath as NSIndexPath).row]
    self.performSegue(withIdentifier: "DescMonu", sender: self)
  }
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return canEdit
  }
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle==UITableViewCellEditingStyle.delete {
      self.deleteFav(tabidMonu[(indexPath as NSIndexPath).row],pStrUser: Iduser)
      tabidMonu.remove(at: (indexPath as NSIndexPath).row)
      tabListe.remove(at: (indexPath as NSIndexPath).row)
      self.tabListeMonu.reloadData()
    }
  }
  func deleteFav(_ pStrIdMonu:String, pStrUser:String){
    let myUrl = URL(string: "\(Url)/DeleteFav.php")
    var request = URLRequest(url: myUrl!)
    
    request.httpMethod = "POST";
    
    let bodyData = "IdMonu=\(pStrIdMonu)&User=\(pStrUser)"
    request.httpBody = bodyData.data(using: String.Encoding.utf8)
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: {
      data, response, error in
      
      if error != nil {
        print("error\(String(describing: error))")
        return
      } else {
        
      }
    }) 
    task.resume()
  }
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "DescMonu"{
        let navigationController = segue.destination as! ViewControllerDescriptionMonu
        navigationController.strIdMonu=self.strIdMonu
        navigationController.strTitle=self.strNomMonu
      } 
  }

}
