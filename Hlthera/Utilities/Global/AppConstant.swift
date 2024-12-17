//
//  AppConstant.swift
//  CommonCode
//
//  Created by Shubham Kaliyar on 6/10/17.
//  Copyright © 2017 Shubham Kaliyar. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Global Variables

let sharedSceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate

// MARK: - Structure

//typealias  JSON = [String:Any]?

let kAppName                    = "Hlthera"
let kIsTutorialAlreadyShown     = "isTutorialAlreadyShown"
let kIsUserLoggedIn             = "isUserLoggedIn"
let kIsPractoEnabled            = "isPractoEnabled"
let kLoggedInAccessToken        = "access_token"
let kLoggedInUserDetails        = "loggedInUserDetails"
let kLoggedInUserId             = "loggedInUserId"
let kLatitude                   = "latitude"
let kLongitude                  = "longitude"
let kIsOtpVerified              = "is_mobile_verified"
let kIsProfileCreated           = "is_profile_create"
let kIs_Active                  = "is_active"
let kIs_Notification            = "is_notification"
let kIsAppInstalled             = "isAppInstalled"
let kAccessToken                = "access_token"
let kDeviceToken                = "device_token"
let iosDeviceType               = "1"
let iosDeviceTokan              = "123456789"
let kSharedAppDelegate          = UIApplication.shared.delegate as? AppDelegate
let kSharedInstance             = SharedClass.sharedInstance
let kSharedSceneDelegate        = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
let kSharedUserDefaults         = UserDefaults.standard
let kScreenWidth                = UIScreen.main.bounds.size.width
let kScreenHeight               = UIScreen.main.bounds.size.height
let kRootVC                     = UIApplication.shared.windows.first?.rootViewController
let kBundleID                   = Bundle.main.bundleIdentifier!


struct APIUrl {
    //    static let kBaseUrl = "18.217.107.168:3010/user/"
    //    static let videoUrl = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
}

struct Keys {
    static let kDeviceToken     = "deviceToken"
    static let kAccessToken     = "access_token"
    static let kFirebaseId      = "firebaseId"
    static let kMobileVerified  = "isMobileVerified"
    static let kUserName        = "username"
    static let alphabet         = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
}

struct ServiceName {
    static let signup                        = "signup"
    static let verifyotp                     = "verify-otp"
    static let login                         = "login"
    static let resendOtp                     = "resend-otp"
    static let forgot_password               = "forgot-password"
    static let myAddress                     = "my_address"
    static let insurance_companies           = "insurance-companies"
    static let term_condition           = "term_condition_json"
    static let update_password               = "update-password"
    static let change_avtar                  = "change-avtar"
    static let create_profile                = "create-profile"
    static let nationality                   = "nationality"
    static let sliderTopBanners                   = "home"
    static let generalSearch                   = "general-search"
    
    static let sendMessageToDoctorCheckIn                   = "check-in"
    static let generate_zoom_link                   = "generate_zoom_link"
    
    static let specialities                  = "specialties-option"
    static let kprofile_lifestyle_options    = "profile-lifestyle-options"
    static let kGetProfileDetails       = "get-profile-details"
    static let emergencyContactRemove = "emergency-contact-remove"
    static let medicationLifestyleOptionRemoved = "medication-lifestyle-option-removed"
    static let updatePasswordWithOld  = "update-password-with-old"
    static let searchDoctor = "search-doctor"
    static let doctorList = "doctor-list"
    static let hospitalList = "hospital-list"
    
    //    static let myDoctors = "my_doctors"
    static let myDoctors = "liked-doctors"
    
    static let homeSearch = "home-search"
    static let homeSearchBySpeciality = "search-by-speciality"
    static let issueReportByUser          = "issue-report-by-user"
    static let nearMeHospital           = "near-me-hospital"
    static let searchHospital           = "search-hospital"
    static let doLike                   = "do-like"
    static let uploadPrescription      = "upload-prescription"
    static let addPost = "add-post"
    static let doUnlike                 = "do-unlike"
    static let doctorFilter             = "apply-filter-doctor"
    static let logOut                   = "logout"
    static let contactUs               = "contact_us"
    static let addPatientAddress     = "add-patient-address"
    static let updateAddress     = "update-address"
    static let country_list = "country_list"
    static let state_list = "state_list"
    static let city_list = "city_list"
    
