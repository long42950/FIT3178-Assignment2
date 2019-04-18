//
//  TaskStatusTableViewCell.swift
//  Assignment 2
//
//  Created by Chak Lee on 17/4/19.
//  Copyright © 2019 Chak Lee. All rights reserved.
//

import UIKit

class TaskStatusTableViewCell: UITableViewCell {
    
    //this is the text shown on the status cell
    @IBOutlet weak var statusLabel: UILabel!
    
    //this is the number of incompleted task shown on the status cell
    @IBOutlet weak var taskNumLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
