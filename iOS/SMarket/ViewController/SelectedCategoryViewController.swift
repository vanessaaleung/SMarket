//
//  SelectedCategoryViewController.swift
//  nightMarket
//
//  Created by Vanessa on 2019/4/24.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import UIKit
import Firebase
import Cosmos
import Kingfisher

class SelectedCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var selectedTable: UITableView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var resultNum: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    
    var categoryString = ""
    var categoryId = 0
    var receivedNMId = 0
    
    var selectedstoreList = [StoreModel]()
    
    var refStores: DatabaseReference!
    var refCategories: DatabaseReference!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        categoryName.text = self.categoryString
        selectedView.dropShadow2()

        selectedTable.rowHeight = 320
        
        if(appDelegate.preferredLanguage == "ja-JP"){
            topLabel.text = "見つかった"
        }
        
        //refStores = Database.database().reference().child("Stores")
        refStores = Database.database().reference().child("NightMarkets").child(String(receivedNMId)).child("nightmarketStores")
        
        refCategories = Database.database().reference().child("Categories")
        
        refCategories.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0{
                for categories in snapshot.children.allObjects as! [DataSnapshot]{
                    let categoryObject = categories.value as? [String: AnyObject]
                    var category = ""
                    if (self.appDelegate.preferredLanguage == "ja-JP"){
                        category = (categoryObject?["categoryNameJPN"] as! String?)!
                    } else {
                        category = (categoryObject?["categoryName"] as! String?)!
                    }
                    if (category == self.categoryString) {
                        self.categoryId = categoryObject?["categoryId"] as! Int
                    }
                }
            }
        })
        
        refStores.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0{
                self.selectedstoreList.removeAll()
                for stores in snapshot.children.allObjects as! [DataSnapshot]{
                    let storeObject = stores.value as? [String: AnyObject]
                    let storeCategoryId = storeObject?["storeCategoryId"] as! Int
                    if (storeCategoryId == self.categoryId) {
                        let storeId = storeObject?["storeId"] as! Int
                        let storeName = storeObject?["storeName"] as! String?
                        let storeNameJPN = storeObject?["storeNameJPN"] as! String?
                        let storeUrl = storeObject?["storeUrl"] as! String?
                        let storeRate = storeObject?["storeRate"] as! Double
                        let storeCategoryId = storeObject?["storeCategoryId"] as! Int
                        let storeLatitude = storeObject?["storeLatitude"] as! Double
                        let storeLongitude = storeObject?["storeLongitude"] as! Double
                        
                        let store = StoreModel(
                            id: storeId, name: storeName, nameJPN: storeNameJPN, url: storeUrl, rate: storeRate, categoryId: storeCategoryId, latitude: storeLatitude, longitude: storeLongitude)
                        self.selectedstoreList.append(store)
                    }}
                self.selectedTable.reloadData()
                self.resultNum.text = String(self.selectedstoreList.count)
            }
        })
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedstoreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedCell", for: indexPath) as! SelectedCategoryTableViewCell
        
        let store: StoreModel
        store = selectedstoreList[indexPath.row]
        if (appDelegate.preferredLanguage == "ja-JP"){
            cell.storeName.text = store.nameJPN
        } else{
            cell.storeName.text = store.name
        }
        cell.storeCategory.text = self.categoryString
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
            controller.receivedId = selectedstoreList[indexPath.row].id
            if (appDelegate.preferredLanguage == "ja-JP"){
                controller.receivedName = selectedstoreList[indexPath.row].nameJPN!
            } else{
                controller.receivedName = selectedstoreList[indexPath.row].name!
            }
            controller.receivedLongitude = selectedstoreList[indexPath.row].longitude
            controller.receivedLatitude = selectedstoreList[indexPath.row].latitude
            controller.receivedNMId = self.receivedNMId
            controller.receivedCategoryId = selectedstoreList[indexPath.row].categoryId
            controller.receivedRate = selectedstoreList[indexPath.row].rate
            controller.receivedUrl = selectedstoreList[indexPath.row].url!
            
        default:
            print("unknown segue")
            break
        }
    }

}
