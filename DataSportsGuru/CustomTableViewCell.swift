//
//  CustomTableViewCell.swift
//  DataSportsGuru
//
//  Created by Arturo González on 4/24/19.
//  Copyright © 2019 Arturo González. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vScoreLabel: UITextField!
    @IBOutlet weak var vTeamLabel: UITextField!
    @IBOutlet weak var hScoreLabel: UITextField!
    @IBOutlet weak var hTeamLabel: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
