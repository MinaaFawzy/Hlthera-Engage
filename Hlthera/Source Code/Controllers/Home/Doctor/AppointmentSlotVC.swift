//
//  AppointmentSlotVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 11/01/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class AppointmentSlotVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak private var labelPageTitle: UILabel!
    @IBOutlet weak private var constraintEveningSlotHeight: NSLayoutConstraint!
    @IBOutlet weak private var collectionViewEveningSlots: UICollectionView!
    @IBOutlet weak private var labelEveningSlotsCount: UILabel!
    @IBOutlet weak private var constraintAfternoonHeight: NSLayoutConstraint!
    @IBOutlet weak private var constraintMorningSlotsHeight: NSLayoutConstraint!
    @IBOutlet weak private var labelAfternoonSlotsCount: UILabel!
    @IBOutlet weak private var collectionVIewAfternoonSlot: UICollectionView!
    @IBOutlet weak private var collectionViewMorningSlot: UICollectionView!
    @IBOutlet weak private var collectionViewDate: UICollectionView!
    @IBOutlet weak private var labelTimeSlots: UILabel!
    @IBOutlet weak private var lblChoosDate: UILabel!
    @IBOutlet weak private var lblChooseSutableTime: UILabel!
    
    // MARK: - Stored properties
    var selectedWeek = -1
    var slots: [Slot] = []
    var selectedDate = -1
    var selectedSlot: Afternoon?
    var callback: ((String, String, String) -> ())?
    var pageTitle = "Appointment (slot)".localize
    var hasCameFrom: HasCameFrom?
    var bookingDetails:[ResultOnGoingSearch] = []
    var myBooking: ResultOnGoingSearch?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        lblChoosDate.font = .corbenRegular(ofSize: 16)
