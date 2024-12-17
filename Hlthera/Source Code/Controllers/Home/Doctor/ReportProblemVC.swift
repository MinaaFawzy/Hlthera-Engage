//
//  ReportProblemVC.swift
//  Hlthera
//
//  Created by Prashant on 29/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ReportProblemVC: UIViewController {
    
    @IBOutlet weak var viewMore: UIView!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: IQTextView!
    
    var hasCameFrom: HasCameFrom?
    var doctorId = ""
    
    var problems = ["Wrong phone number","Wrong Address",
                    "Wrong Timings",
                    //"Wrong consultation fee",
                    "More"]
    var selectedProblems = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.font = .corbenRegular(ofSize: 15)
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        self.viewMore.isHidden = true
        self.constraintTableViewHeight.constant = CGFloat(problems.count * 50)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .darkContent
        
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonSubmitTapped(_ sender: Any) {
        if selectedProblems == 10{
            CommonUtils.showToast(message: "Please Select One".localize)
            return
        }
        else {
            reportApi(type: hasCameFrom ?? .none)
        }
    }
    
}
extension ReportProblemVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return problems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportProblemTVC", for: indexPath) as! ReportProblemTVC
        cell.labelProblemName.text = problems[indexPath.row].localize
        if selectedProblems == indexPath.row{
            cell.buttonSelection.isSelected = true
        }
        else {
            cell.buttonSelection.isSelected = false
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedProblems = indexPath.row
        if "More" == problems[indexPath.row]{
            self.viewMore.isHidden = false
            self.constraintTableViewHeight.constant = self.tableView.contentSize.height
        }
        else{
            self.viewMore.isHidden = true
            self.constraintTableViewHeight.constant = CGFloat(problems.count * 50)
        }
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ReportProblemVC {
    func reportApi(type:HasCameFrom){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [ApiParameters.kDoctor_or_clinic_id:doctorId,
                                     ApiParameters.kMessage:problems[selectedProblems] == "More" ? (String.getString(textView.text)) : (problems[selectedProblems]),
                                     ApiParameters.kReportingType:type == HasCameFrom.doctors ? "1" : "2"]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.issueReportByUser,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0{
                        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        vc.callback = {
                            _ = self?.navigationController?.popViewController(animated: true)
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
}
