//
//  SearchDoctorListingVC.swift
//  Hlthera
//
//  Created by Prashant on 23/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
@available(iOS 15.0, *)
class SearchDoctorListingVC: UIViewController {
    
    // MARK: - Outlets
    //@IBOutlet weak private var searchBar: UISearchBar!
    //@IBOutlet weak private var constraintListingTopOriginal: NSLayoutConstraint!
    //@IBOutlet weak private var constraintListingTopOther: NSLayoutConstraint!
    //@IBOutlet weak private var buttonClearList: UIButton!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var labelPageTitle: UILabel!
    @IBOutlet weak private var buttonFilterAndDelete: UIButton!
    @IBOutlet weak private var buttonDeleteAll: UIButton!
    
    @IBOutlet weak var searchBtn: UIButton!
    // MARK: - Stored Properties
    var isDeleteBtnClicked = false
    var isQuickSearch = false
    var specialityID = -1
    var quickSearchId = -1
    var searchText = ""
    var gender = -1 //0 for Male, 1 for Female
    var searchDoctorResults = [DoctorDetailsModel]()
    var searchHospitalResults = [HospitalDetailModel]()
    var searchedDoctorResult = [DoctorDetailsModel]()
    var searchedHospitalResult = [HospitalDetailModel]()
    
    var passedDoctorsBySpecialist: [DoctorList]? = []
    var passedDoctorsBySpecialists: [DoctorList]? = []
    
    var searchGeneralDoctorList: [DoctorList]? = []
    var searchGeneralDoctorLists: [DoctorList]? = []
    
    var passedFeatSpecialist: FeaturedSpecialty?
    
