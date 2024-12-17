//
//  ChatViewController.swift
//  Hlthera
//
//  Created by Ahmed Hegazy on 08/01/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit
import PaginatedTableView

@available(iOS 15.0, *)
class ChatCheckInViewController: UIViewController {
    
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView: PaginatedTableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tfWriteMessage: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    
    var allChatItems:[ChatItem] = []
    var hasCameFrom:HasCameFrom = .CheckInScheduled
    var doctorId = 0
    var bookingId = 0
    //var pageNumber = 0
    //var pageSize = 20
    var checkInItem:CheckInItem?
    var currentPageScheduled = 1
    var currentPagePrev = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ChatCheckInViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatCheckInViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        tableView.paginatedDelegate = self
        tableView.paginatedDataSource = self
        //tableView.separatorStyle = .none
        tableView.enablePullToRefresh = true
        tableView.pullToRefreshTitle = NSAttributedString(string: "Pull to Refresh".localize)
        self.tableView.register(UINib(nibName: ChatItemTVC.identifier, bundle: nil), forCellReuseIdentifier: ChatItemTVC.identifier)
        
        tfWriteMessage.borderStyle = .none
        lblTitle.font = .corbenRegular(ofSize: 15)
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        
        bookingId = (checkInItem?.id)!
        doctorId = Int.getInt(checkInItem?.doctorInformation?.doctorID)
        
        //getListing(type: .CheckInScheduled)
        //loadMore( self.pageNumber, self.pageSize) { value in
        //} onError: { error in
        //
        //}
        tableView.loadData(refresh: true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSendMessage(_ sender: Any) {
        var message  = ""
        var doctorId = self.doctorId
        if String.getString(tfWriteMessage.text).isEmpty{
            //showAlertMessage.alert(message: "Please Enter Message")
            CommonUtils.showToast(message: "Please Enter Message".localize)
            return
        } else {
            checkInRequest(doctorId: self.doctorId, message: tfWriteMessage.text ?? "",
                           bookingId: self.bookingId)
        }
    }
    
}

@available(iOS 15.0, *)
extension ChatCheckInViewController:
    //UITableViewDelegate,UITableViewDataSource,
    PaginatedTableViewDelegate,
    PaginatedTableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func loadMore(_ pageNumber: Int, _ pageSize: Int, onSuccess: ((Bool) -> Void)?, onError: ((Error) -> Void)?) {
        //print("loadMore")
        // Call your api here
        // Send true in onSuccess in case new data exists, sending false will disable pagination
        //// If page number is first, reset the list
        //if pageNumber == 1 { self.allChatItems = [ChatItem]() }
        //// else append the data to list
        //let startFrom = (self.allChatItems.last ?? 0) + 1
        //for number in startFrom..<(startFrom + pageSize) {
        //    self.allChatItems.append(number)
        //}
        //DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        //    onSuccess?(true)
        //}
        
        getListing(page: pageNumber, limit: pageSize) { success in
            print(success)
            onSuccess!(success)
        } onError: { error in
            print("error")
            
        }
        
        //        getDoctorTimeSlots(page: pageNumber, limit: pageSize) { success in
        //            print(success)
        //            onSuccess!(success)
        //                    } onError: { error in
        //                        print("error")
        //                    }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return tableView.numberOfRow(numberofRow: allChatItems.count)
        return allChatItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatItemTVC.identifier, for: indexPath) as! ChatItemTVC
        let obj = allChatItems[indexPath.row]
        
        if let replyMessage = obj.replyMsg, !replyMessage.isEmpty {
            cell.viewLef.isHidden = false
            cell.lblLeft.text = obj.replyMsg
        } else {
            cell.viewLef.isHidden = true
        }
        
        if let message = obj.message, !message.isEmpty {
            cell.lblRight.text = obj.message
            cell.viewRight.isHidden = false
        } else {
            cell.viewRight.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let obj = allChatItems[indexPath.row]
//        var replyMessage = obj.replyMsg ?? ""
//        if(replyMessage == nil || replyMessage.isEmpty){
//            return 50
//        }else{
//            return 150
//        }
        return UITableView.automaticDimension
    }
    
