//
//  AppDelegate.swift
//  nightMarket
//
//  Created by Vanessa on 2019/3/14.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{
    
    var window: UIWindow?
    
    var pic = ""
    var fullName = ""
    var email = ""
    var signIn = false
    var preferredLanguage = ""
    var nightMarketId = 0
    var nightMarketName = ""
    
    //@objc var currentUnityController: UnityAppController!
    
    var application: UIApplication?
    
    var isUnityRunning = false
    
    let googleApiKey = "AIzaSyAMi8wUMFsZE2POw1ooeK5AAHnvd551tBM"

    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize sign-in
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = "794275713239-mh1ae7j555m88m30i4m04pcv9g2a5cjv.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        //UnityViewController.shared.configure(with: application, options: launchOptions)
       
        GMSServices.provideAPIKey(googleApiKey)
        GMSPlacesClient.provideAPIKey(googleApiKey)
        
        self.application = application
        //unity_init(CommandLine.argc, CommandLine.unsafeArgv)

        //currentUnityController = UnityAppController()
        //currentUnityController.application(application, didFinishLaunchingWithOptions: launchOptions)

        // first call to startUnity will do some init stuff, so just call it here and directly stop it again
        //startUnity()
        //stopUnity()
        
        return true
    }
    
//    func applicationWillResignActive(_ application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//
//        if isUnityRunning {
//            currentUnityController.applicationWillResignActive(application)
//        }
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//
//        if isUnityRunning {
//            currentUnityController.applicationDidEnterBackground(application)
//        }
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//
//        if isUnityRunning {
//            currentUnityController.applicationWillEnterForeground(application)
//        }
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//
//        if isUnityRunning {
//            currentUnityController.applicationDidBecomeActive(application)
//        }
//    }
//
//    func applicationWillTerminate(_ application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//
//        if isUnityRunning {
//            currentUnityController.applicationWillTerminate(application)
//        }
//    }
//
//    func startUnity() {
//        if !isUnityRunning {
//            isUnityRunning = true
//            currentUnityController.applicationDidBecomeActive(application!)
//        }
//    }
//
//    func stopUnity() {
//        if isUnityRunning {
//            currentUnityController.applicationWillResignActive(application!)
//            isUnityRunning = false
//
//        }
//    }
    
    

    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            self.signIn = true
            fullName = user.profile.name
            email = user.profile.email
            if user.profile.hasImage
            {
                pic = (user.profile.imageURL(withDimension: 100)?.absoluteString)!
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabbarVC = storyboard.instantiateViewController(withIdentifier: "TabbarIdentifier") as! UITabBarController
            self.window?.rootViewController?.present(tabbarVC, animated: true, completion: nil)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    
}

