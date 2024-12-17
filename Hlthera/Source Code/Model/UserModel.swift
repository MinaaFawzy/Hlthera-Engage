//
//  UserModel.swift
//  Hlthera
//
//  Created by Fluper on 05/11/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import Foundation
import UIKit

class UserData {
    
    static var shared = UserData()
    
    var firstName:String?
    var lastName:String?
    var mobileNumber:String?
    var insuranceCompanyName:String?
    var insuranceNumber:String?
    var email:String?
    var fullName:String?
    var DOB:String?
    var Nationality:String?
    var UAENationality:String?
    var documentImage:String?
    var expiryDate:String?
    var maritalStatus:String?
    var address:String?
    var weight:String?
    var height:String?
    var bloodGroup:String?
    var emergencyNumber:[String]?
    var relation:String?
    var is_verify:String?
    var is_profile_created:Bool = false
    var status:String?
    var profilePic:String?
    var gender:String?
    var patientDetails:PatientDetailsModel?
    var otherPatientDetails:OtherPatientDetailsModel?
    var isReschedule:Bool = false
    var old_date:String = ""
    var old_slot_id:String = ""
    var hospital_id:String?
    var selectedSlotModel: selectedSlotModel?
    var appointmentType: String = ""
    var lat = 0.0
    var long = 0.0
    var locationName = ""
    var profileImage = UIImage(named: "placeholder")
    var doctorId: Int?
    var doctorData: DoctorDataResult?
    private init() {
        let data: [String:Any] = kSharedUserDefaults.getLoggedInUserDetails()
        saveData(data: data)
    }
    func saveData(data:[String:Any]){
        firstName = String.getString(data["first_name"])
        lastName = String.getString(data["last_name"])
        fullName = String.getString(data["fullname"])
        mobileNumber = String.getString(data["mobile_number"])
        insuranceCompanyName = String.getString(data["name"])
        insuranceNumber = String.getString(data["insurance_number"])
        email = String.getString(data["email"])
        DOB = String.getString(data["date_of_birth"])
        gender = String.getString(data["gender"])
        Nationality = String.getString(data["nationality"])
        UAENationality = String.getString(data[""])
        documentImage = String.getString(data[""])
        expiryDate = String.getString(data["insurance_expiry"])
        maritalStatus = String.getString(data["marital_status"])
        address = String.getString(data["address"])
        weight = String.getString(data["weight"])
        height = String.getString(data["height"])
        bloodGroup = String.getString(data["blood_group"])
        emergencyNumber = kSharedInstance.getArray(data[""]) as? [String]
        relation = String.getString(data[""])
        is_verify = String.getString(data["is_verify"])
        status = String.getString(data["status"])
        profilePic   = String.getString(data["profile_picture"])
        is_profile_created = String.getString(data["is_profile_created"]) == "1" ? true : false
    }
}

class InsuranceCompanyModel{
    var id:String?
    var name:String?
    var status:String?
    init(data:[String:Any]){
        id = String.getString(data["id"])
        name = String.getString(data["name"])
        status = String.getString(data["status"])
    }
}

class NationalityModel{
    var num_code:String?
    var alpha_2_code:String?
    var alpha_3_code:String?
    var nationality:String?
    init(data:[String:Any]){
        num_code = String.getString(data["num_code"])
        alpha_2_code = String.getString(data["alpha_2_code"])
        alpha_3_code = String.getString(data["alpha_3_code"])
        nationality = String.getString(data["nationality"])
    }
}

class SliderHomeTopBannerModel{
    var featured_specialties = [String]()
    var banners = [BannerHomeItem]()
    
    init(data: [String: Any]) {
        //        featured_specialties = data["featured_specialties"] as? [Any] ?? []
        banners = data["banners"] as? [BannerHomeItem] ?? []
        //        self.banners = kSharedInstance.getDictionaryArray(withDictionary:   data["banners"]).map{
        //            BannerHomeItem(data: $0)
        //        }
    }
}
//
//class BannerHomeItem{
//    var id:String?  = ""
//    var image:String?  = ""
//    var ad_purpose:String?  = ""
//    var service_id:String? = ""
//    var ad_from:String? = ""
//    var ad_to:String? = ""
//    var status:String? = ""
//    var created_at:String? = ""
//    var updated_at:String? = ""
//    var name:String? = ""
//
////    init(data:[String:Any]){
////        id = String.getString(data["id"])
////        image = String.getString(data["image"])
////        ad_purpose = String.getString(data["ad_purpose"])
////        service_id = String.getString(data["service_id"])
////        ad_from = String.getString(data["ad_from"])
////        ad_to = String.getString(data["ad_to"])
////        status = String.getString(data["status"])
////        created_at = String.getString(data["created_at"])
////        updated_at = String.getString(data["updated_at"])
////        name = String.getString(data["name"])
////
////    }
//}

// Welcome.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct BannerHomeModel: Codable {
    var message: String?
    var data: DataClass?
}

// DataClass.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dataClass = try? newJSONDecoder().decode(DataClass.self, from: jsonData)

import Foundation

// MARK: - DataClass
struct DataClass: Codable {
    var featuredSpecialties: [FeaturedSpecialty]?
    var banners: [BannerHomeItem]?
    
    enum CodingKeys: String, CodingKey {
        case featuredSpecialties = "featured_specialties"
        case banners
    }
}

// Banner.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let banner = try? newJSONDecoder().decode(Banner.self, from: jsonData)

import Foundation

// MARK: - Banner
struct BannerHomeItem: Codable {
    var id: Int?
    var image: String?
    var adPurpose: String?
    var serviceID: Int?
    var adFrom, adTo: String?
    var status: Int?
    var createdAt, updatedAt, name: String?
    
    enum CodingKeys: String, CodingKey {
        case id, image
        case adPurpose = "ad_purpose"
        case serviceID = "service_id"
        case adFrom = "ad_from"
        case adTo = "ad_to"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case name
    }
}

// FeaturedSpecialty.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let featuredSpecialty = try? newJSONDecoder().decode(FeaturedSpecialty.self, from: jsonData)

import Foundation

// MARK: - FeaturedSpecialty
struct FeaturedSpecialty: Codable {
    var id: Int?
    var name, shortName, fullName, image: String?
    var createdAt: String?
    var updatedAt: String?
    var deletedAt: String?
    var featured, sortingNumber: Int?
    var imagePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case shortName = "short_name"
        case fullName = "full_name"
        case image
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case featured
        case sortingNumber = "sorting_number"
        case imagePath = "image_path"
    }
}

// JSONSchemaSupport.swift

class AddAlergieModel{
    var headerName:String?
    var headerImage:UIImage?
    var addDisease:String?
    var subdisease = [String]()
    var addButtonimage:UIImage?
    init(data:[String:Any]){
        headerName = String.getString(data["headerNamw"])
        headerImage = data["image"] as? UIImage
        addButtonimage = data["addImage"] as? UIImage
        addDisease = String.getString(data["addDiseaseName"])
        subdisease = data["subDisease"] as? [String] ?? []
    }
}
class AddDiseaseModel{
    var id:String?
    var title:String?
    var meta:String?
    var image:String?
    var imgStatic = [#imageLiteral(resourceName: "CU.png"),#imageLiteral(resourceName: "alcohol"),#imageLiteral(resourceName: "placeholder")]
    var question:String?
    var disease = [String]()
    var category_type:String?
    var questionModel = [QuestionModel]()
    init(data:[String:Any]){
        let disease = kSharedInstance.getDictionaryArray(withDictionary: data["options"])
        questionModel = disease.map{QuestionModel(data: $0)}
        id = String.getString(data["id"])
        title =  String.getString(data["title"])
        meta = String.getString(data["meta"])
        image = String.getString(data["image"])
        question = String.getString(data["question"])
        category_type = String.getString(data["category_type"])
    }
}

class QuestionModel {
    var id:String?
    var lifestyle_question_id:String?
    var answer_option:String?
    var selectDises = false
    init(data:[String:Any]){
        id = String.getString(data["id"])
        lifestyle_question_id =  String.getString(data["lifestyle_question_id"])
        answer_option = String.getString(data["answer_option"])
        
    }
}


class PersonalDetail {
    
    static var shared = PersonalDetail()
    
    var firstName:String?
    
