//
//  DoctorProfileAboutVC.swift
//  Hlthera
//
//  Created by Prashant on 23/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

@available(iOS 15.0, *)
class DoctorProfileAboutVC: UIViewController, viewDoctorDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var backgroundView: UIView!
    @IBOutlet weak private var constraintTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak private var labelAbout: UILabel!
    @IBOutlet weak var noRatingImageview: UIImageView!
    @IBOutlet weak var awardsAndHonoursLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var coreCompetenciesLabel: UILabel!
    // MARK: - Stored Properties
    var selectedDoctor: DoctorDataModel?
    var ratings: [RatingModel] = []
    var appointmentTypeId: String = ""
    var appointmentType: String = ""
    var isSlotsAvailable: Bool = false
    var selectedSlotId: String = ""
    var selectedSlotDate: String = ""
    var selectedSlotTime: String = ""
    var isBook: Bool = true
    var chatTime: String = ""
    var doctorId: Int?
    let sender = ViewDoctorProfileVC()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        labelAbout.text = ""
        sender.viewDelegate = self
        noRatingImageview.isHidden = false
//        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            guard self != nil else { return }
            let obj = self?.selectedDoctor?.result
            self?.labelAbout.text = obj?.aboutUs?.localize
            self?.educationLabel.text = obj?.education?.localize
            self?.experienceLabel.text = (obj?.doctorExp?.count > 2) ? obj?.doctorExp?.localize : "\(String.getString(obj?.doctorExp) )".localize + " years of exp.".localize
            if self?.selectedDoctor?.result.ratingReviews?.isEmpty == true {
                self?.noRatingImageview.isHidden = false
            } else {
                self?.noRatingImageview.isHidden = true
            }
            self?.tableView.reloadData()
            CommonUtils.showHudWithNoInteraction(show: false)
        })
        configureReviews()
        getReviews()
    }
    
    private func configureReviews() {
        tableView.register(UINib(nibName: ReviewsAndRatingsTVC.identifier, bundle: nil), forCellReuseIdentifier: ReviewsAndRatingsTVC.identifier)
    }
    
    func updateModel(doctorId: Int) {
        self.doctorId = doctorId
    }
    
    private func showOptionsAlert() {
        //  1 for audio, 2 for video, 3 for chat, 4 for house and 5 for visit consultation
        let alertController = UIAlertController(title: "Select an Option", message: nil, preferredStyle: .alert)
        
        let option1Action = UIAlertAction(title: "Audio", style: .default) { [weak self] _ in
            guard let self = self else { return }
            // Handle Option 1 selection
            UserData.shared.appointmentType = "1"
            self.appointmentTypeId = "1"
            self.appointmentType = "audio"
            if let id = UserData.shared.doctorId {
                self.getDoctorTimeSlots(doctorId: id)
            }
        }
        alertController.addAction(option1Action)
        
        let option2Action = UIAlertAction(title: "Video", style: .default) { [weak self] _ in
            guard let self = self else { return }
            // Handle Option 2 selection
            UserData.shared.appointmentType = "2"
            self.appointmentTypeId = "2"
            self.appointmentType = "video"
            if let id = UserData.shared.doctorId {
                self.getDoctorTimeSlots(doctorId: id)
            }
        }
        alertController.addAction(option2Action)
        
        let option3Action = UIAlertAction(title: "Chat", style: .default) { [weak self] _ in
            guard let self = self else { return }
            // Handle Option 3 selection
            UserData.shared.appointmentType = "3"
            self.appointmentTypeId = "3"
            self.appointmentType = "chat"
            if let id = UserData.shared.doctorId {
                self.getDoctorTimeSlots(doctorId: id)
            }
        }
        alertController.addAction(option3Action)
        
        let option4Action = UIAlertAction(title: "Home", style: .default) { [weak self] _ in
            guard let self = self else { return }
            // Handle Option 4 selection
            UserData.shared.appointmentType = "4"
            self.appointmentTypeId = "4"
            self.appointmentType = "home"
            if let id = UserData.shared.doctorId {
                self.getDoctorTimeSlots(doctorId: id)
            }
        }
        alertController.addAction(option4Action)
        
        let option5Action = UIAlertAction(title: "Visit", style: .default) { [weak self] _ in
            guard let self = self else { return }
            // Handle Option 5 selection
            UserData.shared.appointmentType = "5"
            self.appointmentTypeId = "5"
            self.appointmentType = "visit"
            if let id = UserData.shared.doctorId {
                self.getDoctorTimeSlots(doctorId: id)
            }
        }
        alertController.addAction(option5Action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        //Present the alert controller
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func proceed() {
        if kSharedUserDefaults.isPractoEnabled() {
            saveDetails()
            //guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: AddSelfPatientDetails.getStoryboardID()) as? AddSelfPatientDetails else { return }
            //self.navigationController?.pushViewController(vc, animated: true)
            self.bookingApi(
                isHospital: String.getString(UserData.shared.hospital_id).isEmpty ? false : true,
                forOthers: String.getString(UserData.shared.otherPatientDetails?.other_patient_name).isEmpty ? false : true
            )
        } else if isBook {
            //let res = buttonsAppointmentTypes.filter{ $0.isSelected == true }
            if !appointmentTypeId.isEmpty {
                if isSlotsAvailable && selectedSlotId != "" {
                    //if chatTime != ""{
                    saveDetails()
                    //checkSlotsApi()
                    // }
                    // else {
                    //CommonUtils.showToast(message: "Please Select Chat Time")
                    //return
                    //}
                    self.bookingApi(
                        isHospital: String.getString(UserData.shared.hospital_id).isEmpty ? false : true,
                        forOthers: String.getString(UserData.shared.otherPatientDetails?.other_patient_name).isEmpty ? false : true
                    )
                } else {
                    CommonUtils.showToast(message: "Please Select Slots")
                    return
                }
            }
            else {
                CommonUtils.showToast(message: "Please Select Appointment Type")
                return
            }
        } else {
            if isSlotsAvailable && selectedSlotId != "" {
                if chatTime != "" {
                    saveDetails()
                    checkSlotsApi()
                } else {
                    CommonUtils.showToast(message: "Please Select Chat Time")
                    return
                }
            } else {
                CommonUtils.showToast(message: "Please Select Slots")
                return
            }
        }
    }
}

// MARK: - Actions
@available(iOS 15.0, *)
extension DoctorProfileAboutVC {
    @IBAction private func buttonReportProblemTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: ReportProblemVC.getStoryboardID()) as? ReportProblemVC else { return }
        vc.doctorId = "\(UserData.shared.doctorId ?? 0)"
        vc.hasCameFrom = .doctors
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func buttonBookTapped(_ sender: Any) {
        showOptionsAlert()
        //if selectedDoctor?.doctor_communication_services.count > 0 {
        //guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: DoctorBookingAppointmentVC.getStoryboardID()) as? DoctorBookingAppointmentVC else { return }
        //vc.selectedCommunication = "call_sm"
        //vc.data = result
        //vc.isBook = true
        //UserData.shared.otherPatientDetails = OtherPatientDetailsModel()
        //self.navigationController?.pushViewController(vc, animated: true)
        //} else {
        //CommonUtils.showToast(message: "No services available for booking, please try again later".localize)
        //return
        //}
    }
    
    @IBAction private func buttonBookForOthersTapped(_ sender: Any) {
        //if selectedDoctor?.result.doctorCommunicationServices?.count > 0 {
        let vc = AddOtherPopupVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.onContinue = { [weak self] in
            guard let self = self else { return }
            guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: AddOtherPatientDetails.getStoryboardID()) as? AddOtherPatientDetails else { return }
            vc.data = .init(status: 200, message: "", result: UserData.shared.doctorData ?? .init(doctorID: self.doctorId ?? 0, slotArray: .init(slots: [])))
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.present(vc, animated: true)
        //        } else {
        //            CommonUtils.showToast(message: "No services available for booking, please try again later".localize)
        //            return
        //        }
    }
}

