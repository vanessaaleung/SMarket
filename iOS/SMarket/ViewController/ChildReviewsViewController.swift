//
//  ChildReviewsViewController.swift
//  nightMarket
//
//  Created by Vanessa on 2019/4/22.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import UIKit
import Cosmos
import Firebase
import Kingfisher

class ChildReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var reviewTable: UITableView!
    @IBOutlet weak var writeReview: UIButton!
    
    var receivedId = 1
    var receivedName = ""
    var receivedNMId = 0
    
    //List all the store
    var reviewList = [ReviewModel]()
    
    //Defining Firebase reference var
    var refReview: DatabaseReference!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        if (!appDelegate.signIn){
            writeReview.isHidden = true
        }
        
        if (appDelegate.preferredLanguage == "ja-JP"){
            writeReview.setTitle("レビュー投稿", for: .normal)
        } 
        writeReview.backgroundColor = .clear
        writeReview.layer.cornerRadius = 10
        writeReview.layer.borderWidth = 1
        writeReview.layer.borderColor = UIColor.gray.cgColor
        
        reviewTable.rowHeight = 100
        
        refReview = Database.database().reference().child("NightMarkets").child(String(receivedNMId)).child("nightmarketStores").child(String(self.receivedId)).child("storeReviews")
        
        refReview.observe(DataEventType.value, with: {(snapshot) in
            //If the reference have some values
            if snapshot.childrenCount > 0{
                //Clearing the list
                self.reviewList.removeAll()
                //Iterating through all the values
                for review in snapshot.children.allObjects as! [DataSnapshot]{
                    //Getting values
                    let reviewObject = review.value as? [String: AnyObject]
                    let reviewStore = reviewObject?["reviewStore"] as! Int
                    if (reviewStore == self.receivedId) {
                        let userName = reviewObject?["userName"]
                        let reviewDate = reviewObject?["reviewDate"]
                        let reviewContent = reviewObject?["reviewContent"]
                        let userImage = reviewObject?["userImage"]
                        let reviewRate = reviewObject?["reviewRate"]
                        let userEmail = reviewObject?["userEmail"]
                        let reviewStoreName = reviewObject?["storeName"]
                        
                        //Creating store object with model and fetched values
                        let review = ReviewModel(
                            storeid: reviewStore, storename: reviewStoreName as! String?, name: userName as! String?, date: reviewDate as! String?, review: reviewContent as! String?, url: userImage as! String?, rate: reviewRate as! Double, email: userEmail as! String?)
                        //Appending it to list
                        self.reviewList.append(review)
                    }}
                //Reloading the tableview
                self.reviewTable.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! reviewTableViewCell
        
        //The Review object
        let review: ReviewModel
        
        //Getting the review of selected position
        review = reviewList[indexPath.row]
        
        //Adding values to cell
        cell.userName.text = review.name
        cell.reviewDate.text = review.date
        cell.review.text = review.review
        let url = URL(string: review.url!)!
        cell.userImage.kf.setImage(with: url)
        //cell.userImage.setImage(from: review.url)
        cell.userImage.layer.cornerRadius = (cell.userImage.frame.width / 2)
        cell.userImage.layer.masksToBounds = true
        cell.reviewRate.rating = review.rate
        cell.reviewRate.didFinishTouchingCosmos = { rating in }
        //Returning cell
        return cell
    }
    
    @IBAction func writeReview(_ sender: Any) {
        let popvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddReview") as! AddReviewViewController
        popvc.receivedName = receivedName
        popvc.receivedId = receivedId
        popvc.receivedNMId = receivedNMId
        
        self.addChild(popvc)
        
        popvc.view.frame = self.view.frame
        self.view.addSubview(popvc.view)
        popvc.didMove(toParent: self)
    }

}