    func saveData(data:[String:Any]){
        firstName = String.getString(data["first_name"])
    }
}

class UserProfileModel{
    var id : String?
    var firstName:String?
    var lastName:String?
    var profilePicture: String?
    var email: String?
    var countryCode: String?
    var mobileNumber: String?
    var isBlock: String?
    var isVerify: String?
    var isProfileCreated: String?
    
    var fullname: String?
    var emailPersonalDetail: String?
    var mobileNumberPersonalDetail: String?
    var gender: String?
    var dateOfBirth: String?
    var nationality: String?
    var isCountryResident: String?
    var insuranceFront: String?
    var insuranceBack: String?
    var insuranceNumber: String?
    var insuranceExpiry: String?
    var maritalStatus: String?
    var address: String?
    
    var weight: String?
    var height: String?
    var bloodGroup: String?
    var medicalNotes: String?
    var allergies:[String]?
    var current_medication: [String]?
    var pastMedication:[String]?
    var chronicDisease:[String]?
    var injuries:[String]?
    var surgeries:[String]?
    var emergencyContacts:[[String:Any]]?
    
    var smokingHabit:[String]?
    var alcoholConsumption:[String]?
    var activityLevel:[String]?
    var foodPreference:[String]?
    var occupation:[String]?
    var progress:Double = 0.0
    
    init(data:[String:Any]){
        let userInfo = kSharedInstance.getDictionary(data["userinfo"])
        self.progress = Double.getDouble(data["progress_out_of_hundred"])
        self.id = String.getString(userInfo["id"])
        self.firstName = String.getString(userInfo["first_name"])
        self.lastName = String.getString(userInfo["last_name"])
        self.profilePicture = String.getString(userInfo["profile_picture"])
        self.email = String.getString(userInfo["email"])
        self.countryCode = String.getString(userInfo["country_code"])
        self.mobileNumber = String.getString(userInfo["mobile_number"])
        self.isBlock = String.getString(userInfo["is_block"])
        self.isVerify = String.getString(userInfo["is_verify"])
        self.isProfileCreated = String.getString(userInfo["is_profile_created"])
        
        let personalDetail = kSharedInstance.getDictionary(data["personalDetail"])
        self.fullname = String.getString(personalDetail["fullname"])
        self.emailPersonalDetail = String.getString(personalDetail["email"])
        self.mobileNumberPersonalDetail = String.getString(personalDetail["mobile_number"])
        self.gender = String.getString(personalDetail["gender"])
        self.dateOfBirth = String.getString(personalDetail["date_of_birth"])
        self.nationality = String.getString(personalDetail["nationality"])
        self.isCountryResident = String.getString(personalDetail["is_country_resident"])
        self.insuranceFront = String.getString(personalDetail["insurance_front"])
        self.insuranceBack = String.getString(personalDetail["insurance_back"])
        self.insuranceNumber = String.getString(personalDetail["insurance_number"])
        self.insuranceExpiry = String.getString(personalDetail["insurance_expiry"])
        self.maritalStatus = String.getString(personalDetail["marital_status"])
        self.address = String.getString(personalDetail["address"])
        
        let medicalDetail = kSharedInstance.getDictionary(data["medicalDetail"])
        self.weight = String.getString(medicalDetail["weight"])
        self.height = String.getString(medicalDetail["height"])
        self.bloodGroup = String.getString(medicalDetail["blood_group"])
        self.medicalNotes = String.getString(medicalDetail["medical_notes"])
        self.allergies = kSharedInstance.getStringArray(medicalDetail["allergies"])
        self.current_medication = kSharedInstance.getStringArray(medicalDetail["current_medication"])
        self.pastMedication = kSharedInstance.getStringArray(medicalDetail["past_medication"])
        self.chronicDisease = kSharedInstance.getStringArray(medicalDetail["chronic_disease"])
        self.injuries = kSharedInstance.getStringArray(medicalDetail["injuries"])
        self.surgeries = kSharedInstance.getStringArray(medicalDetail["surgeries"])
        self.emergencyContacts = kSharedInstance.getDictionaryArray(withDictionary: medicalDetail["emergencyContacts"])
        
        let lifestyleDetail = kSharedInstance.getDictionary(data["lifestyleDetail"])
        self.smokingHabit = kSharedInstance.getStringArray(lifestyleDetail["smoking_habit"])
        self.alcoholConsumption = kSharedInstance.getStringArray(lifestyleDetail["alcohol_consumption"])
        self.activityLevel = kSharedInstance.getStringArray(lifestyleDetail["activity_level"])
        self.foodPreference = kSharedInstance.getStringArray(lifestyleDetail["food_preference"])
        self.occupation = kSharedInstance.getStringArray(lifestyleDetail["occupation"])
    }
}

class SpecialitiesModel{
    var short_name = ""
    var full_name = ""
    var id = ""
    init(data:[String:Any]){
        self.short_name = String.getString(data["short_name"])
        self.full_name = String.getString(data["full_name"])
        self.id = String.getString(data["id"])
    }
}
class DoctorQualificationModel{
    var id = ""
    var name = ""
    init(data:[String:Any]){
        self.name = String.getString(data["name"])
        self.id = String.getString(data["id"])
    }
}

class DoctorCommunicationModel {
    var id = ""
    var doctor_id = ""
    var comm_duration = ""
    var comm_duration_type = ""
    var comm_duration_fee = ""
    var comm_service_type = ""
    init(data: [String: Any]) {
        self.id = String.getString(data["id"])
        self.doctor_id = String.getString(data["doctor_id"])
        self.comm_duration = String.getString(data["comm_duration"])
        self.comm_duration_type = String.getString(data["comm_duration_type"])
        self.comm_duration_fee = String.getString(data["comm_duration_fee"])
        self.comm_service_type = String.getString(data["comm_service_type"])
    }
}

class languageModel {
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.name = String.getString(data["name"])
    }
    
    var id = ""
    var name = ""
    
}

class DoctorDetailModel {
    var license_first = ""
    var license_second = ""
    var experience = ""
    var about_us_1 = ""
    var about_us_2 = ""
    var id = ""
    var doctor_id = ""
    var clinic_id = ""
    var date_of_birth = ""
    var country_id = ""
    var city_id = ""
    var doctor_address = ""
    var doctor_work_number = ""
    var lat = ""
    var longitude = ""
    init(data:[String:Any]) {
        self.license_first = String.getString(data["license_first"])
        self.license_second = String.getString(data["license_second"])
        self.experience = String.getString(data["experience"])
        self.about_us_1 = String.getString(data["about_us_1"])
        self.about_us_2 = String.getString(data["about_us_2"])
        self.id = String.getString(data["id"])
        self.doctor_id = String.getString(data["doctor_id"])
        self.clinic_id = String.getString(data["clinic_id"])
        self.date_of_birth = String.getString(data["date_of_birth"])
        self.country_id = String.getString(data["country_id"])
        self.city_id = String.getString(data["city_id"])
        self.doctor_address = String.getString(data["doctor_address"])
        self.doctor_work_number = String.getString(data["doctor_work_number"])
        self.lat = String.getString(data["lat"])
        self.longitude = String.getString(data["longitude"])
    }
    
}
class locationModel{
    var name = ""
    var address = ""
    init(name: String = "", address: String = "") {
        self.name = name
        self.address = address
    }
}

class DoctorDetailsModel {
    var doctor_id = ""
    var doctor_profile = ""
    var doctor_name = ""
    var doctor_exp = ""
    var address = ""
    var about_us = ""
    var doctor_specialities: [SpecialitiesModel] = []
    var doctor_qualifications: [DoctorQualificationModel] = []
    var doctor_communication_services: [DoctorCommunicationModel] = []
    var shareable_url = ""
    var isLike = -1
    var likes = ""
    var gender = ""
    var email = ""
    var mobile_number = ""
    var ratings = 0.0
    var slots: [SlotModel] = []
    var doctorDetailInfo: DoctorDetailModel?
    var doctor_services: String?
    var lat: String? = ""
    var longitude: String? = ""
    
