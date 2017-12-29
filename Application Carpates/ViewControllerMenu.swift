//
//  ViewControllerParametre.swift
//  Application Carpates
//
//  Created by ORTEGA Pierre on 25/03/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//

import UIKit

class ViewControllerMenu: UIViewController,UITableViewDataSource,UITableViewDelegate {

  @IBOutlet weak var TableParam: UITableView!
  let tabParam1:[String]=[NSLocalizedString("Connexion",comment:""),NSLocalizedString("Inscription",comment:"")]
  var tabParam2:[String]=[]
  var tabParam3:[String]=[]
  let tabSection:[String]=[NSLocalizedString("Espace Utilisateur", comment:""),NSLocalizedString("Lieux", comment:"")]
  var tabParam:[[String]] = []
  var tabIdCate:[String]=[]
  let VC = ViewController()
  var strTitleCate:String=""
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.getCate()
  }
    override func viewDidLoad() {
        super.viewDidLoad()
      if log == true {
        tabParam3=[Pseudo,NSLocalizedString("Déconnexion",comment:""),NSLocalizedString("Favories",comment:"")]
        tabParam=[tabParam3,tabParam2]
      } else {
        tabParam=[tabParam1,tabParam2]
      }
        // Do any additional setup after loading the view.
      self.TableParam.tableFooterView = UIView(frame: CGRect.zero)
      self.TableParam.tableFooterView?.isHidden = true
      self.TableParam.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  override func viewDidAppear(_ animated: Bool) {
    self.viewDidLoad()
    self.TableParam.reloadData()
  }
  func getCate(){
    let myUrl = URL(string: "\(Url)/Categorie.php")
    let request = URLRequest(url: myUrl!)
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: {
      data, response, error in
      
      if error != nil {
        print("error\(String(describing: error))")
        return
      }else {
        do {
          let jsonResult:NSArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
          print(jsonResult)
          for i in (jsonResult as? [[String:Any]])!{
            self.tabParam2.append(i["nom"] as! String)
            self.tabIdCate.append(i["id"] as! String)
          }
          self.tabParam2.append("All Monument")
          self.tabIdCate.append("")
          // success ...
        } catch let error as NSError {
          // failure
          print("Fetch failed: \(error.localizedDescription)")
        }
      }
    }) 
    
    task.resume()
    
  }
  // MARK: - TableView
  func numberOfSections(in tableView: UITableView) -> Int {
    return tabSection.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let aCell : UITableViewCell = TableParam.dequeueReusableCell(withIdentifier: "CellParam")!
    let lTab=tabParam[(indexPath as NSIndexPath).section]
    aCell.textLabel?.text=lTab[(indexPath as NSIndexPath).row]
    return aCell
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if log != true {
      switch section {
      case 0:
        return tabParam1.count
      default:
        return tabParam2.count

      }
    }else {
      switch section {
      case 0:
        return tabParam3.count
      default:
        return tabParam2.count
        
      }
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    switch (indexPath as NSIndexPath).section {
    case 0:
      if log != true {
        switch (indexPath as NSIndexPath).row {
        case 0:
          self.performSegue(withIdentifier: "Connection", sender: self)
        default:
          self.performSegue(withIdentifier: "Inscription", sender: self)
        }
      } else {
        switch (indexPath as NSIndexPath).row {
        case 0:
          self.performSegue(withIdentifier: "yourAccount", sender: self)
          break
        case 1:
          log = false
          self.viewDidLoad()
          self.TableParam.reloadData()
          break
        default:
          TitleCate=(tableView.cellForRow(at: indexPath)?.textLabel?.text)!
          idCate=""
          self.performSegue(withIdentifier: "ListeMonu", sender: self)
          break
          
        }
      }
    default:
      switch (indexPath as NSIndexPath).row {
      case 4:
        TitleCate=(tableView.cellForRow(at: indexPath)?.textLabel?.text)!
        self.performSegue(withIdentifier: "Carte", sender: self)
        idCate=""
        tabIdMonuFav=[]
        break
      default:
        TitleCate=(tableView.cellForRow(at: indexPath)?.textLabel?.text)!
        idCate=tabIdCate[(indexPath as NSIndexPath).row]
        tabIdMonuFav=[]
        self.performSegue(withIdentifier: "ListeMonu", sender: self)
      }
      
      
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var lStrTilteSection:String?
    switch section {
    case 0:
      lStrTilteSection=tabSection[section]
    default:
      lStrTilteSection=tabSection[section]

    }
    return lStrTilteSection
  }
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

  }
  

}
