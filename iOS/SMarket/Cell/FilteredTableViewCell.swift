//
//  FilteredTableViewCell.swift
//  SMarket
//
//  Created by Vanessa on 2019/5/16.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import UIKit

class FilteredTableViewCell: UITableViewCell {

    @IBOutlet weak var filteredstoreName: UILabel!
    @IBOutlet weak var filteredstoreCategory: UILabel!
    @IBOutlet weak var filteredstoreImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
