//
//  AddAddressVC.swift
//  Hlthera
//
//  Created by fluper on 17/03/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit
import DropDown

class AddAddressVC: UIViewController {
    
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var textFieldCity: UITextField!
    @IBOutlet weak var textFieldPincode: UITextField!
    @IBOutlet weak var textFieldMobile: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var buttonCountryCode: UIButton!
    @IBOutlet weak var imageCountryCode: UIImageView!
    @IBOutlet weak var labelPageTitle: UILabel!
    
    var dropDown = DropDown()
    var selectedCountryId = ""
    var selectedStateId = ""
    var selectedCityId = ""
    var type = "0"
    var hasCameFrom:HasCameFrom = .addAddress
    var pageTitle = "Add New Address"
    var editAddress:SavedAddressModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelPageTitle.font = .corbenRegular(ofSize: 15)
        
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        
        switch hasCameFrom{
        case .addAddress:
            self.labelPageTitle.text = pageTitle
        case .updateAddress:
            self.labelPageTitle.text = "Edit Address".localize
            fillData()
        default: break
        }
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    func fillData(){
        if let obj = editAddress{
            self.textFieldName.text = obj.patient_name.isEmpty ? (String.getString(UserData.shared.firstName) + " " + String.getString(UserData.shared.lastName)) : (obj.patient_name)
            self.textFieldMobile.text = obj.mobile_no.isEmpty ? (UserData.shared.mobileNumber) : (obj.mobile_no)
            self.textFieldAddress.text = obj.address
            self.textFieldCity.text = obj.city
            self.textFieldPincode.text = obj.pincode
            //self.buttonCountryCode.setTitle(obj.country_code.isEmpty ? ("+971") : (obj.country_code), for: .normal)
        }
    }
    func validateFields(){
        if String.getString(textFieldName.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Name".localize)
            return
        }
        if String.getString(textFieldName.text).count > 30{
            CommonUtils.showToast(message: "Please Enter valid Name".localize)
            return
        }
        if String.getString(textFieldMobile.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Mobile Number".localize)
            return
        }
        if !String.getString(textFieldMobile.text).isPhoneNumber(){
            CommonUtils.showToast(message: "Please Enter valid Mobile Number".localize)
            return
        }
        if String.getString(textFieldAddress.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Address".localize)
            return
        }
        if String.getString(textFieldCity.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter City".localize)
            return
        }
        if String.getString(textFieldPincode.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Pincode".localize)
            return
        }
        if String.getString(textFieldPincode.text).count > 20{
            CommonUtils.showToast(message: "Please Enter valid Pincode".localize)
            return
        }
        switch hasCameFrom{
        case .addAddress:
            saveAddress(isUpdate: false)
        case .updateAddress:
            saveAddress(isUpdate: true)
        default: break
        }
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonCountryTapped(_ sender: UIButton) {
        
        AppsCountryPickers.showController(referense: self)  { (selectedCountry) in
            self.buttonCountryCode.setTitle(selectedCountry?.countryCode, for: .normal)
            self.imageCountryCode.image = selectedCountry?.image
        }
        
        
    }
    //    @IBAction func buttonStateTapped(_ sender: UIButton) {
    //        if buttonCountry.tag == 0{
    //            CommonUtils.showToast(message: "Please Select Country")
    //            return
    //        }
    //        else{
    //            getCountryStateCityApi(type:2){ states in
    //                self.dropDown.anchorView = sender
    //                self.dropDown.dataSource = states.map{$0.name}
    //                self.dropDown.selectionAction = {[unowned self](index:Int, item:String) in
    //                    self.buttonState.setTitle(item, for: .normal)
    //                    self.buttonState.setTitleColor(#colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.5019607843, alpha: 1), for: .normal)
    //                    self.buttonState.tag = 1
    //                    self.selectedStateId = states[index].id
    //                }
    //                self.dropDown.width = self.buttonState.frame.width
    //                self.dropDown.show()
    //        }
    //        }
    //    }
    //    @IBAction func buttonCityTapped(_ sender: UIButton) {
    //        if buttonState.tag == 0{
    //            CommonUtils.showToast(message: "Please Select State")
    //            return
    //        }
    //        else{
    //            getCountryStateCityApi(type:3){ cities in
    //                self.dropDown.anchorView = sender
    //                self.dropDown.dataSource = cities.map{$0.name}
    //                self.dropDown.selectionAction = {[unowned self](index:Int, item:String) in
    //                    self.buttonCity.setTitle(item, for: .normal)
    //                    self.buttonCity.setTitleColor(#colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.5019607843, alpha: 1), for: .normal)
    //                    self.buttonCity.tag = 1
    //                    self.selectedCityId = cities[index].id
    //                }
    //                self.dropDown.width = self.buttonCity.frame.width
    //                self.dropDown.show()
    //        }
    //        }
    //    }
    
    @IBAction func buttonSaveTapepd(_ sender: Any) {
        validateFields()
    }
    //    @IBAction func buttonSelfTapped(_ sender: Any) {
    //        buttonOther.isSelected = false
    //        buttonSelf.isSelected = true
    //
    //    }
    //    @IBAction func buttonOtherTapped(_ sender: Any) {
    //        buttonOther.isSelected = true
    //        buttonSelf.isSelected = false
    //    }
    
    
}
extension AddAddressVC{
    
