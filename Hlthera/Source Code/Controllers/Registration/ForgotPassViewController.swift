//
//  ForgotPassViewController.swift
//  Hlthera
//
//  Created by Akash on 26/10/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ForgotPassViewController: UIViewController,UITextFieldDelegate {
    //MARK:- @IBOutlets
//    @IBOutlet weak var constraintTextFieldTrailing: NSLayoutConstraint!
//    @IBOutlet weak var buttonCountryCode: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageCheck: UIImageView!
//    @IBOutlet weak var imageCountryCode: UIImageView!
//    @IBOutlet weak var constraintCountryCodeWidth: NSLayoutConstraint!
//    @IBOutlet weak var constraintDividerWidth: NSLayoutConstraint!
    @IBOutlet var emailTf:UITextField!
    @IBOutlet weak var btnMobileNumber: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    //MARK:-Functions
    private func initialSetup(){
        
//        lblTitle.font = .corbenRegular(ofSize: 15)
        
        imageCheck.isHidden = true
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
//        emailTf.placeholder(text: "Mobile Number", color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        self.btnMobileNumber.isSelected = true
        self.emailTf.delegate = self
    }
    
    //MARK:- @IBAction
//    @IBAction func buttonCountryCodeTapped(_ sender: Any) {
//        AppsCountryPickers.showController(referense: self)  { (selectedCountry) in
//            self.buttonCountryCode.setTitle(selectedCountry?.countryCode, for: .normal)
//            self.imageCountryCode.image = selectedCountry?.image
//        }
//    }
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnMobileTapped(_ sender: UIButton) {
        self.emailTf.keyboardType =  UIKeyboardType.numberPad
        sender.isSelected = !sender.isSelected
        btnMobileNumber.isSelected = true
        btnEmail.isSelected = false
//        imageCountryCode.image = UIImage(named: "United-Arab-Emirates")
//        constraintDividerWidth.constant = 2
//        constraintTextFieldTrailing.constant = 10
//        constraintCountryCodeWidth.constant = 70
//        emailTf.placeholder(text: "Mobile Number", color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        emailTf.text = ""
        self.view.endEditing(true)
    }
    @IBAction func btnEmailTapped(_ sender: UIButton) {
        self.emailTf.keyboardType =  UIKeyboardType.emailAddress
        sender.isSelected = !sender.isSelected
        btnMobileNumber.isSelected = false
        btnEmail.isSelected = true
//        constraintCountryCodeWidth.constant = 0
//       constraintDividerWidth.constant = 0
//        constraintTextFieldTrailing.constant = 20
//       imageCountryCode.image = #imageLiteral(resourceName: "e_mail")
//        buttonCountryCode.setTitle("+971", for: .normal)
//        emailTf.placeholder(text: "E-mail", color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        emailTf.text = ""
        self.view.endEditing(true)
    }
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        if String.getString(emailTf.text).isEmpty{
            showAlertMessage.alert(message: "Please Enter \(btnEmail.isSelected ? ("Email") : ("Mobile Number".localize))")
            return
        }
        forgotPasswordAPI()
    }
}

extension ForgotPassViewController{
    func forgotPasswordAPI(){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.kusername: emailTf.text ?? ""
        ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.forgot_password,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    print(dictResult)
                    let data = kSharedInstance.getDictionary(dictResult[kResponse])
                    UserData.shared.saveData(data: data)
                    kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: String.getString(data[kAccessToken]))
                    guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kOtpVerificationVC) as? OtpVerificationViewController else {return}
                    nextVc.hasCameFrom = .forgotPass
                    nextVc.userName = self.emailTf.text
                    if String.getString(self.emailTf.text).isEmail(){
                        nextVc.subHeading = String.getString(self.emailTf.text)
                    }
                    else{
//                        nextVc.subHeading = String.getString(self.buttonCountryCode.titleLabel?.text) + String.getString(self.emailTf.text)
                    }
                    
                    self.navigationController?.pushViewController(nextVc, animated: true)
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
