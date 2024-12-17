//
//  CheckInViewController.swift
//  Hlthera
//
//  Created by Ahmed Hegazy on 06/01/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit
//import SwiftyJSON
//import MotionToastView
import EzPopup

@available(iOS 15.0, *)
class CheckInsListViewController: UIViewController {
    
    @IBOutlet weak var viewWriteMessage: UIView!
    @IBOutlet weak var btnHiDoctorIamCheckingIn: UIButton!
    @IBOutlet weak var imgHiDoctorIamCheckingIn: UIImageView!
    @IBOutlet weak var lblHiDoctorIamCheckingIn: UILabel!
    @IBOutlet weak var btnWriteAMessage: UIButton!
    @IBOutlet weak var imgWriteAMessage: UIImageView!
    @IBOutlet weak var lblWriteAMessage: UILabel!
    var passedDoctorIdFromMyBooking:String = "1"
    var hasCameFrom: HasCameFrom = .CheckInScheduled
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tfMessage: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var stackViewNavigation: UIStackView!
    var navigationTabsNames = ["Scheduled", "Previous"]
    var allCheckinsList: [CheckInItem] = []
    
    var currentPageScheduled = 1
    var currentPagePrev = 1
    
    
    var selectedTab = 0 {
        didSet{
            switch hasCameFrom{
            case .CheckInScheduled:
                self.tableView.register(UINib(nibName: ScheduledCheckInTVC.identifier, bundle: nil), forCellReuseIdentifier: ScheduledCheckInTVC.identifier)
            case .CheckInPrev:
                self.tableView.register(UINib(nibName: PrevCheckinTVC.identifier, bundle: nil), forCellReuseIdentifier: PrevCheckinTVC.identifier)
                //            case .past:
                //                self.tableView.register(UINib(nibName: PastBookingTVC.identifier, bundle: nil), forCellReuseIdentifier: PastBookingTVC.identifier)
                //            case .cancelled:
                //                self.tableView.register(UINib(nibName: CancelledBookingTVC.identifier, bundle: nil), forCellReuseIdentifier: CancelledBookingTVC.identifier)
            default:break
            }
            getListing(type: hasCameFrom)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        lblTitle.font = .corbenRegular(ofSize: 15)
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        //viewWriteMessage.isHidden = true;
        self.selectedTab = 0
        setupNavigation()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHiDoctorIamCheckingInTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if btnHiDoctorIamCheckingIn.isSelected{
            self.btnWriteAMessage.isSelected = false
            self.imgHiDoctorIamCheckingIn.image = #imageLiteral(resourceName: "radio_active")
            self.lblHiDoctorIamCheckingIn.textColor = #colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)
            self.imgWriteAMessage.image = #imageLiteral(resourceName: "radio")
            self.lblWriteAMessage.textColor = #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1)
            //            self.gender = "1"
            viewWriteMessage.isHidden = true;
        }
    }
    
    @IBAction func btnWriteAMessageTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if btnWriteAMessage.isSelected{
            self.btnHiDoctorIamCheckingIn.isSelected = false
            self.imgWriteAMessage.image = #imageLiteral(resourceName: "radio_active")
            self.lblWriteAMessage.textColor = #colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)
            self.imgHiDoctorIamCheckingIn.image = #imageLiteral(resourceName: "radio")
            self.lblHiDoctorIamCheckingIn.textColor = #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1)
            //self.gender = "2"
            viewWriteMessage.isHidden = false;
        }
    }
    
    
    //    @IBAction func btnCheckInTapped(_ sender: UIButton) {
    //        var message  = ""
    //        var doctorId = passedDoctorIdFromMyBooking
    //        if(viewWriteMessage.isHidden == false){
    //            if String.getString(tfMessage.text).isEmpty{
    ////                showAlertMessage.alert(message: "Please Enter Message")
    //                CommonUtils.showToast(message: "Please Enter Message")
    //                return
    //            }
    //             message  = tfMessage?.text ?? ""
    //        }else{
    //            message  = "Hi Doctor! I’m Checking in"
    //        }
    //
    //        checkInRequest(doctorId: passedDoctorIdFromMyBooking, message: message ?? "")
    //
    //    }
    //
    @IBAction func buttonsNavigationTapped(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            setupNavigation(selectedIndex: sender.tag)
            self.hasCameFrom = .CheckInScheduled
        case 1:
            setupNavigation(selectedIndex: sender.tag)
            self.hasCameFrom = .CheckInPrev
            //        case 2:
            //            setupNavigation(selectedIndex: sender.tag)
            //            self.hasCameFrom = .past
            //        case 3:
            //            setupNavigation(selectedIndex: sender.tag)
            //            self.hasCameFrom = .cancelled
        default: break
        }
        