//        lblChooseSutableTime.font = .corbenRegular(ofSize: 16)
//        labelPageTitle.font = .corbenRegular(ofSize: 15)
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        labelPageTitle.text = pageTitle
        labelTimeSlots.text = "Select Date".localize
        labelAfternoonSlotsCount.text = "Select Date".localize
        labelEveningSlotsCount.text = "Select Date".localize
    }
    
    func dayToName(weekDay: Int) -> String {
        switch weekDay {
        case 1:
            return "Sun".localize
        case 2:
            return "Mon".localize
        case 3:
            return "Tue".localize
        case 4:
            return "Wed".localize
        case 5:
            return "Thu".localize
        case 6:
            return "Fri".localize
        case 7:
            return "Sat".localize
        default: return ""
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    @IBAction private func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func buttonConfirmTapped(_ sender: Any) {
        self.callback?("\(self.selectedSlot?.id ?? 0)", (String.getString(self.selectedSlot?.id) == "" ? ("") : (self.slots[self.selectedDate].dates)) ,
                  String(self.selectedSlot?.time?.split(separator: " ")[0] ?? "")
        )
//        self.getListing()
//        for item in bookingDetails {
//            if String.getString(selectedSlot?.id) == item.slotID {
//                myBooking = item
//            }
//        }
//        guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: BookingFullDetailsVC.getStoryboardID()) as? BookingFullDetailsVC else { return }
//        vc.data = myBooking

//        kSharedAppDelegate?.moveToHomeScreen(index: 1)
    }
    
}

// MARK: - UICollectionView Delegate & DataSource
extension AppointmentSlotVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionViewDate {
            return slots.count
        } else if collectionView == collectionViewMorningSlot {
            if slots.indices.contains(selectedDate) {
                return slots[selectedDate].morning?.count ?? 0
            } else {
                return 0
            }
        } else if collectionView == collectionVIewAfternoonSlot {
            if slots.indices.contains(selectedDate) {
                return slots[selectedDate].afternoon?.count ?? 0
            } else {
                return 0
            }
        } else {
            if slots.indices.contains(selectedDate) {
                return slots[selectedDate].evening?.count ?? 0
            } else {
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterDoctorWeekDaysCVC", for: indexPath) as! FilterDoctorWeekDaysCVC
        
        if collectionView == collectionViewDate{
            let obj = slots[indexPath.row]
            let dateFormatter = DateFormatter()
            //2021-01-19
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
            let date = dateFormatter.date(from: obj.dates ?? "")
            cell.labelDate.text = String.getString(date?.day)
            cell.labelWeekDay.text = dayToName(weekDay: Int.getInt(date?.weekday))
            cell.viewWeek.borderColor = .clear
            cell.viewWeek.shadowColor = .clear
            if indexPath.row == selectedWeek{
                cell.viewWeek.backgroundColor = #colorLiteral(red: 0.8274509804, green: 0.9137254902, blue: 1, alpha: 1)
//                cell.viewWeek.borderColor = #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1)
            }
            else {
                cell.viewWeek.backgroundColor = UIColor(red: 245, green: 247, blue: 249)
//                cell.viewWeek.borderColor = #colorLiteral(red: 0.9254901961, green: 0.9333333333, blue: 0.9450980392, alpha: 1)
            }
            
        } else if collectionView == collectionViewMorningSlot{
            let obj = slots[selectedDate].morning?[indexPath.row]
            let times = obj?.time?.split(separator: " ")
            cell.labelDate.text = String(times?[1] ?? "")
            cell.labelWeekDay.text = String(times?[0] ?? "")
            if obj?.available == 1 {
                cell.labelDate.textColor = #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1)
                cell.labelWeekDay.textColor = #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1)
            } else {
                cell.labelDate.textColor = #colorLiteral(red: 0.5294117647, green: 0.5803921569, blue: 0.6666666667, alpha: 1)
                cell.labelWeekDay.textColor = #colorLiteral(red: 0.5294117647, green: 0.5803921569, blue: 0.6666666667, alpha: 1)
            }
            if selectedSlot?.id == obj?.id {
                cell.viewWeek.backgroundColor = #colorLiteral(red: 0.8274509804, green: 0.9137254902, blue: 1, alpha: 1)
//                cell.viewWeek.borderColor = #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1)
            } else {
                cell.viewWeek.backgroundColor = UIColor(red: 245, green: 247, blue: 249)
//                cell.viewWeek.borderColor =
            }
            constraintMorningSlotsHeight.constant = collectionViewMorningSlot.contentSize.height
        } else if collectionView == collectionVIewAfternoonSlot {
            let obj = slots[selectedDate].afternoon?[indexPath.row]
            let times = obj?.time?.split(separator: " ")
            cell.labelDate.text = String(times?[1] ?? "")
            cell.labelWeekDay.text = String(times?[0] ?? "")
            if obj?.available == 1 {
                cell.labelDate.textColor = #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1)
                cell.labelWeekDay.textColor = #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1)
            } else {
                cell.labelDate.textColor = #colorLiteral(red: 0.5294117647, green: 0.5803921569, blue: 0.6666666667, alpha: 1)
                cell.labelWeekDay.textColor = #colorLiteral(red: 0.5294117647, green: 0.5803921569, blue: 0.6666666667, alpha: 1)
            }
            if selectedSlot?.id == obj?.id {
                cell.viewWeek.backgroundColor = #colorLiteral(red: 0.8274509804, green: 0.9137254902, blue: 1, alpha: 1)
//                cell.viewWeek.borderColor = #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1)
            }
            else {
                cell.viewWeek.backgroundColor = UIColor(red: 245, green: 247, blue: 249)
//                cell.viewWeek.borderColor = #colorLiteral(red: 0.9254901961, green: 0.9333333333, blue: 0.9450980392, alpha: 1)
            }
            constraintAfternoonHeight.constant = collectionVIewAfternoonSlot.contentSize.height
        } else {
            let obj = slots[selectedDate].evening?[indexPath.row]
            let times = obj?.time?.split(separator: " ")
            cell.labelDate.text = String(times?[1] ?? "")
            cell.labelWeekDay.text = String(times?[0] ?? "")
            if obj?.available == 1 {
                cell.labelDate.textColor = #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1)
                cell.labelWeekDay.textColor = #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1)
            } else {
                cell.labelDate.textColor = #colorLiteral(red: 0.5294117647, green: 0.5803921569, blue: 0.6666666667, alpha: 1)
                cell.labelWeekDay.textColor = #colorLiteral(red: 0.5294117647, green: 0.5803921569, blue: 0.6666666667, alpha: 1)
            }
            if selectedSlot?.id == obj?.id {
                cell.viewWeek.backgroundColor = #colorLiteral(red: 0.8274509804, green: 0.9137254902, blue: 1, alpha: 1)
//                cell.viewWeek.borderColor = #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1)
            } else {
                cell.viewWeek.backgroundColor = UIColor(red: 245, green: 247, blue: 249)
//                cell.viewWeek.borderColor = #colorLiteral(red: 0.9254901961, green: 0.9333333333, blue: 0.9450980392, alpha: 1)
            }
            constraintEveningSlotHeight.constant = collectionViewEveningSlots.contentSize.height
        }
        return cell
    }
    func setupcollections() {
//        collectionViewMorningSlot.borderColor1 = .lightGray
//        collectionViewMorningSlot.borderWidth1 = 1
        collectionViewMorningSlot.cornerRadius1 = 15
        
//        collectionVIewAfternoonSlot.borderColor1 = .lightGray
//        collectionVIewAfternoonSlot.borderWidth1 = 1
        collectionVIewAfternoonSlot.cornerRadius1 = 15
        
//        collectionViewEveningSlots.borderColor1 = .lightGray
//        collectionViewEveningSlots.borderWidth1 = 1
        collectionViewEveningSlots.cornerRadius1 = 15
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewDate{
            setupcollections()
            selectedWeek = indexPath.row
            selectedDate = indexPath.row
            self.labelTimeSlots.text = "\(slots[selectedDate].morning?.count ?? 0) Slots"
            self.labelAfternoonSlotsCount.text = "\(slots[selectedDate].afternoon?.count ?? 0)" + "Slots".localize
            self.labelEveningSlotsCount.text = "\(slots[selectedDate].evening?.count ?? 0)" + "Slots".localize
        }
        if collectionView == collectionViewMorningSlot {
            if slots.indices.contains(selectedDate) {
                if slots[selectedDate].morning?[indexPath.row].available == 1 {
                    selectedSlot = slots[selectedDate].morning?[indexPath.row]
                } else {
                    CommonUtils.showToast(message: "Slot Unavailable".localize)
                    return
                }
            }
        }
        if collectionView == collectionVIewAfternoonSlot {
            if slots.indices.contains(selectedDate) {
                if slots[selectedDate].afternoon?[indexPath.row].available == 1 {
                    selectedSlot = slots[selectedDate].afternoon?[indexPath.row]
                } else {
                    CommonUtils.showToast(message: "Slot Unavailable".localize)
                    return
                }
            }
        }
        if collectionView == collectionViewEveningSlots {
            if slots.indices.contains(selectedDate) {
                if slots[selectedDate].evening?[indexPath.row].available == 1 {
                    selectedSlot = slots[selectedDate].evening?[indexPath.row]
                } else {
                    CommonUtils.showToast(message: "Slot Unavailable".localize)
                    return
                }
            }
        }
        collectionViewDate.reloadData()
        collectionViewMorningSlot.reloadData()
        collectionVIewAfternoonSlot.reloadData()
        collectionViewEveningSlots.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewDate {
            return CGSize(width: 65, height: 75)
        } else {
            return CGSize(width: collectionViewMorningSlot.frame.width/4.15, height: 60)
        }
    }
}

extension AppointmentSlotVC {
    func getListing(){
        CommonUtils.showHudWithNoInteraction(show: true)
        var cType = 0
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
                        print(self?.bookingDetails)
                        guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: BookingFullDetailsVC.getStoryboardID()) as? BookingFullDetailsVC else { return }
                        vc.data = self?.bookingDetails[0]
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
