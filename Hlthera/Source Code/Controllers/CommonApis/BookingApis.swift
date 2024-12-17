//
//  BookingApis.swift
//  Hlthera
//
//  Created by Prashant Panchal on 06/02/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import Foundation
var globalApis = CommonApis.shared
class CommonApis{
    static let shared = CommonApis()
    func updateBookingStatus(bookingId:String,doctorId:String,status:Int,reason:String = "",completion: @escaping (([String:Any])->())){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [ApiParameters.booking_id:bookingId,
                                     ApiParameters.doctor_id:doctorId,
                                     ApiParameters.status:String.getString(status),
                                     ApiParameters.cancellation_reason:reason
                                    ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.updateBookingStatus,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0{
                        completion(dictResult)
                            
                    }
                    else{
                        CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    }
                    
                    
                    
                    
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
    
    func getDoctorDetails(doctorId :String, communicationServiceId: String, slotId: String, completion: @escaping (DoctorDetailsModel)->()) {
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [
            ApiParameters.doctor_id: doctorId,
            ApiParameters.comm_service_id: communicationServiceId,
            ApiParameters.slot_id: slotId
        ]
        
        TANetworkManager.sharedInstance.requestApi(
            withServiceName: ServiceName.getDoctorDetails,
            requestMethod: .POST,
            requestParameters: params,
            withProgressHUD: false
        )
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0{
                        let data = kSharedInstance.getDictionary(dictResult["result"])
                        let doctorData = DoctorDetailsModel(data: data)
                        completion(doctorData)
                    }
                    else{
                        CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    }
                    
                    
                    
                    
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
    func getRatingsAndReviews(completion: @escaping ([RatingModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [
            :
                                    ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.ratingList,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0{
                        let data = kSharedInstance.getArray(dictResult["result"])
                        
                        completion(data.map{
                            RatingModel(data: kSharedInstance.getDictionary($0))
                        })
                    }
                    else{
                        CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    }
                    
                    
                    
                    
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
    func removeCartProduct(id:String,completion:@escaping (()->())){
        
        addRemoveCartProduct(id:"", qty: 0, pharmacyId: "", cartId: id, isRemove: true){ _ in
            completion()
        }
    }
    func addRemoveCartProduct(id:String,qty:Int,pharmacyId:String,cartId:String = "",isRemove:Bool = false, completion:@escaping ((String)->())){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        var params:[String:Any]  = [:]
        
        if !isRemove{
            
            params = [ApiParameters.product_id:id,
                                         ApiParameters.quantity:String.getString(qty),
                                         ApiParameters.pharmacy_id:pharmacyId,
                                         ApiParameters.cart_id:cartId,
                                         ]
        }
        else{
            params = [
                      ApiParameters.cart_id:cartId,
                      ]
        }
       
        TANetworkManager.sharedInstance.requestApi(withServiceName:isRemove ? (ServiceName.remove_from_cart) : (ServiceName.add_cart),                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    
                    completion(String.getString(dictResult["cart_id"]))
                   
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
    func wishlistProduct(id:String,completion: @escaping (()->())){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        var params:[String:Any]  = [ApiParameters.product_id:id]
        
       params = [ApiParameters.product_id:id]
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.add_wishlist ,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    completion()
                   
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
    func cancelOrderApi(id:String, completion: @escaping ((String)->())){
        CommonUtils.showHudWithNoInteraction(show: true)
      
       
        let params:[String : Any] = [ApiParameters.order_id:id
                                     ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.cancelOrders,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    let result = kSharedInstance.getArray(dictResult["data"])
                    completion(String.getString(dictResult["message"]))
                   
                    
                    
                    
                    
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
    func getListing(type:HasCameFrom,sortType:String,hasCameFrom:HasCameFrom,completion:@escaping (([PharmacyOrderModel])->())){
        CommonUtils.showHudWithNoInteraction(show: true)
        var cType = 1
        switch hasCameFrom{
        case .pending:
            cType = 1// to be filtered manually
        case .ongoing:
            cType = 2 // completed
        case .completed:
            cType = 3 // scheduled
        case .cancelled:
            cType = 4 // cancelled
        default:break
        }
        let params:[String : Any] = [ApiParameters.order_type:String.getString(cType),
                                     ApiParameters.sort_type:sortType]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.myOrders,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    let result = kSharedInstance.getArray(dictResult["data"])
                    
    var data:[PharmacyOrderModel] = []
    data = result.map{
        PharmacyOrderModel(data: kSharedInstance.getDictionary($0))
    }
  

    
                      completion(data)
                   
                    
                    
                    
                    
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
    func getCartCount(completion: @escaping (Int)->()){
        CommonUtils.showHudWithNoInteraction(show: false)
        
        let params:[String : Any] = [
            :
                                    ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.product_count,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    let data = Int.getInt(dictResult["data"])
                completion(data)
                default:
                    print(String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToast(message: kNoInternetMsg)
                
            } else {
                CommonUtils.showToast(message: kDefaultErrorMsg)
            }
        }
    }
    func getProductDetails(id:String,completion:@escaping (String,PharmacyProductModel)->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [ApiParameters.product_id:id]
       
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.product_detail,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    
                    let imageUrl = String.getString(dictResult["url"])
                        let data = PharmacyProductModel(dict:kSharedInstance.getDictionary(dictResult["product_details"]))
                    
                    completion(imageUrl,data)
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
