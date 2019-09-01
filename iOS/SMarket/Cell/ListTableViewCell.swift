//
//  ListTableViewCell.swift
//  nightMarket
//
//  Created by Vanessa on 2019/4/24.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import UIKit
import Firebase
import Cosmos
import FaveButton


class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeCategory: UILabel!
    @IBOutlet weak var storeImg: UIImageView!
    @IBOutlet weak var storeView: UIView!
    @IBOutlet weak var storeRateNum: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var storeId = 0
    var refUsers: DatabaseReference!
    var favselected = false
    var tapAction: ((UITableViewCell) -> Void)?
    var yourobj : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if (!appDelegate.signIn){
            favBtn.isHidden = true
        }
        
        storeView.dropShadow()
        storeView.layer.cornerRadius = 1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func favTapped(_ sender: Any) {
        if let btnAction = self.yourobj
        {
            btnAction()
        }
    }
}
extension UIView {
    func dropShadow2(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: -1, height: 5)
        layer.shadowRadius = 5
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }
}
