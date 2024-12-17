//
//  MyDoctorsVC.swift
//  Hlthera
//
//  Created by Prashant on 14/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import EzPopup

class MyDoctorsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var navigationButtons: [UIButton]!
    @IBOutlet weak var stackViewNavigation: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var doctors = ["",""]
    var hasCameFrom: HasCameFrom = .scheduled
    //var bookingDetails:[BookingDataModel] = []
    var bookingDetails:[ResultOnGoingSearch] = []
    var internetTime = ""
//    var navigationTabsNames = ["Scheduled","Ongoing","Past","Cancelled"]
    var selectedTab = 0 {
        didSet {
            switch hasCameFrom{
            case .ongoing:
                self.tableView.register(UINib(nibName: OngoingBookingTVC.identifier, bundle: nil), forCellReuseIdentifier: OngoingBookingTVC.identifier)
            case .scheduled:
                self.tableView.register(UINib(nibName: ScheduledBookingTVC.identifier, bundle: nil), forCellReuseIdentifier: ScheduledBookingTVC.identifier)
            case .past:
                self.tableView.register(UINib(nibName: PastBookingTVC.identifier, bundle: nil), forCellReuseIdentifier: PastBookingTVC.identifier)
            case .cancelled:
                self.tableView.register(UINib(nibName: CancelledBookingTVC.identifier, bundle: nil), forCellReuseIdentifier: CancelledBookingTVC.identifier)
            default:break
            }
            getListing(type: hasCameFrom)
        }
    }
    var refreshControl : UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupStatusBar()
        
