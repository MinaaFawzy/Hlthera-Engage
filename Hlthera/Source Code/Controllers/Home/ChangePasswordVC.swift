//
//  ChangePasswordVC.swift
//  Hlthera
//
//  Created by Prashant on 14/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var labelCurrentPassword: UITextField!
    @IBOutlet weak var textFieldNewPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.font = .corbenRegular(ofSize: 15)
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    @IBAction func buttonChangePasswordTapped(_ sender: Any) {
        if String.getString(labelCurrentPassword.text).isEmpty{
            showAlertMessage.alert(message: "Please Enter Current Password".localize)
            return
        }
        if String.getString(textFieldNewPassword.text).isEmpty{
            showAlertMessage.alert(message: "Please Enter New Password".localize)
            return
        }
        if String.getString(textFieldConfirmPassword.text).isEmpty{
            showAlertMessage.alert(message: "Please Enter Confirm Password".localize)
            return
        }
        if String.getString(textFieldConfirmPassword.text) != String.getString(textFieldNewPassword.text){
            showAlertMessage.alert(message: "Please New & Confirm Password does not match".localize)
            return
        }
        changePasswordAPI()
    }
    
    @IBAction func buttonConfirmPasswordEyeTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isSelected ? (textFieldConfirmPassword.isSecureTextEntry = false) : (textFieldConfirmPassword.isSecureTextEntry = true)
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonNewPasswordEyeTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isSelected ? (textFieldNewPassword.isSecureTextEntry = false) : (textFieldNewPassword.isSecureTextEntry = true)
    }
    
    @IBAction func buttonCurrentPasswordEyeTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isSelected ? (labelCurrentPassword.isSecureTextEntry = false) : (labelCurrentPassword.isSecureTextEntry = true)
    }

}

extension ChangePasswordVC {
    
    func changePasswordAPI() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.kCurrentPassword:labelCurrentPassword.text ?? "",
            ApiParameters.kpassword:textFieldNewPassword.text ?? "",
                                   ApiParameters.kConfirmPassword:textFieldConfirmPassword.text ?? "",
        ]
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.updatePasswordWithOld,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    print(dictResult)
                    //let data = kSharedInstance.getDictionary(dictResult[kResponse])
                    if String.getString(dictResult["status"]) == "1"{
                        CommonUtils.showToast(message:String.getString(dictResult["message"] ))
//                        let alert = UIAlertController(title: String.getString(dictResult["message"] ), message: nil, preferredStyle: .alert)
//                       let action1 = UIAlertAction(title: AlertTitle.kOk, style: .cancel){_ in
//                        self.dismiss(animated: true, completion: nil)
//                       }
//                       alert.addAction(action1)
//                       UIApplication.shared.windows.first?.rootViewController?.present(alert , animated: true)
                        
                    } else {
                        //let alert = UIAlertController(title: "Password Changed Successfully!".localize, message: nil, preferredStyle: .alert)
                        //let action1 = UIAlertAction(title: AlertTitle.kOk, style: .cancel){_ in
                        //kSharedAppDelegate?.moveToLoginScreen()
                        //kSharedUserDefaults.setUserLoggedIn(userLoggedIn: false)
                        //}
                        //alert.addAction(action1)
                        //UIApplication.shared.windows.first?.rootViewController?.present(alert , animated: true)
                        showAlertMessage.alert(message: "Password Changed Successfully!")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            kSharedAppDelegate?.moveToLoginScreen()
                            kSharedUserDefaults.setUserLoggedIn(userLoggedIn: false)
                        })
                    }
                    
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

