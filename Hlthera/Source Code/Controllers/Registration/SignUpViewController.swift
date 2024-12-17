//
//  SignUpViewController.swift
//  Hlthera
//
//  Created by Akash on 26/10/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import DropDown

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    //@IBOutlet weak var switchRemember: UISwitch!
    @IBOutlet weak var switchTerms: UISwitch!
    @IBOutlet weak var imageCheck: UIImageView!
    @IBOutlet var firstNameTF:UITextField!
    @IBOutlet var mobileNoTF:UITextField!
    @IBOutlet var emailTF:UITextField!
    @IBOutlet weak var buttonCountryCode: UIButton!
    @IBOutlet var passwordTF:UITextField!
    @IBOutlet var confirmPasswordTF:UITextField!
    @IBOutlet weak var btnEyeConfirmPass: UIButton!
    @IBOutlet weak var btnEyePass: UIButton!
    @IBOutlet weak var labelJoinNowTitle: UILabel!
    @IBOutlet weak var imageCountryCode: UIImageView!
    
    // MARK: - VARIABLES
    var languageId = "1"
    var insuranceCompany = [InsuranceCompanyModel]()
    var dropDown = DropDown()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    //MARK:- Functions
    private func initialSetup(){
        
        labelJoinNowTitle.font = .CorbenBold(ofSize: 32)
        
        
        // switchRemember.transform = CGAffineTransform(scaleX:0.65, y: 0.65)
        viewContent.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewContent.layer.cornerRadius = 30
        switchTerms.transform = CGAffineTransform(scaleX: 0.70, y: 0.65)
        buttonCountryCode.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        emailTF.delegate = self
        imageCheck.isHidden = true
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        firstNameTF.placeholder(text: "Enter Full Name".localize, color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        mobileNoTF.placeholder(text: "Enter Mobile Number".localize, color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        emailTF.placeholder(text: "Enter Email".localize, color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        passwordTF.placeholder(text: "Enter Password".localize, color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        confirmPasswordTF.placeholder(text: "Enter Confirm Password".localize, color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        
        if UIScreen.main.bounds.height > 800{
            // ScrollView.isScrollEnabled = false
        }
        else {
            // ScrollView.isScrollEnabled = true
        }
        //insuranceCompanyApi()
        //        confirmPasswordTF.isSecureTextEntry = false
        //        passwordTF.isSecureTextEntry = false
        
        
        //country code picker
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            let dialCode = kSharedInstance.getCountryCallingCode(countryRegionCode: countryCode)
            buttonCountryCode.setTitle("+971", for: .normal)
            print(String.getString(Locale.current.regionCode))
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        passwordTF.textContentType = .none
        confirmPasswordTF.textContentType = .none
    }
    
    // MARK: - Actions
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCountryCodeTapped(_ sender: UIButton) {
        AppsCountryPickers.showController(referense: self)  { (selectedCountry) in
            self.buttonCountryCode.setTitle(selectedCountry?.countryCode, for: .normal)
            self.imageCountryCode.image = selectedCountry?.image
            
        }
        
    }
    
    @IBAction func btnSignUpTapped(_ sender: UIButton) {
        self.validationField()
        
        //        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kOtpVerificationVC) as? OtpVerificationViewController else {return}
        //        nextVc.hasCameFrom = .signUp
        //        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func btnEyeEnterPassTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnEyePass.isSelected{self.passwordTF.isSecureTextEntry = false}
        else{self.passwordTF.isSecureTextEntry = true}
    }
    
    @IBAction func btnCinfirmPassTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnEyeConfirmPass.isSelected{self.confirmPasswordTF.isSecureTextEntry = false}
        else{self.confirmPasswordTF.isSecureTextEntry = true}
    }
    
    @IBAction func switchRememberTapped(_ sender: UISwitch) {
        // sender.isOn = !sender.isOn
    }
    
    @IBAction func switchTermsTapped(_ sender: UISwitch) {
        // sender.isOn = !sender.isOn
    }
    
    @IBAction func btnSignInTapped(_ sender: UIButton) {
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kLoginVc) as? LoginVC else { return }
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.pushViewController(nextVc, animated: true)
    }
    
}

// MARK: - signUpApi
extension SignUpViewController{
    func signUpApi() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.kfullName:firstNameTF.text ?? "",
                                   ApiParameters.kemail:emailTF.text ?? "",
                                   ApiParameters.kcountryCode:buttonCountryCode.currentTitle,
                                   ApiParameters.kMobileNumber:mobileNoTF.text,
                                   //ApiParameters.kdeviceToken:kSharedUserDefaults.getDeviceToken(),
                                   ApiParameters.kdeviceToken:"3232",
                                   ApiParameters.kdevice_type :"2",
                                   ApiParameters.kLatitude:"0",
                                   ApiParameters.kLongitude:"0",
                                   ApiParameters.klang_id:languageId,
                                   ApiParameters.kPassword:passwordTF.text,
                                   ApiParameters.kConfirmPassword:confirmPasswordTF.text,
                                   ApiParameters.kcontact_us_by:"sadasd",
                                   ApiParameters.kterms_and_condition:"dada",
                                   ApiParameters.klogin_type:"0"
        ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.signup,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
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
                        nextVc.userName = self.mobileNoTF.text
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
extension SignUpViewController{
    func insuranceCompanyApi(){
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

extension UITextField {
    func disableAutoFill() {
        if #available(iOS 12, *) {
            textContentType = .oneTimeCode
        } else {
            textContentType = .init(rawValue: "")
        }
    }
}

extension UIView {
    func addBlackGradientLayerInForeground(frame: CGRect, colors: [UIColor]) {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{ $0.cgColor }
        self.layer.addSublayer(gradient)
    }
}
