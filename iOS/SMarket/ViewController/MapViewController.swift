//
//  MapViewController.swift
//  SMarket
//
//  Created by Vanessa on 2019/5/20.
//  Copyright © 2019 Vanessa JC Liang. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class MapViewController: UIViewController {
    
    var receivedId = 0
    var receivedNMId = 0
    var receivedLatitude = 0.0
    var receivedLongitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UIApplication.shared.canOpenURL(NSURL(string:"https://maps.google.com")! as URL))
        {
            UIApplication.shared.openURL(NSURL(string:
                "https://maps.google.com/?q=\(receivedLatitude),\(receivedLongitude)")! as URL)
        }
    }
    
//    override func loadView() {
//
//        let camera = GMSCameraPosition.camera(withLatitude: receivedLatitude , longitude: receivedLongitude , zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        view = mapView
//
//        //Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: receivedLatitude, longitude: receivedLongitude)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
//    }
    
   
}