    init(data: [String: Any]) {
        self.doctor_id = String.getString(data["doctor_id"])
        self.doctor_profile = String.getString(data["doctor_profile"])
        self.doctor_name = String.getString(data["doctor_name"])
        self.doctor_exp = String.getString(data["doctor_exp"])
        self.address = String.getString(data["address"])
        self.about_us = String.getString(data["about_us"])
        self.doctor_specialities = kSharedInstance.getDictionaryArray(withDictionary:   data["doctor_specialities"]).map{
            SpecialitiesModel(data: $0)
        }
        self.doctor_qualifications = kSharedInstance.getDictionaryArray(withDictionary: data["doctor_qualifications"]).map{
            DoctorQualificationModel(data: $0)
        }
        self.doctor_communication_services = kSharedInstance.getDictionaryArray(withDictionary: data["doctor_communication_services"]).map{
            DoctorCommunicationModel(data: $0)
        }
        self.shareable_url = String.getString(data["shareable_url"])
        self.isLike = Int.getInt(data["isLike"])
        self.likes = String.getString(data["likes"])
        self.gender = String.getString(data["gender"])
        self.email = String.getString(data["email"])
        self.ratings = Double.getDouble(data["ratings"])
        self.mobile_number = String.getString(data["mobile_number"])
        self.slots =  kSharedInstance.getArray(kSharedInstance.getDictionary(data["slotArray"])["slots"]).map {
            SlotModel(data:kSharedInstance.getDictionary($0))
        }
        self.doctorDetailInfo = DoctorDetailModel(data: kSharedInstance.getDictionary(data["doctorDetailInfo"]))
        self.doctor_services = String.getString(data["doctor_services"])
        self.lat = String.getString(data["lat"])
        self.longitude = String.getString(data["longitude"])
    }
}

class HospitalDetailModel{
    var name = ""
    var id = ""
    var profile_picture = ""
    var email = ""
    var hospital_address = ""
    var hospital_registration = ""
    var about_hospital_1 = ""
    var about_hospital_2 = ""
    var license_first = ""
    var license_second = ""
    var profile_base_url = ""
    var insurance_files_url  = ""
    var hospital_specialities:[SpecialitiesModel] = []
    var hospital_id = ""
    var hospital_profile = ""
    var hospital_name = ""
    var registration_date = ""
    var address = ""
    var about_us = ""
    var isLike = false
    var likes = ""
    var lat = ""
    var long = ""
    
    var doctorBasicInfo:[DoctorDetailsModel]?
    
    init(data:[String:Any]) {
        self.name = String.getString(data["name"])
        self.id = String.getString(data["id"])
        self.profile_picture = String.getString(data["profile_picture"])
        self.email = String.getString(data["email"])
        self.hospital_address = String.getString(data["hospital_address"])
        self.hospital_registration = String.getString(data["hospital_registration"])
        self.about_hospital_1 = String.getString(data["about_hospital_1"])
        self.about_hospital_2 = String.getString(data["about_hospital_2"])
        self.license_first = String.getString(data["license_first"])
        self.license_second = String.getString(data["license_second"])
        self.profile_base_url = String.getString(data["profile_base_url"])
        self.insurance_files_url = String.getString(data["insurance_files_url"])
        self.likes = String.getString(data["likes"])
        self.hospital_specialities = kSharedInstance.getDictionaryArray(withDictionary:   data["hospital_specialities"]).map{
            SpecialitiesModel(data: $0)
        }
        self.hospital_id = String.getString(data["hospital_id"])
        self.hospital_profile = String.getString(data["hospital_profile"])
        self.hospital_name = String.getString(data["hospital_name"])
        self.registration_date = String.getString(data["registration_date"])
        self.address = String.getString(data["address"])
        self.about_us = String.getString(data["about_us"])
        self.lat = String.getString(data["lat"])
        self.long = String.getString(data["longitude"])
        self.isLike = String.getString(data["likes"]) == "0" ? false : true
        self.doctorBasicInfo = kSharedInstance.getDictionaryArray(withDictionary: data["doctorBasicInfo"]).map{
            DoctorDetailsModel(data: $0)
        }
        
    }
    
    
}
class SavedLocationsModel:Codable{
    var lat:Double = 0.0
    var long:Double = 0.0
    var name:String = ""
    init(lat: Double = 0.0, long: Double = 0.0, name: String = "") {
        self.lat = lat
        self.long = long
        self.name = name
    }
}

class SlotModel {
    
    var slot_type = ""
    var dates = ""
    var morning: [SingleSlotModel] = []
    var afternoon: [SingleSlotModel] = []
    var evening: [SingleSlotModel] = []
    
    init(data: [String: Any]) {
        self.slot_type = String.getString(data["slot_type"])
        self.dates = String.getString(data["dates"])
        self.morning = kSharedInstance.getArray(withDictionary: data[
            "morning"]).map{SingleSlotModel(data: $0)}
        self.afternoon = kSharedInstance.getArray(withDictionary: data[
            "afternoon"]).map{SingleSlotModel(data: $0)}
        self.evening = kSharedInstance.getArray(withDictionary: data[
            "evening"]).map{SingleSlotModel(data: $0)}
    }
    
}

class SingleSlotModel {
    var id = ""
    var time = ""
    var available = false
    init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.time = String.getString(data["time"])
        self.available = String.getString(data["available"]) == "0" ? true : false
    }
    
}
class SlotTimeDateItem{
    //    var time: [String] = []
    var time = ""
    var date = ""
    init(time: String?, date: String?) {
        self.time = time ?? "";
        self.date = date ?? "";
    }
}
class SavedAddressModel{
    var id = ""
    var user_id = ""
    var address = ""
    var building = ""
    var flatNumber = ""
    var street = ""
    var city = ""
    var pincode = ""
    var isSelected = false
    var is_type = ""
    var country_id = ""
    var state_id = ""
    var city_id = ""
    var country_name = ""
    var state_name = ""
    var city_name = ""
    var mobile_no = ""
    var patient_name = ""
    var country_code = ""
    init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.user_id = String.getString(data["user_id"])
        self.address = String.getString(data["address"])
        self.city = String.getString(data["city"])
        self.pincode = String.getString(data["pincode"])
        self.country_id = String.getString(data["country_id"])
        self.state_id = String.getString(data["state_id"])
        self.city_id = String.getString(data["city_id"])
        self.country_name = String.getString(data["country_name"])
        self.state_name = String.getString(data["state_name"])
        self.city_name = String.getString(data["city_name"])
        self.building = String.getString(data["building"])
        self.flatNumber = String.getString(data["flat_number"])
        self.street = String.getString(data["street"])
        self.is_type = String.getString(data["is_type"])
        self.mobile_no = String.getString(data["mobile_no"])
        self.patient_name = String.getString(data["patient_name"])
        self.country_code = String.getString(data["country_code"])
    }
    
}
class PatientDetailsModel{
    internal init(patient_name: String = "", patient_age: String = "", patient_gender: String = "", patient_email: String = "", patient_mobile: String = "", patient_countryCode:String = "", address_id: String = "",is_save_address:Bool,address:String = "",city:String = "", pincode:String = "",is_future_address:Bool) {
        self.patient_name = patient_name
        self.patient_age = patient_age
        self.patient_gender = patient_gender
        self.patient_email = patient_email
        self.patient_mobile = patient_mobile
        self.address_id = address_id
        self.is_save_address = is_save_address
        self.address = address
        self.city = city
        self.pincode = pincode
        self.patient_countryCode = patient_countryCode
        self.is_future_address = is_future_address
    }
    var patient_name = ""
    var patient_age = ""
    var patient_gender = ""
    var patient_email = ""
    var patient_mobile = ""
    var patient_countryCode = ""
    var address_id = ""
    var is_save_address = false
    var is_future_address = false
    var address = ""
    var city = ""
    var pincode = ""
}

class selectedSlotModel {
    internal init(appointment_type: String = "", slot_id: String = "", date: String = "", doctor_id: String = "", fees: String = "", total_amount: String = "",slot_time:String = "") {
        self.appointment_type = appointment_type
        self.slot_id = slot_id
        self.slot_time = slot_time
        self.date = date
        self.doctor_id = doctor_id
        self.fees = fees
        self.total_amount = total_amount
    }
    
    var appointment_type = ""
    var slot_id = ""
    var date = ""
    var doctor_id = ""
    var fees = ""
    var total_amount = ""
    var slot_time = ""
}

