//
//  FavouritesViewController.swift
//  nightMarket
//
//  Created by Vanessa on 2019/4/27.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class FavouritesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet var favTbl: UITableView!
    @IBOutlet weak var favView: UIView!
    @IBOutlet weak var resultNum: UILabel!
    @IBOutlet weak var favLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    
    var favstoreList = [StoreModel]()

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var favId = 0
    var refUsers: DatabaseReference!
    var refStores: DatabaseReference!
    var refCategories: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favView.dropShadow2()
        
        favTbl.rowHeight = 320

        if (appDelegate.preferredLanguage == "ja-JP"){
           favLabel.text = "コレクション"
           topLabel.text = "見つかった"
        }
        
        let string = appDelegate.email
        let email = string.replacingOccurrences(of: ".", with: ",")
        
        refUsers = Database.database().reference().child("Users").child(email).child("favorites")
        
        refUsers.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0{
                self.favstoreList.removeAll()
                for allfavs in snapshot.children.allObjects as! [DataSnapshot]{
                    let allfavs = allfavs.value as? [String: AnyObject]
                    let storeId = allfavs?["storeId"] as! Int
                    let storeName = allfavs?["storeName"] as! String?
                    let storeNameJPN = allfavs?["storeNameJPN"] as! String?
                    let storeUrl = allfavs?["storeUrl"] as! String?
                    let storeRate = allfavs?["storeRate"] as! Double
                    let storeCategoryId = allfavs?["storeCategoryId"] as! Int
                    let storeLatitude = 0.0
                    let storeLongitude = 0.0
                    
                    let store = StoreModel(
                        id: storeId, name: storeName, nameJPN: storeNameJPN, url: storeUrl, rate: storeRate, categoryId: storeCategoryId, latitude: storeLatitude, longitude: storeLongitude)
                    self.favstoreList.append(store)
                }
                self.favTbl.reloadData()
                self.resultNum.text = String(self.favstoreList.count)
            }
        })
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favstoreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesTableViewCell", for: indexPath) as! FavouritesTableViewCell
        
        let store: StoreModel
        
        store = favstoreList[indexPath.row]
        
        if (appDelegate.preferredLanguage == "ja-JP"){
            cell.storeName.text = store.nameJPN
        } else{
            cell.storeName.text = store.name
        }
        
        refCategories = Database.database().reference().child("Categories")
        
        refCategories.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0{
                for categories in snapshot.children.allObjects as! [DataSnapshot]{
                    let categoryObject = categories.value as? [String: AnyObject]
                    let categoryId = categoryObject?["categoryId"] as! Int
                    if (categoryId == store.categoryId) {
                        if (self.appDelegate.preferredLanguage == "ja-JP"){
                            cell.storeCategory.text = categoryObject?["categoryNameJPN"] as! String?
                        } else {
                            cell.storeCategory.text = categoryObject?["categoryName"] as! String?
                        }
                    }
                }
            }
        })
        let url = URL(string: store.url!)!
        cell.storeImg.kf.setImage(with: url)
        //cell.storeImg.setImage(from: store.url)
        cell.storeImg.clipsToBounds = true
        cell.storeImg.layer.cornerRadius = 2
        cell.storeRateNum.text = String(store.rate)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailView", sender: indexPath)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.destination, sender) {
        case (let controller as DetailViewController, let indexPath as NSIndexPath):
            controller.receivedId = favstoreList[indexPath.row].id
           
            if (appDelegate.preferredLanguage == "ja-JP"){
                controller.receivedName = favstoreList[indexPath.row].nameJPN!
            } else{
                controller.receivedName = favstoreList[indexPath.row].name!
            }
            
            controller.receivedCategoryId = favstoreList[indexPath.row].categoryId
            controller.receivedRate = favstoreList[indexPath.row].rate
            controller.receivedUrl = favstoreList[indexPath.row].url!
            
        default:
            print("unknown segue")
            break
        }
    }
}
