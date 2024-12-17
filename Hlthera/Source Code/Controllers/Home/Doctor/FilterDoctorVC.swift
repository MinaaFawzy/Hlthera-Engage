//
//  FilterDoctorVC.swift
//  Hlthera
//
//  Created by Prashant on 07/01/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit
import DropDown
import CoreLocation
import GoogleMaps
import AlignedCollectionViewFlowLayout
import Cosmos

class FilterDoctorVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak private var viewRating: CosmosView!
    @IBOutlet var starsButton: [UIButton]!
    @IBOutlet var starsLables: [UILabel]!
    @IBOutlet weak private var lblTitle: UILabel!
    @IBOutlet weak private var buttonMale: UIButton!
    @IBOutlet weak private var buttonFemale: UIButton!
    @IBOutlet weak private var labelMale: UILabel!
    @IBOutlet weak private var labelFemale: UILabel!
    @IBOutlet weak private var viewMale: UIView!
    @IBOutlet weak private var viewFemale: UIView!
    @IBOutlet weak private var collectionViewWeekDays: UICollectionView!
    @IBOutlet weak private var collectionViewLanguage: UICollectionView!
    @IBOutlet weak private var constraintCollectionViewLanguageHeight: NSLayoutConstraint!
    @IBOutlet weak private var tableViewLocation: UITableView!
    @IBOutlet weak private var constraintTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak private var viewVideoCall: UIView!
    @IBOutlet weak private var viewCall: UIView!
    @IBOutlet weak private var viewChat: UIView!
    @IBOutlet weak private var viewHomeVisit: UIView!
    @IBOutlet weak private var viewClinicVisit: UIView!
    @IBOutlet var buttonsAppointmentTypes: [UIButton]!
    @IBOutlet var labelsAppointmentTypes: [UILabel]!
    @IBOutlet var viewsAppointmentTypes: [UIView]!
    //@IBOutlet var buttonsRating: [UIButton]!
    //@IBOutlet weak var stackViewRatings: UIStackView!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var cliniVisitBtn: UIButton!
    
    // MARK: - Stored Properties
    var locationSelected: Bool = false
    var specialitiesId: String = ""
    var languages: [languageModel] = []
    var fiterResult: (([DoctorDetailsModel], [HospitalDetailModel]) -> ())?
    var dropDown = DropDown()
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    var locationManager = CLLocationManager()
    var currentLocation = ""
//    var selectedLocation = SavedLocationsModel(lat: kSharedUserDefaults.getAppLocation().lat, long: kSharedUserDefaults.getAppLocation().long, name: kSharedUserDefaults.getAppLocation().name)
    var selectedLocation = SavedLocationsModel()
    var selectedWeek = -1
//    var selectedCommunication: [String] = []
    var selectedCommunication: String = "-1"
    var selectedLanguages: [String] = []
    var selectedGender: String = ""
    var selectedRating: Int = -1
    var selectedMinFee: Int = -1
    var selectedMaxFee: Int = -1
    var selectedAvailability: String = ""
    var hasCameFrom: HasCameFrom  = .none
    var daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var dates = [Date]()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Calculate the dates for the next 7 days starting from today
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        
        for _ in 0..<7 {
            guard let date = calendar.date(from: dateComponents) else { return }
            dates.append(date)
            dateComponents.day! += 1
        }
//        viewRating.didTouchCosmos = { rating in }
//        viewRating.didFinishTouchingCosmos = { _ in
            //guard let self = self else { return }
            //labelsAppointmentTypes.enumerated().forEach { (index, element) in
            //    let from = index
            //    let to = rating.toInt() ?? 0
            //    if from <= to - 1 {
            //        element.textColor = .white
            //
            //    } else {
            //        element.textColor = .darkGray
            //        print("darkGray")
            //    }
            //}
//        }
        
        lblTitle.font = .corbenRegular(ofSize: 15)