    //public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //    print(scrollView.contentOffset.y)
    //}
    
}

@available(iOS 15.0, *)
extension ChatCheckInViewController {
    
    func getListing( page: Int = 0, limit: Int = 20, onSuccess: ((Bool) -> Void)?, onError: ((Error) -> Void)?){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        //switch hasCameFrom{
        //case .CheckInScheduled:
        //    page = currentPageScheduled
        //case .CheckInPrev:
        //    page = currentPagePrev
        //default:break
        //}
        let params:[String : Any] = [
            ApiParameters.page:String.getString(page),
            ApiParameters.limit:String.getString(limit),
            ApiParameters.booking_id: bookingId
            
        ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.getCheckInsChatList,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                //                print(result)
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    var model:ChatData?
                    let convertDicToJsonString =  try? JSONSerialization.data(withJSONObject: dictResult, options: [.prettyPrinted])
                    let jsonString = String(data: convertDicToJsonString!, encoding: .utf8)!
                    let jsonStringToData = Data(jsonString.utf8)
                    let decoder = JSONDecoder()
                    do {
                        model = try decoder.decode(ChatData.self, from: jsonStringToData)
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    if model?.status == 1{
                        self?.allChatItems = model?.result?.data ?? []
                        self?.tableView.reloadData()
                        print(self?.allChatItems.count)
                        print( model?.result?.total)
                        
                        if self?.allChatItems.count < (model?.result?.total)! {
                            onSuccess!(true);
                        }else{
                            onSuccess!(false);
                        }
                    }
                    else{
                        CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    }
                    break;
                default:
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    break;
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToast(message: kNoInternetMsg)
                
            } else {
                CommonUtils.showToast(message: kDefaultErrorMsg)
            }
        }
    }
    
}

@available(iOS 15.0, *)
extension ChatCheckInViewController {
    
    func checkInRequest(doctorId:Int,
                        message:String,
                        bookingId: Int
    ){
        let params = [
            ApiParameters.doctor_id: doctorId,
            ApiParameters.kMessage: message,
            ApiParameters.booking_id: bookingId,
            
            //ApiParameters.kdeviceToken:kSharedUserDefaults.getDeviceToken(),
            //        ApiParameters.klogin_type:String.getString(loginType),
            //        ApiParameters.ksocial_id:id,
            //        ApiParameters.kLatitude:"0",
            //        ApiParameters.kLongitude:"0",
            //        ApiParameters.kfullName:name,
            //        ApiParameters.kemail:email,
        ] as [String : Any]
        checkInApi(params: params)
    }
    func checkInApi(params:[String:Any]){
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
                    //var json = JSON(dictResult)
                    //var messageSuccess = json["message"].stringValue
                    //var created_at = json["data"]["created_at"].stringValue
                    //var doctor_id = json["data"]["doctor_id"].intValue
                    //var id = json["data"]["id"].intValue
                    //var messageData = json["data"]["message"].stringValue
                    //var updated_at = json["data"]["updated_at"].stringValue
                    //var user_id = json["data"]["user_id"].intValue
                    //print(created_at)
                    //print(doctor_id)
                    //print(id)
                    //print(messageData)
                    //print(updated_at)
                    
                    //self.MotionToast(message: "Checked in successfully completed", toastType: .success)
                    //CommonUtils.showToast(message: "Checked in successfully completed")
                    
                    //self.dismiss(animated: true)
                    var chat = ChatItem()
                    chat.message = self.tfWriteMessage.text ?? ""
                    chat.replyMsg = nil
                    self.allChatItems.append(chat)
                    
                    self.tableView.reloadData()
                    self.tfWriteMessage.text = ""
                    DispatchQueue.main.async {
                        let indexPath = IndexPath(row: self.allChatItems.count-1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                    
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



