//
//  PharmacyCartVC.swift
//  Hlthera
//
//  Created by fluper on 27/03/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class PharmacyCartVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelTotalPrice: UILabel!
    @IBOutlet weak var labelTotalItems: UILabel!
    var imageUrl = ""
    @IBOutlet weak var lblTitle: UILabel!
    var cartItems:[PharmacyCartModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.font = .corbenRegular(ofSize: 15)
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
       print("a7aa")
        getCartItems()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
       
           return .darkContent
        
    }

    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonBuyMoreTapped(_ sender: Any) {
        kSharedAppDelegate?.moveToHomeScreen(index: 3)
    }
    
    @IBAction func buttonCheckoutTapped(_ sender: Any) {
        
        if cartItems.isEmpty{
            CommonUtils.showToast(message: "Please Add items in cart to continue".localize)
            return
        } else {
            guard let vc = UIStoryboard(name: "Pharmacy", bundle: nil).instantiateViewController(withIdentifier: UploadPrescriptionVC.getStoryboardID()) as? UploadPrescriptionVC else { return }
            vc.totalPrice = self.labelTotalPrice.text ?? ""
            vc.totalItems = self.labelTotalItems.text ?? ""
                vc.isPrescribed = self.cartItems.filter{$0.product?.is_prescribed ?? false}.isEmpty ? false : true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension PharmacyCartVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.numberOfRow(numberofRow: cartItems.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PharmacyCartTVC.identifier, for: indexPath) as! PharmacyCartTVC
        let obj = cartItems[indexPath.row]
        cell.labelProductName.text = obj.product?.name.capitalized
        cell.labelProductPrice.text = "Price:".localize + "$" + obj.price
        cell.labelQty.text = obj.quantity
        cell.imageProduct.downlodeImage(serviceurl: String.getString((obj.product?.main_image ?? "")), placeHolder: #imageLiteral(resourceName: "placeholder-1"))
        
        cell.addItemCallback = {
            globalApis.addRemoveCartProduct(id: obj.product_id, qty: Int.getInt(obj.quantity) + 1, pharmacyId: obj.pharmacy_id,cartId: obj.id){ cartId in
                //obj.quantity = String.getString(Int.getInt(obj.quantity) + 1)
                //self.tableView.reloadData()
                self.getCartItems()
            }
        }
        cell.deleteCallback = {
            globalApis.removeCartProduct(id: obj.id){
                self.cartItems.remove(at: indexPath.row)
                //tableView.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    CommonUtils.showToast(message: String.getString("Item Removed Successfully!".localize))
                })
                self.getCartItems()
            }
        }
        cell.removeItemCallback = {
            if Int.getInt(obj.quantity)  == 1{
                globalApis.removeCartProduct(id: obj.id){
                    self.cartItems.remove(at: indexPath.row)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        CommonUtils.showToast(message: String.getString("Item Removed Successfully!".localize))
                    })
                    //tableView.reloadData()
                    self.getCartItems()
                }
                
            }
            else{
                globalApis.addRemoveCartProduct(id: obj.product_id, qty: Int.getInt(obj.quantity) - 1, pharmacyId: obj.pharmacy_id,cartId: obj.id){ cartId in
                    
                    //obj.quantity = String.getString(Int.getInt(obj.quantity) - 1)
                    //self.tableView.reloadData()
                    self.getCartItems()
                }
            }
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                // delete the item here
                let obj = self.cartItems[indexPath.row]
                globalApis.removeCartProduct(id: obj.id){
                    self.cartItems.remove(at: indexPath.row)
                    //tableView.reloadData()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        CommonUtils.showToast(message: String.getString("Item Removed Successfully!".localize))
                    })
                    self.getCartItems()
                }
                completionHandler(true)
            }
            deleteAction.image = #imageLiteral(resourceName: "delete")
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
extension PharmacyCartVC{
    func getCartItems(){
        CommonUtils.showHudWithNoInteraction(show: false)
        
        let params:[String : Any] = [:]
       
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.cart_list,                                                   requestMethod: .GET,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                
                    self?.imageUrl = String.getString(dictResult["url"])
                        let data = kSharedInstance.getArray(dictResult["cart_list"])
                
                    self?.labelTotalItems.text = "No. of items".localize + String.getString(dictResult["total_qty"])
                    self?.labelTotalPrice.text = "Price: $".localize + String.getString(dictResult["total_price"])
                    self?.cartItems = data.map{PharmacyCartModel(data: kSharedInstance.getDictionary($0))}
                    self?.tableView.reloadData()
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
class PharmacyCartTVC:UITableViewCell{
    
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var labelProductPrice: UILabel!
    @IBOutlet weak var labelQty: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var viewBG: UIView!
    
    var addItemCallback:(()->())?
    var removeItemCallback:(()->())?
    var deleteCallback:(()->())?

//      override func awakeFromNib() {
//          let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
//          leftSwipe.direction = .left
//          self.addGestureRecognizer(leftSwipe)
//
//          let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
//          rightSwipe.direction = .right
//          self.addGestureRecognizer(rightSwipe)
//      }
//
//
//      @IBAction func buttonDeleteTapped(_ sender: Any) {
//          deleteCallback?()
//      }
//      @objc func swipeLeft(sender: UISwipeGestureRecognizer){
//          btnDelete.isHidden = false
//          UIView.animate(withDuration: 0.2) {
//              self.constraintTrailing.constant = 60
//              self.constraintLeading.constant = -60
//              self.viewBG.isHidden = false
//              self.btnDelete.isHidden = false
//             // self.btnDelete.isUserInteractionEnabled = false
//              self.layoutIfNeeded()
//          }
//      }
//
//      @objc func swipeRight(sender: UISwipeGestureRecognizer){
//          UIView.animate(withDuration: 0.2) {
//              //self.btnDelete.isUserInteractionEnabled = true
//              self.constraintTrailing.constant = 0
//              self.constraintLeading.constant = 0
//              self.viewBG.isHidden = true
//              self.btnDelete.isHidden = true
//              self.layoutIfNeeded()
//          }
//      }
    
    
    @IBAction func buttonMinusTapped(_ sender: Any) {
        
        removeItemCallback?()
    }
    @IBAction func buttonAddTapped(_ sender: Any) {
        addItemCallback?()
    }
}
