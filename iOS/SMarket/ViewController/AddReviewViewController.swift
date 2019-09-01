//
//  AddReviewViewController.swift
//  nightMarket
//
//  Created by Vanessa on 2019/3/25.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import UIKit
import Cosmos
import Firebase
import Kingfisher

class AddReviewViewController: UIViewController {

    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userRate: CosmosView!
    @IBOutlet weak var userComment: UITextField!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var receivedName = ""
    var receivedId = 1
    var receivedNMId = 0
    var storeRateUpdate = 0.0
    var storeReviewsCountUpdate = 0.0
    var storeList = [StoreModel]()
    
    //Defining Firebase reference var
    var refReview: DatabaseReference!
    var refUpdate: DatabaseReference!
    var refStore: DatabaseReference!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let string = appDelegate.email
        let email = string.replacingOccurrences(of: ".", with: ",")
        
        refReview = Database.database().reference().child("Users").child(email).child("reviews")
        
        if (appDelegate.preferredLanguage == "ja-JP"){
            postBtn.setTitle("提出する", for: .normal)
            cancelBtn.setTitle("取り消す", for: .normal)
            userComment.placeholder = "あなたのコメントを書く"
        }
        
        //Read initial data
        userName.text = appDelegate.fullName
        let url = URL(string: appDelegate.pic)!
        userImg.kf.setImage(with: url)
        userImg.layer.cornerRadius = (userImg.frame.width / 2)
        userImg.layer.masksToBounds = true
        userRate.didFinishTouchingCosmos = { rating in }
        
        showAnimate()
        
        //Set view appearance
        view.backgroundColor = UIColor(white: 1, alpha: 0.6)
        reviewView.dropShadow()
        
        //Set textField appearance
        let bottomLine = CALayer()
        bottomLine.frame = CGRect.init(x: 0, y: userComment.frame.size.height - 1, width: userComment.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        userComment.borderStyle = UITextField.BorderStyle.none
        userComment.layer.addSublayer(bottomLine)
    }
    
    @IBAction func closeKeyboard(_ sender: Any) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func postReview(_ sender: UIButton) {
        //getting the generated key
        let key = refReview.childByAutoId().key!
        let date = Date().asString(style: .medium)
        
        //creating artist with the given values
        let review = ["userName": appDelegate.fullName,
                      "userImage": appDelegate.pic,
                      "userEmail" : appDelegate.email,
                      "reviewDate" : date,
                      "reviewRate" : userRate.rating,
                      "reviewStore" : receivedId,
                      "reviewStoreName" : receivedName,
                      "reviewContent" : userComment.text!
        ] as [String : Any]
        
        refUpdate = Database.database().reference().child("NightMarkets").child(String(receivedNMId)).child("nightmarketStores").child(String(self.receivedId))
       
        
        refStore = Database.database().reference().child("NightMarkets").child(String(receivedNMId)).child("nightmarketStores").child(String(self.receivedId))

        refStore.observeSingleEvent(of: .value, with: { (snapshot) in
            let storeObject = snapshot.value as? [String: AnyObject]
            let storeId = storeObject?["storeId"] as! Int
            if (storeId == self.receivedId) {
                let storeRate = storeObject?["storeRate"] as! Double
                let storeReviewsCount = storeObject?["storeReviewsCount"] as! Double
                self.storeReviewsCountUpdate = storeReviewsCount + 1.0
                self.storeRateUpdate = (storeRate + self.userRate.rating) / 2
                let data  = ["storeRate": self.storeRateUpdate, "storeReviewsCount": self.storeReviewsCountUpdate ]
                self.refUpdate.updateChildValues(data)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        refStore.child("storeReviews").child(key).setValue(review)
        refReview.child(key).setValue(review)
        removeAnimate()
    }
    
    @IBAction func cancelReview(_ sender: Any) {
        removeAnimate()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if(finished)
            {
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        })
    }
}
extension Date {
    func asString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
}
extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 2
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
