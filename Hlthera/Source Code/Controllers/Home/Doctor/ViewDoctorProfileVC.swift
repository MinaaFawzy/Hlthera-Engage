//
//  DoctorProfileVC.swift
//  Hlthera
//
//  Created by Prashant on 22/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import Alamofire

var result: DoctorDetailsModel?
var resultDoctorFromSpecialist: DoctorList?

@available(iOS 15.0, *)
class ViewDoctorProfileVC: UIViewController, pageViewControllerProtocal {
    
    // MARK: - Outlets
    @IBOutlet weak private var constraintContainerViewHeihgt: NSLayoutConstraint!
    @IBOutlet weak private var labelDoctorName: UILabel!
    @IBOutlet weak private var labelDoctorSpeciality: UILabel!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var backgroundVIew: UIView!
    @IBOutlet weak private var labelRating: UILabel!
    @IBOutlet weak private var labelPrice: UILabel!
    @IBOutlet weak private var labelExperience: UILabel!
    @IBOutlet weak private var imageProfile: UIImageView!
    @IBOutlet weak private var collectionViewNavigation: UICollectionView!
    @IBOutlet weak private var labelHeartCount: UILabel!
    @IBOutlet weak private var buttonPhone: UIButton!
    @IBOutlet weak private var buttonChat: UIButton!
    @IBOutlet weak private var buttonHome: UIButton!
    @IBOutlet weak private var buttonFinance: UIButton!
    @IBOutlet weak private var buttonVideo: UIButton!
    @IBOutlet weak private var buttonFavorite: UIButton!
    
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var backgroundTableView: UITableView!
    // MARK: = Stored Properties
    //var searchResultFromSpecialist: DoctorList?
    //var searchResultFromGeneral: DoctorList?
    var isLiked: Bool = false
    var numberOfLikes: Int = 0
    var hasComeFrom: HasCameFrom = .none
    var searchResult: DoctorDetailsModel?
    var navigationTabsNames = [
        "About".localize,
        "Awards and Honours".localize,
        "Core competencies".localize,
        "Education".localize,
        "Experience".localize,
        "Rating & Reviews".localize
    ]
    var containerViewController: PageVIewController?
    var selectedTab = 0
    var ratings: [RatingModel] = []
    var appointmentTypeId: String = ""
    var appointmentType: String = ""
    var selectedSlotId = ""
    var isSlotsAvailable: Bool = false
    var selectedSlotDate = ""
    var selectedSlotTime = ""
    var isBook = true
    var chatTime = ""
    var doctorDataModel: DoctorDataModel?
    var navigationView: DoctorNavigationView?
    weak var viewDelegate: viewDoctorDelegate?
    var bookingDetails:[ResultOnGoingSearch] = []
    var hasCameFrom: HasCameFrom = .home
    var doctorID = 0
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStatusBar(red: 46, green: 122, blue: 197)
        configTableCell()
        if hasCameFrom == .Banners {
            fetchDoctorDetails(doctorID: doctorID) { [weak self] response in
                switch response {
                case .success(let value):
                    self?.doctorDataModel = value
                    self?.doctorDataModel?.result = value.result
                    self?.backgroundTableView.reloadData()
                    //                    self?.accessViewsComeFromHome()
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [weak self] in
                        guard let self = self else { return }
                        self.containerViewController?.doctorData = self.doctorDataModel
                        //                        self.containerViewController?.changeViewController(index: 0, direction: .forward)
                        self.selectedTab = 0
                        //                        self.collectionViewNavigation.reloadData()
                        self.viewDelegate?.updateModel(doctorId: value.result.doctorID)
                        //                        self.labelHeartCount.text = "\(value.result.likes ?? 0)"
                        self.numberOfLikes = value.result.likes ?? 1
                        UserData.shared.doctorId = value.result.doctorID
                        UserData.shared.doctorData = value.result
                    })
                case .failure(let error):
                    print("\(error)")
                    CommonUtils.showToast(message: error.localizedDescription)
                }
            }
        } else {
            if let doctorId = searchResult?.doctor_id, let id = Int(doctorId) {
                fetchDoctorDetails(doctorID: id) { [weak self] response in
                    switch response {
                    case .success(let value):
                        self?.doctorDataModel = value
                        self?.doctorDataModel?.result = value.result
                        self?.backgroundTableView.reloadData()
                        //                    self?.accessViewsComeFromHome()
                        DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [weak self] in
                            guard let self = self else { return }
                            self.containerViewController?.doctorData = self.doctorDataModel
                            //                        self.containerViewController?.changeViewController(index: 0, direction: .forward)
                            self.selectedTab = 0
                            //                        self.collectionViewNavigation.reloadData()
                            self.viewDelegate?.updateModel(doctorId: value.result.doctorID)
                            //                        self.labelHeartCount.text = "\(value.result.likes ?? 0)"
                            self.numberOfLikes = value.result.likes ?? 1
                            UserData.shared.doctorId = value.result.doctorID
                            UserData.shared.doctorData = value.result
                        })
                    case .failure(let error):
                        print("\(error)")
                        CommonUtils.showToast(message: error.localizedDescription)
                    }
                }
            }
        }
//        labelDoctorName.font = .CorbenBold(ofSize: 17)
//        setStatusBar(color: #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1))
//        self.buttonHome.setImage(UIImage(named: "home_visit_white")?.alpha(0.5), for: .normal)
//        self.buttonVideo.setImage(UIImage(named: "video_white")!.alpha(0.5), for: .normal)
//        self.buttonChat.setImage(UIImage(named: "chat")!.alpha(0.5), for: .normal)
//        self.buttonPhone.setImage(UIImage(named: "call_white")!.alpha(0.5), for: .normal)
//        self.buttonFinance.setImage(UIImage(named: "clinic_visit_white")!.alpha(0.5), for: .normal)
//        self.buttonHome.isUserInteractionEnabled = false
//        self.buttonVideo.isUserInteractionEnabled = false
//        self.buttonChat.isUserInteractionEnabled = false
//        self.buttonPhone.isUserInteractionEnabled = false
//        self.buttonFinance.isUserInteractionEnabled = false
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            self.backgroundVIew.setGradientBackground()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        containerViewController?.changeViewController(index: 0, direction: .forward)
        selectedTab = 0