class OtherPatientDetailsModel {
    init(other_patient_name: String = "", other_patient_age: String = "", other_patient_relation: String = "", other_patient_mobile: String = "", other_patient_countryCode:String = "", other_patient_insurance: String = "", other_patient_imageFront: UIImage = UIImage(), other_patient_imageBack: UIImage = UIImage(), other_notes: String = "", other_patient_gender:String = "",other_email:String = "") {
        self.other_patient_name = other_patient_name
        self.other_patient_age = other_patient_age
        self.other_patient_relation = other_patient_relation
        self.other_patient_mobile = other_patient_mobile
        self.other_patient_insurance = other_patient_insurance
        self.other_patient_imageFront = other_patient_imageFront
        self.other_patient_imageBack = other_patient_imageBack
        self.other_notes = other_notes
        self.other_patient_gender = other_patient_gender
        self.other_email = other_email
        self.other_patient_countryCode = other_patient_countryCode
        
    }
    
    var other_patient_name = ""
    var other_patient_age = ""
    var other_patient_relation = ""
    var other_patient_mobile = ""
    var other_patient_countryCode = ""
    var other_patient_insurance = ""
    var other_patient_imageFront = UIImage()
    var other_patient_imageBack = UIImage()
    var other_notes = ""
    var other_patient_gender = ""
    var other_email = ""
    
}
class CouponModel{
    var id = ""
    var name = ""
    var promocode = ""
    var promo_image = ""
    var promo_discount = ""
    var benifits:CouponBenfitsModel?
    init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.name = String.getString(data["name"])
        self.promocode = String.getString(data["promocode"])
        self.promo_discount = String.getString(data["promo_discount"])
        self.promo_image = String.getString(data["promo_image"])
        self.benifits = CouponBenfitsModel(data: kSharedInstance.getDictionary(data["benifits"]))
    }
    
}
class CouponBenfitsModel{
    var id = ""
    var promo_id = ""
    var long_desc = ""
    init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.promo_id = String.getString(data["promo_id"])
        self.long_desc = String.getString(data["long_desc"])
    }
}
class BookingDataModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.appointment_type = String.getString(data["appointment_type"])
        self.slot_id = String.getString(data["slot_id"])
        self.date = String.getString(data["date"])
        self.doctor_id = String.getString(data["doctor_id"])
        //        self.doctor_id = Int.getInt(data["doctor_id"])
        self.user_id = String.getString(data["user_id"])
        self.fees = String.getString(data["fees"])
        self.total_amount = String.getString(data["total_amount"])
        self.address_id = String.getString(data["address_id"])
        self.patient_name = String.getString(data["patient_name"])
        self.patient_age = String.getString(data["patient_age"])
        self.patient_gender = String.getString(data["patient_gender"])
        self.patient_email = String.getString(data["patient_email"])
        self.patient_countryCode = String.getString(data["patient_countryCode"])
        self.patient_mobile = String.getString(data["patient_mobile"])
        self.other_patient_name = String.getString(data["other_patient_name"])
        self.other_patient_age = String.getString(data["other_patient_age"])
        self.other_patient_relation = String.getString(data["other_patient_relation"])
        self.other_patient_countryCode = String.getString(data["other_patient_countryCode"])
        self.other_patient_mobile = String.getString(data["other_patient_mobile"])
        self.other_patient_insurance = String.getString(data["other_patient_insurance"])
        self.other_patient_imageFront = String.getString(data["other_patient_imageFront"])
        self.other_patient_imageBack = String.getString(data["other_patient_imageBack"])
        self.other_notes = String.getString(data["other_notes"])
        self.status = String.getString(data["status"])
        self.hospital_id = String.getString(data["hospital_id"])
        self.cancellation_reason = String.getString(data["cancellation_reason"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        self.doctor_information = DoctorDetailModel(data: kSharedInstance.getDictionary(data["doctor_information"]))
        self.doctor_specialities = String.getString(kSharedInstance.getDictionary(data["doctor_specialities"])["specialities"]).components(separatedBy: ",")
        self.doctor = BookingDoctorDetailsModel(data: kSharedInstance.getDictionary(data["doctor"]))
        self.user_information = UserProfileModel(data: kSharedInstance.getDictionary(data["user_information"]))
        self.doctor_service_fee = DoctorCommunicationModel(data: kSharedInstance.getDictionary(data["doctor_service_fee"]))
        self.doctor_slot_information = BookingSlotInformationModel(data: kSharedInstance.getDictionary(data["doctor_slot_information"]))
    }
    
    var id = ""
    var appointment_type = ""
    var slot_id = ""
    var date = ""
    
    //    var doctor_id = 0
    var doctor_id = ""
    
    var user_id = ""
    var fees = ""
    var total_amount = ""
    var address_id = ""
    var patient_name = ""
    var patient_age = ""
    var patient_gender = ""
    var patient_email = ""
    var patient_countryCode = ""
    var patient_mobile = ""
    var other_patient_name = ""
    var other_patient_age = ""
    var other_patient_relation = ""
    var other_patient_countryCode = ""
    var other_patient_mobile = ""
    var other_patient_insurance = ""
    var other_patient_imageFront = ""
    var other_patient_imageBack = ""
    var other_notes = ""
    var status = ""
    var hospital_id = ""
    var cancellation_reason = ""
    var created_at = ""
    var updated_at = ""
    var doctor_information:DoctorDetailModel?
    var doctor_specialities:[String] = []
    var doctor:BookingDoctorDetailsModel?
    var doctor_service_fee:DoctorCommunicationModel?
    var doctor_slot_information:BookingSlotInformationModel?
    var user_information:UserProfileModel?
}

class BookingSlotInformationModel {
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.doctor_id = String.getString(data["doctor_id"])
        self.comm_type = String.getString(data["comm_type"])
        self.slot_time = String.getString(data["slot_time"])
        self.slot_type = String.getString(data["slot_type"])
        self.date = String.getString(data["date"])
        self.is_available = String.getString(data["is_available"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
    }
    
    var id = ""
    var doctor_id = ""
    var comm_type = ""
    var slot_time = ""
    var slot_type = ""
    var date = ""
    var is_available = ""
    var created_at = ""
    var updated_at = ""
}
class BookingDoctorDetailsModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.name = String.getString(data["name"])
        self.email = String.getString(data["email"])
        self.country_code = String.getString(data["country_code"])
        self.mobile_number = String.getString(data["mobile_number"])
        self.gender = String.getString(data["gender"])
        self.email_verified_at = String.getString(data["email_verified_at"])
        self.password = String.getString(data["password"])
        self.remember_token = String.getString(data["remember_token"])
        self.social_id = String.getString(data["social_id"])
        self.login_type = String.getString(data["login_type"])
        self.otp = String.getString(data["otp"])
        self.otp_time = String.getString(data["otp_time"])
        self.is_verify = String.getString(data["is_verify"])
        self.is_profile_created = String.getString(data["is_profile_created"])
        self.is_individual = String.getString(data["is_individual"])
        self.profile_picture = String.getString(data["profile_picture"])
        self.is_hospital_verify = String.getString(data["is_hospital_verify"])
        self.is_admin_verify = String.getString(data["is_admin_verify"])
        self.is_block = String.getString(data["is_block"])
        self.likes = String.getString(data["likes"])
        self.availablity_status = String.getString(data["availablity_status"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        self.is_available_today = String.getString(data["is_available_today"]) == "0" ? false : true
    }
    
    var id = ""
    var name = ""
    var email = ""
    var country_code = ""
    var mobile_number = ""
    var gender = ""
    var email_verified_at = ""
    var password = ""
    var remember_token = ""
    var social_id = ""
    var login_type = ""
    var otp = ""
    var otp_time = ""
    var is_verify = ""
    var is_profile_created = ""
    var is_individual = ""
    var profile_picture = ""
    var is_hospital_verify = ""
    var is_admin_verify = ""
    var is_block = ""
    var likes = ""
    var availablity_status = ""
    var created_at = ""
    var updated_at = ""
    var is_available_today = false
}
class CancellationReasonsModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.cancel_reason =  String.getString(data["cancel_reason"])
        self.status =  String.getString(data["status"])
    }
    
    var id = ""
    var cancel_reason = ""
    var status = ""
}
class SurveyQuestionsModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.title = String.getString(data["title"])
        self.question = String.getString(data["question"])
        self.status = String.getString(data["status"])
    }
    
    var id = ""
    var title = ""
    var question = ""
    var status = ""
}
class SurveyQuestionModel{
    internal init(qnId: String = "", answer: String = "") {
        self.qnId = qnId
        self.answer = answer
    }
    
    var qnId = ""
    var answer = ""
}