    static let savedCards              = "save_card"//for saving post cards
    static let getSavedCards              = "get_cards"
    
    
    static let orderPlace            = "order-place"
    static let getPatientAddress      = "get-patient-address"
    static let bookAppointment        = "book-appointment"
    static let getCouponsList         = "get-coupons"
    static let checkSlotAvailablity = "check-slot-availablity"
    static let deleteAddress          = "remove-address"
    static let deleteCard             = "delete-card"
    static let getLanguage           = "get-language"
    static let ongoingBookings      = "ongoing-bookings"
    static let getMyCheckins     = "get-bookings"
    static let getCheckInsChatList    = "get-booking-chat"
    static let getDoctorTimeSlots    = "get-doctor-timeslotes"
    
    static let updateBookingStatus = "update-booking-status"
    static let cancellationReasons = "cancellation-reasons"
    static let getDoctorDetails = "reschedule"
    static let surveyQuestions = "survey-questions"
    static let doctorDetails = "doctor-details"
    static let saveUserSurvey = "save-user-survey"
    static let rateYourAppointment = "rate-your-appointment"
    static let ratingList = "rating-list"
    static let pharmacyCategories = "categories"
    static let top_order_products = "top_order_products"
    static let recommended_product = "recommended_product"
    static let product_list = "product_list"
    static let product_detail = "product_detail"
    static let cart_list = "cart_list"
    static let product_count = "product-count"
    static let viewOrderDetail = "view-order-detail"
    static let add_cart = "add_cart"
    static let remove_from_cart = "remove_from_cart"
    static let search_product = "search_product"
    static let add_wishlist = "add_wishlist"
    static let notificationList = "notification-list"
    static let myOrders = "my-orders"
    static let cancelOrders = "cancel-orders"
    static let pharmacyRating = "pharmacy-rating"
    static let viewService = "view-service"
}

struct Notifications {
    static let kDOB                             = "Please Enter Date of Birth"
    static let kEnterMobileNumber               = "Please Enter Mobile Number"
    static let kEnterValidMobileNumber          = "Please Enter Valid Mobile Number"
    static let kEnterEmail                      = "Please Enter your Email Id"
    static let kEnterValidEmail                 = "Please Enter Valid Email Id"
    static let kName                            = "Please Enter  Name"
    static let kValidName                       = "Please Enter  Valid Name"
    static let kPassword                        = "Please Enter  Password"
    static let kValidPassword                   = "Password Should be of Minimum 8 characters Including Alphabets, Numbers & Special Characters."
    static let kNewPassword                     = "Please Enter  New Password"
    static let kSamePassword                    = "Passwords should be Same"
    static let kMatchPassword                   = "Password & Confirm Password doesn't Match"
    static let kTermsNCond                      = "Please Accept Terms & Conditions"
    static let kAppointment                     = "Please Enter Appointment Type"
    static let kUserType                        = "Please Enter Your User Type"
    static let kAppointmentDate                 = "Please Enter Appointment Date & Time"
    static let kAdditionalNotes                 = "Please Enter Additional Note for Appointment"
    static let kChatNotificationReceived        = "ChatNotificationReceived"
    static var kAddress                         = "Please Enter Address"
    static let kEnterOTP                        = "OTP Can't be Empty"
    static let kEnterInsuranceCompany           = "Please Enter Insurance Company"
    static let kEnterInsuranceNo                = "Please Enter Insurance Number"
    static let kEnterValidInsuranceNo                 = "Please Enter Valid Insurance Number"
    static let kEnterFirstName                  = "Please Enter First Name"
    static let kEnterFullName                   = "Please Enter Full Name"
    static let kEnterLastName                   = "Please Enter Last Name"
    
