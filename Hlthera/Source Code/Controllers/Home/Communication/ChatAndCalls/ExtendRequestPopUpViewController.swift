////
////  ExtendRequestPopUpViewController.swift
////  Consultation
////
////  Created by Mohit Kumar Mohit on 02/02/21.
////
//
//import UIKit
//
//class ExtendRequestPopUpViewController: UIViewController {
//
//    @IBOutlet weak var imageExpertProfile: UIImageView!
//    @IBOutlet weak var labelExpertName: UILabel!
//    @IBOutlet weak var labelAppointmentFees: UILabel!
//    @IBOutlet weak var imageAppointmentType: UIImageView!
//    var appointmentDetails:AppointmentList?
//    var communicationList:CommunicationList?
//    var communicationType:CommunicationType?
//    var receiverId = String()
//    var callid = String()
//    var senderName = String()
//    var senderImage = String()
//    var submitCallBack:(()->())?
//    var dismissCallBack:(()->())?
//    var bookingId = String()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        initialSetup()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        initialSetup()
//    }
//    
//    func initialSetup(){
//        if communicationType == .chat{
//            self.imageExpertProfile.downlodeImage(serviceurl: kImageDownloadURL + String.getString(self.communicationList?.expertImage), placeHolder: #imageLiteral(resourceName: "user_home-1"))
//            self.bookingId = String.getString(self.communicationList?.appointmentID)
//            self.labelExpertName.text = self.communicationList?.expertName
//            self.imageAppointmentType.image = #imageLiteral(resourceName: "chat_blue")
//            self.labelAppointmentFees.text = self.communicationList?.appointmentFees
//        }else{
//            self.imageExpertProfile.downlodeImage(serviceurl: kImageDownloadURL + String.getString(self.appointmentDetails?.expertImage), placeHolder: #imageLiteral(resourceName: "user_home-1"))
//            self.bookingId = String.getString(self.appointmentDetails?.appointmentId)
//            self.labelExpertName.text = self.appointmentDetails?.expertName
//            self.labelAppointmentFees.text  = self.appointmentDetails?.appointmentFees
//            self.imageAppointmentType.image = self.appointmentDetails?.appointmentTypeImage
//        }
//    }
//    
//    func sendExtendRequestNotification(){
//        let params = [
//            "booking_id"            : self.bookingId,
//            "sendTo"                :  self.receiverId,
//            "title"                 :  "Extend Appointment",//"Kindling",
//            "message"               :  "User wants to Extend Appointment",
//            "notificationType"      :  NotificationType.EXTEND_REQUEST.rawValue,
////            "callId"                :  callid,
//            "name"                  :  self.senderName,
//            "profileImage"          :  self.senderImage
//        ]
//        //send notification
//        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.nationality,
//                                                   requestMethod: .POST,
//                                                   requestParameters: params, withProgressHUD: false)
//        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
//            
//            if errorType == .requestSuccess {
//                
//                switch Int.getInt(statusCode) {
//                case 200:
//                    print("Notification Sent")
//                        self.dismiss(animated: true) {
//                            self.submitCallBack?()
//                        }
//
//                default:
//                    print("")
//                }
//            }
//        }
//    }
//
//    @IBAction func buttonClose(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: {
//            //kSharedAppDelegate?.moveToTabBar(selectedIndex: 0)
//        })
//    }
//    @IBAction func buttonSubmit(_ sender: UIButton) {
//        sendExtendRequestNotification()
//    }
//}
//
