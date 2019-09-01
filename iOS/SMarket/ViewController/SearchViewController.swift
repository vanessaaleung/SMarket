//
//  SearchViewController.swift
//  SMarket
//
//  Created by Vanessa on 2019/5/16.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Kingfisher

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    @IBOutlet weak var searchTbl: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var receivedNMId = 0
    
    var storesArray = [NSDictionary?]()
    var filteredStores = [NSDictionary?]()
    
    var databaseRef = Database.database().reference()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTbl.rowHeight = 100
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .black
        searchController.searchBar.placeholder = "Search stores here..."
        searchController.searchBar.barTintColor = .white
        definesPresentationContext = true
        searchTbl.tableHeaderView = searchController.searchBar
                
        databaseRef.child("NightMarkets").child(String(self.receivedNMId)).child("nightmarketStores").observe(.childAdded, with: {(snapshot) in
            if snapshot.childrenCount > 0{
                self.storesArray.append(snapshot.value as? NSDictionary)
            }
        //insert the rows
        self.searchTbl.insertRows(at: [IndexPath(row: self.storesArray.count-1, section: 0)], with: UITableView.RowAnimation.automatic)
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: self.searchController.searchBar.text!)
    }
    
    func filterContent(searchText: String){
        self.filteredStores = self.storesArray.filter{store in
            if (self.appDelegate.preferredLanguage == "ja-JP"){
                let storename = store!["storeNameJPN"] as? String
                let storeDesc = store!["storeDesc"] as? String
                return (storename?.lowercased().contains(searchText.lowercased()))! || (storeDesc?.lowercased().contains(searchText.lowercased()))!
            } else {
                let storename = store!["storeName"] as? String
                let storeDesc = store!["storeDesc"] as? String
                return (storename?.lowercased().contains(searchText.lowercased()))! || (storeDesc?.lowercased().contains(searchText.lowercased()))!
            }
        }
        searchTbl.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""
        {
            return filteredStores.count
        } else {
            return self.storesArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTbl.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FilteredTableViewCell
        let store : NSDictionary?
        
        if searchController.isActive && searchController.searchBar.text != ""{
            store = filteredStores[indexPath.row]
        } else {
            store = self.storesArray[indexPath.row]
        }
        
        if (self.appDelegate.preferredLanguage == "ja-JP"){
            cell.filteredstoreName.text = store?["storeNameJPN"] as? String
        } else {
            cell.filteredstoreName.text = store?["storeName"] as? String
        }
        
        var refCategories: DatabaseReference!
        
        refCategories = Database.database().reference().child("Categories")
        
        refCategories.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0{
                for categories in snapshot.children.allObjects as! [DataSnapshot]{
                    let categoryObject = categories.value as? [String: AnyObject]
                    let categoryId = categoryObject?["categoryId"] as! Int
                    if (categoryId == store?["storeCategoryId"] as? Int) {
                        if (self.appDelegate.preferredLanguage == "ja-JP"){
                            cell.filteredstoreCategory.text = categoryObject?["categoryNameJPN"] as! String?
                        } else {
                            cell.filteredstoreCategory.text = categoryObject?["categoryName"] as! String?
                        }
                    }
                }
            }
        })
        let url = URL(string: (store?["storeUrl"] as? String)!)!
        cell.filteredstoreImg.kf.setImage(with: url)
        //cell.filteredstoreImg.setImage(from: store?["storeUrl"] as? String)
        cell.filteredstoreImg.clipsToBounds = true
        cell.filteredstoreImg.layer.cornerRadius = 1
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let store: NSDictionary?
        if searchController.isActive && searchController.searchBar.text != ""{
            store = filteredStores[indexPath.row]
            desVC.receivedId = store?["storeId"] as! Int
            if (self.appDelegate.preferredLanguage == "ja-JP"){
                desVC.receivedName = store?["storeNameJPN"] as! String
            } else{
                desVC.receivedName = store?["storeName"] as! String
            }
            desVC.receivedNMId = self.receivedNMId
            desVC.receivedCategoryId = store?["storeCategoryId"] as! Int
            desVC.receivedRate = store?["storeRate"] as! Double
            desVC.receivedUrl = store?["storeUrl"] as! String
        } else {
            store = self.storesArray[indexPath.row]
            desVC.receivedId = store?["storeId"] as! Int
            if (self.appDelegate.preferredLanguage == "ja-JP"){
                desVC.receivedName = store?["storeNameJPN"] as! String
            } else{
                desVC.receivedName = store?["storeName"] as! String
            }
            desVC.receivedNMId = self.receivedNMId
            desVC.receivedCategoryId = store?["storeCategoryId"] as! Int
            desVC.receivedRate = store?["storeRate"] as! Double
            desVC.receivedUrl = store?["storeUrl"] as! String
        }
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
}
