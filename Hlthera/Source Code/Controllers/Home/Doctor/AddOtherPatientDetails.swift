//
//  AddOtherPatientDetails.swift
//  Hlthera
//
//  Created by Prashant Panchal on 20/01/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import DropDown

@available(iOS 15.0, *)
class AddOtherPatientDetails: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var imageCountryCode: UIImageView!
    @IBOutlet private weak var buttonCountryCode: UIButton!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var buttonRemoveFrontImage: UIButton!
    @IBOutlet private weak var textFieldName: UITextField!
    @IBOutlet private weak var textFieldAge: UITextField!
    @IBOutlet private weak var textFieldMobile: UITextField!
    @IBOutlet private weak var textFieldInsuranceNumber: UITextField!
    @IBOutlet private weak var imageFront: UIImageView!
    @IBOutlet private weak var textView: IQTextView!
    @IBOutlet private weak var buttonRemoveBackImage: UIButton!
    @IBOutlet private weak var textFieldEmail: UITextField!
    @IBOutlet private weak var imageBack: UIImageView!
    @IBOutlet var buttonsBookingType: [UIButton]!
    @IBOutlet var buttonsGender: [UIButton]!
    @IBOutlet var buttonsGenderImage: [UIButton]!
    
    // MARK: - Stored properties
    var relation = ""
    var dropDown = DropDown()
    var cameFrom = -1
    var selectedBooking = ""
    var selectedCommunication = ""
    var data: DoctorDataModel?
    var appointmentTypeId: String = ""
    var appointmentType: String = ""
    var isSlotsAvailable = false
    var selectedSlotId = ""
    var selectedSlotDate = ""
    var selectedSlotTime = ""
    var isBook = true
    var chatTime = ""
    var genderMale: Bool = false
    var genderSelected: Bool = false
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        lblTitle.font = .corbenRegular(ofSize: 15)
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        buttonRemoveBackImage.isHidden = true
        buttonRemoveFrontImage.isHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: - Methods
    func validateFields() {
        if String.getString(textFieldName.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Patient Name".localize)
            return
        }
        if String.getString(textFieldAge.text).isEmpty {
            CommonUtils.showToast(message: "Please Enter Patient Age".localize)
            return
        }
//        if Int.getInt(textFieldAge.text) < 1 || Int.getInt(textFieldAge.text) > 18 {
//            CommonUtils.showToast(message: "Please Enter Valid Patient Age".localize)
//            return
//        }
//        let genderStatus =  buttonsGender.filter{ $0.isSelected == true }
//        if !genderSelected {
//            CommonUtils.showToast(message: "Please Select Patient Gender".localize)
//
//            return
//        }
        if relation.isEmpty {
            CommonUtils.showToast(message: "Please select Patient Relation".localize)
            return
        }
        if String.getString(textFieldMobile.text).isEmpty {
            CommonUtils.showToast(message: "Please Enter Patient Mobile Number".localize)
            return
        }
        if !String.getString(textFieldMobile.text).isPhoneNumber() {
            CommonUtils.showToast(message: "Please Enter Valid Patient Mobile Number".localize)
            return
        }
//        if String.getString(textFieldEmail.text).isEmpty {
//            CommonUtils.showToast(message: "Please Enter Patient Email Address".localize)
//            return
//        }
//        if !String.getString(textFieldEmail.text).isEmail() {
//            CommonUtils.showToast(message: "Please Enter Valid Patient Email Address")
//            return
//        }
        //if !String.getString(textFieldPatientName.text){
        //CommonUtils.showToast(message: "Please Enter Valid Patient Name")
        //return
        //}
        //let res = buttonsGender.filter{$0.isSelected == true }
        //if res.isEmpty{
        //    CommonUtils.showToast(message: "Please Select Patient Gender")
        //    return
        //}
        //if String.getString(textFieldInsuranceNumber.text).isEmpty{
        //    CommonUtils.showToast(message: "Please Enter Patient Insurance Number")
        //    return
        //}
        //if String.getString(textFieldInsuranceNumber.text).count < 3{
        //    CommonUtils.showToast(message: "Please Enter Valid Patient Insurance Number")
        //    return
        //}
        //        if String.getString(self.textFieldInsuranceNumber.text).count > 1 && !String.getString(self.textFieldInsuranceNumber.text).isSpecialCharactersExcluded() {
        //            showAlertMessage.alert(message: Notifications.kEnterValidInsuranceNo)
        //            return
        //        }
        //if imageFront.tag == 0{
        //    CommonUtils.showToast(message: "Please select Front Insurance Image")
        //    return
        //}
        //if imageBack.tag == 0{
        //    CommonUtils.showToast(message: "Please select Back Insurance Image")
        //    return
        //}
        let res = buttonsBookingType.filter{ $0.isSelected == true }
        if selectedBooking == "" {
            CommonUtils.showToast(message: "Please Select Booking Type".localize)
            return
        }
        //if textView.text.isEmpty {
        //    CommonUtils.showToast(message: "Please enter notes".localize)
        //    return
        //}
//        let gender = buttonsGender.filter{ $0.isSelected == true }
        let gender = genderMale ? "Male" : "Female"
        UserData.shared.otherPatientDetails = OtherPatientDetailsModel(other_patient_name: String.getString(textFieldName.text), other_patient_age: String.getString(textFieldAge.text), other_patient_relation: String.getString(relation), other_patient_mobile: String.getString(textFieldMobile.text),other_patient_countryCode:String.getString(buttonCountryCode.titleLabel?.text), other_patient_insurance: String.getString(textFieldInsuranceNumber.text), other_patient_imageFront: imageFront.image ?? UIImage(), other_patient_imageBack: imageBack.image ?? UIImage(), other_notes: String.getString(textView.text),other_patient_gender: String.getString(gender),other_email: String.getString(textFieldEmail.text))
        //guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: DoctorBookingAppointmentVC.getStoryboardID()) as? DoctorBookingAppointmentVC else { return }
        //vc.selectedObject = updateBookingObject(type: selectedBooking)
        //vc.isBook = false
        //vc.selectedCommunication = self.selectedCommunication
        //vc.data = self.data
        //self.navigationController?.pushViewController(vc, animated: true)
        self.getDoctorTimeSlots(doctorId: self.data?.result.doctorID ?? 0)
    }
    
    func updateBookingObject(type: String) -> DoctorDataCommunicationService {
        let res = data?.result.doctorCommunicationServices?.filter {
            $0.commServiceType == type
        }
        return res?.first ?? .init(id: 0, doctorID: 0, commDuration: "", commDurationType: "", commDurationFee: 0, commServiceType: "")
    }
    
    func updateButton(sender: UIButton, value: Bool) {
        sender.isSelected = value
    }
    
    func updateButtonColors(sender: UIButton) {
        sender.backgroundColor = UIColor(named: "10")
        sender.tintColor = UIColor(named: "4")
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
extension AddOtherPatientDetails {
    @IBAction private func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func buttonSubmitTapped(_ sender: Any) {
        validateFields()
    }
    
    @IBAction private func buttonUploadFrontImageTapped(_ sender: UIButton) {
        cameFrom = 1
        CommonUtils.imagePicker(viewController: self)
    }
    
    @IBAction private func buttonRemoveFrontImageTapped(_ sender: UIButton) {
        cameFrom = -1
        self.imageFront.image = UIImage(named: "placeholder_img")
        self.imageFront.tag = 0
        buttonRemoveFrontImage.isHidden = true
    }
    
    @IBAction private func buttonUploadBackImageTapped(_ sender: UIButton) {
        cameFrom = 2
        CommonUtils.imagePicker(viewController: self)
    }
    
    @IBAction private func buttonRemoveBackImageTapped(_ sender: UIButton) {
        cameFrom = -1
        self.imageBack.image = UIImage(named: "placeholder_img")
        self.imageBack.tag = 0
        buttonRemoveBackImage.isHidden = true
    }
    
    @IBAction private func buttonVideoTapped(_ sender: UIButton) {
        buttonsBookingType.forEach {
//            updateButton(sender: $0, value:false)
            updateButtonColors(sender: $0)
        }
//        updateButton(sender: sender, value:true)
        sender.backgroundColor = UIColor(hexString: "#CBE4FA")
        sender.tintColor = UIColor(named: "5")
        self.selectedBooking = "video"
        self.selectedCommunication = "video_call_sm"
    }
    
    @IBAction private func buttonAudioTapped(_ sender: UIButton) {
        buttonsBookingType.forEach {
//            updateButton(sender: $0, value:false)
            updateButtonColors(sender: $0)
        }
//        updateButton(sender: sender, value:true)
        sender.backgroundColor = UIColor(hexString: "#CBE4FA")
        sender.tintColor = UIColor(named: "5")
        self.selectedBooking = "audio"
        self.selectedCommunication = "call_sm"
    }
    
    @IBAction private func buttonChatTapped(_ sender: UIButton) {
        buttonsBookingType.forEach {
//            updateButton(sender: $0, value:false)
            updateButtonColors(sender: $0)
        }
//        updateButton(sender: sender, value:true)
        sender.backgroundColor = UIColor(hexString: "#CBE4FA")
        sender.tintColor = UIColor(named: "5")
        self.selectedBooking = "chat"
        self.selectedCommunication = "chat_sm"
    }
    
    @IBAction private func buttonHomeTapped(_ sender: UIButton) {
        buttonsBookingType.forEach {
//            updateButton(sender: $0, value:false)
            updateButtonColors(sender: $0)
        }
//        updateButton(sender: sender, value:true)
        sender.backgroundColor = UIColor(hexString: "#CBE4FA")
        sender.tintColor = UIColor(named: "5")
        self.selectedBooking = "home"
        self.selectedCommunication = "home_visit"
        
    }
    
    @IBAction private func buttonVisitTapped(_ sender: UIButton) {
        buttonsBookingType.forEach {
//            updateButton(sender: $0, value:false)
            updateButtonColors(sender: $0)
        }
//        updateButton(sender: sender, value:true)
        sender.backgroundColor = UIColor(hexString: "#CBE4FA")
        sender.tintColor = UIColor(named: "5")
        self.selectedBooking = "visit"
        self.selectedCommunication = "clinic_visit_sm"
    }
    
    @IBAction private func buttonRelationTapped(_ sender: UIButton) {
        dropDown.anchorView = sender
        dropDown.dataSource = ["Grand Father","Father","Mother","Sister","Brother","Others"]
        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
            sender.setTitle(item, for: .normal)
//            sender.setTitleColor(#colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.5019607843, alpha: 1), for: .normal)
            sender.setTitleColor(UIColor(hexString: "#212529"), for: .normal)
            self.relation = item
        }
        dropDown.width = sender.frame.width
        dropDown.show()
    }
    
    @IBAction private func buttonMale(_ sender: UIButton) {
//        self.buttonsGender.forEach {
//            $0.isSelected = false
//        }
        self.buttonsGender[0].titleLabel?.textColor = UIColor(named: "5")
        self.buttonsGenderImage[0].tintColor = UIColor(named: "5")
        self.buttonsGenderImage[0].backgroundColor = UIColor().hexStringToUIColor(hex: "#cbe4fa")
        self.buttonsGender[1].titleLabel?.textColor = UIColor(named: "4")
        self.buttonsGenderImage[1].tintColor = UIColor(named: "4")
        self.buttonsGenderImage[1].backgroundColor = UIColor(named: "10")
        genderMale = true
        genderSelected = true
//        sender.isSelected = true
    }
    
    @IBAction private func buttonFemale(_ sender: UIButton) {
//        self.buttonsGender.forEach {
//            $0.isSelected = false
//            if $0 == sender {
//                $0.titleLabel?.textColor = UIColor(named: "5")
//            } else {
//                $0.titleLabel?.textColor = UIColor(named: "5")
//            }
//        }
        self.buttonsGender[1].titleLabel?.textColor = UIColor(named: "5")
        self.buttonsGenderImage[1].tintColor = UIColor(named: "5")
        self.buttonsGenderImage[1].backgroundColor = UIColor().hexStringToUIColor(hex: "#cbe4fa")
        self.buttonsGender[0].titleLabel?.textColor = UIColor(named: "4")
        self.buttonsGenderImage[0].tintColor = UIColor(named: "4")
        self.buttonsGenderImage[0].backgroundColor = UIColor(named: "10")
        genderMale = false
        genderSelected = true
//        sender.isSelected = true
    }
    
    @IBAction private func buttonOther(_ sender: UIButton) {
        self.buttonsGender.forEach {
            $0.isSelected = false
        }
        sender.isSelected = true
    }
    
    @IBAction private func buttonCountryCodeTapped(_ sender: Any) {
        AppsCountryPickers.showController(referense: self)  { (selectedCountry) in
            self.buttonCountryCode.setTitle(selectedCountry?.countryCode, for: .normal)
            self.imageCountryCode.image = selectedCountry?.image
        }
    }
}