//MARK: for doctorRatingVC
struct DoctorRatingReview: Codable {
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.ratingType = String.getString(data["rating_type"])
        self.doctorID = String.getString(data["doctor_id"])
        self.comments = String.getString(data["comments"])
        self.ratings = String.getString(data["ratings"])
        self.firstName = String.getString(data["first_name"])
        self.lastName = String.getString(data["last_name"])
    }
    
    var id: String = ""
    var ratingType = ""
    var doctorID = ""
    var comments: String = ""
    var ratings: String = ""
    var firstName: String = ""
    var lastName: String = ""
}

class RatingModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.rating_type = String.getString(data["rating_type"])
        self.ratings = String.getString(data["ratings"])
        self.doctor_id = String.getString(data["doctor_id"])
        self.comments = String.getString(data["comments"])
        self.booking_id = String.getString(data["booking_id"])
        self.user_id = String.getString(data["user_id"])
        self.rating_date_time = String.getString(data["rating_date_time"])
        self.full_name = String.getString(kSharedInstance.getDictionary(data["user"])["fullname"])
        self.profile_picture = String.getString(kSharedInstance.getDictionary(data["user"])["profile_picture"])
    }
    
    var id = ""
    var rating_type = ""
    var ratings = ""
    var doctor_id = ""
    var comments = ""
    var booking_id = ""
    var user_id = ""
    var rating_date_time = ""
    var full_name = ""
    var profile_picture = ""
}
class SavedCardsModel{
    internal init(dict:[String:Any]) {
        self.id = String.getString(dict["id"])
        self.card_name = String.getString(dict["card_name"])
        self.card_number = String.getString(dict["card_number"])
        self.expiry_date = String.getString(dict["expiry_date"])
        self.cvv = String.getString(dict["cvv"])
        self.created_at = String.getString(dict["created_at"])
        self.updated_at = String.getString(dict["updated_at"])
    }
    
    var id = ""
    var card_name = ""
    var card_number = ""
    var expiry_date = ""
    var cvv = ""
    var created_at = ""
    var updated_at = ""
    var isSelected = false
}
class CountryStateCityModel{
    internal init(dict:[String:Any]) {
        self.id = String.getString(dict["id"])
        self.name = String.getString(dict["name"])
    }
    
    var id = ""
    var name = ""
    
}
class PharmacyCategoriesModel{
    internal init(dict:[String:Any]) {
        self.id = String.getString(dict["id"])
        self.category_name = String.getString(dict["category_name"])
        self.category_image = String.getString(dict["category_image"])
        self.categories = kSharedInstance.getArray(dict["categories"]).map{PharmacySubCategoryModel(dict: kSharedInstance.getDictionary($0))}
    }
    var id = ""
    var category_name = ""
    var category_image = ""
    var categories:[PharmacySubCategoryModel] = []
    var isSelected = false
}
class PharmacySubCategoryModel{
    internal init(dict:[String:Any]) {
        self.id = String.getString(dict["id"])
        self.category_type_id = String.getString(dict["category_type_id"])
        self.parent_id = String.getString(dict["parent_id"])
        self.category_slug = String.getString(dict["category_slug"])
        self.category_name = String.getString(dict["category_name"])
        self.category_image = String.getString(dict["category_image"])
        self.status = String.getString(dict["status"])
        self.created_at = String.getString(dict["created_at"])
        self.updated_at = String.getString(dict["updated_at"])
    }
    var id = ""
    var category_type_id = ""
    var parent_id = ""
    var category_slug = ""
    var category_name = ""
    var category_image = ""
    var status = ""
    var created_at = ""
    var updated_at = ""
    var isSelected = false
}
class PharmacyProductModel{
    internal init(dict:[String:Any]) {
        self.id = String.getString(dict["id"])
        self.pharmacy_id = String.getString(dict["pharmacy_id"])
        self.category_id = String.getString(dict["category_id"])
        self.subCategory_id = String.getString(dict["subCategory_id"])
        self.name = String.getString(dict["name"])
        self.main_price = String.getString(dict["main_price"])
        self.total_price = String.getString(dict["total_price"])
        self.quantity = String.getString(dict["quantity"])
        self.main_image = String.getString(dict["main_image"])
        self.is_wishlist = String.getString(dict["is_wishlist"]) == "0" ? false : true
        self.wishlist_id = String.getString(dict["wishlist_id"])
        self.is_added = String.getString(dict["is_added"])
        self.cart_id = String.getString(dict["cart_id"])
        self.sold_out_qty = String.getString(dict["sold_out_qty"])
        self.sort_desc = String.getString(dict["sort_desc"]).isEmpty ? (String.getString(dict["short_desc"])) : (String.getString(dict["sort_desc"]))
        self.long_description = String.getString(dict["long_description"])
        self.about_product = String.getString(dict["about_product"])
        self.product_benifit = dict["product_benifit"] as? [String] ?? []
        self.howtouse = String.getString(dict["howtouse"])
        self.created_at = String.getString(dict["created_at"])
        self.updated_at = String.getString(dict["updated_at"])
        self.pharmacy_name = String.getString(dict["pharmacy_name"])
        self.pharmacy_address = String.getString(dict["pharmacy_address"])
        self.product_images = kSharedInstance.getArray(dict["product_images"]).map{PharmacyProductImageModel(dict: kSharedInstance.getDictionary($0))}
        self.is_prescribed = String.getString(dict["is_prescribed"]) == "0" ? false : true
        self.order_status = kSharedInstance.getArray(dict["order_status"]).map{OrderStatusModel(data:kSharedInstance.getDictionary($0))}
        self.estimted_delivery = String.getString(dict["estimted_delivery"])
        self.address_details = SavedAddressModel(data: kSharedInstance.getDictionary(dict["address_details"]))
    }
    
    var id = ""
    var pharmacy_id = ""
    var category_id = ""
    var subCategory_id = ""
    var name = ""
    var main_price = ""
    var total_price = ""
    var quantity = ""
    var main_image  = ""
    var is_wishlist = false
    var wishlist_id = ""
    var is_added = ""
    var cart_id = ""
    var sold_out_qty = ""
    var sort_desc = ""
    var long_description = ""
    var about_product = ""
    var product_benifit:[String] = []
    var howtouse = ""
    var created_at = ""
    var updated_at = ""
    var pharmacy_name = ""
    var pharmacy_address = ""
    var product_images:[PharmacyProductImageModel] = []
    var is_prescribed = false
    var order_status:[OrderStatusModel] = []
    var address_details:SavedAddressModel?
    var estimted_delivery = ""
}
class PharmacyProductImageModel{
    internal init(dict:[String:Any]){
        self.id = String.getString(dict["id"])
        self.product_id = String.getString(dict["product_id"])
        self.images = String.getString(dict["images"])
        self.created_at = String.getString(dict["created_at"])
        self.updated_at = String.getString(dict["updated_at"])
    }
    
    var id = ""
    var product_id = ""
    var images = ""
    var created_at = ""
    var updated_at = ""
}
class PharmacyCartModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.user_id = String.getString(data["user_id"])
        self.pharmacy_id = String.getString(data["pharmacy_id"])
        self.product_id = String.getString(data["product_id"])
        self.price = String.getString(data["price"])
        self.quantity = String.getString(data["quantity"])
        self.product = PharmacyProductModel(dict:kSharedInstance.getDictionary(data["product"]))
    }
    var id = ""
    var user_id = ""
    var pharmacy_id = ""
    var product_id = ""
    var price = ""
    var quantity = ""
    var product:PharmacyProductModel?
}
class PharmacyOrderModel{
    internal init(data:[String:Any]) {
        self.message = String.getString(data["message"])
        self.order_id = String.getString(data["order_id"])
        self.product_count = String.getString(data["product_count"])
        self.total_price = String.getString(data["total_price"])
        self.url = String.getString(data["url"])
        self.order_Status = String.getString(data["order_Status"])
        self.transaction = String.getString(data["transaction"])
        self.created_at = String.getString(data["created_at"])
        self.address = String.getString(data["address"])
        self.id = String.getString(data["id"])
        self.user_id = String.getString(data["user_id"])
        self.coupon_id = String.getString(data["coupon_id"])
        self.order_Date = String.getString(data["order_Date"])
        self.delivery_date = String.getString(data["delivery_date"])
        self.discount = String.getString(data["discount"])
        self.coupon_price = String.getString(data["coupon_price"])
        self.delivery_charge = String.getString(data["delivery_charge"])
        self.address_id = String.getString(data["address_id"])
        let images = kSharedInstance.getArray(data["image"])
        self.image = images.map{kSharedInstance.getDictionary($0)["product_image"] as? String ?? ""}
        self.address_details = SavedAddressModel(data: kSharedInstance.getDictionary(data["address_details"]))
    }
    
    
    
