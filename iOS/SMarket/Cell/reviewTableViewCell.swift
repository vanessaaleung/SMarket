//
//  reviewTableViewCell.swift
//  nightMarket
//
//  Created by Vanessa on 2019/3/24.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import UIKit
import Cosmos

class reviewTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var reviewDate: UILabel!
    @IBOutlet weak var review: UILabel!
    @IBOutlet weak var reviewRate: CosmosView!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        reviewRate.settings.updateOnTouch = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
