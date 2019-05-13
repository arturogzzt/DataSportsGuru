//
//  CustomTableViewCell.swift
//  DataSportsGuru
//
//  Created by Arturo González on 4/24/19.
//  Copyright © 2019 Arturo González. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vScoreLabel: UILabel!
    @IBOutlet weak var vTeamLabel: UILabel!
    @IBOutlet weak var hScoreLabel: UILabel!
    @IBOutlet weak var hTeamLabel: UILabel!
    @IBOutlet weak var gameStatus: UILabel!
    @IBOutlet weak var vTeamImageView: UIImageView!
    @IBOutlet weak var hTeamImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