// MARK: - Picker Controller
@available(iOS 15.0, *)
extension AddOtherPatientDetails: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let selectedImage:UIImage = info[.originalImage] as! UIImage
        if cameFrom == 1 {
            self.imageFront.image = selectedImage
            self.imageFront.tag = 1
            
            buttonRemoveFrontImage.isHidden = false
        } else {
            self.imageBack.image = selectedImage
            self.imageBack.tag = 1
            buttonRemoveBackImage.isHidden = false
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

@available(iOS 15.0, *)
extension AddOtherPatientDetails {
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
extension AddOtherPatientDetails {
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
    
    func checkSlotsApi() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let obj = UserData.shared.selectedSlotModel
        //        print(selectedSlotTime)
        //        print(selectedSlotDate)
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
    
    func saveDetails() {
        //  1 for audio, 2 for video, 3 for chat, 4 for house and 5 for visit consultation
        UserData.shared.selectedSlotModel = selectedSlotModel(
            appointment_type: appointmentTypeId,
            slot_id: selectedSlotId,
            date: selectedSlotDate,
            doctor_id: String.getString(data?.result.doctorID),
            fees: String.getString(data?.result.doctorCommunicationServices?.first?.commDurationFee),
            total_amount: String.getString(String.getString((Double.getDouble(data?.result.doctorCommunicationServices?.first?.commDurationFee)/100 * 5) + (Double.getDouble(data?.result.doctorCommunicationServices?.first?.commDurationFee)))),
            slot_time: selectedSlotTime
        )
    }
}

@available(iOS 15.0, *)
extension AddOtherPatientDetails {
    func navigateToViewControlletTimeSlots(practoSltos: TimeSoltResponse?) {
        if ((practoSltos?.timeslots?.isEmpty)!) {
            guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: AppointmentSlotVC.getStoryboardID()) as? AppointmentSlotVC else { return }
            vc.slots = UserData.shared.doctorData?.slotArray?.slots.filter { $0.slotType == self.selectedBooking } ?? []
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
                    self.proceed()
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
