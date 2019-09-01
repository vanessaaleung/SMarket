//
//  SignInViewController.swift
//  nightMarket
//
//  Created by Vanessa on 2019/3/18.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class SignInViewController: UIViewController, GIDSignInUIDelegate {
    @IBOutlet weak var directBtn: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    var window: UIWindow?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var signInBtn: GIDSignInButton!

    @IBAction func directTapped(_ sender: Any) {
        appDelegate.fullName = "Guest"
        appDelegate.pic = "https://mnsearch.org/wp-content/uploads/2014/10/blank-2017.jpg"
        appDelegate.signIn = false
//        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
//        //desVC.viewLoadSetup()
//        self.navigationController?.pushViewController(desVC, animated: true)
        //self.window?.rootViewController?.present(desVC, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewLoadSetup()
    }
    
    func viewLoadSetup(){
        appDelegate.preferredLanguage = NSLocale.preferredLanguages[0]
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        if (appDelegate.preferredLanguage == "ja-JP"){
            directBtn.setTitle("直接使用する", for: .normal)
            warningLabel.text = "サインインせずにレビューを書くことはできません"
        } else {
            directBtn.setTitle("Use Directly", for: .normal)
            warningLabel.text = "You can't write reviews without signing in"
        }
    }
    
}
