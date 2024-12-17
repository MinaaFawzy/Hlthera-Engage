//
//  OrderDetailsVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 14/04/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class OrderDetailsVC: UIViewController {
    @IBOutlet weak var labelOrderID: UILabel!
    @IBOutlet weak var labelOrderName: UILabel!
    @IBOutlet weak var labelTotalPrize: UILabel!
    @IBOutlet weak var labelReportType: UILabel!
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var labelTotalQty: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var products:[PharmacyProductModel] = []
    var url = ""
    var orderId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.font = .corbenRegular(ofSize: 15)
        
        self.tableView.register(UINib(nibName: PharmacyOrderListingTVC.identifier, bundle: nil), forCellReuseIdentifier: PharmacyOrderListingTVC.identifier)
        getOrderDetails(id: orderId)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonCancelOrderTapped(_ sender: Any) {
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension OrderDetailsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PharmacyOrderListingTVC.identifier, for: indexPath) as! PharmacyOrderListingTVC
        let obj = products[indexPath.row]
        cell.labelProductName.text = obj.name
        //cell.labelProductSubtitle.text = "subtitle"
        cell.labelQty.text = "Quantity(".localize +  obj.quantity + ")"
        cell.labelPrice.text = "$" + obj.main_price
        cell.imageProduct.downlodeImage(serviceurl: url + obj.main_image, placeHolder: #imageLiteral(resourceName: "placeholder-1"))
        
        return cell
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
extension OrderDetailsVC{
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
                    //                    self?.continueShop = String.getString(dictResult["continueShop"]) == "0" ? false : true
                    //                    self?.date = String.getString(dictResult["order_Date"])
                    //                    self?.createdAt = String.getString(dictResult["created_at"])
                    //                    self?.orderId = String.getString(dictResult["order_id"])
                    //                    self?.productCount = String.getString(dictResult["product_count"]) + " ITEMS"
                    //                    self?.totalPrice = String.getString(dictResult["main_price"])
                    self?.url = String.getString(dictResult["url"])
                    //                    self?.orderStatus = String.getString(dictResult["order_Status"])
                    //                    self?.transaction = String.getString(dictResult["transaction"])
                    //                    self?.address = String.getString(dictResult["address"])
                    self?.products = kSharedInstance.getArray(dictResult["data"]).map{PharmacyProductModel(dict: kSharedInstance.getDictionary($0))}
                    self?.tableView.reloadData()
                    //                    self?.collectionViewProducts.reloadData()
                    //                    self?.labelBookingId.text = self?.orderId
                    //                    self?.labelTotalPrice.text = self?.totalPrice
                    //                    self?.labelTotalItems.text = self?.productCount
                    //
                    //                    let date = self?.getDateFromCreatedAtString(dateString: String.getString(self?.createdAt))
                    //                    let dateFormatter = DateFormatter()
                    //                    dateFormatter.timeStyle = .none
                    //                    dateFormatter.dateStyle = .long
                    //                    dateFormatter.dateFormat = "EEEE, MMM d, yyyy hh:mm a"
                    //                    self?.labelBookingDateAndTime.text = dateFormatter.string(from: date ?? Date())
                    //                    self?.continueShop ?? false ? (self?.buttonContinue.isHidden = false) : (self?.buttonContinue.isHidden = true)
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