    func saveAddress(isUpdate:Bool){
        CommonUtils.showHudWithNoInteraction(show: true)
        var params:[String:Any] = [:]
        if isUpdate{
            params = [
                ApiParameters.address_id: String.getString(editAddress?.id),
                ApiParameters.kAddress:String.getString(textFieldAddress.text),
                ApiParameters.kCity:String.getString(textFieldCity.text),
                ApiParameters.kPincode:String.getString(textFieldPincode.text),
                ApiParameters.kcountryCode:String.getString(self.buttonCountryCode.titleLabel?.text),
                ApiParameters.address_type:type,ApiParameters.patient_name:String.getString(self.textFieldName.text),
                ApiParameters.mobile_no:String.getString(textFieldMobile.text)
            ]
        }
        else{
            
            params = [
                ApiParameters.kAddress:String.getString(textFieldAddress.text),
                ApiParameters.kCity:String.getString(textFieldCity.text),
                ApiParameters.kPincode:String.getString(textFieldPincode.text),
                ApiParameters.kcountryCode:String.getString(self.buttonCountryCode.titleLabel?.text),
                ApiParameters.address_type:type,ApiParameters.patient_name:String.getString(self.textFieldName.text),
                ApiParameters.mobile_no:String.getString(textFieldMobile.text)
            ]
            
            
        }
        
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:isUpdate ? (ServiceName.updateAddress) : (ServiceName.addPatientAddress),                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    
                    if isUpdate{
                        CommonUtils.showToast(message: "Address updated successfully!".localize)
                    }else{
                        CommonUtils.showToast(message: "Address saved successfully!".localize)
                    }
                    
                    self?.navigationController?.popViewController(animated: true)
                    
                    
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
    func getCountryStateCityApi(type:Int,completion: @escaping ([CountryStateCityModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        var serviceUrl = ""
        let params:[String : Any] = [:]
        switch type{
        case 1:
            serviceUrl = ServiceName.country_list
        case 2:
            serviceUrl = ServiceName.state_list + "?country_id=" + selectedCountryId
        case 3:
            serviceUrl = ServiceName.city_list + "?state_id=" + selectedStateId
        default:
            break
        }
        TANetworkManager.sharedInstance.requestApi(withServiceName:serviceUrl,                                                   requestMethod: .GET,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    
                    switch type{
                    case 1:
                        let data = kSharedInstance.getArray(dictResult["countries"])
                        completion(data.map{CountryStateCityModel(dict: kSharedInstance.getDictionary($0))})
                    case 2:
                        let data = kSharedInstance.getArray(dictResult["states"])
                        completion(data.map{CountryStateCityModel(dict: kSharedInstance.getDictionary($0))})
                    case 3:
                        let data = kSharedInstance.getArray(dictResult["cities"])
                        completion(data.map{CountryStateCityModel(dict: kSharedInstance.getDictionary($0))})
                    default:
                        break
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
