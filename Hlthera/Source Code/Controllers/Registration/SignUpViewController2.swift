//
//  SignUpViewController2.swift
//  Hlthera
//
//  Created by Ahmed Hegazy on 16/12/2022.
//  Copyright © 2022 Fluper. All rights reserved.
//

import UIKit
import DropDown

class SignUpViewController2: UIViewController {
    
    let dropDown = DropDown()
    var languageId = "1"
    var insuranceCompany = [InsuranceCompanyModel]()
    var isTermsAccepted = false
    
    @IBOutlet weak var btnEyeConfirmPass: UIButton!
    @IBOutlet weak var btnEyePass: UIButton!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var viewContent: UIView!
    //@IBOutlet weak var tfFirstName: UITextField!
    //@IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfMobileNumber: UITextField!
    @IBOutlet weak var tfInsuranceCompany: UITextField!
    @IBOutlet weak var tfInsuranceNumber: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var showConfPassword: UIImageView!
    @IBOutlet weak var showPassword: UIImageView!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfPassword: UITextField!
    @IBOutlet weak var tfHowDidHereAboutUs: UITextField!
    @IBOutlet weak var imageCheckAcceptTerms: UIImageView!
    @IBOutlet weak var imageCheckFullName: UIImageView!
    @IBOutlet weak var imageCheckPhone: UIImageView!
    @IBOutlet weak var imageCheckInsuranceNumber: UIImageView!
    @IBOutlet weak var imageCheckEmail: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfFullName.delegate = self
        tfMobileNumber.delegate = self
        tfInsuranceNumber.delegate = self
        tfEmail.delegate = self
        imageCheckPhone.isHidden = true
        imageCheckEmail.isHidden = true
        imageCheckInsuranceNumber.isHidden = true
        imageCheckFullName.isHidden = true
        
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        
        let tapAcceptTermsConditions = UITapGestureRecognizer(target: self, action: #selector(self.handleTapimageCheckAcceptTerms(_:)))
        imageCheckAcceptTerms.addGestureRecognizer(tapAcceptTermsConditions)
        //
        //
        //                          let tapShowConfPassword = UITapGestureRecognizer(target: self, action: #selector(self.handleTapShowConfPassword(_:)))
        //                          showConfPassword.addGestureRecognizer(tapShowConfPassword)
        
        
        let tapimageCheckAcceptTerms = UITapGestureRecognizer(target: self, action: #selector(self.handleTapimageCheckAcceptTerms(_:)))
        imageCheckAcceptTerms.addGestureRecognizer(tapimageCheckAcceptTerms)
        imageCheckAcceptTerms.isUserInteractionEnabled = true;
        
        
        insuranceCompanyApi()
        
    }
    
    @IBAction func btnInsiranceCompanyTapped(_ sender: UIButton) {
        dropDown.anchorView = sender
        dropDown.dataSource = self.insuranceCompany.map{String.getString($0.name)}
        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
            self.tfInsuranceCompany.text = item
        }
        dropDown.width = self.tfInsuranceCompany.frame.width
        dropDown.show()
    }
    
    @objc func handleTapimageCheckAcceptTerms(_ sender: UITapGestureRecognizer? = nil) {
        isTermsAccepted = !isTermsAccepted;
        
        if(isTermsAccepted){
            termsAndConditionsApi()
            imageCheckAcceptTerms.setImage( UIImage(named: "check_box")!)
        }else{
            imageCheckAcceptTerms.setImage( UIImage(named: "uncheck_box")!)
        }
    }
    
    // MARK: - Actions
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSignUpTapped(_ sender: UIButton) {
        self.validationField()
        //        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kOtpVerificationVC) as? OtpVerificationViewController else {return}
        //        nextVc.hasCameFrom = .signUp
        //        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction private func btnEyeEnterPassTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnEyePass.isSelected { self.tfPassword.isSecureTextEntry = false
        } else { self.tfPassword.isSecureTextEntry = true }
    }
    
    @IBAction private func btnCinfirmPassTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnEyeConfirmPass.isSelected{ self.tfConfPassword.isSecureTextEntry = false
        } else { self.tfConfPassword.isSecureTextEntry = true }
    }
    
}

