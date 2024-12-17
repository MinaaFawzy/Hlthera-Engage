//
//  AppointmentCancellationVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 06/02/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class AppointmentCancellationVC: UIViewController {
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textView: IQTextView!
    @IBOutlet weak var constraintCancelHeight: NSLayoutConstraint!
    @IBOutlet weak var viewMore: UIView!
    @IBOutlet weak var constraintViewMoreHieght: NSLayoutConstraint!
    var reasons:[CancellationReasonsModel] = []
    var selectedReason = -1
    
    ///var data:BookingDataModel?
    var data:ResultOnGoingSearch?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.font = .corbenRegular(ofSize: 15)
        
        getCancellationReasons()
        tableView.tableFooterView = UIView()
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        self.constraintViewMoreHieght.constant = 0
        self.viewMore.isHidden = true
        let date = getDateFromString(dateString: String.getString(data?.doctorSlotInformation?.date), timeString: String.getString(data?.doctorSlotInformation?.slotTime))
       
      
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        formatter.dateFormat = "EEE, d MMMM yyyy - HH:mm a"
        self.labelDate.text = formatter.string(from: date)
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
        
    }
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonSubmitTapped(_ sender: Any) {
        if reasons[selectedReason].cancel_reason == "Other" && textView.text.isEmpty{
            CommonUtils.showToast(message: "Please Enter reason")
            return
        }
        else{
            submitCancelReasonApi()
        }
    }
    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AppointmentCancellationVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  constraintCancelHeight.constant = CGFloat(reasons.count * 60)
        return reasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportProblemTVC", for: indexPath) as! ReportProblemTVC
        cell.labelProblemName.text = reasons[indexPath.row].cancel_reason
        if selectedReason == indexPath.row{
            cell.buttonSelection.isSelected = true
        }
        else {
            cell.buttonSelection.isSelected = false
        }
        constraintCancelHeight.constant = tableView.contentSize.height + 50
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedReason = indexPath.row
        if "Other" == reasons[indexPath.row].cancel_reason{
            self.viewMore.isHidden = false
            self.constraintViewMoreHieght.constant = 150
        }
        else{
            self.viewMore.isHidden = true
            self.constraintViewMoreHieght.constant = 0
        }
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
extension AppointmentCancellationVC{
    func submitCancelReasonApi(){
        if reasons[selectedReason].cancel_reason == "Other" {
            reasons[selectedReason].cancel_reason = textView.text ?? ""}
        globalApis.updateBookingStatus(bookingId: String.getString(data?.id), doctorId: String.getString(data?.doctorID), status: 3,reason: reasons[selectedReason].cancel_reason){ _ in
            guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.popUpDescription = "Your appointment has been cancelled"
//            vc.popUpImage = #imageLiteral(resourceName: "smile")
            vc.callback = {
                
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                        self.dismiss(animated: true, completion: {
                            kSharedAppDelegate?.moveToHomeScreen()
                        }
                    )
                })
            }
            self.navigationController?.present(vc, animated: true)
        }
    }
    func getCancellationReasons(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.cancellationReasons,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0{
                        let data = kSharedInstance.getArray(dictResult["result"])
                        self?.reasons =  data.map{
                            CancellationReasonsModel(data:kSharedInstance.getDictionary($0))
                        }
                        self?.reasons.append(CancellationReasonsModel(data: ["cancel_reason":"Other"]))
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
