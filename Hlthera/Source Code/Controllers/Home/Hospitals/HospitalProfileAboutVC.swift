//
//  HospitalProfileAboutVC.swift
//  Hlthera
//
//  Created by Prashant on 06/01/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

var height = 1300.0

class HospitalProfileAboutVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak private var tableViewDoctors: UITableView!
    @IBOutlet weak private var tableViewRatings: UITableView!
    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var labelHospitalName: UILabel!
    @IBOutlet weak private var labelHospitalAddress: UILabel!
    @IBOutlet weak private var labelOpeningTime: UILabel!
    @IBOutlet weak private var viewMap: GMSMapView!
    @IBOutlet weak private var backgroundView: UIView!
    @IBOutlet weak private var constraintTableViewRatingHeight: NSLayoutConstraint!
    @IBOutlet weak private var constraintTableViewDoctorsHeight: NSLayoutConstraint!
    @IBOutlet weak var aboutHospitalLable: UILabel!
    
    // MARK: - Stored properties
    var data: HospitalDetailModel?
    var searchedDoctorResult = [DoctorDetailsModel]()
    var searching = false
    var latitude = 19.0760
    var longitude = 72.8777
    var locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    var currentLocation = ""
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.latitude = Double.getDouble(data?.lat)
        self.longitude = Double.getDouble(data?.long)
        self.labelHospitalName.text = data?.hospital_name
        self.labelHospitalAddress.text = data?.address
        self.aboutHospitalLable.text = data?.about_hospital_1
        searchBar.delegate = self
        let searchView = self.searchBar
        searchView?.layer.cornerRadius = 25
        searchView?.clipsToBounds = true
        searchView?.borderWidth = 0
        searchView?.setSearchIcon(image: #imageLiteral(resourceName: "search_black"))
        searchView?.searchTextPositionAdjustment = UIOffset(horizontal: 15, vertical: 0)
        searchView?.backgroundImage = UIImage()
        let searchField = self.searchBar.searchTextField
        searchField.backgroundColor = .white
        searchField.font = UIFont(name: "Helvetica", size: 13)
        searchField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        searchField.addDoneOnKeyboardWithTarget(self, action: #selector(self.doneAction(_:)), shouldShowPlaceholder: false)
        self.locationManagerInitialSetup(locationManager: locationManager)
        //let mapView = GMSMapView.map(withFrame: self.viewMap.frame, camera: camera)
        let camera = GMSCameraPosition.camera(withLatitude: latitude,
                                              longitude: longitude,
                                              zoom: 15)
        viewMap.camera = camera
        viewMap.settings.myLocationButton = false
        viewMap.isMyLocationEnabled = true
        viewMap.isHidden = false
        viewMap.isUserInteractionEnabled = false
        viewMap.settings.zoomGestures = true
        viewMap.delegate = self
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = "Service Location".localize
        //marker.snippet = ""
        marker.map = viewMap
        placesClient = GMSPlacesClient.shared()
        viewMap.clipsToBounds = true
        viewMap.cornerRadius = 10
        viewMap.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    @objc func doneAction(_ sender : UITextField!) {
        self.view.endEditing(true)
    }
    
    func returnPostionOfMapView(mapView:GMSMapView){
        let geocoder = GMSGeocoder()
        let latitute = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let position = CLLocationCoordinate2DMake(latitute, longitude)
        let marker = GMSMarker()
        marker.position = position
        marker.title = "Selected Location".localize
        marker.snippet = "Drag map to change location".localize
        marker.icon = #imageLiteral(resourceName: "location_map")
        marker.isDraggable = false
        marker.map = viewMap
        geocoder.reverseGeocodeCoordinate(position) { response , error in
            if error != nil {
                print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            } else {
                let result = response?.results()?.first
                self.currentLocation = String(result?.lines?[0] ?? "")
                self.latitude = position.latitude
                self.longitude = position.longitude
            }
        }
        
    }
    
    // MARK: - Actions
    @IBAction func buttonMoreDoctorsTapped(_ sender: UIButton) {
    }
    //    @IBAction func buttonReportProblemTapped(_ sender: Any) {
    //        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: ReportProblemVC.getStoryboardID()) as? ReportProblemVC else { return }
    //        vc.doctorId = String.getString(data?.hospital_id) == "" ? String.getString(data?.id) : String.getString(data?.hospital_id)
    //        vc.hasCameFrom = .hospitals
    //        self.navigationController?.pushViewController(vc, animated: true)
    //    }
}

extension HospitalProfileAboutVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewDoctors {
            if searching {
                return tableView.numberOfRow(numberofRow: self.searchedDoctorResult.count, message: "No Doctors Found associated with this Hospital".localize)
            } else {
                // constraintTableViewDoctorsHeight.constant =  CGFloat(Int.getInt(self.data?.doctorBasicInfo?.count) * 185) + 115
                //height = Double(800 + (CGFloat(Int.getInt(self.data?.doctorBasicInfo?.count) * 185) + 115))
                return tableView.numberOfRow(numberofRow: self.data?.doctorBasicInfo?.count, message: "No Doctors Found associated with this Hospital".localize)
            }
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewDoctors{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchDoctorListingTVC", for: indexPath) as! SearchDoctorListingTVC
            cell.selectionStyle = .none
            var obj = data?.doctorBasicInfo?[indexPath.row]
            if searching {
                obj = searchedDoctorResult[indexPath.row]
            } else {
                obj = data?.doctorBasicInfo?[indexPath.row]
            }
            cell.labelDoctorName.text = String.getString(obj?.doctor_name)
            if obj?.doctor_specialities.count > 0 {
                cell.labelDoctorSpecialization.text = String.getString(obj?.doctor_specialities[0].full_name)
            }
            cell.labelExperience.text = Int.getInt(obj?.doctor_exp) <= 0 ? ("No Experience Found".localize) : (Int.getInt(obj?.doctor_exp) < 2 ? ("\(Int.getInt(obj?.doctor_exp))" + "Year".localize) : ("\(Int.getInt(obj?.doctor_exp))" + "Years".localize))
            cell.imageDoctor.downlodeImage(serviceurl:  String.getString(obj?.doctor_profile), placeHolder: UIImage(named: "placeholder"))
            cell.buttonHeart.isSelected = (obj?.isLike == 1) ? true : false
            cell.heartTapped = { value in
                self.favoriteApi(isLike: !cell.buttonHeart.isSelected, type: .doctors, id: Int.getInt(obj?.doctor_id))
            }
            cell.callback = {
                guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: ViewDoctorProfileVC.getStoryboardID()) as? ViewDoctorProfileVC else { return }
                vc.searchResult = obj
                UserData.shared.hospital_id = self.data?.hospital_id
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutRatingTVC", for: indexPath) as! AboutRatingTVC
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension HospitalProfileAboutVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchedDoctorResult = data?.doctorBasicInfo?.filter({
            $0.doctor_name.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.doctor_specialities.contains(where: {$0.full_name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        }) ?? searchedDoctorResult
        
        
        
        //        searchedResult = searchResults.filter{
        //            $0.doctor_specialities.contains(where: {$0.full_name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        //        }
        //$0.lowercased().prefix(searchText.count) == searchText.lowercased()
        searching = true
        tableViewDoctors.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableViewDoctors.reloadData()
    }
}

extension HospitalProfileAboutVC: GMSMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        let location:CLLocation = locations.last!
        //        latitude  = location.coordinate.latitude
        //        longitude = location.coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: self.latitude, longitude: self.longitude, zoom: 15)
        if viewMap.isHidden {
            viewMap.isHidden = false
            self.viewMap.camera = camera
        } else {
            viewMap.animate(to: camera)
        }
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        marker.title = "Hospital Location".localize
        //marker.snippet = "Drag map to change location"
        marker.icon = #imageLiteral(resourceName: "location_map")
        marker.isDraggable = false
        marker.map = viewMap
        placesClient = GMSPlacesClient.shared()
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print(mapView.center)
        mapView.clear()
        returnPostionOfMapView(mapView: mapView)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        mapView.clear()
        returnPostionOfMapView(mapView: mapView)
    }
}

extension HospitalProfileAboutVC {
    func favoriteApi(isLike: Bool, type: HasCameFrom, id: Int) {
        
        var params:[String : Any] = [:]
        
        var serviceUrl = ServiceName.doLike
        if !isLike{
            serviceUrl = ServiceName.doLike
            params = [ApiParameters.kLike:"1",
                      ApiParameters.kType:type == HasCameFrom.doctors ? "doctor" : "hospital",
                      ApiParameters.kTargetId:String.getString(id)]
        }
        else {
            serviceUrl = ServiceName.doUnlike
            params = [ApiParameters.kUnlike:"1",
                      ApiParameters.kType:type == HasCameFrom.doctors ? "doctor" : "hospital",
                      ApiParameters.kTargetId:String.getString(id)]
        }
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:serviceUrl,
                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: true)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    //if Int.getInt(dictResult["status"]) != 0{
                    self?.searching = false
                    self?.searchBar.text = ""
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    self?.data?.doctorBasicInfo?.map{
                        if $0.doctor_id == String.getString(id){
                            $0.isLike = isLike ? 0 : 1
                        }
                    }
                    self?.tableViewDoctors.reloadData()
                    //  }
                    print("done")
                default:
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToast(message: kNoInternetMsg)
                
            } else {
                CommonUtils.showToast(message: kDefaultErrorMsg)
            }
        }
    }
}


extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
