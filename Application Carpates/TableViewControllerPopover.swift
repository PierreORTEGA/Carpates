//
//  TableViewControllerPopover.swift
//  Application Carpates
//
//  Created by ORTEGA Pierre on 01/04/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//

import UIKit

class TableViewControllerPopover: UITableViewController {

  @IBOutlet var TableParam: UITableView!
  let tabParam1:[String]=["EN","FR","RO"]
  let tabParam2:[String]=["About us"]
  let tabSection:[String]=["Langue","Paramètre"]
  var tabParam:[[String]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tabParam=[tabParam1,tabParam2]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return tabSection.count
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let aCell : UITableViewCell = TableParam.dequeueReusableCell(withIdentifier: "CellParam")!
    let lTab=tabParam[(indexPath as NSIndexPath).section]
    aCell.textLabel?.text=lTab[(indexPath as NSIndexPath).row]
    return aCell
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return tabParam1.count
    default:
      return tabParam2.count
      
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch (indexPath as NSIndexPath).section {
    case 0:
      switch (indexPath as NSIndexPath).row {
      case 0:
        UserDefaults.standard.set(["English"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
      case 1:
        UserDefaults.standard.set(["French"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
      default:
        UserDefaults.standard.set(["Romanian"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
      }
    default:
      self.performSegue(withIdentifier: "Aboutus", sender: self)
    }
  }
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var lStrTilteSection:String?
    switch section {
    case 0:
      lStrTilteSection=tabSection[section]
    default:
      lStrTilteSection=tabSection[section]
      
    }
    return lStrTilteSection
  }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
