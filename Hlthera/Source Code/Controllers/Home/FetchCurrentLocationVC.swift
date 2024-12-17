//
//  FetchCurrentLocationVC.swift
//  Hlthera
//
//  Created by Prashant on 08/01/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class FetchCurrentLocationVC: UIViewController {
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var labelPageTitle: UILabel!
    var latitude = 19.0760
    var longitude = 72.8777
    var locationManager = CLLocationManager()
    var currentLocation = ""
    var callback:((SavedLocationsModel)->())?
    var pageTitle = "Current Location".localize
    
    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.font = .corbenRegular(ofSize: 15)
        self.locationManagerInitialSetup(locationManager: locationManager)
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        let camera = GMSCameraPosition.camera(withLatitude: latitude,
                                              longitude: longitude,
                                              zoom: 15)
        viewMap.camera = camera
        viewMap.settings.myLocationButton = false
        viewMap.isMyLocationEnabled = true
        viewMap.isHidden = false
        viewMap.isUserInteractionEnabled = true
        viewMap.settings.zoomGestures = true
        viewMap.delegate = self
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = "Default Location".localize
        marker.snippet = "Drag to change".localize
        marker.map = viewMap
        viewMap.clipsToBounds = true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func returnPostionOfMapView(mapView:GMSMapView){
        mapView.clear()
        let geocoder = GMSGeocoder()
        let latitute = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let position = CLLocationCoordinate2DMake(latitute, longitude)
        let marker = GMSMarker()
        marker.position = position
        marker.title = "Selected Location".localize
        marker.snippet = "Drag map to change location".localize
        marker.icon = #imageLiteral(resourceName: "map_pin_sm")
        marker.isDraggable = false
        marker.map = viewMap
        geocoder.reverseGeocodeCoordinate(position) { response , error in
            if error != nil {
                print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            }else {
                let result = response?.results()?.first
               // " \) > \) \(result?.locality == nil ? "" : " > ") "
//                "\(String.getString(result?.subLocality))\(result?.subLocality == nil ? "" : ", ") \(String.getString(result?.thoroughfare))"
//
                self.currentLocation = "\(String.getString(result?.locality)), \(String.getString(result?.country))"
                
                    //String(result?.lines?[0] ?? "")
                self.latitude = position.latitude
                self.longitude = position.longitude
            }
        }
        
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonConfirmTapped(_ sender: Any) {
        callback?(SavedLocationsModel(lat:self.latitude, long: self.longitude, name: currentLocation))
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonMyLocationTapped(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    


}
extension FetchCurrentLocationVC:GMSMapViewDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.latitude = manager.location?.coordinate.latitude ?? self.latitude
        self.longitude = manager.location?.coordinate.longitude ?? self.longitude
            let camera = GMSCameraPosition.camera(withLatitude: self.latitude, longitude: self.longitude, zoom: 15)
            if self.viewMap.isHidden {
                self.viewMap.isHidden = false
                self.viewMap.camera = camera
            } else {
                self.viewMap.animate(to: camera)
            }
        self.viewMap.clear()
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        marker.title = "Selected Location".localize
        marker.snippet = "Drag map to change location".localize
            marker.icon = #imageLiteral(resourceName: "map_pin_sm")
            marker.isDraggable = false
            marker.map = self.viewMap
            //self.placesClient = GMSPlacesClient.shared()
        manager.stopUpdatingLocation()
       
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print(mapView.center)
       
        returnPostionOfMapView(mapView: mapView)
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        returnPostionOfMapView(mapView: mapView)
    }
}
