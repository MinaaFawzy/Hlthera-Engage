//
//  locationPermissionVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 20/01/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationPermissionVC: UIViewController {
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManagerInitialSetup(locationManager: locationManager)
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Authorize.")
            navigateToHome()
        case .restricted, .denied:
            setCustomLocation()
        default: break
        }
        
    }
    
    func setCustomLocation() {
        let res = kSharedUserDefaults.getAppLocation()
        if res.lat == 0.0 && res.long == 0.0{
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: MyLocationVC.getStoryboardID()) as? MyLocationVC else { return }
            vc.hasCameFrom = .login
            vc.callback = { location in
                kSharedUserDefaults.setAppLocation(location: location)
                kSharedAppDelegate?.moveToHomeScreen()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            kSharedAppDelegate?.moveToHomeScreen()
        }
        
    }
    func navigateToHome(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.stopUpdatingLocation()
        print("enabled")
        kSharedAppDelegate?.moveToHomeScreen()
    }
    
}

extension LocationPermissionVC {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .authorizedAlways , .authorizedWhenInUse:
                navigateToHome()
                break
            case .denied , .restricted:
                setCustomLocation()
                break
            default:
                break
            }
        } else {
        }
        
        //        if #available(iOS 14.0, *) {
        //            switch manager.accuracyAuthorization {
        //            case .fullAccuracy:
        //                break
        //            case .reducedAccuracy:
        //                break
        //            default:
        //                break
        //            }
        //        } else {
        //            // Fallback on earlier versions
        //        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch(status) {
        case .authorizedAlways, .authorizedWhenInUse:
            navigateToHome()
        case .restricted, .denied:
            setCustomLocation()
        default:break
        }
    }
    
    
}
