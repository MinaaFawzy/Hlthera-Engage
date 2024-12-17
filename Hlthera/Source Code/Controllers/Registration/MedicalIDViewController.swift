//
//  MedicalIDViewController.swift
//  Hlthera
//
//  Created by Akash on 26/10/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import DropDown
import IQKeyboardManagerSwift

var questionsModel = [AddDiseaseModel]()
var weightGlobal = ""
var dob = ""

class MedicalIDViewController: UIViewController {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var textViewMedicalNotes: IQTextView!
    @IBOutlet weak var labelPercentage: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet var weightTF:UITextField!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet var heightTF:UITextField!
    @IBOutlet var imgProfile:UIImageView!
    @IBOutlet var btnCamera:UIButton!
    @IBOutlet var btnSave:UIButton!
    @IBOutlet var bloodGroupTF:UITextField!
    @IBOutlet weak var tableViewEmergencyContact: UITableView!
    @IBOutlet weak var tableViewAlergie: UITableView!
    @IBOutlet weak var emrgencyContactHeight: NSLayoutConstraint!
    @IBOutlet weak var heightAlergiesTableView: NSLayoutConstraint!
    
    var countries: [[String: String]] = []
    var dropDown = DropDown()
    var profileComplete = "0% Profile completed".localize
    var weightArray = [""]
    var heightArray = [""]
    var userProfileData: UserProfileModel?
    var forEmpty = false
    var countryCode = ""
    var countryCodeImage = UIImage()
    
    // MARK: - Variables
    var EmergencyContactArray = [EmergencyContactModal]()
    
    var EmergencyContactHeight: Int {
        get {
            return EmergencyContactArray.count
        }
    }
    
    var alergiesHeight: Int {
        get {
            let height = questionsModel.flatMap{$0.questionModel.filter{$0.selectDises == true}}
            return height.count
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblName.font = .CorbenBold(ofSize: 15)
        self.imgProfile.downlodeImage(serviceurl: String.getString(UserData.shared.profilePic), placeHolder: #imageLiteral(resourceName: "placeholder"))
        self.initialSetup()
        //addDiseaseArray = diseaseArray.map{AddAlergieModel(data: $0)}
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        progressBar.transform = CGAffineTransform(scaleX: 1, y: 2)
        progressBar.layer.cornerRadius = 5
        progressBar.clipsToBounds = true
        
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
        labelPercentage.text = "\(String.getString(progressGlobal))% Profile Completed".localize
        
        self.imgProfile.downlodeImage(serviceurl: String.getString(UserData.shared.profilePic), placeHolder: #imageLiteral(resourceName: "placeholder"))
        self.lblName.text = UserData.shared.fullName
        if !self.forEmpty{
            getProfileDetails()
            self.forEmpty = false
        }
        self.tableViewAlergie.reloadData()
        
    }
    
    //MARK:- function
    private func initialSetup(){
        self.medicalQuestionApi()
        labelPercentage.text = "0% Profile completed".localize
        fetchCountries()
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        self.EmergencyContactArray.append(EmergencyContactModal.init(data: [:]))
        weightTF.placeholder(text: "Weight", color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        heightTF.placeholder(text: "Height", color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        bloodGroupTF.placeholder(text: "Blood Group", color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        weightArray = []
        for index in 40...150 {
            var weight = "\(index) kg"
            weightArray.append(weight)
        }
        heightArray = []
        for index in 3...8{
            for i in 1...12{
                var inch = "\(index) ft. \(i) inch"
                heightArray.append(inch)
                print(inch)
            }
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
    
    func deleteContactApi(id: Int) {
        
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.id:id]
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.emergencyContactRemove,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    print("Deleted Successfully")
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
    
    //MARK:- @IBAction
    @IBAction func btnBackTapped(_ sender: UIButton) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: PersonalDetailsViewController.self) {
                self.navigationController!.popToViewController(controller, animated: false)
                return
            }
        }
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kPersonalDetailsVC) as? PersonalDetailsViewController else {return}
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
    @IBAction func btnLifeStyleTapped(_ sender: UIButton) {
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kLifeStyleVC) as? LifeStyleViewController else {return}
        self.navigationController?.pushViewController(nextVc, animated: false)
    }
    
    @IBAction func btnWeightTapped(_ sender: UIButton) {
        dropDown.anchorView = sender
        let areaArray = weightArray
        dropDown.dataSource = areaArray as! [String]
        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
            self.weightTF.text = item
        }
        dropDown.width = self.weightTF.frame.width
        dropDown.show()
    }
    @IBAction func btnHeightTapped(_ sender: UIButton) {
        dropDown.anchorView = sender
        let areaArray = heightArray
        dropDown.dataSource = areaArray as! [String]
        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
            self.heightTF.text = item
        }
        dropDown.width = self.heightTF.frame.width
        dropDown.show()
    }
    @IBAction func btnBloodGroupTapped(_ sender: UIButton) {
        dropDown.anchorView = sender
        let areaArray = ["A+","A-","B+","B-","AB+","AB-","O+","O-"]
        dropDown.dataSource = areaArray as! [String]
        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
            self.bloodGroupTF.text = item
        }
        dropDown.width = self.bloodGroupTF.frame.width
        dropDown.show()
    }
    @IBAction func btnCountryCodeTapped(_ sender: UIButton) {
        AppsCountryPickers.showController(referense: self)  { (selectedCountry) in
            let object = self.EmergencyContactArray[sender.tag]
            object.countryCode = String.getString(selectedCountry?.countryCode)
            object.countryCodeImage = selectedCountry?.image
            self.EmergencyContactArray[sender.tag] = object
            self.tableViewEmergencyContact.reloadData()
        }
    }
    
    @IBAction func btnRelationTapped(_ sender: UIButton) {
        dropDown.anchorView = sender
        let areaArray = ["Grand Father","Father","Mother","Sister","Brother","Others"]
        dropDown.dataSource = areaArray
        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
            let object = self.EmergencyContactArray[sender.tag]
            object.textRelation = String.getString(item)
            self.EmergencyContactArray[sender.tag] = object
            self.tableViewEmergencyContact.reloadData()
        }
        dropDown.width = self.weightTF.frame.width
        dropDown.show()
    }
    
