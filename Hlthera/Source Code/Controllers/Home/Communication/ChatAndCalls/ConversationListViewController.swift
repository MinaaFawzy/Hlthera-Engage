////
////  ConversationListViewController.swift
////  Kindling
////
////  Created by Mohd Aslam on 29/12/20.
////
//
//import UIKit
//
//class ConversationListViewController: UIViewController {
//    
//    //MARK:- Outlets
//    @IBOutlet weak var listTblView:UITableView!
//    @IBOutlet weak var searchTxtField: UITextField!
//    @IBOutlet weak var allCollectionView: UICollectionView!
//    @IBOutlet weak var newCollectionView: UICollectionView!
//    @IBOutlet weak var searchIcon: UIImageView!
//    
//    //MARK:- Variables
//    var userDetails = kSharedUserDefaults.getLoggedInUserDetails()
//    var stausInfo: [String: Any] = [:]
//    var ResentUser:[ResentUsers]?
//    var originalList:[ResentUsers]?
//    
//    //MARK:- View Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        listTblView.tableFooterView = UIView.init()
//        allCollectionView.contentInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)
//        newCollectionView.contentInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)
//        let image = searchIcon.image!.withRenderingMode(.alwaysTemplate)
//        searchIcon.image = image
//        //searchIcon.tintColor = CustomColor.kGray
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(Notifications.kChatNotificationReceived), object: nil, queue: nil) { (notification) in
//            self.ResentUser = ResentUsers.fetchResentListFromDatabase()
//            self.originalList = self.ResentUser
//            self.listTblView.reloadData()
//        }
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        
//        self.ResentUser = ResentUsers.fetchResentListFromDatabase()
//        self.originalList = self.ResentUser
//        self.listTblView.reloadData()
//        initialeSetup()
//        
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }
//      
//    
//    //MARK:- Private Functions
//    private func initialeSetup() {
//       // DispatchQueue.main.async {
////            if self.ResentUser?.count == 0 {
////                CommonUtils.showHudWithNoInteraction(show: true)
////            }
//            Chat_hepler.Shared_instance.Resent_Users(userid: String.getString(self.userDetails[Parameters.user_id]), message: {[weak self] (ResentList) in
//                //self.ResentUser = ResentList
//                self?.ResentUser = ResentUsers.fetchResentListFromDatabase()
//                self?.originalList = self?.ResentUser
//                //self.updateStatusInfo(forUsers: ResentUsers ?? [])
//                //CommonUtils.showHudWithNoInteraction(show: false)
//                self?.listTblView.reloadData()
//            })
//        //}
//        
//        //Chat_hepler.Shared_instance.OnlineState(State: true)
//    }
//    
//    func updateStatusInfo(forUsers users: [ResentUsers]) {
//        
//        for user in users {
//            if let id = user.Receiverid {
//                stausInfo[id] = id
//                Chat_hepler.Shared_instance.checkUserOnlineStateObserver(userid: id) { (id, status , timeStamp) in
//                    self.ResentUser?.filter{ ($0.Receiverid ?? "") == id }.first?.isOnline = status
//                    self.ResentUser?.filter{ ($0.Receiverid ?? "") == id }.first?.timeStamp = timeStamp
//                    self.listTblView.reloadData()
//                }
//            }
//        }
//    }
//    
//}
//
//extension ConversationListViewController : UITableViewDelegate, UITableViewDataSource{
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.ResentUser?.count ?? 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatConversationCell", for: indexPath) as? ChatConversationCell else{return UITableViewCell()}
//        cell.selectionStyle = .none
//        
//        let obj = self.ResentUser?[indexPath.row]
//        if obj?.isInvalidated ?? true {
//            return UITableViewCell()
//        }
//        
//        cell.userNameLbl.text =  String.getString(self.ResentUser?[indexPath.row].name)
//        var msg = String.getString(self.ResentUser?[indexPath.row].lastmessage)
//        if msg == "audio" {
//            msg = "Audio"
//        }
//        cell.messageLbl.text = msg
//        let url = String.getString(self.ResentUser?[indexPath.row].imageUrl)
//        
//        cell.userImgView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "profile_pic"), options: .highPriority, completed: nil)
//        
//        let stamp = obj?.SendingTime ?? 0
//        if stamp == 0{
//            cell.dateLbl.text = ""
//        }else {
//            let date1 = stamp.dateFromTimeStamp()
//            let str = date1.stringWithFormat(format: "yyyy-MM-dd HH:mm:ss")
//            cell.dateLbl.text = Date.findMyAgo(from: str)
//        }
//        
//        //var receiverId = obj?.Receiverid
//        if obj?.Senderid == String.getString(self.userDetails[Parameters.user_id]) {
//            if obj?.readState == "sent" {
//                //cell.statusLbl.text = "D"
//                //cell.statusLbl.textColor = CustomColor.kRed
//            }else if obj?.readState == "seen" {
//                //cell.statusLbl.text = "R"
//                //cell.statusLbl.textColor = CustomColor.kGreen
//            }else {
//                //cell.statusLbl.text = ""
//            }
//        }else {
//            //cell.statusLbl.text = ""
//            //receiverId = obj?.Senderid
//        }
//        let count = obj?.unread_count ?? 0
//        if count > 0 {
//            cell.viewChatCount.isHidden = false
//            cell.lblChatCount.text = "\(count)"
//        }else {
//            cell.viewChatCount.isHidden = true
//        }
//        
//        let callStatus = String.getString(self.ResentUser?[indexPath.row].call_status)
//        if callStatus == CallState.REJECTED.rawValue {
//            cell.viewMissedCall.isHidden = false
//            cell.nameTrailingConstraint.constant = 120
//        }else {
//            cell.viewMissedCall.isHidden = true
//            cell.nameTrailingConstraint.constant = 1
//        }
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var recId = ""
//        if String.getString(self.ResentUser?[indexPath.row].Receiverid) == String.getString(self.userDetails[Parameters.user_id]) {
//            recId = String.getString(self.ResentUser?[indexPath.row].Senderid)
//        }else {
//            recId = String.getString(self.ResentUser?[indexPath.row].Receiverid)
//        }
//        
//        let story = UIStoryboard.init(name:Storyboards.kOrders, bundle: nil)
//        let controller = story.instantiateViewController(withIdentifier: "Identifiers.kChatViewController") as! ChatViewController
//        controller.receivername = String.getString(self.ResentUser?[indexPath.row].name)
//        controller.receiverid = recId
//        
//        controller.chatCallback = { [weak self] in
//            self?.initialeSetup()
//        }
//        controller.receiverprofile_image = String.getString(self.ResentUser?[indexPath.row].imageUrl)
//        self.navigationController?.pushViewController(controller, animated: true)
//        
//        
//    }
//}
//
//class ChatConversationCell: UITableViewCell {
//
//    @IBOutlet weak var userImgView: UIImageView!
//    @IBOutlet weak var userNameLbl: UILabel!
//    @IBOutlet weak var statusLbl: UILabel!
//    @IBOutlet weak var messageLbl: UILabel!
//    @IBOutlet weak var dateLbl: UILabel!
//    @IBOutlet weak var viewChatCount: UIView!
//    @IBOutlet weak var lblChatCount: UILabel!
//    @IBOutlet weak var containerView: UIView!
//    @IBOutlet weak var nameTrailingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var viewMissedCall: UIView!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//    
//}
//
//extension ConversationListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 66, height: 66)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == allCollectionView {
//            return 9
//        } else {
//            return 2
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        if collectionView == allCollectionView {
//            let cell = allCollectionView.dequeueReusableCell(withReuseIdentifier: "StatusCollectionCell", for: indexPath) as! StatusCollectionCell
//            cell.userImage.image = #imageLiteral(resourceName: "profilepic")
//            return cell
//            
//        } else {
//            let cell = newCollectionView.dequeueReusableCell(withReuseIdentifier: "StatusCollectionCell", for: indexPath) as! StatusCollectionCell
//            cell.userImage.image = #imageLiteral(resourceName: "profilepic")
//            return cell
//            
//            
//        }
//        
//        
//        
//    }
//    
//}
//
//
//class StatusCollectionCell: UICollectionViewCell {
//    
//    @IBOutlet weak var userImage: UIImageView!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.userImage.clipsToBounds = true
//    }
//}
