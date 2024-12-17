//
//  BookingFullDetailsVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 05/02/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
//import MobileRTC

@available(iOS 15.0, *)
class BookingFullDetailsVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var labelDoctorRating: UILabel!
    @IBOutlet weak var labelDoctorSpecialty: UILabel!
    @IBOutlet weak private var labelAppointmentWith: UILabel!
    @IBOutlet weak var TypeOfBookingImage: UIImageView!
    @IBOutlet weak private var imageDoctor: UIImageView!
    @IBOutlet weak private var labelHospitalName: UILabel!
    @IBOutlet weak private var labelTime: UILabel!
    @IBOutlet weak private var labelBookingType: UILabel!
    @IBOutlet weak private var labelExperience: UILabel!
    @IBOutlet weak private var lblTitle: UILabel!
    @IBOutlet weak private var labelReviews: UILabel!
    @IBOutlet weak private var lblYourDetails: UILabel!
    @IBOutlet weak private var labelOnScheduled: UILabel!
    @IBOutlet weak private var labelServiceType: UILabel!
    @IBOutlet weak private var labelServiceFee: UILabel!
    @IBOutlet weak private var imagePhone: UIImageView!
    @IBOutlet weak private var viewMap: GMSMapView!
    @IBOutlet weak private var labelAddress: UILabel!
    @IBOutlet weak private var imageFront: UIImageView!
    @IBOutlet weak private var imageBack: UIImageView!
    @IBOutlet weak private var labelBookingID: UILabel!
    @IBOutlet weak private var labelBookingDate: UILabel!
    @IBOutlet weak private var viewContent: UIView!
    @IBOutlet weak private var buttonConfirm: UIButton!
    @IBOutlet weak private var buttonCancel: UIButton!
    @IBOutlet weak private var buttonPrebooking: UIButton!
    @IBOutlet weak private var lblBookingDate: UILabel!
    @IBOutlet weak private var buttonReschedule: UIButton!
    @IBOutlet weak private var buttonGiveRating: UIButton!
    @IBOutlet weak private var buttonJoinByVideo: UIButton!
    @IBOutlet weak private var buttonJoinByAudio: UIButton!
    @IBOutlet var stackViewsRating: [UIImageView]!
    
    @IBOutlet weak var backgroundViewHhight: NSLayoutConstraint!
    // MARK: - Stored prorperties
    //var data: BookingDataModel?
    var data: ResultOnGoingSearch?
    var patientDetails: [PatientDetailsModel] = []
    var patientKeys: [String] = [
        "Patient's Name",
        //"Patient's Email Address",
        "Patient's Mobile Number",
        //"Patient's Gender",
        "Insurance",
        "Insurance Number",
        "Insurance Images",
    ]
    var patientValues: [String?] = []
    var latitude = 19.0760
    var longitude = 72.8777
    var locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    var currentLocation: String = ""
    var isOngoing: Bool = false
    var hasCameFrom: HasCameFrom?
    var backgroundHight: CGFloat = 0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        lblYourDetails.font = .corbenRegular(ofSize: 17)
//        lblTitle.font = .corbenRegular(ofSize: 15)
//        labelAppointmentWith.font = .CorbenBold(ofSize: 14)
        viewContent.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewContent.layer.cornerRadius = 15
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        setupMaps()
        fillDetails()
        
        //Only showing in case video booking
        //buttonJoinByVideo.isHidden = false
        //buttonJoinByAudio.isHidden = false
        //generateZoomLink()
        //The Zoom SDK requires a UINavigationController to update the UI for us. Here we supplied the SDK with the ViewControllers navigationController.
//        MobileRTC.shared().setMobileRTCRootController(navigationController)
        // Notification that is used to start a meeting upon log in success.
//        NotificationCenter.default.addObserver(self, selector: #selector(userLoggedIn), name: NSNotification.Name(rawValue: "userLoggedIn"), object: nil)
    }
    
    //Selector that is used to start a meeting upon log in success.
