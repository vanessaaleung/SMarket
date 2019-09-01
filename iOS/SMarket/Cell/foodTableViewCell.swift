//
//  foodTableViewCell.swift
//  nightMarket
//
//  Created by Vanessa on 2019/3/21.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import UIKit
import Cosmos

class foodTableViewCell: UITableViewCell {

    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodDesc: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