    var message = ""
    var order_id = ""
    var product_count = ""
    var total_price = ""
    var url = ""
    var order_Status = ""
    var transaction = ""
    var created_at = ""
    var address = ""
    var id = ""
    var user_id = ""
    var coupon_id = ""
    var order_Date = ""
    var delivery_date = ""
    var discount = ""
    var coupon_price = ""
    var delivery_charge = ""
    var address_id = ""
    var image:[String] = []
    var address_details:SavedAddressModel?
}

class OrderStatusModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.order_detail_id = String.getString(data["order_detail_id"])
        self.status = String.getString(data["status"])
        self.status_date = String.getString(data["status_date"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
    }
    
    var id = ""
    var order_detail_id = ""
    var status = ""
    var status_date = ""
    var created_at = ""
    var updated_at = ""
}
class QuickOptionsModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.quick_option = String.getString(data["quick_option"])
        self.quick_icon = String.getString(data["quick_icon"])
    }
    
    var id = ""
    var quick_option = ""
    var quick_icon = ""
}

struct TimeSoltResponse: Codable {
    var timeslots: [String]?
}


struct GenerateZoomUrlResponse: Codable {
    var zoomURL: String?
    var zoomID: Int?
    var zoomPassword: String?
    var status: Int?
    
    enum CodingKeys: String, CodingKey {
        case zoomURL = "zoom_url"
        case zoomID = "zoom_id"
        case zoomPassword = "zoom_password"
        case status
    }
}



struct DataResponeOnGoingSearch: Codable {
    var message: String?
    var status, timestamp: Int?
    var result: [ResultOnGoingSearch]?
}

struct ResultOnGoingSearch: Codable {
    var id: Int?
    var appointmentType, slotID, date, doctorID: String?
    var userID, fees, totalAmount, addressID: String?
    var patientName: String?
    var patientAge, patientGender: String?
    var patientEmail: String?
    var patientCountryCode: String?
    var patientMobile: String?
    var otherPatientName, otherPatientAge, otherPatientRelation, otherPatientCountryCode: String?
    var otherPatientMobile, otherPatientInsurance: String?
    var otherPatientImageFront, otherPatientImageBack: String?
    var otherNotes: String?
    var status, hospitalID: Int?
    var cancellationReason: String?
    var createdAt, updatedAt: String?
    var instaAppointmentID: String?
    var zoomLink: String?
    var ratings: Double?
    var doctorInformation: DoctorInformationOnGogingSearch?
    var doctorSpecialities: DoctorSpecialitiesOnGogingSearch?
    var doctor: DoctorOnGogingSearch?
    var doctorSlotInformation: DoctorSlotInformationOnGogingSearch?
    var doctorServiceFee: DoctorServiceFeeOnGogingSearch?
    var userInformation: UserInformationOnGogingSearch?
    var totalReview, isScheduled: Int?
    var hospital: HospitalModel?
    
    enum CodingKeys: String, CodingKey {
        case id
        case appointmentType = "appointment_type"
        case slotID = "slot_id"
        case date
        case doctorID = "doctor_id"
        case userID = "user_id"
        case fees
        case totalAmount = "total_amount"
        case addressID = "address_id"
        case patientName = "patient_name"
        case patientAge = "patient_age"
        case patientGender = "patient_gender"
        case patientEmail = "patient_email"
        case patientCountryCode = "patient_countryCode"
        case patientMobile = "patient_mobile"
        case otherPatientName = "other_patient_name"
        case otherPatientAge = "other_patient_age"
        case otherPatientRelation = "other_patient_relation"
        case otherPatientCountryCode = "other_patient_countryCode"
        case otherPatientMobile = "other_patient_mobile"
        case otherPatientInsurance = "other_patient_insurance"
        case otherPatientImageFront = "other_patient_imageFront"
        case otherPatientImageBack = "other_patient_imageBack"
        case otherNotes = "other_notes"
        case status
        case hospitalID = "hospital_id"
        case cancellationReason = "cancellation_reason"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case instaAppointmentID = "insta_appointment_id"
        case zoomLink = "zoom_link"
        case ratings
        case doctorInformation = "doctor_information"
        case doctorSpecialities = "doctor_specialities"
        case doctor
        case hospital
        case doctorSlotInformation = "doctor_slot_information"
        case doctorServiceFee = "doctor_service_fee"
        case userInformation = "user_information"
        case totalReview = "total_review"
        case isScheduled = "is_scheduled"
    }
}
struct HospitalModel: Codable {
    let id: Int
    let name, email, countryCode, mobileNumber: String
    let gender: String
    let socialID: String?
    let loginType: Int
    let otp, otpTime: String?
    let isVerify, isProfileCreated: Int
    let emailVerifiedAt: String?
    let password, profilePicture: String?
    let isAdminVerify, isBlock, likes, availablityStatus: Int
    let rememberToken: String?
    let hospitalGeneratedCode: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case countryCode = "country_code"
        case mobileNumber = "mobile_number"
        case gender
        case socialID = "social_id"
        case loginType = "login_type"
        case otp
        case otpTime = "otp_time"
        case isVerify = "is_verify"
        case isProfileCreated = "is_profile_created"
        case emailVerifiedAt = "email_verified_at"
        case password
        case profilePicture = "profile_picture"
        case isAdminVerify = "is_admin_verify"
        case isBlock = "is_block"
        case likes
        case availablityStatus = "availablity_status"
        case rememberToken = "remember_token"
        case hospitalGeneratedCode = "hospital_generated_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct DoctorOnGogingSearch: Codable {
    var id: Int?
    var instaHmsID: String?
    var name: String?
    var email: String?
    var countryCode: String?
    var mobileNumber: String?
    var gender: String?
    var emailVerifiedAt: String?
    var password: String?
    var rememberToken, socialID: String?
    var loginType: Int?
    var otp: String?
    var otpTime: String?
    var isVerify, isProfileCreated: Int?
    var isIndividual: String?
    var profilePicture: String?
    var isHospitalVerify, isAdminVerify, isBlock, likes: Int?
    var availablityStatus, accountType: Int?
    var hospitalGeneratedCode, docterVerifiedByHospital: String?
    var createdAt: String?
    var updatedAt: String?
    var isAvailableToday: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case instaHmsID = "insta_hms_id"
        case name, email
        case countryCode = "country_code"
        case mobileNumber = "mobile_number"
        case gender
        case emailVerifiedAt = "email_verified_at"
        case password
        case rememberToken = "remember_token"
        case socialID = "social_id"
        case loginType = "login_type"
        case otp
        case otpTime = "otp_time"
        case isVerify = "is_verify"
        case isProfileCreated = "is_profile_created"
        case isIndividual = "is_individual"
        case profilePicture = "profile_picture"
        case isHospitalVerify = "is_hospital_verify"
        case isAdminVerify = "is_admin_verify"
        case isBlock = "is_block"
        case likes
        case availablityStatus = "availablity_status"
        case accountType = "account_type"
        case hospitalGeneratedCode = "hospital_generated_code"
        case docterVerifiedByHospital = "docter_verified_by_hospital"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isAvailableToday = "is_available_today"
    }
}

struct DoctorInformationOnGogingSearch: Codable {
    var id: Int?
    var doctorID: String?
    var clinicID: String?
    var dateOfBirth: String?
    var countryID, cityID: String?
    var doctorAddress: String?
    var doctorWorkNumber: String?
    var aboutUs1: String?
    var aboutUs2: String?
    var licenseFirst: String?
    var licenseSecond: String?
    var experience: String?
    var lat, longitude: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case doctorID = "doctor_id"
        case clinicID = "clinic_id"
        case dateOfBirth = "date_of_birth"
        case countryID = "country_id"
        case cityID = "city_id"
        case doctorAddress = "doctor_address"
        case doctorWorkNumber = "doctor_work_number"
        case aboutUs1 = "about_us_1"
        case aboutUs2 = "about_us_2"
        case licenseFirst = "license_first"
        case licenseSecond = "license_second"
        case experience, lat, longitude
    }
}

