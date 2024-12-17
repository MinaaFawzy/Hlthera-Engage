//
//  LifeStyleViewController.swift
//  Hlthera
//
//  Created by Akash on 28/10/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
var lifeStyle = [AddDiseaseModel]()
var progressGlobal = 0.0
class LifeStyleViewController: UIViewController {
    
    @IBOutlet weak var labelPercentage: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tableViewLifeStyle: UITableView!
    @IBOutlet weak var heightAlergiesTableView: NSLayoutConstraint!
    @IBOutlet var imgProfile:UIImageView!
  
    @IBOutlet var btnCamera:UIButton!
    var profileComplete = "80% Profile completed".localize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblName.font = .CorbenBold(ofSize: 15)
        
        self.imgProfile.downlodeImage(serviceurl: String.getString(UserData.shared.profilePic), placeHolder: #imageLiteral(resourceName: "placeholder"))
        self.initialSetup()
    }
    
    var lifeStyleHeight:Int{
        get {
            let height = lifeStyle.flatMap{$0.questionModel.filter{$0.selectDises == true}}
            return height.count
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableViewLifeStyle.reloadData()
        progressBar.transform = CGAffineTransform(scaleX: 1, y: 2)
        progressBar.layer.cornerRadius = 5
        progressBar.clipsToBounds = true
        getProfileDetails()
        
//        if !String.getString(weightGlobal).isEmpty{
//
//            if String.getString(dob).isEmpty{
//                progressBar.progress = 0.4
//
//                labelPercentage.text = "40% Profile Completed"
//
//            }
//            else {
//                progressBar.progress = 0.8
//                labelPercentage.text = "80% Profile Completed"
//            }
//        }
//        else {
//            if dob.isEmpty {
//                progressBar.progress = 0.0
//                labelPercentage.text = "0% Profile Completed"
//            }
//            else {
//                progressBar.progress = 0.4
//                labelPercentage.text = "40% Profile Completed"
//            }
//        }
        progressBar.progress = Float(progressGlobal/100)
        labelPercentage.text = "\(String.getString(progressGlobal))%" + "Profile Completed".localize
        self.imgProfile.downlodeImage(serviceurl: String.getString(UserData.shared.profilePic), placeHolder: #imageLiteral(resourceName: "placeholder"))
        self.lblName.text = UserData.shared.fullName
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    private func initialSetup(){
        
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        LifeStyleQuestionApi()
    }
    func getProfileDetails(){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.kGetProfileDetails,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    let data = kSharedInstance.getDictionary(dictResult["result"])
                    
                    self.fillData(data: data)
                    
                    
                    
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
    func fillData(data:[String:Any]){
        let lifestyleDetail = kSharedInstance.getDictionary(data["lifestyleDetail"])
        let smokingHabit = kSharedInstance.getStringArray(lifestyleDetail["smoking_habit"])
        let activityLevel = kSharedInstance.getStringArray(lifestyleDetail["activity_level"])
        let alcoholConsumption = kSharedInstance.getStringArray(lifestyleDetail["alcohol_consumption"])
        let foodPreference = kSharedInstance.getStringArray(lifestyleDetail["food_preference"])
        let Occupation = kSharedInstance.getStringArray(lifestyleDetail["occupation"])
        
        
        
        
        for i in smokingHabit{
            for (index,j) in lifeStyle.enumerated(){
                for (inde,k) in j.questionModel.enumerated(){
                    if i == k.answer_option{
                        lifeStyle[index].questionModel[inde].selectDises = true
                    }
                    self.tableViewLifeStyle.reloadData()
                }
            }
        }
        for i in activityLevel{
            for (index,j) in lifeStyle.enumerated(){
                for (inde,k) in j.questionModel.enumerated(){
                    if i == k.answer_option{
                        lifeStyle[index].questionModel[inde].selectDises = true
                    }
                    self.tableViewLifeStyle.reloadData()
                }
            }
        }
        for i in alcoholConsumption{
            for (index,j) in lifeStyle.enumerated(){
                for (inde,k) in j.questionModel.enumerated(){
                    if i == k.answer_option{
                        lifeStyle[index].questionModel[inde].selectDises = true
                    }
                    self.tableViewLifeStyle.reloadData()
                }
            }
        }
        for i in foodPreference{
            for (index,j) in lifeStyle.enumerated(){
                for (inde,k) in j.questionModel.enumerated(){
                    if i == k.answer_option{
                        lifeStyle[index].questionModel[inde].selectDises = true
                    }
                    self.tableViewLifeStyle.reloadData()
                }
            }
        }
        for i in Occupation{
            for (index,j) in lifeStyle.enumerated(){
                for (inde,k) in j.questionModel.enumerated(){
                    if i == k.answer_option{
                        lifeStyle[index].questionModel[inde].selectDises = true
                    }
                    self.tableViewLifeStyle.reloadData()
                }
            }
        }
        
        DispatchQueue.main.async {
             self.tableViewLifeStyle.reloadData()
        }
    }
    func fixOrientation(img:UIImage) -> UIImage {
        
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
    @IBAction func btnBackTapped(_ sender: UIButton) {
        //self.navigationController?.popViewController(animated: false)
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: MedicalIDViewController.self) {
                self.navigationController!.popToViewController(controller, animated: false)
                return
            }
        }
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kMedicalIDVC) as? MedicalIDViewController else {return}
        self.navigationController?.pushViewController(nextVc, animated: false)
    }
    @IBAction func btnMedicalTapped(_ sender: UIButton) {
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: MedicalIDViewController.self) {
                self.navigationController!.popToViewController(controller, animated: false)
                return
            }
        }
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kMedicalIDVC) as? MedicalIDViewController else {return}
        self.navigationController?.pushViewController(nextVc, animated: false)
    }
    @IBAction func btnPersonalDetailsTapped(_ sender: UIButton) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: PersonalDetailsViewController.self) {
                self.navigationController!.popToViewController(controller, animated: false)
                break
            }
        }
    }
    @IBAction func btnSaveProfileTapped(_ sender: UIButton) {
        self.lifeStylelApi()
    }
    
    @IBAction func btnUploadProfilePictureTapped(_ sender: UIButton) {
        CommonUtils.imagePicker(viewController: self)
    }
    
    @IBAction func skipTapped(_ sender: Any) {
        kSharedAppDelegate?.moveToHomeScreen(index: 1)
    }
    
}
extension LifeStyleViewController: UITableViewDelegate,UITableViewDataSource{
    @objc func pushToMedicalDetail(sender:UIButton){
        guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "LifeStyleDetailsViewController") as? LifeStyleDetailsViewController else {return }
        nextVc.selectedButton = sender.tag
        nextVc.quesArray = lifeStyle.map{$0.question ?? ""}
        //           nextVc.addSymptoms = questionsModel.map{$0.meta ?? ""}
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        heightAlergiesTableView.constant = CGFloat((self.lifeStyleHeight * 50) + (lifeStyle.count * 50))
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 70, height: 50)
        let diseaseImage =  UIImageView()
        diseaseImage.frame  = CGRect(x: 5, y: headerView.frame.midY, width: 24, height: 24)
        let diseaselbl = UILabel()
        diseaselbl.frame = CGRect(x:40, y: headerView.frame.midY, width: 200, height: 25)
        let addImage = UIImageView()
        addImage.frame  = CGRect(x: headerView.frame.width - 30, y: headerView.frame.midY, width: 20, height: 20)
        let addDiseaseLabel = UILabel()
        addDiseaseLabel.frame = CGRect(x: headerView.frame.width - (addImage.frame.size.width+150), y: headerView.frame.midY, width: 130, height: 25)
        let addButton = UIButton()
        addButton.frame = CGRect(x: 200, y: headerView.frame.midY, width: 270, height: 30)
        addButton.addTarget(self, action: #selector(self.pushToMedicalDetail(sender:)), for: .touchUpInside)
        let lineLabel = UILabel()
        lineLabel.frame = CGRect(x: 0, y: 0, width: headerView.frame.width, height: 1)
        lineLabel.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        headerView.addSubview(lineLabel)
        headerView.addSubview(diseaseImage)
        headerView.addSubview(diseaselbl)
        headerView.addSubview(addImage)
        headerView.addSubview(addDiseaseLabel)
        headerView.addSubview(addButton)
        diseaselbl.text = lifeStyle[section].title
        diseaselbl.font = UIFont(name:"SF Pro Display", size: 13.0)
        diseaselbl.textColor = #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1)
        diseaseImage.downlodeImage(serviceurl: lifeStyle[section].image ?? "", placeHolder: #imageLiteral(resourceName: "chronic_disease"))
        addDiseaseLabel.text = lifeStyle[section].meta
        addDiseaseLabel.font = UIFont(name:"SF Pro Display", size: 13.0)
        addDiseaseLabel.textColor = #colorLiteral(red: 0.09803921569, green: 0.3098039216, blue: 0.4509803922, alpha: 1)
        addDiseaseLabel.textAlignment = NSTextAlignment.right
        addButton.tag = section
        addImage.image = #imageLiteral(resourceName: "add")
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return lifeStyle.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lifeStyle[section].questionModel.filter{$0.selectDises == true}.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewLifeStyle.dequeueReusableCell(withIdentifier: "LifeStyleTableCell") as! LifeStyleTableCell
        let object = lifeStyle[indexPath.section].questionModel.filter{$0.selectDises == true}
        //let isselected = object[indexPath.row].selectDises
        cell.labelDisease.text = object[indexPath.row].answer_option
        cell.removeCallBack = {
            object[indexPath.row].selectDises = false
            self.deleteMedicalLifestyleOption(title: String.getString(object[indexPath.row].answer_option))
            self.tableViewLifeStyle.reloadData()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    
}


extension LifeStyleViewController{
    func LifeStyleQuestionApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.kprofile_lifestyle_options,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data = kSharedInstance.getDictionaryArray(withDictionary: dictResult[kResponse])
                    lifeStyle = data.filter{ Int.getInt($0["category_type"]) == 2}.map{AddDiseaseModel(data: $0)}
                    self.tableViewLifeStyle.reloadData()
                    
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

extension LifeStyleViewController{
    func deleteMedicalLifestyleOption(title:String){
        
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.kTitle:title]
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.medicationLifestyleOptionRemoved,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    print("Deleted Successfully")
                case 400:
                    print("Not in server")
                default:
                    print(String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
    }
    }
    func lifeStylelApi() {
        var smokingHabit = [String]()
        var alcoholConsumption = [String]()
        var activitylevel = [String]()
        var foodpreference = [String]()
        var occupation = [String]()
        
        for (index,objArray) in lifeStyle.enumerated(){
            for obj in objArray.questionModel{
                switch index {
                case 0:
                    if obj.selectDises{
                        smokingHabit.append(obj.answer_option ?? "")
                    }
                case 1:
                    if obj.selectDises{
                        alcoholConsumption.append(obj.answer_option ?? "")
                    }
                case 2:
                    if obj.selectDises{
                        activitylevel.append(obj.answer_option ?? "")
                    }
                case 3:
                    if obj.selectDises{
                        foodpreference.append(obj.answer_option ?? "")
                    }
                default:
                    if obj.selectDises{
                        occupation.append(obj.answer_option ?? "")
                    }
                }
            }
        }
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [
            ApiParameters.kmedicalSmokingHabit : smokingHabit.joined(separator: ","),
            ApiParameters.kmedicalAlcoholConsumption : alcoholConsumption.joined(separator: ","),
            ApiParameters.kmedicalActivitylevel : activitylevel.joined(separator: ","),
            ApiParameters.kmedicalfoodpreference : foodpreference.joined(separator: ","),
            ApiParameters.kmedicalOccupation : occupation.joined(separator: ","),
            ApiParameters.ksteps:"3"]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.create_profile,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data = kSharedInstance.getDictionary(dictResult[kResponse])
                    let userInfo = kSharedInstance.getDictionary(data["userinfo"])
                    let progress = String.getString(data["progress_out_of_hundred"])
                    self.progressBar.progress = Float(Double.getDouble(progress)/100)
                    kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: String.getString(userInfo[kAccessToken]))
                    UserData.shared.profilePic = String.getString(userInfo["profile_picture"])
                    UserData.shared.email = String.getString(userInfo["email"])
                    UserData.shared.firstName = String.getString(userInfo["first_name"])
                    UserData.shared.lastName = String.getString(userInfo["last_name"])
                    UserData.shared.mobileNumber = String.getString(userInfo["mobile_number"])
                    dictionaryProfileCreation = kSharedInstance.getDictionary(dictResult["result"])
                    
                    kSharedUserDefaults.setUserLoggedIn(userLoggedIn: true)
                    kSharedAppDelegate?.moveToHomeScreen()
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

extension LifeStyleViewController{
    
    func profilePictureApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        
        let images:[String:Any] = ["imageName":ApiParameters.kprofile_picture,
                                   "image": self.imgProfile.image!]
        TANetworkManager.sharedInstance.requestMultiPart(withServiceName: ServiceName.change_avtar,
                                                         requestMethod: .post,
                                                         requestImages: [images],
                                                         requestVideos: [:],
                                                         requestData: params)
        {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
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

extension LifeStyleViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let selectedImage:UIImage = info[.originalImage] as! UIImage
        imgProfile.image = self.fixOrientation(img: selectedImage)
        imgProfile.restorationIdentifier = " "
        profilePictureApi()
        btnCamera.tag = 0
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

