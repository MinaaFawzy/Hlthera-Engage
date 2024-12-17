//
//  ChatVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 12/02/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ChatVC: UIViewController {
    @IBOutlet weak var labelTimeLeft: UILabel!
    @IBOutlet weak var labelBookingID: UILabel!
    @IBOutlet weak var labelDateAndTime: UILabel!
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var labelReceiverName: UILabel!
    @IBOutlet weak var ImageReceiver: UIImageView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var textViewChatMessage: UITextView!
    @IBOutlet weak var bottomViewBottmConstraint: NSLayoutConstraint!
    
  //  let loginData = sharedUserDefaults.getLoggedInUserDetails()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelReceiverName.font = .corbenRegular(ofSize: 15)
        
        IQKeyboardManager.shared.enable = false
        labelBookingID.attributedText = NSAttributedString.setAttributedString(firstValue: "Booking ID".localize, firstColor: .white, firstFont:  UIFont.SFDisplayRegular(fontSize: 12), secondValue: "12", secondColor: .white, secondFont: UIFont.SFDisplayMedium(fontSize: 12))
        labelDateAndTime.attributedText = NSAttributedString.setAttributedString(firstValue: "Date and time".localize, firstColor: .white, firstFont:  UIFont.SFDisplayRegular(fontSize: 12), secondValue: "30 mins".localize, secondColor: .white, secondFont: UIFont.SFDisplayMedium(fontSize: 12))
       // view.statusbarColor()
        //self.chatTableView.receiveMessage(receiverId: String.getString(loginData["admin_id"]))
        registerKeyboardNotifications()
        // Do any additional setup after loading the view.
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonFlagTapped(_ sender: Any) {
    }
    @IBAction func buttonAddTapped(_ sender: Any) {
    }
    @IBAction func buttonSendEmojisTapped(_ sender: Any) {
    }
    @IBAction func sendMessageTapped(_ sender: UIButton) {
        if String.getString(self.textViewChatMessage.text) == "" {
            return
        }
//        let message = MessageClass()
//        message.mediaType = .text
//        message.receiverId = String.getString(loginData["admin_id"])
//        message.message = self.textViewChatMessage.text
//        message.profileImage = sharedUserDefaults.getImage()
//        chatTableView.sendMessage(message: message)
        self.textViewChatMessage.text = ""
    }
    // MARK: -  Notification
    @objc func keyboardWillShow(notification: NSNotification) {
        var keyboardSize: CGSize = CGSize.zero
        if let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            keyboardSize = value.cgRectValue.size
//            if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_X_MAX {
//                bottomViewBottmConstraint.constant = keyboardSize.height-34
//            }else {
//                bottomViewBottmConstraint.constant = keyboardSize.height
//            }
//            self.view.layoutIfNeeded()
//            self.chatTableView.scrollToBottom()
        }
    }
    @objc func keyboardWillHide(notification: NSNotification){
        bottomViewBottmConstraint.constant = 20
        self.view.layoutIfNeeded()
    }
    private func registerKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

