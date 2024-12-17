//
//  Models.swift
//  Hlthera
//
//  Created by Fluper on 04/11/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import Foundation
import UIKit

import CoreLocation

class EmergencyContactModal {
    var text:String?
    var textRelation:String?
    var id:String?
    var countryCode:String?
    var countryCodeImage:Any?
    init(data:[String : Any]) {
        text = String.getString(data["contact"])
        countryCode = String.getString(data["contact_country_code"]) == "" ? "+971" : String.getString(data["contact_country_code"])
        textRelation = String.getString(data["contact_relation"])
        id = String.getString(data["id"])
        
        countryCodeImage = String.getString(data["countryCodeImage"]) == "" ? UIImage(named: "United-Arab-Emirates") : String.getString(data["countryCodeImage"])
    }
}

//Not in use
//class CommunicationList{
//    var appointmentID:String?
//    var bookingDate:String?
//    var expertName:String?
//    var expertImage:String?
//    var status:String?
//    var expertId:String?
//    var isSelected = false
//    var createdOn:String?
//    var duration:String?
//    var appointmentFees:String?
//    var appointmentTypeImage:UIImage?
//    init(data:[String:Any]){
//        let expertDetail = kSharedInstance.getDictionary(data["expertdeatil"])
//        let expertProfile = kSharedInstance.getDictionary(expertDetail["expertprofile"])
//        self.appointmentID = String.getString(data["_id"])
//        self.bookingDate = String.getString(data["appoinment_date"])
//        self.createdOn = String.getString(data["created_on"])
//        self.duration = String.getString(data["duration"])
//        switch String.getString(data["is_accept"]) {
//        case "0":
//            self.status = " : Pending"
//        case "1":
//            self.status = " : Accepted"
//        case "2":
//            self.status = " : Rejected"
//        case "3":
//            self.status = " : Cancelled"
//        case "4":
//            self.status = " : Rescheduled"
//        case "5":
//            self.status = " : Ongoing"
//        case "6":
//            self.status = " : Completed"
//        default:
//            print("")
//        }
//        switch String.getString(data["appoinment_type"]) {
//        case "video":
//            self.appointmentFees = String.getString(expertProfile["vedio_fee"])
//            self.appointmentTypeImage = #imageLiteral(resourceName: "video_blue")
//        case "chat":
//            self.appointmentFees = String.getString(expertProfile["chat_fee"])
//            self.appointmentTypeImage = #imageLiteral(resourceName: "chat_blue")
//        case "audio":
//            self.appointmentFees = String.getString(expertProfile["call_fee"])
//            self.appointmentTypeImage = #imageLiteral(resourceName: "call_blue")
//        default:
//            self.appointmentFees = ""
//        }
//        self.expertId = String.getString(data["expert_id"])
//
//        self.expertName = String.getString(expertDetail["name"])
//
//        self.expertImage = String.getString(expertProfile["profile_picture"])
//    }
//}

class CommunicationList{
    var appointmentID:String?
    var bookingDate:String?
    var expertName:String?
    var expertImage:String?
    var status:String?
    var expertId:String?
    var isSelected = false
    var createdOn:String?
    var duration:String?
    var appointmentFees:String?
    var appointmentTypeImage:UIImage?
    init(data:[String:Any]){
        let expertDetail = kSharedInstance.getDictionary(data["expertdeatil"])
        let expertProfile = kSharedInstance.getDictionary(expertDetail["expertprofile"])
        self.appointmentID = String.getString(data["_id"])
        self.bookingDate = String.getString(data["appoinment_date"])
        self.createdOn = String.getString(data["created_on"])
        self.duration = String.getString(data["duration"])
        switch String.getString(data["is_accept"]) {
        case "0":
            self.status = " : Pending"
        case "1":
            self.status = " : Accepted"
        case "2":
            self.status = " : Rejected"
        case "3":
            self.status = " : Cancelled"
        case "4":
            self.status = " : Rescheduled"
        case "5":
            self.status = " : Ongoing"
        case "6":
            self.status = " : Completed"
        default:
            print("")
        }
        switch String.getString(data["appoinment_type"]) {
        case "video":
            self.appointmentFees = String.getString(expertProfile["vedio_fee"])
            self.appointmentTypeImage = #imageLiteral(resourceName: "video_blue")
        case "chat":
            self.appointmentFees = String.getString(expertProfile["chat_fee"])
            self.appointmentTypeImage = #imageLiteral(resourceName: "chat_blue")
        case "audio":
            self.appointmentFees = String.getString(expertProfile["call_fee"])
            self.appointmentTypeImage = #imageLiteral(resourceName: "call_blue")
        default:
            self.appointmentFees = ""
        }
        self.expertId = String.getString(data["expert_id"])
        
        self.expertName = String.getString(expertDetail["name"])
        
        self.expertImage = String.getString(expertProfile["profile_picture"])
    }
}


