//
//  PaymentVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 21/01/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class PaymentVC: UIViewController , CellImageTapDelegate{
    
    func tableCell(didClickedImageOf tableCell: UITableViewCell) {
        self.deleteCardApi(id: self.savedCards[0].id)
    }

    @IBOutlet weak var constraintPayment: NSLayoutConstraint!
    //@IBOutlet weak var constraintSavedCards: NSLayoutConstraint!
    @IBOutlet weak var buttonProceed: UIButton!
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var constraintPaymentCardsHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonApplyPromocode: UIButton!
    @IBOutlet weak var labelPromoCode: UILabel!
    @IBOutlet weak var viewPromoCodeApplied: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var promocode = ""
    var promocodeId = ""
    var pageTitle = "Make Payment".localize
    var orderId = ""
    var isSavedCards = false
    var savedCards:[SavedCardsModel] = []
    var saveCard = false
    var addressId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelPageTitle.font = .corbenRegular(ofSize: 15)
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        let line = UIView(frame: CGRect(x: 0, y: self.buttonApplyPromocode.frame.height-5, width: buttonApplyPromocode.frame.width, height: 2))
        self.buttonApplyPromocode.addSubview(line)
        line.backgroundColor = UIColor(named: "5")
        self.viewPromoCodeApplied.isHidden = true
        self.labelPageTitle.text = pageTitle
        if isSavedCards {
            buttonProceed.setTitle("Save".localize, for: .normal)
            buttonProceed.isHidden = true
            buttonApplyPromocode.isHidden = true
            viewPromoCodeApplied.isHidden = true
            constraintPayment.constant = 15
            //constraintPayment.isActive = false
            // constraintSavedCards.isActive = true
            // constraintSavedCards.constant = 30
            
        } else {
            constraintPayment.isActive = true
            buttonProceed.isHidden = false
            //constraintSavedCards.isActive = false
            constraintPayment.constant = 15
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    override func viewWillAppear(_ animated: Bool) {
        getSavedCards()
    }
    
    
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func buttonAddAddressTapped(_ sender: Any) {
        
        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: AddPaymentCardVC.getStoryboardID()) as? AddPaymentCardVC else { return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func buttonApplyPromoCodeTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: CouponCodeVC.getStoryboardID()) as? CouponCodeVC else { return }
        vc.callback = { code in
            self.buttonApplyPromocode.isHidden = true
            self.viewPromoCodeApplied.isHidden = false
            self.labelPromoCode.text = "\(code.uppercased())" + "- Promocode Applied!".localize
            self.promocode = code
            self.constraintPayment.constant = 45
            
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func buttonProceedTapped(_ sender: Any) {
        if !savedCards.filter({$0.isSelected}).isEmpty{
            if isSavedCards{
                saveCardApi()
            }else {
                
                if saveCard{
                    !addressId.isEmpty && !orderId.isEmpty ? saveCardApi(isOrder:true) : saveCardApi(isBooking:true)
                }else if !addressId.isEmpty && !orderId.isEmpty{
                    placeOrderApi(id: orderId, addressId: addressId, couponId: promocodeId)
                } else {
                    if addressId.isEmpty && orderId.isEmpty{
                        bookingApi(isHospital: String.getString(UserData.shared.hospital_id).isEmpty ? false : true, forOthers: String.getString(UserData.shared.otherPatientDetails?.other_patient_name).isEmpty ? false : true)
                    }
                }
            }
        } else {
            CommonUtils.showToast(message: "Please Select Payment Card".localize)
            return
        }
        
    }
    
    @IBAction func buttonRemovePromoCode(_ sender: Any) {
        self.buttonApplyPromocode.isHidden = false
        self.viewPromoCodeApplied.isHidden = true
        self.promocode = ""
    }
}

extension PaymentVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.constraintPaymentCardsHeight.constant = CGFloat(115 * (savedCards.count))
        return savedCards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTVC", for: indexPath) as! PaymentTVC
        let obj = savedCards[indexPath.row]
        cell.labelCardName.text = "Master Card".localize
        let firstFour = obj.card_number.prefix(4)
        let lastFour = obj.card_number.suffix(4)
        cell.labelCardNumber.text = firstFour + " XXXX XXXX " + lastFour
        cell.labelCardPin.text = obj.card_name
        cell.labelValidThrough.text = obj.expiry_date
        obj.isSelected ? (cell.imageIsSelected.image = UIImage(named: "payment_radio")) : (cell.imageIsSelected.image = UIImage(named: "payment_unradio"))
        
        //        cell.delegate = self
        
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            // delete the item here
            self.deleteCardApi(id: self.savedCards[indexPath.row].id)
            completionHandler(true)
        }
        deleteAction.image = #imageLiteral(resourceName: "delete")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.savedCards.map{$0.isSelected = false}
        savedCards[indexPath.row].isSelected = true
        
        tableView.reloadData()
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PaymentTVC
        cell.viewBG.isHidden = false
        let mainView = tableView.subviews.filter{String(describing:Swift.type(of: $0)) == "_UITableViewCellSwipeContainerView"}
        if !mainView.isEmpty{
            let backgroundView = mainView[0].subviews
            if !backgroundView.isEmpty{
                backgroundView[0].frame = CGRect(x: 0, y: 8, width: mainView[0].frame.width, height: mainView[0].frame.height-16)
                backgroundView[0].layoutIfNeeded()
            }
        }
        
    }
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        if let index = indexPath{
            let cell = tableView.cellForRow(at: index) as! PaymentTVC
            
            UIView.animate(withDuration: 0.2, delay: 0, options:.curveEaseOut, animations: {
                cell.viewBG.isHidden = true
                cell.viewBG.layoutIfNeeded()
            })
        }
    }
    
}

