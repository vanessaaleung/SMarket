//
//  allReviewsTableViewCell.swift
//  nightMarket
//
//  Created by Vanessa on 2019/3/27.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import UIKit
import Cosmos

class allReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewStoreName: UILabel!
    @IBOutlet weak var reviewDate: UILabel!
    @IBOutlet weak var reviewContent: UILabel!
    @IBOutlet weak var reviewStoreRate: CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        reviewStoreRate.settings.updateOnTouch = false

        // Configure the view for the selected state
    }

}
