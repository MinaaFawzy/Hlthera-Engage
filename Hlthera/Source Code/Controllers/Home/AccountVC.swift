//
//  AccountVC.swift
//  Hlthera
//
//  Created by Prashant on 14/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
//import JBTabBarAnimation

@available(iOS 15.0, *)

class AccountVC: UIViewController {
    
    @IBOutlet weak var iconAboveSettings: UIImageView!
    @IBOutlet weak var imageProfile: UIImageView!
    //@IBOutlet weak var constraintTableViewAccountHeight: NSLayoutConstraint!
    //@IBOutlet weak var constraintTableViewAppHeight: NSLayoutConstraint!
    //@IBOutlet weak var buttonArabic: UIButton!
    //@IBOutlet weak var buttonEnglish: UIButton!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonEditProfile: UIButton!
    //@IBOutlet weak var viewNotifications: UIView!
    @IBOutlet weak var viewMyDoctor: UIView!
    @IBOutlet weak var viewEPrescription: UIView!
    @IBOutlet weak var buttonCheckIn: UIButton!
    
    //@IBOutlet weak var viewServices: UIView!
    //@IBOutlet weak var viewMySavedCards: UIView!
    //@IBOutlet weak var tableViewAccount: UITableView!
    //@IBOutlet weak var tableViewApp: UITableView!
    //var accountList:[String] = ["Change Password","My Points","My Orders","My Communication","E-Prescription"]
    //var appList:[String] = ["About Us","Privacy Policy","FAQ's","Push notifications","Help","Rate App","Version","Contact Us","Refer App","Terms & Conditions","My Saved Address"]
    //    var accountListIcons:[UIImage] = [UIImage(named: "change_password") ?? UIImage(),UIImage(named: "my_points") ?? UIImage(),UIImage(named: "my_orders") ?? UIImage(),UIImage(named: "my_communication") ?? UIImage(),UIImage(named: "test_reports") ?? UIImage()]
    //    var appListIcons:[UIImage] = [UIImage(named: "about_us") ?? UIImage(),UIImage(named: "privacy_policy") ?? UIImage(),UIImage(named: "faqs") ?? UIImage(),UIImage(named: "push_notifications") ?? UIImage(),UIImage(named: "help-1") ?? UIImage(),UIImage(named: "Group 59368") ?? UIImage(),UIImage(named: "version") ?? UIImage(),UIImage(named: "contact_us") ?? UIImage(),UIImage(named: "contact_us") ?? UIImage(),UIImage(named: "terms") ?? UIImage(),UIImage(named: "my_save_address") ?? UIImage()]
    var mydelegate: ShareImageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStatusBar()
        //buttonCheckIn.backgroundColor = UIColor(hex: "#385B8A")
        //self.editProfileContainer.layer.borderWidth = 1
        //self.editProfileContainer.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        //self.editProfileContainer.layer.borderColor = UIColor.white.cgColor
        //self.editProfileContainer.layer.cornerRadius = 10;
        //self.editProfileContainer.clipsToBounds = true;
        
        //var image = UIImage(named: "edit_white")
        //let size = 30
        //image = image?.imageResize(sizeChange: CGSize(width: size,height: size))
        //buttonEditProfile.leftImage(image: image!, renderMode: .alwaysOriginal,
        //paddingTop: CGFloat(50),
        //paddingLeft: CGFloat(50),
        //paddingRight: CGFloat(50),
        //paddingBottom: CGFloat(50))
        
        if self.tabBarController?.isKind(of: JBTabBarController.self) ?? false{
            let vc = self.tabBarController as! JBTabBarController
            self.mydelegate = vc as! ShareImageDelegate
        }
//        setStatusBar(color: #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10){
            self.viewBackground.setGradientSettingsBackground()
            self.viewBackground.layer.cornerRadius = 25
            self.viewBackground.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        }
        
