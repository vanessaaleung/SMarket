//
//  FavouritesTableViewCell.swift
//  nightMarket
//
//  Created by Vanessa on 2019/4/27.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import UIKit

class FavouritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var storeImg: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var selectedstoreView: UIView!
    @IBOutlet weak var storeCategory: UILabel!
    @IBOutlet weak var storeRateNum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectedstoreView.dropShadow()
        selectedstoreView.layer.cornerRadius = 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
