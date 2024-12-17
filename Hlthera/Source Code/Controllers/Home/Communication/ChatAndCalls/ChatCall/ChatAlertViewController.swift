////
////  ChatAlertViewController.swift
////  Kindling
////
////  Created by Mohd Aslam on 30/09/20.
////  Copyright © 2020 fluper. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//import AudioToolbox
//
//class ChatAlertViewController: UIViewController, AVAudioPlayerDelegate {
//
//    @IBOutlet weak var userName: UILabel!
//    @IBOutlet weak var userImgView: UIImageView!
//    @IBOutlet weak var labelAppointmentid: UILabel!
//    @IBOutlet weak var labelAppointmentTime: UILabel!
//    
//    var params: [String: Any] = [:]
//    var audioPlayer : AVAudioPlayer?
//    var callIncoming = String()
//    var userDetails = kSharedUserDefaults.getLoggedInUserDetails()
//    var appointmentId:String?
//    var appointmentDetails:AppointmentList?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        userImgView.clipsToBounds = true
//        
//        userName.text = "\(kSharedUserDefaults.getCallerName())"
//        self.userImgView.sd_setImage(with: URL(string: String.getString(kSharedUserDefaults.getProfileImg())), placeholderImage: UIImage(named: "user_create_profile"), options: .highPriority, completed: nil)
//        
//        playVibrate()
//        
//      //  self.view.applyGradient(isTopBottom: false, colorArray: [CustomColor.kDarkRed ,CustomColor.kLightRed])
//        DispatchQueue.main.async {
//       //     self.view.applyGradient(isTopBottom: false, colorArray: [CustomColor.kDarkRed ,CustomColor.kLightRed])
//        }
//        
//
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//        self.getAppointmentDetails(bookingId:String.getString(kSharedUserDefaults.getAppointmentId()))
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        audioPlayer?.stop()
//    }
//    
////    func SendtextMessage() {
////        //saveMessageLocallyInDatabase(mediaurl: "", mediatype: "text", message: String.getString(self.chatTextView.text), thumnilimageurl: "")
////        let timeStamp = String.getString(Int(Date().timeIntervalSince1970 * 1000))
////        let completeName = self.userDetails[Parameters.name] as? String ?? ""
////
////        let dic = [Parameters.senderid: String.getString(self.userDetails[Parameters.user_id]), Parameters.content: "Audio call" , Parameters.timeStamp : timeStamp , Parameters.receiverid  : kSharedUserDefaults.getCallerId()  , Parameters.thumnilimageurl : "" , Parameters.mediatype : "call" ,  Parameters.isDeleted : kSharedUserDefaults.getCallerId() , Parameters.mediaurl :  "" , Parameters.groupid :  "",Parameters.groupname : "","from_name" : completeName, "to_name" : kSharedUserDefaults.getCallerName(), Parameters.status : "not_seen"]
////
////
////        Chat_hepler.Shared_instance.SendMessage(dic: kSharedInstance.getDictionary(dic), Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: kSharedUserDefaults.getCallerId(), bookingId: String.getString(<#T##message: Any?##Any?#>))
////
////            //Func for resend users
////        Chat_hepler.Shared_instance.ResentUser(lastmessage:  "Audio call", Receiverid: String.getString(kSharedUserDefaults.getCallerId()), Senderid: String.getString(self.userDetails[Parameters.user_id]), name: kSharedUserDefaults.getCallerName(), profile_image: kSharedUserDefaults.getProfileImg(), readState: "not_seen", isMsgSend: true, lastTimestamp: timeStamp, msgReceiverId: kSharedUserDefaults.getCallerId(), unreadCount: 1, friendStatus: true, callStatus: CallState.REJECTED.rawValue)
////
////    }
//    func getAppointmentDetails(bookingId:String){
//        let params:[String:Any] = [ApiParameters.booking_id:"bookingId"]
//        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.nationality,
//                                                   requestMethod: .POST,
//                                                   requestParameters: params, withProgressHUD: false)
//        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
//            CommonUtils.showHudWithNoInteraction(show: false)
//            if errorType == .requestSuccess {
//                let dictResult = kSharedInstance.getDictionary(result)
//                switch Int.getInt(statusCode) {
//                case 200:
//                    let data = kSharedInstance.getDictionary(dictResult["response"])
//                    self.appointmentDetails = AppointmentList.init(data:data)
//                    self.labelAppointmentid.text = self.appointmentDetails?.appointmentId
//                    self.labelAppointmentTime.text = self.appointmentDetails?.appointmentDate
//                default:
//                    self.showSimpleAlert(message: String.getString(dictResult[kMessage]))
//                }
//            } else {
//                self.showSimpleAlert(message: AlertMessage.kDefaultError)
//            }
//        }
//    }
//    
//    func rejectGroupVideoCall(){
///*
//        Chat_hepler.Shared_instance.getActiveGroupMembersInCall(callId: kSharedUserDefaults.getCallId()) { (list) in
//            
//            Chat_hepler.Shared_instance.updateGroupCallDataOnFirebase(callId: kSharedUserDefaults.getCallId(), userId: String.getString(kSharedUserDefaults.getLoggedInUserId()), callStatus: CallState.DISCONNECTED.rawValue)
//            
//            let userIdStr = String.getString(kSharedUserDefaults.getLoggedInUserId())
//        if kSharedAppDelegate.isVideoCallOn == true{
//            self.params = [
//                "user_id"                  :  list,
//                "title"                   :  "Video Call Ended",
//                "message"                 :  "\(kSharedUserDefaults.getCallerName()) ended call",
//                "notification_type"        :  NotificationType.GROUP_VIDEO_CALL_REJECT.rawValue ,
//                "call_id"                 : kSharedUserDefaults.getCallId(),
//                "send_to_id"              : Int(userIdStr) ?? 0,
//                "full_name"                : kSharedUserDefaults.getCallerName()
//                ]
//        }else if kSharedAppDelegate.isVoiceCallOn == true{
//            self.params = [
//                "user_id"                  :  list,
//                "title"                   :  "Audio Call Ended",
//                "message"                 :  "\(kSharedUserDefaults.getCallerName()) ended call",
//                "notification_type"        :  NotificationType.GROUP_AUDIO_CALL_REJECT.rawValue ,
//                "call_id"                 : kSharedUserDefaults.getCallId(),
//                "send_to_id"              : Int(userIdStr) ?? 0,
//                "full_name"               : kSharedUserDefaults.getCallerName()
//                ]
//        }
//        
//            self.postToServerAPI(url: kgroupCallingRequest, params: self.params, type: .POST) { (data) in
//        print("Call Ended Notification Sent")
//        }
//    }
// */
//    }
//    
//    func acceptGroupVideoCall(){
///*
//        Chat_hepler.Shared_instance.getActiveGroupMembersInCall(callId: kSharedUserDefaults.getCallId()) { (list) in
//        
//        
//        let userIdStr = String.getString(kSharedUserDefaults.getLoggedInUserId())
//        if kSharedAppDelegate.isVideoCallOn == true{
//            self.params = [
//                "user_id"                  :  list,
//                "title"                   :  "Video Call Accepted",
//                "message"                 :  "\(kSharedUserDefaults.getCallerName()) accepted call",
//                "notification_type"        :  NotificationType.GROUP_VIDEO_CALL_ACCEPT.rawValue ,
//                "call_id"                 : kSharedUserDefaults.getCallId(),
//                "send_to_id"              : Int(userIdStr) ?? 0,
//                "full_name"               : kSharedUserDefaults.getCallerName()
//                ]
//        }else if kSharedAppDelegate.isVoiceCallOn == true{
//            
//            self.params = [
//                "user_id"                  :  list,
//                "title"                   :  "Audio Call Accepted",
//                "message"                 :  "\(kSharedUserDefaults.getCallerName()) accepted call",
//                "notification_type"        :  NotificationType.GROUP_AUDIO_CALL_ACCEPT.rawValue ,
//                "call_id"                 : kSharedUserDefaults.getCallId(),
//                "send_to_id"              : Int(userIdStr) ?? 0,
//                "full_name"               : kSharedUserDefaults.getCallerName()
//                ]
//        }
//
//        
//            Chat_hepler.Shared_instance.updateGroupCallDataOnFirebase(callId: kSharedUserDefaults.getCallId(), userId: String.getString(kSharedUserDefaults.getLoggedInUserId()), callStatus: CallState.CONNECTED.rawValue)
//            self.postToServerAPI(url: kgroupCallingRequest, showLoader: false, params: self.params, type: .POST) { (data) in
//            //print("Call Accepted Notification Sent")
//            
//            if kSharedAppDelegate.isVideoCallOn == true{
//                kSharedAppDelegate.showNotificationScreen(storyBoard: "Chat", identifier: ViewControllerTitles.kGroupVideoCallVC, isGroupChat: kSharedAppDelegate.isGroupCall)
//            }else if kSharedAppDelegate.isVoiceCallOn == true{
//                kSharedAppDelegate.showNotificationScreen(storyBoard: "Chat", identifier: ViewControllerTitles.kVoiceChatViewController, isGroupChat: kSharedAppDelegate.isGroupCall)
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//                NotificationCenter.default.post(name: Notification.Name("UpdatVideoChatTimer"), object: nil)
//            })
//            
//        }
//    }
// */
//    }
//    
//    func playVibrate(){
//        AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil,
//                                              nil,
//                                              { (_:SystemSoundID, _:UnsafeMutableRawPointer?) -> Void in
//                                                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//        },nil)
//        
//        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "alarmTone", ofType: "mp3")!)
//        
//        var error: NSError?
//        
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: url)
//        } catch let error1 as NSError {
//            error = error1
//            audioPlayer = nil
//        }
//        
//        if let err = error {
//            print("audioPlayer error \(err.localizedDescription)")
//            return
//        } else {
//            
//            audioPlayer!.delegate = self
//            audioPlayer!.prepareToPlay()
//            
//        }
//        
//        audioPlayer!.numberOfLoops = -1
//        audioPlayer!.play()
//    }
//    
//    
//    @IBAction func acceptButtonTApped(_ sender: UIButton) {
//                        
//        audioPlayer?.stop()
//        AudioServicesPlaySystemSound(SystemSoundID(truncating: false))
//        
//        if kSharedAppDelegate?.isGroupCall ?? false{
//            acceptGroupVideoCall()
//        }else {
//           
//            Chat_hepler.Shared_instance.updateCallDataOnFirebase(callId: kSharedUserDefaults.getCallId(), callStatus: CallState.CONNECTED.rawValue)
//            if (kSharedAppDelegate?.isVideoCallOn ?? false) == true{
//                 params = [
//                    "sendTo"                  :  kSharedUserDefaults.getCallerId(),
//                    "title"                   :  "Video Call Accepted",
//                    "message"                 :  "\(kSharedUserDefaults.getCallerName()) accepted call",
//                    "notificationType"        :  NotificationType.VIDEO_CALL_ACCEPT.rawValue ,
//                    "callId"                  : kSharedUserDefaults.getCallId(),
//                    "name"                    : kSharedUserDefaults.getCallerName(),
//                    "profileImage"            : kSharedUserDefaults.getProfileImg()
//                    ]
//            }else if (kSharedAppDelegate?.isVoiceCallOn ?? false) == true{
//                 params = [
//                    "sendTo"                  :  kSharedUserDefaults.getCallerId(),
//                    "title"                   :  "Audio Call Accepted",
//                    "message"                 :  "\(kSharedUserDefaults.getCallerName()) accepted call",
//                    "notificationType"        :  NotificationType.AUDIO_CALL_ACCEPT.rawValue ,
//                    "callId"                  : kSharedUserDefaults.getCallId(),
//                    "name"                    : kSharedUserDefaults.getCallerName(),
//                    "profileImage"            : kSharedUserDefaults.getProfileImg()
//                    ]
//            }
//
//            CommonUtils.showHudWithNoInteraction(show: true)
//            //send notification
//            TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.nationality,
//                                                       requestMethod: .POST,
//                                                       requestParameters: params, withProgressHUD: false)
//            { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
//                
//                CommonUtils.showHudWithNoInteraction(show: false)
//                if errorType == .requestSuccess {
//                    
//                    switch Int.getInt(statusCode) {
//                    case 200:
//                        print("Notification Sent")
////                    if (kSharedAppDelegate?.isVideoCallOn ?? false) == true{
////                        kSharedAppDelegate?.showNotificationScreen(storyBoard: "Chat", identifier: "VideoCallViewController", isGroupChat: kSharedAppDelegate?.isGroupCall ?? false)
////                    }else if (kSharedAppDelegate?.isVoiceCallOn ?? false) == true{
////                        kSharedAppDelegate?.showNotificationScreen(storyBoard: "Chat", identifier: "VoiceChatViewController", isGroupChat: kSharedAppDelegate?.isGroupCall ?? false)
////                    }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//                        NotificationCenter.default.post(name: Notification.Name("UpdatVideoChatTimer"), object: nil)
//                    })
//                        
//                    default:
//                        print("")
//                    }
//                }
//            }
//        }
//        
//
//                
//    }
//
//    
//    @IBAction func rejectCallButtonTapped(_ sender: UIButton) {
//        
//        callReject()
//       // kSharedAppDelegate?.moveToTabBar(selectedIndex: 1)
//    }
//    
//    func callReject() {
//        
//        audioPlayer?.stop()
//        AudioServicesPlaySystemSound(SystemSoundID(truncating: false))
//
//        if kSharedAppDelegate?.isGroupCall ?? false{
//            rejectGroupVideoCall()
//        }else {
//           
//            Chat_hepler.Shared_instance.updateCallDataOnFirebase(callId: kSharedUserDefaults.getCallId(), callStatus: CallState.DISCONNECTED.rawValue)
//            if (kSharedAppDelegate?.isVideoCallOn ?? false) == true{
//                 params = [
//                    "sendTo"                  :  kSharedUserDefaults.getCallerId(),
//                    "title"                   :  "Video Call Ended",
//                    "message"                 :  "\(kSharedUserDefaults.getCallerName()) ended call",
//                    "notificationType"        :  NotificationType.VIDEO_CALL_REJECT.rawValue ,
//                    "callId"                  : kSharedUserDefaults.getCallId(),
//                    "name"                    : kSharedUserDefaults.getCallerName(),
//                    "profileImage"            : kSharedUserDefaults.getProfileImg()
//                    ]
//            }else if (kSharedAppDelegate?.isVoiceCallOn ?? false) == true{
//                 params = [
//                    "sendTo"                  :  kSharedUserDefaults.getCallerId(),
//                    "title"                   :  "Audio Call Ended",
//                    "message"                 :  "\(kSharedUserDefaults.getCallerName()) ended call",
//                    "notificationType"        :  NotificationType.AUDIO_CALL_REJECT.rawValue ,
//                    "callId"                  : kSharedUserDefaults.getCallId(),
//                    "name"                    : kSharedUserDefaults.getCallerName(),
//                    "profileImage"            : kSharedUserDefaults.getProfileImg()
//                    ]
//            }
//
////            self.SendtextMessage()
//            //send notification
//            self.connectVideoCallAPI(url: ServiceName.nationality, params: kSharedInstance.getDictionary(params))
//             
//        }
//        
//        
//        //kSharedAppDelegate?.moveToTabBar(selectedIndex: 1)
//    }
//    
//    func connectVideoCallAPI(url : String , params : [String : Any]){
//        
//        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
//                                                   requestMethod: .POST,
//                                                   requestParameters: params, withProgressHUD: false)
//        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
//            
//            if errorType == .requestSuccess {
//                
//                switch Int.getInt(statusCode) {
//                case 200:
//                    print("Notification Sent")
//                    
//                default:
//                    print("")
//                }
//            }
//        }
//    }
//}