// MARK: - UITableView Delegate & DataSource
@available(iOS 15.0, *)
extension DoctorProfileAboutVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDoctor?.result.ratingReviews?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsAndRatingsTVC", for: indexPath) as! ReviewsAndRatingsTVC
        cell.selectionStyle = .none
        let obj = selectedDoctor!.result.ratingReviews
        if obj!.indices.contains(indexPath.row){
            if obj![indexPath.row].ratingType == "username"{
                cell.labelComment?.text = obj![indexPath.row].comments?.localize
                cell.labelUsername.text = (obj![indexPath.row].firstName ?? "") + " " + (obj![indexPath.row].lastName ?? "")
//                cell.imageProfile.downlodeImage(serviceurl: obj![indexPath.row]., placeHolder: UIImage(named: "placeholder"))
                let rating = obj![indexPath.row].ratings
                cell.stackViewRatings.setRatings(value: rating ?? 0)
            }
            else{
                cell.labelComment?.text = obj![indexPath.row].comments?.localize
                cell.labelUsername.text = "Anonymous".localize
                let rating = obj![indexPath.row].ratings
                cell.stackViewRatings.setRatings(value: rating ?? 0)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Reviews
@available(iOS 15.0, *)
extension DoctorProfileAboutVC {
    func getReviews() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params: [String: Any] = [:]
        TANetworkManager.sharedInstance.requestApi(
            withServiceName: ServiceName.ratingList,
            requestMethod: .POST,
            requestParameters: params,
            withProgressHUD: false
        ) { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0 {
                        let data = kSharedInstance.getArray(dictResult["result"])
                        self?.ratings =  data.map {
                            RatingModel(data:kSharedInstance.getDictionary($0))
                        }
                        self?.tableView.reloadData()
                    } else {
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

@available(iOS 15.0, *)
extension DoctorProfileAboutVC {
    func getDoctorTimeSlots(doctorId: Int) {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params: [String: Any] = [
            //ApiParameters.page:String.getString(page),
            //ApiParameters.limit:String.getString(limit),
            ApiParameters.doctor_id: doctorId
        ]
        TANetworkManager.sharedInstance.requestApi(
            withServiceName: ServiceName.getDoctorTimeSlots,
            requestMethod: .POST,
            requestParameters: params,
            withProgressHUD: false
        ) { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                //print(result)
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    var model: TimeSoltResponse?
                    let convertDicToJsonString =  try? JSONSerialization.data(withJSONObject: dictResult, options: [.prettyPrinted])
                    let jsonString = String(data: convertDicToJsonString!, encoding: .utf8)!
                    let jsonStringToData = Data(jsonString.utf8)
                    let decoder = JSONDecoder()
                    do {
                        model = try decoder.decode(TimeSoltResponse.self, from: jsonStringToData)
                    } catch {
                        print(error.localizedDescription)
                    }
                    //print(model?.timeslots)
                    //if model?.status == 1 {
                    //else {
                    //CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    //}
                    self?.navigateToViewControlletTimeSlots(practoSltos: model)
                    break
                default:
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    break
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToast(message: kNoInternetMsg)
            } else {
                CommonUtils.showToast(message: kDefaultErrorMsg)
            }
        }
    }
}

@available(iOS 15.0, *)
extension DoctorProfileAboutVC {
    func bookingApi(isHospital: Bool, forOthers: Bool) {
        //var gender = ""
        //if self.buttonsGender[0].isSelected{
        //    gender =  "1"
        //}else if
        //    self.buttonsGender[1].isSelected{
        //    gender = "2"
        //}else{
        //    gender = "3"
        //}
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let obj = UserData.shared
        var images: [[String: Any]] = []
        
        var params: [String: Any] = [
            ApiParameters.appointment_type: String.getString(obj.selectedSlotModel?.appointment_type),
            ApiParameters.slot_id: String.getString(obj.selectedSlotModel?.slot_id),
            ApiParameters.date: String.getString(obj.selectedSlotModel?.date),
            ApiParameters.doctor_id: String(Int(truncating: (obj.selectedSlotModel?.doctor_id.toEnglishNumber())!)),
            ApiParameters.patient_countryCode: String.getString(obj.patientDetails?.patient_countryCode),
            ApiParameters.is_save_adress: obj.patientDetails?.is_save_address ?? false ? "1" : "0",
            ApiParameters.old_date: String.getString(obj.old_date),
            ApiParameters.old_slot_id: String.getString(obj.old_slot_id),
            ApiParameters.slot_time: String.getString(obj.selectedSlotModel?.slot_time),
            ApiParameters.is_reschedule: obj.isReschedule ? "1" : "0"
        ]
        
        params[ApiParameters.kAddress] = String.getString(obj.patientDetails?.address)
        params[ApiParameters.kCity] = String.getString(obj.patientDetails?.city)
        params[ApiParameters.kPincode] = String.getString(obj.patientDetails?.pincode)
        params[ApiParameters.is_future_address] = obj.patientDetails?.is_future_address ?? false ? "1" : "0"
        
        
        if kSharedUserDefaults.isPractoEnabled(){
            let dateAsString = obj.selectedSlotModel?.slot_time
            //        let dateAsString = "1:15 PM"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.locale = Locale(identifier: "en_US")
            let date = dateFormatter.date(from: dateAsString!)
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.locale = Locale(identifier: "en_US")
            let Date24 = dateFormatter.string(from: date!)
            let dateToFormateIso = (obj.selectedSlotModel?.date)! + "T" + Date24 + ":00Z"
            print(dateToFormateIso)
            params[ApiParameters.insta_hms_slot] = String.getString(dateToFormateIso)
            params.updateValue(String.getString(obj.selectedSlotModel?.fees), forKey:  ApiParameters.fees)
            params.updateValue(String.getString(obj.selectedSlotModel?.total_amount), forKey:  ApiParameters.total_amount)
            params.updateValue(String.getString(obj.patientDetails?.patient_name), forKey:  ApiParameters.patient_name)
            //params.updateValue(String.getString(gender), forKey:  ApiParameters.patient_gender)
            //params.updateValue(String.getString(textFieldEmail.text), forKey:  ApiParameters.patient_email)
            //params.updateValue(String.getString(textFieldMobile.text), forKey:  ApiParameters.patient_mobile)
            //params.updateValue(String.getString(selectedSavedAddress?.id), forKey:  ApiParameters.address_id)
            params.updateValue(String.getString(obj.patientDetails?.patient_name), forKey:  ApiParameters.patient_name)
            params.updateValue(String.getString(obj.patientDetails?.address_id), forKey:  ApiParameters.address_id)
            params.updateValue(String.getString(obj.patientDetails?.patient_mobile), forKey:  ApiParameters.patient_mobile)
            //ApiParameters.fees:String.getString(obj.selectedSlotModel?.fees)
            //ApiParameters.total_amount:String.getString(obj.selectedSlotModel?.total_amount),
            //ApiParameters.patient_name:String.getString(textFieldPatientName.text),
            //ApiParameters.patient_age:String.getString(textFieldAge.text),
            //ApiParameters.patient_gender:String.getString(gender),
            //ApiParameters.patient_email:String.getString(textFieldEmail.text),
            //ApiParameters.patient_mobile:String.getString(textFieldMobile.text),
            //ApiParameters.address_id:String.getString(selectedSavedAddress?.id)
        } else {
            //ApiParameters.patient_age:String.getString(obj.patientDetails?.patient_age),
            //ApiParameters.patient_gender:String.getString(obj.patientDetails?.patient_gender),
            //ApiParameters.patient_email:String.getString(obj.patientDetails?.patient_email),
            //ApiParameters.patient_mobile:String.getString(obj.patientDetails?.patient_mobile)
            //ApiParameters.address_id:String.getString(obj.patientDetails?.address_id),
            
            params[ApiParameters.patient_name] = String.getString(obj.patientDetails?.patient_name)
            params[ApiParameters.patient_age] = String.getString(obj.patientDetails?.patient_age)
            params[ApiParameters.patient_gender] = String.getString(obj.patientDetails?.patient_gender)
            params[ApiParameters.patient_email] = String.getString(obj.patientDetails?.patient_email)
            params[ApiParameters.patient_mobile] = String.getString(obj.patientDetails?.patient_mobile)
            params[ApiParameters.address_id] = String.getString(obj.patientDetails?.address_id)
            images.append(["imageName":ApiParameters.other_patient_imageFront,"image":UserData.shared.otherPatientDetails?.other_patient_imageFront ?? UIImage()])
            images.append(["imageName":ApiParameters.other_patient_imageBack,"image":UserData.shared.otherPatientDetails?.other_patient_imageBack ?? UIImage()])
            if forOthers {
                params[ApiParameters.other_patient_name] = String.getString(obj.otherPatientDetails?.other_patient_name)
                params[ApiParameters.other_patient_age]  = String.getString(obj.otherPatientDetails?.other_patient_age)
                params[ApiParameters.other_patient_relation]  = String.getString(obj.otherPatientDetails?.other_patient_relation)
                params[ApiParameters.other_patient_insurance]  = String.getString(obj.otherPatientDetails?.other_patient_insurance)
                params[ApiParameters.other_patient_mobile]  = String.getString(obj.otherPatientDetails?.other_patient_mobile)
                params[ApiParameters.other_notes]  = String.getString(obj.otherPatientDetails?.other_notes)
                params[ApiParameters.isOtherKey] = "1"
                params[ApiParameters.other_patient_gender]  = String.getString(obj.otherPatientDetails?.other_patient_gender)
                params[ApiParameters.other_patient_email]  = String.getString(obj.otherPatientDetails?.other_email)
                params[ApiParameters.other_patient_countryCode]  = String.getString(obj.otherPatientDetails?.other_patient_countryCode)
            } else if isHospital {
                params[ApiParameters.isHospitalBooking] = "1"
                forOthers ? () : (params[ApiParameters.isOtherKey] = "0")
                params[ApiParameters.hospital_id] = String.getString(obj.hospital_id)
            } else {
                params[ApiParameters.isHospitalBooking] = "0"
                params[ApiParameters.isOtherKey] = "0"
            }
        }
        TANetworkManager.sharedInstance.requestMultiPart(
            withServiceName: ServiceName.bookAppointment,
            requestMethod: .post,
            requestImages: images,
            requestVideos: [:],
            requestData: params
        ) { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0 {
                        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        vc.popUpDescription = "Booking has been successfully done"
                        vc.callback = { [weak self] in
                            guard let self = self else { return }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                                self.dismiss(animated: true, completion: {
                                    UserData.shared.isReschedule = false
                                    kSharedAppDelegate?.moveToHomeScreen()
                                })
                            })
                        }
                        self?.navigationController?.present(vc, animated: true)
                    } else {
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

@available(iOS 15.0, *)
extension DoctorProfileAboutVC {
    func navigateToViewControlletTimeSlots(practoSltos: TimeSoltResponse?) {
        if (practoSltos?.timeslots?.isEmpty ?? true) {
            guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: AppointmentSlotVC.getStoryboardID()) as? AppointmentSlotVC else { return }
            vc.slots = UserData.shared.doctorData?.slotArray?.slots.filter { $0.slotType == self.appointmentType } ?? []
            isSlotsAvailable = true
            if vc.slots.isEmpty {
                isSlotsAvailable = false
                CommonUtils.showToast(message: "No Slots Found, please select another service.")
                return
            }
            vc.callback = { [weak self] id, date, time in
                guard let self = self else { return }
                if date != "" {
                    self.selectedSlotId = id
                    self.selectedSlotDate = date
                    self.isSlotsAvailable = true
                    self.selectedSlotTime = time
                    self.proceed()
                    //self.buttonSlots.setTitle("Selected Slot for \(date)", for: .normal)
                    //self.buttonSlots.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
            kSharedUserDefaults.setPractoEnabled(isPractoEnabled: false)
        } else {
            kSharedUserDefaults.setPractoEnabled(isPractoEnabled: true)
            var slots: [SlotTimeDateItem] = []
            practoSltos?.timeslots?.forEach({ isoDate in
                let isoFormatter = DateFormatter()
                let dateFormatter = DateFormatter()
                let timeFormatter = DateFormatter()
                isoFormatter.locale = Locale(identifier: "en_US")
                isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.locale = Locale(identifier: "en_US")
                //timeFormatter.dateFormat = "HH:mm:ss a"
                timeFormatter.dateFormat = "HH:mm a"
                timeFormatter.locale = Locale(identifier: "en_US")
                let dateIso = isoFormatter.date(from: isoDate)
                let time = timeFormatter.string(from: dateIso!)
                let date = dateFormatter.string(from: dateIso!)
                let slot = SlotTimeDateItem(time: time, date: date)
                slots.append(slot)
            })
            guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PractoTimeSlotVC.getStoryboardID()) as? PractoTimeSlotVC else { return }
            vc.slots = slots
            isSlotsAvailable = true
            if vc.slots.isEmpty {
                isSlotsAvailable = false
                CommonUtils.showToast(message: "No Slots Found for, please select another service.")
                return
            }
            vc.callback = { [weak self] id, date, time in
                guard let self = self else { return }
                if date != "" {
                    self.selectedSlotId = id
                    self.selectedSlotDate = date
                    self.isSlotsAvailable = true
                    self.selectedSlotTime = time
                    //self.buttonSlots.setTitle("Selected Slot for \(date)", for: .normal)
                    //self.buttonSlots.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                    self.proceed()
                }
            }
            //vc.slots = mappedSlots
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func checkSlotsApi() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let obj = UserData.shared.selectedSlotModel
        //print(selectedSlotTime)
        //print(selectedSlotDate)
        //let dateAsString = selectedSlotTime
        //let dateAsString = "1:15 PM"
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "h:mm a"
        //dateFormatter.locale = Locale(identifier: "en_US")
        //let date = dateFormatter.date(from: dateAsString)
        //dateFormatter.dateFormat = "HH:mm"
        //let Date24 = dateFormatter.string(from: date!)
        //let dateToFormateIso = self.selectedSlotDate + "T" + Date24 + ":00Z"
        //print(dateToFormateIso)
        //return
        let params:[String : Any] = [
            ApiParameters.appointment_type: String.getString(obj?.appointment_type),
            ApiParameters.isHospitalBooking: String.getString(UserData.shared.hospital_id).isEmpty ? "0" : "1",
            ApiParameters.hospital_id: String.getString(UserData.shared.hospital_id),
            ApiParameters.doctor_id: String.getString(obj?.doctor_id),
            ApiParameters.date: String.getString(obj?.date),
            ApiParameters.slot_id: String.getString(obj?.slot_id)
        ]
        
        TANetworkManager.sharedInstance.requestApi(
            withServiceName: ServiceName.checkSlotAvailablity,
            requestMethod: .POST,
            requestParameters: params,
            withProgressHUD: false
        ) { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0 {
                        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: AddSelfPatientDetails.getStoryboardID()) as? AddSelfPatientDetails else { return }
                        self?.navigationController?.pushViewController(vc, animated: true)
                    } else {
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
    
    func saveDetails() {
        //  1 for audio, 2 for video, 3 for chat, 4 for house and 5 for visit consultation
        UserData.shared.selectedSlotModel = selectedSlotModel(
            appointment_type: appointmentTypeId,
            slot_id: selectedSlotId,
            date: selectedSlotDate,
            doctor_id: String.getString(UserData.shared.doctorData?.doctorID),
            fees: String.getString(UserData.shared.doctorData?.doctorCommunicationServices?.first?.commDurationFee),
            total_amount: String.getString(String.getString((Double.getDouble(UserData.shared.doctorData?.doctorCommunicationServices?.first?.commDurationFee)/100 * 5) + (Double.getDouble(UserData.shared.doctorData?.doctorCommunicationServices?.first?.commDurationFee)))),
            slot_time: selectedSlotTime
        )
    }
}