struct DoctorServiceFeeOnGogingSearch: Codable {
    var id, doctorID: Int?
    var commDuration: String?
    var commDurationType: String?
    var commDurationFee: Int?
    var commServiceType: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case doctorID = "doctor_id"
        case commDuration = "comm_duration"
        case commDurationType = "comm_duration_type"
        case commDurationFee = "comm_duration_fee"
        case commServiceType = "comm_service_type"
    }
}

struct DoctorSlotInformationOnGogingSearch: Codable {
    var id, doctorID, commType: Int?
    var slotTime: String?
    var slotType: Int?
    var date: String?
    var isAvailable: Int?
    var createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case doctorID = "doctor_id"
        case commType = "comm_type"
        case slotTime = "slot_time"
        case slotType = "slot_type"
        case date
        case isAvailable = "is_available"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct DoctorSpecialitiesOnGogingSearch: Codable {
    var specialities: String?
}

struct UserInformationOnGogingSearch: Codable {
    var id: Int?
    var fullname: String?
    var profilePicture: String?
    var email: String?
    var countryCode: String?
    var mobileNumber: String?
    var dateOfBirth: String?
    var gender: Int?
    var accessToken: String?
    var otp: String?
    var otpTime: String?
    var isBlock, isVerify, loginType: Int?
    var langID: String?
    var isProfileCreated: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, fullname
        case profilePicture = "profile_picture"
        case email
        case countryCode = "country_code"
        case mobileNumber = "mobile_number"
        case dateOfBirth = "date_of_birth"
        case gender
        case accessToken = "access_token"
        case otp
        case otpTime = "otp_time"
        case isBlock = "is_block"
        case isVerify = "is_verify"
        case loginType = "login_type"
        case langID = "lang_id"
        case isProfileCreated = "is_profile_created"
    }
}

///===========================================
struct DataResponeOnGoingSearch2: Codable {
    var message: String?
    var status, timestamp: Int?
    var result: [ResultOnGoingSearch]?
}

struct ResultOnGoingSearch2: Codable {
    var id: Int?
    var appointmentType, slotID, date, doctorID: String?
    var userID, fees, totalAmount, addressID: String?
    var patientName, patientAge, patientGender, patientEmail: String?
    var patientCountryCode: String?
    var patientMobile: String?
    var otherPatientName, otherPatientAge, otherPatientRelation, otherPatientCountryCode: String?
    var otherPatientMobile, otherPatientInsurance: String?
    var otherPatientImageFront, otherPatientImageBack: String?
    var otherNotes: String?
    var status, hospitalID: Int?
    var cancellationReason: String?
    var createdAt, updatedAt: String?
    var ratings: Int?
    var doctorInformation: DoctorInformationOnGoing2?
    var doctorSpecialities: [DoctorSpecialitiesOnGoing2]?
    var doctor: DoctorOnGogingSearch2?
    
    //    var doctorSlotInformation: String?
    var doctorSlotInformation: BookingSlotInfoOnGoing2?
    
    var doctorServiceFee: DoctorServiceFeeOnGoing2?
    var userInformation: UserInformationOnGoing2?
    var totalReview, isScheduled: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case appointmentType = "appointment_type"
        case slotID = "slot_id"
        case date
        case doctorID = "doctor_id"
        case userID = "user_id"
        case fees
        case totalAmount = "total_amount"
        case addressID = "address_id"
        case patientName = "patient_name"
        case patientAge = "patient_age"
        case patientGender = "patient_gender"
        case patientEmail = "patient_email"
        case patientCountryCode = "patient_countryCode"
        case patientMobile = "patient_mobile"
        case otherPatientName = "other_patient_name"
        case otherPatientAge = "other_patient_age"
        case otherPatientRelation = "other_patient_relation"
        case otherPatientCountryCode = "other_patient_countryCode"
        case otherPatientMobile = "other_patient_mobile"
        case otherPatientInsurance = "other_patient_insurance"
        case otherPatientImageFront = "other_patient_imageFront"
        case otherPatientImageBack = "other_patient_imageBack"
        case otherNotes = "other_notes"
        case status
        case hospitalID = "hospital_id"
        case cancellationReason = "cancellation_reason"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case ratings
        case doctorInformation = "doctor_information"
        case doctorSpecialities = "doctor_specialities"
        case doctor
        case doctorSlotInformation = "doctor_slot_information"
        case doctorServiceFee = "doctor_service_fee"
        case userInformation = "user_information"
        case totalReview = "total_review"
        case isScheduled = "is_scheduled"
    }
}

struct DoctorOnGogingSearch2: Codable {
    var id: Int?
    var instaHmsID, name, email, countryCode: String?
    var mobileNumber, gender: String?
    var emailVerifiedAt: String?
    var password: String?
    var rememberToken, socialID: String?
    var loginType: Int?
    var otp, otpTime: String?
    var isVerify, isProfileCreated: Int?
    var isIndividual, profilePicture: String?
    var isHospitalVerify, isAdminVerify, isBlock, likes: Int?
    var availablityStatus, accountType: Int?
    var hospitalGeneratedCode, docterVerifiedByHospital, createdAt, updatedAt: String?
    
    //    var isAvailableToday: Int?
    var isAvailableToday: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case instaHmsID = "insta_hms_id"
        case name, email
        case countryCode = "country_code"
        case mobileNumber = "mobile_number"
        case gender
        case emailVerifiedAt = "email_verified_at"
        case password
        case rememberToken = "remember_token"
        case socialID = "social_id"
        case loginType = "login_type"
        case otp
        case otpTime = "otp_time"
        case isVerify = "is_verify"
        case isProfileCreated = "is_profile_created"
        case isIndividual = "is_individual"
        case profilePicture = "profile_picture"
        case isHospitalVerify = "is_hospital_verify"
        case isAdminVerify = "is_admin_verify"
        case isBlock = "is_block"
        case likes
        case availablityStatus = "availablity_status"
        case accountType = "account_type"
        case hospitalGeneratedCode = "hospital_generated_code"
        case docterVerifiedByHospital = "docter_verified_by_hospital"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isAvailableToday = "is_available_today"
    }
}

struct DoctorInformationOnGoing2: Codable {
    var id: Int?
    var doctorID, clinicID, dateOfBirth: String?
    var countryID, cityID: String?
    var doctorAddress, doctorWorkNumber, aboutUs1: String?
    var aboutUs2: String?
    var licenseFirst, licenseSecond, experience: String?
    var lat, longitude: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case doctorID = "doctor_id"
        case clinicID = "clinic_id"
        case dateOfBirth = "date_of_birth"
        case countryID = "country_id"
        case cityID = "city_id"
        case doctorAddress = "doctor_address"
        case doctorWorkNumber = "doctor_work_number"
        case aboutUs1 = "about_us_1"
        case aboutUs2 = "about_us_2"
        case licenseFirst = "license_first"
        case licenseSecond = "license_second"
        case experience, lat, longitude
    }
}


struct DoctorServiceFeeOnGoing2: Codable {
    var id, doctorID: Int?
    var commDuration, commDurationType: String?
    var commDurationFee: Int?
    var commServiceType: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case doctorID = "doctor_id"
        case commDuration = "comm_duration"
        case commDurationType = "comm_duration_type"
        case commDurationFee = "comm_duration_fee"
        case commServiceType = "comm_service_type"
    }
}

struct DoctorSpecialitiesOnGoing2: Codable {
    var specialities: String?
}
struct UserInformationOnGoing2: Codable {
    var id: Int?
    var fullname, profilePicture, email, countryCode: String?
    var mobileNumber, dateOfBirth: String?
    var gender: Int?
    var accessToken, otp, otpTime: String?
    var isBlock, isVerify, loginType: Int?
    var langID: String?
    var isProfileCreated: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, fullname
        case profilePicture = "profile_picture"
        case email
        case countryCode = "country_code"
        case mobileNumber = "mobile_number"
        case dateOfBirth = "date_of_birth"
        case gender
        case accessToken = "access_token"
        case otp
        case otpTime = "otp_time"
        case isBlock = "is_block"
        case isVerify = "is_verify"
        case loginType = "login_type"
        case langID = "lang_id"
        case isProfileCreated = "is_profile_created"
    }
}


struct BookingSlotInfoOnGoing2: Codable {
    
