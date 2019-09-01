//
//  AllReviewModel.swift
//  nightMarket
//
//  Created by Vanessa on 2019/3/28.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import Foundation

class AllReviewModel{
    var storename: String?
    var storeid : Int
    var date: String?
    var review: String?
    var rate: Double
    var email: String?
    
    init(
        storename: String?, storeid: Int, date: String?,
        review: String?, rate: Double, email: String?){
        self.storename = storename
        self.storeid = storeid
        self.date = date
        self.review = review
        self.rate = rate
        self.email = email
    }
}
