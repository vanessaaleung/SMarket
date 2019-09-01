//
//  StoreModel.swift
//  nightMarket
//
//  Created by Vanessa on 2019/3/15.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import Foundation

class StoreModel{
    var id: Int
    var name: String?
    var nameJPN: String?
    var url: String?
    var rate: Double
    var categoryId: Int
    var latitude: Double
    var longitude: Double

    init(
        id: Int, name: String?, nameJPN: String?, url: String?, rate: Double, categoryId: Int, latitude: Double, longitude: Double){
        self.id = id
        self.name = name
        self.nameJPN = nameJPN
        self.url = url
        self.rate = rate
        self.categoryId = categoryId
        self.latitude = latitude
        self.longitude = longitude
    }
}