//        viewFemale.removeShadow()
//        viewFemale.borderWidth = 1
//        viewFemale.borderColor = #colorLiteral(red: 0.8117647059, green: 0.8392156863, blue: 0.862745098, alpha: 1)
        labelFemale.textColor = #colorLiteral(red: 0.8117647059, green: 0.8392156863, blue: 0.862745098, alpha: 1)
        DispatchQueue(label: "background", qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.locationManagerInitialSetup(locationManager: self.locationManager)
        }
//        viewMale.removeShadow()
//        viewMale.borderWidth = 1
//        viewMale.borderColor = #colorLiteral(red: 0.8117647059, green: 0.8392156863, blue: 0.862745098, alpha: 1)
        labelMale.textColor = #colorLiteral(red: 0.8117647059, green: 0.8392156863, blue: 0.862745098, alpha: 1)
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        constraintCollectionViewLanguageHeight.constant = 0
        constraintTableViewHeight.constant = 160
        tableViewLocation.tableFooterView = UIView()
        tableViewLocation.separatorStyle = .none
        getLanguagesApi()
        //stackViewRatings.setRatings(value: 0)
        let alignedFlowLayout = collectionViewLanguage?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .top
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func updateButton(sender: UIButton, value: Bool) {
        sender.isSelected = value
    }
    
    func updateView(sender: UIView, backgroundColor: UIColor){
        sender.backgroundColor = backgroundColor
    }
    
   
}

// MARK: - Actions
extension FilterDoctorVC {
    @IBAction func starsButtonTapped(_ sender: UIButton) {
        var buttonNum = -1
        for i in 0...starsButton.count - 1 {
            if starsButton[i].isTouchInside {
                buttonNum = i
                break
            }
        }
        for i in 0...starsButton.count - 1 {
            if i <= buttonNum {
                starsButton[i].setImage(UIImage(named: "staractive"), for: .normal)
                starsLables[i].textColor = .white
            } else {
                starsButton[i].setImage(UIImage(named: "starunactive"), for: .normal)
                starsLables[i].textColor = UIColor(named: "D8DFE9")
            }
        }
        selectedRating = buttonNum + 1
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonDoneTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonFemaleTapped(_ sender: Any) {
        viewMale.backgroundColor = UIColor().hexStringToUIColor(hex: "#F5F7F9")
        buttonMale.tintColor = UIColor(named: "4")
        viewFemale.backgroundColor = UIColor().hexStringToUIColor(hex: "#CAE3FF")
        buttonFemale.tintColor = UIColor(named: "5")
        //        viewMale.removeShadow()
//        viewMale.borderWidth = 1
//        viewFemale.borderWidth = 0
//        viewMale.borderColor = #colorLiteral(red: 0.8117647059, green: 0.8392156863, blue: 0.862745098, alpha: 1)
        labelMale.textColor = #colorLiteral(red: 0.8117647059, green: 0.8392156863, blue: 0.862745098, alpha: 1)
        //        viewFemale.drawShadow()
        labelFemale.textColor = #colorLiteral(red: 0.1921568627, green: 0.1921568627, blue: 0.2, alpha: 1)
        self.selectedGender = "female".localize
        //        self.buttonFemale.setImage(UIImage(named: "doctor_women_active"), for: .normal)
        //        self.buttonMale.setImage(UIImage(named: "doctor_menunfill"), for: .normal)
        
    }
    
    @IBAction func buttonMaleTapped(_ sender: Any) {
        viewFemale.backgroundColor = UIColor().hexStringToUIColor(hex: "#F5F7F9")
        buttonFemale.tintColor = UIColor(named: "4")
        viewMale.backgroundColor = UIColor().hexStringToUIColor(hex: "#CAE3FF")
        buttonMale.tintColor = UIColor(named: "5")
        //        viewFemale.removeShadow()
//        viewFemale.borderWidth = 1
//        viewMale.borderWidth = 0
//        viewFemale.borderColor = #colorLiteral(red: 0.8117647059, green: 0.8392156863, blue: 0.862745098, alpha: 1)
        labelFemale.textColor = #colorLiteral(red: 0.8117647059, green: 0.8392156863, blue: 0.862745098, alpha: 1)
        //        viewMale.drawShadow()
        labelMale.textColor = #colorLiteral(red: 0.1921568627, green: 0.1921568627, blue: 0.2, alpha: 1)
        self.selectedGender = "male".localize
        //        self.buttonFemale.setImage(UIImage(named: "doctor_wpmen_unfill"), for: .normal)
        //        self.buttonMale.setImage(UIImage(named: "doctor_men"), for: .normal)
    }
    
    @IBAction func switchAvailibilityTapped(_ sender: Any) {
    }
    
    @IBAction func buttonDateTapped(_ sender: Any) {
        
    }
    
    @IBAction func buttonLanguageTapped(_ sender: UIButton) {
        dropDown.anchorView = sender
        let lang = languages.map{
            $0.name
        }
        dropDown.dataSource = lang
        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
            // sender.setTitle(item, for: .normal)
            //sender.setTitleColor(#colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.5019607843, alpha: 1), for: .normal)
            let result = self.selectedLanguages.filter{
                $0 == item
            }
            if result.isEmpty{
                self.selectedLanguages.append(item)
                
            }
            self.constraintCollectionViewLanguageHeight.constant = 50
            collectionViewLanguage.reloadData()
            
        }
        dropDown.width = sender.frame.width
        dropDown.show()
    }
    
