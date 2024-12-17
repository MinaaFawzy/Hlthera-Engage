////
////  ChatViewController_Ext_MediaChat.swift
////  RippleApp
////
////  Created by Mohd Aslam on 05/05/20.
////  Copyright © 2020 Fluper. All rights reserved.
////
//
//import UIKit
//
//extension ChatViewController {
//        
//    //MARK:- Func for Send Image To server and save Data on Firebase
//    func uploadImagesVideos(imageOrVideo:Any,isImage:Bool){
//        var param:[String:Any]?
//        if isImage{
//            param = ["image":imageOrVideo]
//        }
//        else{
//            param = ["doc":(imageOrVideo as! VideoData).videoData]
//        }
//        //upload
//        AppsNetworkManagerInstanse.requestMultipartApi(parameters: param ?? [:], serviceurl: ServiceName.updateBookingStatus, methodType: .post){result in
//            
//            let mediaDict = kSharedInstance.getDictionary(result)
//            let mediaUrl = String.getString(mediaDict["image"])
//            
//            let url = String.getString(result)
//            if isImage{
//                
//                let timeStamp = String.getString(Int(Date().timeIntervalSince1970 * 1000))
//                let completeName = self.userDetails[Parameters.name] as? String ?? ""
//                
//                let dic = [Parameters.senderid: String.getString(self.userDetails[Parameters.user_id]), Parameters.content: String.getString("Image") , Parameters.timeStamp : timeStamp , Parameters.receiverid  : String.getString(self.receiverid)  , Parameters.thumnilimageurl : "" , Parameters.mediatype : "image" ,  Parameters.isDeleted : "" ,  Parameters.sendername :  String.getString(self.userDetails[Parameters.name] ),   Parameters.mediaurl :  mediaUrl , Parameters.groupid :  "",Parameters.groupname : "","from_name" : completeName, "to_name" : self.receivername , "img_type": "Camera", Parameters.status : "not_seen"]
//                Chat_hepler.Shared_instance.SendMessage(dic: kSharedInstance.getDictionary(dic), Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: String.getString(self.receiverid), bookingId: String.getString(self.communicationList?.appointmentID))
//                //self.saveMessageLocallyInDatabase(mediaurl: mediaUrl, mediatype: "image", message: String.getString("Image"), thumnilimageurl: "")
//                //Func for resend users
//                self.unread_count += 1
//                Chat_hepler.Shared_instance.ResentUser(lastmessage:  String.getString("Image"), Receiverid: String.getString(self.receiverid), Senderid: String.getString(self.userDetails[Parameters.user_id]), name: String.getString(self.receivername), profile_image: String.getString(self.receiverprofile_image), readState: "sent", isMsgSend: true, lastTimestamp: timeStamp, msgReceiverId: String.getString(self.receiverid), unreadCount: self.unread_count , friendStatus: self.isFriend )
//                
//            }else{
//                
//                let mediaUrl = String.getString(url)
//                let thumb = ""//String.getString(data["videoThumbnail"])
//                let timeStamp = String.getString(Int(Date().timeIntervalSince1970 * 1000))
//                let completeName = self.userDetails[Parameters.name] as? String ?? ""
//                
//                let dic = [Parameters.senderid: String.getString(self.userDetails[Parameters.user_id]), Parameters.content: String.getString("Video") , Parameters.timeStamp : timeStamp , Parameters.receiverid  : String.getString(self.receiverid)  , Parameters.thumnilimageurl : String.getString(thumb) , Parameters.mediatype : "video" ,  Parameters.isDeleted : "" ,  Parameters.sendername :  String.getString(self.userDetails[Parameters.name] ),   Parameters.mediaurl :  mediaUrl , Parameters.groupid :  "",Parameters.groupname : "","from_name" : completeName, "to_name" : self.receivername, "img_type": "", Parameters.status : "not_seen"]
//                Chat_hepler.Shared_instance.SendMessage(dic: kSharedInstance.getDictionary(dic), Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: String.getString(self.receiverid), bookingId: String.getString(self.communicationList?.appointmentID))
//                //self.saveMessageLocallyInDatabase(mediaurl: mediaUrl, mediatype: "video", message: String.getString("Video"), thumnilimageurl: thumb)
//                //Func for resend users
//                self.unread_count += 1
//                Chat_hepler.Shared_instance.ResentUser(lastmessage:  String.getString("Video"), Receiverid: String.getString(self.receiverid), Senderid: String.getString(self.userDetails[Parameters.user_id]), name: String.getString(self.receivername), profile_image: String.getString(self.receiverprofile_image), readState: "sent", isMsgSend: true, lastTimestamp: timeStamp, msgReceiverId: String.getString(self.receiverid), unreadCount: self.unread_count, friendStatus: self.isFriend)
//                
//            }
//                print("Success")
//        }
//    }
//    
//    //MARK:- Func for Send Video To server and save Data on Firebase for Video
//    func uploadVideos(imageOrVideo:Any){
//        var param:[String:Any]?
//        
//            param = ["vedio":(imageOrVideo as! VideoData).videoData,
//                     "image":(imageOrVideo as! VideoData).thumbnilImage
//            ]
//        
//        
//        AppsNetworkManagerInstanse.requestMultipartApi(parameters: param ?? [:], serviceurl: ServiceName.updateBookingStatus, methodType: .post){result in
//                
//                let mediaDict = kSharedInstance.getDictionary(result)
//                let mediaUrl = String.getString(mediaDict["vedio"])
//                let thumb = String.getString(mediaDict["image"])
//                let timeStamp = String.getString(Int(Date().timeIntervalSince1970 * 1000))
//                let completeName = self.userDetails[Parameters.name] as? String ?? ""
//                
//                let dic = [Parameters.senderid: String.getString(self.userDetails[Parameters.user_id]), Parameters.content: String.getString("Video") , Parameters.timeStamp : timeStamp , Parameters.receiverid  : String.getString(self.receiverid)  , Parameters.thumnilimageurl : String.getString(thumb) , Parameters.mediatype : "video" ,  Parameters.isDeleted : "" ,  Parameters.sendername :  String.getString(self.userDetails[Parameters.name] ),   Parameters.mediaurl :  mediaUrl , Parameters.groupid :  "",Parameters.groupname : "","from_name" : completeName, "to_name" : self.receivername, "img_type": "", Parameters.status : "not_seen"]
//            Chat_hepler.Shared_instance.SendMessage(dic: kSharedInstance.getDictionary(dic), Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: String.getString(self.receiverid), bookingId: String.getString(self.communicationList?.appointmentID))
//                //self.saveMessageLocallyInDatabase(mediaurl: mediaUrl, mediatype: "video", message: String.getString("Video"), thumnilimageurl: thumb)
//                //Func for resend users
//                self.unread_count += 1
//                Chat_hepler.Shared_instance.ResentUser(lastmessage:  String.getString("Video"), Receiverid: String.getString(self.receiverid), Senderid: String.getString(self.userDetails[Parameters.user_id]), name: String.getString(self.receivername), profile_image: String.getString(self.receiverprofile_image), readState: "sent", isMsgSend: true, lastTimestamp: timeStamp, msgReceiverId: String.getString(self.receiverid), unreadCount: self.unread_count, friendStatus: self.isFriend)
//                
//            
//                print("Success")
//        }
//    }
//    
//    
//    //MARK:- Func for Send Audio To server and save Data on Firebase for Audio
//    func sendDocFile(fileURL :URL?){
//        
//        if fileURL != nil {
//            do {
//                let data = try Data(contentsOf: fileURL!)
//                let docThumbnail = Chat_hepler.Shared_instance.pdfThumbnailFromData(data: data)
//                
//                var param:[String:Any]?
//                param = ["doc":data, "image": docThumbnail ?? UIImage()]
//                
//                
//                AppsNetworkManagerInstanse.requestMultipartApi(parameters: param ?? [:], serviceurl: ServiceName.updateBookingStatus, methodType: .post){result in
//                    
//                    let mediaDict = kSharedInstance.getDictionary(result)
//                    let mediaUrl = String.getString(mediaDict["doc"])
//                    let mediaThumbImage = String.getString(mediaDict["image"])
//                    let fileName =  fileURL?.lastPathComponent ?? ""
//                    
//                    let timeStamp = String.getString(Int(Date().timeIntervalSince1970 * 1000))
//                    let completeName = self.userDetails[Parameters.name] as? String ?? ""
//                        
//                    let dic = [Parameters.senderid: String.getString(self.userDetails[Parameters.user_id]), Parameters.content: String.getString("Document") , Parameters.timeStamp : timeStamp , Parameters.receiverid  : String.getString(self.receiverid)  , Parameters.thumnilimageurl : mediaThumbImage , Parameters.mediatype : "document" ,  Parameters.isDeleted : "" ,  Parameters.sendername :  String.getString(self.userDetails[Parameters.name] ),   Parameters.mediaurl :  mediaUrl , Parameters.groupid :  "",Parameters.groupname : "","from_name" : completeName, "to_name" : self.receivername, "img_type": "", Parameters.status : "not_seen", Parameters.mediaName: fileName]
//                    Chat_hepler.Shared_instance.SendMessage(dic: kSharedInstance.getDictionary(dic), Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: String.getString(self.receiverid), bookingId: String.getString(self.communicationList?.appointmentID))
//                    //Func for resend users
//                    self.unread_count += 1
//                    //self.saveMessageLocallyInDatabase(mediaurl: mediaUrl, mediatype: "audio", message: String.getString("Audio"), thumnilimageurl: "")
//                    Chat_hepler.Shared_instance.ResentUser(lastmessage:  String.getString("Document"), Receiverid: String.getString(self.receiverid), Senderid: String.getString(self.userDetails[Parameters.user_id]), name: String.getString(self.receivername), profile_image: String.getString(self.receiverprofile_image), readState: "sent", isMsgSend: true, lastTimestamp: timeStamp, msgReceiverId: String.getString(self.receiverid), unreadCount: self.unread_count, friendStatus: self.isFriend)
//                        
//                    
//                        print("Success")
//                }
//                
//            } catch {
//                print_debug(items:"Unable to load data: \(error)")
//            }
//        }else {
//            
//        }
//        
//        
//    }
//}
