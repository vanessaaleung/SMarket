//
//  FoodModel.swift
//  nightMarket
//
//  Created by Vanessa on 2019/3/24.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import Foundation

class FoodModel{
    var storeid : Int
    var name: String?
    var nameJPN: String?
    var desc: String?
    var descJPN: String?
    var price: Double
    var url: String?
    
    init(
        storeid: Int, name: String?, nameJPN: String?, desc: String?, descJPN: String?, price: Double, url: String?){
        self.storeid = storeid
        self.name = name
        self.nameJPN = nameJPN
        self.desc = desc
        self.descJPN = descJPN
        self.price = price
        self.url = url
    }
}
