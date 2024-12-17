//
//  DoctorLocationVc.swift
//  Hlthera
//
//  Created by Ahmed Hegazy on 11/12/2022.
//  Copyright © 2022 Fluper. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation


class DoctorLocationVc: UIViewController {
    
    var locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    var hasComeFrom: HasCameFrom = .none
    
    @IBOutlet weak var labelPageTitle: UILabel!
    
    
    var doctorDetailModel: DoctorDetailsModel?
    var searchResultFromSpecialist:DoctorList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        labelPageTitle.font = .corbenRegular(ofSize: 15)
        
        
        self.locationManagerInitialSetup(locationManager: locationManager)
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Authorize.")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            
            print("enabled")
            
            //            print(doctorDetailModel?.lat)
            //            print(doctorDetailModel?.longitude)
            if (checkLatAndLong()!) {
                locationManager.stopUpdatingLocation()
                let coordinate = CLLocationCoordinate2D(latitude: Double.getDouble( doctorDetailModel?.lat), longitude: Double.getDouble( doctorDetailModel?.longitude))
                let region = self.mapView.regionThatFits(MKCoordinateRegion(center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200))
                self.mapView.setRegion(region, animated: true)
            } else {
                locationManager.startUpdatingLocation()
            }
            break
        case .restricted, .denied:
            break
        default: break
        }
    }
    
    func checkLatAndLong() -> Bool? {
        switch hasComeFrom {
        case .home:
            return searchResultFromSpecialist?.lat != "" && searchResultFromSpecialist?.longitude != ""
        default:
            return doctorDetailModel?.lat != "" && doctorDetailModel?.longitude != ""
        }
        return false
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
}