    @IBAction func buttonVideoTapped(_ sender: UIButton) {
        
        viewsAppointmentTypes.forEach {
            updateView(sender: $0, backgroundColor: UIColor().hexStringToUIColor(hex: "#F5F7F9"))
        }
        videoBtn.tintColor = UIColor(named: "5")
        callBtn.tintColor = UIColor(named: "4")!
        chatBtn.tintColor = UIColor(named: "4")!
        homeBtn.tintColor = UIColor(named: "4")!
        cliniVisitBtn.tintColor = UIColor(named: "4")!
        updateView(sender: viewVideoCall, backgroundColor: UIColor().hexStringToUIColor(hex: "#cbe4fa"))
        selectedCommunication = "2"
        //=====================
        
        //        buttonsAppointmentTypes.map{
        //            updateButton(sender: $0, value:false)
        //        }
        //        updateButton(sender: sender, value:true)
//        let result = self.selectedCommunication.filter{
//            $0 == "2"
//        }
//        if result.isEmpty{
//            self.selectedCommunication.append("2")
//        }
//        else {
//            if let index = self.selectedCommunication.firstIndex(of: "2"){
//                self.selectedCommunication.remove(at: index)
//                sender.borderWidth = 0
//            }
//
//        }
    }
    
    @IBAction func buttonCallTapped(_ sender: UIButton) {
        viewsAppointmentTypes.forEach {
            updateView(sender: $0, backgroundColor: UIColor().hexStringToUIColor(hex: "#F5F7F9"))
        }
        videoBtn.tintColor = UIColor(named: "4")
        callBtn.tintColor = UIColor(named: "5")!
        chatBtn.tintColor = UIColor(named: "4")!
        homeBtn.tintColor = UIColor(named: "4")!
        cliniVisitBtn.tintColor = UIColor(named: "4")!
        updateView(sender: viewCall, backgroundColor: UIColor().hexStringToUIColor(hex: "#cbe4fa"))
        selectedCommunication = "1"
        //        buttonsAppointmentTypes.map{
        //            updateButton(sender: $0, value:false)
        //        }
        //        updateButton(sender: sender, value:true)
//            let result = self.selectedCommunication.filter{
//                $0 == "1"
//            }
//            if result.isEmpty{
//                self.selectedCommunication.append("1")
//            }
//            else {
//                if let index = self.selectedCommunication.firstIndex(of: "1"){
//                    self.selectedCommunication.remove(at: index)
//                    sender.borderWidth = 0
//                }
//
//            }
    }
    
