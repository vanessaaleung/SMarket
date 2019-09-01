//
//  MarketViewController.swift
//  SMarket
//
//  Created by Vanessa on 2019/5/3.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import UIKit

class MarketViewController: UIViewController {
    @IBOutlet weak var ningxiaBtn: UIButton!
    @IBOutlet weak var shilinBtn: UIButton!
    @IBOutlet weak var tonghuaBtn: UIButton!
    @IBOutlet weak var gongguanBtn: UIButton!
    @IBOutlet weak var njcBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var nightMarketId = 0
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        if appDelegate.preferredLanguage == "ja-JP"{
            titleLabel.text = "ナイトマーケットを選ぶ探索する"
            shilinBtn.setTitle("士林観光夜市", for: .normal)
            tonghuaBtn.setTitle("臨江観光夜市", for: .normal)
            gongguanBtn.setTitle("南機場観光夜市", for: .normal)
            njcBtn.setTitle("饒河観光夜市", for: .normal)
            ningxiaBtn.setTitle("寧夏観光夜市", for: .normal)
        } else {
            titleLabel.text = "Choose a Night Market to explore"
            shilinBtn.setTitle("Shi Lin", for: .normal)
            tonghuaBtn.setTitle("Lin Jiang", for: .normal)
            gongguanBtn.setTitle("Nan Ji Chang", for: .normal)
            njcBtn.setTitle("Rao He", for: .normal)
            ningxiaBtn.setTitle("Ning Xia", for: .normal)
        }
    }
    
    @IBAction func nxTapped(_ sender: Any) {
        self.nightMarketId = 2
        appDelegate.nightMarketId = 2
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        desVC.receivedNMId = 2
        desVC.receivedNMNameJPN = "寧夏観光夜市"
        desVC.receivedNMName = "Ning Xia Night Market"
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    @IBAction func slTapped(_ sender: Any) {
        self.nightMarketId = 1
        appDelegate.nightMarketId = 1
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        desVC.receivedNMId = 1
        desVC.receivedNMNameJPN = "士林観光夜市"
        desVC.receivedNMName = "Shi Lin Night Market"
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    @IBAction func thTapped(_ sender: Any) {
        self.nightMarketId = 3
        appDelegate.nightMarketId = 3
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        desVC.receivedNMId = 3
        desVC.receivedNMNameJPN = "臨江観光夜市"
        desVC.receivedNMName = "Lin Jiang Night Market"
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    @IBAction func ggTapped(_ sender: Any) {
        self.nightMarketId = 5
        appDelegate.nightMarketId = 5
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        desVC.receivedNMId = 5
        desVC.receivedNMNameJPN = "南機場観光夜市"
        desVC.receivedNMName = "Nan Ji Chang"
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    @IBAction func njcTapped(_ sender: Any) {
        self.nightMarketId = 4
        appDelegate.nightMarketId = 4
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        desVC.receivedNMId = 4
        desVC.receivedNMNameJPN = "饒河観光夜市"
        desVC.receivedNMName = "Rao He Night Market"
        self.navigationController?.pushViewController(desVC, animated: true)
    }
}
