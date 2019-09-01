//
//  AllReviewsViewController.swift
//  nightMarket
//
//  Created by Vanessa on 2019/3/27.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import UIKit
import Cosmos
import Firebase

class AllReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var allReviewsTable: UITableView!
    @IBOutlet weak var YourReviewsView: UIView!
    @IBOutlet weak var reviewsLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var allreviewsList = [AllReviewModel]()
    var reviewList = [AllReviewModel]()
    
    var refAllReviews: DatabaseReference!
    var refStores: DatabaseReference!
    var refUsers: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        YourReviewsView.dropShadow()
        
        if (appDelegate.preferredLanguage == "ja-JP"){
            reviewsLabel.text = "コメント"
        }
        
        allReviewsTable.rowHeight = 100
        
        refAllReviews = Database.database().reference().child("reviews")
        refStores = Database.database().reference().child("Stores")
        
        let string = appDelegate.email
        let email = string.replacingOccurrences(of: ".", with: ",")
        
        refUsers = Database.database().reference().child("Users").child(email).child("reviews")
        
        refUsers.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0{
                self.reviewList.removeAll()
                for allreviews in snapshot.children.allObjects as! [DataSnapshot]{
                    let reviewObject = allreviews.value as? [String: AnyObject]
                    let storeName = reviewObject?["reviewStoreName"] as! String?
                    let storeId = reviewObject?["reviewStore"] as! Int
                    let reviewDate = reviewObject?["reviewDate"] as! String?
                    let reviewContent = reviewObject?["reviewContent"] as! String?
                    let reviewRate = reviewObject?["reviewRate"] as! Double
                    let userEmail = reviewObject?["userEmail"] as! String
                    
                    let review = AllReviewModel(
                        storename: storeName, storeid: storeId, date: reviewDate,
                        review: reviewContent, rate: reviewRate, email: userEmail)
                    
                    self.reviewList.append(review)
                }
                self.allReviewsTable.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "allReviews", for: indexPath) as! allReviewsTableViewCell
        
        let allreviews: AllReviewModel
        
        allreviews = reviewList[indexPath.row]
        
        print(reviewList[indexPath.row])
        cell.reviewStoreName.text = allreviews.storename
        cell.reviewDate.text = allreviews.date
        cell.reviewContent.text = allreviews.review
        cell.reviewStoreRate.rating = allreviews.rate
        
        return cell
    }
}
