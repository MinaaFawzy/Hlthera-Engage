//
//  DoctorBookingAppointmentVC.swift
//  Hlthera
//
//  Created by Prashant on 07/01/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit
import DropDown

class DoctorBookingAppointmentVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak private var lblTitle: UILabel!
    @IBOutlet weak private var constraintIconHeight: NSLayoutConstraint!
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak private var labelDoctorName: UILabel!
    @IBOutlet weak private var labelDoctorSpecility: UILabel!
    @IBOutlet weak private var labelDoctorEducation: UILabel!
    @IBOutlet weak private var labelConsultationFee: UILabel!
    @IBOutlet weak private var labelExperience: UILabel!
    @IBOutlet weak private var imageSelectedCommunication: UIImageView!
    @IBOutlet weak private var imageDoctor: UIImageView!
    @IBOutlet weak private var labelConsultationFeeValue: UILabel!
    @IBOutlet weak private var labelTaxFeeValue: UILabel!
    @IBOutlet weak private var labelTotalAmountValue: UILabel!
    @IBOutlet weak private var viewPaymentDetails: UIView!
    @IBOutlet weak private var constraintHideType: NSLayoutConstraint!
    @IBOutlet weak private var constraintUnHideType: NSLayoutConstraint!
    @IBOutlet weak private var labelSelectAppoinntment: UILabel!
    @IBOutlet weak private var buttonSlots: UIButton!
    @IBOutlet weak private var labelRating: UILabel!
    @IBOutlet var buttonsAppointmentTypes: [UIButton]!
    @IBOutlet var stackViews: [UIView]!
    
    // MARK: - Stored Proeprties
    var data: DoctorDetailsModel?
    var selectedCommunication:String = ""
    var selectedObject: DoctorCommunicationModel?
    var isBook = false
    var dropDown = DropDown()
    var chatTime = ""
    var isSlotsAvailable = false
    var selectedSlotId = ""
    var selectedSlotDate = ""
    var selectedSlotTime = ""
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        lblTitle.font = .corbenRegular(ofSize: 15)
        kSharedUserDefaults.setPractoEnabled(isPractoEnabled: false)
        //print("selectedObject = \(self.data?.doctor_id)")
        //print("selectedObject = \(self.data?.doctorDetailInfo?.doctor_id)")
        //print("selectedObject = \(self.selectedObject?.)")
        
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        if isBook {
            constraintUnHideType.isActive = true
            constraintUnHideType.constant = 15
            constraintHideType.isActive = false
            stackView.isHidden = false
            self.labelSelectAppoinntment.isHidden = false
            self.stackViews.forEach { $0.isHidden = false }
            constraintIconHeight.constant = 0
            self.viewPaymentDetails.isHidden = true
        } else {
            constraintHideType.isActive = true
            constraintHideType.constant = 15
            constraintUnHideType.isActive = false
            self.labelSelectAppoinntment.isHidden = true
            self.stackViews.forEach { $0.isHidden = true }
            updateFeeDetails(type: String.getString(selectedObject?.comm_service_type))
        }
        self.labelDoctorName.text = data?.doctor_name
        if let obj = data {
            if !obj.doctor_specialities.isEmpty {
                self.labelDoctorSpecility.text = data?.doctor_specialities[0].full_name
            }
            if !obj.doctor_qualifications.isEmpty{
                self.labelDoctorEducation.text = data?.doctor_qualifications[0].name
            }
        }
        
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.addArrangedSubview(spacerView)
        if String.getString(data?.doctor_exp).isEmpty{
            self.labelExperience.text = "No Experience Found".localize
        }
        else {
            self.labelExperience.text = String.getString(data?.doctor_exp) + " years of exp.".localize
        }
        self.labelRating.text = String.getString(data?.ratings)
        self.imageDoctor.downlodeImage(serviceurl: String.getString(data?.doctor_profile), placeHolder: UIImage(named: "placeholder"))
        switch selectedCommunication{
        case "audio" :
            self.imageSelectedCommunication.image = UIImage(named: ServiceIconIdentifiers.audio) ?? UIImage(named: "placeholder")
        case "video":
            self.imageSelectedCommunication.image = UIImage(named: ServiceIconIdentifiers.video) ?? UIImage(named: "placeholder")
        case "chat":
            self.imageSelectedCommunication.image = UIImage(named: ServiceIconIdentifiers.chat) ?? UIImage(named: "placeholder")
        case "home":
            self.imageSelectedCommunication.image = UIImage(named: ServiceIconIdentifiers.home) ?? UIImage(named: "placeholder")
        case "visit":
            self.imageSelectedCommunication.image = UIImage(named: ServiceIconIdentifiers.clinic) ?? UIImage(named: "placeholder")
        default:break
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func updateButton(sender: UIButton, value: Bool) {
        sender.isSelected = value
        if sender.isSelected {
            buttonSlots.setTitle("Select Slots".localize, for: .normal)
            buttonSlots.setTitleColor(UIColor.lightGray, for: .normal)
            self.selectedSlotId = ""
        }
        
    }
    
    func updateFeeDetails(type: String) {
        let res = data?.doctor_communication_services.filter {
            $0.comm_service_type == type
        }
        if res?.indices.contains(0) ?? false {
            self.selectedObject = res?[0]
        } else {
            CommonUtils.showToast(message: "Service Unavailable".localize)
            return
        }
        if Int.getInt(selectedObject?.comm_duration_fee) == 0 {
            viewPaymentDetails.isHidden = true
        } else {
            viewPaymentDetails.isHidden = false
            self.labelConsultationFeeValue.text = selectedObject?.comm_duration_fee
            self.labelTaxFeeValue.text = String.getString(Double.getDouble(selectedObject?.comm_duration_fee)/100 * 5)
            self.labelTotalAmountValue.text = String.getString((Double.getDouble(selectedObject?.comm_duration_fee)/100 * 5) + (Double.getDouble(selectedObject?.comm_duration_fee)))
        }
    }
    
    func saveDetails() {
        var appointmentType = ""
        //  1 for audio, 2 for video, 3 for chat, 4 for house and 5 for visit consultation
        switch self.selectedObject?.comm_service_type{
        case "audio": appointmentType = "1"
        case "video": appointmentType = "2"
        case "chat": appointmentType = "3"
        case "home": appointmentType = "4"
        case "visit": appointmentType = "5"
        default:break
        }
        UserData.shared.selectedSlotModel = selectedSlotModel(appointment_type:appointmentType, slot_id: selectedSlotId, date: selectedSlotDate, doctor_id: String.getString(data?.doctor_id), fees: String.getString(self.labelConsultationFeeValue.text), total_amount: String.getString(self.labelTotalAmountValue.text),slot_time :selectedSlotTime)
    }
}