//        let tapSettinngAbove = UITapGestureRecognizer(target: self, action: #selector(self.handleTapAboveSettings(_:)))
//        iconAboveSettings.isUserInteractionEnabled = true;
//        iconAboveSettings.addGestureRecognizer(tapSettinngAbove)
        
        //buttonEnglish.isSelected = true
        //let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(_:)))
        //viewNotifications.addGestureRecognizer(tap1)
        //let savedCards = UITapGestureRecognizer(target: self, action: #selector(self.handleSavedCards(_:)))
        //viewMySavedCards.addGestureRecognizer(savedCards)
        //let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap2(_:)))
        //viewServices.addGestureRecognizer(tap2)
        let myDoctors = UITapGestureRecognizer(target: self, action: #selector(self.handleMyDoctors(_:)))
        viewMyDoctor.addGestureRecognizer(myDoctors)
        
        let ePrescription = UITapGestureRecognizer(target: self, action: #selector(self.handleTapEPrescription(_:)))
        viewEPrescription.addGestureRecognizer(ePrescription)
        
//        labelName.font = .CorbenBold(ofSize: 19)
        labelName.text = UserData.shared.fullName!.isEmpty ? "UserName".localize : UserData.shared.fullName?.localize
        labelEmail.text = UserData.shared.email
        
        imageProfile.downlodeImage(serviceurl: String.getString(UserData.shared.profilePic), placeHolder: UIImage(named: "no_data_image") ?? UIImage())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupStatusBar(red: 46, green: 122, blue: 197)
        self.downlodeImage(serviceurl: String.getString(UserData.shared.profilePic), placeHolder: UIImage(named: "placeholder"), completion: { image in
            self.mydelegate?.shareImage(image)
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupStatusBar()
    }
    
    @IBAction private func btnCheckInTapped(_ sender: UIButton) {
        //        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        //        let vc = storyBoard.instantiateViewController(identifier: CheckInViewController.getStoryboardID()) as! CheckInViewController
        //        vc.modalPresentationStyle = .pageSheet
        //        if let sheet = vc.sheetPresentationController {
        //            sheet.detents = [.medium()]
        //           }
        //           present(vc, animated: true, completion: nil)
        
        guard let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: CheckInsListViewController.getStoryboardID()) as? CheckInsListViewController else { return }
        //        vc.orderId = obj.order_id
        //        vc.hasCameFrom = .viewPharmacyOrder
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        guard let nextVc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: "SettingsVc") as? SettingsVc else { return }
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    @objc func handleTapEPrescription(_ sender: UITapGestureRecognizer? = nil) {
        CommonUtils.showToast(message: "Under development".localize)
    }
    
    @objc func handleTapAboveSettings(_ sender: UITapGestureRecognizer? = nil) {
        guard let nextVc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: "SettingsVc") as? SettingsVc else { return }
        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
    
    @objc func handleTap1(_ sender: UITapGestureRecognizer? = nil) {
        guard let nextVc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: "NotificationsVC") as? NotificationsVC else {return}
        nextVc.hasComeFrom = .account
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @objc func handleTap2(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.tabBarController?.selectedIndex = 2
        if let item = self.tabBarController?.tabBar.selectedItem {
            if let controller = self.tabBarController?.tabBar{
                self.tabBarController?.tabBar(controller, didSelect: item)
            }
        }
    }
    
    @objc func handleSavedCards(_ sender:UITapGestureRecognizer? = nil) {
        guard let nextVc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(identifier: "PaymentVC") as? PaymentVC else {return}
        nextVc.pageTitle = "My Saved Cards".localize
        nextVc.isSavedCards = true
        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
    
    @objc func handleMyDoctors(_ sender:UITapGestureRecognizer? = nil) {
        guard let nextVc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(identifier: "SearchDoctorListingVC") as? SearchDoctorListingVC else {return}
        nextVc.hasCameFrom = .settings
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    func changeNotifications(warning: Bool = true, on: UISwitch) {
        if on.isOn {
            kSharedUserDefaults.setNotificationsEnable(status:true)
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            UIApplication.shared.unregisterForRemoteNotifications()
            if warning{
                let alert = UIAlertController(title: "Disable Call Notifications".localize, message: "Disabling this will also disable incoming call notifications".localize, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes".localize, style: .destructive, handler: {_ in
                    kSharedUserDefaults.setNotificationsEnable(status:false)
                }))
                alert.addAction(UIAlertAction(title: "No".localize, style: .default, handler: {_ in
                    alert.dismiss(animated: true, completion: {
                        on.isOn = true
                        kSharedUserDefaults.setNotificationsEnable(status:true)
                    })
                }))
                self.navigationController?.present(alert, animated: true, completion: nil)
                
            }
            else{
                kSharedUserDefaults.setNotificationsEnable(status:false)
            }
            
        }
    }
    
    @IBAction private func buttonViewEditProfileTapped(_ sender: Any) {
        guard let nextVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Identifiers.kPersonalDetailsVC) as? PersonalDetailsViewController else {return}
        nextVc.hasCameFrom = .editProfile
        
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    //    @IBAction func buttonEnglishTapped(_ sender: UIButton) {
    //        buttonEnglish.isSelected = true
    //        buttonArabic.isSelected = false
    //        buttonArabic.setTitleColor(#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1), for: .normal)
    //        buttonEnglish.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1), for: .normal)
    //    }
    //    @IBAction func buttonArabicTapped(_ sender: Any) {
    //        buttonEnglish.isSelected = false
    //        buttonArabic.isSelected = true
    //        buttonEnglish.setTitleColor(#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1), for: .normal)
    //        buttonArabic.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1), for: .normal)
    //    }
    //    @IBAction func buttonLogOutTapped(_ sender: Any) {
    //        logOutApi()
    //        kSharedAppDelegate?.logout()
    //    }
    //    @IBAction func switchTapped(_ sender: UISwitch) {
    //        changeNotifications(on: sender)
    //    }
    
}
//extension AccountVC:UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        if tableView == tableViewAccount{
//
//            return accountList.count
//        }
//        else {
//            return appList.count
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTVC", for: indexPath) as! AccountTVC
//        if tableView == tableViewAccount{
//            tableView.separatorStyle = .singleLine
//            cell.selectionStyle = .none
//            cell.labelName.text = accountList[indexPath.row]
//            cell.imageIcon.image = accountListIcons[indexPath.row]
//            constraintTableViewAccountHeight.constant = CGFloat(accountList.count*65)
//
//        }
//        else {
//            tableView.separatorStyle = .singleLine
//            cell.switchSettings.transform = CGAffineTransform(scaleX:0.70, y: 0.65)
//            cell.selectionStyle = .none
//            cell.labelName.text = appList[indexPath.row]
//            cell.imageIcon.image = appListIcons[indexPath.row]
//            constraintTableViewAppHeight.constant = CGFloat(appList.count*65)
//            if indexPath.row == 3{
//                cell.switchSettings.isHidden = false
//                kSharedUserDefaults.getNotificationsEnable() ? (cell.switchSettings.isOn = true) : (cell.switchSettings.isOn = false)
//                changeNotifications(warning:false,on:cell.switchSettings)
//            }
//            else{
//                cell.switchSettings.isHidden = true
//            }
//        }
//
//
//        return cell
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 65
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView == tableViewAccount{
//            if indexPath.row == 0{
//                guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC else {return}
//                self.navigationController?.pushViewController(nextVc, animated: true)
//            }
//            if indexPath.row == 1{
//                guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "PointsVC") as? PointsVC else {return}
//                self.navigationController?.pushViewController(nextVc, animated: true)
//            }
//            if indexPath.row == 2{
//
//                guard let nextVc = UIStoryboard(name: "Pharmacy", bundle: nil).instantiateViewController(withIdentifier: PharmacyMyOrdersVC.getStoryboardID()) as? PharmacyMyOrdersVC else {return}
//
//                self.navigationController?.pushViewController(nextVc, animated: true)
//            }
//            if indexPath.row == 3{
//
//                CommonUtils.showToast(message: "Under Development")
//                return
//            }
//        }
//        else {
//            if indexPath.row == 0{
//                guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else {return}
//                nextVc.pageTitleString = "About Us"
//                nextVc.url = kBASEURL + "about_us"
//                self.navigationController?.pushViewController(nextVc, animated: true)
//            }
//            if indexPath.row == 1{
//                guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else {return}
//                nextVc.pageTitleString = "Privacy Policy"
//                nextVc.url = kBASEURL + "privacy_policy"
//                self.navigationController?.pushViewController(nextVc, animated: true)
//            }
//            if indexPath.row == 2{
//                guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else {return}
//                nextVc.pageTitleString = "FAQ"
//                nextVc.url = kBASEURL + "faq"
//                self.navigationController?.pushViewController(nextVc, animated: true)
//            }
//            if indexPath.row == 3{
//                guard let nextVc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: "NotificationsVC") as? NotificationsVC else {return}
//
//                self.navigationController?.pushViewController(nextVc, animated: true)
//            }
//            if indexPath.row == 6{
//                let alert = UIAlertController(title:"Hlthera App", message: "Version 1.0", preferredStyle: .alert)
//               let action1 = UIAlertAction(title: AlertTitle.kOk, style: .cancel){_ in
//                self.dismiss(animated: true, completion: nil)
//               }
//               alert.addAction(action1)
//               UIApplication.shared.windows.first?.rootViewController?.present(alert , animated: true)
//            }
//            if indexPath.row == 7{
//                guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as? ContactUsVC else {return}
//                self.navigationController?.pushViewController(nextVc, animated: true)
//            }
//            if indexPath.row == 8{
//                let textToShare = kAppName
//                if let myWebsite = NSURL(string: "http://www.hlthera.com") {
//                    let objectsToShare = [textToShare, myWebsite] as [Any]
//                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//
//                    activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
//                    self.present(activityVC, animated: true, completion: nil)
//                }
//            }
//            if indexPath.row == 9{
//                guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else {return}
//                nextVc.pageTitleString = "Terms and Conditions"
//                nextVc.url = kBASEURL + "term_condition"
//                self.navigationController?.pushViewController(nextVc, animated: true)
//            }
//            if indexPath.row == 10{
//                guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "SavedAddressesVC") as? SavedAddressesVC else {return}
//                self.navigationController?.pushViewController(nextVc, animated: true)
//            }
//        }
//
//
//    }
//
//
//}

extension UIView {
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(named: "11")!.cgColor, UIColor(named: "12")!.cgColor]
        //gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        //gradientLayer.endPoint = CGPoint(x: 1, y: 1.0)
        gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    func setGradientSettingsBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1).cgColor, #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1).cgColor]
        //gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        //gradientLayer.endPoint = CGPoint(x: 1, y: 1.0)
        gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 25
        gradientLayer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    func setGradientBackground2() {
        //        let gradientLayer = CAGradientLayer()
        //        gradientLayer.colors = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
        //        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        //        gradientLayer.endPoint = CGPoint(x: 1, y: 1.0)
        //        gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        //        gradientLayer.frame = self.bounds
        //        self.layer.insertSublayer(gradientLayer, at: 0)
        
        //var gradientView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 35))
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.frame.size
        gradientLayer.colors =
        [UIColor.white.withAlphaComponent(0).cgColor,UIColor.white.withAlphaComponent(1).cgColor]
        gradientLayer.locations = [0.4,0.7,0.7,1]
        //Use diffrent colors
        self.layer.addSublayer(gradientLayer)
    }
    func setGradientBackground3() {
        //        let gradientLayer = CAGradientLayer()
        //        gradientLayer.colors = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
        //        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        //        gradientLayer.endPoint = CGPoint(x: 1, y: 1.0)
        //        gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        //        gradientLayer.frame = self.bounds
        //        self.layer.insertSublayer(gradientLayer, at: 0)
        
        //var gradientView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 35))
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.frame.size
        gradientLayer.colors =
        [UIColor.white.withAlphaComponent(0).cgColor,UIColor.white.withAlphaComponent(1).cgColor]
        gradientLayer.locations = [0.75,0.9,0.9,1]
        //Use diffrent colors
        self.layer.addSublayer(gradientLayer)
    }
}

//extension AccountVC{
//    func logOutApi(){
//        CommonUtils.showHudWithNoInteraction(show: true)
//
//        let params:[String : Any] = [:]
//
//        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.logOut,                                                   requestMethod: .POST,
//                                                   requestParameters:params, withProgressHUD: false)
//        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
//
//            CommonUtils.showHudWithNoInteraction(show: false)
//
//            if errorType == .requestSuccess {
//
//                let dictResult = kSharedInstance.getDictionary(result)
//                switch Int.getInt(statusCode) {
//                case 200:
//                        print("logged out")
//                default:
//                    print(dictResult["message"])
//                    //CommonUtils.showToast(message: String.getString(dictResult["message"]))
//                }
//            } else if errorType == .noNetwork {
//                CommonUtils.showToast(message: kNoInternetMsg)
//
//            } else {
//                CommonUtils.showToast(message: kDefaultErrorMsg)
//            }
//        }
//    }
//}

public protocol ShareImageDelegate {
    func shareImage(_ iamge: UIImage)
}

