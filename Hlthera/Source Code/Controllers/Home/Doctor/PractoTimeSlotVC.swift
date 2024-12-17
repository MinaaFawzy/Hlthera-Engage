//
//  PractoTimeSlotVC.swift
//  Hlthera
//
//  Created by Ahmed Hegazy on 13/01/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit

class PractoTimeSlotVC: UIViewController {
    
    @IBOutlet weak var lblChoosDate: UILabel!
    @IBOutlet weak var lblChooseSutableTime: UILabel!
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var labelTimeSlots: UILabel!
    @IBOutlet weak var collectionViewMorningSlot: UICollectionView!
    @IBOutlet weak var collectionViewDate: UICollectionView!
    
    var selectedTime = 0
    var slots:[SlotTimeDateItem] = []
    var selectedDate = -1
    var selectedSlot:SingleSlotModel?
    var callback:((String,String,String)->())?
    var pageTitle = "Appointment (slot)".localize
    var hasCameFrom:HasCameFrom?
    var dates:[String] = []
    var times:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblChoosDate.font = .corbenRegular(ofSize: 16)
        lblChooseSutableTime.font = .corbenRegular(ofSize: 16)
        labelPageTitle.font = .corbenRegular(ofSize: 15)
        
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        self.labelPageTitle.text = pageTitle
        
        
        slots.forEach { item in
            if (!dates.contains(item.date)){
                dates.append(item.date)
            }
        }
        //        if !dates.isEmpty {
        //            let firstDate  = dates[0]
        //            slots.forEach { item in
        //                if (firstDate == item.date){
        //                    times.append(item.time)
        //                }
        //            }
        //        }
        //
        //        collectionViewDate.reloadData()
        //        collectionViewMorningSlot.reloadData()
        //
    }
    
    func dayToName(weekDay:Int)->String{
        switch weekDay{
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
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonConfirmTapped(_ sender: Any) {
        //        callback?(
        //            selectedSlot?.id ?? "",
        //            String.getString(selectedSlot?.id) == "" ? (""): (slots[selectedDate].dates),
        //            String(selectedSlot?.time.split(separator: " ")[0] ?? ""))
        callback?(
            "id",
            dates[selectedDate],
            times[selectedTime])
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
}


extension PractoTimeSlotVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionViewDate{
            return dates.count
        }
        else if collectionView == collectionViewMorningSlot{
            return times.count
        }
        //        else if collectionView == collectionVIewAfternoonSlot{
        //            if slots.indices.contains(selectedDate){
        //                return slots[selectedDate].afternoon.count
        //            }
        //            else {
        //                return 0
        //            }
        //        }
        //        else {
        //            if slots.indices.contains(selectedDate){
        //                return slots[selectedDate].evening.count
        //            }
        else {
            return 0
        }
        //        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterDoctorWeekDaysCVC", for: indexPath) as! FilterDoctorWeekDaysCVC
        
        if collectionView == collectionViewDate{
            let obj = dates[indexPath.row]
            let dateFormatter = DateFormatter()
            //2021-01-19
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from:obj)
            cell.labelDate.text = String.getString(date?.day)
            cell.labelWeekDay.text = dayToName(weekDay: Int.getInt(date?.weekday))
            
            if indexPath.row == selectedDate{
                cell.viewWeek.backgroundColor = #colorLiteral(red: 0.8274509804, green: 0.9137254902, blue: 1, alpha: 1)
                cell.viewWeek.borderColor = #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1)
            }
            else {
                cell.viewWeek.backgroundColor = UIColor.white
                cell.viewWeek.borderColor = #colorLiteral(red: 0.9254901961, green: 0.9333333333, blue: 0.9450980392, alpha: 1)
            }
            
        }
        else if collectionView == collectionViewMorningSlot{
            let obj = times[indexPath.row]
            let selectedDate = dates[selectedDate]
            let dateFormatter = DateFormatter()
            //2021-01-19
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from:selectedDate)
            //            let times = obj.time.split(separator: " ")
            cell.labelDate.text = obj
            //            cell.labelDate.text = String(times[1])
            cell.labelWeekDay.text = dayToName(weekDay: Int.getInt(date?.weekday))
            //            if obj.available{
            //                cell.labelDate.textColor = #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1)
            //                cell.labelWeekDay.textColor = #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1)
            //            }
            //            else {
            //                cell.labelDate.textColor = #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1)
            //                cell.labelWeekDay.textColor = #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1)
            //            }
            if !times.isEmpty {
                
                if times[selectedTime] == obj{
                    cell.viewWeek.backgroundColor = #colorLiteral(red: 0.8274509804, green: 0.9137254902, blue: 1, alpha: 1)
                    cell.viewWeek.borderColor = #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1)
                }
                else {
                    cell.viewWeek.backgroundColor = UIColor.white
                    cell.viewWeek.borderColor = #colorLiteral(red: 0.9254901961, green: 0.9333333333, blue: 0.9450980392, alpha: 1)
                }
            }
            //            constraintMorningSlotsHeight.constant = collectionViewMorningSlot.contentSize.height
        }
        //        else if collectionView == collectionVIewAfternoonSlot {
        //            let obj = slots[selectedDate].afternoon[indexPath.row]
        //            let times = obj.time.split(separator: " ")
        //            cell.labelDate.text = String(times[1])
        //            cell.labelWeekDay.text = String(times[0])
        //            if obj.available{
        //                cell.labelDate.textColor = #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1)
        //                cell.labelWeekDay.textColor = #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1)
        //            }
        //            else {
        //                cell.labelDate.textColor = #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1)
        //                cell.labelWeekDay.textColor = #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1)
        //            }
        //            if selectedSlot?.id == obj.id{
        //                cell.viewWeek.backgroundColor = #colorLiteral(red: 0.8274509804, green: 0.9137254902, blue: 1, alpha: 1)
        //                cell.viewWeek.borderColor = #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1)
        //            }
        //            else {
        //                cell.viewWeek.backgroundColor = UIColor.white
        //                cell.viewWeek.borderColor = #colorLiteral(red: 0.9254901961, green: 0.9333333333, blue: 0.9450980392, alpha: 1)
        //            }
        //            constraintAfternoonHeight.constant = collectionVIewAfternoonSlot.contentSize.height
        //        }
        //        else {
        //            let obj = slots[selectedDate].evening[indexPath.row]
        //            let times = obj.time.split(separator: " ")
        //            cell.labelDate.text = String(times[1])
        //            cell.labelWeekDay.text = String(times[0])
        //            if obj.available{
        //                cell.labelDate.textColor = #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1)
        //                cell.labelWeekDay.textColor = #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1)
        //            }
        //            else {
        //                cell.labelDate.textColor = #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1)
        //                cell.labelWeekDay.textColor = #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1)
        //            }
        //            if selectedSlot?.id == obj.id{
        //                cell.viewWeek.backgroundColor = #colorLiteral(red: 0.8274509804, green: 0.9137254902, blue: 1, alpha: 1)
        //                cell.viewWeek.borderColor = #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1)
        //            }
        //            else {
        //                cell.viewWeek.backgroundColor = UIColor.white
        //                cell.viewWeek.borderColor = #colorLiteral(red: 0.9254901961, green: 0.9333333333, blue: 0.9450980392, alpha: 1)
        //            }
        //            constraintEveningSlotHeight.constant = collectionViewEveningSlots.contentSize.height
        //        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewDate{
            selectedDate = indexPath.row
            times = []
            if !dates.isEmpty {
                let firstDate  = dates[indexPath.row]
                slots.forEach { item in
                    if (firstDate == item.date){
                        times.append(item.time)
                    }
                }
            }
            
            self.labelTimeSlots.text = "\(times.count)" + "Slots".localize
            //            self.labelAfternoonSlotsCount.text = "\(slots[selectedDate].afternoon.count) Slots"
            //            self.labelEveningSlotsCount.text = "\(slots[selectedDate].evening.count) Slots"
        }
        if collectionView == collectionViewMorningSlot{
            selectedTime = indexPath.row
            //            if slots.indices.contains(selectedDate){
            //                if slots[selectedDate].morning[indexPath.row].available{
            //                    selectedSlot = slots[selectedDate].morning[indexPath.row]
            //                }
            //                else {
            //                    CommonUtils.showToast(message: "Slot Unavailable")
            //                    return
            //                }
            //
            //            }
            //
        }
        //        if collectionView == collectionVIewAfternoonSlot{
        //            if slots.indices.contains(selectedDate){
        //                if slots[selectedDate].afternoon[indexPath.row].available{
        //                    selectedSlot = slots[selectedDate].afternoon[indexPath.row]
        //                }
        //                else {
        //                    CommonUtils.showToast(message: "Slot Unavailable")
        //                    return
        //                }
        //
        //            }
        //
        //        }
        //        if collectionView == collectionViewEveningSlots{
        //            if slots.indices.contains(selectedDate){
        //                if slots[selectedDate].evening[indexPath.row].available{
        //                    selectedSlot = slots[selectedDate].evening[indexPath.row]
        //                }
        //                else {
        //                    CommonUtils.showToast(message: "Slot Unavailable")
        //                    return
        //                }
        //
        //            }
        //
        //        }
        collectionViewDate.reloadData()
        collectionViewMorningSlot.reloadData()
        //        collectionVIewAfternoonSlot.reloadData()
        //        collectionViewEveningSlots.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewDate{
            return CGSize(width: 65, height: 75)
        }
        else {
            return CGSize(width: collectionViewMorningSlot.frame.width/4.15, height: 75)
        }
    }
    
    
}
