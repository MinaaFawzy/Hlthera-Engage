//
//  NotificationsVC.swift
//  Hlthera
//
//  Created by Prashant on 14/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController {
    
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var viewCount: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var constraintNotification: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    
    var unreadNotify: Int = 0
    var hasComeFrom: HasCameFrom = .none
    var notifications: [NotificationsModel] = []
//        .init(dict: [
//        "id": 1,
//        "user_id": 2,
//        "read_unread_notification": "read",
//        "is_type": "true",
//        "order_id": 34,
//        "message": "This is a testing for notifications functionality",
//        "created_at": "",
//        "updated_at": "",
//        "title": "Hospital Added",
//        "order_request_date": ""])
//    ]
                                                           
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStatusBar()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.separatorStyle = .none
        if hasComeFrom == .settings {
            backBtn.isHidden = false
//            constraintNotification.constant = 20
        } else {
            backBtn.isHidden = true
//            constraintNotification.constant = -30
        }
//        lblTitle.font = .corbenRegular(ofSize: 15)
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        getNotifications()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MyNotificationsTVC.identifier, bundle: nil), forCellReuseIdentifier: MyNotificationsTVC.identifier)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension NotificationsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tableView.numberOfRow(numberofRow: notifications.count)
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTVC", for: indexPath) as! NotificationsTVC
//        if indexPath.row % 2 == 0{
//            cell.viewColor.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.2235294118, blue: 0.3960784314, alpha: 1)
//        }
//        else{
//            cell.viewColor.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.7098039216, blue: 0.07058823529, alpha: 1)
//        }
//        let obj = notifications[indexPath.row]
//        //        if obj.is_type == "1"{
//        //            cell.buttonViewDetail.isHidden = false
//        //        }
//        //        else{
//        //            cell.buttonViewDetail.isHidden = true
//        //        }
//        cell.labelTitle.text = obj.title.isEmpty ? "Title".localize : obj.title
//        let today = Date()
//        let date = Date(unixTimestamp: Double.getDouble(obj.order_request_date))
//        let dateFormatter = DateFormatter()
//
//        dateFormatter.timeStyle = .none
//        dateFormatter.dateStyle = .long
//        dateFormatter.dateFormat = date.dateString() == today.dateString() ? ("'Today' 'at 'hh:mm a") : ("MMM d, yyyy 'at 'hh:mm a")
//        cell.labelTime.text = dateFormatter.string(from: date)
//        cell.viewDescription.text = obj.message
//        cell.callbackViewDetails = {
//            guard let vc = UIStoryboard(name: "Pharmacy", bundle: nil).instantiateViewController(withIdentifier: ConfirmOrderVC.getStoryboardID()) as? ConfirmOrderVC else {
//                return
//            }
//            vc.orderId = obj.order_id
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        return cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyNotificationsTVC", for: indexPath) as! MyNotificationsTVC
        let obj = notifications[indexPath.row]
        cell.labelTitle.text = obj.message
        let today = Date()
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        cell.labelTime.text = formatter.localizedString(for: Date(unixTimestamp: Double.getDouble(obj.order_request_date)), relativeTo: Date())
        if obj.read_unread_notification == "0" {
            cell.mainView.backgroundColor = .white
            cell.viewAcceptReject.backgroundColor = .white
        } else {
            unreadNotify += 1
            print("aaaaaa\(indexPath.row)")
            cell.mainView.backgroundColor = UIColor(red: 245, green: 247, blue: 249)
            cell.viewAcceptReject.backgroundColor = UIColor(red: 245, green: 247, blue: 249)
        }
        cell.viewAcceptReject.isHidden = true
        labelCount.text = String.getString(unreadNotify)
        cell.onMore = { [weak self] in
            guard let self = self else { return }
            let actionSheet = UIAlertController(title: "Notification", message: "Choose action", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Remove this notification", style: .cancel))
            actionSheet.addAction(UIAlertAction(title: "Turn off notifications of this type", style: .default))
            actionSheet.addAction(UIAlertAction(title: "Report issue to Notifications Team", style: .default))
            self.present(actionSheet, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                return UITableView.automaticDimension
//        return 140
    }
    
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return CGFloat.leastNormalMagnitude
    //    }
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //           return 100
    //       }

}

extension NotificationsVC {
    func getNotifications() {
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.notificationList,                                                   requestMethod: .GET,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    let data = kSharedInstance.getArray(dictResult["data"])
                    self?.notifications = data.map{NotificationsModel(dict: kSharedInstance.getDictionary($0))}
                    self?.labelCount.text = String.getString(1)
                    self?.tableView.reloadData()
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