    @IBAction func buttonChatTapped(_ sender: UIButton) {
        viewsAppointmentTypes.forEach {
            updateView(sender: $0, backgroundColor: UIColor().hexStringToUIColor(hex: "#F5F7F9"))
        }
        videoBtn.tintColor = UIColor(named: "4")
        callBtn.tintColor = UIColor(named: "4")!
        chatBtn.tintColor = UIColor(named: "5")!
        homeBtn.tintColor = UIColor(named: "4")!
        cliniVisitBtn.tintColor = UIColor(named: "4")!
        updateView(sender: viewChat, backgroundColor: UIColor().hexStringToUIColor(hex: "#cbe4fa"))
        selectedCommunication = "3"
        //        buttonsAppointmentTypes.map{
        //        updateButton(sender: $0, value:false)
        //    }
        //    updateButton(sender: sender, value:true)
//        let result = self.selectedCommunication.filter{
//            $0 == "3"
//        }
//        if result.isEmpty{
//            self.selectedCommunication.append("3")
//        }
//        else {
//            if let index = self.selectedCommunication.firstIndex(of: "3"){
//                self.selectedCommunication.remove(at: index)
//                sender.borderWidth = 0
//            }
//
//        }
    }
    
    @IBAction func buttonHomeVisitTapped(_ sender: UIButton) {
        viewsAppointmentTypes.forEach {
            updateView(sender: $0, backgroundColor: UIColor().hexStringToUIColor(hex: "#F5F7F9"))
        }
        videoBtn.tintColor = UIColor(named: "4")
        callBtn.tintColor = UIColor(named: "4")!
        chatBtn.tintColor = UIColor(named: "4")!
        homeBtn.tintColor = UIColor(named: "5")!
        cliniVisitBtn.tintColor = UIColor(named: "4")!
        updateView(sender: viewHomeVisit, backgroundColor: UIColor().hexStringToUIColor(hex: "#cbe4fa"))
        selectedCommunication = "4"
        //        buttonsAppointmentTypes.map{
        //            updateButton(sender: $0, value:false)
        //        }
        //        updateButton(sender: sender, value:true)
//        let result = self.selectedCommunication.filter{
//            $0 == "4"
//        }
//        if result.isEmpty{
//            self.selectedCommunication.append("4")
//
//        }
//        else {
//            if let index = self.selectedCommunication.firstIndex(of: "4"){
//                self.selectedCommunication.remove(at: index)
//                sender.borderWidth = 0
//            }
//
//        }
    }
    
    @IBAction func buttonClinicVisitTapped(_ sender: UIButton) {
        viewsAppointmentTypes.forEach {
            updateView(sender: $0, backgroundColor: UIColor().hexStringToUIColor(hex: "#F5F7F9"))
        }
        videoBtn.tintColor = UIColor(named: "4")
        callBtn.tintColor = UIColor(named: "4")!
        chatBtn.tintColor = UIColor(named: "4")!
        homeBtn.tintColor = UIColor(named: "4")!
        cliniVisitBtn.tintColor = UIColor(named: "5")!
        updateView(sender: viewClinicVisit, backgroundColor: UIColor().hexStringToUIColor(hex: "#cbe4fa"))
        selectedCommunication = "5"
        //        buttonsAppointmentTypes.map{
        //            updateButton(sender: $0, value:false)
        //        }
        //        updateButton(sender: sender, value:true)
//        let result = self.selectedCommunication.filter{
//            $0 == "5"
//        }
//        if result.isEmpty{
//            self.selectedCommunication.append("5")
//
//        }
//        else {
//            if let index = self.selectedCommunication.firstIndex(of: "5"){
//                self.selectedCommunication.remove(at: index)
//                sender.borderWidth = 0
//            }
//
//        }
    }
    
    @IBAction func buttonApplyFilterTapped(_ sender: UIButton) {
        
        self.filterApi(id:specialitiesId)
    }
}

