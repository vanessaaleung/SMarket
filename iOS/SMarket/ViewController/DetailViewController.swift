//
//  DetailViewController.swift
//  nightMarket
//
//  Created by Vanessa on 2019/3/19.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import UIKit
import Firebase
import Cosmos
import GoogleMaps

class DetailViewController: UIViewController {

    @IBOutlet weak var detailGrey: UIImageView!
    @IBOutlet weak var detailstoreImg: UIImageView!
    @IBOutlet weak var detailstoreName: UILabel!
    @IBOutlet weak var detailstoreCategory: UILabel!
    @IBOutlet weak var detailstoreRate: CosmosView!
    
    @IBOutlet weak var foodView: UIView!
    @IBOutlet weak var reviewView: UIView!
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var shareBtn: UIButton!
    
    var receivedId = 1
    var receivedName = ""
    var receivedCategory = ""
    var receivedRate = 0.1
    var receivedUrl = ""
    var receivedCategoryId = 0
    var receivedNMId = 0
    var receivedLatitude = 0.0
    var receivedLongitude = 0.0
    
    var refStores: DatabaseReference!
    var refCategories: DatabaseReference!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnView.dropShadow()
        
        detailstoreRate.settings.updateOnTouch = false
        detailstoreName.text = receivedName
        //detailstoreCategory.text = receivedCategory
        detailstoreImg.setImage(from: receivedUrl)
        
        shareBtn.contentHorizontalAlignment = .right

        refCategories = Database.database().reference().child("Categories")
        
        refCategories.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0{
                for categories in snapshot.children.allObjects as! [DataSnapshot]{
                    let categoryObject = categories.value as? [String: AnyObject]
                    let categoryId = categoryObject?["categoryId"] as! Int
                    if (categoryId == self.receivedCategoryId) {
                        if (self.appDelegate.preferredLanguage == "ja-JP"){
                            self.detailstoreCategory.text = categoryObject?["categoryNameJPN"] as! String?
                        } else {
                            self.detailstoreCategory.text = categoryObject?["categoryName"] as! String?
                        }
                    }
                }
            }
        })
        
        refStores = Database.database().reference().child("NightMarkets").child(String(receivedNMId)).child("nightmarketStores").child(String(self.receivedId))
        
        refStores.observe(DataEventType.value, with: {(snapshot) in
            let storeObject = snapshot.value as? [String: AnyObject]
            self.detailstoreRate.rating = storeObject?["storeRate"] as! Double
        })
        
        if (appDelegate.preferredLanguage == "ja-JP"){
            menuBtn.setTitle("メニュー", for: .normal)
            reviewBtn.setTitle("コメント", for: .normal)
            shareBtn.setTitle("分け合う", for: .normal)
        }
    }

    @IBAction func foodBtn(_ sender: Any) {
        self.foodView.alpha = 1.0
        self.reviewView.alpha = 0.0
        menuBtn.setTitleColor(UIColor(red: 136/255.0, green: 97/255.0, blue: 246/255.0, alpha: 1.00), for: .normal)
        reviewBtn.setTitleColor(.lightGray, for: .normal)
    }
    
    @IBAction func reviewsBtn(_ sender: Any) {
        self.foodView.alpha = 0.0
        self.reviewView.alpha = 1.0
        menuBtn.setTitleColor(.lightGray, for: .normal)
        reviewBtn.setTitleColor(UIColor(red: 136/255.0, green: 97/255.0, blue: 246/255.0, alpha: 1.00), for: .normal)
    }

    @IBAction func shareTapped(_ sender: UIButton) {
        let text = " Store's Name: " + receivedName + " Store's Image: " + receivedUrl
        let url = NSURL(string: receivedUrl)
        let data = try? Data( contentsOf: url! as URL)
        let image = UIImage(data:data!)
        let shareAll = [text, image!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func mapTapped(_ sender: Any) {
        if (UIApplication.shared.canOpenURL(NSURL(string:"https://maps.google.com")! as URL))
        {
            UIApplication.shared.openURL(NSURL(string:
                "https://maps.google.com/?q=\(receivedLatitude),\(receivedLongitude)")! as URL)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedChildFoodSegue" {
            if let childfoodVC = segue.destination as? ChildFoodViewController {
                //Some property on ChildVC that needs to be set
                childfoodVC.receivedId = self.receivedId
                childfoodVC.receivedNMId = self.receivedNMId
            }
        }
        if segue.identifier == "embedChildReviewsSegue" {
            if let childreviewsVC = segue.destination as? ChildReviewsViewController {
                //Some property on ChildVC that needs to be set
                childreviewsVC.receivedId = self.receivedId
                childreviewsVC.receivedName = self.receivedName
                childreviewsVC.receivedNMId = self.receivedNMId
            }
        }
    }
}