class AppointmentList{
    var isExpertActive:Bool?
    var expertId:String?
    var expertName:String?
    var expertImage:String?
    var expertLocation:String?
    var expertRating:String?
    var expertExperience:String?
    var expertSpeciality:String?
    var expertLatitude:String?
    var expertLongitude:String?
    var appointmentType:String?
    var appointmentStatus:String?
    var appointmentFees:String?
    var userName:String?
    var userEmail:String?
    var userMobile:String?
    var appointmentReason:String?
    var usertype:String?
    var appointmentDate:String?
    var additionalNotes:String?
    var appointmentId:String?
    var bookedOn:String?
    var bookingStatus:String?
    var status:String?
    var distance:String?
    var currentCompany:String?
    var appointmentTypeImage:UIImage?
    var duration:String?
    var isExtend:Bool?
    var createdOn:String?
    var expertDetails = [String:Any]()
    var expertprofile = [String:Any]()
    init(data:[String:Any]){
        self.expertDetails = kSharedInstance.getDictionary(data["expertdeatil"])
        self.expertprofile = kSharedInstance.getDictionary(expertDetails["expertprofile"])
        self.isExpertActive    = String.getString(expertDetails["is_active"]) != "0"
        self.appointmentId = String.getString(data["_id"])
        self.duration = String.getString(data["duration"])
        self.isExtend = String.getString(expertDetails["is_extend"]) != "0"
        self.usertype = String.getString(data["user_type"])
        self.additionalNotes  = String.getString(data["additional_note"])
        self.appointmentReason = String.getString(data["appoinment"])
        self.appointmentDate = String.getString(data["appoinment_date"])
        self.createdOn = String.getString(data["created_on"])
        self.bookedOn = String.getString(data["appoinment_date"])
        self.expertLatitude = String.getString(expertDetails["latitude"])
        self.expertLongitude = String.getString(expertDetails["longitude"])
        let coordinate0 = CLLocation(latitude: Double.getDouble(self.expertLatitude), longitude: Double.getDouble(self.expertLongitude))
        let coordinate1 = CLLocation(latitude: LocationManager.sharedInstance.latitiude, longitude: LocationManager.sharedInstance.longitude)
        self.distance = String(format: "%.1f", (coordinate0.distance(from: coordinate1)/1000)) + " Km"
        self.expertId = String.getString(data["expert_id"])
        switch String.getString(data["is_accept"]) {
        case "0":
            self.bookingStatus = "Status : Pending"
        case "1":
            self.bookingStatus = "Status : Accepted"
        case "2":
            self.bookingStatus = "Status : Rejected"
        case "3":
            self.bookingStatus = "Status : Cancelled"
        case "4":
            self.bookingStatus = "Status : Rescheduled"
        case "5":
            self.bookingStatus = "Status : Ongoing"
        case "6":
            self.bookingStatus = "Status : Completed"
        default:
            print("")
        }
        self.status = String.getString(data["is_accept"])
        self.userEmail = String.getString(data["email"])
        self.expertLocation = String.getString(expertprofile["address"])
        switch String.getString(data["appoinment_type"]) {
        case "video":
            self.appointmentType = "Video Call"
            self.appointmentFees = String.getString(expertprofile["vedio_fee"])
            self.appointmentTypeImage = #imageLiteral(resourceName: "video")
        case "chat":
            self.appointmentType = "Chat"
            self.appointmentFees = String.getString(expertprofile["chat_fee"])
            self.appointmentTypeImage = #imageLiteral(resourceName: "chat")
        case "audio":
            self.appointmentType = "Audio Call"
            self.appointmentFees = String.getString(expertprofile["call_fee"])
            self.appointmentTypeImage = #imageLiteral(resourceName: "call-1")
        default:
            self.appointmentType = ""
        }
        self.expertExperience = String.getString(expertprofile["experience"])
        self.expertImage = String.getString(expertprofile["profile_picture"])
        self.currentCompany = String.getString(expertprofile["current_company"])
        let specializationDetail = kSharedInstance.getDictionary(expertprofile["specialization_detail"])
        self.expertSpeciality = String.getString(specializationDetail["name"])
        self.expertName = String.getString(expertDetails["name"])
        self.userName = String.getString(data["full_name"])
        self.userMobile = String.getString(data["country_code"]) + String.getString(data["mobile_number"])
    }
}