//        collectionViewNavigation.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupStatusBar(red: 46, green: 122, blue: 197)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupStatusBar(red: 245, green: 247, blue: 249)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segue.identifier == "pageVC" {
        //containerViewController = segue.destination as? PageVIewController
        //}
        if let vc = segue.destination as? PageVIewController,
           segue.identifier == "pageVC" {
            containerViewController = vc
            vc.delegate = self
            vc.hasCameFrom = .doctors
            vc.doctorData = self.doctorDataModel
            vc.mydelegate = self
        }
    }
    func configTableCell() {
        backgroundTableView.delegate = self
        backgroundTableView.dataSource = self
        backgroundTableView.register(UINib(nibName: DoctorHeaderTVC.identifier, bundle: nil), forCellReuseIdentifier: DoctorHeaderTVC.identifier)
        backgroundTableView.register(UINib(nibName: InfoAboutDoctorCell.identifier, bundle: nil), forCellReuseIdentifier: InfoAboutDoctorCell.identifier)
        backgroundTableView.register(UINib(nibName: RatingDoctorProfileTVC.identifier, bundle: nil), forCellReuseIdentifier: RatingDoctorProfileTVC.identifier)
        self.navigationView = getDoctorNavigationView()
        self.navigationView?.setupCollectionView()
        self.navigationView?.callbackSelectedItem = { indexPath in
            self.backgroundTableView.scrollToRow(at: IndexPath(row: indexPath.row, section: 1), at: .top, animated: true)
        }
    }
    
    func accessViewsComeFromHome() {
        // API State
        if doctorDataModel?.result.isLike == 1 {
            buttonFavorite.setImage(UIImage(named: "heart_unfill"), for: .normal)
            isLiked = false
        } else {
            buttonFavorite.setImage(UIImage(named: "heart_active"), for: .normal)
            isLiked = true
        }
        self.labelDoctorName.text = doctorDataModel?.result.doctorName
        self.labelHeartCount.text = "\(numberOfLikes)"
        self.labelRating.text = String(format: "%.1f", doctorDataModel?.result.ratings ?? 0)
        self.reviewsCountLabel.text = String.getString(doctorDataModel?.result.ratingReviews?.count ?? 0)
        self.labelDoctorSpeciality.text = doctorDataModel?.result.doctorSpecialities?.first?.fullName
        self.labelExperience.text = (doctorDataModel?.result.doctorExp?.count > 2) ? doctorDataModel?.result.doctorExp : "\(String.getString(doctorDataModel?.result.doctorExp) )" + " years of exp.".localize
        self.imageProfile.downlodeImage(serviceurl: String.getString(doctorDataModel?.result.doctorProfile), placeHolder: UIImage(named: "no_data_image"))
        
        doctorDataModel?.result.doctorCommunicationServices?.forEach {
            if $0.commServiceType == "video" {
                self.buttonVideo.setImage(UIImage(named: "video_white"), for: .normal)
                self.buttonVideo.isUserInteractionEnabled = true
            }
            if $0.commServiceType == "home" {
                self.buttonHome.setImage(UIImage(named: "home_visit_white"), for: .normal)
                self.buttonHome.isUserInteractionEnabled = true
            }
            if $0.commServiceType == "chat" {
                self.buttonChat.setImage(UIImage(named: "chat"), for: .normal)
                self.buttonChat.isUserInteractionEnabled = true
            }
            if $0.commServiceType == "audio" {
                self.buttonPhone.setImage(UIImage(named: "call_white"), for: .normal)
                self.buttonPhone.isUserInteractionEnabled = true
            }
            if $0.commServiceType == "visit" {
                self.buttonFinance.setImage(UIImage(named: "clinic_visit_white"), for: .normal)
                self.buttonFinance.isUserInteractionEnabled = true
            }
        }
    }
    
    
    func getMinimumPrice(from: DoctorDataModel) -> Int {
        let res = from.result.doctorCommunicationServices?.map {
            Int.getInt($0.commDurationFee ?? 0)
        }
        return res?.min() ?? 0
    }
    
    //func getMinimumPrice(from: HospitalDetailModel) -> Int {
    //if let data = from.doctorBasicInfo {
    //    let res = data.map{ getMinimumPrice(from: $0) }
    //    return res.min() ?? 0
    //}
    //return 0
    //}
    
    func getSelectedPageIndex(with value: Int) {
        selectedTab = value
        if value == 1 {
            selectedTab = value
//            self.collectionViewNavigation.reloadData()
            self.constraintContainerViewHeihgt.constant = 300
        } else {
            selectedTab = value
//            self.collectionViewNavigation.reloadData()
            self.constraintContainerViewHeihgt.constant = 1250
        }
//        self.collectionViewNavigation.reloadData()
    }
    
    private func proceed() {
        if kSharedUserDefaults.isPractoEnabled() {
            saveDetails()
            //guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: AddSelfPatientDetails.getStoryboardID()) as? AddSelfPatientDetails else { return }
            //self.navigationController?.pushViewController(vc, animated: true)
            self.bookingApi(
                isHospital: String.getString(UserData.shared.hospital_id).isEmpty ? false : true,
                forOthers: String.getString(UserData.shared.otherPatientDetails?.other_patient_name).isEmpty ? false : true
            )
        } else if isBook {
            //let res = buttonsAppointmentTypes.filter{ $0.isSelected == true }
            if !UserData.shared.appointmentType.isEmpty {
                if isSlotsAvailable && selectedSlotId != "" {
                    //if chatTime != ""{
                    saveDetails()
                    //checkSlotsApi()
                    // }
                    // else {
                    //CommonUtils.showToast(message: "Please Select Chat Time")
                    //return
                    //}
                    self.bookingApi(
                        isHospital: String.getString(UserData.shared.hospital_id).isEmpty ? false : true,
                        forOthers: String.getString(UserData.shared.otherPatientDetails?.other_patient_name).isEmpty ? false : true
                    )
                } else {
                    CommonUtils.showToast(message: "Please Select Slots")
                    return
                }
            }
            else {
                CommonUtils.showToast(message: "Please Select Appointment Type")
                return
            }
        } else {
            if isSlotsAvailable && selectedSlotId != "" {
                if chatTime != "" {
                    saveDetails()
                    checkSlotsApi()
                } else {
                    CommonUtils.showToast(message: "Please Select Chat Time")
                    return
                }
            } else {
                CommonUtils.showToast(message: "Please Select Slots")
                return
            }
        }
    }
    
    private func showOptionsAlert() {
        //  1 for audio, 2 for video, 3 for chat, 4 for house and 5 for visit consultation
        let alertController = UIAlertController(title: "Select an Option", message: nil, preferredStyle: .alert)
        
        let option1Action = UIAlertAction(title: "Audio", style: .default) { [weak self] _ in
            guard let self = self else { return }
            // Handle Option 1 selection
            UserData.shared.appointmentType = "1"
            self.appointmentTypeId = "1"
            self.appointmentType = "audio"
            if let id = UserData.shared.doctorId {
                self.getDoctorTimeSlots(doctorId: id)
            }
        }
        alertController.addAction(option1Action)
        
        let option2Action = UIAlertAction(title: "Video", style: .default) { [weak self] _ in
            guard let self = self else { return }
            // Handle Option 2 selection
            UserData.shared.appointmentType = "2"
            self.appointmentTypeId = "2"
            self.appointmentType = "video"
            if let id = UserData.shared.doctorId {
                self.getDoctorTimeSlots(doctorId: id)
            }
        }
        alertController.addAction(option2Action)
        
        let option3Action = UIAlertAction(title: "Chat", style: .default) { [weak self] _ in
            guard let self = self else { return }
            // Handle Option 3 selection
            UserData.shared.appointmentType = "3"
            self.appointmentTypeId = "3"
            self.appointmentType = "chat"
            if let id = UserData.shared.doctorId {
                self.getDoctorTimeSlots(doctorId: id)
            }
        }
        alertController.addAction(option3Action)
        
        let option4Action = UIAlertAction(title: "Home", style: .default) { [weak self] _ in
            guard let self = self else { return }
            // Handle Option 4 selection
            UserData.shared.appointmentType = "4"
            self.appointmentTypeId = "4"
            self.appointmentType = "home"
            if let id = UserData.shared.doctorId {
                self.getDoctorTimeSlots(doctorId: id)
            }
        }
        alertController.addAction(option4Action)
        
        let option5Action = UIAlertAction(title: "Visit", style: .default) { [weak self] _ in
            guard let self = self else { return }
            // Handle Option 5 selection
            UserData.shared.appointmentType = "5"
            self.appointmentTypeId = "5"
            self.appointmentType = "visit"
            if let id = UserData.shared.doctorId {
                self.getDoctorTimeSlots(doctorId: id)
            }
        }
        alertController.addAction(option5Action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        //Present the alert controller
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
}
//MARK: - Scrolling extension
extension ViewDoctorProfileVC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0.0 && scrollView.contentOffset.y != 0.0 {
        
            if let indexPath = backgroundTableView.indexPathForRow(at: CGPoint(x: backgroundTableView.contentOffset.x , y: backgroundTableView.contentOffset.y + 50)) {
                if indexPath.section == 0 {
                    setupStatusBar(red: 46, green: 122, blue: 197)
                    self.backgroundTableView.backgroundColor = UIColor(named: "11")
                } else {
                    setupStatusBar(red: 255, green: 255, blue: 255)
                    self.backgroundTableView.backgroundColor = .white
                }
//                collectionViewNavigation.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
                self.navigationView?.DoctorNavigationCollectionView.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: [.centeredVertically, .centeredHorizontally], animated: true)
                if selectedTab != indexPath.row {
                    selectedTab = indexPath.row
//                    collectionViewNavigation.reloadData()
                    self.navigationView?.selectedTab = indexPath.row
                    self.navigationView?.DoctorNavigationCollectionView.reloadData()
                }
            }
        }
    }
}