//        lblTitle.font = .corbenRegular(ofSize: 15)
        //setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        self.selectedTab = 0
        setupNavigation()
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(methodPullToRefresh), for: UIControl.Event.valueChanged)
        self.refreshControl.tintColor = .clear

        self.tableView.addSubview(self.refreshControl)
    }
    
    @objc func methodPullToRefresh()
    {
        self.refreshControl.endRefreshing()
        getListing(type: hasCameFrom)

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupStatusBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func setupNavigation(selectedIndex: Int = 0) {
        
        for (index,view) in self.stackViewNavigation.arrangedSubviews.enumerated(){
            for btn in view.subviews{
                if let button  = btn as? UIButton {
                    button.setTitleColor(selectedIndex == index ? (#colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)) : (#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1)), for: .normal)
                    button.titleLabel?.font = selectedIndex == index ? (UIFont(name: "SFProDisplay-Bold", size: 15)) : (UIFont(name: "SFProDisplay-Medium", size: 15))
                    button.adjustsImageWhenDisabled = false
                    button.adjustsImageWhenHighlighted = false
                }
                
                else{
                    btn.isHidden = index == selectedIndex ? (false) : (true)
                    btn.backgroundColor = index == selectedIndex ? (#colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)) : (#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1))
                    
                }
            }
        }
    }
    
    func mapDoctorOnGoingSearchToDoctor(doctorOnGoingSearch: DoctorOnGogingSearch) -> Doctor {
        return Doctor(
            id: doctorOnGoingSearch.id,
            name: doctorOnGoingSearch.name,
            email: doctorOnGoingSearch.email,
            countryCode: doctorOnGoingSearch.countryCode,
            mobileNumber: doctorOnGoingSearch.mobileNumber,
            gender: doctorOnGoingSearch.gender,
            emailVerifiedAt: nil, // Set the appropriate value for emailVerifiedAt
            password: doctorOnGoingSearch.password,
            rememberToken: nil, // Set the appropriate value for rememberToken
            socialID: nil, // Set the appropriate value for socialID
            loginType: doctorOnGoingSearch.loginType,
            otp: doctorOnGoingSearch.otp,
            otpTime: doctorOnGoingSearch.otpTime,
            isVerify: doctorOnGoingSearch.isVerify,
            isProfileCreated: doctorOnGoingSearch.isProfileCreated,
            isIndividual: doctorOnGoingSearch.isIndividual,
            profilePicture: doctorOnGoingSearch.profilePicture,
            isHospitalVerify: doctorOnGoingSearch.isHospitalVerify,
            isAdminVerify: doctorOnGoingSearch.isAdminVerify,
            isBlock: doctorOnGoingSearch.isBlock,
            likes: doctorOnGoingSearch.likes,
            availablityStatus: doctorOnGoingSearch.availablityStatus,
            accountType: doctorOnGoingSearch.accountType,
            hospitalGeneratedCode: doctorOnGoingSearch.hospitalGeneratedCode,
            docterVerifiedByHospital: doctorOnGoingSearch.docterVerifiedByHospital,
            createdAt: doctorOnGoingSearch.createdAt,
            updatedAt: doctorOnGoingSearch.updatedAt,
            isAvailableToday: (doctorOnGoingSearch.isAvailableToday ?? false) ? 1 : 0
        )
    }
    
    func mapDoctorInformationOnGoingSearchToDoctorInformation(doctorInformationOnGoingSearch: DoctorInformationOnGogingSearch) -> DoctorInformation {
        return DoctorInformation(
            id: doctorInformationOnGoingSearch.id,
            doctorID: doctorInformationOnGoingSearch.doctorID,
            clinicID: doctorInformationOnGoingSearch.clinicID,
            dateOfBirth: doctorInformationOnGoingSearch.dateOfBirth,
            countryID: doctorInformationOnGoingSearch.countryID,
            cityID: doctorInformationOnGoingSearch.cityID,
            doctorAddress: doctorInformationOnGoingSearch.doctorAddress,
            doctorWorkNumber: doctorInformationOnGoingSearch.doctorWorkNumber,
            aboutUs1: doctorInformationOnGoingSearch.aboutUs1,
            aboutUs2: doctorInformationOnGoingSearch.aboutUs2,
            licenseFirst: doctorInformationOnGoingSearch.licenseFirst,
            licenseSecond: doctorInformationOnGoingSearch.licenseSecond,
            experience: doctorInformationOnGoingSearch.experience,
            lat: doctorInformationOnGoingSearch.lat,
            longitude: doctorInformationOnGoingSearch.longitude
        )
    }
    //    private lazy var firstViewController: FAQVC = {
    //           // Load Storyboard
    //           let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    //
    //           // Instantiate View Controller
    //           var viewController = storyboard.instantiateViewController(withIdentifier: "FirstViewController") as! FAQVC
    //
    //           // Add View Controller as Child View Controller
    //           self.add(asChildViewController: viewController)
    //
    //           return viewController
    //       }()
    //
    //       private lazy var secondViewController: AboutVC = {
    //           // Load Storyboard
    //           let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    //
    //           // Instantiate View Controller
    //           var viewController = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as! AboutVC
    //
    //           // Add View Controller as Child View Controller
    //           self.add(asChildViewController: viewController)
    //
    //           return viewController
    //       }()
    //    private func add(asChildViewController viewController: UIViewController) {
    //
    //           // Add Child View Controller
    //           addChildViewController(viewController)
    //
    //           // Add Child View as Subview
    //           containerView.addSubview(viewController.view)
    //
    //           // Configure Child View
    //           viewController.view.frame = containerView.bounds
    //           viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    //
    //           // Notify Child View Controller
    //           viewController.didMove(toParentViewController: self)
    //       }
    //    private func remove(asChildViewController viewController: UIViewController) {
    //           // Notify Child View Controller
    //           viewController.willMove(toParentViewController: nil)
    //
    //           // Remove Child View From Superview
    //           viewController.view.removeFromSuperview()
    //
    //           // Notify Child View Controller
    //           viewController.removeFromParentViewController()
    //       }
    
    //remove(asChildViewController: secondViewController)
    //add(asChildViewController: firstViewController)
    @IBAction func buttonsNavigationTapped(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            setupNavigation(selectedIndex: sender.tag)
            self.hasCameFrom = .scheduled
        case 1:
            setupNavigation(selectedIndex: sender.tag)
            self.hasCameFrom = .ongoing
        case 2:
            setupNavigation(selectedIndex: sender.tag)
            self.hasCameFrom = .past
        case 3:
            setupNavigation(selectedIndex: sender.tag)
            self.hasCameFrom = .cancelled
        default: break
        }
        self.tableView.reloadData()
        self.selectedTab = sender.tag
        //self.collectionView.reloadData()
        
        //
    }
    
    @IBAction private func backButtonTapped(_ sender: Any) {
    }
}

//extension MyDoctorsVC:UICollectionViewDelegate,UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return navigationTabsNames.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewDoctorNavigationCVC", for: indexPath) as! ViewDoctorNavigationCVC
//        cell.labelTabName.text = navigationTabsNames[indexPath.row]
//        if indexPath.row == selectedTab{
//            cell.viewActive.isHidden = false
//            cell.labelTabName.textColor = #colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)
//        }
//        else{
//            cell.viewActive.isHidden = true
//            cell.labelTabName.textColor = #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1)
//        }
//        return cell
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        switch indexPath.row{
//        case 0:
//            self.hasCameFrom = .ongoing
//        case 1:
//            self.hasCameFrom = .scheduled
//        case 2:
//            self.hasCameFrom = .past
//        case 3:
//            self.hasCameFrom = .cancelled
//        default:
//            break
//        }
//        self.selectedTab = indexPath.row
//        self.collectionView.reloadData()
//    }
//
//}

@available(iOS 15.0, *)
@available(iOS 15.0, *)
extension MyDoctorsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.numberOfRow(numberofRow: bookingDetails.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch hasCameFrom{
        case .ongoing:
            let cell = tableView.dequeueReusableCell(withIdentifier: OngoingBookingTVC.identifier, for: indexPath) as! OngoingBookingTVC
            let obj = bookingDetails[indexPath.row]
            //            cell.labelInProcess.isHidden = true
            cell.labelBookingID.text = obj.id?.toString()
            cell.labelDoctorName.text = obj.doctor?.name
//            cell.labelDoctorSpeciality.text = obj.doctorSpecialities[0]
//            cell.labelDoctorSpeciality.text = obj.doctorSpecialities![0].specialities
            cell.labelDoctorSpeciality.text = obj.doctorSpecialities?.specialities
            cell.labelDoctorRating.text = String(format : "%.1f", obj.ratings ?? 0.0)
            cell.labelDoctorFees.text = obj.hospital?.name
            let slotTime =   self.getDateFromString(dateString: String.getString(obj.doctorSlotInformation?.date), timeString: String.getString(obj.doctorSlotInformation?.slotTime)).timeIntervalSince1970
            let currentTime = Date(milliseconds: Int64(Double.getDouble(self.internetTime)) * 1000).timeIntervalSince1970
            let diff = Int(currentTime - slotTime)

            let hours = diff / 3600
            let minutes = (diff - hours * 3600) / 60
            let timeLeft = 60 - minutes
            //let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(Int(timeLeft ?? 0)), repeats: true) { timer in
            print("Timer fired!")
            // cell.labelTime

            //  }
            //          cell.labelTimeLeft.text = String.getString(timeLeft) + " mins left"
            //            cell.labelDoctorAddress.text = obj.doctorInformation?.doctorAddress
            //            cell.labelDoctorFees.text = "$" + obj.fees!
            //            cell.labelDoctorFees.text = obj
            cell.labelTime.text = obj.doctor?.isAvailableToday ?? false ? "Available Today".localize : "Not Available Today".localize
            cell.labelExperience.text =  String.getString(obj.doctorInformation?.experience) + " years of exp.".localize
            cell.imageDoctor.downlodeImage(serviceurl: "https://hlthera-s3.s3-ap-southeast-2.amazonaws.com/user_profile/" + String.getString(obj.doctor?.profilePicture), placeHolder: UIImage(named: "placeholder"))

            switch String.getString(obj.doctorServiceFee?.commServiceType){
            case "video":
                //                cell.imageServiceIcon.image = UIImage(named: "video_call_sm")
                cell.imageServiceIcon.image = UIImage(named: "video2")

            case "home":
                cell.imageServiceIcon.image = UIImage(named: "home")

            case "chat":
                cell.imageServiceIcon.image = UIImage(named: "chat_sm")

            case "audio":
                cell.imageServiceIcon.image = UIImage(named: "call_sm")

            case "visit":
                cell.imageServiceIcon.image = UIImage(named: "home_visit_sm")

            default:break

            }
            cell.callbackFullDetails = {
                guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: BookingFullDetailsVC.getStoryboardID()) as? BookingFullDetailsVC else { return }
                vc.data = obj
                vc.isOngoing = true
                vc.hasCameFrom = .ongoing
                //                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: MyLocationVC.getStoryboardID()) as? MyLocationVC else { return }

                //                guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: SearchDoctorVC.getStoryboardID()) as? SearchDoctorVC else { return }
                //
                //                guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: FilterDoctorVC.getStoryboardID()) as? FilterDoctorVC else { return }

                //                guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: ReportProblemVC.getStoryboardID()) as? ReportProblemVC else { return }
                //                vc.doctorId = "51"

                //                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: FeelingUnwellVC.getStoryboardID()) as? FeelingUnwellVC else { return }

                self.navigationController?.pushViewController(vc, animated: true)

            }
            return cell
        case .scheduled:
            let cell = tableView.dequeueReusableCell(withIdentifier: ScheduledBookingTVC.identifier, for: indexPath) as! ScheduledBookingTVC
            let obj = bookingDetails[indexPath.row]
            if Int.getInt(obj.status) == 4 {
                cell.buttonReschedule.isHidden = true
                cell.buttonConfirm.isUserInteractionEnabled = false
                cell.buttonConfirm.setTitle("Confirmed".localize, for: .normal)
                cell.labelCancelled.text = "Confirmed".localize
                cell.labelCancelled.textColor = UIColor().hexStringToUIColor(hex: "#68A85F")
                //                cell.labelCancelled.isHidden = true

            } else {
                cell.buttonReschedule.isHidden = false
                cell.buttonConfirm.isUserInteractionEnabled = true
                cell.buttonConfirm.setTitle("Confirm".localize, for: .normal)
                //                cell.labelCancelled.isHidden = true
            }

            cell.labelBookingID.text = obj.id?.toString().localize
            cell.labelDoctorName.text = obj.doctor?.name

            //cell.labelDoctorSpeciality.text = obj.doctor_specialities[0]
            //            cell.labelDoctorSpeciality.text = obj.doctorSpecialities![0].specialities
            cell.labelDoctorSpeciality.text = obj.doctorSpecialities?.specialities

            cell.labelRating.text = String(format : "%.1f", obj.ratings ?? 0.0).localize

            //            cell.labelAddress.text = obj.doctorInformation?.doctorAddress
            //cell.labelFees.text = "$" + obj.fees!
            cell.labelFees.text = obj.hospital?.name ?? ""

            cell.labelTime.text = obj.doctor?.isAvailableToday ?? false ? "Available Today".localize : "Not Available Today".localize
            cell.labelExperience.text =  String.getString(obj.doctorInformation?.experience) + " years of exp.".localize
            cell.imageDoctor.downlodeImage(serviceurl: "https://hlthera-s3.s3-ap-southeast-2.amazonaws.com/user_profile/" + String.getString(obj.doctor?.profilePicture), placeHolder: UIImage(named: "placeholder"))
            switch String.getString(obj.doctorServiceFee?.commServiceType){
            case "video":
                cell.imageServiceIcon.image = UIImage(named: ServiceIconIdentifiers.video)

            case "home":
                cell.imageServiceIcon.image = UIImage(named: ServiceIconIdentifiers.home)

            case "chat":
                cell.imageServiceIcon.image = UIImage(named: ServiceIconIdentifiers.chat)

            case "audio":
                cell.imageServiceIcon.image = UIImage(named: ServiceIconIdentifiers.audio)

            case "visit":
                cell.imageServiceIcon.image = UIImage(named: ServiceIconIdentifiers.clinic)

            default:break

            }

            cell.callbackRate = {
                guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: GiveRatingVC.getStoryboardID()) as? GiveRatingVC else { return }
                vc.productId = "\(obj.id ?? 0)"
                vc.data = obj
                vc.hasCameFrom = .doctors
                UserData.shared.hospital_id = ""

                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.callbackFullDetails = {
                guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: BookingFullDetailsVC.getStoryboardID()) as? BookingFullDetailsVC else { return }
                vc.data = obj
                vc.hasCameFrom = .scheduled
                self.navigationController?.pushViewController(vc, animated: true)

            }
            cell.callbackSchedule = {

                guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: AlertVC.getStoryboardID()) as? AlertVC else { return }
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                vc.alertDesc = "Are you sure you want to reschedule your appointment".localize
                vc.textColor = UIColor(red: 33, green: 37, blue: 41)
//                ".localize + " \(String.getString(obj.doctorServiceFee?.commDurationType))" + "appointment?".localize
                vc.yesCallback = {

                    self.dismiss(animated: true, completion: {
                        globalApis.getDoctorDetails(doctorId: obj.doctorID!, communicationServiceId: String.getString(obj.doctorServiceFee?.id), slotId: String.getString(obj.slotID)){ data in
                            guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: DoctorBookingAppointmentVC.getStoryboardID()) as? DoctorBookingAppointmentVC else { return }
                            vc.selectedCommunication = String.getString(obj.doctorServiceFee?.commServiceType)
                            let res = data.doctor_communication_services.filter{$0.comm_service_type ==  obj.doctorServiceFee?.commServiceType}
                            if res.indices.contains(0){
                                vc.selectedObject = res[0]
                            }
                            else{
                                CommonUtils.showToast(message: "Data not found".localize)
                                return
                            }

                            vc.data = data
                            UserData.shared.otherPatientDetails = OtherPatientDetailsModel()
                            UserData.shared.isReschedule = true
                            UserData.shared.old_date = String.getString(obj.doctorSlotInformation?.date)
                            UserData.shared.old_slot_id = String.getString(obj.doctorSlotInformation?.id)

                            self.navigationController?.pushViewController(vc, animated: true)
                        }

                    })

                }
                self.navigationController?.present(vc, animated: true)



            }
            cell.callbackConfirm = {
                globalApis.updateBookingStatus(bookingId: (obj.id?.toString())!, doctorId: obj.doctorID!, status: 4){ _ in
                    guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    vc.popUpDescription = "Your appointment has been confirmed".localize
                    vc.popUpImage = #imageLiteral(resourceName: "smile")
                    vc.callback = { [weak self] in
                        guard let self = self else { return }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { [weak self] in
                            guard let self = self else { return }
                            self.dismiss(animated: true, completion: {
                                self.getListing(type: self.hasCameFrom)
                            }
                            )
                        })
                    }
                    self.navigationController?.present(vc, animated: true)
                }
            }
            cell.callbackCancel = {
                guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: AlertVC.getStoryboardID()) as? AlertVC else { return }
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen

                vc.yesCallback = {

                    self.dismiss(animated: true, completion: {
                        guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: AppointmentCancellationVC.getStoryboardID()) as? AppointmentCancellationVC else { return }
                        vc.data = obj
                        self.navigationController?.pushViewController(vc, animated: true)
                    })

                }
                self.navigationController?.present(vc, animated: true)
            }
            cell.callbackCheckIn = { [weak self] in
                guard let self = self else { return }
                guard let contentViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: PopupCheckInViewController.getStoryboardID()) as? PopupCheckInViewController else { return }
                //contentViewController.doctorId = Int.getInt(obj.doctorInformation?.doctorID ?? 0)
                //contentViewController.bookingId = obj.id ?? 0
                contentViewController.checkInItem = .init(
                    id: obj.id,
                    doctorInformation: self.mapDoctorInformationOnGoingSearchToDoctorInformation(doctorInformationOnGoingSearch: obj.doctorInformation ?? .init()),
                    doctor: self.mapDoctorOnGoingSearchToDoctor(doctorOnGoingSearch: obj.doctor ?? .init())
                )
        
                let popupVC = PopupViewController(contentController: contentViewController, popupWidth: 320, popupHeight: 550)
                popupVC.backgroundAlpha = 0.3
                popupVC.backgroundColor = .black
                popupVC.canTapOutsideToDismiss = false
                popupVC.cornerRadius = 10
                popupVC.shadowEnabled = true
                self.present(popupVC, animated: true)
            }
            return cell
        case .past:
            let cell = tableView.dequeueReusableCell(withIdentifier: PastBookingTVC.identifier, for: indexPath) as! PastBookingTVC
            let obj = bookingDetails[indexPath.row]
            cell.labelCompleted.isHidden = true
            cell.labelBookingID.text = obj.id?.toString()
            cell.labelDoctorName.text = obj.doctor?.name

            //cell.labelDoctorSpeciality.text = obj.doctor_specialities[0]
            //cell.labelDoctorSpeciality.text = obj.doctorSpecialities![0].specialities
            cell.labelDoctorSpeciality.text = obj.doctorSpecialities?.specialities

            cell.labelRating.text = String(format : "%.1f", obj.ratings ?? 0.0)
            //cell.labelAddress.text = obj.doctorInformation?.doctorAddress
            //cell.labelFees.text = "$" + obj.fees!
            cell.labelFees.text = obj.hospital?.name ?? ""

            cell.labelTime.text = obj.doctor?.isAvailableToday ?? false ? "Available Today".localize : "Not Available Today".localize
            cell.labelExperience.text =  String.getString(obj.doctorInformation?.experience) + " years of exp.".localize
            cell.imageDoctor.downlodeImage(serviceurl: "https://hlthera-s3.s3-ap-southeast-2.amazonaws.com/user_profile/" + String.getString(obj.doctor?.profilePicture), placeHolder: UIImage(named: "placeholder"))

            switch String.getString(obj.doctorServiceFee?.commServiceType){
            case "video":
                cell.imageServiceIcon.image = UIImage(named: "video_call_sm")

            case "home":
                cell.imageServiceIcon.image = UIImage(named: "home")

            case "chat":
                cell.imageServiceIcon.image = UIImage(named: "chat_sm")

            case "audio":
                cell.imageServiceIcon.image = UIImage(named: "call_sm")

            case "visit":
                cell.imageServiceIcon.image = UIImage(named: "home_visit_sm")

            default:break

            }
            cell.callbackFullDetails = { [weak self] in
                guard let self = self else { return }
                guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: BookingFullDetailsVC.getStoryboardID()) as? BookingFullDetailsVC else { return }
                vc.data = obj
                vc.hasCameFrom = .past
                self.navigationController?.pushViewController(vc, animated: true)

            }
            cell.callbackPrebooking = {
                globalApis.getDoctorDetails(doctorId: obj.doctorID!, communicationServiceId: String.getString(obj.doctorServiceFee?.id), slotId: String.getString(obj.slotID)){ data in
                    guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: ViewDoctorProfileVC.getStoryboardID()) as? ViewDoctorProfileVC else { return }
                    vc.searchResult = data
                    UserData.shared.hospital_id = ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            cell.callbackReview = {
                guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: GiveRatingVC.getStoryboardID()) as? GiveRatingVC else { return }
                UserData.shared.hospital_id = ""
                vc.data = obj
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        case .cancelled:
            let cell = tableView.dequeueReusableCell(withIdentifier: CancelledBookingTVC.identifier, for: indexPath) as! CancelledBookingTVC
            let obj = bookingDetails[indexPath.row]
            cell.labelCancelled.isHidden = true
            cell.labelBookingID.text = obj.id?.toString()
            cell.labelDoctorName.text = obj.doctor?.name

            //cell.labelDoctorSpeciality.text = obj.doctor_specialities[0]
            //            cell.labelDoctorSpeciality.text = obj.doctorSpecialities![0].specialities
            cell.labelDoctorSpeciality.text = obj.doctorSpecialities?.specialities

            cell.labelRating.text = String(format : "%.1f", obj.ratings ?? 0.0)
            //            cell.labelAddress.text = obj.doctorInformation?.doctorAddress
            //cell.labelFees.text = "$" + obj.fees!
            cell.labelFees.text = obj.hospital?.name ?? ""

            cell.labelTime.text = obj.doctor?.isAvailableToday ?? false ? "Available Today".localize : "Not Available Today".localize
            cell.labelExperience.text =  String.getString(obj.doctorInformation?.experience) + " years of exp.".localize
            cell.imageDoctor.downlodeImage(serviceurl: "https://hlthera-s3.s3-ap-southeast-2.amazonaws.com/user_profile/" + String.getString(obj.doctor?.profilePicture), placeHolder: UIImage(named: "placeholder"))

            switch String.getString(obj.doctorServiceFee?.commServiceType){
            case "video":
                cell.imageServiceIcon.image = UIImage(named: "video_call_sm")

            case "home":
                cell.imageServiceIcon.image = UIImage(named: "home")

            case "chat":
                cell.imageServiceIcon.image = UIImage(named: "chat_sm")

            case "audio":
                cell.imageServiceIcon.image = UIImage(named: "call_sm")

            case "visit":
                cell.imageServiceIcon.image = UIImage(named: "home_visit_sm")

            default:break

            }
            cell.callbackFullDetails = {
                guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: BookingFullDetailsVC.getStoryboardID()) as? BookingFullDetailsVC else { return }
                vc.data = obj
                vc.hasCameFrom = .cancelled
                self.navigationController?.pushViewController(vc, animated: true)

            }
            cell.callbackBookAgain = {
                globalApis.getDoctorDetails(doctorId: obj.doctorID!, communicationServiceId: String.getString(obj.doctorServiceFee?.id), slotId: String.getString(obj.slotID)){ data in
                    guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: ViewDoctorProfileVC.getStoryboardID()) as? ViewDoctorProfileVC else { return }
                    vc.searchResult = data
                    UserData.shared.hospital_id = ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }

            }
            return cell
        default:return UITableViewCell()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch hasCameFrom {
        case .ongoing:
            return 260
        case .scheduled:
            return 330
        case .past:
            return 260
        case .cancelled:
            return 260
        default :
            return UITableView.automaticDimension
        }
    }
}

