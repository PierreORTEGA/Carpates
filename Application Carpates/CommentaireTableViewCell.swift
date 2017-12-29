//
//  CommentaireTableViewCell.swift
//  Application Carpates
//
//  Created by ORTEGA Pierre on 30/04/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//

import UIKit

class CommentaireTableViewCell: UITableViewCell {
  @IBOutlet weak var UserNameLabel: UILabel!
  @IBOutlet weak var NoteRatingBar: RatingAvis!
  @IBOutlet weak var DateLabel: UILabel!
  @IBOutlet weak var DescriptionLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}
