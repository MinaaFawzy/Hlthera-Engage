//
//  AddSelfPatientDetails.swift
//  Hlthera
//
//  Created by Prashant Panchal on 20/01/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class AddSelfPatientDetails: UIViewController {
    @IBOutlet weak var imageCountryCode: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintAddressHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textFieldPatientName: UITextField!
    @IBOutlet weak var textFieldAge: UITextField!
    @IBOutlet var buttonsGender: [UIButton]!
    @IBOutlet weak var textFieldMobile: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var textFieldCity: UITextField!
    
    @IBOutlet weak var textFieldPinCode: UITextField!
    @IBOutlet weak var buttonCountryCode: UIButton!
    @IBOutlet weak var buttonCurrentLocation: UIButton!
    
    var isAddressToBeSaved = false
    var savedAddress:[SavedAddressModel] = []
    var isSavedAdressSelected = false
    var selectedSavedAddress:SavedAddressModel?
    var currentLocation:SavedAddressModel?
    var currentAddress:[String:Any] = [:]
    var latitude = 0.0
    var longitude = 0.0
    
    var promocodeId = ""
    var orderId = ""
    var addressId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.font = .corbenRegular(ofSize: 15)
        
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        tableView.tableFooterView = UIView()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
        
        let today = Date()
        if let customdate = UserData.shared.DOB{
            let dob = dateFormatter.date(from:customdate) ?? Date()
            let calender = Calendar.current

                let dateComponent = calender.dateComponents([.year, .month, .day], from:
                                                                dob, to: Date())
            if let age = dateComponent.year{
                if age>0{
                    self.textFieldAge.text = String.getString(dateComponent.year)
                }
              
            }
        }
        self.textFieldPatientName.text = UserData.shared.fullName
        
        self.textFieldMobile.text = UserData.shared.mobileNumber
        self.textFieldEmail.text = UserData.shared.email
        let gender = UserData.shared.gender
        if gender == "1"{
            self.buttonsGender[0].isSelected = true
        }else if gender == "2"{
            self.buttonsGender[1].isSelected = true
        }else{
            self.buttonsGender[2].isSelected = true
        }
        let lat = kSharedUserDefaults.getAppLocation().lat
        let long = kSharedUserDefaults.getAppLocation().long
        self.getLocationDetails(latitude: lat, longitude: long){ address in
            self.latitude = lat
            self.longitude = long
            self.currentLocation = address
            self.buttonCurrentLocation.setTitle(address.address + ", " + address.pincode, for: .normal)
           
        }
       

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        saveAddressApi(isSaving: false)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func validateFields() {
        if String.getString(textFieldPatientName.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Name".localize)
            return
        }
//        if !String.getString(textFieldPatientName.text){
//            CommonUtils.showToast(message: "Please Enter Valid Patient Name")
//            return
//        }
        if String.getString(textFieldAge.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Age".localize)
            return
        }
        if Int.getInt(textFieldAge.text)<18{
            CommonUtils.showToast(message: "Please Enter Valid Age".localize)
            return
        }
        let res = buttonsGender.filter{$0.isSelected == true }
        if res.isEmpty{
            CommonUtils.showToast(message: "Please Select Gender".localize)
            return
        }
        if String.getString(textFieldMobile.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Mobile Number".localize)
            return
        }
        if !String.getString(textFieldMobile.text).isPhoneNumber(){
            CommonUtils.showToast(message: "Please Enter Valid Mobile Number".localize)
            return
        }
        if String.getString(textFieldEmail.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Email Address".localize)
            return
        }
        if !String.getString(textFieldEmail.text).isEmail(){
            CommonUtils.showToast(message: "Please Enter Valid Email Address".localize)
            return
        }
        
        if kSharedUserDefaults.isPractoEnabled() == false{
            if String.getString(textFieldAddress.text).isEmpty && isSavedAdressSelected == false{
                CommonUtils.showToast(message: "Please Enter Address or Select Address".localize)
            return
            }
            if String.getString(textFieldEmail.text).count < 3 && isSavedAdressSelected == false{
                CommonUtils.showToast(message: "Please Enter Valid Address".localize)
                return
            }
            if String.getString(textFieldCity.text).isEmpty && isSavedAdressSelected == false{
                CommonUtils.showToast(message: "Please Enter City".localize)
                return
            }
            if String.getString(textFieldCity.text).count < 3 && isSavedAdressSelected == false{
                CommonUtils.showToast(message: "Please Enter Valid City".localize)
                return
            }
            if String.getString(textFieldPinCode.text).isEmpty && isSavedAdressSelected == false{
                CommonUtils.showToast(message: "Please Enter Pincode".localize)
                return
            }
            if String.getString(textFieldPinCode.text).count < 3 && isSavedAdressSelected == false{
                CommonUtils.showToast(message: "Please Enter Valid Pincode".localize)
                return
            }
        }
        
        self.bookingApi(isHospital: String.getString(UserData.shared.hospital_id).isEmpty ? false : true, forOthers: String.getString(UserData.shared.otherPatientDetails?.other_patient_name).isEmpty ? false : true)
        
//        if kSharedUserDefaults.isPractoEnabled() {
////            orderId = order!.id
////            addressId = selectedSavedAddress?.id
////            couponId = selectedSavedAddress?.id
//
////            self.placeOrderApi(id: self.orderId ?? "", addressId: self.addressId ?? "", couponId: self.promocodeId ?? "")
//
//            self.bookingApi(isHospital: String.getString(UserData.shared.hospital_id).isEmpty ? false : true, forOthers: String.getString(UserData.shared.otherPatientDetails?.other_patient_name).isEmpty ? false : true)
//        }else{
//            navigateToPaymentVC()
//        }
        
        
       
    }
    func navigateToPaymentVC(){
//        if isAddressToBeSaved{
//            let res = self.savedAddress.filter{$0.isSelected == true}
//
//            //UserData.shared.patientDetails(data:[:])
//        }
//
      //  1 for audio, 2 for video, 3 for chat, 4 for house and 5 for visit consultation
        if isSavedAdressSelected{
            let res = buttonsGender.filter{$0.isSelected == true}
            if selectedSavedAddress?.id == "current"{
                UserData.shared.patientDetails = PatientDetailsModel(patient_name: String.getString(textFieldPatientName.text), patient_age: String.getString(textFieldAge.text), patient_gender: String.getString(res[0].titleLabel?.text), patient_email: String.getString(textFieldEmail.text), patient_mobile: String.getString(textFieldMobile.text),patient_countryCode:String.getString(buttonCountryCode.titleLabel?.text), address_id: "", is_save_address: false,address: String.getString(selectedSavedAddress?.address),city: String.getString(selectedSavedAddress?.city),pincode: String.getString(selectedSavedAddress?.pincode), is_future_address: isAddressToBeSaved)
            }else{
                UserData.shared.patientDetails = PatientDetailsModel(patient_name: String.getString(textFieldPatientName.text), patient_age: String.getString(textFieldAge.text), patient_gender: String.getString(res[0].titleLabel?.text), patient_email: String.getString(textFieldEmail.text), patient_mobile: String.getString(textFieldMobile.text),patient_countryCode:String.getString(buttonCountryCode.titleLabel?.text), address_id: String.getString(selectedSavedAddress?.id), is_save_address: true,address: String.getString(selectedSavedAddress?.address),city: String.getString(selectedSavedAddress?.city),pincode: String.getString(selectedSavedAddress?.pincode), is_future_address: isAddressToBeSaved)
            }
        }
        else {
            let res = buttonsGender.filter{$0.isSelected == true}
            UserData.shared.patientDetails = PatientDetailsModel(patient_name: String.getString(textFieldPatientName.text), patient_age: String.getString(textFieldAge.text), patient_gender: String.getString(res[0].titleLabel?.text), patient_email: String.getString(textFieldEmail.text), patient_mobile: String.getString(textFieldMobile.text),patient_countryCode:String.getString(buttonCountryCode.titleLabel?.text), address_id: "", is_save_address: false,address: String.getString(textFieldAddress.text),city: String.getString(textFieldCity.text),pincode: String.getString(textFieldPinCode.text), is_future_address: isAddressToBeSaved)
        }
//        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PaymentVC.getStoryboardID()) as? PaymentVC else { return }
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonConfirmTapped(_ sender: Any) {
       validateFields()
    }
    @IBAction func buttonMaleTapped(_ sender: UIButton) {
        self.buttonsGender.map{
            $0.isSelected = false
        }
        sender.isSelected = true
    }
    
    @IBAction func buttonFemaleTapped(_ sender: UIButton) {
        self.buttonsGender.map{
            $0.isSelected = false
        }
        sender.isSelected = true
    }
    @IBAction func buttonOtherTapped(_ sender: UIButton) {
        self.buttonsGender.map{
            $0.isSelected = false
        }
        sender.isSelected = true
    }
    @IBAction func buttonSaveForFutureTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isSelected ? (isAddressToBeSaved = true) : (isAddressToBeSaved = false)
    }
    @IBAction func buttonCountryCodeTapped(_ sender: Any) {
        AppsCountryPickers.showController(referense: self)  { (selectedCountry) in
            self.buttonCountryCode.setTitle(selectedCountry?.countryCode, for: .normal)
            self.imageCountryCode.image = selectedCountry?.image
            
        }
    }
    @IBAction func buttonCurrentLocationTapped(_ sender: Any) {
        self.savedAddress.map{
            $0.isSelected = false
        }
        buttonCurrentLocation.isSelected = !buttonCurrentLocation.isSelected
       if buttonCurrentLocation.isSelected{
        isSavedAdressSelected = true
        self.selectedSavedAddress =  currentLocation
        }
       else{
        isSavedAdressSelected = false
        self.selectedSavedAddress =  SavedAddressModel(data: [:])
       }
        self.textFieldPinCode.text = ""
        self.textFieldPinCode.text = ""
        self.textFieldAddress.text = ""
        tableView.reloadData()
    }
    @IBAction func buttonEditCurrentLocation(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: FetchCurrentLocationVC.getStoryboardID()) as? FetchCurrentLocationVC else { return }
        vc.latitude = self.latitude
        vc.longitude = self.longitude
        vc.callback = { location in
            self.getLocationDetails(latitude: location.lat, longitude: location.long, completion: { address in
                self.latitude = location.lat
                self.longitude = location.long
                self.currentLocation = address
                self.buttonCurrentLocation.setTitle(address.address + ", " + address.pincode, for: .normal)
                self.tableView.reloadData()
            })
            
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension AddSelfPatientDetails{
    
    func bookingApi(isHospital:Bool, forOthers:Bool){
        var gender = ""
        if self.buttonsGender[0].isSelected{
            gender =  "1"
        }else if
            self.buttonsGender[1].isSelected{
            gender = "2"
        }else{
            gender = "3"
        }
        CommonUtils.showHudWithNoInteraction(show: true)

        let obj = UserData.shared
        var images:[[String:Any]] = []

        
        var params:[String : Any] = [
                                     ApiParameters.appointment_type:String.getString(obj.selectedSlotModel?.appointment_type),
                                     ApiParameters.slot_id:String.getString(obj.selectedSlotModel?.slot_id),
                                     ApiParameters.date:String.getString(obj.selectedSlotModel?.date),
                                     ApiParameters.doctor_id:String(Int((obj.selectedSlotModel?.doctor_id.toEnglishNumber())!))
                                     ,ApiParameters.patient_countryCode:String.getString(obj.patientDetails?.patient_countryCode),
            ApiParameters.is_save_adress:obj.patientDetails?.is_save_address ?? false ? "1" : "0",
            ApiParameters.old_date:String.getString(obj.old_date),
            ApiParameters.old_slot_id:String.getString(obj.old_slot_id),
            ApiParameters.slot_time:String.getString(obj.selectedSlotModel?.slot_time),
            ApiParameters.is_reschedule:obj.isReschedule ? "1" : "0",
           
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
            params.updateValue(String.getString(textFieldPatientName.text), forKey:  ApiParameters.patient_name)
            params.updateValue(String.getString(textFieldAge.text), forKey:  ApiParameters.patient_age)
            params.updateValue(String.getString(gender), forKey:  ApiParameters.patient_gender)
            params.updateValue(String.getString(textFieldEmail.text), forKey:  ApiParameters.patient_email)
            params.updateValue(String.getString(textFieldMobile.text), forKey:  ApiParameters.patient_mobile)
            params.updateValue(String.getString(selectedSavedAddress?.id), forKey:  ApiParameters.address_id)

            
//            ApiParameters.fees:String.getString(obj.selectedSlotModel?.fees)
//            ApiParameters.total_amount:String.getString(obj.selectedSlotModel?.total_amount),
//            ApiParameters.patient_name:String.getString(textFieldPatientName.text),
//            ApiParameters.patient_age:String.getString(textFieldAge.text),
//           ApiParameters.patient_gender:String.getString(gender),
//            ApiParameters.patient_email:String.getString(textFieldEmail.text),
//            ApiParameters.patient_mobile:String.getString(textFieldMobile.text),
//            ApiParameters.address_id:String.getString(selectedSavedAddress?.id)
            
        }else{
//            ApiParameters.patient_name:String.getString(obj.patientDetails?.patient_name),
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
                  
            
            
            if forOthers{
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
                
            }
             else if isHospital{
                params[ApiParameters.isHospitalBooking] = "1"
                forOthers ? () : (params[ApiParameters.isOtherKey] = "0")
                params[ApiParameters.hospital_id] = String.getString(obj.hospital_id)
            }
             else {
                params[ApiParameters.isHospitalBooking] = "0"
                params[ApiParameters.isOtherKey] = "0"
             }
        }
            
        
    
        
        TANetworkManager.sharedInstance.requestMultiPart(withServiceName: ServiceName.bookAppointment, requestMethod: .post, requestImages: images, requestVideos: [:], requestData: params)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0{
                        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        vc.popUpDescription = "Payment has been successfully done".localize
                        vc.callback = {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                                    self?.dismiss(animated: true, completion: {
                                        UserData.shared.isReschedule = false
                                        kSharedAppDelegate?.moveToHomeScreen()
                                    }
                                )
                            })
                        }
                        self?.navigationController?.present(vc, animated: true)
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
    
    
    func placeOrderApi(id:String,addressId:String,couponId:String = ""){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [ApiParameters.order_id:
                                        id, ApiParameters.address_id:addressId,
                                     ApiParameters.coupon_id:couponId]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.orderPlace,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                  
                        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                    vc.popUpDescription = "Your order placed successfully".localize
                        vc.callback = {
                            
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                                    self?.dismiss(animated: true, completion: {
                                        UserData.shared.isReschedule = false
                                        kSharedAppDelegate?.moveToHomeScreen()
                                    }
                                )
                            })
                        }
                        self?.navigationController?.present(vc, animated: true)
                  
                   
                   
                    
                default:
                    
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    return
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToast(message: kNoInternetMsg)
                
            } else {
                CommonUtils.showToast(message: kDefaultErrorMsg)
            }
        }
    }
}