    static let kEnterPassword                   = "Please Enter Password"
    static let kReEnterPassword                 = "Please Enter Confirm Password"
    static let kEnterValidPassword              = "Please Enter Valid Password"
    static let kFullName                        = "Please Enter Full Name"
    static let kFirstName                       = "Please Enter First Name"
    static let kLastName                        = "Please Enter Last Name"
    static let kPropertyType                    = "Please Select Property Type"
    static let kEnterValidEmailId               = "Please Enter Valid Email ID"
    static let kEmailId                         = "Please Enter Email ID"
    static let kAcceptTerms                     = "Please Accept Terms & Conditions"
    static let kPasswordRange                   = "Password Should be Minimum Of 8 digits"
    static let kPasswordMatch                   = "Password & Confirm Password Should Be Same"
    static let kEnterEmailOrMobile              = "Please Enter Email ID or Mobile Number"
    static let kEnterValidEmailOrMobile         = "Please Enter Valid Email or Mobile Number"
    static let kBloodGroup                      = "Please Select Blood Group"
    static let kHeight                          = "Please Select Height"
    static let kWeight                          = "Please Select Weight"
    static let kDob                             = "Please Select Date Of Birth"
    static let kNationality                     = "Please Enter Nationality"
    static let kUaeResident                     = "Please Select You Are UAE Resident Or Not"
    static let kExpiryDate                      = "Please Select Expiry Date"
    static let kMaritalStatus                   = "Please Select Marital Status"
    static let kAcceptCond                      = "Please Accept terms and conditions"
    static let kHowDidHearAboutUs                    = "Please Enter How Did Hear About Us"
    
}
struct ApiParameters {
    static var ksteps                    = "steps"
    static var kfullName                 = "fullname"
    static var kusername                 = "username"
    static var kpassword                 = "password"
    static var ksocial_id                = "social_id"
    static let kFirstName                = "first_name"
    static let klastName                 = "last_name"
    static let kgender                   = "gender"
    static let kdob                      = "date_of_birth"
    static let knationality              = "nationality"
    static let kis_country_resident      = "is_country_resident"
    static let kinsurance_expiry         = "insurance_expiry"
    static let kmarital_status           = "marital_status"
    static let kaddress                  = "address"
    static let kinsurance_back           = "insurance_back"
    static let kinsurance_front          = "insurance_front"
    static let kweight                   = "weight"
    static let kheight                   = "height"
    static let kblood_group              = "blood_group"
    static let kmedical_notes            = "medical_notes"
    static let kemail                    = "email"
    static let kcountryCode              = "country_code"
    static let kCountryCodes             = "contact_country_code"
    static let kMobileNumber             = "mobile_number"
    static let kdeviceToken              = "device_token"
    static let kdevice_type              = "device_type"
    static let kPassword                 = "password"
    static let kCurrentPassword          = "current_password"
    static let kconfirm_password         = "confirm_password"
    static let kConfirmPassword          = "confirm_password"
    static let kcontact_us_by            = "contact_us_by"
    static let klogin_type               = "login_type"
    static let kLatitude                 = "lat"
    static let speciality                 = "speciality"
    static let kLongitude                = "long"
    static let klang_id                  = "lang_id"
    static let id                        = "id"
    static let kinsurance_company        = "insurance_company"
    static let kinsurance_number         = "insurance_number"
    static let kterms_and_condition      = "terms_and_condition"
    static let message                   = "Something went wrong"
    static let kotp                      = "otp"
    static let kprofile_picture          = "profile_picture"
    static let kcreate_profile           = "create-profile"
    static let kmedicalAllergies          = "allergies"
    static let kmedicalCurrentMedication  = "current_medication"
    static let kmedicalPastMedication    = "past_medication"
    static let kmedicalChronicDisease    = "chronic_disease"
    static let kmedicalInjuries          = "injuries"
    static let kmedicalSurgeries         = "surgeries"
    static let kmedicalSmokingHabit      = "smoking_habit"
    static let kmedicalAlcoholConsumption = "alcohol_consumption"
    static let kmedicalActivitylevel     = "activity_level"
    static let kmedicalfoodpreference    = "food_preference"
    static let kmedicalOccupation        = "occupation"
    static let kemergencyContactnumber   = "contact_number"
    static let kemergencyRelation        = "relation"
    static let kTitle                    = "title"
    static let kSpecialitiesId             = "specialties"
    
