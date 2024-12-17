//
//  SettingsVc.swift
//  Hlthera
//
//  Created by Ahmed Hegazy on 09/12/2022.
//  Copyright © 2022 Fluper. All rights reserved.
//

import UIKit
import MOLH

class SettingsVc: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var buttonArabic: UIButton!
    @IBOutlet weak var buttonEnglish: UIButton!
    @IBOutlet weak var tableViewAccount: UITableView!
    @IBOutlet weak var tableViewApp: UITableView!
    @IBOutlet weak var constraintTableViewAccountHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintTableViewAppHeight: NSLayoutConstraint!
    
    var mydelegate: ShareImageDelegate?
    
    var accountList: [String] = [
        "About Us".localize,
        "Privacy Policy".localize,
        "Terms & Conditions".localize,
        "Help".localize,
        "FAQ's".localize,
        "Contact Us".localize,
        "Push notifications".localize,
        "Change Password".localize,
        "Face ID",
        "Saved Address",
        "Refer App".localize,
        "Rate App".localize,
        "Delete account".localize,
    ]
    
    var accountListIcons: [UIImage] = [
        UIImage(named: "aboutus2") ?? UIImage(),
        UIImage(named: "privacy2") ?? UIImage(),
        UIImage(named: "terms2") ?? UIImage(),
        UIImage(named: "help2") ?? UIImage(),
        UIImage(named: "faq2") ?? UIImage(),
        UIImage(named: "contact_us") ?? UIImage(),
        UIImage(named: "pushnotification2") ?? UIImage(),
        UIImage(named: "changepass2") ?? UIImage(),
        UIImage(named: "faceId") ?? UIImage(),
        UIImage(named: "my_save_address") ?? UIImage(),
        UIImage(named: "refrerapp2") ?? UIImage(),
        UIImage(named: "rateapp2") ?? UIImage(),
        UIImage(named: "st_delete_account") ?? UIImage()
        
        //====================================
        //UIImage(named: "about_us") ?? UIImage(),
        //UIImage(named: "privacy_policy") ?? UIImage(),
        //UIImage(named: "terms") ?? UIImage(),
        //UIImage(named: "help-1") ?? UIImage(),
        //UIImage(named: "faqs") ?? UIImage(),
        //UIImage(named: "push_notifications") ?? UIImage(),
        //UIImage(named: "change_password") ?? UIImage(),
        //UIImage(named: "change_password") ?? UIImage(),//face id
        //UIImage(named: "my_save_address") ?? UIImage(),
        //UIImage(named: "my_save_address") ?? UIImage(),
        //UIImage(named: "my_save_address") ?? UIImage(), //"Refer App",
        //UIImage(named: "my_save_address") ?? UIImage(), //  "Rate App",
        //UIImage(named: "my_save_address") ?? UIImage()// "Delete account",
        //====================================
        //UIImage(named: "my_points") ?? UIImage(),
        //UIImage(named: "my_communication") ?? UIImage(),
        //UIImage(named: "test_reports") ?? UIImage(),
        //UIImage(named: "Group 59368") ?? UIImage(),
        //UIImage(named: "version") ?? UIImage(),
        //UIImage(named: "contact_us") ?? UIImage(),
        //UIImage(named: "contact_us") ?? UIImage(),
        //UIImage(named: "my_orders") ?? UIImage()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
//        buttonArabic.isHidden = true
//        buttonEnglish.isHidden = true
        self.tableViewAccount.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        //buttonEnglish.isSelected = !(LocalizationManager.shared.getLanguage() == .Arabic)
        //buttonArabic.isSelected = LocalizationManager.shared.getLanguage() == .Arabic
        //let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(_:)))
        //viewNotifications.addGestureRecognizer(tap1)
        //let savedCards = UITapGestureRecognizer(target: self, action: #selector(self.handleSavedCards(_:)))
        //viewMySavedCards.addGestureRecognizer(savedCards)
        //let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap2(_:)))
        //viewServices.addGestureRecognizer(tap2)
        //let myDoctors = UITapGestureRecognizer(target: self, action: #selector(self.handleMyDoctors(_:)))
        //viewMyDoctor.addGestureRecognizer(myDoctors)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func goToPointsVc() {
        guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "PointsVC") as? PointsVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    func goToPharmacy() {
        guard let nextVc = UIStoryboard(name: "Pharmacy", bundle: nil).instantiateViewController(withIdentifier: PharmacyMyOrdersVC.getStoryboardID()) as? PharmacyMyOrdersVC else {return}
        
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    func goToChangePassword() {
        guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
    }

    func goToAboutUs() {
        guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else { return }
        nextVc.pageTitleString = "About Us".localize
        nextVc.url = kBASEURL + "about_us"
        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
    
    func goToHelp() {
        guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else { return }
        nextVc.pageTitleString = "Help".localize
        nextVc.url = kBASEURL + "help"
        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
    
    func goToPrivacyPolicy() {
        guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else { return }
        nextVc.pageTitleString = "Privacy Policy".localize
        nextVc.url = kBASEURL + "privacy_policy"
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    func goToFaqs() {
        guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else { return }
        nextVc.pageTitleString = "FAQ".localize
        nextVc.url = kBASEURL + "faq"
        self.navigationController?.pushViewController(nextVc, animated: true)
    }

    func goToPushNotifications() {
        guard let nextVc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: "NotificationsVC") as? NotificationsVC else {return}
        nextVc.hasComeFrom = .settings
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    func showVersionAlert() {
        let alert = UIAlertController(title:"Hlthera App", message: "Version 1.0", preferredStyle: .alert)
        let action1 = UIAlertAction(title: AlertTitle.kOk, style: .cancel){_ in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action1)
        UIApplication.shared.windows.first?.rootViewController?.present(alert , animated: true)
    }
    
    func goToContactUs() {
        guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as? ContactUsVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    func referApp() {
        let textToShare = kAppName
        if let myWebsite = NSURL(string: "http://www.hlthera.com") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func goToTermsAndConditions() {
        guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else {return}
        nextVc.pageTitleString = "Terms and Conditions".localize
        nextVc.url = kBASEURL + "term_condition"
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    func goToSavedAddress() {
        guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "SavedAddressesVC") as? SavedAddressesVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    func goToSavedCards() {
        guard let nextVc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(identifier: "PaymentVC") as? PaymentVC else {return}
        nextVc.pageTitle = "My Saved Cards".localize
        nextVc.isSavedCards = true
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    // MARK: - Actions
    @objc func handleTap1(_ sender: UITapGestureRecognizer? = nil) {
        guard let nextVc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: "NotificationsVC") as? NotificationsVC else {return}
        nextVc.hasComeFrom = .settings
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
            if warning {
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
    
    @IBAction func buttonEnglishTapped(_ sender: UIButton) {
        buttonEnglish.isSelected = true
        buttonArabic.isSelected = false
        buttonArabic.setTitleColor(#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1), for: .normal)
        buttonEnglish.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1), for: .normal)
        changeAppLanguage()
    }
    
    @IBAction func buttonArabicTapped(_ sender: Any) {
        buttonEnglish.isSelected = false
        buttonArabic.isSelected = true
        buttonEnglish.setTitleColor(#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1), for: .normal)
        buttonArabic.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1), for: .normal)
        changeAppLanguage()
    }
    
    @IBAction func buttonLogOutTapped(_ sender: Any) {
        logOutApi()
        kSharedAppDelegate?.logout()
    }
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        changeNotifications(on: sender)
    }
    
    @IBAction func onVersionTapClickAction(_ sender: Any) {
        showVersionAlert()
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SettingsVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTVC", for: indexPath) as! AccountTVC
        
        tableView.separatorStyle = .singleLine
        cell.selectionStyle = .none
        cell.labelName.text = accountList[indexPath.row].localize
        cell.imageIcon.image = accountListIcons[indexPath.row]
        cell.backgroundImageIcon.image = UIImage(named: "circle")
        if indexPath.row == 12 {
            cell.backgroundImageIcon.image = accountListIcons[indexPath.row]
            cell.imageIcon.isHidden = true
        }
        constraintTableViewAccountHeight.constant = CGFloat(accountList.count*65)
        //if indexPath.row == 3 {
        //cell.switchSettings.isHidden = false
        //kSharedUserDefaults.getNotificationsEnable() ? (cell.switchSettings.isOn = true) : (cell.switchSettings.isOn = false)
        //changeNotifications(warning:false,on:cell.switchSettings)
        //} else {
        //cell.switchSettings.isHidden = true
        //}
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row == 0 {
            goToAboutUs()
        }
        if indexPath.row == 1 {
            goToPrivacyPolicy()
        }
        if indexPath.row == 2 {
            goToTermsAndConditions()
        }
        if indexPath.row == 3 {
            goToHelp()
        }
        if indexPath.row == 4 {
            goToFaqs()
        }
        if indexPath.row == 5 {
            goToContactUs()
        }
        if indexPath.row == 6 {
            goToPushNotifications()
        }
        if indexPath.row == 7 {
            goToChangePassword()
        }
        if indexPath.row == 9 {
            goToSavedAddress()
        }
        //if indexPath.row == 9{
        //goToSavedCards()
        //}
        
        if indexPath.row == 10 {
            referApp()
        }
    }
}

extension SettingsVc {
    func logOutApi() {
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.logOut,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    print("logged out")
                default:
                    print(dictResult["message"])
                    //CommonUtils.showToast(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToast(message: kNoInternetMsg.localize)
                
            } else {
                CommonUtils.showToast(message: kDefaultErrorMsg.localize)
            }
        }
    }
}