//    @objc func userLoggedIn() {
//        startMeeting()
//    }
    
//    func startMeeting() {
//        // Obtain the MobileRTCMeetingService from the Zoom SDK, this service can start meetings, join meetings, leave meetings, etc.
//        if let meetingService = MobileRTC.shared().getMeetingService() {
//            // Set the ViewController to be the MobileRTCMeetingServiceDelegate
//            meetingService.delegate = self
//
//            // Create a MobileRTCMeetingStartParam to provide the MobileRTCMeetingService with the necessary info to start an instant meeting.
//            // In this case we will use MobileRTCMeetingStartParam4LoginlUser(), since the user has logged into Zoom.
//            let startMeetingParameters = MobileRTCMeetingStartParam4LoginlUser()
//
//            // Call the startMeeting function in MobileRTCMeetingService. The Zoom SDK will handle the UI for you, unless told otherwise.
//            meetingService.startMeeting(with: startMeetingParameters)
//        }
//    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func setupMaps() {
        self.latitude = Double.getDouble(data?.doctorInformation?.lat)
        self.longitude = Double.getDouble(data?.doctorInformation?.longitude)
        self.locationManagerInitialSetup(locationManager: locationManager)
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
        marker.icon = #imageLiteral(resourceName: "location_map")
        //marker.snippet = ""
        marker.map = viewMap
        placesClient = GMSPlacesClient.shared()
        viewMap.clipsToBounds = true
        viewMap.cornerRadius = 10
        let geocoder = GMSGeocoder()
        let position = CLLocationCoordinate2DMake(self.latitude, self.longitude)
        geocoder.reverseGeocodeCoordinate(position) { response , error in
            if error != nil {
                print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            } else {
                let result = response?.results()?.first
                // " \) > \) \(result?.locality == nil ? "" : " > ") "
                //                "\(String.getString(result?.subLocality))\(result?.subLocality == nil ? "" : ", ") \(String.getString(result?.thoroughfare))"
                //
                self.currentLocation = "\(String.getString(result?.locality)), \(String.getString(result?.country))"
                
                self.labelAddress.text = String(result?.lines?[0] ?? "Unknown Address").localize
                self.latitude = position.latitude
                self.longitude = position.longitude
            }
        }
    }
    
    func fillDetails() {
        if let obj = data {
            if obj.status?.toString() == "4" {
                self.buttonConfirm.isHidden = true
                self.buttonReschedule.isHidden = true
                self.buttonPrebooking.isHidden = true
                self.buttonGiveRating.isHidden = true
                backgroundHight = 1090
            }
            else if obj.status?.toString() == "3" {
                self.buttonConfirm.isHidden = true
                self.buttonReschedule.isHidden = true
                self.buttonCancel.isHidden = true
                self.buttonPrebooking.isHidden = false
                self.buttonPrebooking.setTitle("Book again".localize, for: .normal)
                self.buttonGiveRating.isHidden = true
                backgroundHight = 1090
            }
            else if obj.status?.toString() == "2" {
                self.buttonConfirm.isHidden = true
                self.buttonReschedule.isHidden = true
                self.buttonCancel.isHidden = true
                self.buttonPrebooking.isHidden = false
                self.buttonGiveRating.isHidden = false
                backgroundHight = 1090
            }
            else if isOngoing {
                self.buttonConfirm.isHidden = true
                self.buttonReschedule.isHidden = true
                backgroundHight = 1100
            }
            else if obj.status?.toString() == "1" {
                self.buttonConfirm.isHidden = false
                self.buttonReschedule.isHidden = false
                self.buttonCancel.isHidden = false
                self.buttonPrebooking.isHidden = true
                self.buttonGiveRating.isHidden = true
                backgroundHight = 1230
            }
//            self.labelAppointmentWith.text = "Your Upcoming Clinic Appointment with".localize + String.getString(obj.doctor?.name)
           
            switch obj.appointmentType {
            case "1" :
                self.imagePhone.image = UIImage(named: "audio_call")
                self.buttonJoinByAudio.isHidden = false
                backgroundHight = backgroundHight + 50
            case "2" :
                self.imagePhone.image = UIImage(named: "video")
                self.buttonJoinByVideo.isHidden = false
                backgroundHight = backgroundHight + 50
            case "3" :
                self.imagePhone.image = UIImage(named: "chat-1")
            case "4" :
                self.imagePhone.image = UIImage(named: "homevisit")
            case "5" :
                self.imagePhone.image = UIImage(named: "clinic_visit_hospital")
            default: break
            }
            self.backgroundViewHhight.constant = backgroundHight
            self.labelHospitalName.text = String.getString(obj.hospital?.name) == "" ? "Unknown hospital name".localize : obj.hospital?.name.localize
            self.labelDoctorSpecialty.text = String.getString(obj.doctorSpecialities?.specialities) == "" ? "Unknown doctor specialities".localize : obj.doctorSpecialities?.specialities?.localize
            self.labelAppointmentWith.text = String.getString(obj.doctor?.name).localize
            self.labelDoctorRating.text = String(format : "%.1f", obj.ratings ?? 0.0).localize
            //self.labelOnScheduled.text = "On scheduled date & time, consulted Doctor will initiate the \(String.getString(obj.doctor_service_fee?.comm_service_type))"
            let date = getDateFromString(dateString: String.getString(obj.doctorSlotInformation?.date), timeString: String.getString(obj.doctorSlotInformation?.slotTime))
            let formatterForDate = DateFormatter()
            formatterForDate.timeStyle = .none
            formatterForDate.dateStyle = .long
            formatterForDate.dateFormat = "EEEE, d MMM yyyy"
            self.labelBookingDate.text = formatterForDate.string(from: date)
            let formatterForTime = DateFormatter()
            formatterForTime.timeStyle = .none
            formatterForTime.dateStyle = .long
            formatterForTime.dateFormat = "h:mm a"
            self.labelTime.text = formatterForTime.string(from: date).localize
            self.labelExperience.text = String.getString(obj.doctorInformation?.experience) == "1" ? String.getString(obj.doctorInformation?.experience) + " Year".localize : String.getString(obj.doctorInformation?.experience) + " Years".localize
            if isOngoing {
                self.labelBookingType.text = "Your ongoing appointment".localize
            } else {
                self.labelBookingType.text = "Your scheduled appointment".localize
            }
//            switch String.getString(obj.doctorServiceFee?.commServiceType) {
//            case "video":
//                //self.labelServiceType.text = "Video Call"
//                //self.imagePhone.image = UIImage(named: "video_call_sm")
//                self.imagePhone.image = UIImage(named: "video2")
//                self.buttonJoinByVideo.isHidden = false
//                break
//            case "home":
//                //self.labelServiceType.text = "Home Visit"
//                self.imagePhone.image = UIImage(named: "home")
//                break
//            case "chat":
//                //self.labelServiceType.text = "Chat"
//                self.imagePhone.image = UIImage(named: "chat_sm")
//                break
//            case "audio":
//                //self.labelServiceType.text = "Audio Call"
//                self.imagePhone.image = UIImage(named: "call_sm")
//                self.buttonJoinByAudio.isHidden = false
//                break
//            case "visit":
//                //self.labelServiceType.text = "Clinic Visit"
//                self.imagePhone.image = UIImage(named: "home_visit_sm")
//                break
//            default: break
//            }
            //self.labelServiceFee.text = "$"+obj.fees
            self.latitude = Double.getDouble(obj.doctorInformation?.lat)
            self.longitude = Double.getDouble(obj.doctorInformation?.longitude)
            self.labelBookingID.text = obj.id?.toString().localize
            self.imageDoctor.downlodeImage(serviceurl: "https://hlthera-s3.s3-ap-southeast-2.amazonaws.com/user_profile/" + String.getString(obj.doctor?.profilePicture), placeHolder: UIImage(named: "no_data_image"))
            
            var gender = "Female"
            if (obj.patientGender == "1") {
                gender = "Male"
            }
            if !(obj.otherPatientName?.isEmpty == true) {
                self.patientValues = [
                    obj.otherPatientName,
                    obj.patientMobile,
                    obj.otherPatientInsurance,
                    obj.otherPatientImageFront
                ]
            } else {
                self.patientValues = [
                    obj.patientName,
                    obj.patientMobile,
                    obj.otherPatientInsurance,
                    obj.otherPatientImageFront
                ]
            }
//          //self.imageFront.downlodeImage(serviceurl: , placeHolder: <#T##UIImage?#>)
        }
    }
}