    static let SearchGeneralName             = "name"
    static let SearchGeneralCountry            = "country"
    static let SearchGeneralGender            = "gender"
    static let SearchGeneralSpecilaity            = "speciality"
    
    
    static let kGender                   = "gender"
    static let kRating                   = "rating"
    static let kAvailability              = "availability"
    static let kLocation                 = "location"
    static let kIsQuickSearch            = "is_quick_search"
    static let kDoctor_or_clinic_id       = "doctor_or_clinic_id"
    static let kMessage                   = "message"
    static let kLike                     = "like"
    static let kUnlike                   = "unlike"
    static let kType                     = "type"
    static let kTargetId                 = "target_id"
    static let kLanguage                  = "language"
    static let kCommunication_way         = "communication_way"
    static let kReportingType            = "reporting_type"
    static let kAddress                  = "address"
    static let kCity                     = "city"
    static let building                  = "building"
    static let flat                      = "flat"
    static let street                    = "street"
    static let kPincode                  = "pincode"
    static let address_type              = "address_type"
    static let mobile_no                 = "mobile_no"
    static let isHospitalBooking         = "isHospitalBooking"
    static let hospital_id               = "hospital_id"
    static let appointment_type         = "appointment_type"
    static let order_id = "order_id"
    static let coupon_id = "coupon_id"
    static let orderPlace              = "order-place"
    static let booking_type               = "booking_type"
    static let page               = "page"
    static let limit               = "limit"
    static let filter_by               = "filter_by"
    static let order_type = "order_type"
    static let slot_id         = "slot_id"
    static let insta_hms_slot         = "insta_hms_slot"
    static let date         = "date"
    static let doctor_id         = "doctor_id"
    static let satisfied_id = "satisfied_id"
    static let fees         = "fees"
    static let total_amount         = "total_amount"
    static let patient_name         = "patient_name"
    static let patient_age         = "patient_age"
    static let patient_gender         = "patient_gender"
    static let patient_email         = "patient_email"
    static let patient_mobile         = "patient_mobile"
    static let address_id         = "address_id"
    static let countryId          = "country_id"
    static let stateId            = "state_id"
    static let cityId             = "city_id"
    static let card_number        = "card_number"
    static let card_name        = "card_name"
    static let expiry_date        = "expiry_date"
    static let cvv        = "cvv"
    
    static let is_save_adress    = "is_save_adress"
    static let other_patient_name         = "other_patient_name"
    static let other_patient_age         = "other_patient_age"
    static let other_patient_relation         = "other_patient_relation"
    static let other_patient_mobile         = "other_patient_mobile"
    static let other_patient_insurance         = "other_patient_insurance"
    static let other_patient_imageFront         = "other_patient_imageFront"
    static let other_patient_imageBack         = "other_patient_imageBack"
    static let other_notes                     = "other_notes"
    static let isOtherKey                    = "is_other"
    static let other_patient_gender           = "other_patient_gender"
    static let other_patient_email           = "other_patient_email"
    static let other_patient_countryCode    = "other_patient_countryCode"
    static let patient_countryCode          = "patient_countryCode"
    static let booking_id = "booking_id"
    static let status = "status"
    static let cancellation_reason = "cancellation_reason"
    static let is_future_address = "is_future_address"
    static let comm_service_id = "comm_service_id"
    static let old_slot_id = "old_slot_id"
    static let old_date = "old_date"
    static let slot_time = "slot_time"
    static let is_reschedule = "is_reschedule"
    static let question_ids = "question_id"
    static let ratings = "ratings"
    static let rating_type = "rating_type"
    static let rating = "rating"
    static let comment = "comment"
    static let comments = "comments"
    static let type = "type"
    static let product_id = "product_id"
    static let quantity = "quantity"
    static let pharmacy_id = "pharmacy_id"
    static let cart_id = "card_id"
    static let sort_type = "sort_type"
}
enum CommunicationType{
    case audio,video,chat,none
}
struct CustomColor {
    
    static let kGreen               = UIColor.init(red: 50/255,  green: 185/255, blue: 113/255, alpha: 1)
    static let kRed                 = UIColor.init(red: 229/255,  green: 49/255, blue: 38/255, alpha: 1)
    static let kSenderPlay          = UIColor.init(red: 198/255,  green: 212/255, blue: 225/255, alpha: 0.4)
    static let kReceiverPlay        = UIColor.init(red: 115/255,  green: 120/255, blue: 128/255, alpha: 1)
    static let kBlack               = UIColor.init(red: 0/255,  green: 0/255, blue: 0/255, alpha: 0.05)
    static let kGray                = UIColor.init(red: 158/255,  green: 161/255, blue: 167/255, alpha: 1)
    static let kLightRed            = UIColor.init(red: 89/255,  green: 124/255, blue: 236/255, alpha: 1)
    static let kDarkRed             = UIColor.init(red: 57/255,  green: 83/255, blue: 164/255, alpha: 1)
    static let kChatHeader          = UIColor.init(red: 142/255,  green: 148/255, blue: 156/255, alpha: 1)
    
}