extension SignUpViewController2: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == self.tfEmail {
            if String.getString(textField.text).count >= 9 {
                imageCheckEmail.isHidden = false
            } else {
                imageCheckEmail.isHidden = true
            }
        }
        
        if textField == self.tfMobileNumber {
            if String.getString(textField.text).count >= 9 {
                imageCheckPhone.isHidden = false
            } else {
                imageCheckPhone.isHidden = true
            }
        }
        
        if textField == self.tfInsuranceNumber {
            if String.getString(textField.text).count >= 9 {
                imageCheckInsuranceNumber.isHidden = false
            } else {
                imageCheckInsuranceNumber.isHidden = true
            }
        }
        
        if textField == self.tfFullName {
            if String.getString(textField.text).count >= 9 {
                imageCheckFullName.isHidden = false
            } else {
                imageCheckFullName.isHidden = true
            }
        }
    }
}

// MARK: - signUpApi
extension SignUpViewController2 {
    func signUpApi() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String: Any] = [ApiParameters.kfullName: tfFullName.text ?? "",
                                    ApiParameters.kemail: tfEmail.text ?? "",
                                    //ApiParameters.kcountryCode:buttonCountryCode.currentTitle,
                                    ApiParameters.kMobileNumber: "+2 \(tfMobileNumber.text ?? "")" ,
                                    //ApiParameters.kdeviceToken:kSharedUserDefaults.getDeviceToken(),
                                    ApiParameters.kdeviceToken: "3232",
                                    ApiParameters.kdevice_type: "2",
                                    ApiParameters.kLatitude: "0",
                                    ApiParameters.kLongitude: "0",
                                    ApiParameters.klang_id: languageId,
                                    ApiParameters.kPassword: tfPassword.text ?? "",
                                    ApiParameters.kConfirmPassword: tfConfPassword.text ?? "",
                                    ApiParameters.kcontact_us_by: "sadasd",
                                    ApiParameters.kterms_and_condition: "dada",
                                    ApiParameters.klogin_type: "0"
        ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.signup,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    
                    let data = kSharedInstance.getDictionary(dictResult[kResponse])
                    kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: String.getString(data[kAccessToken]))
                    kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: data)
                    UserData.shared.saveData(data: data)
                    
                    let alert = UIAlertController(title: "Signed Up Successfully!".localize, message: nil, preferredStyle: .alert)
                    let action1 = UIAlertAction(title: AlertTitle.kOk, style: .cancel){_ in
                        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kOtpVerificationVC) as? OtpVerificationViewController else {return}
                        nextVc.hasCameFrom = .signUp
                        nextVc.userName = self.tfMobileNumber.text
                        self.navigationController?.pushViewController(nextVc, animated: true)
                    }
                    alert.addAction(action1)
                    UIApplication.shared.windows.first?.rootViewController?.present(alert , animated: true)
                    
                    
                    
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

// MARK: - insuranceCompanyApi
extension SignUpViewController2 {
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
                    self.insuranceCompany = data.map{InsuranceCompanyModel(data: $0)}
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

// MARK: - insuranceCompanyApi
extension SignUpViewController2 {
    func termsAndConditionsApi() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String: Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.term_condition,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    
                    let result = kSharedInstance.getArray(dictResult["data"])
                    if Int.getInt(dictResult["status"]) == 0{
                        
                        var model:DataResponseTermsCond?
                        let convertDicToJsonString =  try? JSONSerialization.data(withJSONObject: dictResult, options: [.prettyPrinted])
                        let jsonString = String(data: convertDicToJsonString!, encoding: .utf8)!
                        let jsonStringToData = Data(jsonString.utf8)
                        let decoder = JSONDecoder()
                        do {
                            model = try decoder.decode(DataResponseTermsCond.self, from: jsonStringToData)
                            print(model?.data)
                            guard let nextVc = UIStoryboard(name: Storyboards.kMain, bundle: nil).instantiateViewController(withIdentifier: TermsAndConditionsVC.getStoryboardID()) as? TermsAndConditionsVC else { return }
                            nextVc.html = (model?.data)!
                            self.navigationController?.pushViewController(nextVc, animated: true)
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    break
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

