//
//  PharmacyMyOrdersVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 14/04/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class PharmacyMyOrdersVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var collectionVIew: UICollectionView!
    var doctors = ["",""]
    var hasCameFrom:HasCameFrom = .pending
    var orders:[PharmacyOrderModel] = []
    var internetTime = ""
    var sortType = 0
    @IBOutlet weak var lblTitle: UILabel!
    var url = ""
    var navigationTabsNames =
    ["Pending","Ongoing","Completed","Cancelled"]
    @IBOutlet weak var stackViewNavigation: UIStackView!
    var selectedTab = 0 {
        didSet{
            switch hasCameFrom{
            case .pending:
                self.tableView.register(UINib(nibName: PharmacyMainOrderListingTVC.identifier, bundle: nil), forCellReuseIdentifier: PharmacyMainOrderListingTVC.identifier)
            case .ongoing:
                self.tableView.register(UINib(nibName: PharmacyMainOrderListingTVC.identifier, bundle: nil), forCellReuseIdentifier: PharmacyMainOrderListingTVC.identifier)
            case .completed:
                self.tableView.register(UINib(nibName: PharmacyMainOrderListingTVC.identifier, bundle: nil), forCellReuseIdentifier: PharmacyMainOrderListingTVC.identifier)
            case .cancelled:
                self.tableView.register(UINib(nibName: PharmacyMainOrderListingTVC.identifier, bundle: nil), forCellReuseIdentifier: PharmacyMainOrderListingTVC.identifier)
            default:break
            }
            globalApis.getListing(type: hasCameFrom,sortType:String.getString(self.sortType),hasCameFrom: self.hasCameFrom){ data in
                self.orders = data
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.font = .corbenRegular(ofSize: 15)
        
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        self.selectedTab = 0
        setupNavigation()
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
        
    }
    override func viewWillAppear(_ animated: Bool) {
        globalApis.getListing(type: hasCameFrom,sortType:String.getString(self.sortType),hasCameFrom: self.hasCameFrom){ data in
            self.orders = data
            self.tableView.reloadData()
        }
    }
    func setupNavigation(selectedIndex:Int = 0){
        
        for (index,view) in self.stackViewNavigation.arrangedSubviews.enumerated(){
            for btn in view.subviews{
                if let button  = btn as? UIButton{
                    button.setTitleColor(selectedIndex == index ? (#colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)) : (#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1)), for: .normal)
                    button.titleLabel?.font = selectedIndex == index ? (UIFont(name: "SFProDisplay-Bold", size: 15)) : (UIFont(name: "SFProDisplay-Medium", size: 15))
                    button.adjustsImageWhenDisabled = false
                    button.adjustsImageWhenHighlighted = false
                }
                
                else{
                    btn.isHidden = index == selectedIndex ? (false) : (true)
                    btn.backgroundColor = index == selectedIndex ? (#colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)) : (#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1))
                    
                }
            }
        }
    }
    @IBAction func buttonCancelTapped(_ sender: Any) {
    }
    
    @IBAction func buttonSortTapped(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: PharmacySortVCViewController.getStoryboardID()) as? PharmacySortVCViewController else { return }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selectedSort = sortType
        vc.isMyOrders = true
        vc.callback = { type,selectedSort in
            self.sortType = selectedSort
            vc.dismiss(animated: true, completion: {
                globalApis.getListing(type: self.hasCameFrom,sortType:String.getString(self.sortType),hasCameFrom: self.hasCameFrom){ data in
                    self.orders = data
                    self.tableView.reloadData()
                }
                
            })
            
        }
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonsNavigationTapped(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            setupNavigation(selectedIndex: sender.tag)
            self.hasCameFrom = .pending
        case 1:
            setupNavigation(selectedIndex: sender.tag)
            self.hasCameFrom = .ongoing
        case 2:
            setupNavigation(selectedIndex: sender.tag)
            self.hasCameFrom = .completed
        case 3:
            setupNavigation(selectedIndex: sender.tag)
            self.hasCameFrom = .cancelled
        default: break
        }
        
        self.selectedTab = sender.tag
        //self.collectionView.reloadData()
        
        //
    }
    
    
}
//extension PharmacyMyOrdersVC:UICollectionViewDelegate,UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return navigationTabsNames.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewDoctorNavigationCVC", for: indexPath) as! ViewDoctorNavigationCVC
//        cell.labelTabName.text = navigationTabsNames[indexPath.row]
//        if indexPath.row == selectedTab{
//            cell.viewActive.isHidden = false
//            cell.labelTabName.textColor = #colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)
//        }
//        else{
//            cell.viewActive.isHidden = true
//            cell.labelTabName.textColor = #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1)
//        }
//        return cell
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        switch indexPath.row{
//        case 0:
//            self.hasCameFrom = .pending
//        case 1:
//            self.hasCameFrom = .ongoing
//        case 2:
//            self.hasCameFrom = .completed
//        case 3:
//            self.hasCameFrom = .cancelled
//        default:
//            break
//        }
//        self.selectedTab = indexPath.row
//        self.collectionVIew.reloadData()
//    }
//
//}
extension PharmacyMyOrdersVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.numberOfRow(numberofRow: orders.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch hasCameFrom{
        case .pending,.ongoing,.completed,.cancelled:
            let cell = tableView.dequeueReusableCell(withIdentifier: PharmacyMainOrderListingTVC.identifier, for: indexPath) as! PharmacyMainOrderListingTVC
            let obj = orders[indexPath.row]
            cell.labelStatus.isHidden = true
            cell.labelName.text = obj.address_details?.patient_name
            cell.labelAddress.text = obj.address_details?.address
            cell.labelQty.text = Int.getInt(obj.product_count) < 10 ? ("0"+obj.product_count + " Qty".localize) : (obj.product_count + " Qty".localize)
            cell.labelOrderId.text = obj.order_id
            let date = Date(unixTimestamp: Double.getDouble(obj.order_Date))
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .long
            dateFormatter.dateFormat = "MMM d, yyyy, hh:mm a "
            cell.labelDateTime.text = dateFormatter.string(from: date)
            cell.labelTotalPrice.text = "$" + obj.total_price
            cell.imageProduct.downlodeImage(serviceurl: obj.image[0], placeHolder: #imageLiteral(resourceName: "placeholder"))
            
            
            switch hasCameFrom{
            case .pending:
                cell.buttonFullDetails.setTitle("Full Details".localize, for: .normal)
                cell.buttonCancel.setTitle("Cancel Order".localize, for: .normal)
                cell.buttonCancel.isHidden = false
            case .ongoing:
                cell.buttonFullDetails.setTitle("Full Details".localize, for: .normal)
                cell.buttonCancel.setTitle("Cancel Order".localize, for: .normal)
                cell.buttonCancel.isHidden = false
            case .completed:
                cell.buttonFullDetails.setTitle("Repeat Order".localize, for: .normal)
                cell.buttonCancel.isHidden = true
            case .cancelled:
                cell.buttonFullDetails.setTitle("Place Order Again".localize, for: .normal)
                cell.buttonCancel.isHidden = true
            default:break
            }
            cell.callbackFullDetailsTapped = {
                switch self.hasCameFrom{
                case .pending:
                    guard let vc = UIStoryboard(name: "Pharmacy", bundle: nil).instantiateViewController(withIdentifier: ConfirmOrderVC.getStoryboardID()) as? ConfirmOrderVC else { return }
                    vc.orderId = obj.order_id
                    vc.hasCameFrom = .viewPharmacyOrder
                    self.navigationController?.pushViewController(vc, animated: true)
                case .ongoing:
                    guard let vc = UIStoryboard(name: "Pharmacy", bundle: nil).instantiateViewController(withIdentifier: ConfirmOrderVC.getStoryboardID()) as? ConfirmOrderVC else { return }
                    vc.orderId = obj.order_id
                    vc.hasCameFrom = .viewPharmacyOrder
                    self.navigationController?.pushViewController(vc, animated: true)
                case .completed:
                    kSharedAppDelegate?.moveToHomeScreen(index: 3)
                case .cancelled:
                    kSharedAppDelegate?.moveToHomeScreen(index: 3)
                default:break
                }
                
                
            }
            cell.callbackCancelTapped = {
                switch self.hasCameFrom{
                case .pending:
                    guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: AlertVC.getStoryboardID()) as? AlertVC else { return }
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    vc.alertDesc = "Are you sure you want to cancel this order?".localize
                    vc.yesCallback = {
                        
                        self.dismiss(animated: true, completion: {
                            globalApis.cancelOrderApi(id: obj.order_id){ message in
                                guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overFullScreen
                                vc.popUpDescription = message
                                vc.callback = {
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                                        self.dismiss(animated: true, completion: {
                                            let type = self.hasCameFrom ?? .pending
                                            globalApis.getListing(type: type, sortType: "0",hasCameFrom: self.hasCameFrom){ data in
                                                self.orders = data
                                                self.tableView.reloadData()
                                            }
                                        }
                                        )
                                    })
                                }
                                self.navigationController?.present(vc, animated: true)
                            }
                            
                        })
                        
                    }
                    self.navigationController?.present(vc, animated: true)
                    
                    
                case .ongoing:
                    guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: AlertVC.getStoryboardID()) as? AlertVC else { return }
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    vc.alertDesc = "Are you sure you want to cancel this order?".localize
                    vc.yesCallback = {
                        
                        self.dismiss(animated: true, completion: {
                            globalApis.cancelOrderApi(id: obj.order_id){ message in
                                guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overFullScreen
                                vc.popUpDescription = message
                                vc.callback = {
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                                        self.dismiss(animated: true, completion: {
                                            let type = self.hasCameFrom ?? .ongoing
                                            globalApis.getListing(type: type, sortType: "0",hasCameFrom: self.hasCameFrom){ data in
                                                self.orders = data
                                                self.tableView.reloadData()
                                            }
                                        }
                                        )
                                    })
                                }
                                self.navigationController?.present(vc, animated: true)
                            }
                            
                        })
                        
                    }
                    self.navigationController?.present(vc, animated: true)
                case .completed:
                    guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: GiveRatingVC.getStoryboardID()) as? GiveRatingVC else { return }
                    UserData.shared.hospital_id = ""
                    self.navigationController?.pushViewController(vc, animated: true)
                case .cancelled:
                    print("")
                default:break
                }
                
            }
            return cell
        default:return UITableViewCell()
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

extension PharmacyMyOrdersVC{
    func ratePharmacyOrder(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [ApiParameters.ratings:"",
                                     ApiParameters.comments:"",
                                     ApiParameters.product_id:""]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.pharmacyRating,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    
                    let data = kSharedInstance.getArray(dictResult["cart_list"])
                    
                    
                    
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