struct NumberContants {
    static let kMinPasswordLength = 8
}


struct  AlertMessage {
    static let kDefaultError                  = "Something went wrong. Please try again.".localize
    static let knoNetwork                     = "Please check your internet connection !".localize
    static let kSessionExpired                = "Your session has expired. Please login again. -> 🚀 ".localize
    static let kNoInternet                    = "Unable to connect to the Internet. Please try again.".localize
    static let kInvalidUser                   = "Oops something went wrong. Please try again later.".localize
    static let knoData                        = "No Data Found 🎈".localize
    static let noName                         = "Empty name 🚀".localize
    static let Under_Development              = "Under Development 👨‍🏫".localize
    static let logout                         = "Are you sure you want to logout?".localize
    static let signin                         = "Please sign in first.".localize
    static let currentPagealert               = "you are already on this page 🤣 -> 🚀".localize
}

struct Identifiers {
    static let kLoginVc = "LoginVC"
    static let kLoginVc2 = "LoginVc2"
    
    static let kSelectLangVc = "SelectLangViewController"
    static let kWalkthroughCVC = "WalkthroughCVC"
    static let kPersonalDetailsVC = "PersonalDetailsViewController"
    static let kMedicalIDVC = "MedicalIDViewController"
    static let kLifeStyleVC = "LifeStyleViewController"
    static let kbannerCVC = "BannerCollectionViewCell"
    static let kResetPassVC = "ResetPassViewController"
    static let kForgotPassVC = "ForgotPassViewController"
    static let kOtpVerificationVC = "OtpVerificationViewController"
    
    static let kSignUpVC                   = "SignUpViewController"
    static let kSignUpVc2                  = "SignUpViewController2"
    
    static let kCartController             = "MyCartViewController"
    static let kPromoCodeController        = "PromoCodeListViewController"
    static let kMapController              = "MapViewController"
    static let kAddOnsController           = "AddOnsViewController"
    static let kMenuController             = "MenuViewController"
    static let kPaymentController          = "MakePaymentViewController"
    static let kOrderPlacedPopUpController = "OrderPlacedPopUpViewController"
    static let kHome                       = "HomeVC"
    static let kMedicalDetailsVC           = "MedicalDetailsViewController"
    static let kSearchMedicalInfoVC        = "SearchMedicalInfoViewController"
    //MARK: - tableView cell Constants
    static let kEmergencyContactsTVCell        = "EmergencyContactsTableViewCell"
}

struct Storyboards {
    static let kMain = "Main"
    static let kHome = "Home"
    static let kDoctor = "MyDoctors"
    static let kHospitals = "Hospitals"
    static let kOrders = "Orders"
}

struct ServiceIconIdentifiers {
    static let video = "video_call_sm"
    static let home = "home_visit"
    static let home1 = "home_visit-1"
    static let chat = "chat_sm"
    static let audio = "call_sm"
    static let clinic = "clinic_visit_sm"
}

struct ServicesIdentifiers {
    static let video = "video"
    static let home = "home"
    static let chat = "chat"
    static let audio = "audio"
    static let clinic = "visit"
}

enum HasCameFrom {
    case signUp,login,forgotPass,none,editProfile,doctors,hospitals,home,others,ongoing,past,cancelled,scheduled,settings,pending,completed,placePharmacyOrder,viewPharmacyOrder,viewPharmacyProduct,pharmarcyTopProducts,pharmacyRecommendedProducts,pharmacy,addAddress,updateAddress,account,
         CheckInPrev, CheckInScheduled, feelingUnwell,
         searchDoctor,hospitalProfile , bookAppointment, Banners
}

enum addSymptomsEnum {
    case allergie, currentMedications, pastMedications, chronicDisease, injuries, surgeries, none
}

