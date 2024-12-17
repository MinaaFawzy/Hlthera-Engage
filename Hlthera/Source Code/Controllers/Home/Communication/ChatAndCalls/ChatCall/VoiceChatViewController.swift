////
////  VoiceChatViewController.swift
////  Kindling
////
////  Created by Mohd Aslam on 29/09/20.
////  Copyright © 2020 fluper. All rights reserved.
////
//
//import UIKit
//import AgoraRtcKit
//import AVFoundation
//import AVKit
//
////Kindling: "d07aa0caa0454d69a1ccec22993f00e3"
//let Agora_AppID: String = "7b7c99ac420e4577ba2562eae092fa56"
//
//class VoiceChatViewController: UIViewController, AVAudioPlayerDelegate {
//    
//    @IBOutlet weak var userProfile: UIImageView!
//    @IBOutlet weak var lblUserName: UILabel!
//    @IBOutlet weak var lblTimer: UILabel!
//    @IBOutlet weak var btnSpeaker: UIButton!
//    @IBOutlet weak var btnEndCall: UIButton!
//    @IBOutlet weak var btnVoice: UIButton!
//    @IBOutlet weak var controlButtonsView: UIView!
//    
//    var titleStr = ""
//    var profileUrl = ""
//    var agoraKit: AgoraRtcEngineKit!
//    var receiverId = ""
//    var userId = ""
//    var ishangoutBtnTapped = false
//    var isChennalBusy = false
//    var audioPlayer   : AVAudioPlayer?
//    var chennalName = ""
//    var isComingFromChat = false
//    var timer:Timer!
//    var seconds = 0
//    var callBack:(()->())?
//    var userIds = [Int]()
//    var senderName = ""
//    var senderImage = ""
//    var receiverName = ""
//    var unread_count = 0
//    var userDetails = kSharedUserDefaults.getLoggedInUserDetails()
//    var appointmentDetails:AppointmentList?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.userProfile.clipsToBounds = true
//        //self.view.applyGradient(isTopBottom: false, colorArray: [CustomColor.kDarkRed ,CustomColor.kLightRed])
//        DispatchQueue.main.async {
//           // self.view.applyGradient(isTopBottom: false, colorArray: [CustomColor.kDarkRed ,CustomColor.kLightRed])
//        }
//        NotificationCenter.default.addObserver(self, selector: #selector(startVideoChat), name: Notification.Name("UpdatVideoChatTimer"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(extendRejected), name: Notification.Name("ExtendRequestRejected"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(extendAccepted), name: Notification.Name("ExtendRequestAccepted"), object: nil)
//        //profileUrl = kSharedInstance.usermodel?.userImage ?? ""
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        userId = String.getString(self.userDetails[Parameters.user_id])
//        senderName = String.getString(self.userDetails[Parameters.name])
//        senderImage = String.getString(self.userDetails[kProfilePicture])
//        receiverId = kSharedUserDefaults.getCallerId()
//        self.getAppointmentDetails(bookingId:String.getString(kSharedUserDefaults.getAppointmentId()))
//        if kSharedAppDelegate?.isVoiceCallOn ?? false{
//            if kSharedAppDelegate?.isGroupCall ?? false{
//                self.userProfile.image = UIImage(named: "group-1")
//            }else {
//                self.userProfile.sd_setImage(with: URL(string: String.getString(kSharedUserDefaults.getProfileImg())), placeholderImage: UIImage(named: "user_create_profile"), options: .highPriority, completed: nil)
//            }
//            lblTimer.text = "Audio Call"
//            lblUserName.text = kSharedUserDefaults.getCallerName()
//            videoCallConnection()
//        }else{
//            (kSharedAppDelegate?.isGroupCall ?? false) ? initateGroupVideoCall() : self.initateVideoCall()
//        }
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        callDismiss()
//        if timer != nil {
//            timer.invalidate()
//        }
//    }
//    
//    @objc func startVideoChat(notification: NSNotification) {
//        if timer == nil {
//            timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector:#selector(self.startTimer(timer:)), userInfo:nil, repeats:true)
//        }
//    }
//    
//    @objc func extendAccepted(notification: NSNotification) {
//        timer.invalidate()
//        if timer == nil {
//            timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector:#selector(self.startTimer(timer:)), userInfo:nil, repeats:true)
//        }
//    }
//    
//    @objc func extendRejected(notification: NSNotification) {
//        disconnectCall()
//    }
//    
//    @objc func startTimer(timer: Timer) {
//        seconds = seconds + 1
//        let hr = seconds / 3600
//        let min = ((seconds % 3600) / 60)
//        let sec = ((seconds % 3600) % 60)
//        let totalTimeString = String(format: "%02d:%02d:%02d",hr, min, sec)
//        lblTimer.text = "\(totalTimeString)"
//        if seconds == 3600 * Int(Double.getDouble(self.appointmentDetails?.duration)){
//            print("Extend")
////            guard let vc = self.storyboard?.instantiateViewController(identifier: Identifiers.kAppointmentExtendPopUp) as? AppointmentExtendPopUpViewController else {return}
////            vc.modalTransitionStyle = .crossDissolve
////            vc.modalPresentationStyle = .overCurrentContext
////            vc.appointmentDetails = self.appointmentDetails
////            vc.communicationType = .audio
////            vc.receiverid = self.receiverId
////            vc.homeCallBack = {
////                kSharedAppDelegate?.moveToTabBar(selectedIndex: 0)
////            }
////            vc.extendCallBack = {
////                guard let vc = self.storyboard?.instantiateViewController(identifier: "ExtendRequestPopUpViewController") as? ExtendRequestPopUpViewController else {return}
////                vc.modalTransitionStyle = .crossDissolve
////                vc.modalPresentationStyle = .overCurrentContext
////                vc.receiverId = self.receiverId
////                vc.communicationType = .audio
////                vc.appointmentDetails = self.appointmentDetails
////                vc.senderName = String.getString(self.userDetails[Parameters.sendername])
////                vc.senderImage = String.getString(self.userDetails[Parameters.senderImage])
////                vc.submitCallBack = {
////                    self.getAppointmentDetails(bookingId: String.getString(String.getString(kSharedUserDefaults.getAppointmentId())))
////                }
////                self.present(vc, animated: true)
////            }
////            self.present(vc, animated: true)
//        }
//    }
//    
//    func getAppointmentDetails(bookingId:String){
//        let params:[String:Any] = [ApiParameters.booking_id:"bookingId"]
//        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.updateBookingStatus,
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
//                default:
//                    self.showSimpleAlert(message: String.getString(dictResult[kMessage]))
//                }
//            } else {
//                self.showSimpleAlert(message: AlertMessage.kDefaultError)
//            }
//        }
//    }
//    
//    //    func SendtextMessage() {
//    //        //saveMessageLocallyInDatabase(mediaurl: "", mediatype: "text", message: String.getString(self.chatTextView.text), thumnilimageurl: "")
//    //        let timeStamp = String.getString(Int(Date().timeIntervalSince1970 * 1000))
//    //        let completeName = self.userDetails[Parameters.name] as? String ?? ""
//    //
//    //        let dic = [Parameters.senderid: userId, Parameters.content: "Audio call" , Parameters.timeStamp : timeStamp , Parameters.receiverid  : kSharedUserDefaults.getCallerId()  , Parameters.thumnilimageurl : "" , Parameters.mediatype : "call" ,  Parameters.isDeleted : userId, Parameters.mediaurl :  "" , Parameters.groupid :  "",Parameters.groupname : "","from_name" : completeName, "to_name" : kSharedUserDefaults.getCallerName(), Parameters.status : "not_seen"]
//    //
//    //
//    //            Chat_hepler.Shared_instance.SendMessage(dic: kSharedInstance.getDictionary(dic), Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: kSharedUserDefaults.getCallerId())
//    //
//    //            //Func for resend users
//    //        Chat_hepler.Shared_instance.ResentUser(lastmessage:  "Audio call", Receiverid: String.getString(kSharedUserDefaults.getCallerId()), Senderid: String.getString(self.userDetails[Parameters.user_id]), name: kSharedUserDefaults.getCallerName(), profile_image: kSharedUserDefaults.getProfileImg(), readState: "not_seen", isMsgSend: true, lastTimestamp: timeStamp, msgReceiverId: kSharedUserDefaults.getCallerId(), unreadCount: 1, friendStatus: true, callStatus: CallState.REJECTED.rawValue)
//    //
//    //    }
//    
//    
//    func initateVideoCall(){
//        lblTimer.text = "Audio Call"
//        lblUserName.text = kSharedUserDefaults.getCallerName()
//        self.userProfile.sd_setImage(with: URL(string: String.getString(kSharedUserDefaults.getProfileImg())), placeholderImage: UIImage(named: "user_create_profile"), options: .highPriority, completed: nil)
//        
//        if self.receiverId < self.userId{
//            kSharedUserDefaults.setChennalName(chennalName: self.receiverId + "_" + self.userId)
//        }else{
//            kSharedUserDefaults.setChennalName(chennalName: self.userId + "_" + self.receiverId)
//        }
//        
//        let timeStamp = String.getString(Int(Date().timeIntervalSince1970 * 1000))//UInt64(Date().timeIntervalSince1970 * 1000)
//        let groupDetails = [Parameters.receiverid: String.getString(self.receiverId), Parameters.receivername: receiverName, Parameters.receiverImage: profileUrl, Parameters.sendername: senderName, Parameters.senderImage: senderImage, "call_type": CallType.AUDIO_CALL.rawValue , "timeStamp" : timeStamp , "message" : "Ringing", "call_status": CallState.CONNECTING.rawValue] as [String : Any]
//        
//        Chat_hepler.Shared_instance.addOneToOneCalltoFirebase(callDic: kSharedInstance.getDictionary(groupDetails)) { (callid) in
//            print("call id ====== \(callid)")
//            kSharedUserDefaults.setCallId(name: callid)
//            
//            let params: [String: Any] = [
//                "sendTo"                :  self.receiverId,
//                "title"                 :  "Audio Call",//"Kindling",
//                "message"               :  "Audio Call",
//                "notificationType"      :  NotificationType.AUDIO_CALL_INCOMING.rawValue,
//                "callId"                :  callid,
//                "name"                  :  self.senderName,
//                "profileImage"          :  self.senderImage
//            ]
//            
//            //playVibrate(ringTone: kReceiverTone)
//            //send notification
//            self.connectVideoCallAPI(url: ServiceName.nationality, params: kSharedInstance.getDictionary(params))
//            //self.SendtextMessage()
//            self.videoCallConnection()
//        }
//    }
//    
//    
//    func initateGroupVideoCall(){
//        lblUserName.text = kSharedUserDefaults.getCallerName()
//        //self.userProfile.sd_setImage(with: URL(string: String.getString(profileUrl)), placeholderImage: UIImage(named: "group-1"), options: .highPriority, completed: nil)
//        //kSharedUserDefaults.setChennalName(chennalName: self.receiverId)
//        self.userProfile.image = UIImage(named: "group-1")
//        //playVibrate(ringTone: kReceiverTone)
//        
//        let timeStamp = String.getString(Int(Date().timeIntervalSince1970 * 1000))//UInt64(Date().timeIntervalSince1970 * 1000)
//        let groupDetails = ["group_id": String.getString(self.receiverId), Parameters.groupName: receiverName, Parameters.groupImage: profileUrl, "call_type": CallType.AUDIO_CALL.rawValue , "timeStamp" : timeStamp , "message" : "Ringing"] as [String : Any]
//        
//        var userDict = [String: Any]()
//        //Chat_hepler.Shared_instance.GetMembersfromGroup(groupid:String.getString(self.receiverId)) { (members)  in
//        for item in self.userIds {
//            let idStr = "u_\(item)"
//            userDict[idStr] = CallState.CONNECTING.rawValue
//        }
//        userDict[self.userId] = CallState.CONNECTED.rawValue
//        
//        Chat_hepler.Shared_instance.addGroupCalltoFirebase(groupdic: kSharedInstance.getDictionary(groupDetails), userdic: userDict) { (callid) in
//            print("call id ====== \(callid)")
//            kSharedUserDefaults.setCallId(name: callid)
//            kSharedUserDefaults.setChennalName(chennalName: String.getString(callid))
//            kSharedUserDefaults.setCallerId(name: String.getString(callid))
//            
//            
//            let params: [String: Any] = [
//                "user_id"                 : self.userIds,
//                "title"                   : "Kindling",
//                "message"                 : "Group Audio Call",
//                "notification_type"       : NotificationType.GROUP_AUDIO_CALL_INCOMING.rawValue,
//                "call_id"                 : callid,
//                "send_to_id"              : self.userId,
//                "full_name"               : kSharedUserDefaults.getCallerName(),
//                //"group_id"                : self.receiverId
//            ]
//            
//            self.connectVideoCallAPI(url: "kgroupCallingRequest", params: kSharedInstance.getDictionary(params))
//            self.videoCallConnection()
//            
//        }
//        //}
//        
//    }
//    
//    func videoCallConnection(){
//        initializeAgoraEngine()
//        joinChannel()
//    }
//    
//    func initializeAgoraEngine() {
//        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: Agora_AppID, delegate: nil)
//    }
//    
//    func joinChannel() {
//        print("Channel name === \(String.getString(kSharedUserDefaults.getChennalName()))")
//        agoraKit.joinChannel(byToken: nil,channelId: String.getString(kSharedUserDefaults.getChennalName()), info:nil, uid:0) {[unowned self] (sid, uid, elapsed) -> Void in
//            self.agoraKit.setEnableSpeakerphone(true)
//            UIApplication.shared.isIdleTimerDisabled = true
//        }
//        audioPlayer?.stop()
//    }
//    
//    func rejectGroupVideoCall(){
//        
//        Chat_hepler.Shared_instance.updateGroupCallDataOnFirebase(callId: kSharedUserDefaults.getCallId(), userId: userId, callStatus: CallState.DISCONNECTED.rawValue)
//        var params: [String: Any] = [:]
//        if kSharedAppDelegate?.isVoiceCallOn == true{
//            
//            Chat_hepler.Shared_instance.getActiveGroupMembersInCall(callId: kSharedUserDefaults.getCallId()) { (list) in
//                
//                
//                params = [
//                    "user_id"                 : list,
//                    "send_to_id"              : self.userId,
//                    "title"                   : "Audio Call Ended",
//                    "message"                 : "\(kSharedUserDefaults.getCallerName()) ended call",
//                    "notification_type"       : NotificationType.GROUP_AUDIO_CALL_REJECT.rawValue ,
//                    "call_id"                 : kSharedUserDefaults.getCallId(),
//                    "full_name"               : kSharedUserDefaults.getCallerName()
//                ]
//                
//                self.connectVideoCallAPI(url: "kgroupCallingRequest", params: kSharedInstance.getDictionary(params))
//                
//            }
//        }
//        
//    }
//    
//    func callDismiss(){
//        leaveChannel()
//        setDefaultValue()
//        audioPlayer?.stop()
//    }
//    
//    func setDefaultValue(){
//        audioPlayer?.stop()
//    }
//    
//    func leaveChannel() {
//        kSharedAppDelegate?.isVoiceCallOn = false
//        if agoraKit != nil {
//            agoraKit.leaveChannel(nil)
//        }
//        hideControlButtons()
//        UIApplication.shared.isIdleTimerDisabled = false
//    }
//    
//    func hideControlButtons() {
//        controlButtonsView.isHidden = true
//    }
//    
//    @IBAction func tapSwitchSpeakerBtn(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        agoraKit.setEnableSpeakerphone(sender.isSelected)
//    }
//    
//    @IBAction func tapMuteBtn(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        agoraKit.muteLocalAudioStream(sender.isSelected)
//    }
//    
//    @IBAction func tapEndCallBtn(_ sender: UIButton) {
//        disconnectCall()
//    }
//    
//    func disconnectCall() {
//        
//        ishangoutBtnTapped = true
//        if !isChennalBusy{
//            callDismiss()
//        }
//        if kSharedAppDelegate?.isGroupCall ?? false{
//            rejectGroupVideoCall()
//        }else {
//            Chat_hepler.Shared_instance.updateCallDataOnFirebase(callId: kSharedUserDefaults.getCallId(), callStatus: CallState.DISCONNECTED.rawValue)
//            
//            
//            let params: [String: Any] = [
//                "sendTo"                :  self.receiverId,
//                "title"                 :  "Audio Call Ended",
//                "message"               :  "Audio Call",
//                "notificationType"      :  NotificationType.AUDIO_CALL_DISCONNECT.rawValue,
//                "callId"                :   kSharedUserDefaults.getCallId(),
//                "name"                  :  kSharedUserDefaults.getCallerName(),
//                "profileImage"          :  kSharedUserDefaults.getProfileImg()
//            ]
//            //send notification
//            connectVideoCallAPI(url: ServiceName.nationality, params: kSharedInstance.getDictionary(params))
//            
//            
//        }
//        if isComingFromChat {
//            self.dismiss(animated: true) {
//                self.callBack?()
//            }
//        }else {
//           // kSharedAppDelegate?.moveToTabBar(selectedIndex: 1)
//        }
//    }
//    
//}
//
//extension VoiceChatViewController{
//    
//    
//    func playVibrate(ringTone : String){
//        
//        AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil,
//                                              nil,
//                                              { (_:SystemSoundID, _:UnsafeMutableRawPointer?) -> Void in
//                                                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//                                              },
//                                              nil)
//        let url = URL(fileURLWithPath: Bundle.main.path(forResource: ringTone, ofType: "mp3")!)
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
//            
//            print("audioPlayer error \(err.localizedDescription)")
//            
//            return
//            
//        } else {
//            
//            audioPlayer!.delegate = self
//            
//            audioPlayer!.prepareToPlay()
//            
//        }
//        
//        audioPlayer!.numberOfLoops = -1
//        audioPlayer!.play()
//    }
//    
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
//    
//}
//
//
//enum CallState : String {
//    case CONNECTING     = "0"
//    case RINGING        = "1"
//    case CONNECTED      = "2"
//    case REJECTED       = "3"
//    case DISCONNECTED   = "4"
//    case NOT_ANSWERED   = "5"
//}
//
//enum CallType : String {
//    case AUDIO_CALL         = "0"
//    case VIDEO_CALL         = "1"
//}
//
//enum NotificationType : String {
//    case VIDEO_CALL_INCOMING     = "VIDEO_CALL_INCOMING"
//    case VIDEO_CALL_DISCONNECT   = "VIDEO_CALL_DISCONNECT"
//    case VIDEO_CALL_REJECT       = "VIDEO_CALL_REJECT"
//    case VIDEO_CALL_ACCEPT       = "VIDEO_CALL_ACCEPT"
//    
//    case GROUP_VIDEO_CALL_INCOMING   = "GROUP_VIDEO_CALL_INCOMING"
//    case GROUP_VIDEO_CALL_ENDED = "GROUP_VIDEO_CALL_DISCONNECT"
//    case GROUP_VIDEO_CALL_REJECT = "GROUP_VIDEO_CALL_REJECT"
//    case GROUP_VIDEO_CALL_ACCEPT = "GROUP_VIDEO_CALL_ACCEPT"
//    
//    case AUDIO_CALL_INCOMING     = "AUDIO_CALL_INCOMING"
//    case AUDIO_CALL_DISCONNECT   = "AUDIO_CALL_DISCONNECT"
//    case AUDIO_CALL_REJECT       = "AUDIO_CALL_REJECT"
//    case AUDIO_CALL_ACCEPT       = "AUDIO_CALL_ACCEPT"
//    
//    case GROUP_AUDIO_CALL_INCOMING     = "GROUP_AUDIO_CALL_INCOMING"
//    case GROUP_AUDIO_CALL_DISCONNECT   = "GROUP_AUDIO_CALL_DISCONNECT"
//    case GROUP_AUDIO_CALL_REJECT       = "GROUP_AUDIO_CALL_REJECT"
//    case GROUP_AUDIO_CALL_ACCEPT       = "GROUP_AUDIO_CALL_ACCEPT"
//    
//    case EXTEND_REQUEST              = "EXTEND_REQUEST"
//    case EXTEND_REQUEST_ACCEPT       = "EXTEND_REQUEST_ACCEPT"
//    case EXTEND_REQUEST_REJECT       = "EXTEND_REQUEST_REJECT"
//}
