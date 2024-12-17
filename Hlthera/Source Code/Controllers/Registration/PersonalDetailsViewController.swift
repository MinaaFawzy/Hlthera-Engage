//
//  PersonalDetailsViewController.swift
//  Hlthera
//
//  Created by Akash on 26/10/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import DropDown
import GoogleMaps
//import JBTabBarAnimation

var isFirst = true

class PersonalDetailsViewController: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var viewMale: UIView!
    @IBOutlet weak var viewFemale: UIView!
    @IBOutlet weak var constraintTopEditProfileShow: NSLayoutConstraint!
    @IBOutlet weak var constraintTopEditProfile: NSLayoutConstraint!
    @IBOutlet weak var buttonBackEditProfile: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelPercentage: UILabel!
    @IBOutlet var fullNameTF:UITextField!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet var emailIDTF:UITextField!
    @IBOutlet var mobileNoTF:UITextField!
    @IBOutlet var DobTF:UITextField!
    @IBOutlet weak var btnCrossBack: UIButton!
    @IBOutlet var NationalityTF:UITextField!
    @IBOutlet var UAEResidenceTF:UITextField!
    @IBOutlet var insuranceNoTF:UITextField!
    @IBOutlet var expirtDateTF:UITextField!
    @IBOutlet var maritalTF:UITextField!
    @IBOutlet var addressTF:UITextField!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnCrossFront: UIButton!
    @IBOutlet weak var imgMale: UIImageView!
    @IBOutlet weak var lblMale: UILabel!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgFemale: UIImageView!
    @IBOutlet weak var imgFront: UIImageView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var lblFemale: UILabel!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnUploadFront: UIButton!
    @IBOutlet weak var btnUploadBack: UIButton!
    @IBOutlet weak var btnMaritialStatus: UIButton!
    
    var imagePicker = UIImagePickerController()
    let datePickerView = UIDatePicker()
    var nationality = [NationalityModel]()
    var selectedDate = Date()
    var dropDown = DropDown()
    var datePickerFor:Bool = false
    var gender: String = "1"
    var userProfileData:UserProfileModel?
    var fromImagePicker = false
    var resident: Int?
    var totalProgressBarWidth = 0.0
    var hasCameFrom: HasCameFrom?
    var latitude = 19.0760
    var longitude = 72.8777
    var locationManager = CLLocationManager()
    var currentLocation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dob = self.DobTF.text ?? ""
        progressView.transform = CGAffineTransform(scaleX: 1, y: 2)
        progressView.layer.cornerRadius = 5
        progressView.clipsToBounds = true
        progressView.progress = Float(progressGlobal/100)
        labelPercentage.text = "\(String.getString(progressGlobal))%" + "Profile Completed".localize
        
        if imgBack.image == UIImage(named: "placeholder_img"){
            btnCrossBack.isHidden = true
        }
        else {
            btnCrossBack.isHidden = false
        }
        if imgFront.image == UIImage(named: "placeholder_img"){
            btnCrossFront.isHidden = true
        }
        else {
            btnCrossFront.isHidden = false
        }
        setupDatePicker()
        self.imgProfile.downlodeImage(serviceurl: String.getString(UserData.shared.profilePic), placeHolder: #imageLiteral(resourceName: "placeholder"))
        self.lblName.text = UserData.shared.fullName?.localize
        if String.getString(UserData.shared.email).isEmpty{
            self.emailIDTF.isUserInteractionEnabled = true
        }
        else{
            self.emailIDTF.text = UserData.shared.email?.localize
        }
        if String.getString(UserData.shared.mobileNumber).isEmpty{
            self.mobileNoTF.isUserInteractionEnabled = true
        }
        else{
            self.mobileNoTF.text = UserData.shared.mobileNumber?.localize
        }
        self.fullNameTF.text = "\(String.getString(UserData.shared.fullName))".localize
        if !self.fromImagePicker{
            self.getProfileDetails()
            self.fromImagePicker = false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    @objc func viewMaleTapped(_ sender: UITapGestureRecognizer){
        viewMale.backgroundColor = UIColor().hexStringToUIColor(hex: "#E8EBEE")
        viewFemale.backgroundColor = .clear
        
    }
    
    @objc func viewFemaleTapped(_ sender: UITapGestureRecognizer){
        viewMale.backgroundColor = .clear
        viewFemale.backgroundColor = UIColor().hexStringToUIColor(hex: "#E8EBEE")
        
    }
    
    func initialSetup() {
        
        viewFemale.backgroundColor = UIColor().hexStringToUIColor(hex: "#E8EBEE")
        viewMale.isUserInteractionEnabled = true;
        viewFemale.isUserInteractionEnabled = true;
        let tapGestureMale = UITapGestureRecognizer(target: self, action: #selector(self.viewMaleTapped))
        viewMale.addGestureRecognizer(tapGestureMale)
        let tapGestureFemale = UITapGestureRecognizer(target: self, action: #selector(self.viewFemaleTapped))
        viewFemale.addGestureRecognizer(tapGestureFemale)
        
        self.lblName.font = .CorbenBold(ofSize: 15)
        
        self.locationManagerInitialSetup(locationManager: locationManager)
        
        
//        setStatusBar(color: #colorLiteral(red: 0.1019607843, green: 0.2509803922, blue: 0.4274509804, alpha: 1))
        fullNameTF.placeholder(text: "Full Name".localize, color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        emailIDTF.placeholder(text: "Email ID".localize, color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        mobileNoTF.placeholder(text: "Mobile Number".localize, color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        DobTF.placeholder(text: "Date of Birth".localize, color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        NationalityTF.placeholder(text: "Nationalty".localize, color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        UAEResidenceTF.placeholder(text: "UAE Resident or Non UAE Resident".localize, color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        insuranceNoTF.placeholder(text: "Insurance Number".localize, color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        expirtDateTF.placeholder(text: "Expiry Date".localize, color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        maritalTF.placeholder(text: "Marital status".localize, color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        addressTF.placeholder(text: "Address".localize, color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        nationalityApi()
        imagePicker.delegate = self
        DobTF.delegate = self
        expirtDateTF.delegate = self
        self.expirtDateTF.inputView = self.datePickerView
        self.expirtDateTF.inputAccessoryView = self.getToolBar()
        self.DobTF.inputView = self.datePickerView
        self.DobTF.inputAccessoryView = self.getToolBar()
        //AutoFill Data
        DobTF.delegate = self
        expirtDateTF.delegate = self
        imgFront.image = UIImage(named: "placeholder_img")
        imgBack.image = UIImage(named: "placeholder_img")
        switch hasCameFrom{
        case .editProfile:
            isFirst = false
            constraintTopEditProfileShow.isActive = true
            constraintTopEditProfileShow.constant = 15
            constraintTopEditProfile.isActive = false
            buttonBackEditProfile.isHidden = false
        default:
            isFirst = true
            constraintTopEditProfileShow.isActive = false
            constraintTopEditProfile.constant = 30
            constraintTopEditProfile.isActive = true
            buttonBackEditProfile.isHidden = true
        }
    }
    
    func fixOrientation(img: UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImage.Orientation.up) {
            return img;
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext();
        return normalizedImage;
        
    }
    
    func setupDatePicker() {
        if #available(iOS 13.4, *) {
            datePickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerView.preferredDatePickerStyle = .wheels
            datePickerView.preferredDatePickerStyle = .wheels
        }
        
        self.datePickerView.datePickerMode = .date
        let currentDate = Date()
        var dateComponents = DateComponents()
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = -100
        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
        dateComponents.year = 10
        let maxDate = calendar.date(byAdding: dateComponents, to: currentDate)
        datePickerView.maximumDate = maxDate
        datePickerView.minimumDate = minDate
        self.DobTF.inputView = self.datePickerView
        self.DobTF.inputAccessoryView = self.getToolBar()
        self.expirtDateTF.inputView = self.datePickerView
        self.expirtDateTF.inputAccessoryView = self.getToolBar()
    }
    // MARK: - Function for Date Of Birth
    func getToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let myColor : UIColor = UIColor( red: 2/255, green: 14/255, blue:70/255, alpha: 1.0 )
        toolBar.tintColor = myColor
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done".localize, style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localize, style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    
    @objc func doneClick(for:Int) {
        self.view.endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if self.datePickerFor{
            self.expirtDateTF.text = dateFormatter.string(from: self.datePickerView.date)
            self.selectedDate = self.datePickerView.date
        }else{
            self.DobTF.text = dateFormatter.string(from: self.datePickerView.date)
            self.selectedDate = self.datePickerView.date
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0{
            self.datePickerFor = false
            self.datePickerView.maximumDate = Date()
            var dateComponents = DateComponents()
            let calendar = Calendar.init(identifier: .gregorian)
            dateComponents.year = -100
            let minDate = calendar.date(byAdding: dateComponents, to: Date())
            self.datePickerView.minimumDate = minDate
            
        }else{
            self.datePickerFor = true
            var dateComponents = DateComponents()
            let calendar = Calendar.init(identifier: .gregorian)
            dateComponents.year = 100
            self.datePickerView.maximumDate = calendar.date(byAdding: dateComponents, to: Date())
            let minDate = Date()
            self.datePickerView.minimumDate = minDate
        }
        return true
    }
    
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
    
    @IBAction func buttonBackPressed(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: JBTabBarController.self) {
                self.navigationController!.popToViewController(controller, animated: false)
                return
            }
        }
        kSharedAppDelegate?.moveToHomeScreen(index: 4)
    }
    
    @IBAction func btnCameraTapped(_ sender: UIButton) {
        sender.tag = 1
        CommonUtils.imagePicker(viewController: self)
    }
    
    @IBAction func btnMedicalIDTapped(_ sender: UIButton) {
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kMedicalIDVC) as? MedicalIDViewController else {return}
        self.navigationController?.pushViewController(nextVc, animated: false)
    }
    
    @IBAction func btnLifeStyleTapped(_ sender: UIButton) {
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kLifeStyleVC) as? LifeStyleViewController else {return}
        self.navigationController?.pushViewController(nextVc, animated: false)
    }
    
    @IBAction func btnMaleTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if btnMale.isSelected{
            self.btnFemale.isSelected = false
            self.imgMale.image = #imageLiteral(resourceName: "radio_active")
            self.lblMale.textColor = #colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)
            self.imgFemale.image = #imageLiteral(resourceName: "radio")
            self.lblFemale.textColor = #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1)
            self.gender = "1"
        }
    }
    
    @IBAction func btnFemaleTapped(_ sender: UIButton) {
        
        
        sender.isSelected = !sender.isSelected
        if btnFemale.isSelected{
            self.btnMale.isSelected = false
            self.imgFemale.image = #imageLiteral(resourceName: "radio_active")
            self.lblFemale.textColor = #colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)
            self.imgMale.image = #imageLiteral(resourceName: "radio")
            self.lblMale.textColor = #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1)
            self.gender = "2"
        }
    }
    
    @IBAction func btnNationalityTapped(_ sender: UIButton) {
        dropDown.anchorView = sender
        dropDown.dataSource = self.nationality.map{String.getString($0.nationality)}
        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
            self.NationalityTF.text = item
        }
        dropDown.width = self.NationalityTF.frame.width
        dropDown.show()
    }
    
    @IBAction func btnUAEResidentTapped(_ sender: UIButton) {
        dropDown.anchorView = sender
        let areaArray = ["Non-UAE Resident".localize, "UAE Resident".localize]
        dropDown.dataSource = areaArray as! [String]
        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
            self.resident = index
            self.UAEResidenceTF.text = item
        }
        dropDown.width = self.UAEResidenceTF.frame.width
        dropDown.show()
    }
    
    @IBAction func btnCrossFrontTapped(_ sender: UIButton) {
        imgFront.image = UIImage(named: "placeholder_img")
        btnCrossFront.isHidden = true
    }
    
    @IBAction func btnUploadFrontTapped(_ sender: UIButton) {
        sender.tag = 1
        CommonUtils.imagePicker(viewController: self)
    }
    
    @IBAction func btnCrossBackTapped(_ sender: UIButton) {
        imgBack.image = UIImage(named: "placeholder_img")
        btnCrossBack.isHidden = true
    }
    
    @IBAction func btnUploadBackTapped(_ sender: UIButton) {
        sender.tag = 1
        CommonUtils.imagePicker(viewController: self)
    }
    
    @IBAction func btnMaritalStatusTapped(_ sender: UIButton) {
        dropDown.anchorView = sender
        let areaArray = ["Single".localize, "Married".localize]
        dropDown.dataSource = areaArray as! [String]
        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
            self.maritalTF.text = item
        }
        dropDown.width = self.maritalTF.frame.width
        dropDown.show()
    }
    
    @IBAction func btnSaveProfileTapped(_ sender: UIButton) {
        validationField()
    }
    
    @IBAction func buttonMyLocationTapped(_ sender: Any) {
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            self.addressTF.text =  LocationManager.sharedInstance.currentLocation
        case .restricted, .denied:
            CommonUtils.showToast(message: "Please Enable Location Permissions from Settings".localize)
            return
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        default: break
        }
    }

    @IBAction func skipTapped(_ sender: Any) {
        kSharedAppDelegate?.moveToHomeScreen(index: 1)
    }
}

extension PersonalDetailsViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let selectedImage: UIImage = info[.originalImage] as! UIImage
        if btnCamera.tag == 1 {
            imgProfile.image = self.fixOrientation(img: selectedImage)
            imgProfile.restorationIdentifier = " "
            profilePictureApi()
            btnCamera.tag = 0
        } else if btnUploadFront.tag == 1 {
            imgFront.image  = selectedImage
            btnUploadFront.tag = 0
            btnCrossFront.isHidden = false
        } else if btnUploadBack.tag == 1 {
            imgBack.image  = selectedImage
            btnUploadBack.tag = 0
            btnCrossBack.isHidden = false
        }
        self.fromImagePicker = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PersonalDetailsViewController {
    func getProfileDetails() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.kGetProfileDetails,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    
                    
                    let data = kSharedInstance.getDictionary(dictResult["result"])
                    self.userProfileData = UserProfileModel(data: data)
                    DispatchQueue.main.async {
                        setData(userData:self.userProfileData ?? UserProfileModel(data: [:]))
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
        
        func setData(userData: UserProfileModel) {
            self.progressView.progress = Float(userData.progress/100)
            self.labelPercentage.text = "\(String.getString(userData.progress))% Profile Completed".localize
            progressGlobal = userData.progress
            self.fullNameTF.text   = userData.fullname
            self.emailIDTF.text    = userData.email
            self.mobileNoTF.text   = userData.mobileNumber
            //            self.btnMale.isSelected = userData.gender == "1" ? true:false
            //            self.btnFemale.isSelected = userData.gender == "2" ? true:false
            self.DobTF.text          = userData.dateOfBirth
            self.NationalityTF.text  = userData.nationality
            self.imgFront.downlodeImage(serviceurl: String.getString(userData.insuranceFront), placeHolder: #imageLiteral(resourceName: "placeholder_img"))
            self.imgBack.downlodeImage(serviceurl: String.getString(userData.insuranceBack), placeHolder: #imageLiteral(resourceName: "placeholder_img"))
            self.insuranceNoTF.text = userData.insuranceNumber
            self.expirtDateTF.text = userData.insuranceExpiry
            
            self.addressTF.text = String.getString(userData.address).isEmpty ? ( LocationManager.sharedInstance.currentLocation) : (userData.address)
            if !isFirst {
                if userData.isCountryResident == "0" {
                    self.UAEResidenceTF.text = "Non-UAE Resident".localize
                } else {
                    self.UAEResidenceTF.text = "UAE Resident".localize
                }
                if userData.maritalStatus == "0" {
                    self.maritalTF.text = "Single".localize
                } else {
                    self.maritalTF.text = "Married".localize
                }
            }
        }
    }
    
    func profilePictureApi() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        
        let images:[String:Any] = ["imageName":ApiParameters.kprofile_picture,
                                   "image": self.imgProfile.image!]
        TANetworkManager.sharedInstance.requestMultiPart(withServiceName: ServiceName.change_avtar,
                                                         requestMethod: .post,
                                                         requestImages: [images],
                                                         requestVideos: [:],
                                                         requestData: params)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard self != nil else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    UserData.shared.profilePic = String.getString(dictResult["result"])
                    self?.imgProfile.downlodeImage(serviceurl: String.getString(UserData.shared.profilePic), placeHolder: #imageLiteral(resourceName: "placeholder"))
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

extension PersonalDetailsViewController {
    func profileScreenApi() {
        dob = String.getString(DobTF.text)
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.kemail:userProfileData?.email,
                                   ApiParameters.kMobileNumber:userProfileData?.mobileNumber,
                                   ApiParameters.kfullName:fullNameTF.text,
                                   ApiParameters.kgender:gender,
                                   ApiParameters.kdob:DobTF.text,
                                   ApiParameters.knationality:NationalityTF.text,
                                   ApiParameters.kis_country_resident:String.getString(self.resident),
                                   ApiParameters.kinsurance_number:insuranceNoTF.text,
                                   ApiParameters.kinsurance_expiry:expirtDateTF.text,
                                   ApiParameters.kmarital_status:String.getString(maritalTF.text)  == "Single" ? "0" : "1",
                                   ApiParameters.kaddress:addressTF.text,
                                   ApiParameters.ksteps:"1"]
        
        let images = [["imageName":ApiParameters.kinsurance_front,"image":self.imgFront.image],
                      ["imageName":ApiParameters.kinsurance_back,"image":self.imgBack.image]]
        TANetworkManager.sharedInstance.requestMultiPart(withServiceName: ServiceName.create_profile,
                                                         requestMethod: .post,
                                                         requestImages: images,
                                                         requestVideos: [:],
                                                         requestData: params)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard self != nil else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data = kSharedInstance.getDictionary(dictResult["result"])
                    let userInfo = kSharedInstance.getDictionary(data["userinfo"])
                    kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: String.getString(userInfo[kAccessToken]))
                    UserData.shared.profilePic = String.getString(userInfo["profile_picture"])
                    UserData.shared.email = String.getString(userInfo["email"])
                    UserData.shared.firstName = String.getString(userInfo["first_name"])
                    UserData.shared.lastName = String.getString(userInfo["last_name"])
                    UserData.shared.mobileNumber = String.getString(userInfo["mobile_number"])
                    guard let nextVc = self?.storyboard?.instantiateViewController(identifier: Identifiers.kMedicalIDVC) as? MedicalIDViewController else {return}
                    dob = self?.DobTF.text ?? ""
                    isFirst = false
                    nextVc.profileComplete = "40% Profile completed".localize
                    self?.navigationController?.pushViewController(nextVc, animated: false)
                    
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

// MARK: - nationalityApi
extension PersonalDetailsViewController {
    func nationalityApi() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.nationality,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data = kSharedInstance.getDictionaryArray(withDictionary: dictResult[kResponse])
                    self.nationality = data.map{NationalityModel(data:$0)}
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

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

extension PersonalDetailsViewController {
    func getLocationDetails(latitude: Double, longitude: Double, completion: @escaping (SavedAddressModel) -> ()) {
        let geocoder = GMSGeocoder()
        let position = CLLocationCoordinate2DMake(latitude, longitude)
        let id = "current"
        
        geocoder.reverseGeocodeCoordinate(position) { response , error in
            if error != nil {
                print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            } else {
                let result = response?.results()?.first
                let address = "\(String.getString(result?.locality)), \(String.getString(result?.country))"
                let city = String.getString(result?.locality)
                let pincode = String.getString(result?.postalCode).isEmpty ? ("000000") : (String.getString(result?.postalCode))
                completion(
                    SavedAddressModel(data: ["id": id, "address": address, "city": city, "pincode": pincode]))
            }
        }
        
    }
}

extension PersonalDetailsViewController {
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        self.latitude = manager.location?.coordinate.latitude ?? self.latitude
    //        self.longitude = manager.location?.coordinate.longitude ?? self.longitude
    //         getLocationDetails(latitude: latitude, longitude: longitude, completion:{ location in
    //            self.addressTF.text = location.address
    //        })
    //            //self.placesClient = GMSPlacesClient.shared()
    //        manager.stopUpdatingLocation()
    //
    //    }
}
