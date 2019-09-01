//
//  ListViewController.swift
//  nightMarket
//
//  Created by Vanessa on 2019/4/24.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import UIKit
import Firebase
import Cosmos
import FaveButton
import GoogleSignIn
import Kingfisher


class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, UIScrollViewDelegate{
    
    @IBOutlet weak var allstoreTable: UITableView!
    @IBOutlet weak var popularLabel: UILabel!
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var sideTbl: UITableView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var greyView: UIView!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var allStoresLabel: UILabel!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var dropDownTbl: UITableView!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var camBtn: UIButton!
    @IBOutlet weak var scrollviewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var LeadingConstraint: NSLayoutConstraint!
    
    var sideViewShow : Bool = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let searchController = UISearchController(searchResultsController: nil)
    
    var receivedNMId = 0
    var receivedNMName = ""
    var receivedNMNameJPN = ""
    
    var window: UIWindow?
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var funArray = ["All reviews", "Favorites"]
    var funArrayJPN = ["コメント", "お気に入り"]
    var imageViewArray: [UIImage] = [UIImage(named: "Chinese.jpg")!, UIImage(named: "Japanese.jpg")!,
                                     UIImage(named: "BubbleTea.jpg")!, UIImage(named: "Juice.jpg")!,
                                     UIImage(named: "Taiwanese.jpg")!, UIImage(named: "Japanese.jpg")!]
    var nameArray = ["Chinese", "Japanese", "Bubble Tea", "Juice", "Taiwanese", "Western"]
    var nameArrayJPN = ["中華料理", "和風", "タピオカティー", "ジュース", "台湾料理", "和風", "洋食"]
    var nmNameArray = ["Shi Lin Night Market", "Ning Xia Night Market", "Lin Jiang Night Market", "Rao He Night Market", "Nan Ji Chang Night Market"]
    var nmNameArrayJPN = ["士林観光夜市", "寧夏観光夜市", "臨江観光夜市", "饒河観光夜市", "南機場観光夜市"]
    
    //Firebase
    var storesArray = [NSDictionary?]()
    var filteredStores = [NSDictionary?]()
    