        self.selectedTab = sender.tag
        //self.collectionView.reloadData()
    }
    
    func setupNavigation(selectedIndex: Int = 0) {
        
        for (index,view) in self.stackViewNavigation.arrangedSubviews.enumerated(){
            for btn in view.subviews{
                if let button  = btn as? UIButton{
                    button.setTitleColor(selectedIndex == index ? (#colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)) : (#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1)), for: .normal)
                    button.titleLabel?.font = selectedIndex == index ? (UIFont(name: "SFProDisplay-Bold", size: 15)) : (UIFont(name: "SFProDisplay-Medium", size: 15))
                    button.adjustsImageWhenDisabled = false
                    button.adjustsImageWhenHighlighted = false
                } else {
                    btn.isHidden = index == selectedIndex ? (false) : (true)
                    btn.backgroundColor = index == selectedIndex ? (#colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)) : (#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1))
                    
                }
            }
        }
    }
    
}

@available(iOS 15.0, *)
extension CheckInsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.numberOfRow(numberofRow: allCheckinsList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch hasCameFrom{
        case .CheckInScheduled:
            let cell = tableView.dequeueReusableCell(withIdentifier: ScheduledCheckInTVC.identifier, for: indexPath) as! ScheduledCheckInTVC
            let obj = allCheckinsList[indexPath.row]
            //            cell.labelInProcess.isHidden = true
            cell.labelBookingID.text = String.getString(obj.id)
            cell.labelDoctorName.text = obj.doctor?.name?.localize
            //            cell.labelDoctorSpeciality.text = obj.doctor_specialities[0]
            //cell.labelr.text = "4.5"
            //            let slotTime =   self.getDateFromString(dateString: String.getString(obj.doctor_slot_information?.date), timeString: String.getString(obj.doctor_slot_information?.slot_time)).timeIntervalSince1970
            //            let currentTime = Date(milliseconds: Int64(Double.getDouble(self.internetTime)) * 1000).timeIntervalSince1970
            //            let diff = Int(currentTime - slotTime)
            //
            //            let hours = diff / 3600
            //            let minutes = (diff - hours * 3600) / 60
            //            let timeLeft = 60 - minutes
            //let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(Int(timeLeft ?? 0)), repeats: true) { timer in
            print("Timer fired!")
            // cell.labelTime
            
            //  }
            //          cell.labelTimeLeft.text = String.getString(timeLeft) + " mins left"
            //            cell.labelDoctorAddress.text = obj.doctor_information?.doctor_address
            //            cell.labelDoctorFees.text = "$" + obj.fees
            //            cell.labelTime.text = obj.doctor?.is_available_today ?? false ? "Available Today" : "Not Available Today"
            cell.labelTime.text = obj.date
            //            cell.labelExperience.text =  String.getString(obj.doctor_information?.experience) + " years of exp."
            cell.imageDoctor.downlodeImage(serviceurl: "https://hlthera-s3.s3-ap-southeast-2.amazonaws.com/" + String.getString(obj.doctor?.profilePicture), placeHolder: UIImage(named: "placeholder"))
            
            //            switch String.getString(obj.doctor_service_fee?.comm_service_type){
            //            case "video":
            //                cell.imageServiceIcon.image = UIImage(named: "video_call_sm")
            //
            //            case "home":
            //                cell.imageServiceIcon.image = UIImage(named: "home")
            //
            //            case "chat":
            //                cell.imageServiceIcon.image = UIImage(named: "chat_sm")
            //
            //            case "audio":
            //                cell.imageServiceIcon.image = UIImage(named: "call_sm")
            //
            //            case "visit":
            //                cell.imageServiceIcon.image = UIImage(named: "home_visit_sm")
            //
            //            default:break
            //
            //            }
            cell.callbackChat = {
                guard let contentViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: ChatCheckInViewController.getStoryboardID()) as? ChatCheckInViewController else { return }
                contentViewController.checkInItem = obj
                self.navigationController?.pushViewController(contentViewController, animated: true)
                
            }
            cell.callbackCheckIn = {
                guard let contentViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: PopupCheckInViewController.getStoryboardID()) as? PopupCheckInViewController else { return }
                //                contentViewController.doctorId = Int.getInt(obj.doctorInformation?.doctorID ?? 0)
                //                contentViewController.bookingId = obj.id ?? 0
                contentViewController.checkInItem = obj
                let popupVC = PopupViewController(contentController: contentViewController, popupWidth: 320, popupHeight: 600)
                popupVC.backgroundAlpha = 0.3
                popupVC.backgroundColor = .black
                popupVC.canTapOutsideToDismiss = false
                popupVC.cornerRadius = 10
                popupVC.shadowEnabled = true
                self.present(popupVC, animated: true)
            }
            return cell
        case .CheckInPrev:
            let cell = tableView.dequeueReusableCell(withIdentifier: PrevCheckinTVC.identifier, for: indexPath) as! PrevCheckinTVC
            let obj = allCheckinsList[indexPath.row]
            //            if Int.getInt(obj.status) == 4{
            //                cell.buttonReschedule.isHidden = true
            //                cell.buttonConfirm.isUserInteractionEnabled = false
            //                cell.buttonConfirm.setTitle("Confirmed", for: .normal)
            //                cell.labelCancelled.text = "Confirmed"
            //                cell.labelCancelled.textColor = .green
            //                cell.labelCancelled.isHidden = true
            //
            //            }else{
            //                cell.buttonReschedule.isHidden = false
            //                cell.buttonConfirm.isUserInteractionEnabled = true
            //                cell.buttonConfirm.setTitle("Confirm", for: .normal)
            //                cell.labelCancelled.isHidden = true
            //            }
            //
            cell.labelBookingID.text = String.getString(obj.id)
            cell.labelDoctorName.text = obj.doctor?.name
            //            cell.labelDoctorSpeciality.text = obj.doctor_specialities[0]
            //            cell.labelRating.text = "4.5"
            
            //            cell.labelAddress.text = obj.doctor_information?.doctor_address
            //            cell.labelFees.text = "$" + obj.fees
            //            cell.labelTime.text = obj.doctor?.isAvailableToday ?? false ? "Available Today" : "Not Available Today"
            cell.labelTime.text = obj.date
            //            cell.labelExperience.text =  String.getString(obj.doctor_information?.experience) + " years of exp."
            cell.imageDoctor.downlodeImage(serviceurl: "https://hlthera-s3.s3-ap-southeast-2.amazonaws.com/" + String.getString(obj.doctor?.profilePicture), placeHolder: UIImage(named: "placeholder"))
            //            switch String.getString(obj.doctor_service_fee?.comm_service_type){
            //            case "video":
            //                cell.imageServiceIcon.image = UIImage(named: ServiceIconIdentifiers.video)
            //
            //            case "home":
            //                cell.imageServiceIcon.image = UIImage(named: ServiceIconIdentifiers.home)
            //
            //            case "chat":
            //                cell.imageServiceIcon.image = UIImage(named: ServiceIconIdentifiers.chat)
            //
            //            case "audio":
            //                cell.imageServiceIcon.image = UIImage(named: ServiceIconIdentifiers.audio)
            //
            //            case "visit":
            //                cell.imageServiceIcon.image = UIImage(named: ServiceIconIdentifiers.clinic)
            //
            //            default:break
            //
            //            }
            //
            
            cell.callbackChat = {
                guard let contentViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: ChatCheckInViewController.getStoryboardID()) as? ChatCheckInViewController else { return }
                contentViewController.checkInItem = obj
                self.navigationController?.pushViewController(contentViewController, animated: true)
                
                
            }
            cell.callbackCheckIn = {
                guard let contentViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: PopupCheckInViewController.getStoryboardID()) as? PopupCheckInViewController else { return }
                //                contentViewController.doctorId = Int.getInt(obj.doctorInformation?.doctorID ?? 0)
                //                contentViewController.bookingId = obj.id ?? 0
                contentViewController.checkInItem = obj
                let popupVC = PopupViewController(contentController: contentViewController, popupWidth: 320, popupHeight: 600)
                popupVC.backgroundAlpha = 0.3
                popupVC.backgroundColor = .black
                popupVC.canTapOutsideToDismiss = false
                popupVC.cornerRadius = 10
                popupVC.shadowEnabled = true
                self.present(popupVC, animated: true)
            }
            
            return cell
            
            
        default:return UITableViewCell()
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return UITableView.automaticDimension
        return 250
    }
    
    
}
@available(iOS 15.0, *)
extension CheckInsListViewController{
    func getListing(type:HasCameFrom,
                    page: Int = 0, limit: Int = 20
    ){
        CommonUtils.showHudWithNoInteraction(show: true)
        var page = 0
        var filter_by = 0
        
        switch hasCameFrom{
        case .CheckInScheduled:
            page = currentPageScheduled
            filter_by = 1
        case .CheckInPrev:
            page = currentPagePrev
            filter_by = 0
        default:break
        }
        let params:[String : Any] = [ApiParameters.page:String.getString(page),
                                     ApiParameters.filter_by:String.getString(filter_by),
                                     
                                     ApiParameters.limit:String.getString(limit),]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.getMyCheckins,                                                   requestMethod: .GET,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                //                print(result)
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    
                    var model:GetAllCheckinsModel?
                    let convertDicToJsonString =  try? JSONSerialization.data(withJSONObject: dictResult, options: [.prettyPrinted])
                    let jsonString = String(data: convertDicToJsonString!, encoding: .utf8)!
                    let jsonStringToData = Data(jsonString.utf8)
                    let decoder = JSONDecoder()
                    do {
                        model = try decoder.decode(GetAllCheckinsModel.self, from: jsonStringToData)
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    if model?.status == 1{
                        
                        self?.allCheckinsList = model?.result?.data ?? []
                        
                        
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