//MARK: - UI Table View Delegate & DataSource
extension ViewDoctorProfileVC:  UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        backgroundTableView.sectionHeaderTopPadding = 0
        if section == 0 {
            return nil
        }
        return self.navigationView
    }
    
    func getDoctorNavigationView() -> DoctorNavigationView {
        return UINib(nibName: "DoctorNavigationView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! DoctorNavigationView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorHeaderTVC", for: indexPath) as! DoctorHeaderTVC
            cell.backgroundVIew?.setGradientBackground()
            cell.setupHeaderData(data: doctorDataModel?.result)
            cell.callbackBackButton = {
                self.navigationController?.popViewController(animated: true)
            }
            cell.callbackChatButton = {
                UserData.shared.appointmentType = "3"
                self.appointmentType = "chat"
                self.getDoctorTimeSlots(doctorId: self.doctorDataModel?.result.doctorID ?? 0)
            }
            cell.callbackHomeButton = {
                UserData.shared.appointmentType = "4"
                self.appointmentType = "home"
                self.getDoctorTimeSlots(doctorId: self.doctorDataModel?.result.doctorID ?? 0)
            }
            cell.callbackPhoneButton = {
                UserData.shared.appointmentType = "1"
                self.appointmentType = "audio"
                self.getDoctorTimeSlots(doctorId: self.doctorDataModel?.result.doctorID ?? 0)
            }
            cell.callbackShareButton = {
                let textToShare = kAppName
                if let myWebsite = NSURL(string: String.getString(self.searchResult?.shareable_url)) {
                    let objectsToShare = [textToShare, myWebsite] as [Any]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                    self.present(activityVC, animated: true, completion: nil)
                }
            }
            cell.callbackVideoButton = {
                UserData.shared.appointmentType = "2"
                self.appointmentType = "video"
                self.getDoctorTimeSlots(doctorId: self.doctorDataModel?.result.doctorID ?? 0)
            }
            cell.callbackLocationButton = {
                guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: DoctorLocationVc.getStoryboardID()) as? DoctorLocationVc else { return }
                //vc.doctorDetailModel = result
                //print("searchResult = \(result?.lat ?? "")")
                //print("searchResult = \(result?.longitude ?? "")")
                //print("searchResult = \(result?.doctor_name ?? "")")
                vc.hasComeFrom = self.hasComeFrom
                switch self.hasComeFrom {
                case .home:
                    vc.searchResultFromSpecialist = resultDoctorFromSpecialist
                default:
                    vc.doctorDetailModel = result
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.callbackFinancialButton = {
                UserData.shared.appointmentType = "5"
                self.appointmentType = "visit"
                self.getDoctorTimeSlots(doctorId: self.doctorDataModel?.result.doctorID ?? 0)
            }
            return cell
        } else {
            if indexPath.row == 5 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RatingDoctorProfileTVC", for: indexPath) as! RatingDoctorProfileTVC
                cell.doctorDataModel = self.doctorDataModel
                cell.ratingsTable.reloadData()
                cell.callBackBookAppoientment = {
                    self.showOptionsAlert()
                }
                cell.callBackBookForOther = {
                    let vc = AddOtherPopupVC()
                    vc.modalPresentationStyle = .overFullScreen
                    vc.onContinue = { [weak self] in
                        guard let self = self else { return }
                        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: AddOtherPatientDetails.getStoryboardID()) as? AddOtherPatientDetails else { return }
                        vc.data = .init(status: 200, message: "", result: UserData.shared.doctorData ?? .init(doctorID: self.doctorDataModel?.result.doctorID ?? 0, slotArray: .init(slots: [])))
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    self.present(vc, animated: true)
                }
                cell.callBackReportProblem = {
                    guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: ReportProblemVC.getStoryboardID()) as? ReportProblemVC else { return }
                    vc.doctorId = "\(UserData.shared.doctorId ?? 0)"
                    vc.hasCameFrom = .doctors
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InfoAboutDoctorCell", for: indexPath) as! InfoAboutDoctorCell
                let obj = doctorDataModel?.result
                cell.titleLabel.text = navigationTabsNames[indexPath.row]
                switch indexPath.row {
                case 0: cell.infoLabel.text = obj?.aboutUs
                case 1: cell.infoLabel.text = obj?.professionalAffiliation
                case 2: cell.infoLabel.text = obj?.areaOfExpertise
                case 3: cell.infoLabel.text = obj?.education
                case 4: cell.infoLabel.text = (obj?.doctorExp?.count > 2) ? obj?.doctorExp : "\(String.getString(obj?.doctorExp) )" + " years of exp.".localize
                default:break
                }
                return cell
            }
        }
    }
    
}