    var refStores: DatabaseReference!
    var refStars = Database.database().reference()
    var refUsers: DatabaseReference!
    var refCategories: DatabaseReference!
    var storeList = [StoreModel]()
    var favList = [StoreModel]()
    
    
//    @IBAction func camTapped(_ sender: Any) {
//        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "ARViewController") as! ARViewController
//        desVC.receivedNMId = self.receivedNMId
//        self.navigationController?.pushViewController(desVC, animated: true)
//    }
    
    
    @IBAction func dropDownTapped(_ sender: Any) {
        if dropDownView.isHidden{
            animate(toogle: true)
        } else{
            animate(toogle: false)
        }
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        desVC.receivedNMId = self.receivedNMId
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    func animate(toogle: Bool){
        if toogle{
            UIView.animate(withDuration: 0.3) {
                self.dropDownTbl.isHidden = false
                self.dropDownView.isHidden = false
            }
        }
        else{
            UIView.animate(withDuration: 0.3) {
                self.dropDownTbl.isHidden = true
                self.dropDownView.isHidden = true
            }
        }
    }
    
    //Side View
    @IBAction func menuTapped(_ sender: Any) {
        if (self.sideViewShow) {
            LeadingConstraint.constant = -320
            greyView.isHidden = true
        } else {
            LeadingConstraint.constant = 0
            greyView.isHidden = false
        }
        self.sideViewShow = !self.sideViewShow
    }
    
    @IBAction func didTapSignOut(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        appDelegate.signIn = false
        appDelegate.fullName = "Guest"
        appDelegate.pic = "https://mnsearch.org/wp-content/uploads/2014/10/blank-2017.jpg"
        viewLoadSetup()
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        self.tabBarController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeTapped(_ sender: Any) {
        if (appDelegate.preferredLanguage == "ja-JP"){
            appDelegate.preferredLanguage = "en-US"
        } else {
            appDelegate.preferredLanguage = "ja-JP"
        }
        viewLoadSetup()
        categoryCollection.reloadData()
        sideTbl.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoadSetup()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewLoadSetup()
    }
    
    
    
    
    @objc func viewLoadSetup(){
        dropDownTbl.isHidden = true
        dropDownView.isHidden = true
        dropDownView.dropShadow2()
        
        //Style camera button
        camBtn.layer.shadowColor = UIColor.gray.cgColor
        camBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        camBtn.layer.shadowRadius = 5
        camBtn.layer.shadowOpacity = 1.0
        camBtn.layer.cornerRadius = camBtn.frame.width / 2
        camBtn.imageEdgeInsets = UIEdgeInsets(
            top: (camBtn.frame.size.height - 40) / 2,
            left: (camBtn.frame.size.width - 40) / 2,
            bottom: (camBtn.frame.size.height - 40) / 2,
            right: (camBtn.frame.size.width - 40) / 2)

    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        greyView.isHidden = true
        sideTbl.isScrollEnabled = false
        
        if (!appDelegate.signIn) {
            sideTbl.isHidden = true
            signOutBtn.isHidden = true
            signInBtn.isHidden = false
        } else {
            sideTbl.isHidden = false
            signOutBtn.isHidden = false
            signInBtn.isHidden = true
        }
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        allstoreTable.reloadData()
        dropDownTbl.reloadData()
        signOutBtn.contentHorizontalAlignment = .left
        
        if (appDelegate.preferredLanguage == "ja-JP"){
            categoriesLabel.text = "カテゴリー"
            allStoresLabel.text = "全店舗一覧"
            signInBtn.setTitle("サインイン", for: .normal)
            signOutBtn.setTitle("ログアウト", for: .normal)
            changeBtn.setTitle("英語に変更", for: .normal)
            dropDownBtn.setTitle(receivedNMNameJPN, for: .normal)
        }
        else {
            categoriesLabel.text = "Categories"
            allStoresLabel.text = "All Stores"
            signInBtn.setTitle("Sign In", for: .normal)
            signOutBtn.setTitle("Sign Out", for: .normal)
            changeBtn.setTitle("Change to Japanese", for: .normal)
            dropDownBtn.setTitle(receivedNMName, for: .normal)
        }
        
        //userImg.setImage(from: appDelegate.pic)
        let url = URL(string: appDelegate.pic)!
        userImg.kf.setImage(with: url)
        userImg.layer.cornerRadius = (userImg.frame.width / 2)
        userImg.layer.masksToBounds = true
        userName.text = appDelegate.fullName
        
        
        //category view
        categoryView.dropShadow()
        screenWidth = UIScreen.main.bounds.width
        screenHeight = UIScreen.main.bounds.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/4, height: screenWidth/8)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        categoryCollection!.collectionViewLayout = layout
        
        allstoreTable.rowHeight = 320
        sideTbl.rowHeight = 70
        
        //search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search stores name"
        definesPresentationContext = true
        
        refStores = Database.database().reference().child("NightMarkets").child(String(self.receivedNMId)).child("nightmarketStores")
        
        refStores.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0{
                self.storeList.removeAll()
                for store in snapshot.children.allObjects as! [DataSnapshot]{
                    let storeObject = store.value as? [String: AnyObject]
                    let storeId = storeObject?["storeId"] as! Int
                    let storeName = storeObject?["storeName"] as! String?
                    let storeNameJPN = storeObject?["storeNameJPN"] as! String?
                    let storeRate = storeObject?["storeRate"] as! Double
                    let storeUrl = storeObject?["storeUrl"] as! String?
                    let storeCategoryId = storeObject?["storeCategoryId"] as! Int
                    let storeLatitude = storeObject?["storeLatitude"] as! Double
                    let storeLongitude = storeObject?["storeLongitude"] as! Double
                    
                    let store = StoreModel(
                        id: storeId, name: storeName, nameJPN: storeNameJPN, url: storeUrl, rate: storeRate, categoryId: storeCategoryId, latitude: storeLatitude, longitude: storeLongitude)
                    
                    self.storeList.append(store)
                }}
            self.allstoreTable.reloadData()
        })
    }
    
    
    //CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageViewArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollection.dequeueReusableCell(withReuseIdentifier: "catCell", for: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        let name = cell.viewWithTag(2) as! UILabel
        imageView.image = imageViewArray[indexPath.row]
        
        if (appDelegate.preferredLanguage == "ja-JP") {
            name.text = nameArrayJPN[indexPath.row]
        } else{
            name.text = nameArray[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "SelectedCategoryViewController") as! SelectedCategoryViewController
        desVC.receivedNMId = self.receivedNMId

        if (appDelegate.preferredLanguage == "ja-JP"){
            desVC.categoryString = nameArrayJPN[indexPath.row]
        } else{
            desVC.categoryString = nameArray[indexPath.row]
        }
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredContent(searchText: self.searchController.searchBar.text!)
    }
    
    func filteredContent(searchText: String)
    {
        self.filteredStores = self.storesArray.filter{ store in
            let storename = store!["storeName"] as? String
            
            return(storename?.lowercased().contains(searchText.lowercased()))!
        }
        allstoreTable.reloadData()
    }
    
    
    //TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if (tableView == self.allstoreTable){
            if searchController.isActive && searchController.searchBar.text != ""{
                count = filteredStores.count
            }
            count = self.storeList.count
        }
            
        else if (tableView == self.dropDownTbl){
            count = self.nmNameArray.count
        }
            
        else{
            count = funArray.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.allstoreTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                     for: indexPath) as! ListTableViewCell
            let store: StoreModel

            store = storeList[indexPath.row]
            
            if (!appDelegate.signIn){
                cell.favBtn.isHidden = true
            }
            cell.favBtn.setImage(UIImage(named: "like_white.png"), for: .normal)
            cell.favBtn.setImage(UIImage(named: "like.png"), for: .selected)
            cell.favBtn.isSelected = false
            
            if (appDelegate.signIn){
                let string = appDelegate.email
                let email = string.replacingOccurrences(of: ".", with: ",")
                
                refUsers = Database.database().reference().child("Users").child(email).child("favorites")
                
                refUsers.observe(.value) { snapshot in
                    for allfavs in snapshot.children.allObjects as! [DataSnapshot]{
                        let allfavs = allfavs.value as? [String: AnyObject]
                        let favId = allfavs?["storeId"] as! Int
                        if (favId == store.id) {
                            cell.favBtn.isSelected = true
                        }
                    }
                }
                
                cell.yourobj = {
                    let key = String(store.id)
                    if (!cell.favBtn.isSelected) {
                        let fav = ["storeId": store.id, "storeName": store.name!, "storeNameJPN": store.nameJPN!,
                                   "storeRate": store.rate, "storeUrl": store.url!, "storeCategoryId": store.categoryId] as[String: Any]
                        self.refUsers.child(key).setValue(fav)
                        cell.favBtn.isSelected = true
                    } else {
                        self.refUsers.child(key).removeValue()
                        cell.favBtn.isSelected = false
                    }
                }
            }
            cell.storeId = store.id
            if (appDelegate.preferredLanguage == "ja-JP"){
                cell.storeName.text = store.nameJPN
            } else {
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
            cell.storeImg.clipsToBounds = true
            cell.storeImg.layer.cornerRadius = 1
            cell.storeRateNum.text = String(store.rate)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        }
            
        else if (tableView == self.dropDownTbl) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "nmcell", for: indexPath) as! dropDownTableViewCell
            if (appDelegate.preferredLanguage == "ja-JP"){
                cell.nmName.text = nmNameArrayJPN[indexPath.row]
            } else {
                cell.nmName.text = nmNameArray[indexPath.row]
            }
            return cell
        }
            
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! menuTableViewCell
            if (appDelegate.preferredLanguage == "ja-JP"){
                cell.functionName.text = funArrayJPN[indexPath.row]
            } else{
                cell.functionName.text = funArray[indexPath.row]
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == self.allstoreTable){
            performSegue(withIdentifier: "showDetailView", sender: indexPath)
        }
        else if (tableView == self.dropDownTbl){
            if (self.appDelegate.preferredLanguage == "ja-JP"){
                dropDownBtn.setTitle(self.nmNameArrayJPN[indexPath.row], for: .normal)
                self.receivedNMNameJPN = self.nmNameArrayJPN[indexPath.row]
            } else {
                dropDownBtn.setTitle(self.nmNameArray[indexPath.row], for: .normal)
                self.receivedNMName = self.nmNameArray[indexPath.row]
            }
            self.receivedNMId = indexPath.row + 1
            animate(toogle: false)
            viewLoadSetup()
        }
        else {
            if indexPath.row == 0{
                let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let desVC = mainStoryboard.instantiateViewController(withIdentifier: "AllReviewsViewController") as! AllReviewsViewController
                self.navigationController?.pushViewController(desVC, animated: true)
            }
            if indexPath.row == 1{
                let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let desVC = mainStoryboard.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
                self.navigationController?.pushViewController(desVC, animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.destination, sender) {
        case (let controller as DetailViewController, let indexPath as NSIndexPath):
            let store: StoreModel
            store = self.storeList[indexPath.row]
            controller.receivedId = store.id
            if (appDelegate.preferredLanguage == "ja-JP") {
                controller.receivedName = store.nameJPN!
            } else {
                controller.receivedName = store.name!
            }
            controller.receivedNMId = self.receivedNMId
            controller.receivedCategoryId = store.categoryId
            controller.receivedRate = store.rate
            controller.receivedUrl = store.url!
            controller.receivedLatitude = store.latitude
            controller.receivedLongitude = store.longitude
            
        default:
            print("unknown segue")
            break
        }
    }
}
