//
//  ResetPassViewController.swift
//  Hlthera
//
//  Created by Akash on 26/10/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class ResetPassViewController: UIViewController {
    
    @IBOutlet var btnEyeNewPass:UIButton!
    @IBOutlet var btnEyeReEnterPass:UIButton!
    @IBOutlet var newPassTf:UITextField!
    @IBOutlet var reEnterPassTf:UITextField!
    
    @IBOutlet weak var lblTitle: UILabel!
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        lblTitle.font = .corbenRegular(ofSize: 15)
        
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    //MARK:- FUNCTIONS
 
    //MARK:- @IBAction
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnEyeNewPassTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnEyeNewPass.isSelected{self.newPassTf.isSecureTextEntry = false}
            else{self.newPassTf.isSecureTextEntry = true}
    }
    @IBAction func btnEyeReEnterPassTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnEyeReEnterPass.isSelected{self.reEnterPassTf.isSecureTextEntry = false}
            else{self.reEnterPassTf.isSecureTextEntry = true}
    }
    @IBAction func btnResetPassTapped(_ sender: UIButton) {
        //self.validationField()
        resetPassApi()
    }
}
//MARK:-ResetPassApi
extension ResetPassViewController{
    func resetPassApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.kpassword:newPassTf.text ?? "",
                                   ApiParameters.kConfirmPassword:reEnterPassTf.text ?? "",
        ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.update_password,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    
                    let data = kSharedInstance.getDictionary(dictResult[kResponse])
                    kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: data)
                    UserData.shared.saveData(data: data)
                    guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kLoginVc) as? LoginVC else {return}
                    self.navigationController?.pushViewController(nextVc, animated: true)
                    
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
