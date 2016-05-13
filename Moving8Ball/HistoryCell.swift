//
//  HistoryCell.swift
//  Moving8Ball
//
//  Created by Matthew Saliba on 13/05/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    
    @IBOutlet var cImage: UIImageView!
    
    @IBOutlet var answer: UILabel!
    @IBOutlet var question: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
