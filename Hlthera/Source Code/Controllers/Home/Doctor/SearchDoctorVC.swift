//
//  SearchDoctorVC.swift
//  Hlthera
//
//  Created by Prashant on 23/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import DropDown
import GooglePlaces
import Alamofire

class SearchDoctorVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var buttonSpecialities: UIButton!
    @IBOutlet weak private var lblTitle: UILabel!
    @IBOutlet weak private var buttonGender: UIButton!
    @IBOutlet weak private var buttonLocation: UIButton!
    @IBOutlet weak private var buttonAvailibility: UIButton!
    @IBOutlet weak private var tfInsuranceCompany: UITextField!
    
    // MARK: - Stored Properties
    var categories: [FeaturedSpecialty]? = []
    var specialities: [SpecialitiesModel] = []
    var selectedSpecialityID:Int = -1
    var dropDown = DropDown()
    var quickSearch: [String: Any] = [:]
    var insuranceCompany = [InsuranceCompanyModel]()
    //    var quickSearchNames:[String] = ["Homeopathy","Psychiatry","General Practitioner","Dentistry","Dermatology","Obstetrics and Gynaecology"]
    //    var quickSearchIcons:[UIImage] = [UIImage(named: "homeopathy") ?? UIImage(),UIImage(named: "psychiatry-1") ?? UIImage(),UIImage(named: "general") ?? UIImage(),UIImage(named: "dentistry") ?? UIImage(),UIImage(named: "dermatology-1") ?? UIImage(),UIImage(named: "obstetrics") ?? UIImage()]
    //    var quickSearchNames:[String] = ["Eye specialist","Diabetes","Dentist","Kidney","Lungs","Cancer"]
    //    var quickSearchIcons:[UIImage] = [UIImage(named: "eye_specialist") ?? UIImage(),UIImage(named: "diabetes") ?? UIImage(),UIImage(named: "dentist") ?? UIImage(),UIImage(named: "kidney") ?? UIImage(),UIImage(named: "lungs") ?? UIImage(),UIImage(named: "cancer") ?? UIImage()]
    var quickSearchIds: [String] = Array(repeating: "0", count: 6)
    var selectedGender: Int = -1
    var selectedLocation = ""
    var latitude = 0.0
    var longitude = 0.0
    var placesClient: GMSPlacesClient!
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    var quickOptions: [QuickOptionsModel] = []
    let datePickerView: UIDatePicker = UIDatePicker()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupStatusBar()
//        lblTitle.font = .corbenRegular(ofSize: 15)
        getSpecialitiesApi()
        //homeTopSliderBanners()
        getFeaturedSpecialities()
        insuranceCompanyApi()
        setupDatePicker()
        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        setupSearchBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .darkContent
//    }
//    
    func setupSearchBar() {
        let searchView = self.searchBar
        searchView?.layer.cornerRadius = 25
        searchView?.clipsToBounds = true
        searchView?.borderWidth = 0
        searchView?.setSearchIcon(image: #imageLiteral(resourceName: "search-1"))
        searchView?.searchTextPositionAdjustment = UIOffset(horizontal: 15, vertical: 0)
        searchView?.backgroundImage = UIImage()
        let searchField = self.searchBar.searchTextField
        searchField.backgroundColor = UIColor().hexStringToUIColor(hex: "#F5F7F9")
        searchField.font = UIFont(name: "Helvetica", size: 13)
        searchField.textColor = UIColor().hexStringToUIColor(hex: "#212529")
        searchField.attributedPlaceholder = NSAttributedString(string: searchField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "#8794AA")])
        if let leftView = searchField.leftView as? UIImageView {
            leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
            leftView.tintColor = UIColor(hexString: "#8794AA")
        }
        searchField.addDoneOnKeyboardWithTarget(self, action: #selector(self.doneAction(_:)), shouldShowPlaceholder: false)
    }
    
    func setupDatePicker() {
        if #available(iOS 13.4, *) {
            datePickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerView.preferredDatePickerStyle = .wheels
            datePickerView.preferredDatePickerStyle = .wheels
        }
        self.datePickerView.datePickerMode = .date
        let currentDate = Date()
        var dateComponents = DateComponents()
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = -100
        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
        dateComponents.year = 10
        let maxDate = calendar.date(byAdding: dateComponents, to: currentDate)
        datePickerView.maximumDate = maxDate
        datePickerView.minimumDate = minDate
    }
    
    // MARK: - Function for Date Of Birth
    func getToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let myColor : UIColor = UIColor( red: 2/255, green: 14/255, blue:70/255, alpha: 1.0 )
        toolBar.tintColor = myColor
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done".localize, style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localize, style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    
}