class MyExpertList{
    var isExpertActive:Bool?
    var expertId:String?
    var expertName:String?
    var expertImage:String?
    var expertLocation:String?
    var expertRating:String?
    var expertExperience:String?
    var expertSpeciality:String?
    var expertLatitude:String?
    var expertLongitude:String?
    var appointmentType:String?
    var appointmentStatus:String?
    var appointmentFees:String?
    var userName:String?
    var userEmail:String?
    var userMobile:String?
    var appointmentReason:String?
    var usertype:String?
    var appointmentDate:String?
    var additionalNotes:String?
    var appointmentId:String?
    var bookedOn:String?
    var bookingStatus:String?
    var status:String?
    var distance:String?
    var currentCompany:String?
    var appointmentTypeImage:UIImage?
    var duration:String?
    var isExtend:Bool?
    var createdOn:String?
    var expertDetails = [String:Any]()
    var expertprofile = [String:Any]()
    init(data:[String:Any]){
        self.expertDetails = kSharedInstance.getDictionary(data["expertprofile"])
        self.expertprofile = kSharedInstance.getDictionary(expertDetails["expertdeatil"])
        self.isExpertActive    = String.getString(expertDetails["is_active"]) != "0"
        self.appointmentId = String.getString(data["_id"])
        self.duration = String.getString(data["duration"])
        self.isExtend = String.getString(expertDetails["is_extend"]) != "0"
        self.usertype = String.getString(data["user_type"])
        self.additionalNotes  = String.getString(data["additional_note"])
        self.appointmentReason = String.getString(data["appoinment"])
        self.appointmentDate = String.getString(data["appoinment_date"])
        self.createdOn = String.getString(data["created_on"])
        self.bookedOn = String.getString(data["appoinment_date"])
        self.expertLatitude = String.getString(expertDetails["latitude"])
        self.expertLongitude = String.getString(expertDetails["longitude"])
        let coordinate0 = CLLocation(latitude: Double.getDouble(self.expertLatitude), longitude: Double.getDouble(self.expertLongitude))
        let coordinate1 = CLLocation(latitude: LocationManager.sharedInstance.latitiude, longitude: LocationManager.sharedInstance.longitude)
        self.distance = String(format: "%.1f", (coordinate0.distance(from: coordinate1)/1000)) + " Km"
        self.expertId = String.getString(data["expert_id"])
        switch String.getString(data["is_accept"]) {
        case "0":
            self.bookingStatus = "Status : Pending"
        case "1":
            self.bookingStatus = "Status : Accepted"
        case "2":
            self.bookingStatus = "Status : Rejected"
        case "3":
            self.bookingStatus = "Status : Cancelled"
        case "4":
            self.bookingStatus = "Status : Rescheduled"
        case "5":
            self.bookingStatus = "Status : Ongoing"
        case "6":
            self.bookingStatus = "Status : Completed"
        default:
            print("")
        }
        self.status = String.getString(data["is_accept"])
        self.userEmail = String.getString(data["email"])
        self.expertLocation = String.getString(expertprofile["address"])
        switch String.getString(data["appoinment_type"]) {
        case "video":
            self.appointmentType = "Video Call"
            self.appointmentFees = String.getString(expertprofile["vedio_fee"])
            self.appointmentTypeImage = #imageLiteral(resourceName: "video")
        case "chat":
            self.appointmentType = "Chat"
            self.appointmentFees = String.getString(expertprofile["chat_fee"])
            self.appointmentTypeImage = #imageLiteral(resourceName: "chat")
        case "audio":
            self.appointmentType = "Audio Call"
            self.appointmentFees = String.getString(expertprofile["call_fee"])
            self.appointmentTypeImage = #imageLiteral(resourceName: "call-1")
        default:
            self.appointmentType = ""
        }
        self.expertExperience = String.getString(expertprofile["experience"])
        self.expertImage = String.getString(expertprofile["profile_picture"])
        self.currentCompany = String.getString(expertprofile["current_company"])
        let specializationDetail = kSharedInstance.getDictionary(expertprofile["specialization_detail"])
        self.expertSpeciality = String.getString(specializationDetail["name"])
        self.expertName = String.getString(expertDetails["name"])
        self.userName = String.getString(data["full_name"])
        self.userMobile = String.getString(data["country_code"]) + String.getString(data["mobile_number"])
    }
}
class NotificationsModel{
    internal init(dict:[String:Any]) {
        self.id = String.getString(dict["id"])
        self.user_id = String.getString(dict["user_id"])
        self.read_unread_notification = String.getString(dict["read_unread_notification"])
        self.is_type = String.getString(dict["is_type"])
        self.order_id = String.getString(dict["order_id"])
        self.message = String.getString(dict["message"])
        self.created_at = String.getString(dict["created_at"])
        self.updated_at = String.getString(dict["updated_at"])
        self.title = String.getString(dict["title"])
        self.order_request_date = String.getString(dict["order_request_date"])
    }
    
    var id = ""
    var user_id = ""
    var read_unread_notification = ""
    var is_type = ""
    var order_id = ""
    var message = ""
    var created_at = ""
    var updated_at = ""
    var order_request_date = ""
    var title = ""
}

class ServicesModel {
    
    internal init(data: [String: Any]) {
        self.id = String.getString(data["id"])
        self.pharmacy_service = String.getString(data["pharmacy_service"])
        self.service_icon = String.getString(data["service_icon"])
    }
    
    var id: String = ""
    var pharmacy_service: String = ""
    var service_icon: String = ""
}