//struct Notifications {
//    static var kAddress                         = "Please Enter Address"
//    static let kEnterOTP                        = "OTP Can't be Empty"
//    static let kEnterInsuranceCompany           = "Please Enter Insurance Company"
//    static let kEnterInsuranceNo                = "Please Enter Insurance Number"
//    static let kEnterFirstName                  = "Please Enter Full Name"
//    static let kEnterFullName                   = "Please Enter Full Name"
//    static let kEnterLastName                   = "Please Enter Last Name"
//    static let kEnterMobileNumber               = "Please Enter Mobile Number"
//    static let kEnterValidMobileNumber          = "Please Enter Valid Mobile Number"
//    static let kEnterPassword                   = "Please Enter Password"
//    static let kReEnterPassword                 = "Please Enter Confirm Password"
//    static let kEnterValidPassword              = "Please Enter Valid Password"
//    static let kFullName                        = "Please Enter Full Name"
//    static let kFirstName                       = "Please Enter First Name"
//    static let kLastName                        = "Please Enter Last Name"
//    static let kPropertyType                    = "Please Select Property Type"
//    static let kEnterValidEmailId               = "Please Enter Valid Email ID"
//    static let kEmailId                         = "Please Enter Email ID"
//    static let kAcceptTerms                     = "Please Accept Terms & Conditions"
//    static let kPasswordRange                   = "Password Should be Minimum Of 8 digits"
//    static let kPasswordMatch                   = "Password & Confirm Password Should Be Same"
//    static let kEnterEmailOrMobile              = "Please Enter Email ID or Mobile Number"
//    static let kEnterValidEmailOrMobile         = "Please Enter Valid Email or Mobile Number"
//    static let kBloodGroup                      = "Please Select Blood Group"
//    static let kHeight                          = "Please Select Height"
//    static let kWeight                          = "Please Select Weight"
//    static let kDob                             = "Please Select Date Of Birth"
//    static let kNationality                     = "Please Enter Nationality"
//    static let kUaeResident                     = "Please Select You Are UAE Resident Or Not"
//    static let kExpiryDate                      = "Please Select Expiry Date"
//    static let kMaritalStatus                   = "Please Select Marital Status"
//    static let kAcceptCond                      = "Please Accept terms and conditions"
//}

struct AlertTitle {
    static let kOk = "OK".localize
    static let kCancel = "Cancel".localize
    static let kDone = "Done".localize
    static let ChooseDate = "Choose Date".localize
    static let SelectCountry = "Select Country".localize
    static let logout = "Logout".localize
}

struct Cellidentifier {
    static let IntroductionCell    = "IntroductionCell"
    static let SidebarMenuCell     = "SidebarMenuCell"
}

struct OtherConstant {
    static let kAppDelegate        = UIApplication.shared.delegate as? AppDelegate
    //static let kRootVC             = UIApplication.shared.keyWindow?.rootViewController
    static let kBundleID           = Bundle.main.bundleIdentifier!
    static let kGenders: [String]  = ["Male", "Female", "Other"]
    static let kReviewsSortBy: [String] = ["Recent", "Last Month", "Last Year"]
}

func Localised(_ aString:String) -> String {
    
    return NSLocalizedString(aString, comment: aString)
}

struct Indicator {
    static func showToast(message aMessage: String)
    {
        DispatchQueue.main.async
        {
            showAlertMessage.alert(message: aMessage)
        }
    }
}

// Enums
enum PhotoSource {
    case library
    case camera
}

enum MessageType {
    case photo
    case text
    case video
    case audio
}

enum MessageOwner {
    case sender
    case receiver
}

enum BottomOptions: Int {
    case search = 0
    case match
    case message
    case post
}

//enum HasCameFrom{
//    case Forgot // forgot Password flow
//    case SignUp
//    case ResetPassword
//}

enum AppColor {
    case Blue, Red
    var color : UIColor {
        switch self {
        case .Blue:
            return UIColor.blue
        case .Red:
            return UIColor.init(hexString: "#C7003B")
        }
    }
}

enum OpenMediaType: Int {
    case camera = 0
    case photoLibrary
    case videoCamera
    case videoLibrary
}

enum AppFonts {
    case bold(CGFloat),regular(CGFloat)
    var font: UIFont {
        switch self {
        case .bold(let size):
            return UIFont (name: "System", size: size)!
        case .regular(let size):
            return UIFont.systemFont(ofSize: size)
        }
    }
}

// MARK: ---------Color Constants---------

let appThemeUp = UIColor.init(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
let appThemeDown = UIColor.init(red: 251/255, green: 136/255, blue: 51/255, alpha: 1)

// MARK: ---------Method Constants---------

func print_debug(items: Any) {
    print(items)
}

func print_debug_fake(items: Any) {
}
