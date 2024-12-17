//
//  ReportOptionsVC.swift
//  Kindling
//
//  Created by Mohd Aslam on 01/01/21.
//

import UIKit
import IQKeyboardManagerSwift

class ReportOptionsVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var reportTextView: UITextView!
    @IBOutlet weak var viewTextBg: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    
    var selectedOption = ""
    var userId = ""
    var reportCallBack: (() -> ())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.drawShadow()
       
        self.btnSubmit.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
    }
    
    private func resetAllOptions() {
        btn1.isSelected = false
        btn2.isSelected = false
        btn3.isSelected = false
        btn4.isSelected = false
        btn5.isSelected = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.containerView{
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func optionBtnTapped(_ sender: UIButton) {
        resetAllOptions()
        sender.isSelected = true
        selectedOption = sender.titleLabel?.text ?? ""
    }
    
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        if selectedOption == "" && String.getString(reportTextView.text) == "" {
            self.showSimpleAlert(message: "Please enter feedback".localize)
        }else {
            if String.getString(reportTextView.text) != "" {
                selectedOption = String.getString(reportTextView.text)
            }
            //submitReportApi()
        }
        
    }
/*
    func submitReportApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.kUserId: userId,
                                   ApiParameters.kFeedback:selectedOption]
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.reportUser,
                                                   requestMethod: .PUT,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    self.dismiss(animated: true){
                        self.reportCallBack?()
                    }
                    
                    
                default:
                    self.showSimpleAlert(message: String.getString(dictResult[kMessage]))
                }
            } else if errorType == .noNetwork {
                self.showSimpleAlert(message: AlertMessage.kNoInternet)
                
            } else {
                self.showSimpleAlert(message: AlertMessage.kDefaultError)
            }
        }
    }*/
    
}
