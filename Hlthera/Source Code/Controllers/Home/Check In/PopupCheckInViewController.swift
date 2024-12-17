//
//  PopupCheckInViewController.swift
//  Hlthera
//
//  Created by Ahmed Hegazy on 08/01/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit

@available(iOS 15.0, *)
class PopupCheckInViewController: UIViewController {
    
    @IBOutlet weak var imageDoctor: UIImageView!
    @IBOutlet weak var viewHidDoctor: UIView!
    @IBOutlet weak var viewCustom: UIView!
    @IBOutlet weak var lblHiDoctor: UILabel!
    @IBOutlet weak var lblCustom: UILabel!
    @IBOutlet weak var tfMessage: UITextField!
    @IBOutlet weak var lblDoctorName: UILabel!
    @IBOutlet weak var viewWriteMessage: UIView!
    
    var doctorId = 0
    var bookingId = 0
    var checkInItem: CheckInItem?
    var callBackCheckin: (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        doctorId = Int.getInt(checkInItem?.doctorInformation?.doctorID)
        bookingId = (checkInItem?.id)!
//        viewWriteMessage.isHidden = true;
//        viewHidDoctor.backgroundColor = UIColor().hexStringToUIColor(hex: "#BFDDF8")
//        viewCustom.backgroundColor = UIColor().hexStringToUIColor(hex: "#EFF5F8")
        imageDoctor.downlodeImage(serviceurl: "https://hlthera-s3.s3-ap-southeast-2.amazonaws.com/" + String.getString(checkInItem?.doctor?.profilePicture), placeHolder: UIImage(named: "placeholder"))
        lblDoctorName.text = checkInItem?.doctor?.name
        
        let doctorName = checkInItem?.doctor?.name ?? ""
        //doctorName = doctorName?.substring(with: 0..<doctorName)
        lblHiDoctor.text = "\(doctorName)"
    }
    
    @IBAction func btnHiDoctorTapped(_ sender: UIButton) {
//        viewHidDoctor.backgroundColor = UIColor().hexStringToUIColor(hex: "#BFDDF8")
//        viewCustom.backgroundColor = UIColor().hexStringToUIColor(hex: "#EFF5F8")
//        lblCustom.textColor = UIColor().hexStringToUIColor(hex: "#878989")
//        lblHiDoctor.textColor = UIColor().hexStringToUIColor(hex: "#1C2C51")
//        viewWriteMessage.isHidden = true;
    }
    
    @IBAction func btnCustomTapped(_ sender: UIButton) {
//        viewCustom.backgroundColor = UIColor().hexStringToUIColor(hex: "#BFDDF8")
//        viewHidDoctor.backgroundColor = UIColor().hexStringToUIColor(hex: "#EFF5F8")
//        lblHiDoctor.textColor = UIColor().hexStringToUIColor(hex: "#878989")
//        lblCustom.textColor = UIColor().hexStringToUIColor(hex: "#1C2C51")
//        viewWriteMessage.isHidden = false
    }
    
    @IBAction func btnDoneCheckIn(_ sender: UIButton) {
        var message  = ""
        var doctorId = self.doctorId
        if(viewWriteMessage.isHidden == false) {
            if String.getString(tfMessage.text).isEmpty{
                //showAlertMessage.alert(message: "Please Enter Message")
                CommonUtils.showToast(message: "Please Enter Message".localize)
                return
            }
            message  = tfMessage?.text ?? ""
        } else {
            let doctorName = checkInItem?.doctor?.name ?? ""
            message = "Hi \(doctorName)! I’m Checking in".localize
        }
        
        checkInRequest(doctorId: self.doctorId, message: message ,
                       bookingId: self.bookingId)
        
    }
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func btnCheckInTapped(_ sender: UIButton) {
        var message  = ""
        var doctorId = self.doctorId
        if(viewWriteMessage.isHidden == false) {
            if String.getString(tfMessage.text).isEmpty{
                //showAlertMessage.alert(message: "Please Enter Message")
                CommonUtils.showToast(message: "Please Enter Message".localize)
                return
            }
            message  = tfMessage?.text ?? ""
        } else {
            let doctorName = checkInItem?.doctor?.name ?? ""
            message = "Hi \(doctorName)! I’m Checking in".localize
        }
        
        checkInRequest(doctorId: self.doctorId, message: message ,
                       bookingId: self.bookingId)
    }
}

@available(iOS 15.0, *)
extension PopupCheckInViewController {
    
    func checkInRequest(doctorId: Int,
                        message: String,
                        bookingId: Int
    ) {
        let params = [
            ApiParameters.doctor_id: doctorId,
            ApiParameters.kMessage: message,
            ApiParameters.booking_id: bookingId,
            
            //ApiParameters.kdeviceToken:kSharedUserDefaults.getDeviceToken(),
            //ApiParameters.klogin_type:String.getString(loginType),
            //ApiParameters.ksocial_id:id,
            //ApiParameters.kLatitude:"0",
            //ApiParameters.kLongitude:"0",
            //ApiParameters.kfullName:name,
            //ApiParameters.kemail:email,
        ] as [String : Any]
        checkInApi(params: params)
    }
    
    func checkInApi(params: [String: Any]) {
        CommonUtils.showHudWithNoInteraction(show: true)
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.sendMessageToDoctorCheckIn,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    print(dictResult)
                    let data = kSharedInstance.getDictionary(dictResult["data"])
                    //              var json = JSON(dictResult)
                    //              var messageSuccess = json["message"].stringValue
                    //              var created_at = json["data"]["created_at"].stringValue
                    //              var doctor_id = json["data"]["doctor_id"].intValue
                    //              var id = json["data"]["id"].intValue
                    //              var messageData = json["data"]["message"].stringValue
                    //              var updated_at = json["data"]["updated_at"].stringValue
                    //              var user_id = json["data"]["user_id"].intValue
                    //            print(created_at)
                    //              print(doctor_id)
                    //              print(id)
                    //              print(messageData)
                    //              print(updated_at)
                    
                    //              self.MotionToast(message: "Checked in successfully completed", toastType: .success)
                    //                    CommonUtils.showToast(message: "Checked in successfully completed".localize)
                    //                    self.dismiss(animated: true)
                    
                    //                    self.dismiss(animated: true) { [weak self] in
                    //guard let self = self else { return }
                    guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
                    vc.popUpDescription = "Checked in successfully completed"
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    vc.callback = {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                            self.dismiss(animated: true)
                        })
                    }
                    self.present(vc, animated: true)
                    //}
                case 400:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
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