// MARK: - ACtions
extension DoctorBookingAppointmentVC {
    @IBAction private func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func buttonVideoCallTapped(_ sender: UIButton) {
        buttonsAppointmentTypes.forEach {
            updateButton(sender: $0, value:false)
        }
        updateButton(sender: sender, value:true)
        updateFeeDetails(type: "video")
    }
    
    @IBAction private func buttonCallTapped(_ sender: UIButton) {
        buttonsAppointmentTypes.forEach {
            updateButton(sender: $0, value:false)
        }
        updateButton(sender: sender, value:true)
        updateFeeDetails(type: "audio")
    }
    
    @IBAction private func buttonChatTapped(_ sender: UIButton) {
        buttonsAppointmentTypes.forEach {
            updateButton(sender: $0, value:false)
        }
        updateButton(sender: sender, value:true)
        updateFeeDetails(type: "chat")
    }
    
    @IBAction private func buttonHomeVisitTapped(_ sender: UIButton) {
        buttonsAppointmentTypes.forEach {
            updateButton(sender: $0, value:false)
        }
        updateButton(sender: sender, value:true)
        updateFeeDetails(type: "home")
    }
    
    @IBAction private func buttonClinicVisitTapped(_ sender: UIButton) {
        buttonsAppointmentTypes.forEach {
            updateButton(sender: $0, value:false)
        }
        updateButton(sender: sender, value:true)
        updateFeeDetails(type: "visit")
        
    }
    
    @IBAction private func buttonSelectSlotsTapped(_ sender: Any) {
        if selectedObject == nil {
            CommonUtils.showToast(message: "Please Select appointment Type")
            return
        } else {
            //if Int.getInt(selectedObject?.comm_duration_fee) == 0{
            //CommonUtils.showToast(message: "This service is not available for booking")
            //return
            //}
            //else{
            //getDoctorTimeSlots(doctorId: 0)
            //}
            getDoctorTimeSlots(doctorId: Int.getInt(data?.doctor_id.toEnglishNumber()))
            //getDoctorTimeSlots(doctorId: 141)
        }
    }
    