// MARK: - UICollection view Delegate & DataSource
//@available(iOS 15.0, *)
//extension ViewDoctorProfileVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return navigationTabsNames.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewDoctorNavigationCVC", for: indexPath) as! ViewDoctorNavigationCVC
//        cell.labelTabName.text = navigationTabsNames[indexPath.row]
//        if indexPath.row == selectedTab {
//            cell.viewActive.isHidden = false
//            cell.labelTabName.textColor = #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1)
//            cell.labelTabName.font = UIFont(name: "SFProDisplay-Bold", size: 15)
//        } else {
//            cell.viewActive.isHidden = true
//            cell.labelTabName.textColor = #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1)
//            cell.labelTabName.font = UIFont(name: "SFProDisplay-Medium", size: 15)
//        }
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        let lastIndex = selectedTab
////
////        if lastIndex > selectedTab {
////            containerViewController?.changeViewController(index: selectedTab, direction: .reverse)
////        } else {
////            containerViewController?.changeViewController(index: selectedTab, direction: .forward)
////        }
////        collectionView.reloadData()
//        selectedTab = indexPath.row
//        backgroundTableView.scrollToRow(at: indexPath, at: .top, animated: true)
//        collectionView.reloadData()
//    }
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        return CGSizeMake(200, 50)
////    }
//}

extension UIImage {
    var grayscaled: UIImage? {
        let ciImage = CIImage(image: self)
        let grayscale = ciImage?.applyingFilter("CIColorControls",
                                                parameters: [ kCIInputSaturationKey: 0.0 ])
        if let gray = grayscale{
            return UIImage(ciImage: gray)
        }
        else{
            return nil
        }
    }
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

// MARK: - Reviews API
@available(iOS 15.0, *)
extension ViewDoctorProfileVC {
    func getReviews() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String : Any] = [:]
        TANetworkManager.sharedInstance.requestApi(
            withServiceName:ServiceName.surveyQuestions,
            requestMethod: .POST,
            requestParameters: params,
            withProgressHUD: false
        ) { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0{
                        let data = kSharedInstance.getArray(dictResult["result"])
                        self?.ratings =  data.map{
                            RatingModel(data:kSharedInstance.getDictionary($0))
                        }
                    } else {
                        CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    }
                default:
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToast(message: kNoInternetMsg)
                
            } else {
                CommonUtils.showToast(message: kDefaultErrorMsg)
            }
        }
    }
}

// MARK: - Favorite API
@available(iOS 15.0, *)
extension ViewDoctorProfileVC {
    func favoriteApi(
        isLike: Bool,
        type: HasCameFrom,
        id: Int
    ) {
        var params: [String: Any] = [:]
        
        var serviceUrl = ServiceName.doLike
        if !isLike {
            serviceUrl = ServiceName.doLike
            params = [
                ApiParameters.kLike: "1",
                ApiParameters.kType: type == HasCameFrom.doctors ? "doctor" : "hospital",
                //ApiParameters.kTargetId: String.getString(id)]
                ApiParameters.kTargetId: id
            ]
        } else {
            serviceUrl = ServiceName.doUnlike
            params = [
                ApiParameters.kUnlike: "1",
                ApiParameters.kType: type == HasCameFrom.doctors ? "doctor" : "hospital",
                //ApiParameters.kTargetId: String.getString(id)]
                ApiParameters.kTargetId: id]
        }
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:serviceUrl,
                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: true)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if self.isLiked  {
                        self.buttonFavorite.setImage(UIImage(named: "heart_unfill"), for: .normal)
                        self.labelHeartCount.text = "\(self.numberOfLikes - 1)"
                    } else {
                        self.buttonFavorite.setImage(UIImage(named: "heart_active"), for: .normal)
                        self.labelHeartCount.text = "\(self.numberOfLikes + 1)"
                    }
                    self.isLiked.toggle()
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                default:
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToast(message: kNoInternetMsg)
            } else {
                CommonUtils.showToast(message: kDefaultErrorMsg)
            }
        }
    }
}

@available(iOS 15.0, *)
extension ViewDoctorProfileVC {
    func getDoctorTimeSlots(doctorId: Int) {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params: [String: Any] = [
            //ApiParameters.page:String.getString(page),
            //ApiParameters.limit:String.getString(limit),
            ApiParameters.doctor_id: doctorId
        ]
        TANetworkManager.sharedInstance.requestApi(
            withServiceName: ServiceName.getDoctorTimeSlots,
            requestMethod: .POST,
            requestParameters: params,
            withProgressHUD: false
        ) { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                //print(result)
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    var model: TimeSoltResponse?
                    let convertDicToJsonString =  try? JSONSerialization.data(withJSONObject: dictResult, options: [.prettyPrinted])
                    let jsonString = String(data: convertDicToJsonString!, encoding: .utf8)!
                    let jsonStringToData = Data(jsonString.utf8)
                    let decoder = JSONDecoder()
                    do {
                        model = try decoder.decode(TimeSoltResponse.self, from: jsonStringToData)
                    } catch {
                        print(error.localizedDescription)
                    }
                    //print(model?.timeslots)
                    //if model?.status == 1 {
                    //else {
                    //CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    //}
                    self?.navigateToViewControlletTimeSlots(practoSltos: model)
                    break
                default:
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    break
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToast(message: kNoInternetMsg)
            } else {
                CommonUtils.showToast(message: kDefaultErrorMsg)
            }
        }
    }
}

