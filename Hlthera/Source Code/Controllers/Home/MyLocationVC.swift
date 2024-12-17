//
//  MyLocationVC.swift
//  Hlthera
//
//  Created by Prashant on 08/01/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation

class MyLocationVC: UIViewController {
    
    @IBOutlet weak var buttonSearchLocation: UIButton!
    @IBOutlet weak var buttonCurrentLocation: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var locations: [SavedLocationsModel] = []
    var searching = false
    var searchedLocations:[SavedLocationsModel] = []
    var callback:((SavedLocationsModel)->())?
    var selectedLocation = ""
    var latitude = 19.0760
    var longitude = 72.8777
    var placesClient: GMSPlacesClient!
    var likelyPlaces:[GMSPlace] = []
    var selectedPlace:GMSPlace?
    var hasCameFrom:HasCameFrom?
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.font = .corbenRegular(ofSize: 15)
        
        self.locationManagerInitialSetup(locationManager: locationManager)
        //searchBar.setImage(UIImage(), for: .search, state: .normal)
        tableView.tableFooterView = UIView()
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        self.locations = kSharedUserDefaults.getSavedSuggestions()
        //        let searchView = self.searchBar
        //        searchView?.layer.cornerRadius = 25
        //        searchView?.clipsToBounds = true
        //        searchView?.borderWidth = 0
        //        searchView?.setSearchIcon(image: UIImage())
        //        searchView?.searchTextPositionAdjustment = UIOffset(horizontal: -10, vertical: 0)
        //        searchView?.backgroundImage = UIImage()
        //        let searchField = self.searchBar.searchTextField
        //        searchField.backgroundColor = .white
        //        searchField.font = UIFont(name: "Helvetica", size: 13)
        //        searchField.textColor = #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1)
        //        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    func showPermissionAlert(){
        let alertController = UIAlertController(title: kAppName, message: "Please enable location permissions to continue using this app".localize, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings".localize, style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel".localize, style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func fetchLocation() {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: FetchCurrentLocationVC.getStoryboardID()) as? FetchCurrentLocationVC else { return }
        vc.callback = { currentLocation in
            self.selectedLocation = currentLocation.name
            self.latitude = currentLocation.lat
            self.longitude = currentLocation.long
            self.buttonSearchLocation.setTitle(currentLocation.name, for: .normal)
            self.buttonSearchLocation.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        switch hasCameFrom{
        case .login:
            kSharedAppDelegate?.logout()
        case .home:
            self.navigationController?.popViewController(animated: true)
        default:break;
        }
        
    }
    
    @IBAction func buttonConfirmedTapped(_ sender: Any) {
        
        if selectedLocation.isEmpty{
            CommonUtils.showToast(message: "Please Select Location".localize)
            return
        }
        else {
            callback?(SavedLocationsModel(lat: self.latitude, long: self.longitude, name:self.selectedLocation))
            self.navigationController?.popViewController(animated: true)
            
        }

    }
    
    @IBAction func buttonMyLocationTapped(_ sender: Any) {
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            fetchLocation()
        case .restricted, .denied:
            showPermissionAlert()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        default: break
        }
    }
    
    @IBAction func buttonSearchLocationTapped(_ sender: Any) {
        searchPlaces()
    }
    
}

extension MyLocationVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return searchedLocations.count
        } else {
            return tableView.numberOfRow(numberofRow: locations.count, message: "No Suggestions Found, Please checkback later".localize)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportProblemTVC", for: indexPath) as! ReportProblemTVC
        if searching{
            cell.labelProblemName.text = searchedLocations[indexPath.row].name
            if selectedLocation == searchedLocations[indexPath.row].name{
                cell.buttonSelection.isSelected = true
            } else {
                cell.buttonSelection.isSelected = false
            }
        } else {
            cell.labelProblemName.text = locations[indexPath.row].name
            if selectedLocation == locations[indexPath.row].name{
                cell.buttonSelection.isSelected = true
            } else {
                cell.buttonSelection.isSelected = false
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.buttonSearchLocation.setTitleColor(UIColor.lightGray, for: .normal)
        self.selectedLocation = locations[indexPath.row].name
        self.latitude = locations[indexPath.row].lat
        self.longitude = locations[indexPath.row].long
        if searching{
            let loc = searchedLocations[indexPath.row]
            self.selectedLocation = loc.name
            self.latitude = loc.lat
            self.longitude = loc.long
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension MyLocationVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedLocations = locations.filter({
            $0.name.lowercased().prefix(searchText.count) == searchText.lowercased()
        })

        //        searchedResult = searchResults.filter{
        //            $0.doctor_specialities.contains(where: {$0.full_name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        //        }
        //$0.lowercased().prefix(searchText.count) == searchText.lowercased()
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
}

extension MyLocationVC: GMSAutocompleteViewControllerDelegate {
    func searchPlaces() {
        //Google Places
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let fields: GMSPlaceField =
        GMSPlaceField(rawValue:UInt(GMSPlaceField.name.rawValue) |
                      UInt(GMSPlaceField.placeID.rawValue) |
                      UInt(GMSPlaceField.coordinate.rawValue) |
                      GMSPlaceField.addressComponents.rawValue |
                      GMSPlaceField.formattedAddress.rawValue)!
        autocompleteController.placeFields = fields
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
        
    }
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: true){
            self.selectedLocation = String.getString(place.name)
            
            self.buttonSearchLocation.setTitle(self.selectedLocation, for: .normal)
            self.buttonSearchLocation.setTitleColor(#colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.5019607843, alpha: 1), for: .normal)
            self.latitude = Double.getDouble(place.coordinate.latitude)
            self.longitude = Double.getDouble(place.coordinate.longitude)
            
            if self.locations.count <= 12{
                self.locations.append(SavedLocationsModel(lat: Double.getDouble(place.coordinate.latitude), long: Double.getDouble(place.coordinate.longitude), name: self.selectedLocation))
            }
            else {
                self.locations = []
                self.locations.append(SavedLocationsModel(lat: Double.getDouble(place.coordinate.latitude), long: Double.getDouble(place.coordinate.longitude), name: self.selectedLocation))
            }
            // self.tableView.reloadData()
            
            kSharedUserDefaults.updateSavedSuggestions(suggestions: self.locations)
            //self.buttonSearchMarina.tag = 1
            //self.searchMarinaApi(lat:Double.getDouble(place.coordinate.latitude),long:Double.getDouble(place.coordinate.longitude),listing: false)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension MyLocationVC {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .authorizedAlways , .authorizedWhenInUse:
                //fetchLocation()
                break
            default:
                break
            }
        } else {
            print("hello")
            // Fallback on earlier versions
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(currentLocation.latitude) \(currentLocation.longitude)")
        manager.stopUpdatingLocation()
    }
    
}