extension MyDoctorsVC{
    func getListing(type:HasCameFrom){
        CommonUtils.showHudWithNoInteraction(show: true)
        var cType = 0
        switch hasCameFrom {
        case .scheduled:
            cType = 0 // scheduled
        case .ongoing:
            cType = 1 // to be filtered manually
        case .past:
            cType = 2 // completed
        case .cancelled:
            cType = 3 // cancelled
        default: break
        }
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
                    self?.internetTime = String.getString(dictResult["timestamp"])
                    if Int.getInt(dictResult["status"]) == 0{
                        var model:DataResponeOnGoingSearch?
                        let convertDicToJsonString =  try? JSONSerialization.data(withJSONObject: dictResult, options: [.prettyPrinted])
                        let jsonString = String(data: convertDicToJsonString!, encoding: .utf8)!
                        let jsonStringToData = Data(jsonString.utf8)
                        let decoder = JSONDecoder()
                        do {
                            model = try decoder.decode(DataResponeOnGoingSearch.self, from: jsonStringToData)
                        } catch {
                            //                            print("localizedDescription \(error.localizedDescription)")
                            print(String(describing: error)) // <- ✅ Use this for debuging!
                        }
                        self?.bookingDetails = model?.result ?? []
                        //                            if cType == 0 && type == HasCameFrom.ongoing{
                        //                                let data = self?.bookingDetails
                        //                                if let obj = data{
                        //                                    self?.bookingDetails = obj.filter{
                        //                                        Double.getDouble(self?.getDateFromString(dateString: String.getString($0.doctorSlotInformation?.date), timeString: String.getString($0.doctorSlotInformation?.slotTime)).millisecondsSince1970) <= Double.getDouble(self?.internetTime) * 1000 && Double.getDouble(self?.internetTime) * 1000 <= Double.getDouble(self?.getDateFromString(dateString: String.getString($0.doctorSlotInformation?.date), timeString: String.getString($0.doctorSlotInformation?.slotTime)).millisecondsSince1970) + 3600000
                        //                                    }
                        //                                }
                        //                            }
                        
                        print(self?.bookingDetails)
                        self?.tableView.reloadData()
                        
                        
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
}

extension UIViewController{
    func getDateFromString(dateString:String,timeString:String)->Date{
        let dateFormatter = DateFormatter()
        //2021-01-19
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd HH:mm"
        let date = dateFormatter.date(from:"\(dateString) \(timeString)") ?? Date()
        return date
    }
    func getDateFromCreatedAtString(dateString:String)->Date{
        let dateFormatter = DateFormatter()
        //2021-01-19 021-01-19 13:10:42
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd HH:mm:ss"
        let date = dateFormatter.date(from:dateString) ?? Date()
        return date
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

class HltheraSegment: UISegmentedControl {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.borderWidth = 0
        layer.backgroundColor = UIColor.white.cgColor
        layer.masksToBounds = true
        
        
        // self.selectedSegmentTintColor = UIColor(named: "5")
        
        //        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Medium", size: 12)],
        //                                                    for: .selected)
        //        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(named: "MainColor"),NSAttributedString.Key.font: UIFont(name: "SF Display Pro Regular", size: 12)],
        //                                                    for: .normal)
        
    }
}

