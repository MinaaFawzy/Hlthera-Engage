//
//  LoginVC.swift
//  Hlthera
//
//  Created by Akash on 23/10/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices

class LoginVc2: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageEmail: UIImageView!
    @IBOutlet weak var constraintViewDividerWidth: NSLayoutConstraint!
    @IBOutlet weak var imageCheck: UIImageView!
    @IBOutlet weak var imageCountryCode: UIImageView!
    @IBOutlet var emailTf: UITextField!
    @IBOutlet weak var btnCountryCodeWidthConstraint: NSLayoutConstraint!
    @IBOutlet var passwordTf:UITextField!
    //@IBOutlet var btnExploreGuest:UIButton!
    @IBOutlet weak var buttonCountryCode: UIButton!
    @IBOutlet var btnEye:UIButton!
    @IBOutlet weak var constraintTextFieldLeading: NSLayoutConstraint!
    @IBOutlet weak var viewConteny: UIView!
    @IBOutlet weak var switchRemember: UISwitch!
    @IBOutlet weak var scrollView: UIScrollView!
    var email:String?
    var mobile:String?
    let buttonFBLogin = FBLoginButton()

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    // MARK: - functions
    func initialSetup(){
        //        viewConteny.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        //        viewConteny.layer.cornerRadius = 30
        imageCheck.isHidden = true
        //        switchRemember.transform = CGAffineTransform(scaleX:0.70, y: 0.65)
        // imageEmail.image = #imageLiteral(resourceName: "e_mail")
        //imageEmail.isHidden = true
        imageCountryCode.isHidden = true
        self.buttonCountryCode.isHidden = true
        btnCountryCodeWidthConstraint.constant = 0
        constraintViewDividerWidth.constant = 0
        constraintTextFieldLeading.constant = 25
        // imageEmail.isHidden = false
        imageCountryCode.isHidden = true
        imageCheck.isHidden = true
        if UIScreen.main.bounds.height > 800{
            scrollView.isScrollEnabled = false
        }
        else {
            scrollView.isScrollEnabled = true
        }
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        emailTf.placeholder(text: "Enter E-mail or Phone".localize, color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        passwordTf.placeholder(text: "Enter Password".localize, color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        emailTf.delegate = self
        buttonFBLogin.permissions = ["public_profile", "email"]
        buttonFBLogin.delegate = self
        buttonFBLogin.isHidden = true
        GIDSignIn.sharedInstance()!.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !String.getString(textField.text).isNumberContains(){
            self.buttonCountryCode.isHidden = true
            btnCountryCodeWidthConstraint.constant = 0
            constraintViewDividerWidth.constant = 0
            constraintTextFieldLeading.constant = 25
            imageCountryCode.isHidden = true
            imageCheck.isHidden = true
            imageEmail.isHidden = false
            
        }else {
            imageEmail.isHidden = true
            imageCountryCode.isHidden = false
            self.buttonCountryCode.isHidden = false
            constraintViewDividerWidth.constant = 2
            constraintTextFieldLeading.constant = 10
            btnCountryCodeWidthConstraint.constant = 70
            if String.getString(textField.text).count >= 9 {
                imageCheck.isHidden = false
            }
            else{
                imageCheck.isHidden = true
            }
        }
    }
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    ////        if !String.getString(string).isNumberContains(){
    ////            self.buttonCountryCode.isHidden = true
    ////             btnCountryCodeWidthConstraint.constant = 0
    ////            constraintViewDividerWidth.constant = 0
    ////            constraintTextFieldLeading.constant = 25
    ////            imageEmail.isHidden = false
    ////            imageCountryCode.isHidden = true
    ////            imageCheck.isHidden = true
    ////
    ////        }else {
    ////            imageEmail.isHidden = true
    ////            imageCountryCode.isHidden = false
    ////            self.buttonCountryCode.isHidden = false
    ////            constraintViewDividerWidth.constant = 2
    ////            constraintTextFieldLeading.constant = 10
    ////            btnCountryCodeWidthConstraint.constant = 70
    ////            if String.getString(textField.text).count >= 9 {
    ////                imageCheck.isHidden = false
    ////            }
    ////            else{
    ////                imageCheck.isHidden = true
    ////            }
    ////        }
    //        return true
    //    }
    
    func getUserProfile(token: AccessToken?, userId: String?) {
        let graphRequest: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, middle_name, last_name, name, picture, email"])
        graphRequest.start { _, result, error in
            if error == nil {
                let data: [String: AnyObject] = result as! [String: AnyObject]
                
                // Facebook Id
                if let facebookId = data["id"] as? String {
                    print("Facebook Id: \(facebookId)")
                } else {
                    print("Facebook Id: Not exists")
                }
                //sample comment
                // Facebook First Name
                if let facebookFirstName = data["first_name"] as? String {
                    print("Facebook First Name: \(facebookFirstName)")
                } else {
                    print("Facebook First Name: Not exists")
                }
                
                // Facebook Middle Name
                if let facebookMiddleName = data["middle_name"] as? String {
                    print("Facebook Middle Name: \(facebookMiddleName)")
                } else {
                    print("Facebook Middle Name: Not exists")
                }
                
                // Facebook Last Name
                if let facebookLastName = data["last_name"] as? String {
                    print("Facebook Last Name: \(facebookLastName)")
                } else {
                    print("Facebook Last Name: Not exists")
                }
                
                // Facebook Name
                if let facebookName = data["name"] as? String {
                    print("Facebook Name: \(facebookName)")
                } else {
                    print("Facebook Name: Not exists")
                }
                
                // Facebook Profile Pic URL
                let facebookProfilePicURL = "https://graph.facebook.com/\(userId ?? "")/picture?type=large"
                print("Facebook Profile Pic URL: \(facebookProfilePicURL)")
                
                // Facebook Email
                if let facebookEmail = data["email"] as? String {
                    print("Facebook Email: \(facebookEmail)")
                } else {
                    print("Facebook Email: Not exists")
                }
                
                //                    print("Facebook Access Token: \(token?.tokenString ?? "")")
                
                
                self.logInRequest(id: String.getString(data["id"]), name: String.getString(data["name"]), email: String.getString(data["email"]), loginType: 2)
                
                
            } else {
                
                print("Error: Trying to get user's info")
            }
        }
    }
    
    //MARK:- @IBAction
    @IBAction func buttonBackTapped(_ sender: Any) {
        for controller in self.navigationController?.viewControllers ?? []{
            if controller.isKind(of: WalkthroughViewController.self){
                self.navigationController?.popToViewController(controller, animated:true)
                return
            }
        }
        guard let vc = UIStoryboard(name: Storyboards.kMain, bundle: nil).instantiateViewController(withIdentifier: WalkthroughViewController.getStoryboardID()) as? WalkthroughViewController else { return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnEyeTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnEye.isSelected{self.passwordTf.isSecureTextEntry = false}
        else{self.passwordTf.isSecureTextEntry = true}
    }
    @IBAction func btnCountryCodeTapped(_ sender: UIButton) {
        AppsCountryPickers.showController(referense: self)  { (selectedCountry) in
            self.buttonCountryCode.setTitle(selectedCountry?.countryCode, for: .normal)
            self.imageCountryCode.image = selectedCountry?.image
        }
    }
    @IBAction func btnForgotPassTapped(_ sender: UIButton) {
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kForgotPassVC) as? ForgotPassViewController else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    @IBAction func btnSignInTapped(_ sender: UIButton) {
        if String.getString(emailTf.text).isEmpty{
            showAlertMessage.alert(message: "Please Enter Email/Mobile Number".localize)
            return
        }
        else if String.getString(passwordTf.text).isEmpty{
            showAlertMessage.alert(message: "Please Enter Password".localize)
            return
        }
        logInRequest()
    }
    @IBAction func btnExploreGuestTapped(_ sender: UIButton) {
        //        guard let nextVc = self.storyboard?.instantiateViewController(identifier: "HomeScrenViewController") as? HomeScrenViewController else {return}
        //        self.navigationController?.pushViewController(nextVc, animated: true)
        //        kSharedUserDefaults.setUserLoggedIn(userLoggedIn: true)
    }
    @IBAction func btnJoinNowTapped(_ sender: UIButton) {
        //        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kSignUpVC) as? SignUpViewController else {return}
        //        self.navigationController?.pushViewController(nextVc, animated: true)
        
        
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kSignUpVc2) as? SignUpViewController2 else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
        
        
    }
    @IBAction func buttonFacebookTapped(_ sender: Any) {
        buttonFBLogin.sendActions(for: .touchUpInside)
    }
    @IBAction func buttonGoogleTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()!.signIn()
    }
    
    @IBAction func buttonAppleTapped(_ sender: Any) {
        self.handleAuthorizationAppleIDButtonPress()
    }
    
    
}
//MARK:-LoginVCApi
extension LoginVc2{
    func logInRequest(id:String,name:String,email:String,loginType:Int){
        let params = [
            ApiParameters.kdevice_type:"2",
            //ApiParameters.kdeviceToken:kSharedUserDefaults.getDeviceToken(),
            ApiParameters.kdeviceToken:"test",
            ApiParameters.klogin_type:String.getString(loginType),
            ApiParameters.ksocial_id:id,
            ApiParameters.kLatitude:"0",
            ApiParameters.kLongitude:"0",
            ApiParameters.kfullName:name,
            ApiParameters.kemail:email,
        ]
        loginInApi(params: params)
    }
    func logInRequest(){
        let params = [
            ApiParameters.kusername:String.getString(emailTf.text),
            ApiParameters.kpassword:String.getString(self.passwordTf.text),
            ApiParameters.kdevice_type:"2",
            //ApiParameters.kdeviceToken:kSharedUserDefaults.getDeviceToken(),
            //ApiParameters.kdeviceToken:kSharedUserDefaults.getDeviceToken(),
            ApiParameters.kdeviceToken:"test",
            ApiParameters.klogin_type:String.getString(0),
            ApiParameters.ksocial_id:"",
            ApiParameters.kLatitude:"0",
            ApiParameters.kLongitude:"0",
            ApiParameters.kcountryCode:String.getString(buttonCountryCode.titleLabel?.text)]
        loginInApi(params: params)
    }
    func loginInApi(params:[String:Any]){
        CommonUtils.showHudWithNoInteraction(show: true)
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.login,
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
                    kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: String.getString(data[kAccessToken]))
                    kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: data)
                    kSharedUserDefaults.setUserLoggedIn(userLoggedIn: true)
                    UserData.shared.saveData(data: data)
                    if UserData.shared.is_verify == "1"{
                        //                        let alert = UIAlertController(title: "Alert", message: "Coming Soon", preferredStyle: UIAlertController.Style.alert)
                        //                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        //                        self.present(alert, animated: true, completion: nil)
                        // if UserData.shared.is_profile_created{
                        
                        kSharedAppDelegate?.moveToLocationPermissionsScreen()
                        
                        kSharedUserDefaults.setUserLoggedIn(userLoggedIn: true)
                        //}
                        //                        else{
                        //                            guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kPersonalDetailsVC) as? PersonalDetailsViewController else {return}
                        //                            self.navigationController?.pushViewController(nextVc, animated: true)
                        //                        }
                        
                    }
                    else {
                        guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: Identifiers.kOtpVerificationVC) as? OtpVerificationViewController else {return}
                        
                        //                        if socialId != ""{
                        //                            nextVc.hasCameFrom = .signUp
                        //                        }
                        //                        else {
                        //                            nextVc.hasCameFrom = .login
                        //                        }
                        self.navigationController?.pushViewController(nextVc, animated: true)
                    }
                case 400:
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
extension LoginVc2:LoginButtonDelegate{
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if result?.isCancelled ?? false {
            print("Cancelled")
            
            
        } else if error != nil {
            print("ERROR: Trying to get login results")
        } else {
            print("Logged in")
            self.getUserProfile(token: result?.token, userId: result?.token?.userID)
            //print(result?.token?.userID)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // Do something after the user pressed the logout button
        print("You logged out!")
        
    }
}
extension LoginVc2:GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
                
            } else {
                print("\(error.localizedDescription)")
                
            }
            return
        }
        self.logInRequest(id: String.getString(user.userID), name: String.getString(user.profile?.name), email: String.getString(user.profile?.email), loginType: 1)
        
        // ...
    }
}
extension LoginVc2:ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
    
    
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    //MARK:- Apple delegates
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            
            //          self.isApple = "1"
            //         self.appleModel = AppleModel.init(social:appleIDCredential.user, name: appleIDCredential.fullName?.givenName ?? "", email: appleIDCredential.email ?? "")
            
            //requestSocialSignUp(name: String.getString(appleIDCredential.fullName?.givenName), id: String.getString(appleIDCredential.user), profilePicUrl: " ", email: String.getString(appleIDCredential.email), type: 2)
            self.logInRequest(id: String.getString(appleIDCredential.user), name: String.getString(appleIDCredential.fullName), email: String.getString(appleIDCredential.email), loginType: 4)
            
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
    
    
}
