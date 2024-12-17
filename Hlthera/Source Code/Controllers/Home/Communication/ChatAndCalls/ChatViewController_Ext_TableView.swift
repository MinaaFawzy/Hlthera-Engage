////
////  ChatViewController_Ext_TableView.swift
////  RippleApp
////
////  Created by Mohd Aslam on 29/04/20.
////  Copyright © 2020 Fluper. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//import AVKit
//import SDWebImage
//
//extension ChatViewController: UITableViewDelegate , UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return self.MessageObjList.count
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let arr = self.MessageObjList[section].messages
//        return arr.count
//    }
//   
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//                
//        //Media Type Check for type for Cell  , 1 = text , 2- image , 3 - Video , 4 - Pdf , 5 = Location Share Celll
//        let obj = self.MessageObjList[indexPath.section].messages[indexPath.row]
//        if obj.isInvalidated {
//            return UITableViewCell()
//        }
//        if obj.Senderid == String.getString(self.userDetails[Parameters.user_id]) {
//            
//            if obj.mediatype == "call" {
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellidentifiers.MissedCallCell, for: indexPath) as? MissedCallCell else{return UITableViewCell()}
//                cell.selectionStyle = .none
//                let time = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
//                cell.lblTime.text = "Missed Call at \(time)"
//                return cell
//                
//            }else if obj.mediatype == "text" {
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellidentifiers.SendertextCell, for: indexPath) as? SendertextCell else{return UITableViewCell()}
//                cell.selectionStyle = .none
//                cell.lblMsgTrailingConstraint.constant = 35
//                cell.btnDelete.isHidden = true
//                
//                cell.lblMessage.text = String.getString(obj.Message)
//                cell.lblMessage.backgroundColor = .clear
//                if isSearchOn {
//                    let msgId = String.getString(obj.uid)
//                    if searchList.contains(msgId) {
//                        cell.lblMessage.backgroundColor =  UIColor(red: 254/255, green: 177/255, blue: 61/255, alpha: 1)
//                    }
//                }
//                cell.lbltime.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
//                
////                cell.tickImgView.isHidden = false
////                if String.getString(obj.status) == "seen" {
////                    cell.tickImgView.image = UIImage(named: "chat_doubleTick")
////                }else if String.getString(obj.status) == "sent" {
////                    cell.tickImgView.image = UIImage(named: "chat_singleTick")
////                }else {
////                    cell.tickImgView.isHidden = true
////                }
//                
//                
//                
//                //CALL BACK FOR Delete Message
//                cell.DeleteCallBack = {
//                    
//                    let story = UIStoryboard(name: Storyboards.kOrders, bundle: nil)
//                    let controller = story.instantiateViewController(withIdentifier: "kCustomAlertPopupVC") as! CustomAlertPopupVC
//                    
//                        self.present(controller, animated: true) {
//                            controller.deleteCallBack = {
//                                
//                                self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: String.getString(self.receiverid), bookingId: String.getString(self.communicationList?.appointmentID), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
//                                
//                                self.isDeleted = true
//                                MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
//                                CommonUtils.showToast(message: "message was deleted")
//                                
//                            }
//                        }
//                }
////                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
////                    cell.viewBg.roundCorners([.bottomLeft,.bottomRight, .topLeft], radius: 20)
////                }
//                
//                return cell
//            } else if obj.mediatype == "image" {
//                
//                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderImageCell", for: indexPath) as! SenderImageCell
//                cell.selectionStyle = .none
//                cell.imgTrailingConstraint.constant = 20
//                
//                cell.sendimageView.sd_setImage(with: URL(string: String.getString(obj.imageurl)), placeholderImage: nil, options: .highPriority, completed: nil)
//                
//                cell.time.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
//                
////                cell.tickImgView.isHidden = false
////                if String.getString(obj.status) == "seen" {
////                    cell.tickImgView.image = UIImage(named: "chat_doubleTick")
////                }else if String.getString(obj.status) == "sent" {
////                    cell.tickImgView.image = UIImage(named: "chat_singleTick")
////                }else {
////                    cell.tickImgView.isHidden = true
////                }
//                
//                
//                //OPEN IMAGE
//                cell.openImageCallBack = {
//                    self.player?.pause()
//                    let imageScreen = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewVC") as! ImageViewVC
//                    imageScreen.imageString = String.getString(obj.imageurl)
//                    imageScreen.Messageclass = self.Messageclass
//                    imageScreen.selectedMessage = String.getString(obj.uid)
//                    if #available(iOS 13.0, *) {
//                        imageScreen.modalPresentationStyle = .currentContext
//                    } else {
//                        // Fallback on earlier versions
//                    }
//                    self.present(imageScreen, animated: true, completion: nil)
//                    self.chatTblView.reloadData()
//                }
//                
//                
//                //CALL BACK FOR Delete Message
//                cell.DeleteCallBack = {
//                    let story = UIStoryboard(name: Storyboards.kOrders, bundle: nil)
//                    let controller = story.instantiateViewController(withIdentifier: "CustomAlertPopupVC") as! CustomAlertPopupVC
//                    
//                        self.present(controller, animated: true) {
//                            controller.deleteCallBack = {
//                        
//                                self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid:String.getString(self.receiverid), bookingId: String.getString(self.communicationList?.appointmentID), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
//                        
//                        self.isDeleted = true
//                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
//                        CommonUtils.showToast(message: "message was deleted")
//                      }
//                    }
//                }
//                
//                return cell
//            }
//            else if obj.mediatype == "video" {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderVideoCell", for: indexPath) as! SenderVideoCell
//                cell.selectionStyle = .none
//                cell.imgTrailingConstraint.constant = 15
//                
//                cell.sendimageView.sd_setImage(with: URL(string: String.getString(obj.thumnilimageurl)), placeholderImage: nil, options: .highPriority, completed: nil)
//                cell.time.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
//                
////                cell.tickImgView.isHidden = false
////                if String.getString(obj.status) == "seen" {
////                    cell.tickImgView.image = UIImage(named: "chat_doubleTick")
////                }else if String.getString(obj.status) == "sent" {
////                    cell.tickImgView.image = UIImage(named: "chat_singleTick")
////                }else {
////                    cell.tickImgView.isHidden = true
////                }
//                
//                
//                
//                //CALL BACK FOR Delete Message
//                cell.DeleteCallBack = {
//                    let story = UIStoryboard(name: Storyboards.kOrders, bundle: nil)
//                    let controller = story.instantiateViewController(withIdentifier: "CustomAlertPopupVC") as! CustomAlertPopupVC
//                    
//                        self.present(controller, animated: true) {
//                            controller.deleteCallBack = {
//                        
//                                self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid:String.getString(self.receiverid), bookingId: String.getString(self.communicationList?.appointmentID), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
//                        self.isDeleted = true
//                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
//                        CommonUtils.showToast(message: "message was deleted")
//                    }
//                }
//                }
//                
//                //CALL Back for Play Video
//                cell.playVideo = {
//                    self.player?.pause()
//                    let videoURL = NSURL(string:  "\(String.getString(obj.mediaurl))")
//                    let player = AVPlayer(url: videoURL! as URL)
//                    let playerViewController = AVPlayerViewController()
//                    playerViewController.player = player
//                    playerViewController.modalTransitionStyle = .crossDissolve
//                    playerViewController.modalPresentationStyle = .overFullScreen
//                    self.present(playerViewController, animated: true) {
//                        playerViewController.player!.play()
//                    }
//                    self.chatTblView.reloadData()
//                }
//                
//                return cell
//                
//            } else if obj.mediatype == "audio" {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderAudioCell", for: indexPath) as! SenderAudioCell
//                cell.selectionStyle = .none
//                cell.viewTrailingConstraint.constant = 15
//                
//                cell.time.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
////                cell.tickImgView.isHidden = false
////                if String.getString(obj.status) == "seen" {
////                    cell.tickImgView.image = UIImage(named: "chat_doubleTick")
////                }else if String.getString(obj.status) == "sent" {
////                    cell.tickImgView.image = UIImage(named: "chat_singleTick")
////                }else {
////                    cell.tickImgView.isHidden = true
////                }
//                if cell.indicatorView.isAnimating {
//                    cell.indicatorView.stopAnimating()
//                }
//                cell.indicatorView.isHidden = true
//                cell.playBtn.isSelected = false
//                cell.playBtn.backgroundColor = CustomColor.kSenderPlay
//                cell.lblName.isHidden = false
//                self.isPlaying = false
//                self.player?.pause()
//                let url = URL(string: obj.mediaurl ?? "")
//                let fileName =  url?.lastPathComponent ?? ""
//                let path = CommonUtils.getDocumentDirectoryPath() + "/\(fileName).m4a";
//                if fileManager.fileExists(atPath: path) {
//                    cell.playBtn.isHidden = false
//                    cell.saveBtn.isHidden = true
//                }else {
//                    cell.playBtn.isHidden = true
//                    cell.saveBtn.isHidden = false
//                }
//                cell.lblName.text = fileName
//                
//                cell.saveCallback = {
//                    CommonUtils.showHudWithNoInteraction(show: true)
//                    CommonUtils.saveFileToDocumentDirectory(url: url, fileName: "/\(fileName).m4a") { (success) in
//                        if success ?? false {
//                            cell.playBtn.isHidden = false
//                            cell.saveBtn.isHidden = true
//                        }
//                        CommonUtils.showHudWithNoInteraction(show: false)
//                    }
//                }
//                
//                cell.playCallback = {
//                    
//                    let playerItem:AVPlayerItem = AVPlayerItem(url: CommonUtils.getFileUrl(fileName: "/\(fileName).m4a"))
//                    self.player = AVPlayer(playerItem: playerItem)
//                    //obj.isSongPlayed = !obj.isSongPlayed
//                    
//                    
//                    
//                    if !self.isPlaying{
//                        
//                        //obj.isSongPlayed  = false
//                        cell.playBtn.isSelected = true
//                        cell.indicatorView.isHidden = false
//                        cell.indicatorView.startAnimating()
//                        self.isPlaying = true
//                        cell.playBtn.backgroundColor = .clear
//                        cell.lblName.isHidden = true
//                        self.player!.play()
//                    }else{
//                        //obj.isSongPlayed  = true
//                        cell.playBtn.isSelected = false
//                        cell.indicatorView.isHidden = true
//                        cell.indicatorView.stopAnimating()
//                        self.isPlaying = false
//                        cell.playBtn.backgroundColor = CustomColor.kSenderPlay
//                        cell.lblName.isHidden = false
//                        self.player!.pause()
//                    }
//                    
//                    
//                }
//                
//                //DELETE
//                cell.DeleteCallBack = {
//                    let story = UIStoryboard(name: Storyboards.kOrders, bundle: nil)
//                    let controller = story.instantiateViewController(withIdentifier: "CustomAlertPopupVC") as! CustomAlertPopupVC
//                    
//                        self.present(controller, animated: true) {
//                            controller.deleteCallBack = {
//                        
//                                self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: String.getString(self.receiverid), bookingId: String.getString(self.communicationList?.appointmentID), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
//                        
//                        print(self.CreatedBy)
//                        
//                        self.isDeleted = true
//                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
//                        CommonUtils.showToast(message: "message was deleted")
//                        
//                    }
//                }
//                }
//                
//                return cell
//                
//            }else if obj.mediatype == "document" {
//                
//                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderDocumentCell", for: indexPath) as! SenderDocumentCell
//                cell.selectionStyle = .none
//                cell.imgTrailingConstraint.constant = 20
//                
//                cell.labelDocName.text = String.getString(obj.mediaName)
//                cell.labelTime.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
//                let url = String.getString(obj.thumnilimageurl)
//                cell.imageDoc.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .highPriority, completed: nil)
//                cell.viewDocumentCallBack = { [weak self] in
//                    self?.openDocumentFile(mediaurl: String.getString(obj.mediaurl), mediaName: String.getString(obj.mediaName))
//                }
//                
//                //CALL BACK FOR Delete Message
//                cell.DeleteCallBack = {
//                    let story = UIStoryboard(name: Storyboards.kOrders, bundle: nil)
//                    let controller = story.instantiateViewController(withIdentifier: "CustomAlertPopupVC") as! CustomAlertPopupVC
//                    
//                        self.present(controller, animated: true) {
//                            controller.deleteCallBack = {
//                        
//                                self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid:String.getString(self.receiverid), bookingId: String.getString(self.communicationList?.appointmentID), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
//                        
//                        self.isDeleted = true
//                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
//                        CommonUtils.showToast(message: "message was deleted")
//                      }
//                    }
//                }
//                
//                return cell
//            }
//            else {
//                return UITableViewCell()
//            }
//            
//        } else {
//            
//            if obj.mediatype == "text" {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "Receivertextcell", for: indexPath) as! Receivertextcell
//                cell.selectionStyle = .none
//                cell.lblMsgTrailingConstraint.constant = 20
//                cell.btnDelete.isHidden = true
//                cell.profile_image.image = self.userImgView.image
//                cell.lblMessage.text = String.getString(obj.Message)
//                cell.lblMessage.backgroundColor = .clear
//                if isSearchOn {
//                    let msgId = String.getString(obj.uid)
//                    if searchList.contains(msgId) {
//                        cell.lblMessage.backgroundColor = UIColor(red: 254/255, green: 177/255, blue: 61/255, alpha: 1)
//                    }
//                }
//                cell.lbltime.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
//                
//                
//                //CALL BACK FOR Delete Message
//                cell.DeleteCallBack = {
//                    let story = UIStoryboard(name: Storyboards.kOrders, bundle: nil)
//                    let controller = story.instantiateViewController(withIdentifier: "CustomAlertPopupVC") as! CustomAlertPopupVC
//                    
//                        self.present(controller, animated: true) {
//                            controller.deleteCallBack = {
//                        
//                                self.CreatedBy == Parameters.emptyString ? Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid:String.getString(self.receiverid), bookingId: String.getString(self.communicationList?.appointmentID), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
//                        
//                        self.isDeleted = true
//                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
//                        CommonUtils.showToast(message: "message was deleted")
//                    }
//                }
//                }
////                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
////                    cell.chatBoxView.roundCorners([.bottomLeft,.bottomRight, .topRight], radius: 20)
////                }
//                
//                return cell
//                
//            } else if obj.mediatype == "image" {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverImageCell", for: indexPath) as! ReceiverImageCell
//                cell.selectionStyle = .none
//                cell.imageLeadingConstraint.constant = 20
//                cell.viewSaveImage.isHidden = true
//                cell.profileImgView.image = self.userImgView.image
//                cell.receiveimageView.sd_setImage(with: URL(string: String.getString(obj.imageurl)), placeholderImage: nil, options: .highPriority, completed: nil)
//                // cell.receiveimageView.addFilter(filter: FilterType.Noir)
//                
//                cell.time.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
//                
//                
//                //OPEN IMAGE
//                cell.openImageCallBack = {
//                    self.player?.pause()
//                    let imageScreen = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewVC") as! ImageViewVC
//                    imageScreen.imageString = String.getString(obj.imageurl)
//                    imageScreen.Messageclass = self.Messageclass
//                    imageScreen.selectedMessage = String.getString(obj.uid)
//                    if #available(iOS 13.0, *) {
//                        imageScreen.modalPresentationStyle = .currentContext
//                    } else {
//                        // Fallback on earlier versions
//                    }
//                    self.present(imageScreen, animated: true, completion: nil)
//                    self.chatTblView.reloadData()
//                }
//                
//                //Save Image
//                cell.saveImageCallBack = {
//                    cell.viewSaveImage.isHidden = true
//                    guard let image = cell.receiveimageView.image else { return }
//                    CommonUtils.showHudWithNoInteraction(show: true)
//                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
//                }
//                //CALL BACK FOR Delete Message
//                cell.DeleteCallBack = {
//                    let story = UIStoryboard(name: Storyboards.kOrders, bundle: nil)
//                    let controller = story.instantiateViewController(withIdentifier: "CustomAlertPopupVC") as! CustomAlertPopupVC
//                    
//                        self.present(controller, animated: true) {
//                            controller.deleteCallBack = {
//                                self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid:String.getString(self.receiverid), bookingId: String.getString(self.communicationList?.appointmentID), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
//                                
//                        self.isDeleted = true
//                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
//                        CommonUtils.showToast(message: "message was deleted")
//                    }
//                }
//                }
//                return cell
//                
//            }
//            else if obj.mediatype == "video" {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverVideoCell", for: indexPath) as! ReceiverVideoCell
//                cell.selectionStyle = .none
//                cell.imageLeadingConstraint.constant = 15
//                cell.viewSaveVideo.isHidden = true
//                
//                cell.receiveimageView.sd_setImage(with: URL(string: String.getString(obj.thumnilimageurl)), placeholderImage: nil, options: .highPriority, completed: nil)
//                cell.time.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
//                                
//                //Save Video
//                cell.saveVideoCallBack = {
//                    cell.viewSaveVideo.isHidden = true
//                    CommonUtils.downloadVideo(url: String.getString(obj.mediaurl))
//                }
//                //CALL BACK FOR Delete Message
//                cell.DeleteCallBack = {
//                    let story = UIStoryboard(name: Storyboards.kOrders, bundle: nil)
//                    let controller = story.instantiateViewController(withIdentifier: "Identifiers.kCustomAlertPopupVC") as! CustomAlertPopupVC
//                    
//                        self.present(controller, animated: true) {
//                            controller.deleteCallBack = {
//                                self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid:String.getString(self.receiverid), bookingId: String.getString(self.communicationList?.appointmentID), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
//                        self.isDeleted = true
//                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
//                        CommonUtils.showToast(message: "message was deleted")
//                    }
//                }
//                }
//                
//                //CALL Back for Play Video
//                cell.playVideo = {
//                    self.player?.pause()
//                    
//                    let videoURL = NSURL(string: "\(String.getString(obj.mediaurl))")
//                    let player = AVPlayer(url: videoURL! as URL)
//                    let playerViewController = AVPlayerViewController()
//                    playerViewController.player = player
//                    playerViewController.modalTransitionStyle = .crossDissolve
//                    playerViewController.modalPresentationStyle = .overFullScreen
//                    self.present(playerViewController, animated: true) {
//                        playerViewController.player!.play()
//                    }
//                    self.chatTblView.reloadData()
//                }
//                return cell
//                
//            }else if obj.mediatype == "audio" {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverAudioCell", for: indexPath) as! ReceiverAudioCell
//                cell.selectionStyle = .none
//                
//                cell.viewLeadingConstraint.constant = 15
//                cell.time.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
//                
//                if cell.indicatorView.isAnimating {
//                    cell.indicatorView.stopAnimating()
//                }
//                cell.indicatorView.isHidden = true
//                cell.playBtn.isSelected = false
//                self.isPlaying = false
//                cell.playBtn.backgroundColor = CustomColor.kReceiverPlay
//                cell.lblName.isHidden = false
//                self.player?.pause()
//                let url = URL(string: obj.mediaurl ?? "")
//                let fileName =  url?.lastPathComponent ?? ""
//                let path = CommonUtils.getDocumentDirectoryPath() + "/\(fileName).m4a";
//                if fileManager.fileExists(atPath: path) {
//                    cell.playBtn.isHidden = false
//                    cell.saveBtn.isHidden = true
//                }else {
//                    cell.playBtn.isHidden = true
//                    cell.saveBtn.isHidden = false
//                }
//                cell.lblName.text = fileName
//                
//                cell.saveCallback = {
//                    CommonUtils.showHudWithNoInteraction(show: true)
//                    CommonUtils.saveFileToDocumentDirectory(url: url, fileName: "/\(fileName).m4a") { (success) in
//                        if success ?? false {
//                            cell.playBtn.isHidden = false
//                            cell.saveBtn.isHidden = true
//                        }
//                        CommonUtils.showHudWithNoInteraction(show: false)
//                    }
//                }
//                
//                cell.playCallback = {
//                    
//                    let playerItem:AVPlayerItem = AVPlayerItem(url: CommonUtils.getFileUrl(fileName: "/\(fileName).m4a"))
//                    self.player = AVPlayer(playerItem: playerItem)
//                    //obj.isSongPlayed = !obj.isSongPlayed
//                    
//                    
//                    if !self.isPlaying{
//                        //obj.isSongPlayed  = false
//                        cell.playBtn.isSelected = true
//                        cell.indicatorView.isHidden = false
//                        cell.indicatorView.startAnimating()
//                        self.isPlaying = true
//                        cell.playBtn.backgroundColor = .clear
//                        cell.lblName.isHidden = true
//                        self.player!.play()
//                    }else{
//                        //obj.isSongPlayed  = true
//                        cell.playBtn.isSelected = false
//                        cell.indicatorView.isHidden = true
//                        cell.indicatorView.stopAnimating()
//                        self.isPlaying = false
//                        cell.playBtn.backgroundColor = CustomColor.kReceiverPlay
//                        cell.lblName.isHidden = false
//                        self.player!.pause()
//                    }
//                    
//                    
//                }
//                
//                //DELETE
//                cell.DeleteCallBack = {
//                    let story = UIStoryboard(name: Storyboards.kOrders, bundle: nil)
//                    let controller = story.instantiateViewController(withIdentifier: "Identifiers.kCustomAlertPopupVC") as! CustomAlertPopupVC
//                    
//                        self.present(controller, animated: true) {
//                            controller.deleteCallBack = {
//                        
//                                self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: String.getString(self.receiverid), bookingId: String.getString(self.communicationList?.appointmentID), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
//                        
//                        print(self.CreatedBy)
//                        
//                        self.isDeleted = true
//                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
//                        CommonUtils.showToast(message: "message was deleted")
//                        
//                    }
//                }
//                }
//                
//                return cell
//                
//            }else if obj.mediatype == "document" {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverDocumentCell", for: indexPath) as! ReceiverDocumentCell
//                cell.selectionStyle = .none
//                cell.imageLeadingConstraint.constant = 20
//                cell.profileImgView.image = self.userImgView.image
//                cell.labelDocName.text = String.getString(obj.mediaName)
//                cell.labelTime.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
//                let url = String.getString(obj.thumnilimageurl)
//                cell.imageDoc.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .highPriority, completed: nil)
//                cell.viewDocumentCallBack = { [weak self] in
//                    self?.openDocumentFile(mediaurl: String.getString(obj.mediaurl), mediaName: String.getString(obj.mediaName))
//                }
//                //CALL BACK FOR Delete Message
//                cell.DeleteCallBack = {
//                    let story = UIStoryboard(name: Storyboards.kOrders, bundle: nil)
//                    let controller = story.instantiateViewController(withIdentifier: "Identifiers.kCustomAlertPopupVC") as! CustomAlertPopupVC
//                    
//                        self.present(controller, animated: true) {
//                            controller.deleteCallBack = {
//                        
//                                self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid:String.getString(self.receiverid), bookingId: String.getString(self.communicationList?.appointmentID), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
//                        self.isDeleted = true
//                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
//                        CommonUtils.showToast(message: "message was deleted")
//                      }
//                    }
//                }
//                return cell
//            }
//            else {
//                return UITableViewCell()
//            }
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
//        view.backgroundColor = .clear
//        
//        
//        let headerLabel = UILabel.init(frame: CGRect(x: (UIScreen.main.bounds.width-110)/2, y: 5, width: 110, height: 25))
//        headerLabel.backgroundColor = .white
//        headerLabel.textAlignment = .center
//        headerLabel.textColor = CustomColor.kChatHeader
//        headerLabel.font = UIFont(name: "Gotham Rounded-Medium", size: 13.0)
//        view.addSubview(headerLabel)
//        headerLabel.drawShadow()
//        headerLabel.cornerRadius = 10
//        headerLabel.clipsToBounds = true
//        let timeStamp = self.MessageObjList[section].SendingTime
//        let date1 = timeStamp.dateFromTimeStamp()
//        if date1.isToday() {
//            headerLabel.text = "Today"
//        }else if date1.isYesterday() {
//            headerLabel.text = "Yesterday"
//        }else {
//            let dateStr1  = date1.toString(withFormat: "dd MMM YYYY")
//            headerLabel.text = dateStr1
//        }
//        
//        return view
//    }
//
//}