//isHospitalBooking:1
//other_patient_name:
extension PaymentVC{
    func bookingApi(isHospital:Bool, forOthers:Bool){
        
        CommonUtils.showHudWithNoInteraction(show: true)
        let obj = UserData.shared
        var params:[String : Any] = [
            ApiParameters.appointment_type:String.getString(obj.selectedSlotModel?.appointment_type),
            ApiParameters.slot_id:String.getString(obj.selectedSlotModel?.slot_id),
            ApiParameters.date:String.getString(obj.selectedSlotModel?.date),
            ApiParameters.doctor_id:String.getString(obj.selectedSlotModel?.doctor_id),
            ApiParameters.fees:String.getString(obj.selectedSlotModel?.fees),
            ApiParameters.total_amount:String.getString(obj.selectedSlotModel?.total_amount),
            ApiParameters.patient_name:String.getString(obj.patientDetails?.patient_name),
            ApiParameters.patient_age:String.getString(obj.patientDetails?.patient_age),
            ApiParameters.patient_gender:String.getString(obj.patientDetails?.patient_gender),
            ApiParameters.patient_email:String.getString(obj.patientDetails?.patient_email),
            ApiParameters.patient_mobile:String.getString(obj.patientDetails?.patient_mobile),ApiParameters.patient_countryCode:String.getString(obj.patientDetails?.patient_countryCode),
            ApiParameters.address_id:String.getString(obj.patientDetails?.address_id),
            ApiParameters.is_save_adress:obj.patientDetails?.is_save_address ?? false ? "1" : "0",
            ApiParameters.old_date:String.getString(obj.old_date),
            ApiParameters.old_slot_id:String.getString(obj.old_slot_id),
            ApiParameters.slot_time:String.getString(obj.selectedSlotModel?.slot_time),
            ApiParameters.is_reschedule:obj.isReschedule ? "1" : "0",
            
        ]
        
        params[ApiParameters.kAddress] = String.getString(obj.patientDetails?.address)
        params[ApiParameters.kCity] = String.getString(obj.patientDetails?.city)
        params[ApiParameters.kPincode] = String.getString(obj.patientDetails?.pincode)
        params[ApiParameters.is_future_address] = obj.patientDetails?.is_future_address ?? false ? "1" : "0"
        
        
        if forOthers{
            params[ApiParameters.other_patient_name] = String.getString(obj.otherPatientDetails?.other_patient_name)
            params[ApiParameters.other_patient_age]  = String.getString(obj.otherPatientDetails?.other_patient_age)
            params[ApiParameters.other_patient_relation]  = String.getString(obj.otherPatientDetails?.other_patient_relation)
            params[ApiParameters.other_patient_insurance]  = String.getString(obj.otherPatientDetails?.other_patient_insurance)
            params[ApiParameters.other_patient_mobile]  = String.getString(obj.otherPatientDetails?.other_patient_mobile)
            params[ApiParameters.other_notes]  = String.getString(obj.otherPatientDetails?.other_notes)
            params[ApiParameters.isOtherKey] = "1"
            params[ApiParameters.other_patient_gender]  = String.getString(obj.otherPatientDetails?.other_patient_gender)
            params[ApiParameters.other_patient_email]  = String.getString(obj.otherPatientDetails?.other_email)
            params[ApiParameters.other_patient_countryCode]  = String.getString(obj.otherPatientDetails?.other_patient_countryCode)
            
        } else if isHospital {
            params[ApiParameters.isHospitalBooking] = "1"
            forOthers ? () : (params[ApiParameters.isOtherKey] = "0")
            params[ApiParameters.hospital_id] = String.getString(obj.hospital_id)
        } else {
            params[ApiParameters.isHospitalBooking] = "0"
            params[ApiParameters.isOtherKey] = "0"
        }
        
        var images:[[String:Any]] = []
        images.append(["imageName":ApiParameters.other_patient_imageFront,"image":UserData.shared.otherPatientDetails?.other_patient_imageFront ?? UIImage()])
        images.append(["imageName":ApiParameters.other_patient_imageBack,"image":UserData.shared.otherPatientDetails?.other_patient_imageBack ?? UIImage()])
        
        
        TANetworkManager.sharedInstance.requestMultiPart(withServiceName: ServiceName.bookAppointment, requestMethod: .post, requestImages: images, requestVideos: [:], requestData: params)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0{
                        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        vc.popUpDescription = "Payment has been successfully done".localize
                        vc.callback = {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                                self?.dismiss(animated: true, completion: {
                                    UserData.shared.isReschedule = false
                                    kSharedAppDelegate?.moveToHomeScreen()
                                }
                                )
                            })
                        }
                        self?.navigationController?.present(vc, animated: true)
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
    
