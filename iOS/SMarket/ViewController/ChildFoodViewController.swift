//
//  ChildFoodViewController.swift
//  nightMarket
//
//  Created by Vanessa on 2019/4/22.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import UIKit
import Firebase
import Cosmos
import Kingfisher

class ChildFoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var foodTable: UITableView!
    
    var foodList = [FoodModel]()
    var receivedId = 1
    var receivedNMId = 0
    
    var refFood: DatabaseReference!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodTable.rowHeight = 130
        
        //Getting a reference to the node stores
        refFood = Database.database().reference().child("NightMarkets").child(String(receivedNMId)).child("nightmarketStores").child(String(self.receivedId)).child("storeFood")
        
        refFood.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0{
                self.foodList.removeAll()
                for food in snapshot.children.allObjects as! [DataSnapshot]{
                    let foodObject = food.value as? [String: AnyObject]
                    let foodName = foodObject?["foodName"]
                    let foodNameJPN = foodObject?["foodNameJPN"]
                    let foodDesc = foodObject?["foodDesc"]
                    let foodDescJPN = foodObject?["foodDescJPN"]
                    let foodPrice = foodObject?["foodPrice"]
                    let foodUrl = foodObject?["foodImage"]
                    
                    let food = FoodModel(
                        storeid: self.receivedId, name: foodName as! String?, nameJPN: foodNameJPN as! String?, desc: foodDesc as! String?, descJPN: foodDescJPN as! String?, price: foodPrice as! Double, url: foodUrl as! String?)
                    self.foodList.append(food)
            }
                self.foodTable.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! foodTableViewCell
        
        let food: FoodModel
        
        food = foodList[indexPath.row]
        
        if (appDelegate.preferredLanguage == "ja-JP"){
            cell.foodName.text = food.nameJPN
            cell.foodDesc.text = food.descJPN
        } else {
            cell.foodName.text = food.name
            cell.foodDesc.text = food.desc
        }
        cell.foodPrice.text = String(food.price)
        //cell.foodImage.setImage(from: food.url)
        let url = URL(string: food.url!)!
        cell.foodImage.kf.setImage(with: url)
        return cell
    }
    
}