@available(iOS 15.0, *)
extension ViewDoctorProfileVC {
    func bookingApi(isHospital: Bool, forOthers: Bool) {
        //var gender = ""
        //if self.buttonsGender[0].isSelected{
        //    gender =  "1"
        //}else if
        //    self.buttonsGender[1].isSelected{
        //    gender = "2"
        //}else{
        //    gender = "3"
        //}
        CommonUtils.showHudWithNoInteraction(show: true)
        let obj = UserData.shared
        var images: [[String: Any]] = []
        var params: [String: Any] = [
            ApiParameters.appointment_type: String.getString(obj.selectedSlotModel?.appointment_type),
            ApiParameters.slot_id: String.getString(obj.selectedSlotModel?.slot_id),
            ApiParameters.date: String.getString(obj.selectedSlotModel?.date),
            ApiParameters.doctor_id: String(Int(truncating: (obj.selectedSlotModel?.doctor_id.toEnglishNumber())!)),
            ApiParameters.patient_countryCode: String.getString(obj.patientDetails?.patient_countryCode),
            ApiParameters.is_save_adress: obj.patientDetails?.is_save_address ?? false ? "1" : "0",
            ApiParameters.old_date: String.getString(obj.old_date),
            ApiParameters.old_slot_id: String.getString(obj.old_slot_id),
            ApiParameters.slot_time: String.getString(obj.selectedSlotModel?.slot_time),
            ApiParameters.is_reschedule: obj.isReschedule ? "1" : "0"
        ]
        params[ApiParameters.kAddress] = String.getString(obj.patientDetails?.address)
        params[ApiParameters.kCity] = String.getString(obj.patientDetails?.city)
        params[ApiParameters.kPincode] = String.getString(obj.patientDetails?.pincode)
        params[ApiParameters.is_future_address] = obj.patientDetails?.is_future_address ?? false ? "1" : "0"
        if kSharedUserDefaults.isPractoEnabled(){
            let dateAsString = obj.selectedSlotModel?.slot_time
            //let dateAsString = "1:15 PM"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.locale = Locale(identifier: "en_US")
            let date = dateFormatter.date(from: dateAsString!)
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.locale = Locale(identifier: "en_US")
            let Date24 = dateFormatter.string(from: date!)
            let dateToFormateIso = (obj.selectedSlotModel?.date)! + "T" + Date24 + ":00Z"
            print(dateToFormateIso)
            params[ApiParameters.insta_hms_slot] = String.getString(dateToFormateIso)
            params.updateValue(String.getString(obj.selectedSlotModel?.fees), forKey:  ApiParameters.fees)
            params.updateValue(String.getString(obj.selectedSlotModel?.total_amount), forKey:  ApiParameters.total_amount)
            params.updateValue(String.getString(obj.patientDetails?.patient_name), forKey:  ApiParameters.patient_name)
            params.updateValue(String.getString(obj.patientDetails?.patient_name), forKey:  ApiParameters.patient_name)
            params.updateValue(String.getString(obj.patientDetails?.address_id), forKey:  ApiParameters.address_id)
            params.updateValue(String.getString(obj.patientDetails?.patient_mobile), forKey:  ApiParameters.patient_mobile)
            //params.updateValue(String.getString(gender), forKey:  ApiParameters.patient_gender)
            //params.updateValue(String.getString(textFieldEmail.text), forKey:  ApiParameters.patient_email)
            //params.updateValue(String.getString(textFieldMobile.text), forKey:  ApiParameters.patient_mobile)
            //params.updateValue(String.getString(selectedSavedAddress?.id), forKey:  ApiParameters.address_id)
            //ApiParameters.fees:String.getString(obj.selectedSlotModel?.fees)
            //ApiParameters.total_amount:String.getString(obj.selectedSlotModel?.total_amount),
            //ApiParameters.patient_name:String.getString(textFieldPatientName.text),
            //ApiParameters.patient_age:String.getString(textFieldAge.text),
            //ApiParameters.patient_gender:String.getString(gender),
            //ApiParameters.patient_email:String.getString(textFieldEmail.text),
            //ApiParameters.patient_mobile:String.getString(textFieldMobile.text),
            //ApiParameters.address_id:String.getString(selectedSavedAddress?.id)
        } else {
            //ApiParameters.patient_age:String.getString(obj.patientDetails?.patient_age),
            //ApiParameters.patient_gender:String.getString(obj.patientDetails?.patient_gender),
            //ApiParameters.patient_email:String.getString(obj.patientDetails?.patient_email),
            //ApiParameters.patient_mobile:String.getString(obj.patientDetails?.patient_mobile)
            //ApiParameters.address_id:String.getString(obj.patientDetails?.address_id),
            params[ApiParameters.patient_name] = String.getString(obj.patientDetails?.patient_name)
            params[ApiParameters.patient_age] = String.getString(obj.patientDetails?.patient_age)
            params[ApiParameters.patient_gender] = String.getString(obj.patientDetails?.patient_gender)
            params[ApiParameters.patient_email] = String.getString(obj.patientDetails?.patient_email)
            params[ApiParameters.patient_mobile] = String.getString(obj.patientDetails?.patient_mobile)
            params[ApiParameters.address_id] = String.getString(obj.patientDetails?.address_id)
            images.append(["imageName":ApiParameters.other_patient_imageFront,"image":UserData.shared.otherPatientDetails?.other_patient_imageFront ?? UIImage()])
            images.append(["imageName":ApiParameters.other_patient_imageBack,"image":UserData.shared.otherPatientDetails?.other_patient_imageBack ?? UIImage()])
            if forOthers {
                params[ApiParameters.other_patient_name] = String.getString(obj.otherPatientDetails?.other_patient_name)
                params[ApiParameters.other_patient_age]  = String.getString(obj.otherPatientDetails?.other_patient_age)
                params[ApiParameters.other_patient_relation]  = String.getString(obj.otherPatientDetails?.other_patient_relation)
                params[ApiParameters.other_patient_insurance]  = String.getString(obj.otherPatientDetails?.other_patient_insurance)
                params[ApiParameters.other_patient_mobile]  = String.getString(obj.otherPatientDetails?.other_patient_mobile)
                params[ApiParameters.other_notes]  = String.getString(obj.otherPatientDetails?.other_notes)
                params[ApiParameters.isOtherKey] = "1"
                params[ApiParameters.other_patient_gender]  = String.getString(obj.otherPatientDetails?.other_patient_gender)
                params[ApiParameters.other_patient_email]  = String.getString(obj.otherPatientDetails?.other_email)
                params[ApiParameters.other_patient_countryCode]  = String.getString(obj.otherPatientDetails?.other_patient_countryCode)
            } else if isHospital {
                params[ApiParameters.isHospitalBooking] = "1"
                forOthers ? () : (params[ApiParameters.isOtherKey] = "0")
                params[ApiParameters.hospital_id] = String.getString(obj.hospital_id)
            } else {
                params[ApiParameters.isHospitalBooking] = "0"
                params[ApiParameters.isOtherKey] = "0"
            }
        }
        TANetworkManager.sharedInstance.requestMultiPart(
            withServiceName: ServiceName.bookAppointment,
            requestMethod: .post,
            requestImages: images,
            requestVideos: [:],
            requestData: params
        ) { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0 {
                        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        vc.popUpDescription = "Booking has been successfully done"
                        vc.callback = { [weak self] in
                            guard let self = self else { return }
                            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                                self.dismiss(animated: true, completion: {
                                    UserData.shared.isReschedule = false
//                                    kSharedAppDelegate?.moveToHomeScreen()
                                    self.getListing()
                                })
                            })
                        }
                        self?.navigationController?.present(vc, animated: true)
                    } else {
                        CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    }
                default:
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToast(message: kNoInternetMsg)
            } else {
                CommonUtils.showToast(message: kDefaultErrorMsg)
            }
        }
    }
    
    func navigateToViewControlletTimeSlots(practoSltos: TimeSoltResponse?) {
        if ((practoSltos?.timeslots?.isEmpty)!) {
            guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: AppointmentSlotVC.getStoryboardID()) as? AppointmentSlotVC else { return }
            vc.slots = doctorDataModel?.result.slotArray?.slots.filter { $0.slotType == self.appointmentType } ?? []
            isSlotsAvailable = true
            if vc.slots.isEmpty {
                //isSlotsAvailable = false
                CommonUtils.showToast(message: "No Slots Found, please select another service.")
                return
            }
            vc.callback = { [weak self] id, date, time in
                guard let self = self else { return }
                if date != "" {
                    self.selectedSlotId = id
                    self.selectedSlotDate = date
                    self.isSlotsAvailable = true
                    self.selectedSlotTime = time
                    self.proceed()
                    //self.buttonSlots.setTitle("Selected Slot for \(date)", for: .normal)
                    //self.buttonSlots.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
            kSharedUserDefaults.setPractoEnabled(isPractoEnabled: false)
        } else {
            kSharedUserDefaults.setPractoEnabled(isPractoEnabled: true)
            var slots: [SlotTimeDateItem] = []
            practoSltos?.timeslots?.forEach({ isoDate in
                let isoFormatter = DateFormatter()
                let dateFormatter = DateFormatter()
                let timeFormatter = DateFormatter()
                isoFormatter.locale = Locale(identifier: "en_US")
                isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.locale = Locale(identifier: "en_US")
                //timeFormatter.dateFormat = "HH:mm:ss a"
                timeFormatter.dateFormat = "HH:mm a"
                timeFormatter.locale = Locale(identifier: "en_US")
                let dateIso = isoFormatter.date(from: isoDate)
                let time = timeFormatter.string(from: dateIso!)
                let date = dateFormatter.string(from: dateIso!)
                let slot = SlotTimeDateItem(time: time, date: date)
                slots.append(slot)
            })
            guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PractoTimeSlotVC.getStoryboardID()) as? PractoTimeSlotVC else { return }
            vc.slots = slots
            isSlotsAvailable = true
            if vc.slots.isEmpty {
                isSlotsAvailable = false
                CommonUtils.showToast(message: "No Slots Found for, please select another service.")
                return
            }
            vc.callback = { [weak self] id, date, time in
                guard let self = self else { return }
                if date != "" {
                    self.selectedSlotId = id
                    self.selectedSlotDate = date
                    self.isSlotsAvailable = true
                    self.selectedSlotTime = time
                    //self.buttonSlots.setTitle("Selected Slot for \(date)", for: .normal)
                    //self.buttonSlots.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                    self.proceed()
                }
            }
            //vc.slots = mappedSlots
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func checkSlotsApi() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let obj = UserData.shared.selectedSlotModel
        //print(selectedSlotTime)
        //print(selectedSlotDate)
        //let dateAsString = selectedSlotTime
        //let dateAsString = "1:15 PM"
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "h:mm a"
        //dateFormatter.locale = Locale(identifier: "en_US")
        //let date = dateFormatter.date(from: dateAsString)
        //dateFormatter.dateFormat = "HH:mm"
        //let Date24 = dateFormatter.string(from: date!)
        //let dateToFormateIso = self.selectedSlotDate + "T" + Date24 + ":00Z"
        //print(dateToFormateIso)
        //return
        let params: [String : Any] = [
            ApiParameters.appointment_type: String.getString(obj?.appointment_type),
            ApiParameters.isHospitalBooking: String.getString(UserData.shared.hospital_id).isEmpty ? "0" : "1",
            ApiParameters.hospital_id: String.getString(UserData.shared.hospital_id),
            ApiParameters.doctor_id: String.getString(obj?.doctor_id),
            ApiParameters.date: String.getString(obj?.date),
            ApiParameters.slot_id: String.getString(obj?.slot_id)
        ]
        
        TANetworkManager.sharedInstance.requestApi(
            withServiceName: ServiceName.checkSlotAvailablity,
            requestMethod: .POST,
            requestParameters: params,
            withProgressHUD: false
        ) { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0 {
                        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: AddSelfPatientDetails.getStoryboardID()) as? AddSelfPatientDetails else { return }
                        
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                    else{
                        CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToast(message: kNoInternetMsg)
                
            } else {
                CommonUtils.showToast(message: kDefaultErrorMsg)
            }
        }
    }
    
    func saveDetails() {
        //  1 for audio, 2 for video, 3 for chat, 4 for house and 5 for visit consultation
        UserData.shared.selectedSlotModel = selectedSlotModel(
            appointment_type: UserData.shared.appointmentType,
            slot_id: selectedSlotId,
            date: selectedSlotDate,
            doctor_id: String.getString(doctorDataModel?.result.doctorID),
            fees: String.getString(doctorDataModel?.result.doctorCommunicationServices?.first?.commDurationFee ?? 0),
            total_amount: String.getString(String.getString((Double.getDouble(doctorDataModel?.result.doctorCommunicationServices?.first?.commDurationFee)/100 * 5) + (Double.getDouble(doctorDataModel?.result.doctorCommunicationServices?.first?.commDurationFee)))),
            slot_time: selectedSlotTime
        )
    }
}