extension FilterDoctorVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewWeekDays {
            return dates.count
        } else if collectionView == collectionViewLanguage {
            return selectedLanguages.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewWeekDays{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterDoctorWeekDaysCVC", for: indexPath) as! FilterDoctorWeekDaysCVC
            
            let date = dates[indexPath.item]
            
            // Extract the day of the week and the day of the month
            let dayOfWeek = Calendar.current.component(.weekday, from: date)
            let dayOfMonth = Calendar.current.component(.day, from: date)
            
            cell.labelWeekDay.text = daysOfWeek[dayOfWeek - 1]
            cell.labelDate.text = String(dayOfMonth)
            
            if indexPath.row == selectedWeek {
                cell.viewWeek.backgroundColor = UIColor().hexStringToUIColor(hex: "#CBE4FA")
                //cell.viewWeek.borderColor = #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1)
            } else {
                cell.viewWeek.backgroundColor = UIColor(named: "10")
                //cell.viewWeek.borderColor = #colorLiteral(red: 0.9254901961, green: 0.9333333333, blue: 0.9450980392, alpha: 1)
            }
            return cell
        }
        else if collectionView == collectionViewLanguage{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterDoctorLanguageCVC", for: indexPath) as! FilterDoctorLanguageCVC
            cell.labelLanguageName.text = selectedLanguages[indexPath.row]
            cell.removeCallback = {
                
                self.selectedLanguages.remove(at: indexPath.row)
                self.collectionViewLanguage.reloadData()
                if self.selectedLanguages.isEmpty{
                    self.constraintCollectionViewLanguageHeight.constant = 0
                }
            }
//            self.constraintCollectionViewLanguageHeight.constant = collectionViewLanguage.contentSize.height
            self.constraintCollectionViewLanguageHeight.constant = 60
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterDoctorLanguageCVC", for: indexPath) as! FilterDoctorLanguageCVC
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewWeekDays{
            selectedWeek = indexPath.row
            collectionViewWeekDays.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewWeekDays{
            return CGSize(width: 65, height: 75)
        }
        else if collectionView == collectionViewLanguage{
            //            //let label = UILabel(frame: CGRect.zero)
            //           // label.text = languages[indexPath.row].name
            //           // label.sizeToFit()
            //            let str = languages[indexPath.row].name as NSString
            //            let itemSize = str.size(withAttributes: [
            //                       NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)
            //                   ])
            //           // return CGSize(width: str.length * 15, height: 30)
            //            //return itemSize
            //           // return CGSize(width: collectionViewWeekDays.frame.width/2.28, height: 50)
            //
            //
            //
            //
            //            let string = languages[indexPath.row].name
            //
            //               // your label font.
            //               let font = UIFont(name: "SFProDisplay-Medium", size: 14)
            //            let fontAttribute = [NSAttributedString.Key.font: font]
            //
            //               // to get the exact width for label according to ur label font and Text.
            //            let size = string.size(withAttributes: fontAttribute as [NSAttributedString.Key : Any])
            //
            //               // some extraSpace give if like so.
            //               let extraSpace : CGFloat = 52
            //               let width = size.width + extraSpace
            //               return CGSize(width:width, height: 30)
            
            
            return CGSize(width: 65, height: 75)
        
        }
        else {
            return CGSize(width: 100, height: 100)
        }
    }
}

extension FilterDoctorVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterDoctorLocationTVC") as! FilterDoctorLocationTVC
        cell.selectionStyle = .none
        if indexPath.row < 1{
            cell.labelLocationName.text = "Current Location".localize
            cell.labelAddress.text = String.getString(kSharedUserDefaults.getAppLocation().name)
            cell.imageAddressType.image = UIImage(named: "home_icon")
            cell.imageAddressType.tintColor = UIColor(named: "4")
            if locationSelected {
                selectedLocation.lat == kSharedUserDefaults.getAppLocation().lat ?  (cell.backgroundColor = UIColor().hexStringToUIColor(hex: "#CBE4FA")) : (cell.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
            }
//            selectedLocation.lat != kSharedUserDefaults.getAppLocation().lat ?  (cell.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)) : (cell.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.8666666667, blue: 0.8745098039, alpha: 1))
            
        }else{
            cell.labelAddress.text = selectedLocation.lat == kSharedUserDefaults.getAppLocation().lat ?  "Address".localize : String.getString(selectedLocation.name)
            cell.imageAddressType.image = UIImage(named: "location_mark")
            cell.imageAddressType.tintColor = UIColor(named: "4")
            if locationSelected {
                selectedLocation.lat != kSharedUserDefaults.getAppLocation().lat ?  (cell.backgroundColor = UIColor().hexStringToUIColor(hex: "#CBE4FA")) : (cell.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
            }
//            selectedLocation.lat != kSharedUserDefaults.getAppLocation().lat ?  (cell.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.8666666667, blue: 0.8745098039, alpha: 1)) : (cell.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.selectedLocation = kSharedUserDefaults.getAppLocation()
            tableView.reloadData()
        } else {
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: MyLocationVC.getStoryboardID()) as? MyLocationVC else { return }
            vc.hasCameFrom = .home
            vc.callback = { currentLocation in
                
                self.selectedLocation = currentLocation
                tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        locationSelected = true
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension UIViewController: CLLocationManagerDelegate {
    func locationManagerInitialSetup(locationManager: CLLocationManager) {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
}

extension FilterDoctorVC {
    func filterApi(id: String) {
        
        var params:[String : Any] = [ApiParameters.kSpecialitiesId:id]
        if self.selectedLocation.long != 0.0{
            params[ApiParameters.kLatitude] = self.selectedLocation.lat
            params[ApiParameters.kLongitude] = self.selectedLocation.long
        }
        if self.selectedCommunication != "-1"{
            params[ApiParameters.kCommunication_way] = selectedCommunication
        }
        if !selectedLanguages.isEmpty{
            params[ApiParameters.kLanguage] = selectedLanguages.joined(separator: ",")
        }
        if !selectedGender.isEmpty{
            params[ApiParameters.kGender] = selectedGender
        }
        if selectedRating>0{
            params[ApiParameters.kRating] = String.getString(selectedRating)
        }
        if !selectedAvailability.isEmpty{
            params[ApiParameters.kAvailability] = String.getString(selectedAvailability)
        }
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.doctorFilter,
                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: true)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    //                    if Int.getInt(dictResult["status"]) != 0{
                    //
                    //                    }
                    //                    else {
                    //                        CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    //                    }
                    
                    
                    let result = kSharedInstance.getArray(dictResult["result"])
                    
                    
                    switch self?.hasCameFrom{
                    case .doctors:
                        let data  = result.map{
                            DoctorDetailsModel(data: kSharedInstance.getDictionary($0))
                        }
                        self?.fiterResult?(data,[])
                        self?.navigationController?.popViewController(animated: true)
                    case .hospitals:
                        let data  = result.map{
                            HospitalDetailModel(data: kSharedInstance.getDictionary($0))
                        }
                        
                        self?.fiterResult?([],data)
                        self?.navigationController?.popViewController(animated: true)
                        
                    default:break
                    }
                    
                    
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
    
    func getLanguagesApi() {
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.getLanguage,                                                   requestMethod: .GET,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0{
                        let data = kSharedInstance.getArray(withDictionary: dictResult[kResponse])
                        self?.languages = data.map{
                            languageModel(data:$0)
                        }
                        self?.dropDown.reloadAllComponents()
                    }
                    else{
                        CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    }
                    
                    
                    
                    
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

class CustomViewFlowLayout: UICollectionViewFlowLayout {
    let cellSpacing: CGFloat = 4
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 4.0
        self.sectionInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 6)
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + cellSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        return attributes
    }
}