    func getSavedCards(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:
                                                    //ServiceName.savedCards
                                                   ServiceName.getSavedCards
                                                   ,
                                                   
                                                   requestMethod: .GET,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    let data = kSharedInstance.getArray(dictResult["card_list"])
                    
                    self?.savedCards = data.map{SavedCardsModel(dict:kSharedInstance.getDictionary($0))}
                    
                    self?.tableView.reloadData()
                default:
                    print(dictResult["message"])
                    //CommonUtils.showToast(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToast(message: kNoInternetMsg)
                
            } else {
                CommonUtils.showToast(message: kDefaultErrorMsg)
            }
        }
    }
    func saveCardApi(isBooking:Bool = false,isOrder:Bool = false){
        
        if isBooking{
            self.bookingApi(isHospital: String.getString(UserData.shared.hospital_id).isEmpty ? false : true, forOthers: String.getString(UserData.shared.otherPatientDetails?.other_patient_name).isEmpty ? false : true)
        } else if isOrder{
            self.placeOrderApi(id: self.orderId ?? "", addressId: self.addressId ?? "", couponId: self.promocodeId ?? "")
        }
        else{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.navigationController?.popViewController(animated: true)
            })
        }
        
        
        
    }
    
    func placeOrderApi(id:String,addressId:String,couponId:String = ""){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [ApiParameters.order_id:
                                        id, ApiParameters.address_id:addressId,
                                     ApiParameters.coupon_id:couponId]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.orderPlace,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    
                    guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    vc.popUpDescription = "Your order placed successfully".localize
                    vc.callback = {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                            self?.dismiss(animated: true, completion: {
                                UserData.shared.isReschedule = false
                                kSharedAppDelegate?.moveToHomeScreen()
                            }
                            )
                        })
                    }
                    self?.navigationController?.present(vc, animated: true)
                    
                    
                    
                    
                default:
                    
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    return
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToast(message: kNoInternetMsg)
                
            } else {
                CommonUtils.showToast(message: kDefaultErrorMsg)
            }
        }
    }
    func deleteCardApi(id:String = ""){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params = [ApiParameters.cart_id: Int(id.toEnglishNumber()!)
        ]
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.deleteCard,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0 {
                        CommonUtils.showToast(message: "Card Deleted Successfully".localize)
                        self?.getSavedCards()
                        
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
}


