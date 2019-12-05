//
//  EventCell.swift
//  LetsSeeAShow
//
//  Created by Jay Fein on 12/3/19.
//  Copyright © 2019 Jay Fein. All rights reserved.
//

import Foundation
import UIKit

class EventCell : UITableViewCell {
    
    
    @IBOutlet weak var concertImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
