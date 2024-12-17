// Welcome.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct GetAllCheckinsModel: Codable {
    var message: String?
    var status: Int?
    var result: Results?
}

// Result.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let result = try? newJSONDecoder().decode(Result.self, from: jsonData)

import Foundation

// MARK: - Result
struct Results: Codable {
    var currentPage: Int?
    var data: [CheckInItem]?
    var firstPageURL: String?
    var from: Int?
    var nextPageURL: String?
    var path: String?
    var perPage: String?
    var prevPageURL: String?
    var to: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to
    }
}

// Datum.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let datum = try? newJSONDecoder().decode(Datum.self, from: jsonData)

import Foundation

// MARK: - Datum
struct CheckInItem: Codable {
    var id: Int?
    var appointmentType, slotID, date, doctorID: String?
    var userID, fees, totalAmount, addressID: String?
    var patientName, patientAge, patientGender, patientEmail: String?
    var patientCountryCode, patientMobile: String?
    var otherPatientName, otherPatientAge, otherPatientRelation, otherPatientCountryCode: JSONNull?
    var otherPatientMobile, otherPatientInsurance: JSONNull?
    var otherPatientImageFront, otherPatientImageBack: String?
    var otherNotes: JSONNull?
    var status, hospitalID: Int?
    var cancellationReason, createdAt, updatedAt: String?
    var ratings: JSONNull?
    var doctorInformation: DoctorInformation?
    var doctorSpecialities: DoctorSpecialities?
    var doctor: Doctor?
    var doctorSlotInformation: DoctorSlotInformation?
    var doctorServiceFee: DoctorServiceFee?
    var userInformation: UserInformation?

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
    }
}

// Doctor.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let doctor = try? newJSONDecoder().decode(Doctor.self, from: jsonData)

import Foundation

// MARK: - Doctor
struct Doctor: Codable {
    var id: Int?
    var name, email: String?
    var countryCode: String?
    var mobileNumber, gender: String?
    var emailVerifiedAt: JSONNull?
    var password: String?
    var rememberToken, socialID: JSONNull?
    var loginType: Int?
    var otp, otpTime: String?
    var isVerify, isProfileCreated: Int?
    var isIndividual, profilePicture: String?
    var isHospitalVerify, isAdminVerify, isBlock, likes: Int?
    var availablityStatus, accountType: Int?
    var hospitalGeneratedCode, docterVerifiedByHospital, createdAt, updatedAt: String?
    var isAvailableToday: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, email
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

// DoctorInformation.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let doctorInformation = try? newJSONDecoder().decode(DoctorInformation.self, from: jsonData)

import Foundation

// MARK: - DoctorInformation
struct DoctorInformation: Codable {
    var id: Int?
    var doctorID, clinicID, dateOfBirth: String?
    var countryID, cityID: String?
    var doctorAddress: String?
    var doctorWorkNumber: String?
    var aboutUs1: String?
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

// DoctorServiceFee.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let doctorServiceFee = try? newJSONDecoder().decode(DoctorServiceFee.self, from: jsonData)

import Foundation

// MARK: - DoctorServiceFee
struct DoctorServiceFee: Codable {
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

// DoctorSlotInformation.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let doctorSlotInformation = try? newJSONDecoder().decode(DoctorSlotInformation.self, from: jsonData)

import Foundation

// MARK: - DoctorSlotInformation
struct DoctorSlotInformation: Codable {
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

// DoctorSpecialities.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let doctorSpecialities = try? newJSONDecoder().decode(DoctorSpecialities.self, from: jsonData)

import Foundation

// MARK: - DoctorSpecialities
struct DoctorSpecialities: Codable {
    var specialities: String?
}

// UserInformation.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let userInformation = try? newJSONDecoder().decode(UserInformation.self, from: jsonData)

import Foundation

// MARK: - UserInformation
struct UserInformation: Codable {
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

// JSONSchemaSupport.swift

import Foundation

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

// Welcome.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct ChatData: Codable {
    var message: String?
    var status: Int?
    var result: ChatResult?
}

// Result.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let result = try? newJSONDecoder().decode(Result.self, from: jsonData)

import Foundation

// MARK: - Result
struct ChatResult: Codable {
    var currentPage: Int?
    var data: [ChatItem]?
    var firstPageURL: String?
    var from, lastPage: Int?
    var lastPageURL: String?
    var nextPageURL: String?
    var path: String?
    var perPage: String?
    var prevPageURL: String?
    var to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// Datum.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let datum = try? newJSONDecoder().decode(Datum.self, from: jsonData)

import Foundation

// MARK: - Datum
struct ChatItem: Codable {
    var id: Int?
    var message: String?
    var replyMsg: String?

    enum CodingKeys: String, CodingKey {
        case id, message
        case replyMsg = "reply_msg"
    }
}
