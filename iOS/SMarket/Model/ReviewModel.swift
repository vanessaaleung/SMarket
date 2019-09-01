//
//  ReviewModel.swift
//  nightMarket
//
//  Created by Vanessa on 2019/3/24.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import Foundation

class ReviewModel{
    var storeid : Int
    var storename: String?
    var date: String?
    var name: String?
    var review: String?
    var url: String?
    var rate: Double
    var email: String?
    
    init(
        storeid: Int, storename: String?, name: String?, date: String?,
        review: String?, url: String?, rate: Double, email: String?){
        self.storeid = storeid
        self.storename = storename
        self.name = name
        self.date = date
        self.review = review
        self.url = url
        self.rate = rate
        self.email = email
    }
}
