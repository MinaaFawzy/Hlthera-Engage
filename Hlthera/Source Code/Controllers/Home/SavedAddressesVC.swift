//
//  SavedAddressesVC.swift
//  Hlthera
//
//  Created by fluper on 17/03/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class SavedAddressesVC: UIViewController {
    
    // @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var labelPageTitle: UILabel!
    var isConfirmOrder = false
    @IBOutlet weak var buttonAddAddress: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    var type = ""
    var addresses:[SavedAddressModel] = []
    var orderId = ""
    var cell:UITableViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelPageTitle.font = .corbenRegular(ofSize: 15)
        
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        if isConfirmOrder{
            self.labelPageTitle.text = "Delivery Address".localize
            self.buttonAddAddress.isHidden = false
            self.buttonNext.setTitle("Continue Ordering".localize, for: .normal)
            self.buttonNext.setImage(UIImage(), for: .normal)
            type = "1"
        }
        else{
            self.labelPageTitle.text = "My Saved Address".localize
            self.buttonAddAddress.isHidden = true
            self.buttonNext.setTitle("Add New Address".localize, for: .normal)
        }
        //tableView.isEditing = true
        // tableView.setEditing(true, animated: true)
        self.tableView.allowsMultipleSelectionDuringEditing = false
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getSavedAddresses()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonAddAddressTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: AddAddressVC.getStoryboardID()) as? AddAddressVC else {
            return
        }
        vc.type = self.type
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func buttonAddNewAddressTapped(_ sender: Any) {
        if !isConfirmOrder{
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: AddAddressVC.getStoryboardID()) as? AddAddressVC else {
                return
            }
            
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let res = addresses.filter{$0.isSelected}
            if !res.isEmpty{
                guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PaymentVC.getStoryboardID()) as? PaymentVC else {
                    return
                }
                vc.orderId = self.orderId
                vc.addressId = self.addresses.filter{$0.isSelected}[0].id
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                CommonUtils.showToast(message: "Please Select Delivery Address".localize)
                return
            }
        }
    }
    
}

extension SavedAddressesVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableView.numberOfRow(numberofRow: addresses.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SavedAddressesTVC.identifier, for: indexPath) as! SavedAddressesTVC
        let obj = addresses[indexPath.row]
        cell.labelName.text = obj.patient_name.isEmpty ? (UserData.shared.fullName) : (obj.patient_name)
        cell.labelMobile.text = obj.mobile_no.isEmpty ? (UserData.shared.mobileNumber) : (obj.mobile_no)
        cell.labelAddress.text = obj.address
        cell.labelCity.text = obj.city
        cell.labelPostCode.text = obj.pincode
        cell.deleteCallback = {
            self.deleteAddressApi(id: obj.id)
        }
        cell.editCallback = {
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: AddAddressVC.getStoryboardID()) as? AddAddressVC else { return }
            vc.hasCameFrom = .updateAddress
            vc.editAddress = self.addresses[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.viewContent.layer.borderColor = #colorLiteral(red: 0.137254902, green: 0.2980392157, blue: 0.4784313725, alpha: 1)
        obj.isSelected ? (cell.viewContent.layer.borderWidth = 1) : (cell.viewContent.layer.borderWidth = 0)
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isConfirmOrder{
            self.addresses.map{$0.isSelected = false}
            addresses[indexPath.row].isSelected = true
            tableView.reloadData()
        }
        
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            // delete the item here
            self.deleteAddressApi(id: self.addresses[indexPath.row].id)
            completionHandler(true)
        }
        deleteAction.image = #imageLiteral(resourceName: "delete")
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SavedAddressesTVC
        cell.viewBG.isHidden = false
        let mainView = tableView.subviews.filter{String(describing:Swift.type(of: $0)) == "_UITableViewCellSwipeContainerView"}
        if !mainView.isEmpty{
            let backgroundView = mainView[0].subviews
            if !backgroundView.isEmpty{
                backgroundView[0].frame = CGRect(x: 0, y: 5, width: mainView[0].frame.width, height: mainView[0].frame.height-10)
                backgroundView[0].layoutIfNeeded()
            }
        }
        
    }
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        if let index = indexPath{
            let cell = tableView.cellForRow(at: index) as! SavedAddressesTVC
            
            UIView.animate(withDuration: 0.2, delay: 0, options:.curveEaseOut, animations: {
                cell.viewBG.isHidden = true
                cell.viewBG.layoutIfNeeded()
            })
        }
    }
    
    
    
    
}
extension SavedAddressesVC{
    func getSavedAddresses(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.myAddress,                                                   requestMethod: .GET,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    let data = kSharedInstance.getArray(dictResult["my_address_list"])
                    self?.addresses = data.map{SavedAddressModel(data: kSharedInstance.getDictionary($0))}
                    
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
    func deleteAddressApi(id:String = ""){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params = [ApiParameters.address_id:String.getString(id),
        ]
        
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.deleteAddress,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0{
                        
                        
                        CommonUtils.showToast(message: "Address Deleted Successfully".localize)
                        self?.getSavedAddresses()
                        
                    } else {
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

class AutoTableView: UITableView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var height:CGFloat = 0;
            for s in 0..<self.numberOfSections {
                let nRowsSection = self.numberOfRows(inSection: s)
                for r in 0..<nRowsSection {
                    height += self.rectForRow(at: IndexPath(row: r, section: s)).size.height;
                }
            }
            return CGSize(width: -1, height: height )
        }
        set { }
    }
    
}
