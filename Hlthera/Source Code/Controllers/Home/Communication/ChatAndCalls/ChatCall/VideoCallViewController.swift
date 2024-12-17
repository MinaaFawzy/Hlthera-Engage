////
////  VideoCallViewController.swift
////  Kindling
////
////  Created by Mohd Aslam on 30/09/20.
////  Copyright © 2020 fluper. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//import AVKit
//import AgoraRtcKit
//
//class VideoCallViewController: UIViewController, AVAudioPlayerDelegate {
//
//    @IBOutlet weak var remoteVideo: UIView!
//    @IBOutlet weak var localVideo: UIView!
//    @IBOutlet weak var controlButtons: UIView!
//    @IBOutlet weak var remoteVideoMutedIndicator: UIImageView!
//    @IBOutlet weak var localVideoMutedBg: UIImageView!
//    @IBOutlet weak var localVideoMutedIndicator: UIImageView!
//    @IBOutlet weak var timeLbl: UILabel!
//    @IBOutlet weak var connectingLbl: UILabel!
//    @IBOutlet weak var lblUserName: UILabel!
//    @IBOutlet weak var btnEndCall: UIButton!
//    
//    var titleStr = ""
//    var receiverId = String()
//    var userId = String()
//    
//    var callStatusKey = String()
//    
//    var agoraKit: AgoraRtcEngineKit!
//    let appController = AppController.sharedInstance()
//    var ishangoutBtnTapped = false
//    var isComingFromChat = false
//    var isChennalBusy = false
//    var audioPlayer   : AVAudioPlayer?
//    var chennalName = ""
//    var timer:Timer!
//    var seconds = 0
//    var callBack:(()->())?
//    var senderName = ""
//    var senderImage = ""
//    var receiverName = ""
//    var receiverImage = ""
//    var profileUrl = ""
//    var userDetails = kSharedUserDefaults.getLoggedInUserDetails()
//    var appointmentDetails:AppointmentList?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        localVideo.clipsToBounds = true
//        lblUserName.text = String.getString(kSharedUserDefaults.getCallerName())
//        NotificationCenter.default.addObserver(self, selector: #selector(startVideoChat), name: Notification.Name("UpdatVideoChatTimer"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(extendRejected), name: Notification.Name("ExtendRequestRejected"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(extendAccepted), name: Notification.Name("ExtendRequestAccepted"), object: nil)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        userId = String.getString(self.userDetails[Parameters.user_id])
//        senderName = String.getString(self.userDetails[Parameters.name])
//        senderImage = String.getString(self.userDetails[kProfilePicture])
//        receiverId = kSharedUserDefaults.getCallerId()
//        
//        if kSharedAppDelegate?.isVideoCallOn ?? false{
//            videoCallConnection()
//        }else{
//            self.initateVideoCall()
//        }
//    }
//    
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        setDefaultValue()
//        leaveChannel()
//        audioPlayer?.stop()
//        if timer != nil {
//            timer.invalidate()
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
//    @objc func startVideoChat(notification: NSNotification) {
//            connectingLbl.isHidden = true
//            timeLbl.isHidden = false
//            if timer == nil {
//                timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector:#selector(self.startTimer(timer:)), userInfo:nil, repeats:true)
//            }
//        }
//        
//        @objc func startTimer(timer: Timer) {
//            seconds = seconds + 1
//            let hr = seconds / 3600
//            let min = ((seconds % 3600) / 60)
//            let sec = ((seconds % 3600) % 60)
//            let totalTimeString = String(format: "%02d:%02d:%02d",hr, min, sec)
//            timeLbl.text = "\(totalTimeString)"
//            if seconds == 3600 * Int(Double.getDouble(self.appointmentDetails?.duration)){
//                print("Extend")
////                guard let vc = self.storyboard?.instantiateViewController(identifier: Identifiers.kAppointmentExtendPopUp) as? AppointmentExtendPopUpViewController else {return}
////                vc.appointmentDetails = self.appointmentDetails
////                vc.communicationType = .video
////                vc.homeCallBack = {
////                    kSharedAppDelegate?.moveToTabBar(selectedIndex: 0)
////                }
////                vc.extendCallBack = {
////                    guard let vc = self.storyboard?.instantiateViewController(identifier: "ExtendRequestPopUpViewController") as? ExtendRequestPopUpViewController else {return}
////                    vc.modalTransitionStyle = .crossDissolve
////                    vc.modalPresentationStyle = .overCurrentContext
////                    vc.receiverId = self.receiverId
////                    vc.communicationType = .audio
////                    vc.appointmentDetails = self.appointmentDetails
////                    vc.senderName = String.getString(self.userDetails[Parameters.sendername])
////                    vc.senderImage = String.getString(self.userDetails[Parameters.senderImage])
////                    vc.submitCallBack = {
////                        self.getAppointmentDetails(bookingId: String.getString(String.getString(kSharedUserDefaults.getAppointmentId())))
////                    }
////                    self.present(vc, animated: true)
////                }
////                self.present(vc, animated: true)
//            }
//        }
//    
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
//                default:
//                    self.showSimpleAlert(message: String.getString(dictResult[kMessage]))
//                }
//            } else {
//                self.showSimpleAlert(message: AlertMessage.kDefaultError)
//            }
//        }
//    }
//    
////    func SendtextMessage() {
////        //saveMessageLocallyInDatabase(mediaurl: "", mediatype: "text", message: String.getString(self.chatTextView.text), thumnilimageurl: "")
////        let timeStamp = String.getString(Int(Date().timeIntervalSince1970 * 1000))
////        let completeName = self.userDetails[Parameters.name] as? String ?? ""
////
////        let dic = [Parameters.senderid: String.getString(self.userDetails[Parameters.user_id]), Parameters.content: "Video call" , Parameters.timeStamp : timeStamp , Parameters.receiverid  : kSharedUserDefaults.getCallerId()  , Parameters.thumnilimageurl : "" , Parameters.mediatype : "call" ,  Parameters.isDeleted : kSharedUserDefaults.getCallerId() , Parameters.mediaurl :  "" , Parameters.groupid :  "",Parameters.groupname : "","from_name" : completeName, "to_name" : kSharedUserDefaults.getCallerName(), Parameters.status : "not_seen"]
////
////
////        Chat_hepler.Shared_instance.SendMessage(dic: kSharedInstance.getDictionary(dic), Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: kSharedUserDefaults.getCallerId(), bookingId: )
////
////            //Func for resend users
////        Chat_hepler.Shared_instance.ResentUser(lastmessage:  "Video call", Receiverid: String.getString(kSharedUserDefaults.getCallerId()), Senderid: String.getString(self.userDetails[Parameters.user_id]), name: kSharedUserDefaults.getCallerName(), profile_image: kSharedUserDefaults.getProfileImg(), readState: "not_seen", isMsgSend: true, lastTimestamp: timeStamp, msgReceiverId: kSharedUserDefaults.getCallerId(), unreadCount: 1, friendStatus: true, callStatus: CallState.REJECTED.rawValue)
////
////    }
//    
//    func initateVideoCall(){
//        
//        if self.receiverId < self.userId{
//            kSharedUserDefaults.setChennalName(chennalName: self.receiverId + "_" + self.userId)
//        }else{
//            kSharedUserDefaults.setChennalName(chennalName: self.userId + "_" + self.receiverId)
//        }
//        
//        
//        let timeStamp = String.getString(Int(Date().timeIntervalSince1970 * 1000))//UInt64(Date().timeIntervalSince1970 * 1000)
//        let groupDetails = [Parameters.receiverid: String.getString(self.receiverId), Parameters.receivername: receiverName, Parameters.receiverImage: profileUrl, Parameters.sendername: senderName, Parameters.senderImage: senderImage, "call_type": CallType.VIDEO_CALL.rawValue , "timeStamp" : timeStamp , "message" : "Ringing", "call_status": CallState.CONNECTING.rawValue] as [String : Any]
//        Chat_hepler.Shared_instance.addOneToOneCalltoFirebase(callDic: kSharedInstance.getDictionary(groupDetails)) { (callid) in
//            print("call id ====== \(callid)")
//            kSharedUserDefaults.setCallId(name: callid)
//                        
//            let params: [String: Any] = [
//                "sendTo"                  :  self.receiverId,
//                "title"                   :  "Video Call",//"Kindling",
//                "message"                 :  "Video Call",
//                "notificationType"        :  NotificationType.VIDEO_CALL_INCOMING.rawValue,
//                "callId"                  :   callid,
//                "name"                    :  self.senderName,
//                "profileImage"            :  self.senderImage
//            ]
//            //send notification
//            self.connectVideoCallAPI(url: ServiceName.nationality, params: kSharedInstance.getDictionary(params))
//            //self.SendtextMessage()
//            self.videoCallConnection()
//        }
//    }
//    
//    
//    func videoCallConnection(){
//        connectingLbl.isHidden = true
//        setupButtons()
//        hideVideoMuted()
//        initializeAgoraEngine()
//        setupVideo()
//        setupLocalVideo()
//        joinChannel()
//    }
//    
//    // Tutorial Step 1
//    func initializeAgoraEngine() {
//        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: Agora_AppID, delegate: self)
//    }
//    
//    // Tutorial Step 2
//    func setupVideo() {
//        agoraKit.enableVideo()  // Default mode is disableVideo
//        agoraKit.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension640x360,
//                                                                             frameRate: .fps15,
//                                                                             bitrate: AgoraVideoBitrateStandard,
//                                                                             orientationMode: .adaptative))
//    }
//    
//    // Tutorial Step 3
//    
//    func setupLocalVideo() {
//        let videoCanvas = AgoraRtcVideoCanvas()
//        videoCanvas.uid = 0
//        videoCanvas.view = localVideo
//        videoCanvas.renderMode = .fit
//        agoraKit.setupLocalVideo(videoCanvas)
//    }
//    
//    // Tutorial Step 4
//    
//    func joinChannel() {
//        print("Channel name === \(String.getString(kSharedUserDefaults.getChennalName()))")
//        agoraKit.joinChannel(byToken: nil, channelId: String.getString(kSharedUserDefaults.getChennalName()) , info:nil, uid:0) {[weak self] (sid, uid, elapsed) -> Void in
//            if let weakSelf = self {
//                weakSelf.agoraKit.setEnableSpeakerphone(true)
//                UIApplication.shared.isIdleTimerDisabled = true
//            }
//        }
//        
//    }
//    
//    
//    func callDisconnectApi() {
//        
//        audioPlayer?.stop()
//        AudioServicesPlaySystemSound(SystemSoundID(truncating: false))
//
//        var params: [String: Any] = [:]
//       
//        Chat_hepler.Shared_instance.updateCallDataOnFirebase(callId: kSharedUserDefaults.getCallId(), callStatus: CallState.DISCONNECTED.rawValue)
//            
//        
//            //if kSharedAppDelegate.isVideoCallOn == true{
//                params = [
//                    "sendTo"                  :  self.receiverId,
//                    "title"                   :  "Video Call Ended",
//                    "message"                 :  "\(kSharedUserDefaults.getCallerName()) ended call",
//                    "notificationType"        :  NotificationType.VIDEO_CALL_DISCONNECT.rawValue ,
//                    "callId"                  :   kSharedUserDefaults.getCallId(),
//                    "name"                    :  kSharedUserDefaults.getCallerName(),
//                    "profileImage"            :  kSharedUserDefaults.getProfileImg()
//                    ]
//            //}
//        //send notification
//            self.connectVideoCallAPI(url: ServiceName.nationality, params: kSharedInstance.getDictionary(params))
//           
//        
//        if isComingFromChat {
//            self.dismiss(animated: true) {
//                self.callBack?()
//            }
//        }else {
//            //kSharedAppDelegate?.moveToTabBar(selectedIndex: 1)
//        }
//    }
//    
//    func callDismiss(){
//        callDisconnectApi()
//        leaveChannel()
//        setDefaultValue()
//        audioPlayer?.stop()
//        
//    }
//    
//    func setDefaultValue(){
//        audioPlayer?.stop()
//    }
//    
//    func leaveChannel() {
//        kSharedAppDelegate?.isVideoCallOn = false
//        agoraKit.leaveChannel(nil)
//        hideControlButtons()
//        UIApplication.shared.isIdleTimerDisabled = false
//        if remoteVideo != nil {
//            remoteVideo.removeFromSuperview()
//            localVideo.removeFromSuperview()
//        }
//    }
//    
//    // Tutorial Step 8
//    func setupButtons() {
//        perform(#selector(hideControlButtons), with:nil, afterDelay:8)
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(VideoCallViewController.ViewTapped))
//        view.addGestureRecognizer(tapGestureRecognizer)
//        view.isUserInteractionEnabled = true
//    }
//    
//    @objc func hideControlButtons() {
//        controlButtons.isHidden = true
//        btnEndCall.isHidden = true
//    }
//    
//    @objc func ViewTapped() {
//        if (controlButtons.isHidden) {
//            controlButtons.isHidden = false
//            btnEndCall.isHidden = false
//            perform(#selector(hideControlButtons), with:nil, afterDelay:8)
//        }
//    }
//    
//    func resetHideButtonsTimer() {
//        ConversationListViewController.cancelPreviousPerformRequests(withTarget: self)//change
//        perform(#selector(hideControlButtons), with:nil, afterDelay:8)
//    }
//    
//    func hideVideoMuted() {
//        remoteVideoMutedIndicator.isHidden = true
//        localVideoMutedBg.isHidden = true
//        localVideoMutedIndicator.isHidden = true
//    }
//    
//    //Mark:-Incoming Ringtone
//        func setIncomingRingtone() {
//            let fileURL: URL = URL(fileURLWithPath: "\("/Library/Ringtones")/\("Opening.m4r")")
//            do {
//                appController.audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
//                appController.audioPlayer.play()
//                appController.audioPlayer.volume = 1.0
//                appController.audioPlayer.numberOfLoops = 6
//            } catch {
//                debugPrint("\(error)")
//            }
//        }
//        
//        //Incoming video call
//        func incomingVideoCall() {
//            NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("APIKeys.connection_request"), object: nil)
//        }
//        
//        @objc func methodOfReceivedNotification(notification: Notification) {
//    //        self.incomingCallingScreen.isHidden  = false
//    //        self.outgoingVideoCallSreen.isHidden = true
//    //        self.switchCameraButton.isHidden     = true
//    //        self.hangUpCallButton.isHidden       = true
//            self.localVideo.isHidden               = true
//        }
//    
//    func playVibrate(ringTone : String){
//        
//        AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil,
//                                              nil,
//                                              { (_:SystemSoundID, _:UnsafeMutableRawPointer?) -> Void in
//                                                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//        },
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
//    func disconnectCall() {
//        ishangoutBtnTapped = true
//        if !isChennalBusy{
//            callDismiss()
//        }
//        audioPlayer?.stop()
//        if isComingFromChat {
//            self.dismiss(animated: true) {
//                self.callBack?()
//            }
//        }else {
//           // kSharedAppDelegate?.moveToTabBar(selectedIndex: 1)
//        }
//    }
//    
//    //MARK:- IBActions
//    @IBAction func tapSwitchSpeakerBtn(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        agoraKit.setEnableSpeakerphone(sender.isSelected)
//    }
//    
//    @IBAction func tapSwitchCamera(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        agoraKit.switchCamera()
//        resetHideButtonsTimer()
//    }
//    
//    @IBAction func didClickMuteButton(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        agoraKit.muteLocalAudioStream(sender.isSelected)
//        resetHideButtonsTimer()
//    }
//    
//    // Tutorial Step 10
//    @IBAction func didClickVideoMuteButton(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        agoraKit.muteLocalVideoStream(sender.isSelected)
//        localVideo.isHidden = sender.isSelected
//        localVideoMutedBg.isHidden = !sender.isSelected
//        localVideoMutedIndicator.isHidden = !sender.isSelected
//        resetHideButtonsTimer()
//    }
//    
//    
//    @IBAction func tapEndCallBtn(_ sender: UIButton) {
//        
//        ishangoutBtnTapped = true
//        if !isChennalBusy{
//            callDismiss()
//        }
//        audioPlayer?.stop()
//        if isComingFromChat {
//            self.dismiss(animated: true) {
//                self.callBack?()
//            }
//        }else {
//           // kSharedAppDelegate?.moveToTabBar(selectedIndex: 1)
//        }
//    }
//}
//
//
//extension VideoCallViewController: AgoraRtcEngineDelegate {
//    // Tutorial Step 5
//    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
//        if (remoteVideo.isHidden) {
//            remoteVideo.isHidden = false
//        }
//        let videoCanvas = AgoraRtcVideoCanvas()
//        videoCanvas.uid = uid
//        videoCanvas.view = remoteVideo
//        videoCanvas.renderMode = .adaptive
//        agoraKit.setupRemoteVideo(videoCanvas)
//        audioPlayer?.stop()
//    }
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
//        leaveChannel()
//        print("leave channel")
//    }
//    
//    // Tutorial Step 7
//    internal func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
//        self.remoteVideo.isHidden = true
//        if !(kSharedAppDelegate?.isVideoCallOn ?? false) {
//            setDefaultValue()
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
//    // Tutorial Step 10
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
//        remoteVideo.isHidden = muted
//        remoteVideoMutedIndicator.isHidden = !muted
//    }
//}
//
//
//extension VideoCallViewController {
//    func postNotification(callStatus:String){
//                
//        let params: [String: Any] = [
//            "sendTo"                  :  self.receiverId,
//            "title"                   :  "Video Call",
//            "message"                 :  "Hi",
//            "notificationType"        :  callStatus ,
//            "name"                    :  kSharedUserDefaults.getCallerName(),
//            "profileImage"            :  kSharedUserDefaults.getProfileImg()
//            ]
//        
//        CommonUtils.showHudWithNoInteraction(show: true)
//        //send notification
//        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.nationality,
//                                                   requestMethod: .POST,
//                                                   requestParameters: params, withProgressHUD: false)
//        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
//            
//            CommonUtils.showHudWithNoInteraction(show: false)
//            if errorType == .requestSuccess {
//                
//                switch Int.getInt(statusCode) {
//                case 200:
//                    print("Notification Sent")
//                    let videocallVc = self.storyboard?.instantiateViewController(withIdentifier: "VideoCallViewController") as! VideoCallViewController
//                    self.present(videocallVc, animated: true, completion: nil)
//                    
//                default:
//                    print("")
//                }
//            }
//        }
//        
//    }
//}
//
//extension VideoCallViewController{
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
//    
//}