    var id: Int?
    var doctorId: Int?
    var commType: String?
    var slotTime : String?
    var slotType : String?
    var date : String?
    var isAvailable: Bool?
    var createdAt : String?
    var updatedAt : String?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case doctorId = "doctor_id"
        case commType = "comm_type"
        case slotTime = "slot_time"
        case slotType = "slot_type"
        case date = "date"
        case isAvailable = "is_available"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct DataResponseTermsCond: Codable {
    var data: String?
    var status: Int?
}

struct SearchByFeatSpecialistResponse: Codable {
    var message: String?
    var doctorList: [DoctorList]?
    var pharmacyList: [PharmacyList]?
    var hospitalList: [HospitalList]?
    
    enum CodingKeys: String, CodingKey {
        case message
        case doctorList = "doctor_list"
        case pharmacyList = "pharmacy_list"
        case hospitalList = "hospital_list"
    }
}

struct DoctorCommunicationServices : Codable {
    let id : Int?
    let doctorId : Int?
    let commDuration : String?
    let commDurationType : String?
    let commDurationFee : Int?
    let commServiceType : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case doctorId = "doctor_id"
        case commDuration = "comm_duration"
        case commDurationType = "comm_duration_type"
        case commDurationFee = "comm_duration_fee"
        case commServiceType = "comm_service_type"
    }
}

struct DoctorList : Codable {
    let doctorId : Int?
    let doctorProfile : String?
    let doctorName : String?
    let doctorExp : String?
    let address : String?
    let lat : String?
    let longitude : String?
    let aboutUs : String?
    let likes : Int?
    let ratings : Double?
    let isLike : Int?
    let doctorSpecialities : [DoctorSpecialitiesHomeSearch]?
    let doctorQualifications : [DoctorQualifications]?
    let doctorCommunicationServices : [DoctorCommunicationServices]?
    let shareableUrl : String?
    
    enum CodingKeys: String, CodingKey {
        
        case doctorId = "doctor_id"
        case doctorProfile = "doctor_profile"
        case doctorName = "doctor_name"
        case doctorExp = "doctor_exp"
        case address = "address"
        case lat = "lat"
        case longitude = "longitude"
        case aboutUs = "about_us"
        case likes = "likes"
        case ratings = "ratings"
        case isLike = "isLike"
        case doctorSpecialities = "doctor_specialities"
        case doctorQualifications = "doctor_qualifications"
        case doctorCommunicationServices = "doctor_communication_services"
        case shareableUrl = "shareable_url"
    }
}

struct DoctorQualifications : Codable {
    let id : Int?
    let name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
    }
}

struct DoctorSpecialitiesHomeSearch : Codable {
    let id : Int?
    let shortName : String?
    let fullName : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case shortName = "short_name"
        case fullName = "full_name"
    }
}


struct HospitalList : Codable {
    let hospitalId : Int?
    let hospitalProfile : String?
    let hospitalName : String?
    let registrationDate : String?
    let address : String?
    let openingTime : String?
    let closingTime : String?
    let lat : String?
    let longitude : String?
    let aboutUs : String?
    let likes : Int?
    let isLike : Int?
    let ratings : Int?
    let hospitalSpecialities : [String]?
    let profileBaseUrl : String?
    let insuranceFilesUrl : String?
    
    enum CodingKeys: String, CodingKey {
        
        case hospitalId = "hospital_id"
        case hospitalProfile = "hospital_profile"
        case hospitalName = "hospital_name"
        case registrationDate = "registration_date"
        case address = "address"
        case openingTime = "opening_time"
        case closingTime = "closing_time"
        case lat = "lat"
        case longitude = "longitude"
        case aboutUs = "about_us"
        case likes = "likes"
        case isLike = "isLike"
        case ratings = "ratings"
        case hospitalSpecialities = "hospital_specialities"
        case profileBaseUrl = "profile_base_url"
        case insuranceFilesUrl = "insurance_files_url"
    }
    
}

struct PharmacyList : Codable {
    let id : Int?
    let pharmacyId : Int?
    let categoryId : Int?
    let subCategoryId : Int?
    let name : String?
    let mainPrice : Int?
    let quantity : Int?
    let soldOutQty : String?
    let sortDesc : String?
    let mainImage : String?
    let longDescription : String?
    let aboutProduct : String?
    let productBenifit : String?
    let howtouse : String?
    let isPrescribed : Int?
    let createdAt : String?
    let updatedAt : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case pharmacyId = "pharmacy_id"
        case categoryId = "category_id"
        case subCategoryId = "subCategory_id"
        case name = "name"
        case mainPrice = "main_price"
        case quantity = "quantity"
        case soldOutQty = "sold_out_qty"
        case sortDesc = "sort_desc"
        case mainImage = "main_image"
        case longDescription = "long_description"
        case aboutProduct = "about_product"
        case productBenifit = "product_benifit"
        case howtouse = "howtouse"
        case isPrescribed = "is_prescribed"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct SearchGeneralResponse: Codable {
    var message: String?
    var doctorList: [DoctorList]?
    
    enum CodingKeys: String, CodingKey {
        case message
        case doctorList = "doctor_list"
    }
}

struct DoctorQualification: Codable {
    var id: Int?
    var name: String?
}


struct DoctorSpeciality: Codable {
    var id: Int?
    var shortName, fullName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case shortName = "short_name"
        case fullName = "full_name"
    }
}


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let doctorDataModel = try? JSONDecoder().decode(DoctorDataModel.self, from: jsonData)

import Foundation

// MARK: - DoctorDataModel
struct DoctorDataModel: Codable {
    var status: Int
    var message: String
    var result: DoctorDataResult
}

// MARK: - Result
struct DoctorDataResult: Codable {
    var doctorID: Int
    var ratingReviews: [RatingReview]?
    var doctorProfile: String?
    var doctorName: String?
    var doctorExp: String?
    var address, lat, longitude, aboutUs: String?
    var likes, isLike: Int?
    var ratings: Double?
    var doctorSpecialities: [DoctorDataSpeciality]?
    var doctorQualifications: [DoctorDataQualification]?
    var areaOfExpertise, education, professionalAffiliation, languages: String?
    var doctorCommunicationServices: [DoctorDataCommunicationService]?
    var slotArray: SlotArray?

    enum CodingKeys: String, CodingKey {
        case doctorID = "doctor_id"
        case ratingReviews = "rating_reviews"
        case doctorProfile = "doctor_profile"
        case doctorName = "doctor_name"
        case doctorExp = "doctor_exp"
        case address, lat, longitude
        case aboutUs = "about_us"
        case likes, ratings, isLike
        case doctorSpecialities = "doctor_specialities"
        case doctorQualifications = "doctor_qualifications"
        case areaOfExpertise = "area_of_expertise"
        case education = "education"
        case professionalAffiliation = "professional_affiliation"
        case languages = "languages"
        case doctorCommunicationServices = "doctor_communication_services"
        case slotArray
    }
}

struct RatingReview: Codable {
    var id: Int?
    var ratingType, doctorID, comments: String?
    var ratings: Int?
    var firstName: String?
    var lastName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case ratingType = "rating_type"
        case doctorID = "doctor_id"
        case comments, ratings
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

// MARK: - DoctorCommunicationService
struct DoctorDataCommunicationService: Codable {
    var id, doctorID: Int?
    var commDuration, commDurationType: String?
    var commDurationFee: Int?
    var commServiceType: String?

    enum CodingKeys: String, CodingKey {
        case id
        case doctorID = "doctor_id"
        case commDuration = "comm_duration"
        case commDurationType = "comm_duration_type"
        case commDurationFee = "comm_duration_fee"
        case commServiceType = "comm_service_type"
    }
}

// MARK: - DoctorQualification
struct DoctorDataQualification: Codable {
    var id: Int?
    var name: String?
}

// MARK: - DoctorSpeciality
struct DoctorDataSpeciality: Codable {
    var id: Int
    var shortName, fullName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case shortName = "short_name"
        case fullName = "full_name"
    }
}

// MARK: - SlotArray
struct SlotArray: Codable {
    var slots: [Slot]
}

// MARK: - Slot
struct Slot: Codable {
    var slotType, dates: String
    var morning, afternoon, evening: [Afternoon]?

    enum CodingKeys: String, CodingKey {
        case slotType = "slot_type"
        case dates, morning, afternoon, evening
    }
}

// MARK: - Afternoon
struct Afternoon: Codable {
    var id: Int
    var time: String?
    var available: Int?
}