extension AddSelfPatientDetails:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if savedAddress.count < 1 {
            self.constraintAddressHeight.constant = 200
        }
        return tableView.numberOfRow(numberofRow: savedAddress.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedAddressTVC", for: indexPath) as! SavedAddressTVC
        cell.labelAddress.text = savedAddress[indexPath.row].address + ",\n" + savedAddress[indexPath.row].pincode
        if self.savedAddress[indexPath.row].isSelected{
            cell.imageIsSelected.image = UIImage(named:"radio_active")
        }
        else {
            cell.imageIsSelected.image = UIImage(named:"radio_unactive")
        }
        cell.deleteCallback = {
            self.saveAddressApi(isSaving: false, isDelete: true, id: self.savedAddress[indexPath.row].id)
            
        }
        cell.editCallback = {
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: AddAddressVC.getStoryboardID()) as? AddAddressVC else { return }
            vc.hasCameFrom = .updateAddress
            vc.editAddress = self.savedAddress[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        constraintAddressHeight.constant = tableView.contentSize.height + 100
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                // delete the item here
                self.saveAddressApi(isSaving: false, isDelete: true, id: self.savedAddress[indexPath.row].id)
                completionHandler(true)
            }
            deleteAction.image = #imageLiteral(resourceName: "delete")
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
    }
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SavedAddressTVC
        cell.viewBG.isHidden = false
        let mainView = tableView.subviews.filter{String(describing:Swift.type(of: $0)) == "_UITableViewCellSwipeContainerView"}
        if !mainView.isEmpty{
            let backgroundView = mainView[0].subviews
            if !backgroundView.isEmpty{
                backgroundView[0].frame = CGRect(x: 0, y: 5, width: mainView[0].frame.width, height: mainView[0].frame.height-10)
                backgroundView[0].layoutIfNeeded()
            }
        }
        
        }
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        if let index = indexPath{
            let cell = tableView.cellForRow(at: index) as! SavedAddressTVC
            
            UIView.animate(withDuration: 0.2, delay: 0, options:.curveEaseOut, animations: {
                cell.viewBG.isHidden = true
                cell.viewBG.layoutIfNeeded()
            })
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if savedAddress[indexPath.row].isSelected {
            self.savedAddress[indexPath.row].isSelected = false
            isSavedAdressSelected = false
            self.selectedSavedAddress = SavedAddressModel(data: [:])
            
        }
        else {
            self.savedAddress.map{
                $0.isSelected = false
            }
            self.buttonCurrentLocation.isSelected = false
            self.savedAddress[indexPath.row].isSelected = true
            isSavedAdressSelected = true
            self.selectedSavedAddress =  self.savedAddress[indexPath.row]
            
        }
        self.textFieldPinCode.text = ""
        self.textFieldPinCode.text = ""
        self.textFieldAddress.text = ""
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
extension AddSelfPatientDetails{
    func saveAddressApi(isSaving:Bool,isDelete:Bool = false, id:String = ""){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        var params:[String : Any] = [:]
        var serviceUrl = ServiceName.addPatientAddress
        var reqType:kHTTPMethod = .POST
        if isSaving{
            
            params = [ApiParameters.kAddress:String.getString(textFieldAddress.text),
                      ApiParameters.kCity:String.getString(textFieldCity.text),
                      ApiParameters.kPincode:String.getString(textFieldPinCode.text),
                      ApiParameters.address_type:"1"]
            serviceUrl = ServiceName.addPatientAddress
            reqType = .POST
            
        }
        if !isSaving{
            params = [:]
            serviceUrl = ServiceName.myAddress
            reqType = .GET
        }
        if isDelete{
            
            params = [ApiParameters.address_id:String.getString(id),
                      ]
            serviceUrl = ServiceName.deleteAddress
            reqType = .POST
        }
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:serviceUrl,                                                   requestMethod:reqType ,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0{
                        if isSaving{
                            self?.isAddressToBeSaved = false
                            self?.navigateToPaymentVC()
                        }
                        if !isSaving {
                            let result = kSharedInstance.getArray(dictResult["my_address_list"])
                           
                            self?.savedAddress = result.map{
                                        SavedAddressModel(data: kSharedInstance.getDictionary($0))
                                   
                            
                        }
                            
                            
                          
                            
                        
                    }
                        if isDelete{
                            CommonUtils.showToast(message: "Address Deleted Successfully")
                            self?.isSavedAdressSelected = false
                            self?.savedAddress.map{
                                $0.isSelected = false
                            }
                            self?.buttonCurrentLocation.isSelected = false
                            self?.selectedSavedAddress = SavedAddressModel(data: [:])
                            self?.saveAddressApi(isSaving: false)
                            
                                                    }
                        self?.tableView.reloadData()
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
    func getLocationDetails(latitude:Double,longitude:Double,completion: @escaping (SavedAddressModel)->()){
        let geocoder = GMSGeocoder()
        let position = CLLocationCoordinate2DMake(latitude, longitude)
        let id = "current"
        
        geocoder.reverseGeocodeCoordinate(position) { response , error in
            if error != nil {
                print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            }else {
                let result = response?.results()?.first
                let address = "\(String.getString(result?.locality)), \(String.getString(result?.country))"
                let city = String.getString(result?.locality)
                let pincode = String.getString(result?.postalCode).isEmpty ? ("000000") : (String.getString(result?.postalCode))
                completion(
                 SavedAddressModel(data: ["id":id,"address":address,"city":city,"pincode":pincode]))
               
                
                
            }
        }
        
    }
    
}
extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}