    var searching = false
    var pageTitle = "Healer Around You".localize
    var hasCameFrom: HasCameFrom?
    var lat = 0.0
    var long = 0.0
    var isDoctorNearBy = false
    var appointmentTypeId: String = ""
    var appointmentType: String = ""
    var isSlotsAvailable = false
    var selectedSlotId = ""
    var selectedSlotDate = ""
    var selectedSlotTime = ""
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBtn.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
//        labelPageTitle.font = .corbenRegular(ofSize: 15)
        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        setStatusBar(color: #colorLiteral(red: 0.9607843137254902, green: 0.9686274509803922, blue: 0.9764705882352941, alpha: 1))
        self.labelPageTitle.text = pageTitle
        let searchView = self.searchBar
        //searchView?.layer.cornerRadius = 25
        //searchView?.clipsToBounds = true
        //searchView?.borderWidth = 0
        //searchView?.setSearchIcon(image: #imageLiteral(resourceName: "search_black"))
        //searchView?.searchTextPositionAdjustment = UIOffset(horizontal: 15, vertical: 0)
        //searchView?.backgroundImage = UIImage()
        //let searchField = self.searchBar.searchTextField
        //searchField.backgroundColor = .white
        //searchField.font = UIFont(name: "Helvetica", size: 13)
        //searchField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //searchBar.delegate = self
        //searchField.addDoneOnKeyboardWithTarget(self, action: #selector(self.doneAction(_:)), shouldShowPlaceholder: false)
        if hasCameFrom == HasCameFrom.hospitals {
            //searchBar.placeholder = "Search Health centers, Speciality".localize
        }
        if hasCameFrom == HasCameFrom.settings {
            //constraintListingTopOther.isActive = true
            //constraintListingTopOther.constant = 15
            //constraintListingTopOriginal.isActive = false
            //constraintListingTopOther.isActive = true
            //constraintListingTopOriginal.isActive = false
            //constraintListingTopOriginal.constant = 5
            //buttonClearList.isHidden = true
            self.labelPageTitle.text = "My Favourites".localize
            self.buttonFilterAndDelete.isHidden = true
            self.buttonDeleteAll.isHidden = true
        } else {
            //constraintListingTopOther.isActive = false
            //constraintListingTopOriginal.isActive = true
            //constraintListingTopOriginal.constant = 5
            //buttonClearList.isHidden = true
        }
        switch hasCameFrom {
        case .home, .feelingUnwell:
            searchByFeatSpecialist(featSpecialsitId: String.getString(passedFeatSpecialist?.id))
            break
        case .searchDoctor:
            searchGeneral(name: searchText, speciality: String(specialityID), country: "101", gender: String.getString(gender))
            break
        default:
            getSearchListing()
            break
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    
    //    func mapDoctorListToDoctorDetailsModel(doctorList: DoctorList) -> DoctorDetailsModel {
    //        let doctorDetailsModel = DoctorDetailsModel(data: [:])
    //
    //        doctorDetailsModel.doctor_id = String.getString(doctorList.doctorId)
    //        doctorDetailsModel.doctor_profile = String.getString(doctorList.doctorProfile)
    //        doctorDetailsModel.doctor_name = String.getString(doctorList.doctorName)
    //        doctorDetailsModel.doctor_exp = String.getString(doctorList.doctorExp)
    //        doctorDetailsModel.address = String.getString(doctorList.address)
    //        doctorDetailsModel.about_us = String.getString(doctorList.aboutUs)
    //
    //        if let specialities = doctorList.doctorSpecialities {
    //            doctorDetailsModel.doctor_specialities = specialities.map { speciality in
    //                return SpecialitiesModel(data: [
    //                    "speciality_id": speciality.id ?? 0,
    //                    "speciality_name": speciality.fullName ?? ""
    //                ])
    //            }
    //        }
    //
    //        if let qualifications = doctorList.doctorQualifications {
    //            doctorDetailsModel.doctor_qualifications = qualifications.map { qualification in
    //                return DoctorQualificationModel(data: [
    //                    "qualification_id": qualification.id ?? 0,
    //                    "qualification_name": qualification.name ?? ""
    //                ])
    //            }
    //        }
    //
    //        if let communicationServices = doctorList.doctorCommunicationServices {
    //            doctorDetailsModel.doctor_communication_services = communicationServices.map { communicationService in
    //                return DoctorCommunicationModel(data: [
    //                    "communication_id": communicationService.id ?? 0,
    //                    "communication_name": communicationService.commServiceType ?? ""
    //                ])
    //            }
    //        }
    //
    //        doctorDetailsModel.shareable_url = String.getString(doctorList.shareableUrl)
    //        doctorDetailsModel.isLike = doctorList.isLike == 1 ? true : false
    //        doctorDetailsModel.likes = String(doctorList.likes ?? 0)
    //        doctorDetailsModel.ratings = String(doctorList.ratings ?? 0.0)
    //        doctorDetailsModel.lat = String.getString(doctorList.lat)
    //        doctorDetailsModel.longitude = String.getString(doctorList.longitude)
    //
    //        return doctorDetailsModel
    //    }
    
    
    func mapDoctorListToDoctorDetailsModel(doctorList: DoctorList) -> DoctorDetailsModel {
        let doctorDetailsModel = DoctorDetailsModel(data: [:])
        
        doctorDetailsModel.doctor_id = String.getString(doctorList.doctorId)
        doctorDetailsModel.doctor_profile = String.getString(doctorList.doctorProfile)
        doctorDetailsModel.doctor_name = String.getString(doctorList.doctorName)
        doctorDetailsModel.doctor_exp = String.getString(doctorList.doctorExp)
        doctorDetailsModel.address = String.getString(doctorList.address)
        doctorDetailsModel.about_us = String.getString(doctorList.aboutUs)
        doctorDetailsModel.shareable_url = String.getString(doctorList.shareableUrl)
        doctorDetailsModel.isLike = doctorList.isLike ?? -1
        doctorDetailsModel.likes = String.getString(doctorList.likes)
//        doctorDetailsModel.ratings = String.getString(doctorList.ratings)
        doctorDetailsModel.ratings = doctorList.ratings ?? 0.0
        doctorDetailsModel.lat = doctorList.lat ?? ""
        doctorDetailsModel.longitude = doctorList.longitude ?? ""
        
//        if let slotsData = doctorList["slotArray"] as? [String: Any],
//            let slotsArray = kSharedInstance.getArray(kSharedInstance.getDictionary(slotsData)["slots"]) as? [[String: Any]] {
//            doctorDetailsModel.slots = slotsArray.map { slotData in
//                let slotModel = SlotModel(data: slotData)
//                return slotModel
//            }
//        }
        
        if let doctorSpecialities = doctorList.doctorSpecialities {
            doctorDetailsModel.doctor_specialities = doctorSpecialities.map { speciality in
                let specialityModel = SpecialitiesModel(data: [:])
                specialityModel.id = String.getString(speciality.id)
                specialityModel.short_name = String.getString(speciality.shortName)
                specialityModel.full_name = String.getString(speciality.fullName)
                return specialityModel
            }
        }
        
        if let doctorQualifications = doctorList.doctorQualifications {
            doctorDetailsModel.doctor_qualifications = doctorQualifications.map { qualification in
                let qualificationModel = DoctorQualificationModel(data: [:])
                qualificationModel.id = String.getString(qualification.id)
                qualificationModel.name = String.getString(qualification.name)
                return qualificationModel
            }
        }
        
        if let doctorCommunicationServices = doctorList.doctorCommunicationServices {
            doctorDetailsModel.doctor_communication_services = doctorCommunicationServices.map { communicationService in
                let communicationModel = DoctorCommunicationModel(data: [:])
                communicationModel.id = String.getString(communicationService.id)
                communicationModel.doctor_id = String.getString(communicationService.doctorId)
                communicationModel.comm_duration = String.getString(communicationService.commDuration)
                communicationModel.comm_duration_type = String.getString(communicationService.commDurationType)
                communicationModel.comm_duration_fee = String.getString(communicationService.commDurationFee)
                communicationModel.comm_service_type = String.getString(communicationService.commServiceType)
                return communicationModel
            }
        }
        
        return doctorDetailsModel
    }
    
}

// MARK: - Actions
@available(iOS 15.0, *)
extension SearchDoctorListingVC {
    @objc private func doneAction(_ sender : UITextField!) {
        self.view.endEditing(true)
    }
    
    @IBAction private func buttonClearListTapped(_ sender: Any) {}
    
    @IBAction private func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func buttonFilterTapped(_ sender: Any) {
        switch hasCameFrom {
        case .doctors, .feelingUnwell, .searchDoctor:
            guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: FilterDoctorVC.getStoryboardID()) as? FilterDoctorVC else { return }
            vc.fiterResult = { [weak self] data, _ in
                guard let self = self else { return }
                self.searchDoctorResults = data
                self.tableView.reloadData()
            }
            vc.specialitiesId = String.getString(self.specialityID)
            vc.hasCameFrom = .doctors
            navigationController?.pushViewController(vc, animated: true)
        case .hospitals:
            guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: FilterDoctorVC.getStoryboardID()) as? FilterDoctorVC else { return }
            vc.fiterResult = { [weak self] _, data in
                guard let self = self else { return }
                self.searchHospitalResults = data
                self.tableView.reloadData()
            }
            vc.hasCameFrom = .hospitals
            navigationController?.pushViewController(vc, animated: true)
        case .settings:
            CommonUtils.showToast(message: "Under Dev".localize)
            return
        default: break
        }
    }
    
