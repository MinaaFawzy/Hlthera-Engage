//
//  ConfirmOrderVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 09/04/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class ConfirmOrderVC: UIViewController {
    
    @IBOutlet weak var labelBookingIDeading: UILabel!
    @IBOutlet var subViews: [UIView]!
    @IBOutlet weak var labelTotalPrice: UILabel!
    @IBOutlet weak var collectionViewProducts: UICollectionView!
    @IBOutlet weak var labelBookingDateAndTime: UILabel!
    @IBOutlet weak var labelBookingId: UILabel!
    @IBOutlet weak var labelTotalItems: UILabel!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var buttonCancelOrder: UIButton!
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var labelFees: UILabel!
    @IBOutlet weak var labelPrescriptionType: UILabel!
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var labelCartCount: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelTotalAmount: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelPaymentType: UILabel!
    @IBOutlet weak var labelShippingAddress: UILabel!
    @IBOutlet weak var labelTransactionID: UILabel!
    @IBOutlet weak var viewTransaction: UIView!
    @IBOutlet weak var viewTransactionHeight: NSLayoutConstraint!
    @IBOutlet weak var labelEstimatedDelivery: UILabel!
    @IBOutlet var viewsTrackingStatus: [UIView]!
    @IBOutlet weak var tableViewTrackingStatus: UITableView!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonRateProduct: UIButton!
    
    var orderTrackingData:[OrderStatusModel] = []
    var data:[PharmacyProductModel] = []
    var product:PharmacyProductModel?
    var orderId = ""
    var productCount = ""
    var totalPrice = ""
    var url = ""
    var orderStatus = ""
    var transaction = ""
    var createdAt = ""
    var address = ""
    var date = ""
    var continueShop = false
    var hasCameFrom:HasCameFrom = .placePharmacyOrder
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelPageTitle.font = .corbenRegular(ofSize: 15)
        
        setupCollectionView()
        
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        switch self.hasCameFrom{
        case .placePharmacyOrder:
            subViews[0].isHidden = true
            buttonCancelOrder.isHidden = true
            subViews[1].isHidden = false
            subViews[2].isHidden = true
            subViews[3].isHidden = false
            subViews[4].isHidden = true
            subViews[5].isHidden = true
            subViews[6].isHidden = true
            subViews[7].isHidden = false
            self.viewTransaction.isHidden = true
            self.viewTransactionHeight.constant = 0
            self.tableViewTrackingStatus.isHidden = true
            
            getOrderDetails(id: orderId)
        case .viewPharmacyOrder:
            subViews[0].isHidden = true
            buttonCancelOrder.isHidden = false
            subViews[1].isHidden = false
            subViews[2].isHidden = true
            subViews[3].isHidden = false
            subViews[4].isHidden = false
            subViews[5].isHidden = false
            subViews[6].isHidden = true
            subViews[7].isHidden = false
            self.labelPageTitle.text = "Order Details".localize
            self.labelTotalAmount.text = "Total Amount paid".localize
            self.labelBookingIDeading.text = "Order ID:".localize
            getOrderDetails(id: orderId)
            self.viewTransaction.isHidden = false
            self.tableViewTrackingStatus.isHidden = true
            self.buttonContinue.isHidden = true
            
        case .viewPharmacyProduct:
            if product?.order_status.last?.status == "8" {
                buttonRateProduct.isHidden = false
            }
            
            subViews[0].isHidden = false
            buttonCancelOrder.isHidden = true
            subViews[1].isHidden = true
            subViews[2].isHidden = false
            subViews[3].isHidden = true
            subViews[4].isHidden = true
            subViews[5].isHidden = true
            subViews[6].isHidden = false
            subViews[7].isHidden = false
            self.buttonContinue.isHidden = true
            self.labelPageTitle.text = "Product Details".localize
            self.labelTotalAmount.text = "Total Amount paid".localize
            self.labelStatus.isHidden = true
            
            self.labelCartCount.text = Int.getInt(product?.quantity) < 10 ? ("0" + String.getString(product?.quantity) + " Qty".localize) : (String.getString(product?.quantity) + " Qty".localize)
            self.labelDateTime.text = self.date
            self.imageProduct.downlodeImage(serviceurl: self.product?.main_image ?? "", placeHolder: #imageLiteral(resourceName: "placeholder"))
            self.labelProductName.text = product?.name.capitalized
            self.labelFees.text = "$".localize + String.getString(product?.main_price)
            self.labelTotalPrice.text = "$".localize + String.getString(product?.total_price)
            self.viewTransaction.isHidden = true
            self.viewTransactionHeight.constant = 0
            self.labelEstimatedDelivery.text = "Estimated Delivery:".localize + String.getString(product?.estimted_delivery)
            self.tableViewTrackingStatus.isHidden = false
            self.orderTrackingData = product?.order_status ?? []
            self.tableViewTrackingStatus.reloadData()
        default: break
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func setupCollectionView() {
        collectionViewProducts.register(UINib(nibName: PharmacyProductConfirmedCVC.identifier, bundle: nil), forCellWithReuseIdentifier: PharmacyProductConfirmedCVC.identifier)
        
    }
    
    func setItemStatus(code: Int, label: UILabel, isColor: Bool = true) {
        switch code{
        case 0:
            label.text = "Verification Pending".localize
            isColor ? (label.textColor = #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1)) : ()
        case 1:
            label.text = "Approved".localize
            isColor ? (label.textColor = #colorLiteral(red: 0.003921568627, green: 0.7098039216, blue: 0.07058823529, alpha: 1)) : ()
        case 2:
            label.text = "Rejected".localize
            isColor ? (label.textColor = #colorLiteral(red: 0.9176470588, green: 0.02352941176, blue: 0.02352941176, alpha: 1)) : ()
        case 3:
            label.text = "Order Pending".localize
            isColor ? (label.textColor = #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1)) : ()
        case 4:
            label.text = "Ongoing".localize
            isColor ? (label.textColor = #colorLiteral(red: 0.003921568627, green: 0.7098039216, blue: 0.07058823529, alpha: 1)) : ()
        case 5:
            label.text = "Delivered".localize
            isColor ? (label.textColor = #colorLiteral(red: 0.003921568627, green: 0.7098039216, blue: 0.07058823529, alpha: 1)) : ()
        case 6:
            label.text = "Cancelled".localize
            isColor ? (label.textColor = #colorLiteral(red: 0.9176470588, green: 0.02352941176, blue: 0.02352941176, alpha: 1)) : ()
            
        default:
            label.text = "Status unavailable".localize
        }
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonRateProductTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: GiveRatingVC.getStoryboardID()) as? GiveRatingVC else { return }
        vc.productId = self.product?.id ?? ""
        vc.hasCameFrom = .pharmacy
        UserData.shared.hospital_id = ""
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonContinueTapped(_ sender: Any) {
        if continueShop{
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: SavedAddressesVC.getStoryboardID()) as? SavedAddressesVC else { return }
            vc.isConfirmOrder = true
            vc.orderId = self.orderId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func buttonCancelOrderTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: AlertVC.getStoryboardID()) as? AlertVC else { return }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.alertDesc = "Are you sure you want to cancel this order?".localize
        vc.yesCallback = {
            
            self.dismiss(animated: true, completion: {
                globalApis.cancelOrderApi(id: self.orderId){ message in
                    guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    vc.popUpDescription = message
                    vc.callback = {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                            self.dismiss(animated: true, completion: {
                                self.navigationController?.popViewController(animated: true)
                            }
                            )
                        })
                    }
                    self.navigationController?.present(vc, animated: true)
                }
                
            })
            
        }
        self.navigationController?.present(vc, animated: true)
    }
    
}

extension ConfirmOrderVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PharmacyProductConfirmedCVC.identifier, for: indexPath) as! PharmacyProductConfirmedCVC
        let obj = data[indexPath.row]
        cell.labelProductName.text = obj.name.capitalized
        cell.labelProductSubtitle.text = obj.sort_desc
        cell.labelQty.text = "Quantity(".localize +  (Int.getInt(obj.quantity) > 10 ? "10+" : obj.quantity) + ")"
        cell.labelPrice.text = "$" + obj.main_price
        cell.imageProduct.downlodeImage(serviceurl: obj.main_image, placeHolder: #imageLiteral(resourceName: "placeholder-1"))
        if !obj.order_status.isEmpty{
            setItemStatus(code: Int.getInt(obj.order_status.last?.status), label: cell.labelItemStatus)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.02, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if hasCameFrom != .placePharmacyOrder{
            guard let vc = UIStoryboard(name: "Pharmacy", bundle: nil).instantiateViewController(withIdentifier: ConfirmOrderVC.getStoryboardID()) as? ConfirmOrderVC else {
                return
            }
            vc.orderId = self.orderId
            vc.hasCameFrom = .viewPharmacyProduct
            vc.product = data[indexPath.row]
            vc.date = self.labelBookingDateAndTime.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
extension ConfirmOrderVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        constraintTableViewHeight.constant = CGFloat(orderTrackingData.count * 60)
        return orderTrackingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderTrackingTVC.identifier, for: indexPath) as! OrderTrackingTVC
        
        setItemStatus(code: Int.getInt(orderTrackingData[indexPath.row].status), label: cell.labelStatusTitle,isColor: false)
        let date = Date(unixTimestamp: Double.getDouble(orderTrackingData[indexPath.row].status_date))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "hh:mm a, MMM d, yyyy "
        cell.labelDateTime.text = dateFormatter.string(from: date)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
extension ConfirmOrderVC{
    func getOrderDetails(id:String){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [ApiParameters.order_id:id]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.viewOrderDetail,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    self?.continueShop = String.getString(dictResult["continueShop"]) == "0" ? false : true
                    self?.date = String.getString(dictResult["order_Date"])
                    self?.createdAt = String.getString(dictResult["created_at"])
                    self?.orderId = String.getString(dictResult["order_id"])
                    self?.productCount = Int.getInt(dictResult["product_count"]) < 2 ? (String.getString(dictResult["product_count"]) + " ITEM") : (String.getString(dictResult["product_count"]) + " ITEMS")
                    self?.totalPrice = "$" + String.getString(dictResult["main_price"])
                    self?.url = String.getString(dictResult["url"])
                    self?.orderStatus = String.getString(dictResult["order_status"])
                    self?.transaction = String.getString(dictResult["transaction_id"])
                    let address = SavedAddressModel(data: kSharedInstance.getDictionary(dictResult["address"]))
                    self?.address = address.address
                    self?.labelShippingAddress.text = self?.address
                    self?.data = kSharedInstance.getArray(dictResult["data"]).map{PharmacyProductModel(dict: kSharedInstance.getDictionary($0))}
                    self?.collectionViewProducts.reloadData()
                    self?.labelBookingId.text = self?.orderId
                    self?.labelTotalPrice.text = self?.totalPrice
                    self?.labelTotalItems.text = self?.productCount
                    
                    let date = self?.getDateFromCreatedAtString(dateString: String.getString(self?.createdAt))
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = .none
                    dateFormatter.dateStyle = .long
                    dateFormatter.dateFormat = "hh:mm a, MMM d, yyyy "
                    self?.labelBookingDateAndTime.text = dateFormatter.string(from: date ?? Date())
                    if self?.hasCameFrom == .viewPharmacyOrder{
                        self?.buttonContinue.isHidden = true
                    }
                    else{
                        
                        self?.continueShop ?? false ? (self?.buttonContinue.isHidden = false) : (self?.buttonContinue.isHidden = true)
                    }
                    self?.labelTransactionID.text = self?.transaction
                    
                    
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
class OrderTrackingTVC:UITableViewCell{
    @IBOutlet weak var labelStatusTitle:UILabel!
    @IBOutlet weak var labelDateTime:UILabel!
}