// MARK: - Actions
@available(iOS 15.0, *)
extension BookingFullDetailsVC {
    @IBAction private func buttonAppointmentTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func buttonBackTapped(_ sender: Any) {
        if hasCameFrom == .ongoing || hasCameFrom == .scheduled || hasCameFrom == .cancelled || hasCameFrom == .past {
            self.navigationController?.popViewController(animated: true)
        } else if hasCameFrom == .bookAppointment {
            kSharedAppDelegate?.moveToHomeScreen(index: 1)
        }
    }
    
    @IBAction private func buttonConfirm(_ sender: Any) {
        globalApis.updateBookingStatus(bookingId: String.getString(data?.id), doctorId: String.getString(data?.doctorID), status: 4){ _ in
            guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.popUpDescription = "Your appointment has been confirmed".localize
            vc.popUpImage = #imageLiteral(resourceName: "smile")
            vc.callback = {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    self.dismiss(animated: true, completion: {
                        
                    }
                    )
                })
            }
            self.navigationController?.present(vc, animated: true)
        }
    }
    
    @IBAction private func buttonCancelTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: AlertVC.getStoryboardID()) as? AlertVC else { return }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        
        vc.yesCallback = {
            
            self.dismiss(animated: true, completion: {
                guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: AppointmentCancellationVC.getStoryboardID()) as? AppointmentCancellationVC else { return }
                vc.data = self.data
                self.navigationController?.pushViewController(vc, animated: true)
            })
            
        }
        self.navigationController?.present(vc, animated: true)
        
    }
    
    @IBAction private func buttonRescheduleTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: AlertVC.getStoryboardID()) as? AlertVC else { return }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.alertDesc = "Are you sure you want to reschedule this".localize + " \(String.getString(data?.doctorServiceFee?.commDurationType))" + "appointment?".localize
        vc.yesCallback = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: {
                globalApis.getDoctorDetails(doctorId: String.getString(self.data?.doctorID), communicationServiceId: String.getString(self.data?.doctorServiceFee?.id), slotId: String.getString(self.data?.slotID)){ data in
                    guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: DoctorBookingAppointmentVC.getStoryboardID()) as? DoctorBookingAppointmentVC else { return }
                    vc.selectedCommunication = String.getString(self.data?.doctorServiceFee?.commServiceType)
                    let res = data.doctor_communication_services.filter{$0.comm_service_type == self.data?.doctorServiceFee?.commServiceType}
                    if res.indices.contains(0) {
                        vc.selectedObject = res[0]
                    } else {
                        CommonUtils.showToast(message: "Data not found".localize)
                        return
                    }
                    vc.data = data
                    UserData.shared.otherPatientDetails = OtherPatientDetailsModel()
                    UserData.shared.isReschedule = true
                    UserData.shared.old_date = String.getString(self.data?.doctorSlotInformation?.date)
                    UserData.shared.old_slot_id = String.getString(self.data?.doctorSlotInformation?.id)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
        }
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction private func buttonRebookingTapped(_ sender: Any) {
        globalApis.getDoctorDetails(doctorId: String.getString(data?.doctorID), communicationServiceId: String.getString(data?.doctorServiceFee?.id), slotId: String.getString(data?.slotID)){ data in
            guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: ViewDoctorProfileVC.getStoryboardID()) as? ViewDoctorProfileVC else { return }
            vc.searchResult = data
            UserData.shared.hospital_id = ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction private func buttonRatingTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: GiveRatingVC.getStoryboardID()) as? GiveRatingVC else { return }
        vc.data = self.data
        UserData.shared.hospital_id = ""
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func btnCheckInTapped(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: CheckInsListViewController.getStoryboardID()) as? CheckInsListViewController else { return }
        //vc.orderId = obj.order_id
        //vc.hasCameFrom = .viewPharmacyOrder
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction private func btnJoinByVideoTapped(_ sender: UIButton) {
        generateZoomLink()
    }
    
    @IBAction private func btnJoinByAudioTapped(_ sender: UIButton) {
        generateZoomLink()
    }
}