    @IBAction private func btnDeleteAllDoctors(_ sender: UIButton) {
        //CommonUtils.showToast(message: "btnDeleteAllDoctors")
        isDeleteBtnClicked = !isDeleteBtnClicked;
        tableView.reloadData()
    }
}

// MARK: - UITableView Delegate & DataSource
@available(iOS 15.0, *)
extension SearchDoctorListingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            switch hasCameFrom {
            case .doctors, .settings:
                return tableView.numberOfRow(numberofRow: self.searchedDoctorResult.count)
            case .hospitals:
                return tableView.numberOfRow(numberofRow: self.searchedHospitalResult.count)
            case .home, .feelingUnwell:
                return tableView.numberOfRow(numberofRow: self.passedDoctorsBySpecialist?.count)
            case .searchDoctor:
                return tableView.numberOfRow(numberofRow: self.searchGeneralDoctorList?.count)
            default:
                return 0
            }
        } else {
            switch hasCameFrom {
            case .doctors, .settings:
                return tableView.numberOfRow(numberofRow: self.searchDoctorResults.count)
            case .home, .feelingUnwell:
                return tableView.numberOfRow(numberofRow: self.passedDoctorsBySpecialists?.count)
            case .searchDoctor:
                return tableView.numberOfRow(numberofRow: self.searchGeneralDoctorLists?.count)
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: SearchDoctorListingTVC = tableView.cellForRow(at: indexPath) as! SearchDoctorListingTVC
        if isDeleteBtnClicked {
            cell.viewCheckBox.isHidden = !cell.viewCheckBox.isHidden
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchDoctorListingTVC", for: indexPath) as! SearchDoctorListingTVC
        switch hasCameFrom {
        case .home, .feelingUnwell:
            var obj = passedDoctorsBySpecialists![indexPath.row]
            if searching {
                obj = passedDoctorsBySpecialist![indexPath.row]
            }
            cell.labelDoctorName.text = String.getString(obj.doctorName)
            if obj.doctorSpecialities!.indices.contains(0) {
                cell.labelDoctorSpecialization.text = obj.doctorSpecialities![0].fullName?.capitalized.localize
            }
            //cell.labelPrice.text = "Starting from $\(getMinimumPrice(from: obj))"
            cell.imageDoctor.downlodeImage(serviceurl: String.getString(obj.doctorProfile), placeHolder: UIImage(named: "no_data_image"))
            cell.labelExperience.text = (obj.doctorExp ?? "0") + " years of exp.".localize
//            cell.labelLocation.text = obj.address!.isEmpty ? "Address not found".localize : obj.address
            cell.buttonHeart.isSelected = (obj.isLike == 1) ? true : false
            //if hasCameFrom == .settings {
            //    cell.imageService.isHidden = false
            //    cell.imageService.image = getImage(from: Int.getInt(obj.doctor_services))
            //} else {
            //    cell.imageService.isHidden = true
            //}
            let date = Date()
            let dateFormattor = DateFormatter()
            dateFormattor.dateFormat = "yyyy'-'MM'-'dd"
            //let res = obj.slots!.filter{
            //date.dateString(ofStyle: .long) == dateFormattor.date(from:$0.dates!)?.dateString(ofStyle: .long)
            //}
            //let startingDate = obj.slots!.indices.contains(0) ? ("Available From \(obj.slots![0].dates)") : ("Not Available")
//            cell.labelAvailibility.text  = res.isEmpty ? ("Not Available Today").localize : ("Available Today").localize
            cell.labelRating.text = String(format : "%.1f", obj.ratings ?? 0.0).localize
            cell.callback = { [weak self] in
                guard let self = self else { return }
                guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: ViewDoctorProfileVC.getStoryboardID()) as? ViewDoctorProfileVC else { return }
                //vc.searchResultFromSpecialist = obj
                vc.searchResult = self.mapDoctorListToDoctorDetailsModel(doctorList: obj)
                UserData.shared.hospital_id = ""
                vc.hasComeFrom = self.hasCameFrom!
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.labelRating.text = String.getString(obj.ratings).localize
            cell.heartTapped = { value in
                let doctorId = String.getString(obj.doctorId).toEnglishNumber()
                self.favoriteApi(isLike: !cell.buttonHeart.isSelected, type: .doctors, id: Int(truncating: doctorId ?? 0))
            }
            cell.checkBoxTapped = { value in
                if value {
                    cell.buttonCheckBox.setImage(UIImage(named: "check_box"), for: .normal)
                } else {
                    cell.buttonCheckBox.setImage(UIImage(named: "uncheck_box"), for: .normal)
                }
            }
            break
        case .doctors, .settings:
            var obj = searchDoctorResults[indexPath.row]
            if searching {
                obj = searchedDoctorResult[indexPath.row]
            }
            cell.labelDoctorName.text = String.getString(obj.doctor_name).localize
            
            if obj.doctor_specialities.indices.contains(0) {
                cell.labelDoctorSpecialization.text = obj.doctor_specialities[0].full_name.capitalized.localize
            }
            cell.labelPrice.text = "Starting from $".localize + "\(getMinimumPrice(from: obj))".localize
            cell.imageDoctor.downlodeImage(serviceurl: String.getString(obj.doctor_profile), placeHolder: UIImage(named: "no_data_image"))
            cell.labelExperience.text = obj.doctor_exp + " years of exp.".localize
//            cell.labelLocation.text = obj.address == nil ? "Address not found".localize : obj.address
            cell.buttonHeart.isSelected = (obj.isLike ==  1) ? true : false
            if hasCameFrom == .settings {
                cell.imageService.isHidden = false
                cell.imageService.image = getImage(from: Int.getInt(obj.doctor_services))
            } else {
                cell.imageService.isHidden = true
            }
            let date = Date()
            let dateFormattor = DateFormatter()
            dateFormattor.dateFormat = "yyyy'-'MM'-'dd"
            let res = obj.slots.filter{
                date.dateString(ofStyle: .long) == dateFormattor.date(from:$0.dates)?.dateString(ofStyle: .long)
            }
            let startingDate = obj.slots.indices.contains(0) ? ("Available From".localize + "\(obj.slots[0].dates)").localize : ("Not Available".localize)
            cell.labelAvailibility.text  = res.isEmpty ? "Not Available Today".localize : "Available Today".localize
            cell.labelRating.text = String(format : "%.1f", obj.ratings ).localize
            cell.callback = { [weak self] in
                guard let self = self else { return }
                guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: ViewDoctorProfileVC.getStoryboardID()) as? ViewDoctorProfileVC else { return }
                vc.searchResult = obj
                UserData.shared.hospital_id = ""
                vc.hasComeFrom = self.hasCameFrom!
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.labelRating.text = String.getString(obj.ratings).localize
            cell.heartTapped = { value in
                let doctorId = obj.doctor_id.toEnglishNumber()
                self.favoriteApi(isLike: !cell.buttonHeart.isSelected, type: .doctors, id: Int(truncating: doctorId ?? 0))
            }
            cell.checkBoxTapped = { value in
                if value {
                    cell.buttonCheckBox.setImage(UIImage(named: "check_box"), for: .normal)
                } else {
                    cell.buttonCheckBox.setImage(UIImage(named: "uncheck_box"), for: .normal)
                }
            }
        case .searchDoctor:
            var obj = searchGeneralDoctorLists![indexPath.row]
            if searching {
                obj = searchGeneralDoctorList![indexPath.row]
            }
            cell.labelDoctorName.text = String.getString(obj.doctorName).localize
            if obj.doctorSpecialities!.indices.contains(0){
                cell.labelDoctorSpecialization.text = obj.doctorSpecialities![0].fullName?.capitalized
            }
            //cell.labelPrice.text = "Starting from $\(getMinimumPrice(from: obj))"
            cell.imageDoctor.downlodeImage(serviceurl: String.getString(obj.doctorProfile), placeHolder: UIImage(named: "no_data_image"))
            cell.labelExperience.text = (obj.doctorExp ?? "0").localize + " years of exp.".localize
            //cell.labelLocation.text = obj.address!.isEmpty ? "Address not found" : obj.address
            
            cell.buttonHeart.isSelected = (obj.isLike == 1) ? true : false
            if hasCameFrom == .settings {
                cell.imageService.isHidden = false
                cell.imageService.image = getImage(from: Int.getInt(obj.doctorCommunicationServices))
            } else {
                cell.imageService.isHidden = true
            }
            let date = Date()
            let dateFormattor = DateFormatter()
            dateFormattor.dateFormat = "yyyy'-'MM'-'dd"
            //let res = obj.slots.filter{
            //date.dateString(ofStyle: .long) == dateFormattor.date(from:$0.dates)?.dateString(ofStyle: .long)
            //}
            //let startingDate = obj.slots.indices.contains(0) ? ("Available From \(obj.slots[0].dates)") : ("Not Available")
            cell.labelAvailibility.text  = "Available Today".localize
            cell.labelRating.text = String(format : "%.1f", obj.ratings ?? 0.0).localize
            cell.callback = { [weak self] in
                guard let self = self else { return }
                guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: ViewDoctorProfileVC.getStoryboardID()) as? ViewDoctorProfileVC else { return }
                //vc.searchResultFromGeneral = obj
                vc.searchResult = self.mapDoctorListToDoctorDetailsModel(doctorList: obj)
                UserData.shared.hospital_id = ""
                vc.hasComeFrom = self.hasCameFrom!
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.heartTapped = { value in
                let doctorId = String.getString(obj.doctorId).toEnglishNumber()
                self.favoriteApi(isLike: !cell.buttonHeart.isSelected, type: .doctors, id: Int(truncating: doctorId ?? 0))
            }
            cell.checkBoxTapped = { value in
                if value {
                    cell.buttonCheckBox.setImage(UIImage(named: "check_box"), for: .normal)
                } else {
                    cell.buttonCheckBox.setImage(UIImage(named: "uncheck_box"), for: .normal)
                }
            }
            
        default: break
        }
        //DispatchQueue.main.async{
        //    cell.imageDoctor.setGradientBackground2()
        //}
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableView.automaticDimension
        return 255
    }
}

@available(iOS 15.0, *)
extension SearchDoctorListingVC {
    func getSearchListing() {
        CommonUtils.showHudWithNoInteraction(show: true)
        var params: [String: Any] = [:]
        var serviceUrl = ServiceName.searchDoctor
        switch hasCameFrom {
        case .doctors:
            serviceUrl = ServiceName.doctorList
        case .hospitals:
            self.isQuickSearch = false
            serviceUrl = ServiceName.hospitalList
        case .settings:
            self.isQuickSearch = false
            serviceUrl = ServiceName.myDoctors
        default: break
        }
        
        
        if self.isQuickSearch {
            params = [ApiParameters.kIsQuickSearch:"1",
                      ApiParameters.kSpecialitiesId:String.getString(self.quickSearchId)
            ]
        } else {
            params = [ApiParameters.kIsQuickSearch:"0"]
            if lat != 0.0 && long != 0.0 {
                params[ApiParameters.kLatitude] = String(self.lat)
                params[ApiParameters.kLongitude] = String(self.long)
            }
            if self.specialityID != -1 {
                params[ApiParameters.kSpecialitiesId] = String.getString(self.specialityID)
            }
            if self.gender != -1 {
                params[ApiParameters.kGender] = self.gender == 0 ? "male" : "female"
            }
            //if !self.searchText.isEmpty{
            //self.searchBar.searchTextField.text = searchText
            //}
        }
        
        TANetworkManager.sharedInstance.requestApi(
            withServiceName: serviceUrl,
            requestMethod: hasCameFrom == HasCameFrom.settings ? (.GET) : (.POST),
            requestParameters: params, withProgressHUD: false
        ) { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    
                    let result = kSharedInstance.getDictionaryArray(withDictionary: dictResult["result"])
                    switch self.hasCameFrom {
                    case .doctors:
                        self.searchDoctorResults = result.map {
                            DoctorDetailsModel(data: $0)
                        }
                        self.tableView.reloadData()
                    case  .settings, .searchDoctor:
                        self.searchDoctorResults = result.map {
                            DoctorDetailsModel(data: $0)
                        }
        
                    case .hospitals:
                        self.searchHospitalResults = result.map { HospitalDetailModel(data: $0) }
                    default: break
                    }
                    self.tableView.reloadData()
                    if !self.searchText.isEmpty {
                        //self.searchBar.text = self.searchText
                        //self.searchBar.delegate?.searchBar?(self.searchBar, textDidChange: self.searchText)
                    }
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

@available(iOS 15.0, *)
extension SearchDoctorListingVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch hasCameFrom{
        case .doctors,.settings:
            searchedDoctorResult = searchDoctorResults.filter({
                $0.doctor_name.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.doctor_specialities.contains(where: {$0.full_name.lowercased().prefix(searchText.count) == searchText.lowercased()})
            })
        case .home, .feelingUnwell:
            passedDoctorsBySpecialist = passedDoctorsBySpecialists?.filter({
                $0.doctorName!.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.doctorSpecialities!.contains(where: {$0.fullName!.lowercased().prefix(searchText.count) == searchText.lowercased()})
            })
        case .hospitals:
            searchedHospitalResult = searchHospitalResults.filter({
                $0.hospital_name.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.hospital_specialities.contains(where: {$0.full_name.lowercased().prefix(searchText.count) == searchText.lowercased()})
            })
        default:break
            
        }
        
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

extension UICollectionView {
    
    private func noRecordsMessage(_ message: String?)
    {
        let messageLabel = UILabel(frame: CGRect(x:0,y:0,width:self.bounds.size.width, height:self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = AppFonts.regular(15.0).font
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        
    }
    
    func loadXibForCellResuse(_ identifier: String?) -> Void {
        let nib = UINib(nibName: String.getString(identifier), bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: String.getString(identifier))
    }
    
    func numberOfRow(_ row: Int?, message: String?) -> Int {
        
        if Int.getInt(row) > 0
        {
            self.removeEmptyMessage()
            return Int.getInt(row)
            
        } else {
            noRecordsMessage(message)
            return 0
        }
        
        
    }
    
    func reloadDataInMainThread() -> Void {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    private func removeEmptyMessage()
    {
        self.backgroundView = nil
    }
}

extension UITableView {
    func numberOfRow(numberofRow count: Int? ,message messages: String? , messageColor: UIColor = UIColor.darkGray) -> Int {
        var noDataLbl : UILabel?
        noDataLbl = UILabel(frame: self.frame)
        noDataLbl?.textAlignment = .center
        noDataLbl?.font = AppFonts.regular(15.0).font
        noDataLbl?.numberOfLines = 0
        noDataLbl?.text = messages
        noDataLbl?.center = self.center
        noDataLbl?.textColor = .black
        noDataLbl?.lineBreakMode = .byTruncatingTail
        self.backgroundView = Int.getInt(count) != 0 ? nil : noDataLbl
        return Int.getInt(count)
    }
    func numberOfRow(numberofRow count: Int? ,image: UIImage = UIImage(named: "no_data_image")!) -> Int {
        let noDataImg = UIImageView()
        noDataImg.image = image
        noDataImg.translatesAutoresizingMaskIntoConstraints = false
        if Int.getInt(count) == 0 {
            noDataImg.restorationIdentifier = "nodatafound"
            self.addSubview(noDataImg)
            NSLayoutConstraint.activate([noDataImg.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant:  0),
                                         noDataImg.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),noDataImg.heightAnchor.constraint(equalToConstant: 200),
                                         noDataImg.widthAnchor.constraint(equalToConstant: 200)])
        } else {
            self.subviews.forEach { if $0.restorationIdentifier == "nodatafound" {
                $0.removeFromSuperview()
            }
            }
        }
        return Int.getInt(count)
    }
}

extension UICollectionView {
    func numberOfRow(numberofRow count: Int?, image: UIImage = UIImage(named: "no_data_image")!) -> Int {
        let noDataImg = UIImageView()
        noDataImg.image = image
        noDataImg.translatesAutoresizingMaskIntoConstraints = false
        if Int.getInt(count) == 0 {
            noDataImg.restorationIdentifier = "nodatafound"
            self.addSubview(noDataImg)
            NSLayoutConstraint.activate([noDataImg.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant:  0),
                                         noDataImg.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),noDataImg.heightAnchor.constraint(equalToConstant: 200),
                                         noDataImg.widthAnchor.constraint(equalToConstant: 200)])
        } else {
            self.subviews.forEach { if $0.restorationIdentifier == "nodatafound" {
                $0.removeFromSuperview()
            }}
        }
        return Int.getInt(count)
    }
}

extension UIViewController {
    func json(from object: Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}
@available(iOS 15.0, *)
extension SearchDoctorListingVC {
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
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    //if Int.getInt(dictResult["status"]) != 0{
                    self?.searching = false
                    //self?.searchBar.text = ""
                    self?.getSearchListing()
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    //  }
                    
                    
                    
                    
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

func getMinimumPrice(from: DoctorDetailsModel) -> Int{
    let res = from.doctor_communication_services.map{
        Int.getInt($0.comm_duration_fee)
    }
    return res.min() ?? 0
}

func getMinimumPrice(from: HospitalDetailModel) -> Int{
    if let data = from.doctorBasicInfo{
        let res = data.map{
            getMinimumPrice(from: $0)
        }
        return res.min() ?? 0
    }
    return 0
}

func getImage(from: Int) -> UIImage {
    switch from{
    case 1: return UIImage(named: ServiceIconIdentifiers.audio) ?? UIImage()
    case 2: return UIImage(named: ServiceIconIdentifiers.video) ?? UIImage()
    case 3: return UIImage(named: ServiceIconIdentifiers.chat) ?? UIImage()
    case 4: return UIImage(named: ServiceIconIdentifiers.home) ?? UIImage()
    case 5: return UIImage(named: ServiceIconIdentifiers.clinic) ?? UIImage()
    default: return UIImage()
    }
}

@available(iOS 15.0, *)
extension SearchDoctorListingVC {
    func searchByFeatSpecialist(featSpecialsitId: String) {
        CommonUtils.showHudWithNoInteraction(show: true)
        var params:[String: Any] = [:]
        //        DispatchQueue.main.async {
        //            self.scrollView.refreshControl?.beginRefreshing()
        //           }
        let serviceUrl = ServiceName.homeSearchBySpeciality
        
        params = [ApiParameters.speciality: String(featSpecialsitId)]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: serviceUrl,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    //let result = kSharedInstance.getDictionaryArray(withDictionary: dictResult["result"])
                    //self.doctors = result.map {
                    //DoctorDetailsModel(data: $0)
                    //}
                    //}
                    
                    var model: SearchByFeatSpecialistResponse?
                    let convertDicToJsonString = try? JSONSerialization.data(withJSONObject: dictResult, options: [.prettyPrinted])
                    let jsonString = String(data: convertDicToJsonString!, encoding: .utf8)!
                    let jsonStringToData = Data(jsonString.utf8)
                    let decoder = JSONDecoder()
                    do {
                        model = try decoder.decode(SearchByFeatSpecialistResponse.self, from: jsonStringToData)
                    } catch {
                        print(error.localizedDescription)
                    }
                    self.passedDoctorsBySpecialists = model?.doctorList
                    self.tableView.reloadData()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                    break
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
}
@available(iOS 15.0, *)
extension SearchDoctorListingVC {
    func searchGeneral(
        name: String?,
        speciality: String?,
        country: String?,
        gender: String?
    ) {
        CommonUtils.showHudWithNoInteraction(show: true)
        var params: [String: Any] = [:]
        
        if lat != 0.0 && long != 0.0 {
            params[ApiParameters.kLatitude] = String(self.lat)
            params[ApiParameters.kLongitude] = String(self.long)
        }
        if self.specialityID != -1 {
            params[ApiParameters.SearchGeneralSpecilaity] = String.getString(self.specialityID)
        }
        if self.gender != -1 {
            params[ApiParameters.SearchGeneralGender] = self.gender == 0 ? "male" : "female"
        }
        
        params = [
            ApiParameters.SearchGeneralName: name ?? ""
            //ApiParameters.SearchGeneralCountry: country ?? ""
        ]
        
        TANetworkManager.sharedInstance.requestApi(
            withServiceName: ServiceName.generalSearch,
            requestMethod: .POST,
            requestParameters: params, withProgressHUD: false
        ) {
            [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    var model:SearchGeneralResponse?
                    let convertDicToJsonString = try? JSONSerialization.data(withJSONObject: dictResult, options: [.prettyPrinted])
                    let jsonString = String(data: convertDicToJsonString!, encoding: .utf8)!
                    let jsonStringToData = Data(jsonString.utf8)
                    let decoder = JSONDecoder()
                    do {
                        model = try decoder.decode(SearchGeneralResponse.self, from: jsonStringToData)
                    } catch {
                        print(error.localizedDescription)
                    }
                    self.searchGeneralDoctorLists = model?.doctorList
                    self.tableView.reloadData()
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
