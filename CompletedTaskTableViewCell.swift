//
//  CompletedTaskTableViewCell.swift
//  Assignment 2
//
//  Created by Chak Lee on 17/4/19.
//  Copyright © 2019 Chak Lee. All rights reserved.
//

import UIKit

class CompletedTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