// MARK: - Actions
extension SearchDoctorVC {
    @objc func doneClick(for: Int) {
        self.view.endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        //            self.DobTF.text = dateFormatter.string(from: self.datePickerView.date)
        //            self.selectedDate = self.datePickerView.date
        
    }
    
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
    
    @objc func doneAction(_ sender : UITextField!) {
        self.view.endEditing(true)
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSpecialitesTapped(_ sender: UIButton) {
        dropDown.anchorView = sender
        dropDown.dataSource = self.specialities.map{String.getString($0.full_name)}
        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
            self.buttonSpecialities.setTitle(item, for: .normal)
//            self.buttonSpecialities.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.buttonSpecialities.setTitleColor(UIColor().hexStringToUIColor(hex: "#212529"), for: .normal)
            self.selectedSpecialityID = Int.getInt(specialities[index].id)
            self.buttonSpecialities.tag = 1
        }
        dropDown.width = self.buttonSpecialities.frame.width
        dropDown.show()
    }
    
    @IBAction func buttonLocationTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: MyLocationVC.getStoryboardID()) as? MyLocationVC else { return }
        vc.hasCameFrom = .home
        vc.callback = { currentLocation in
            
            self.buttonLocation.setTitle(currentLocation.name, for: .normal)
            self.buttonLocation.setTitleColor(UIColor().hexStringToUIColor(hex: "#212529"), for: .normal)
//            self.buttonLocation.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.latitude = currentLocation.lat
            self.longitude = currentLocation.long
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonAvailibilityTapped(_ sender: UIButton) {
        
        dropDown.anchorView = sender
        dropDown.dataSource = self.insuranceCompany.map{String.getString($0.name)}
        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
            self.tfInsuranceCompany.text = item
            self.tfInsuranceCompany.textColor = UIColor().hexStringToUIColor(hex: "#212529")
        }
        dropDown.width = self.tfInsuranceCompany.frame.width
        dropDown.show()
        
    }

    @IBAction func buttonGenderTapped(_ sender: UIButton) {
        dropDown.anchorView = sender
        dropDown.dataSource = ["Male".localize,"Female".localize]
        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
            sender.setTitle(item, for: .normal)
            sender.setTitleColor(UIColor().hexStringToUIColor(hex: "#212529"), for: .normal)
//            sender.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.selectedGender = item == "Male" ? 0 : 1
        }
        dropDown.width = self.buttonSpecialities.frame.width
        dropDown.show()
    }
    
    @IBAction func buttonSearchTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: SearchDoctorListingVC.getStoryboardID()) as? SearchDoctorListingVC else { return }
        //vc.hasCameFrom = .doctors
        vc.hasCameFrom = .searchDoctor
        vc.isQuickSearch = false
        vc.specialityID = selectedSpecialityID
        vc.gender = selectedGender
        vc.lat = self.latitude
        vc.long = self.longitude
        vc.searchText = String.getString(self.searchBar.text)
        //if !String.getString(searchBar.text).isEmpty{
        //if buttonSpecialities.tag == 0 {
        //CommonUtils.showToast(message: "Please Select Specialization")
        //return
        //}
        //else {
        //self.navigationController?.pushViewController(vc, animated: true)
        //return
        //}
        //}
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchDoctorVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return collectionView.numberOfRow(numberofRow: quickOptions.count)
        return collectionView.numberOfRow(numberofRow: categories?.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchDoctorCVC", for: indexPath) as! SearchDoctorCVC
        cell.clipsToBounds = false
        cell.layer.masksToBounds = false
        //        let obj = quickOptions[indexPath.row]
        // cell.labelName.text = obj.quick_option
        // cell.imageLogo.downlodeImage(serviceurl: obj.quick_icon, placeHolder: #imageLiteral(resourceName: "placeholder-1"))
        
        let obj = self.categories![indexPath.row]
        cell.labelName.text = obj.name?.localize
        cell.imageLogo.downlodeImage(serviceurl: obj.imagePath!, placeHolder: #imageLiteral(resourceName: "placeholder-1"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width/2.10, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: SearchDoctorListingVC.getStoryboardID()) as? SearchDoctorListingVC else { return }
        vc.isQuickSearch = true
        vc.quickSearchId = Int.getInt(categories?[indexPath.row].id)
        vc.hasCameFrom = .searchDoctor
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchDoctorVC {
    func getSpecialitiesApi() {
        CommonUtils.showHudWithNoInteraction(show: false)
        let params:[String:Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.specialities,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    self.quickOptions = kSharedInstance.getArray(dictResult["quick_options"]).map{ QuickOptionsModel(data: kSharedInstance.getDictionary($0)) }
                    //self.quickSearchIds[0] = String.getString(quickSearchResult["Homeopathy"])
                    //self.quickSearchIds[1] = String.getString(quickSearchResult["Psychiatry"])
                    //self.quickSearchIds[2] = String.getString(quickSearchResult["General_Practitioner"])
                    //self.quickSearchIds[3] = String.getString(quickSearchResult["Dentistry"])
                    //self.quickSearchIds[4] = String.getString(quickSearchResult["Dermatology"])
                    //self.quickSearchIds[5] = String.getString(quickSearchResult["Obstetrics_and_Gynaecology"])
                    let result = kSharedInstance.getDictionaryArray(withDictionary: dictResult["result"])
                    self.specialities = result.map{ SpecialitiesModel(data:$0) }
                    self.collectionView.reloadData()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
}

extension SearchDoctorVC: GMSAutocompleteViewControllerDelegate {
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
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
        
    }
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "")")
        print("Place ID: \(place.placeID)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: true){
            self.selectedLocation = String.getString(place.name)
            self.buttonLocation.setTitle(self.selectedLocation, for: .normal)
            self.buttonLocation.setTitleColor(UIColor().hexStringToUIColor(hex: "#212529"), for: .normal)
//            self.buttonLocation.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.latitude = Double.getDouble(place.coordinate.latitude)
            self.longitude = Double.getDouble(place.coordinate.longitude)
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

extension SearchDoctorVC {
    func homeTopSliderBanners() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.sliderTopBanners,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    //let banners =  (dictResult as NSDictionary).value(forKeyPath: "data.banners")
                    //var jsonObj = JSON(banners)
                    //jsonObj.arrayValue.forEach({ json in
                    //let bannerItem =  BannerHomeItem()
                    //bannerItem.created_at = json["created_at"].stringValue
                    //bannerItem.ad_purpose = json["ad_purpose"].stringValue
                    //bannerItem.status = json["status"].intValue.toString()
                    //bannerItem.name = json["name"].stringValue
                    //bannerItem.id = json["id"].intValue.toString()
                    //bannerItem.ad_from = json["ad_from"].stringValue
                    //bannerItem.ad_to = json["ad_to"].stringValue
                    //bannerItem.service_id = json["service_id"].intValue.toString()
                    //bannerItem.updated_at = json["updated_at"].stringValue
                    //bannerItem.image = json["image"].stringValue
                    //self.sliderTopHomeBanners.append(bannerItem)
                    //})
                    
                    var model: BannerHomeModel?
                    let convertDicToJsonString = try? JSONSerialization.data(withJSONObject: dictResult, options: [.prettyPrinted])
                    let jsonString = String(data: convertDicToJsonString!, encoding: .utf8)!
                    let jsonStringToData = Data(jsonString.utf8)
                    let decoder = JSONDecoder()
                    do {
                        model = try decoder.decode(BannerHomeModel.self, from: jsonStringToData)
                    } catch {
                        print(error.localizedDescription)
                    }
                    //self.sliderTopHomeBanners = (model?.data?.banners)
                    self.categories = model?.data?.featuredSpecialties
                    self.collectionView.reloadData()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    private func getFeaturedSpecialities() {
        let headers: HTTPHeaders = ["accessToken": kSharedUserDefaults.getLoggedInAccessToken(), "Accept": "application/json"]
        Alamofire.request(
            "http://62.210.203.134/hlthera_engage_backend/api/user/home/featured-quick-search",
            method: .get,
            headers: headers
        ).responseData { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let model):
                do {
                    // Parse the response into the User model
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(BannerHomeModel.self, from: model)
                    self.categories = result.data?.featuredSpecialties ?? []
                    self.collectionView.reloadData()
                } catch {
                    // Handle parsing error
                    print("Error parsing response: \(error.localizedDescription)")
                }
            case .failure(let error):
                showAlertMessage.alert(message: error.localizedDescription)
            }
        }
    }
}

extension SearchDoctorVC {
    func insuranceCompanyApi() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.insurance_companies,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    
                    let data = kSharedInstance.getDictionaryArray(withDictionary: dictResult[kResponse])
                    self.insuranceCompany = data.map{ InsuranceCompanyModel(data: $0) }
                default:
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToast(message: AlertMessage.kNoInternet)
            } else {
                CommonUtils.showToast(message: AlertMessage.kDefaultError)
            }
        }
    }
}