    @IBAction private func buttonSelectChatTimeTapped(_ sender: UIButton) {
        dropDown.anchorView = sender
        dropDown.dataSource = ["60 Minutes"]
        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
            sender.setTitle(item, for: .normal)
            sender.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.chatTime = item
        }
        dropDown.width = sender.frame.width
        dropDown.show()
    }
    
    @IBAction private func buttonProceedTapped(_ sender: Any) {
        if kSharedUserDefaults.isPractoEnabled() {
            saveDetails()
            //guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: AddSelfPatientDetails.getStoryboardID()) as? AddSelfPatientDetails else { return }
            //self.navigationController?.pushViewController(vc, animated: true)
            self.bookingApi(
                isHospital: String.getString(UserData.shared.hospital_id).isEmpty ? false : true,
                forOthers: String.getString(UserData.shared.otherPatientDetails?.other_patient_name).isEmpty ? false : true
            )
        } else if isBook {
            let res = buttonsAppointmentTypes.filter{ $0.isSelected == true }
            if !res.isEmpty {
                if isSlotsAvailable && selectedSlotId != "" {
                    //if chatTime != ""{
                    saveDetails()
                    //checkSlotsApi()
                    // }
                    // else {
                    //     CommonUtils.showToast(message: "Please Select Chat Time")
                    //     return
                    // }
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

extension DoctorBookingAppointmentVC {
    func navigateToViewControlletTimeSlots(practoSltos: TimeSoltResponse?) {
        if ((practoSltos?.timeslots?.isEmpty)!) {
            guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: AppointmentSlotVC.getStoryboardID()) as? AppointmentSlotVC else { return }
           // vc.slots = data?.slots.filter{ $0.slot_type == self.selectedObject?.comm_service_type } ?? []
            isSlotsAvailable = true
            if vc.slots.isEmpty {
                isSlotsAvailable = false
                CommonUtils.showToast(message: "No Slots Found for \(String.getString(selectedObject?.comm_service_type)), please select another service.")
                return
            }
            vc.callback = { [weak self] id, date, time in
                guard let self = self else { return }
                if date != "" {
                    self.selectedSlotId = id
                    self.selectedSlotDate = date
                    self.isSlotsAvailable = true
                    self.selectedSlotTime = time
                    self.buttonSlots.setTitle("Selected Slot for \(date)", for: .normal)
                    self.buttonSlots.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
            kSharedUserDefaults.setPractoEnabled(isPractoEnabled: false)
        } else {
            kSharedUserDefaults.setPractoEnabled(isPractoEnabled: true)
            var slots:[SlotTimeDateItem] = []
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
                
                var dateIso = isoFormatter.date(from: isoDate)
                var time = timeFormatter.string(from: dateIso!)
                var date = dateFormatter.string(from: dateIso!)
                
                var slot = SlotTimeDateItem(time: time, date: date)
                slots.append(slot)
                
            })
            guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PractoTimeSlotVC.getStoryboardID()) as? PractoTimeSlotVC else { return }
            vc.slots = slots
            isSlotsAvailable = true
            if vc.slots.isEmpty {
                isSlotsAvailable = false
                CommonUtils.showToast(message: "No Slots Found for \(String.getString(selectedObject?.comm_service_type)), please select another service.")
                return
            }
            vc.callback = { [weak self] id, date, time in
                guard let self = self else { return }
                if date != "" {
                    self.selectedSlotId = id
                    self.selectedSlotDate = date
                    self.isSlotsAvailable = true
                    self.selectedSlotTime = time
                    self.buttonSlots.setTitle("Selected Slot for \(date)", for: .normal)
                    self.buttonSlots.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                }
            }
            //vc.slots = mappedSlots
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func checkSlotsApi() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let obj = UserData.shared.selectedSlotModel
        print(selectedSlotTime)
        print(selectedSlotDate)
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
            ApiParameters.appointment_type:String.getString(obj?.appointment_type),
            ApiParameters.isHospitalBooking:String.getString(UserData.shared.hospital_id).isEmpty ? "0" : "1",
            ApiParameters.hospital_id:String.getString(UserData.shared.hospital_id),
            ApiParameters.doctor_id:String.getString(obj?.doctor_id),
            ApiParameters.date:String.getString(obj?.date),
            ApiParameters.slot_id:String.getString(obj?.slot_id)
        ]
        
        TANetworkManager.sharedInstance.requestApi(
            withServiceName: ServiceName.checkSlotAvailablity,
            requestMethod: .POST,
            requestParameters: params,
            withProgressHUD: false
        )
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
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
}

extension DoctorBookingAppointmentVC {
    func getDoctorTimeSlots(doctorId: Int) {
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [
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
                    //if model?.status == 1{
                    //else{
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

extension DoctorBookingAppointmentVC {
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
        
        var params:[String : Any] = [
            ApiParameters.appointment_type:String.getString(obj.selectedSlotModel?.appointment_type),
            ApiParameters.slot_id:String.getString(obj.selectedSlotModel?.slot_id),
            ApiParameters.date:String.getString(obj.selectedSlotModel?.date),
            ApiParameters.doctor_id:String(Int(truncating: (obj.selectedSlotModel?.doctor_id.toEnglishNumber())!)),
            ApiParameters.patient_countryCode:String.getString(obj.patientDetails?.patient_countryCode),
            ApiParameters.is_save_adress:obj.patientDetails?.is_save_address ?? false ? "1" : "0",
            ApiParameters.old_date:String.getString(obj.old_date),
            ApiParameters.old_slot_id:String.getString(obj.old_slot_id),
            ApiParameters.slot_time:String.getString(obj.selectedSlotModel?.slot_time),
            ApiParameters.is_reschedule:obj.isReschedule ? "1" : "0"
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
            //            ApiParameters.patient_age:String.getString(obj.patientDetails?.patient_age),
            //            ApiParameters.patient_gender:String.getString(obj.patientDetails?.patient_gender),
            //           ApiParameters.patient_email:String.getString(obj.patientDetails?.patient_email),
            //           ApiParameters.patient_mobile:String.getString(obj.patientDetails?.patient_mobile)
            //        ApiParameters.address_id:String.getString(obj.patientDetails?.address_id),
            
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
                        vc.popUpDescription = "Payment has been successfully done"
                        vc.callback = { [weak self] in
                            guard let self = self else { return }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { [weak self] in
                                guard let self = self else { return }
                                self.dismiss(animated: true, completion: { [weak self] in
                                    guard let self = self else { return }
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