    @IBAction func btnSaveProfileTapped(_ sender: UIButton) {
        sender.tag = 1
        self.validationField()
        
    }
    
    @IBAction func btnUploadProfilePictureTapped(_ sender: UIButton) {
        CommonUtils.imagePicker(viewController: self)
    }
    
    @IBAction func skipTapped(_ sender: Any) {
        kSharedAppDelegate?.moveToHomeScreen(index: 1)
    }
    
}
//MARK:- TABLE VIEW EXTENSION
extension MedicalIDViewController:UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate  {
    @objc func pushToMedicalDetail(sender:UIButton){
        guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "MedicalDetailsViewController") as? MedicalDetailsViewController else {return }
        self.forEmpty = true
        nextVc.selectedButton = sender.tag
        nextVc.totalNumberOfQuestion = questionsModel.count
        nextVc.quesArray = questionsModel.map{$0.question ?? ""}
        nextVc.addSymptoms = questionsModel.map{$0.meta ?? ""}
        
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 70, height: 50)
        let diseaseImage = UIImageView()
        diseaseImage.frame  = CGRect(x: 5, y: headerView.frame.midY, width: 24, height: 24)
        let diseaselbl = UILabel()
        diseaselbl.frame = CGRect(x:40, y: headerView.frame.midY, width: 200, height: 25)
        let addImage = UIImageView()
        addImage.image = #imageLiteral(resourceName: "add")
        addImage.frame  = CGRect(x: headerView.frame.width - 30, y: headerView.frame.midY, width: 20, height: 20)
        let addDiseaseLabel = UILabel()
        addDiseaseLabel.frame = CGRect(x: headerView.frame.width - (addImage.frame.size.width+150), y: headerView.frame.midY, width: 130, height: 25)
        let lineLabel = UILabel()
        lineLabel.frame = CGRect(x: 0, y: 0, width: headerView.frame.width, height: 1)
        lineLabel.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        headerView.addSubview(lineLabel)
        let addButton = UIButton()
        addButton.frame = CGRect(x: 200, y: headerView.frame.midY, width: 270, height: 30)
        addButton.addTarget(self, action: #selector(self.pushToMedicalDetail(sender:)), for: .touchUpInside)
        headerView.addSubview(diseaseImage)
        headerView.addSubview(diseaselbl)
        headerView.addSubview(addImage)
        headerView.addSubview(addDiseaseLabel)
        headerView.addSubview(addButton)
        diseaselbl.text = questionsModel[section].title
        diseaselbl.font = UIFont(name:"SF Pro Display", size: 13.0)
        diseaselbl.textColor = #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1)
        diseaseImage.downlodeImage(serviceurl: questionsModel[section].image ?? "", placeHolder: #imageLiteral(resourceName: "chronic_disease"))
        addDiseaseLabel.text = questionsModel[section].meta
        addDiseaseLabel.font = UIFont(name:"SF Pro Display", size: 13.0)
        addDiseaseLabel.textAlignment = NSTextAlignment.right
        addDiseaseLabel.textColor = #colorLiteral(red: 0.09803921569, green: 0.3098039216, blue: 0.4509803922, alpha: 1)
        addButton.tag = section
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView{
        case tableViewAlergie:
            return 50
        default:
            return 0
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView{
        case tableViewAlergie:
            return questionsModel.count
        case tableViewEmergencyContact:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableViewEmergencyContact:
            emrgencyContactHeight.constant = CGFloat((CGFloat(115) * CGFloat(EmergencyContactHeight)))
            return EmergencyContactArray.count
        case tableViewAlergie:
            heightAlergiesTableView.constant = CGFloat((self.alergiesHeight * 50) + (questionsModel.count * 50))
            return questionsModel[section].questionModel.filter{$0.selectDises == true}.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tableViewEmergencyContact:
            guard let cell = self.tableViewEmergencyContact.dequeueReusableCell(withIdentifier: Identifiers.kEmergencyContactsTVCell, for: indexPath)as? EmergencyContactsTableViewCell else{return UITableViewCell()}
            let object = self.EmergencyContactArray[indexPath.row]
            cell.emergencyContactsTF.placeholder(text: "Emergency Contact", color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
            cell.relationTF.placeholder(text: "Relation", color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
            cell.object = object
            cell.emergencyContactsTF.text = object.text
            cell.emergencyContactsTF.delegate = self
            cell.emergencyContactsTF.tag = indexPath.row
            cell.relationTF.text = object.textRelation
            cell.buttonCountryCode.setTitle(object.countryCode, for: .normal)
            let selectedCountry = countries.filter({ (data: [String : String]) -> Bool in
                return data["dial_code"]!.lowercased().contains(object.countryCode ?? "+971")
            })
            let selectedFlag = selectedCountry[0]["code"]
            cell.imageCountryCode.image = UIImage(named: selectedFlag!)
            cell.btnRelation.tag = indexPath.row
            cell.buttonCountryCode.tag = indexPath.row
            cell.emergencyContactsTF.addTarget(cell, action: #selector(cell.textChange(_:)), for: .editingChanged)
            
            cell.callBack = {
                if indexPath.row == self.EmergencyContactArray.count - 1{
                    self.EmergencyContactArray.append(EmergencyContactModal.init(data: [:]))
                }else{
                    if String.getString(self.EmergencyContactArray[indexPath.row].id) != ""{
                        self.deleteContactApi(id:Int.getInt(self.EmergencyContactArray[indexPath.row].id))
                    }
                    self.EmergencyContactArray.remove(at: indexPath.row)
                }
                self.tableViewEmergencyContact.reloadData()
                self.emrgencyContactHeight.constant = CGFloat((CGFloat(115) * CGFloat(self.EmergencyContactHeight)))
            }
            indexPath.row == self.EmergencyContactArray.count - 1 ? cell.btnAdd.setImage(#imageLiteral(resourceName: "add"), for: .normal) : cell.btnAdd.setImage(#imageLiteral(resourceName: "minus"), for: .normal)
            return cell
        case tableViewAlergie:
            let cell = tableViewAlergie.dequeueReusableCell(withIdentifier: "AlergieTableViewCell", for: indexPath) as! AlergieTableViewCell
            let object = questionsModel[indexPath.section].questionModel.filter{$0.selectDises == true}
            //let isselected = object[indexPath.row].selectDises
            cell.labelDisease.text = object[indexPath.row].answer_option
            cell.removeCallBack = {
                object[indexPath.row].selectDises = false
                
                self.deleteMedicalLifestyleOption(title:String.getString(object[indexPath.row].answer_option))
                
                self.tableViewAlergie.reloadData()
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView{
        case tableViewAlergie:
            return CGFloat(50)
        case tableViewEmergencyContact:
            return CGFloat(115)
        default:
            return 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let object = self.EmergencyContactArray[textField.tag]
        for check in self.EmergencyContactArray{
            if check.text == textField.text {
                showAlertMessage.alert(message: "Enter Other Mobile Number")
            }else{
                object.text = String.getString(textField.text)
                
                self.EmergencyContactArray[textField.tag] = object
            }
        }
        self.tableViewEmergencyContact.reloadData()
        
        return true
    }
}
extension MedicalIDViewController{
    
    func medicalQuestionApi(){
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
                    if dictionaryProfileCreation.count > 0 {
                        self.dataset()
                    } else {
                        questionsModel = data.filter{ Int.getInt($0["category_type"]) == 1 }.map{ AddDiseaseModel(data: $0) }
                        self.tableViewAlergie.reloadData()
                    }
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
    
    func dataset() {
        weightGlobal = String.getString(userProfileData?.weight)
        let userInfoDict = kSharedInstance.getDictionary(dictionaryProfileCreation["medicalDetail"])
        let alergies = kSharedInstance.getStringArray(userInfoDict["allergies"])
        let current_medication = kSharedInstance.getStringArray(userInfoDict["current_medication"])
        let past_medication = kSharedInstance.getStringArray(userInfoDict["past_medication"])
        let chronic_disease = kSharedInstance.getStringArray(userInfoDict["chronic_disease"])
        let injuries = kSharedInstance.getStringArray(userInfoDict["injuries"])
        let surgeries = kSharedInstance.getStringArray(userInfoDict["surgeries"])
        
        for i in alergies{
            for (index,j) in questionsModel.enumerated() {
                for (inde, k) in j.questionModel.enumerated() {
                    if i == k.answer_option{
                        questionsModel[index].questionModel[inde].selectDises = true
                    }
                    self.tableViewAlergie.reloadData()
                }
            }
        }
        for i in current_medication{
            for (index,j) in questionsModel.enumerated(){
                for (inde,k) in j.questionModel.enumerated(){
                    if i == k.answer_option{
                        questionsModel[index].questionModel[inde].selectDises = true
                    }
                    self.tableViewAlergie.reloadData()
                }
            }
        }
        for i in past_medication{
            for (index,j) in questionsModel.enumerated(){
                for (inde,k) in j.questionModel.enumerated(){
                    if i == k.answer_option{
                        questionsModel[index].questionModel[inde].selectDises = true
                    }
                    self.tableViewAlergie.reloadData()
                }
            }
        }
        for i in chronic_disease{
            for (index,j) in questionsModel.enumerated(){
                for (inde,k) in j.questionModel.enumerated(){
                    if i == k.answer_option{
                        questionsModel[index].questionModel[inde].selectDises = true
                    }
                    self.tableViewAlergie.reloadData()
                }
            }
        }
        
        for i in injuries{
            for (index,j) in questionsModel.enumerated(){
                for (inde,k) in j.questionModel.enumerated(){
                    if i == k.answer_option{
                        questionsModel[index].questionModel[inde].selectDises = true
                    }
                    self.tableViewAlergie.reloadData()
                }
            }
        }
        
        for i in surgeries{
            for (index,j) in questionsModel.enumerated(){
                for (inde,k) in j.questionModel.enumerated(){
                    if i == k.answer_option{
                        questionsModel[index].questionModel[inde].selectDises = true
                    }
                    self.tableViewAlergie.reloadData()
                }
            }
        }
        
        DispatchQueue.main.async {
            self.tableViewAlergie.reloadData()
        }
    }
    
}
extension MedicalIDViewController{
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
                    
                    self.userProfileData = UserProfileModel(data: data)
                    // dictionaryProfileCreation = kSharedInstance.getDictionary(dictResult["result"])
                    //self.dataset()
                    DispatchQueue.main.async {
                        self.setData(userData:self.userProfileData ?? UserProfileModel(data: [:]))
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
    
    func setData(userData:UserProfileModel){
        
        
        weightGlobal = String.getString(userProfileData?.weight)
        self.weightTF.text = userData.weight
        self.heightTF.text = userData.height
        self.progressBar.progress = Float(userData.progress/100)
        progressGlobal = userData.progress
        self.labelPercentage.text = "\(String.getString(userData.progress))% Profile Completed".localize
        self.textViewMedicalNotes.text = userData.medicalNotes
        self.bloodGroupTF.text = userData.bloodGroup
        
        if kSharedInstance.getDictionaryArray(withDictionary: userData.emergencyContacts).count > 0 {
            self.EmergencyContactArray = kSharedInstance.getDictionaryArray(withDictionary: userData.emergencyContacts).map{EmergencyContactModal(data: $0)}
        } else {
            self.EmergencyContactArray = [EmergencyContactModal.init(data: [:])]
        }
    
        tableViewEmergencyContact.reloadData()
        
    }
    
    func medicalApi() {
        var alergie = [String]()
        var currentMedication = [String]()
        var pastMedication = [String]()
        var chronicDisease = [String]()
        var injuries = [String]()
        var surgeries = [String]()
        let emergencyContactNumber = EmergencyContactArray.compactMap{$0.text ?? ""}.filter{$0 != ""}.joined(separator: ",")
        let relation = EmergencyContactArray.compactMap{$0.textRelation ?? ""}.filter{$0 != ""}.joined(separator: ",")
        let countryCodes = EmergencyContactArray.compactMap{$0.countryCode ?? ""}.filter{$0 != ""}.joined(separator: ",")
        for (index,objArray) in questionsModel.enumerated() {
            for obj in objArray.questionModel {
                switch index {
                case 0:
                    if obj.selectDises{
                        alergie.append(obj.answer_option ?? "")
                    }
                case 1:
                    if obj.selectDises{
                        currentMedication.append(obj.answer_option ?? "")
                    }
                case 2:
                    if obj.selectDises{
                        pastMedication.append(obj.answer_option ?? "")
                    }
                case 3:
                    if obj.selectDises {
                        chronicDisease.append(obj.answer_option ?? "")
                    }
                case 4:
                    if obj.selectDises {
                        injuries.append(obj.answer_option ?? "")
                    }
                default:
                    if obj.selectDises{
                        surgeries.append(obj.answer_option ?? "")
                    }
                }
            }
            
        }
        CommonUtils.showHudWithNoInteraction(show: true)
        let params: [String:Any] = [ApiParameters.kweight: String.getString(weightTF.text),
                                   ApiParameters.kheight : String.getString(heightTF.text),
                                   ApiParameters.kblood_group : String.getString(bloodGroupTF.text),
                                   ApiParameters.kemergencyContactnumber : emergencyContactNumber,
                                   ApiParameters.kemergencyRelation : relation,
                                   ApiParameters.kCountryCodes : countryCodes,
                                   ApiParameters.kmedical_notes : String.getString(self.textViewMedicalNotes.text),
                                   ApiParameters.kmedicalAllergies : alergie.joined(separator: ", "),
                                   ApiParameters.kmedicalCurrentMedication : currentMedication.joined(separator: ", "),
                                   ApiParameters.kmedicalPastMedication : pastMedication.joined(separator: ", "),
                                   ApiParameters.kmedicalChronicDisease : chronicDisease.joined(separator: ", "),
                                   ApiParameters.kmedicalInjuries : injuries.joined(separator: ", "),
                                   ApiParameters.kmedicalSurgeries : surgeries.joined(separator: ", "),
                                   ApiParameters.ksteps: "2"
        ]
        
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
                    progressGlobal = Double.getDouble(data["progress_out_of_hundred"])
                    kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: String.getString(userInfo[kAccessToken]))
                    UserData.shared.profilePic = String.getString(userInfo["profile_picture"])
                    UserData.shared.email = String.getString(userInfo["email"])
                    UserData.shared.firstName = String.getString(userInfo["first_name"])
                    UserData.shared.lastName = String.getString(userInfo["last_name"])
                    UserData.shared.mobileNumber = String.getString(userInfo["mobile_number"])
                    dictionaryProfileCreation = kSharedInstance.getDictionary(dictResult["result"])
                    
                    weightGlobal = self.weightTF.text ?? ""
                    
                    //UserData.shared.saveData(data: userInfo)
                    DispatchQueue.main.async {
                        self.tableViewAlergie.reloadData()
                    }
                    guard let nextVc = self.storyboard?.instantiateViewController(identifier: "LifeStyleViewController") as? LifeStyleViewController else {return}
                    self.navigationController?.pushViewController(nextVc, animated: false)
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

extension MedicalIDViewController {
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

extension MedicalIDViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

extension MedicalIDViewController {
    func fetchCountries () {
        guard let path = Bundle.main.path(forResource: "CallingCodes", ofType: "plist") else {return}
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        guard let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [[String:String]] else {return}
        print(plist)
        countries = plist
    }
}
