//
//  UnityViewController.swift
//  nightMarket
//
//  Created by Vanessa on 2019/5/2.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import UIKit
import Firebase

class ARViewController: UIViewController {
    
    var unityView: UIView?
    var storeName = "storeName"
    var refStores: DatabaseReference!
    var storeList = [StoreModel]()
    var receivedNMId = 0
    var receivedId = 0
    var receivedName = ""
    var receivedCategory = ""
    var receivedRate = 0.1
    var receivedUrl = ""
    var receivedCategoryId = 0
    var receivedLatitude = 0.0
    var receivedLongitude = 0.0
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(isDataGet(_:)), name:
            NSNotification.Name("NotificationName") , object: nil)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        refStores = Database.database().reference().child("NightMarkets").child(String(receivedNMId)).child("nightmarketStores")
//
        appDelegate.startUnity()

        unityView = UnityGetGLView()!

        self.view!.addSubview(unityView!)
        unityView!.translatesAutoresizingMaskIntoConstraints = false

        // look, non-full screen unity content!
        let views = ["view": unityView]
        //        let w = NSLayoutConstraint.constraints(withVisualFormat: "|-20-[view]-20-|", options: [], metrics: nil, views: views)
        //        let h = NSLayoutConstraint.constraints(withVisualFormat: "V:|-75-[view]-50-|", options: [], metrics: nil, views: views)
        let w = NSLayoutConstraint.constraints(withVisualFormat: "|-0-[view]-0-|", options: [], metrics: nil, views: views as [String : Any])
        let h = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: views as [String : Any])
        view.addConstraints(w + h)
        
    }
    
 
    
    @objc func isDataGet(_ n: NSNotification) {
        self.storeName = n.userInfo?["data"] as! String
//        refStores.observe(DataEventType.value, with: {(snapshot) in
//            if snapshot.childrenCount > 0{
//                self.storeList.removeAll()
//                print(self.storeName)
//                for stores in snapshot.children.allObjects as! [DataSnapshot]{
//                    let storeObject = stores.value as? [String: AnyObject]
//                    let storeName = storeObject?["storeName"] as! String?
//                    print(self.storeName)
//                    if (storeName == self.storeName) {
//                        let storeId = storeObject?["storeId"] as! Int
//                        let storeName = storeObject?["storeName"] as! String?
//                        let storeNameJPN = storeObject?["storeNameJPN"] as! String?
//                        let storeUrl = storeObject?["storeUrl"] as! String?
//                        let storeRate = storeObject?["storeRate"] as! Double
//                        let storeCategoryId = storeObject?["storeCategoryId"] as! Int
//                        let storeLatitude = storeObject?["storeLatitude"] as! Double
//                        let storeLongitude = storeObject?["storeLongitude"] as! Double
//
//                        let store = StoreModel(
//                            id: storeId, name: storeName, nameJPN: storeNameJPN, url: storeUrl, rate: storeRate, categoryId: storeCategoryId, latitude: storeLatitude, longitude: storeLongitude)
//                        self.storeList.append(store)
//
//                    }}
//            }
//        })
        
        print(self.receivedLatitude)
        //        let store: StoreModel
        //print(self.storeList[0])
        //store = self.storeList[0]
        //        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        //        desVC.receivedNMId = self.receivedNMId
        //        desVC.receivedId = self.receivedId
        //        desVC.receivedName = store.name!
        //        desVC.receivedRate = store.rate
        //        desVC.receivedUrl = store.url!
        //        desVC.receivedCategoryId = store.categoryId
        //        desVC.receivedLatitude = store.latitude
        //        desVC.receivedLongitude = store.longitude
        
        //        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
}

