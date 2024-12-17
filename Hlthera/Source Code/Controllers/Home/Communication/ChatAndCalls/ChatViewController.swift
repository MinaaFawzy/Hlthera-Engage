////
////  ChatViewController.swift
////  Kindling
////
////  Created by Mohd Aslam on 29/12/20.
////
//
//import UIKit
//import IQKeyboardManagerSwift
//import AVKit
//import AVFoundation
//import ISEmojiView
//import iRecordView
//import MobileCoreServices
//
//class ChatViewController: UIViewController, AVAudioRecorderDelegate {
//    
//    //MARK:- Outlets
//    @IBOutlet weak var navView:UIView!
//    @IBOutlet weak var userImgView: UIImageView!
//    @IBOutlet weak var userNameLbl: UILabel!
//    @IBOutlet weak var footerView: UIView!
//    @IBOutlet weak var chatTblView: UITableView!
//    @IBOutlet weak var btnSend: UIButton!
//    @IBOutlet weak var chatTextView: IQTextView!
//    @IBOutlet var txtMessageHTConstant: NSLayoutConstraint!
//    @IBOutlet var bottomViewBottmConstraint: NSLayoutConstraint!
//    @IBOutlet weak var imgBtnSend: UIImageView!
//    @IBOutlet weak var viewProfile: UIView!
//    @IBOutlet weak var buttonBack: UIButton!
//    @IBOutlet weak var btnAttachment: UIButton!
//    @IBOutlet weak var viewTyping: UIView!
//    @IBOutlet weak var typingUserImg: UIImageView!
//    @IBOutlet weak var lblTypingName: UILabel!
//    @IBOutlet weak var viewBg: UIView!
//    @IBOutlet weak var viewMediaOptions: UIView!
//    @IBOutlet weak var labelAppointmentId: UILabel!
//    @IBOutlet weak var labelTimer: UILabel!
//    @IBOutlet weak var labelAppointmentDate: UILabel!
//    var communicationList:CommunicationList?
//    var selectedCommunicationType = 0
//    var callBack:((_ selectedCommunicationType:Int)->())?
//    //MARK:- Variables
//    let textViewMaxHeight:CGFloat = 100.0
//    let textViewMinHeight:CGFloat = 34.0
//    var userDetails = kSharedUserDefaults.getLoggedInUserDetails()
//    var receiverid  =  String()
//    var receivername = String()
//    var CreatedBy = String()
//    var receiverprofile_image = String()
//    var Messageclass:[MessageClass] = []
//    var readmessagesCountCheck = false
//    var ChatBackup :[ChatbackupOnetoOne]?
//    var MessageObjList = [MessageObject]()
//    var player:AVPlayer?
//    //var playerItem:AVPlayerItem?
//    var audioRecorder: AVAudioRecorder!
//    var audioPlayer: AVAudioPlayer?
//    var meterTimer:Timer!
//    var playerTimer:Timer!
//    var isAudioRecordingGranted = false
//    var isRecording = false
//    var isPlaying = false
//    let recordedAudioFileName = "RecordingClip.m4a"
//    let fileManager = FileManager.default
//    var longGesture: UILongPressGestureRecognizer?
//    var moveGesture: UIPanGestureRecognizer?
//    //var usermodel   : UserProfileModel?
//    var isDeleted = false
//    var slideConnstant = 0
//    var isRecordingCancel = false
//    var isComingFromUserProfile = false
//    var unread_count = 0
//    var isSearchOn = false
//    var searchList = [String]()
//    var selectedSearchIndex = 0
//    var isUserBlocked = false
//    var isCallback = false
//    var isAnimated = false
//    var isFriend = true
//    var senderIdStr = ""
//    var isBlock = false
//    var chatCallback: (() ->Void)? = nil
//    var bookingId:String?
//    var timer = Timer()
//    var count = 0
//    //MARK:- View Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.getAppointmentDetails(bookingId:String.getString(self.bookingId))
//        viewBg.clipsToBounds = true
//        senderIdStr = String.getString(self.userDetails[Parameters.user_id])
//        
//       // navView.addShadowWithBlurOnView(navView, spread: 0, blur: 6, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 3)
//       // self.view.applyGradient(isTopBottom: false, colorArray: [CustomColor.kDarkRed ,CustomColor.kLightRed])
//        DispatchQueue.main.async {
//        //    self.view.applyGradient(isTopBottom: false, colorArray: [CustomColor.kDarkRed ,CustomColor.kLightRed])
//        }
//        
//        let ResentUser = ResentUsers.fetchResentListFromDatabase()
//        for object in ResentUser ?? [] {
//            var recId = object.Receiverid
//            if recId == String.getString(self.userDetails[Parameters.user_id]) {
//                recId = object.Senderid
//            }
//            if recId == self.receiverid {
//                self.isFriend = object.isFriend
//                break
//            }
//        }
//        
//        //hideKeyboardWhenTappedAround(views: self.chatTblView)
//        chatTblView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
//        
//        initialSetup()
//        registerNib()
//        self.Messageclass = MessageList.fetchMessagesForUser(userid: self.receiverid, bookingId: String.getString(self.communicationList?.appointmentID)) ?? []
//        self.filterMessageArray()
//        self.chatTblView.reloadData()
//        self.scrollToBottom(animated : false)
//        perform(#selector(changeScrollStatus), with: nil, afterDelay: 3)
//        if self.Messageclass.count == 0 {
//            CommonUtils.showHudWithNoInteraction(show: true)
//        }
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(Notifications.kChatNotificationReceived), object: nil, queue: nil) { (notification) in
//            
//            self.Messageclass = MessageList.fetchMessagesForUser(userid: self.receiverid, bookingId: String.getString(self.communicationList?.appointmentID)) ?? []
//            self.filterMessageArray()
//            self.chatTblView.reloadData()
//            self.scrollToBottom(animated : true)
//        }
//        NotificationCenter.default.addObserver(self, selector: #selector(extendAccepted), name: Notification.Name("ExtendRequestAccepted"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(extendRejected), name: Notification.Name("ExtendRequestRejected"), object: nil)
//        self.ReceiveMessage()
//        Chat_hepler.Shared_instance.getUeadCountForAConversation(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: self.receiverid) { (count, success) in
//            if success {
//                self.unread_count = count
//                if !self.isCallback {
//                    self.isCallback = true
//                    
//                    self.refreshReceiverDetailOnFirebase()
//                }
//            }
//        }
//        
//        self.setStatusBar(color: #colorLiteral(red: 0.3490196078, green: 0.4862745098, blue: 0.9254901961, alpha: 1))
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        IQKeyboardManager.shared.enable = false
//        //IQKeyboardManager.shared.enableAutoToolbar = false
//        chatTblView.reloadData()
//        registerKeyboardNotifications()
//        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        //DispatchQueue.main.async {
//        Chat_hepler.Shared_instance.readMessageCountForAConversation(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: self.receiverid)
//        //}
//        getTypingStatus()
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(true)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        self.timer.invalidate()
//        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.enableAutoToolbar = true
//        self.player?.pause()
//        NotificationCenter.default.removeObserver(NSNotification.Name.AVPlayerItemDidPlayToEndTime)
//        
//        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
//        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
//    }
//    
//    @objc func swipeLeft(sender: UISwipeGestureRecognizer){
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    @objc func changeScrollStatus() {
//        self.isAnimated = true
//    }
//    
//    
//    @objc func extendAccepted(notification: NSNotification) {
//        guard let vc = self.storyboard?.instantiateViewController(identifier: "ExtendAcceptedPopUpViewController") as? ExtendAcceptedPopUpViewController else {return}
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
//        vc.dismissCallBack = {
//            self.getAppointmentDetails(bookingId: String.getString(self.bookingId))
//        }
//        self.present(vc, animated: true)
//    }
//    
//    @objc func extendRejected(notification: NSNotification) {
//        guard let vc = self.storyboard?.instantiateViewController(identifier: "ExpertRejectedViewController") as? ExpertRejectedViewController else {return}
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
//        vc.dismissCallBack = {
//            self.getAppointmentDetails(bookingId: String.getString(self.bookingId))
//        }
//        self.present(vc, animated: true)
//    }
//    
//    
//    //MARK:- Private Functions
//    private func initialSetup() {
//        chatTblView.rowHeight = UITableView.automaticDimension
//        //footerView.addShadowWithBlurOnView(footerView, spread: 0, blur: 12, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 0)
//        userNameLbl.text = receivername
//        let url = kImageDownloadURL + receiverprofile_image
//        userImgView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "user_create_profile"), options: .highPriority, completed: nil)
//        self.labelAppointmentId.text = "Appointment Id: \(String.getString(self.communicationList?.appointmentID))"
//        self.labelAppointmentDate.text = String.getString(self.communicationList?.bookingDate)
//        //        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressOnRecordingBtn(_:)))
//        //        btnRecording.addGestureRecognizer(longGesture!)
//        
//        //        moveGesture = UIPanGestureRecognizer(target: self, action: #selector(touchMoved(_:)))
//        //        //moveGesture.delegate = self
//        //        btnRecording.addGestureRecognizer(moveGesture!)
//    }
//    
//    func getAppointmentDetails(bookingId:String){
//        //get appointment details
//        CommonUtils.showHudWithNoInteraction(show: true)
//        let params:[String:Any] = [ApiParameters.booking_id:bookingId]
//        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.bookAppointment,
//                                                   requestMethod: .POST,
//                                                   requestParameters: params, withProgressHUD: false)
//        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
//            CommonUtils.showHudWithNoInteraction(show: false)
//            if errorType == .requestSuccess {
//                let dictResult = kSharedInstance.getDictionary(result)
//                switch Int.getInt(statusCode) {
//                case 200:
//                    let data = kSharedInstance.getDictionary(dictResult["response"])
//                    self.communicationList = CommunicationList.init(data:data)
//                    self.labelAppointmentId.text = "Appointment ID: " + String.getString(self.communicationList?.appointmentID)
//                    self.labelAppointmentDate.text = self.communicationList?.bookingDate
//                    self.count = 3600 * Int(Double.getDouble(self.communicationList?.duration))
////                    self.count = 2400
//                    DispatchQueue.main.async{
//                        self.startTimer()
//                    }
//                default:
//                    self.showSimpleAlert(message: String.getString(dictResult[kMessage]))
//                }
//            } else {
//                self.showSimpleAlert(message: AlertMessage.kDefaultError)
//            }
//        }
//    }
//    
//    private func getTypingStatus() {
//        Chat_hepler.Shared_instance.getTypingStat(receiverid: self.receiverid) { (status) in
//            if status ?? 0 == 1 {
//                self.lblTypingName.text = "\(self.receivername) is typing..."
//                self.viewTyping.isHidden = false
//                self.typingUserImg.image = self.userImgView.image
//            }else {
//                self.viewTyping.isHidden = true
//            }
//        }
//    }
//
//    func startTimer(){
//        let startServiceTimeStamp = String.getString(self.communicationList?.createdOn)
//        let startServiceTimeStampInt = Int.getInt(startServiceTimeStamp)/1000
//        let startD = Date(timeIntervalSince1970: Double(String.getString(startServiceTimeStampInt)) ?? 0.0)
//        let endD = Date(timeIntervalSince1970: Double(String.getString(Int(Date().timeIntervalSince1970))) ?? 0.0)
//        let diffInDays = Calendar.current.dateComponents([.second], from: startD, to: endD)
//        if diffInDays.second < count {
//            if diffInDays.second<0{
//                print("Booking Completed")
//            }
//            count = count - (diffInDays.second ?? 0)
//            timer.invalidate()
//            timer = Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
//        }
//        else {
//            self.labelTimer.text = "Completed"
//            timer.invalidate()
//        }
//    }
//    
//    @objc func updateCounter() {
//            if count > 0 {
//                let hours = count / 3600 < 10 ? "0\(count / 3600)":"\(count / 3600)"
//                let minutes = (count % 3600) / 60 < 10 ? "0\((count % 3600) / 60)":"\((count % 3600) / 60)"
//                let seconds = ((count % 3600) % 60) < 10 ? "0\(((count % 3600) % 60))":"\((count % 3600) % 60)"
//                print("\(String(hours)):\(String(minutes)):\(String(seconds))")
//                self.labelTimer.text = "\(String(hours)):\(String(minutes)):\(String(seconds))"
//                count -= 1
//            } else {
//                self.timer.invalidate()
//                self.labelTimer.text = "00:00:00"
//                //time extended
////                guard let vc = self.storyboard?.instantiateViewController(identifier: Identifiers.kAppointmentExtendPopUp) as? AppointmentExtendPopUpViewController else {return}
////                vc.modalTransitionStyle = .crossDissolve
////                vc.modalPresentationStyle = .overCurrentContext
////                vc.communicationList = self.communicationList
////                vc.communicationType = .chat
////                vc.receiverid = self.receiverid
////                vc.homeCallBack = {
////                    kSharedAppDelegate?.moveToTabBar(selectedIndex: 0)
////                }
////                vc.extendCallBack = {
////                    guard let vc = self.storyboard?.instantiateViewController(identifier: "ExtendRequestPopUpViewController") as? ExtendRequestPopUpViewController else {return}
////                    vc.modalTransitionStyle = .crossDissolve
////                    vc.modalPresentationStyle = .overCurrentContext
////                    vc.receiverId = self.receiverid
////                    vc.communicationList = self.communicationList
////                    vc.communicationType = .chat
////                    vc.senderName = String.getString(self.userDetails[Parameters.sendername])
////                    vc.senderImage = String.getString(self.userDetails[Parameters.senderImage])
////                    vc.submitCallBack = {
////                        self.getAppointmentDetails(bookingId: String.getString(self.bookingId))
////                    }
////                    self.present(vc, animated: true)
////                }
////                self.present(vc, animated: true)
//            }
//        }
//    
//    //Function for Register  Nib in for Table View
//    private func registerNib() {
//        self.chatTblView.register(UINib(nibName: cellidentifiers.SendertextCell, bundle: nil),   forCellReuseIdentifier: cellidentifiers.SendertextCell)
//        self.chatTblView.register(UINib(nibName: cellidentifiers.Receivertextcell, bundle: nil),  forCellReuseIdentifier: cellidentifiers.Receivertextcell)
//        self.chatTblView.register(UINib(nibName: cellidentifiers.SenderImageCell, bundle: nil), forCellReuseIdentifier: cellidentifiers.SenderImageCell)
//        self.chatTblView.register(UINib(nibName: cellidentifiers.ReceiverImageCell, bundle: nil),forCellReuseIdentifier: cellidentifiers.ReceiverImageCell)
//        self.chatTblView.register(UINib(nibName: cellidentifiers.SenderVideoCell, bundle: nil), forCellReuseIdentifier: cellidentifiers.SenderVideoCell)
//        self.chatTblView.register(UINib(nibName: cellidentifiers.ReceiverVideoCell, bundle: nil), forCellReuseIdentifier: cellidentifiers.ReceiverVideoCell)
//        self.chatTblView.register(UINib(nibName: cellidentifiers.SenderAudioCell, bundle: nil), forCellReuseIdentifier: cellidentifiers.SenderAudioCell)
//        self.chatTblView.register(UINib(nibName: cellidentifiers.ReceiverAudioCell, bundle: nil), forCellReuseIdentifier: cellidentifiers.ReceiverAudioCell)
//        self.chatTblView.register(UINib(nibName: cellidentifiers.MissedCallCell, bundle: nil), forCellReuseIdentifier: cellidentifiers.MissedCallCell)
//        self.chatTblView.register(UINib(nibName: cellidentifiers.SenderDocumentCell, bundle: nil), forCellReuseIdentifier: cellidentifiers.SenderDocumentCell)
//        self.chatTblView.register(UINib(nibName: cellidentifiers.ReceiverDocumentCell, bundle: nil), forCellReuseIdentifier: cellidentifiers.ReceiverDocumentCell)
//    }
//    
//    private func registerKeyboardNotifications(){
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    
//    func scrollToBottom(animated : Bool){
//        if !isDeleted {
//            //DispatchQueue.main.async {
//            if self.MessageObjList.count > 0 {
//                let arr = self.MessageObjList[self.MessageObjList.count-1].messages
//                let indexPath = IndexPath(row: arr.count-1, section: self.MessageObjList.count-1)
//                self.chatTblView.scrollToRow(at: indexPath, at: .bottom, animated: self.isAnimated )
//            }
//            //}
//        }else {
//            isDeleted = false
//        }
//        
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if player != nil {
//            isPlaying = false
//            player?.pause()
//        }
//    }
//    
//    //Callback to save image in Gallery
//    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
//        if let error = error {
//            CommonUtils.showToast(message: error.localizedDescription)
//        } else {
//            CommonUtils.showToast(message: "Image saved successfully")
//        }
//        CommonUtils.showHudWithNoInteraction(show: false)
//    }
//    
//    //Keyboard methods
//    func emojiKeyboard(){
//        let keyboardSettings = KeyboardSettings(bottomType: .categories)
//        let emojiView = EmojiView(keyboardSettings: keyboardSettings)
//        emojiView.translatesAutoresizingMaskIntoConstraints = false
//        emojiView.delegate = self
//        //self.btnEmoji.isSelected = true
//        self.chatTextView.inputView = emojiView
//        self.chatTextView.reloadInputViews()
//        self.chatTextView.becomeFirstResponder()
//    }
//    func defaultKeyboard(){
//        //self.chatTextView.resignFirstResponder()
//        self.chatTextView.inputView = nil
//        self.chatTextView.keyboardType = .default
//        self.chatTextView.reloadInputViews()
//        self.chatTextView.becomeFirstResponder()
//        //self.btnEmoji.isSelected = false
//        
//    }
//    
//    @objc func dismissKeyboard() {
//        self.chatTextView.resignFirstResponder()
//        self.chatTextView.inputView = nil
//        self.chatTextView.keyboardType = .default
//        self.chatTextView.reloadInputViews()
//        //self.btnEmoji.isSelected = false
//        view.endEditing(true)
//    }
//    
//    func hideKeyboardWhenTappedAround(views : UIView) {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        views.addGestureRecognizer(tap)
//    }
//    
//    //More options method
//    private func deleteConversationAction() {
////        let story = UIStoryboard(name: Storyboards.kDoctor, bundle: nil)
////        let controller = story.instantiateViewController(withIdentifier: Identifiers.kCustomAlertPopupVC) as! CustomAlertPopupVC
////        controller.titleStrr = "Are you sure you want to delete this conversation?"
////        self.present(controller, animated: true) {
////            controller.deleteCallBack = {
////
////                Chat_hepler.Shared_instance.ClearChat(msgclass: self.Messageclass, Senderid: self.senderIdStr, Receiverid: String.getString(self.receiverid))
////                CommonUtils.showHudWithNoInteraction(show: true)
////                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
////                    CommonUtils.showHudWithNoInteraction(show: false)
////                    CommonUtils.showToast(message: "All chat cleared")
////                    //Chat_hepler.Shared_instance.removeFromresent(senderid: String.getString(self.userDetails[Parameters.user_id]), receiverid: String.getString(self.receiverid))
////                    let node = self.senderIdStr < String.getString(self.receiverid) ? "\(String.getString(self.senderIdStr))_\(String.getString(self.receiverid))" :  "\(String.getString(self.receiverid))_\(String.getString(self.senderIdStr))"
////                    MessageList.deleteMessagesForUser(userid: node)
////                    self.Messageclass.removeAll()
////                    self.MessageObjList.removeAll()
////                    self.chatTblView.reloadData()
////                    Chat_hepler.Shared_instance.removeFromresent(Senderid: self.senderIdStr, Receiverid: String.getString(self.receiverid))
////                }
////
////            }
////        }
//    }
//    
//    private func blockUser() {
////        let story = UIStoryboard(name: Storyboards.kChat, bundle: nil)
////        let controller = story.instantiateViewController(withIdentifier: Identifiers.kCustomAlertPopupVC) as! CustomAlertPopupVC
////        controller.titleStrr = self.isBlock ? "Are you sure you want to unblock this user?" : "Are you sure you want to block this user?"
////        self.present(controller, animated: true) {
////            controller.deleteCallBack = {
////
////                self.blockUnblockApi()
////            }
////        }
//    }
//    
//    private func searchMessages(searchText: String) {
//        
//        searchList.removeAll()
//        self.Messageclass.forEach { (message) in
//            let txtStr = String.getString(message.Message).lowercased()
//            if txtStr.contains(searchText.lowercased()) {
//                let msgId = String.getString(message.uid)
//                searchList.append(msgId)
//            }
//        }
//        chatTblView.reloadData()
//        selectedSearchIndex = searchList.count - 1
//        moveToSearchMessage()
//    }
//    
//    private func moveToSearchMessage() {
//        if selectedSearchIndex < 0 || selectedSearchIndex >= searchList.count{
//            CommonUtils.showToast(message:"No searched message found")
//            return
//        }
//        if searchList.count > selectedSearchIndex {
//            let msgId = String.getString(searchList[selectedSearchIndex])
//            
//            for section in 0..<self.MessageObjList.count {
//                let arr = self.MessageObjList[section].messages
//                for index in 0..<arr.count {
//                    let msgIdStr = String.getString(arr[index].uid)
//                    if msgId == msgIdStr {
//                        let indexPath = IndexPath(row: index, section: section)
//                        self.chatTblView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//                        break
//                    }
//                }
//            }
//        }
//        
//    }
//    
//    private func makeVideoCall() {
//        if let vc = UIStoryboard(name: "Chat", bundle: .main).instantiateViewController(withIdentifier: "VideoCallViewController") as? VideoCallViewController {
//            vc.titleStr = String.getString(self.receivername)
//            
//            kSharedUserDefaults.setCallerId(name: String.getString(self.receiverid))
//            kSharedUserDefaults.setChennalName(chennalName: String.getString(self.receiverid))
//            kSharedUserDefaults.setCallerName(name: String.getString(self.receivername))
//            kSharedUserDefaults.setProfileImg(name: String.getString(self.receiverprofile_image))
//            kSharedAppDelegate?.isGroupCall = false
//            vc.profileUrl = String.getString(self.receiverprofile_image)
//            vc.receiverName = String.getString(self.receivername)
//            vc.isComingFromChat = true
//            self.present(vc, animated: true, completion: nil)
//        }
//    }
//    
//    private func makeAudioCall() {
//        if let vc = UIStoryboard(name: "Chat", bundle: .main).instantiateViewController(withIdentifier: "VoiceChatViewController") as? VoiceChatViewController {
//            kSharedUserDefaults.setCallerId(name: String.getString(self.receiverid))
//            kSharedUserDefaults.setChennalName(chennalName: String.getString(self.receiverid))
//            kSharedAppDelegate?.isGroupCall = false
//            kSharedUserDefaults.setCallerName(name: String.getString(self.receivername))
//            kSharedUserDefaults.setProfileImg(name: String.getString(self.receiverprofile_image))
//            vc.receiverId = String.getString(self.receiverid)
//            vc.profileUrl = String.getString(self.receiverprofile_image)
//            vc.receiverName = String.getString(self.receivername)
//            vc.isComingFromChat = true
//            self.present(vc, animated: true, completion: nil)
//        }
//    }
//    
//    func openDocumentFile(mediaurl: String?, mediaName: String?) {
////        let story = UIStoryboard(name: Storyboards.kChat, bundle: nil)
////        let controller = story.instantiateViewController(withIdentifier: "OpenMediaFileVC") as! OpenMediaFileVC
////        controller.urlStr = String.getString(mediaurl)
////        controller.fileName = String.getString(mediaName)
////        self.navigationController?.pushViewController(controller, animated: true)
//        
//    }
//    
//    // MARK: -  Notification
//    @objc func keyboardWillShow(notification: NSNotification) {
//        var keyboardSize: CGSize = CGSize.zero
//        if let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
//            keyboardSize = value.cgRectValue.size
//            if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_X_MAX {
//                bottomViewBottmConstraint.constant = keyboardSize.height-34
//            }else {
//                bottomViewBottmConstraint.constant = keyboardSize.height
//            }
//            self.view.layoutIfNeeded()
//            scrollToBottom(animated: true)
//            
//        }
//    }
//    
//    @objc func keyboardWillHide(notification: NSNotification){
//        bottomViewBottmConstraint.constant = 10
//        self.view.layoutIfNeeded()
//    }
//    
//    //MARK:- Record Sound Methods
//    private func hideOrShowFooterView(isShow: Bool) {
//        btnSend.isHidden = isShow
//        imgBtnSend.isHidden = isShow
//        chatTextView.isHidden = isShow
//    }
//    
//    @objc func playerDidFinishPlaying(note: NSNotification) {
//        isPlaying = false
//        chatTblView.reloadData()
//    }
//    
//    @objc func longPressOnRecordingBtn(_ guesture: UILongPressGestureRecognizer) {
//        if guesture.state == .began {
//            print_debug(items: "Long Press started")
//            if !isRecording {
//                startRecording()
//            }
//        }else if guesture.state == .ended {
//            print_debug(items: "Long Press Ended")
//            stopRecording()
//        }
//    }
//    
//    private func deletePreviousFile() {
//        //        if fileManager.fileExists(atPath: CommonUtils.getFileUrl(fileName: recordedAudioFileName).path) {
//        //            do {
//        //                try fileManager.removeItem(atPath: CommonUtils.getFileUrl(fileName: recordedAudioFileName).path)
//        //            } catch {
//        //
//        //            }
//        //        }
//    }
//    
//    
//    //Check Recording Permission
//    private func check_record_permission() {
//        switch AVAudioSession.sharedInstance().recordPermission {
//        case AVAudioSession.RecordPermission.granted:
//            isAudioRecordingGranted = true
//            break
//        case AVAudioSession.RecordPermission.denied:
//            isAudioRecordingGranted = false
//            break
//        case AVAudioSession.RecordPermission.undetermined:
//            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
//                if allowed {
//                    self.isAudioRecordingGranted = true
//                } else {
//                    self.isAudioRecordingGranted = false
//                }
//            })
//            break
//        default:
//            break
//        }
//    }
//    
//    //Recording start
//    private func startRecording() {
//        check_record_permission()
//        deletePreviousFile()
//        setup_recorder()
//        if audioRecorder != nil {
//            audioRecorder.record()
//            hideOrShowFooterView(isShow: true)
//            
//            
//            //meterTimer = Timer.scheduledTimer(timeInterval: 1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
//            isRecording = true
//        }
//    }
//    //Recording stop
//    private func stopRecording() {
//        //        if meterTimer != nil {
//        //            meterTimer.invalidate()
//        //        }
//        if audioRecorder != nil {
//            audioRecorder.stop()
//            audioRecorder = nil
//            
//            //btnRecording.isSelected = false
//            isRecording = false
//            hideOrShowFooterView(isShow: false)
//            
//            print_debug(items: "recorded successfully.")
//        }
//        
//    }
//    
//    private func setup_recorder() {
//        if isAudioRecordingGranted {
//            let session = AVAudioSession.sharedInstance()
//            do
//            {
//                try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, policy: .default, options: .defaultToSpeaker)
//                try session.setActive(true)
//                let settings = [
//                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//                    AVSampleRateKey: 44100,
//                    AVNumberOfChannelsKey: 2,
//                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
//                ]
//                //audioRecorder = try AVAudioRecorder(url: CommonUtils.getFileUrl(fileName: recordedAudioFileName), settings: settings)
//                audioRecorder.delegate = self
//                audioRecorder.isMeteringEnabled = true
//                audioRecorder.record(forDuration: 60)
//                audioRecorder.prepareToRecord()
//            }
//            catch let error {
//                CommonUtils.showToast(message: String.getString(error.localizedDescription))
//            }
//        }
//        else {
//            CommonUtils.showToast(message: "Don't have access to use your microphone.")
//        }
//    }
//    
//    //Update recording time
//    @objc func updateAudioMeter(timer: Timer) {
//        if audioRecorder.isRecording {
//            //let hr = Int((audioRecorder.currentTime / 60) / 60)
//            let min = Int(audioRecorder.currentTime / 60)
//            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
//            let totalTimeString = String(format: "%02d:%02d", min, sec)
//            audioRecorder.updateMeters()
//            if sec > 60 {
//                CommonUtils.showToast(message: String.getString("Maxium Recording time is 60 seconds"))
//                longGesture?.state = .cancelled
//                stopRecording()
//            }
//        }
//    }
//    
//    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        if !flag {
//            CommonUtils.showToast(message: String.getString("Recording failed."))
//        }
//        hideOrShowFooterView(isShow: false)
//        if isRecordingCancel {
//            isRecordingCancel = false
//        }else {
//            //            let url = CommonUtils.getFileUrl(fileName: recordedAudioFileName)
//            //            self.sendAudioFile(videoURL: url)
//        }
//    }
//    
//    //MARK:- IBActions
//    @IBAction func backBtnTapped(_ sender: Any) {
//        if isSearchOn {
//            
//        }else {
//            if isUserBlocked {
//                Chat_hepler.Shared_instance.deleteChatNode(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: String.getString(self.receiverid))
//                //sharedAppDelegate.moveToHome()
//            }
//            //            else {
//            //                if isComingFromUserProfile {
//            //                    sharedAppDelegate.moveToHome()
//            //                }else {
//            //                    self.navigationController?.popViewC()
//            //                }
//            //            }
//            self.navigationController?.popViewController(animated: true)
//            self.callBack?(self.selectedCommunicationType)
//        }
//        
//    }
//    
//    @IBAction func tap_AttachmentBtn(_ sender: Any) {
//        self.view.endEditing(true)
//        self.viewMediaOptions.isHidden = false
//    }
//    
//    @IBAction func tap_DeleteBtn(_ sender: Any) {
//        
//    }
//    
//    @IBAction func tap_AudioCallBtn(_ sender: Any) {
//        
//        self.makeAudioCall()
//        
//    }
//    
//    @IBAction func tap_VideoCallBtn(_ sender: Any) {
//        
//        self.makeVideoCall()
//        
//    }
//    
//    @IBAction func tap_EmojiBtn(_ sender: UIButton) {
//        self.player?.pause()
//        chatTblView.reloadData()
//        sender.isSelected ? self.defaultKeyboard() : self.emojiKeyboard()
//    }
//    
//    @IBAction func dismissMediaView(_ sender: UIButton) {
//        self.viewMediaOptions.isHidden = true
//    }
//    
//    @IBAction func tap_DocumentBtn(_ sender: UIButton) {
//        self.viewMediaOptions.isHidden = true
//        
//        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
//        importMenu.delegate = self
//        importMenu.modalPresentationStyle = .formSheet
//        self.present(importMenu, animated: true, completion: nil)
//    }
//    
//    @IBAction func tap_GalleryBtn(_ sender: UIButton) {
//        self.viewMediaOptions.isHidden = true
//        
////        ImagePickerHelper.shared.openGallery(true) { [weak self](image) -> (Void) in
////
////            var width = image?.size.width
////            var height = image?.size.height
////            if image?.size.width ?? 0 > ScreenSize.SCREEN_WIDTH {
////                width = ScreenSize.SCREEN_WIDTH
////            }
////            if image?.size.height ?? 0 > ScreenSize.SCREEN_HEIGHT - 100 {
////                height = ScreenSize.SCREEN_HEIGHT - 100
////            }
////            let size: CGSize = CGSize(width: width ?? 0, height: height ?? 0)
////            let finalImage: UIImage? = image?.ResizeImageOriginalSize(targetSize: size)
////            //self?.sendImage(image : finalImage, check: true)
////            if finalImage != nil {
////                self?.uploadImagesVideos(imageOrVideo:finalImage!, isImage: true)
////            }
////        }
//    }
//    
//    @IBAction func tap_CameraBtn(_ sender: UIButton) {
//        self.viewMediaOptions.isHidden = true
//        
////        ImagePickerHelper.shared.showCamera { [weak self](image) -> (Void) in
////
////            var width = image?.size.width
////            var height = image?.size.height
////            if image?.size.width ?? 0 > ScreenSize.SCREEN_WIDTH {
////                width = ScreenSize.SCREEN_WIDTH
////            }
////            if image?.size.height ?? 0 > ScreenSize.SCREEN_HEIGHT - 100 {
////                height = ScreenSize.SCREEN_HEIGHT - 100
////            }
////            let size: CGSize = CGSize(width: width ?? 0, height: height ?? 0)
////            let finalImage: UIImage? = image?.ResizeImageOriginalSize(targetSize: size)
////            //self?.sendImage(image : finalImage, check: true)
////            if finalImage != nil {
////                self?.uploadImagesVideos(imageOrVideo:finalImage!, isImage: true)
////            }
////        }
//        
//    }
//    
//    @IBAction func tap_RecordingBtn(_ sender: UIButton) {
//        
//    }
//    
//    @IBAction func tap_SendBtn(_ sender: UIButton) {
//        self.player?.pause()
//        chatTblView.reloadData()
//        if !(chatTextView.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
//            self.SendtextMessage()
//            txtMessageHTConstant.constant = textViewMinHeight
//        }else {
//            CommonUtils.showToast(message: "Please enter some text")
//        }
//    }
//    
//    @IBAction func tap_SearchBtn(_ sender: UIButton) {
//        if searchList.count == 0 {
//            //CommonUtils.showToast(message:"No searched message found")
//            return
//        }
//        if sender.tag == 1 {//Top btn
//            selectedSearchIndex -= 1
//            if selectedSearchIndex < 0 {
//                selectedSearchIndex = 0
//                CommonUtils.showToast(message:"No searched message found")
//                return
//            }
//        }else {//Bottom btn
//            selectedSearchIndex += 1
//            if selectedSearchIndex >= searchList.count {
//                selectedSearchIndex = searchList.count - 1
//                CommonUtils.showToast(message:"No searched message found")
//                return
//            }
//        }
//        moveToSearchMessage()
//    }
//    
//}
//
//extension ChatViewController: RecordViewDelegate {
//    
//    func onStart() {
//        self.player?.pause()
//        chatTblView.reloadData()
//        startRecording()
//        print("onStart")
//    }
//    
//    func onCancel() {
//        isRecordingCancel = true
//        stopRecording()
//        print("onCancel")
//    }
//    
//    func onFinished(duration: CGFloat) {
//        if duration < 60 {
//            if duration < 1 {
//                isRecordingCancel = true
//            }
//            stopRecording()
//        }
//        print("onFinished \(duration)")
//    }
//    
//    func onAnimationEnd() {
//        print("onAnimationEnd")
//    }
//}
//
//extension ChatViewController {
//    
//    func blockUnblockApi(){
//        /*
//         CommonUtils.showHudWithNoInteraction(show: true)
//         let params:[String:Any] = [ApiParameters.kUserId: self.receiverid,
//         ApiParameters.kIsBlocked:self.isBlock ? "0" : "1"]
//         TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.blockUser,
//         requestMethod: .PUT,
//         requestParameters: params, withProgressHUD: false)
//         { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
//         CommonUtils.showHudWithNoInteraction(show: false)
//         if errorType == .requestSuccess {
//         let dictResult = kSharedInstance.getDictionary(result)
//         switch Int.getInt(statusCode) {
//         case 200:
//         if self.isBlock {
//         self.viewBloak.isHidden = true
//         self.footerView.isHidden = false
//         }else {
//         self.viewBloak.isHidden = false
//         self.footerView.isHidden = true
//         }
//         Chat_hepler.Shared_instance.blockUnblocFromRecent(Senderid: self.senderIdStr, Receiverid: String.getString(self.receiverid), status: self.isBlock)
//         let story = UIStoryboard.init(name:Storyboards.kPlan, bundle: nil)
//         let vc = story.instantiateViewController(withIdentifier: Identifiers.kSuccessPopupVC) as! SuccessPopupVC
//         vc.titleStr = self.isBlock ? "User unblocked successfully!" : "User blocked successfully!"
//         self.present(vc, animated: true)
//         
//         default:
//         self.showSimpleAlert(message: String.getString(dictResult[kMessage]))
//         }
//         } else if errorType == .noNetwork {
//         self.showSimpleAlert(message: AlertMessage.kNoInternet)
//         
//         } else {
//         self.showSimpleAlert(message: AlertMessage.kDefaultError)
//         }
//         }*/
//    }
//    
//    fileprivate func postBlockAPI() {
//        /*
//         let params : [String:String] = [ APIKeys.reciever_id :  self.receiverid,
//         APIKeys.sender_id   :  String.getString(self.userDetails[Parameters.user_id])
//         ]
//         
//         CommonUtils.showHudWithNoInteraction(show: true)
//         NetworkManager.shared.requestData(serviceName: ServiceName.blockuser, method: .post, parameters: params){dicResponse,statusCode  in
//         self.isUserBlocked = true
//         ResentUsers.deleteRecordForUser(userid: String.getString(self.receiverid))
//         let loggedInUserid = String.getString(self.userDetails[Parameters.user_id])
//         let chatId = loggedInUserid < self.receiverid ? "\(String.getString(loggedInUserid))_\(String.getString(self.receiverid))" : "\(String.getString(self.receiverid))_\(String.getString(loggedInUserid))"
//         MessageList.deleteMessagesForUser(userid: chatId)
//         self.MessageObjList.removeAll()
//         self.Messageclass.removeAll()
//         self.chatTblView.reloadData()
//         Chat_hepler.Shared_instance.deleteChatNode(Senderid: String.getString(self.userDetails[APIKeys.user_id]), Receiverid: String.getString(self.receiverid))
//         
//         CommonUtils.showToast(message: "Block Successfully")
//         
//         self.viewBloak.isHidden = false
//         self.footerView.isHidden = true
//         
//         }*/
//    }
//    
//}
//
////MARK:- UITextViewDelegate Methods
//extension ChatViewController: UITextViewDelegate {
//    
//    func textViewDidChange(_ textView: UITextView) {
//        
//        if textView.contentSize.height >= self.textViewMaxHeight {
//            txtMessageHTConstant.constant = self.textViewMaxHeight
//        }
//        else {
//            txtMessageHTConstant.constant = max(textViewMinHeight, textView.contentSize.height)
//        }
//    }
//    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let newString = NSString(string:textView.text).replacingCharacters(in: range, with: text)
//        if newString == "" {
//            Chat_hepler.Shared_instance.updateTypingStat(receiverid: self.receiverid, status: 0)
//        }else {
//            Chat_hepler.Shared_instance.updateTypingStat(receiverid: self.receiverid, status: 1)
//        }
//        
//        if text == "\n" {
//            //chatTextView.resignFirstResponder()
//            
//            if !(chatTextView.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
//                self.player?.pause()
//                chatTblView.reloadData()
//                self.SendtextMessage()
//                txtMessageHTConstant.constant = textViewMinHeight
//                return false
//            }else {
//                //CommonUtils.showToast(message: "Please enter some text")
//                chatTextView.resignFirstResponder()
//            }
//        }
//        
//        return true
//    }
//}
//
//extension ChatViewController: UITextFieldDelegate {
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if !String.getString(textField.text).isEmpty {
//            searchMessages(searchText: String.getString(textField.text))
//        }else {
//            
//        }
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if String.getString(textField.text).isEmpty {
//            CommonUtils.showToast(message: "Please enter text")
//        }else {
//            self.view.endEditing(true)
//        }
//        return true
//    }
//}
//
////MARK:- Extension for Emoji Send
//extension ChatViewController : EmojiViewDelegate {
//    // callback when tap a emoji on keyboard
//    func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
//        self.chatTextView.insertText(emoji)
//    }
//    
//    // callback when tap change keyboard button on keyboard
//    func emojiViewDidPressChangeKeyboardButton(_ emojiView: EmojiView) {
//        self.chatTextView.inputView = nil
//        self.chatTextView.keyboardType = .default
//        self.chatTextView.reloadInputViews()
//    }
//    
//    // callback when tap delete button on keyboard
//    func emojiViewDidPressDeleteBackwardButton(_ emojiView: EmojiView) {
//        self.chatTextView.deleteBackward()
//    }
//    
//    
//    // callback when tap dismiss button on keyboard
//    func emojiViewDidPressDismissKeyboardButton(_ emojiView: EmojiView) {
//        self.chatTextView.resignFirstResponder()
//        self.chatTextView.inputView = nil
//        self.chatTextView.keyboardType = .default
//        self.chatTextView.reloadInputViews()
//    }
//    
//}
//
////MARK:- extension for Pick Pdf from Cloud
//extension ChatViewController : UIDocumentPickerDelegate {
//    
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
//        
//        print(url as URL)
//        print(url.lastPathComponent)
//        //print(fileSize(forURL: url))
//        
//        self.sendDocFile(fileURL: url)
//        
//    }
//    
//    func documentMenu(_ documentMenu: UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
//        present(documentPicker, animated: true, completion: nil)
//    }
//    
//    
//    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
//        print("view was cancelled")
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func fileSize(forURL url: Any) -> Double {
//        var fileURL: URL?
//        var fileSize: Double = 0.0
//        if (url is URL) || (url is String)
//        {
//            if (url is URL) {
//                fileURL = url as? URL
//            }
//            else {
//                fileURL = URL(fileURLWithPath: url as! String)
//            }
//            var fileSizeValue = 0.0
//            try? fileSizeValue = (fileURL?.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).allValues.first?.value as! Double?)!
//            if fileSizeValue > 0.0 {
//                fileSize = (Double(fileSizeValue) / (1024 * 1024))
//            }
//        }
//        return fileSize
//    }
//    
//}
