//
//  PrototypeCellListeMonu.swift
//  Application Carpates
//
//  Created by ORTEGA Pierre on 25/05/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//

import UIKit

class PrototypeCellListeMonu: UITableViewCell {
  
  
  @IBOutlet weak var labeltitre: UILabel!
  @IBOutlet weak var ImageCell: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}