@available(iOS 15.0, *)
extension BookingFullDetailsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookingFullDetailsTVC.identifier, for: indexPath) as! BookingFullDetailsTVC
        cell.labelTitle.text = patientKeys[indexPath.row].localize
        //cell.labelValue.text = patientValues[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//extension booking {
//    func saveAddressApi(isSaving:Bool,isDelete:Bool = false, id:String = ""){
//        CommonUtils.showHudWithNoInteraction(show: true)
//        
//        var params:[String : Any] = [:]
//        var serviceUrl = ServiceName.addPatientAddress
//        if isSaving{
//            params = [ApiParameters.kAddress:String.getString(textFieldAddress.text),
//                      ApiParameters.kCity:String.getString(textFieldCity.text),
//                      ApiParameters.kPincode:String.getString(textFieldPinCode.text)]
//            serviceUrl = ServiceName.addPatientAddress
//            
//        }
//        if !isSaving{
//            params = [:]
//            serviceUrl = ServiceName.getPatientAddress
//        }
//        if isDelete{
//            
//            params = [ApiParameters.address_id:String.getString(id),
//                      ]
//            serviceUrl = ServiceName.deleteAddress
//        }
//        
//        TANetworkManager.sharedInstance.requestApi(withServiceName:serviceUrl,                                                   requestMethod: .POST,
//                                                   requestParameters:params, withProgressHUD: false)
//        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
//            
//            CommonUtils.showHudWithNoInteraction(show: false)
//            
//            if errorType == .requestSuccess {
//                
//                let dictResult = kSharedInstance.getDictionary(result)
//                switch Int.getInt(statusCode) {
//                case 200:
//                    if Int.getInt(dictResult["status"]) == 0{
//                        if isSaving{
//                            self?.isAddressToBeSaved = false
//                            self?.navigateToPaymentVC()
//                        }
//                        if !isSaving {
//                            let result = kSharedInstance.getArray(dictResult["result"])
//                           
//                            self?.savedAddress = result.map{
//                                        SavedAddressModel(data: kSharedInstance.getDictionary($0))
//                                   
//                            
//                        }
//                            let lat = kSharedUserDefaults.getAppLocation().lat
//                            let long = kSharedUserDefaults.getAppLocation().long
//                            self?.getLocationDetails(latitude: lat, longitude: long)
//                          
//                            
//                        
//                    }
//                        if isDelete{
//                            CommonUtils.showToast(message: "Address Deleted Successfully")
//                            self?.saveAddressApi(isSaving: false)
//                                                    }
//                    }
//                    else{
//                        CommonUtils.showToast(message: String.getString(dictResult["message"]))
//                    }
//                    
//                    
//                    
//                    
//                default:
//                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
//                }
//            } else if errorType == .noNetwork {
//                CommonUtils.showToast(message: kNoInternetMsg)
//                
//            } else {
//                CommonUtils.showToast(message: kDefaultErrorMsg)
//            }
//        }
//    }
@available(iOS 15.0, *)
extension BookingFullDetailsVC:GMSMapViewDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
    }
}