// MARK: - GET Doctor Details
extension ViewDoctorProfileVC {
    private func fetchDoctorDetails(doctorID: Int, completion: @escaping (Swift.Result<DoctorDataModel, Error>) -> Void) {
        CommonUtils.showHud(show: true)
        let baseURL = "http://62.210.203.134/hlthera_engage_backend/api/user/doctor-details"
        
        let parmas: [String: Any] = ["doctor_id": "\(doctorID)"]
        
        Alamofire.request(
            baseURL,
            method: .post,
            parameters: parmas,
            encoding: JSONEncoding.default
        )
        .validate()
        .responseJSON { response in
            CommonUtils.showHud(show: false)
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let doctorData = try JSONDecoder().decode(DoctorDataModel.self, from: data)
                        completion(.success(doctorData))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func getListing(){
        CommonUtils.showHudWithNoInteraction(show: true)
        let cType = 0
        let params:[String : Any] = [ApiParameters.booking_type:String.getString(cType)]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.ongoingBookings,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    let result = kSharedInstance.getArray(dictResult["result"])
//                    self?.internetTime = String.getString(dictResult["timestamp"])
                    if Int.getInt(dictResult["status"]) == 0{
                        var model:DataResponeOnGoingSearch?
                        let convertDicToJsonString =  try? JSONSerialization.data(withJSONObject: dictResult, options: [.prettyPrinted])
                        let jsonString = String(data: convertDicToJsonString!, encoding: .utf8)!
                        let jsonStringToData = Data(jsonString.utf8)
                        let decoder = JSONDecoder()
                        do {
                            model = try decoder.decode(DataResponeOnGoingSearch.self, from: jsonStringToData)
                        } catch {
                            print(String(describing: error)) }
                        self?.bookingDetails = model?.result ?? []
                        guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: BookingFullDetailsVC.getStoryboardID()) as? BookingFullDetailsVC else { return }
                        vc.data = self?.bookingDetails[0]
                        vc.hasCameFrom = .bookAppointment
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                    else{
                        CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToast(message: kNoInternetMsg)
                
            } else {
                CommonUtils.showToast(message: kDefaultErrorMsg)
            }
            CommonUtils.showHudWithNoInteraction(show: false)
        }
    }
}

protocol viewDoctorDelegate: AnyObject {
    func updateModel(doctorId: Int)
}

//MARK: - commented code
//switch hasComeFrom {
//case .home:
//    accesViewsComeFromHome()
//    break
//case .searchDoctor:
//    accesViewsComeFromSearchGeneral()
//    break
//default:
//    accesViewsComeFromNone()
//    break
//}
//accesViewsComeFromHome()
//func accesViewsComeFromSearchGeneral() {
//        if ((searchResultFromSpecialist?.isLike) != nil) {
//            buttonFavorite.setImage(UIImage(named: "heart_unfill"), for: .normal)
//            isLiked = false
//        } else {
//            buttonFavorite.setImage(UIImage(named: "heart_active"), for: .normal)
//            isLiked = true
//        }
//        resultDoctorFromSpecialist = searchResultFromGeneral
//        //if let data = searchResult{
//        //self.labelPrice.text = "$\(getMinimumPrice(from: data))"
//        //}
//        self.labelDoctorName.text = String.getString(searchResultFromGeneral?.doctorName)
//        self.labelHeartCount.text = String.getString(Int.getInt(searchResultFromGeneral?.likes) < 0 ? (0) : (searchResult?.likes))
//        //self.labelRating.text = "0.0(0)"
//        self.labelRating.text = searchResult?.ratings
//        if(!(searchResultFromGeneral?.doctorSpecialities?.isEmpty)!){
//            self.labelDoctorSpeciality.text = String.getString(searchResultFromGeneral?.doctorSpecialities![0].fullName)
//        }
//        self.labelExperience.text = String.getString(searchResultFromGeneral?.doctorExp) + " years of exp.".localize
//        self.imageProfile.downlodeImage(serviceurl: String.getString(searchResultFromGeneral?.doctorProfile), placeHolder: UIImage(named: "placeholder"))
//
//        searchResultFromGeneral?.doctorCommunicationServices?.forEach {
//            if $0.commServiceType == "video" {
//                self.buttonVideo.setImage(UIImage(named: "video_white"), for: .normal)
//                self.buttonVideo.isUserInteractionEnabled = true
//            }
//            if $0.commServiceType == "home" {
//                self.buttonHome.setImage(UIImage(named: "home_visit_white"), for: .normal)
//                self.buttonHome.isUserInteractionEnabled = true
//            }
//            if $0.commServiceType == "chat" {
//                self.buttonChat.setImage(UIImage(named: "chat_white"), for: .normal)
//                self.buttonChat.isUserInteractionEnabled = true
//            }
//            if $0.commServiceType == "audio" {
//                self.buttonPhone.setImage(UIImage(named: "call_white"), for: .normal)
//                self.buttonPhone.isUserInteractionEnabled = true
//            }
//            if $0.commServiceType == "visit" {
//                self.buttonFinance.setImage(UIImage(named: "clinic_visit_white"), for: .normal)
//                self.buttonFinance.isUserInteractionEnabled = true
//            }
//        }
//    }
//
//    func accesViewsComeFromNone() {
//        if ((searchResult?.isLike) != nil) {
//            buttonFavorite.setImage(UIImage(named: "heart_unfill"), for: .normal)
//            isLiked = false
//        } else {
//            buttonFavorite.setImage(UIImage(named: "heart_active"), for: .normal)
//            isLiked = true
//        }
//        result = searchResult
//        //if let data = searchResult{
//        //self.labelPrice.text = "$\(getMinimumPrice(from: data))"
//        //}
//        self.labelDoctorName.text = String.getString(searchResult?.doctor_name)
//        self.labelHeartCount.text = String.getString(Int.getInt(searchResult?.likes) < 0 ? (0) : (searchResult?.likes))
//        //self.labelRating.text = "0.0(0)"
//        self.labelRating.text = "4.5"
//        if(!(searchResult?.doctor_specialities.isEmpty)!){
//            self.labelDoctorSpeciality.text = String.getString(searchResult?.doctor_specialities[0].full_name)
//        }
//        self.labelExperience.text = String.getString(searchResult?.doctor_exp) + " years of exp.".localize
//        self.imageProfile.downlodeImage(serviceurl: String.getString(searchResult?.doctor_profile), placeHolder: UIImage(named: "placeholder"))
//
//        searchResult?.doctor_communication_services.forEach {
//            if $0.comm_service_type == "video" {
//                self.buttonVideo.setImage(UIImage(named: "video_white"), for: .normal)
//                self.buttonVideo.isUserInteractionEnabled = true
//            }
//            if $0.comm_service_type == "home" {
//                self.buttonHome.setImage(UIImage(named: "home_visit_white"), for: .normal)
//                self.buttonHome.isUserInteractionEnabled = true
//            }
//            if $0.comm_service_type == "chat" {
//                self.buttonChat.setImage(UIImage(named: "chat_white"), for: .normal)
//                self.buttonChat.isUserInteractionEnabled = true
//            }
//            if $0.comm_service_type == "audio" {
//                self.buttonPhone.setImage(UIImage(named: "call_white"), for: .normal)
//                self.buttonPhone.isUserInteractionEnabled = true
//            }
//            if $0.comm_service_type == "visit" {
//                self.buttonFinance.setImage(UIImage(named: "clinic_visit_white"), for: .normal)
//                self.buttonFinance.isUserInteractionEnabled = true
//            }
//        }
//    }
//

// MARK: - Actions
@available(iOS 15.0, *)
extension ViewDoctorProfileVC {
    @IBAction private func buttonAddToFavoriteTapped(_ sender: Any) {
        let doctorId = searchResult!.doctor_id.toEnglishNumber()
        self.favoriteApi(isLike: isLiked, type: .doctors, id: Int.getInt(doctorId))
    }
    
//    @IBAction private func buttonBackTapped(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
    
//    @IBAction private func buttonPhoneTapped(_ sender: Any) {
        //guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: DoctorBookingAppointmentVC.getStoryboardID()) as? DoctorBookingAppointmentVC else { return }
        //vc.selectedCommunication = "audio"
        //let res = searchResult?.doctor_communication_services.filter{$0.comm_service_type == "audio"}
        //vc.selectedObject = res?[0]
        //vc.data = self.searchResult
        //UserData.shared.otherPatientDetails = OtherPatientDetailsModel()
        //self.navigationController?.pushViewController(vc, animated: true)
//        UserData.shared.appointmentType = "1"
//        appointmentType = "audio"
//        getDoctorTimeSlots(doctorId: doctorDataModel?.result.doctorID ?? 0)
//    }
    
//    @IBAction private func buttonChatTapped(_ sender: Any) {
        //guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: DoctorBookingAppointmentVC.getStoryboardID()) as? DoctorBookingAppointmentVC else { return }
        //vc.selectedCommunication = "chat"
        //let res = searchResult?.doctor_communication_services.filter{$0.comm_service_type == "chat"}
        //vc.selectedObject = res?[0]
        //vc.data = self.searchResult
        //UserData.shared.otherPatientDetails = OtherPatientDetailsModel()
        //self.navigationController?.pushViewController(vc, animated: true)
//        UserData.shared.appointmentType = "3"
//        appointmentType = "chat"
//        getDoctorTimeSlots(doctorId: doctorDataModel?.result.doctorID ?? 0)
//    }
    
//    @IBAction private func buttonHomeTapped(_ sender: Any) {
        //guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: DoctorBookingAppointmentVC.getStoryboardID()) as? DoctorBookingAppointmentVC else { return }
        //vc.selectedCommunication = "home"
        //let res = searchResult?.doctor_communication_services.filter{$0.comm_service_type == "home"}
        //vc.selectedObject = res?[0]
        //vc.data = self.searchResult
        //UserData.shared.otherPatientDetails = OtherPatientDetailsModel()
        //self.navigationController?.pushViewController(vc, animated: true)
//        UserData.shared.appointmentType = "4"
//        appointmentType = "home"
//        getDoctorTimeSlots(doctorId: doctorDataModel?.result.doctorID ?? 0)
//    }
    
//    @IBAction private func buttonFinancialTapped(_ sender: Any) {
        //guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: DoctorBookingAppointmentVC.getStoryboardID()) as? DoctorBookingAppointmentVC else { return }
        //vc.selectedCommunication = "visit"
        //let res = searchResult?.doctor_communication_services.filter{$0.comm_service_type == "visit"}
        //vc.selectedObject = res?[0]
        //vc.data = self.searchResult
        //UserData.shared.otherPatientDetails = OtherPatientDetailsModel()
        //self.navigationController?.pushViewController(vc, animated: true)
//        UserData.shared.appointmentType = "5"
//        appointmentType = "visit"
//        getDoctorTimeSlots(doctorId: doctorDataModel?.result.doctorID ?? 0)
//    }
    
//    @IBAction private func buttonVideoTapped(_ sender: Any) {
        //guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: DoctorBookingAppointmentVC.getStoryboardID()) as? DoctorBookingAppointmentVC else { return }
        //vc.selectedCommunication = "video"
        //let res = searchResult?.doctor_communication_services.filter{$0.comm_service_type == "video"}
        //vc.selectedObject = res?[0]
        //vc.data = self.searchResult
        //UserData.shared.otherPatientDetails = OtherPatientDetailsModel()
        //self.navigationController?.pushViewController(vc, animated: true)
//        UserData.shared.appointmentType = "2"
//        appointmentType = "video"
//        getDoctorTimeSlots(doctorId: doctorDataModel?.result.doctorID ?? 0)
//    }
    
//    @IBAction private func buttonShareTapped(_ sender: Any) {
//        let textToShare = kAppName
//        if let myWebsite = NSURL(string: String.getString(searchResult?.shareable_url)) {
//            let objectsToShare = [textToShare, myWebsite] as [Any]
//            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
//            self.present(activityVC, animated: true, completion: nil)
//        }
//    }
    
//    @IBAction private func buttonLocationTapped(_ sender: Any) {
//        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: DoctorLocationVc.getStoryboardID()) as? DoctorLocationVc else { return }
//        //vc.doctorDetailModel = result
//        //print("searchResult = \(result?.lat ?? "")")
//        //print("searchResult = \(result?.longitude ?? "")")
//        //print("searchResult = \(result?.doctor_name ?? "")")
//        vc.hasComeFrom = self.hasComeFrom
//        switch hasComeFrom {
//        case .home:
//            vc.searchResultFromSpecialist = resultDoctorFromSpecialist
//        default:
//            vc.doctorDetailModel = result
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
}
