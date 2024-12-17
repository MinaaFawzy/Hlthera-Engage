//
//  CouponCodeVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 20/01/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class CouponCodeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var lblTitle: UILabel!
    var coupons:[CouponModel] = []
    var searchedCoupons:[CouponModel] = []
    var searching = false
    var callback:((String)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.font = .corbenRegular(ofSize: 15)
        
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        let searchView = self.searchBar
        searchView?.layer.cornerRadius = 25
        searchView?.clipsToBounds = true
        searchView?.borderWidth = 0
        searchView?.setSearchIcon(image: #imageLiteral(resourceName: "search_black"))
        searchView?.searchTextPositionAdjustment = UIOffset(horizontal: 15, vertical: 0)
        searchView?.backgroundImage = UIImage()
        let searchField = self.searchBar.searchTextField
        searchField.backgroundColor = .white
        searchField.font = UIFont(name: "Helvetica", size: 13)
        searchField.textColor = #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1)
        searchBar.delegate = self
        searchField.addDoneOnKeyboardWithTarget(self, action: #selector(self.doneAction(_:)), shouldShowPlaceholder: false)
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getCoupons()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    @objc func doneAction(_ sender : UITextField!) {
        self.view.endEditing(true)
    }
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension CouponCodeVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            
            return tableView.numberOfRow(numberofRow: searchedCoupons.count, message: "No Results Found".localize)
            
            
        }
        else {
            return tableView.numberOfRow(numberofRow: coupons.count, message: "No Coupons Found".localize)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCodeTVC", for: indexPath) as! CouponCodeTVC
        var obj = coupons[indexPath.row]
        if searching{
            
            
            obj = searchedCoupons[indexPath.row]
            
        }
        else {
            obj = coupons[indexPath.row]
        }
        cell.labelCouponName.text = obj.name
        cell.imageCoupon.downlodeImage(serviceurl: obj.promo_image, placeHolder: #imageLiteral(resourceName: "placeholder_img"))
        cell.callback = {
            if self.searching{
                
                
                self.callback?(self.searchedCoupons[indexPath.row].promocode)
                
            }
            else {
                self.callback?(self.coupons[indexPath.row].promocode)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    
    
}
extension CouponCodeVC{
    func getCoupons(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        var params:[String : Any] = [:]
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.getCouponsList,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0{
                        
                        let result = kSharedInstance.getArray(withDictionary: dictResult[kResponse])
                        self?.coupons = result.map{
                            CouponModel(data: $0)
                        }
                        self?.tableView.reloadData()
                        
                        
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
extension CouponCodeVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchedCoupons = coupons.filter({
            $0.promocode.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.name.lowercased().prefix(searchText.count) == searchText.lowercased() })
        
        
        //        searchedResult = searchResults.filter{
        //            $0.doctor_specialities.contains(where: {$0.full_name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        //        }
        //$0.lowercased().prefix(searchText.count) == searchText.lowercased()
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
}