@available(iOS 15.0, *)
extension BookingFullDetailsVC {
    func generateZoomLink() {
        
        var params:[String : Any] = [
            ApiParameters.booking_id:String.getString(data?.id),
        ]
        
        CommonUtils.showHudWithNoInteraction(show: true)
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.generate_zoom_link,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { [self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    //            print(dictResult)
                    //            let zoom_url = kSharedInstance.getDictionary(dictResult["zoom_url"])
                    
                    var model:GenerateZoomUrlResponse?
                    let convertDicToJsonString =  try? JSONSerialization.data(withJSONObject: dictResult, options: [.prettyPrinted])
                    let jsonString = String(data: convertDicToJsonString!, encoding: .utf8)!
                    let jsonStringToData = Data(jsonString.utf8)
                    let decoder = JSONDecoder()
                    do {
                        model = try decoder.decode(GenerateZoomUrlResponse.self, from: jsonStringToData)
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    //              var zoomUrl = model?.zoomURL ?? ""
                    //              print(zoomUrl)
                    
                    //              presentJoinMeetingAlert()
                    if let meetingNumber = model?.zoomID, let password = model?.zoomPassword , let Url = model?.zoomURL{
//                        self.joinMeeting(meetingNumber: String(meetingNumber), meetingPassword: password)
                        self.joinZoomMeetingWithLink(meetingLink: Url)
                    }
                    
                case 400:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
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

// Conform ViewController to MobileRTCMeetingServiceDelegate.
// MobileRTCMeetingServiceDelegate listens to updates about meetings, such as meeting state changes, join attempt status, meeting errors, etc.
@available(iOS 15.0, *)
//extension BookingFullDetailsVC: MobileRTCMeetingServiceDelegate {
extension BookingFullDetailsVC {
    /// Puts user into ongoing Zoom meeting using a known meeting number and meeting password.
    ///
    /// Assign a MobileRTCMeetingServiceDelegate to listen to meeting events and join meeting status.
    ///
    /// - Parameters:
    ///   - meetingNumber: The meeting number of the desired meeting.
    ///   - meetingPassword: The meeting password of the desired meeting.
    /// - Precondition:
    ///   - Zoom SDK must be initialized and authorized.
    ///   - MobileRTC.shared().setMobileRTCRootController() has been called.
    
    func joinZoomMeetingWithLink(meetingLink: String) {
        if let url = URL(string: meetingLink) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Zoom app is not installed or the URL is invalid.")
            }
        } else {
            print("Invalid Zoom meeting link.")
        }
    }
    
//    func joinMeeting(meetingNumber: String, meetingPassword: String) {
//        // Obtain the MobileRTCMeetingService from the Zoom SDK, this service can start meetings, join meetings, leave meetings, etc.
//        if let meetingService = MobileRTC.shared().getMeetingService() {
//
//            // Set the ViewController to be the MobileRTCMeetingServiceDelegate
//            meetingService.delegate = self
//
//            // Create a MobileRTCMeetingJoinParam to provide the MobileRTCMeetingService with the necessary info to join a meeting.
//            // In this case, we will only need to provide a meeting number and password.
//            let joinMeetingParameters = MobileRTCMeetingJoinParam()
//            joinMeetingParameters.meetingNumber = meetingNumber
//            joinMeetingParameters.password = meetingPassword
//
//
//            // Call the joinMeeting function in MobileRTCMeetingService. The Zoom SDK will handle the UI for you, unless told otherwise.
//            // If the meeting number and meeting password are valid, the user will be put into the meeting. A waiting room UI will be presented or the meeting UI will be presented.
//            meetingService.joinMeeting(with: joinMeetingParameters)
//        }
//    }


    /// Logs user into their Zoom account using the user's Zoom email and password.
    ///
    /// Assign a MobileRTCAuthDelegate to listen to authorization events including onMobileRTCLoginReturn(_ returnValue: Int).
    ///
    /// - Parameters:
    ///   - email: The user's email address attached to their Zoom account.
    ///   - password: The user's password attached to their Zoom account.
    /// - Precondition:
    ///   - Zoom SDK must be initialized and authorized.
//    func logIn(email: String, password: String) {
//        // Obtain the MobileRTCAuthService from the Zoom SDK, this service can log in a Zoom user, log out a Zoom user, authorize the Zoom SDK etc.
//        if let authorizationService = MobileRTC.shared().getAuthService() {
//            // Call the login function in MobileRTCAuthService. This will attempt to log in the user.
//            //               authorizationService.login(withEmail: email, password: password, rememberMe: false)
//        }
//    }


    /// Creates alert for prompting the user to enter meeting number and password for joining a meeting.
    func presentJoinMeetingAlert() {
        let alertController = UIAlertController(title: "Join meeting".localize, message: "", preferredStyle: .alert)

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Meeting number".localize
            textField.keyboardType = .phonePad
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Meeting password".localize
            textField.keyboardType = .asciiCapable
            textField.isSecureTextEntry = true
        }

        let joinMeetingAction = UIAlertAction(title: "Join meeting".localize, style: .default, handler: { alert -> Void in
            let numberTextField = alertController.textFields![0] as UITextField
            let passwordTextField = alertController.textFields![1] as UITextField

            if let meetingNumber = numberTextField.text, let password = passwordTextField.text {
//                self.joinMeeting(meetingNumber: meetingNumber, meetingPassword: password)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel".localize, style: .default, handler: { (action : UIAlertAction!) -> Void in })

        alertController.addAction(joinMeetingAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }

    // Creates alert for prompting the user to enter their Zoom credentials for starting a meeting.
//    sfunc presentLogInAlert() {
//        let alertController = UIAlertController(title: "Log in".localize, message: "", preferredStyle: .alert)
//
//        alertController.addTextField { (textField : UITextField!) -> Void in
//            textField.placeholder = "Email".localize
//            textField.keyboardType = .emailAddress
//        }
//        alertController.addTextField { (textField : UITextField!) -> Void in
//            textField.placeholder = "Password".localize
//            textField.keyboardType = .asciiCapable
//            textField.isSecureTextEntry = true
//        }
//
//        let logInAction = UIAlertAction(title: "Log in".localize, style: .default, handler: { alert -> Void in
//            let emailTextField = alertController.textFields![0] as UITextField
//            let passwordTextField = alertController.textFields![1] as UITextField
//
//            if let email = emailTextField.text, let password = passwordTextField.text {
//                self.logIn(email: email, password: password)
//            }
//        })
//        let cancelAction = UIAlertAction(title: "Cancel".localize, style: .default, handler: { (action : UIAlertAction!) -> Void in })
//
//        alertController.addAction(logInAction)
//        alertController.addAction(cancelAction)
//
//        self.present(alertController, animated: true, completion: nil)
//    }

    // Is called upon in-meeting errors, join meeting errors, start meeting errors, meeting connection errors, etc.
//    func onMeetingError(_ error: MobileRTCMeetError, message: String?) {
//        switch error {
//        case .success:
//            print("Successful meeting operation.")
//        case .passwordError:
//            print("Could not join or start meeting because the meeting password was incorrect.")
//        default:
//            print("MobileRTCMeetError: \(error) \(message ?? "")")
//        }
//    }

    // Is called when the user joins a meeting.
    func onJoinMeetingConfirmed() {
        print("Join meeting confirmed.")
    }

    // Is called upon meeting state changes.
//    func onMeetingStateChange(_ state: MobileRTCMeetingState) {
//        print("Current meeting state: \(state)")
//    }
}

