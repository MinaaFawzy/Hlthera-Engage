//
//  CartVC.swift
//  Hlthera
//
//  Created by Prashant on 14/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import ScalingCarousel

class CartVC: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionViewSlider: ScalingCarouselView!
    @IBOutlet weak var collectionViewCategorie: UICollectionView!
    @IBOutlet weak var collectionViewRecommended: UICollectionView!
    @IBOutlet weak var collectionViewTopProducts: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonCart: HltheraCartButton!
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var buttonAddress: UIButton!
    
    var categories:[PharmacyCategoriesModel] = []
    var recommendedProducts:[PharmacyProductModel] = []
    var topProducts:[PharmacyProductModel] = []
    var searchResults:[PharmacyProductModel] = []
    var imageUrl = ""
    var tableViewHeight = NSLayoutConstraint()
    let tableViewSearch = UITableView()
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var labelMarketPlace: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        setupSearchBar()
        setupCollectionViews()
        headerView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        headerView.layer.cornerRadius = 15
      
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
        hideSearch()
        
        getPharmacyCategories()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .darkContent
        
    }
    func setupCollectionViews(){
        collectionViewCategorie.register(UINib(nibName: PharmacyCategoryCVC.identifier, bundle: nil), forCellWithReuseIdentifier: PharmacyCategoryCVC.identifier)
        collectionViewRecommended.register(UINib(nibName: PharmacyProductCVC.identifier, bundle: nil), forCellWithReuseIdentifier: PharmacyProductCVC.identifier)
        collectionViewTopProducts.register(UINib(nibName: PharmacyProductCVC.identifier, bundle: nil), forCellWithReuseIdentifier: PharmacyProductCVC.identifier)
    }
    
    func setupSearchBar(){
        let searchView = self.searchBar
        searchView?.layer.cornerRadius = 20
        searchView?.clipsToBounds = true
        searchView?.borderWidth = 0
        searchView?.setSearchIcon(image: #imageLiteral(resourceName: "search-1"))
        searchView?.searchTextPositionAdjustment = UIOffset(horizontal: 5, vertical: 0)
        searchView?.backgroundImage = UIImage()
        let searchField = self.searchBar.searchTextField
        searchField.backgroundColor = .white
        searchField.font = UIFont(name: "Helvetica", size: 13)
        searchField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        searchField.addDoneOnKeyboardWithTarget(self, action: #selector(self.doneAction(_:)), shouldShowPlaceholder: false)
        self.view.addSubview(tableViewSearch)
        searchBar.delegate = self
        tableViewSearch.delegate = self
        tableViewSearch.dataSource = self
        
        tableViewSearch.frame = CGRect(x: 0, y: 0, width: headerView.frame.width, height: 150)
        tableViewSearch.translatesAutoresizingMaskIntoConstraints = false
        self.view.bringSubviewToFront(tableViewSearch)
        let leading = tableViewSearch.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor,constant: 0)
        let trailing = tableViewSearch.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor,constant: 0)
        
        let top = tableViewSearch.topAnchor.constraint(equalTo: headerView.bottomAnchor,constant: 0)
        self.tableViewHeight = tableViewSearch.heightAnchor.constraint(equalToConstant: 220)
        NSLayoutConstraint.activate([top,leading,trailing,self.tableViewHeight])
        tableViewSearch.register(UINib(nibName: PharmacyHomeSearchTVC.identifier, bundle: nil), forCellReuseIdentifier: PharmacyHomeSearchTVC.identifier)
        viewSearch.isHidden = true
        labelMarketPlace.isHidden = false
        if let clearButton = searchField.value(forKey: "_clearButton") as? UIButton{
            clearButton.addTarget(self, action: #selector(buttonCrossTapped(_:)), for: .touchUpInside)
        }
           
        //tableViewSearch.isScrollEnabled = false
        
    }
    @objc func doneAction(_ sender : UITextField!) {
        self.view.endEditing(true)
    }
    
    @IBAction func buttonViewAllRecommendedTapped(_ sender: Any) {
        guard let nextVc = UIStoryboard(name: "Pharmacy", bundle: nil).instantiateViewController(identifier: "SubCategoryVC") as? SubCategoryVC else {return}
        
        nextVc.products = self.recommendedProducts
        nextVc.hasCameFrom = .pharmacyRecommendedProducts
        nextVc.imageUrl = self.imageUrl
        
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    @IBAction func buttonViewAllTopProductionsTapped(_ sender: Any) {
        guard let nextVc = UIStoryboard(name: "Pharmacy", bundle: nil).instantiateViewController(identifier: "SubCategoryVC") as? SubCategoryVC else {return}
        nextVc.products = self.topProducts
        nextVc.hasCameFrom = .pharmarcyTopProducts
        nextVc.imageUrl = self.imageUrl
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    @IBAction func buttonLocationTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: FetchCurrentLocationVC.getStoryboardID()) as? FetchCurrentLocationVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func buttonCartTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Pharmacy", bundle: nil).instantiateViewController(withIdentifier: PharmacyCartVC.getStoryboardID()) as? PharmacyCartVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func buttonSearchBarTapped(_ sender: Any) {
        viewSearch.isHidden = false
        buttonSearch.isHidden = true
        labelMarketPlace.isHidden = true
        self.searchBar.becomeFirstResponder()
    }

}
extension CartVC:UISearchBarDelegate{
    func hideSearch(){
        searchBar.text = ""
        searchResults = []
        self.view.endEditing(true)
        tableViewHeight.constant = 0
        tableViewSearch.reloadData()
        self.viewSearch.isHidden = true
        self.buttonSearch.isHidden = false
        labelMarketPlace.isHidden = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.searchProducts(text: searchText)
            })
            
        }
        else{
            searchResults = []
            tableViewSearch.reloadData()
        }
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text != ""{
            
            searchProducts(text: String.getString(searchBar.text))
        }else
        {
            hideSearch()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearch()
    }
    @objc func buttonCrossTapped(_ sender:Any){
        hideSearch()
    }
    
}
extension CartVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewSlider{
            return 3
        }
        else if collectionView == collectionViewCategorie{
            return categories.count
        }else if collectionView == collectionViewRecommended{
            return collectionView.numberOfRow(numberofRow: recommendedProducts.count)
        }
        else{
            return collectionView.numberOfRow(numberofRow: topProducts.count)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewSlider{
            let mycell = collectionView.dequeueReusableCell(withReuseIdentifier: "CodeCell", for: indexPath) as! CodeCell
            
            if let scalingCell = mycell as? ScalingCarouselCell {
                scalingCell.mainView.backgroundColor = .blue
            }
            DispatchQueue.main.async {
                mycell.setNeedsLayout()
                mycell.layoutIfNeeded()
            }

            return mycell
           
        }
        else if collectionView == collectionViewCategorie{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PharmacyCategoryCVC.identifier, for: indexPath) as! PharmacyCategoryCVC
            let obj = categories[indexPath.row]
            cell.labelCategoryName.text = obj.category_name
            cell.imageCategory.downlodeImage(serviceurl: imageUrl + obj.category_image, placeHolder: #imageLiteral(resourceName: "placeholder-1"))
            return cell
            
        }else if collectionView == collectionViewRecommended{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PharmacyProductCVC.identifier, for: indexPath) as! PharmacyProductCVC
            let obj = recommendedProducts[indexPath.row]
            cell.labelProductName.text = obj.name.capitalized
            cell.labelProductSubtitle.text = obj.sort_desc
              
            cell.labelQty.text = "Quantity".localize + "(" +  (Int.getInt(obj.quantity) > 10 ? "10+" : obj.quantity) + ")"
            cell.labelPrice.text = "$" + obj.main_price
             let str = obj.main_price as NSString
           // cell.constraintLabelWidth.constant =  CGFloat(str.length*9)
            cell.imageProduct.downlodeImage(serviceurl:  obj.main_image, placeHolder: #imageLiteral(resourceName: "placeholder-1"))
            obj.is_wishlist ? (cell.buttonHeart.isSelected = true) : (cell.buttonHeart.isSelected = false)
            cell.favoriteCallback = {
                globalApis.wishlistProduct(id:obj.id){
                    
                    self.getRecommendedProducts()
                }
            }
            cell.cartCallback = {
                globalApis.addRemoveCartProduct(id: obj.id, qty: 1, pharmacyId: obj.pharmacy_id,cartId: obj.cart_id){ id in
                    obj.cart_id = id
                    collectionView.reloadData()
                }
            }
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PharmacyProductCVC.identifier, for: indexPath) as! PharmacyProductCVC
            let obj = topProducts[indexPath.row]
            cell.labelProductName.text = obj.name.capitalized
            cell.labelProductSubtitle.text = obj.sort_desc
            cell.labelQty.text = "Quantity".localize + "(" +  (Int.getInt(obj.quantity) > 10 ? "10+" : obj.quantity) + ")"
            cell.labelPrice.text = "$" + obj.main_price
            let str = obj.main_price as NSString
            //cell.constraintLabelWidth.constant =  CGFloat(str.length*9)
            cell.imageProduct.downlodeImage(serviceurl: obj.main_image, placeHolder: #imageLiteral(resourceName: "placeholder-1"))
            obj.is_wishlist ? (cell.buttonHeart.isSelected = true) : (cell.buttonHeart.isSelected = false)
            cell.favoriteCallback = {
                globalApis.wishlistProduct(id:obj.id){
                    
                    self.getTopProducts()
                    
                }
            }
            cell.cartCallback = {
                globalApis.addRemoveCartProduct(id: obj.id, qty: 1, pharmacyId: obj.pharmacy_id,cartId: obj.cart_id){ id in
                    obj.cart_id = id
                    collectionView.reloadData()
                }
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewSlider{
            
            return CGSize(width: collectionView.frame.width-50, height:collectionView.frame.height)
        }
        else if collectionView == collectionViewCategorie{
          return CGSize(width: 90, height: 90)
        }else if collectionView == collectionViewRecommended{
            return CGSize(width: collectionView.frame.width/2.02, height: 250)
        }
        else{
            return CGSize(width: collectionView.frame.width/2.02, height: 250)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionViewCategorie{
            guard let vc = UIStoryboard(name: "Pharmacy", bundle: nil).instantiateViewController(withIdentifier: SubCategoryVC.getStoryboardID()) as? SubCategoryVC else { return }
            vc.subcategory = categories[indexPath.row]
            vc.imageUrl = self.imageUrl
            vc.pageTitle = categories[indexPath.row].category_name
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == collectionViewRecommended{
            globalApis.getProductDetails(id:recommendedProducts[indexPath.row].id){ url, data in
                
                guard let vc = UIStoryboard(name: "Pharmacy", bundle: nil).instantiateViewController(withIdentifier: ProductDetailsVC.getStoryboardID()) as? ProductDetailsVC else { return }
                vc.data = data
                vc.imageUrl = url
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        else if collectionView == collectionViewTopProducts{
//            guard let vc = UIStoryboard(name: "Pharmacy", bundle: nil).instantiateViewController(withIdentifier: ProductDetailsVC.getStoryboardID()) as? ProductDetailsVC else { return }
//            vc.id = topProducts[indexPath.row].id
//            self.navigationController?.pushViewController(vc, animated: true)
            globalApis.getProductDetails(id:topProducts[indexPath.row].id){ url, data in
                
                guard let vc = UIStoryboard(name: "Pharmacy", bundle: nil).instantiateViewController(withIdentifier: ProductDetailsVC.getStoryboardID()) as? ProductDetailsVC else { return }
                vc.data = data
                vc.imageUrl = url
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
extension CartVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        self.tableViewHeight.constant = CGFloat(searchResults.count * 50)
        return searchResults.count > 5 ? 5 : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PharmacyHomeSearchTVC.identifier, for: indexPath) as! PharmacyHomeSearchTVC
        let obj = searchResults[indexPath.row]
        cell.labelProductName.text = obj.name
        cell.imageProduct.downlodeImage(serviceurl: obj.main_image, placeHolder: #imageLiteral(resourceName: "placeholder-1"))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        guard let vc = UIStoryboard(name: "Pharmacy", bundle: nil).instantiateViewController(withIdentifier: ProductDetailsVC.getStoryboardID()) as? ProductDetailsVC else { return }
        vc.id = searchResults[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
extension CartVC{
    func getPharmacyCategories(){
        CommonUtils.showHudWithNoInteraction(show: false)
        
        let params:[String : Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.pharmacyCategories,                                                   requestMethod: .GET,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                   
                    self?.imageUrl = String.getString(dictResult["url"])
                        let data = kSharedInstance.getArray(dictResult["categories"])
                        self?.categories =  data.map{
                            PharmacyCategoriesModel(dict:kSharedInstance.getDictionary($0))
                        }
                    self?.getTopProducts()
                        self?.collectionViewCategorie.reloadData()
                    
                   
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
    func getRecommendedProducts(){
        CommonUtils.showHudWithNoInteraction(show: false)
        
        let params:[String : Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.recommended_product,                                                   requestMethod: .GET,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                   
                    self?.imageUrl = String.getString(dictResult["url"])
                        let data = kSharedInstance.getArray(dictResult["product_list"])
                        self?.recommendedProducts =  data.map{
                            PharmacyProductModel(dict:kSharedInstance.getDictionary($0))
                        }
                    self?.buttonCart.refreshCartCount()
                        self?.collectionViewRecommended.reloadData()
                    
                   
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
    func getTopProducts(){
        CommonUtils.showHudWithNoInteraction(show: false)
        
        let params:[String : Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.top_order_products,                                                   requestMethod: .GET,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                   
                    self?.imageUrl = String.getString(dictResult["url"])
                        let data = kSharedInstance.getArray(dictResult["product_list"])
                        self?.topProducts =  data.map{
                            PharmacyProductModel(dict:kSharedInstance.getDictionary($0))
                        }
                    
                    
                    self?.getRecommendedProducts()
                        self?.collectionViewTopProducts.reloadData()
                    
                   
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
    func searchProducts(text:String){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [:]
        
        let url = (ServiceName.search_product + "?product_name=" + text).replacingOccurrences(of: " ", with: "+")
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:url,                                                   requestMethod: .GET,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                   
                        let data = kSharedInstance.getArray(dictResult["product_list"])
                    if !String.getString(self?.searchBar.text).isEmpty{
                        self?.searchResults =  data.map{
                            PharmacyProductModel(dict:kSharedInstance.getDictionary($0))
                        }
                    }else{
                        self?.searchResults = []
                    }
                        
                        self?.tableViewSearch.reloadData()
                   
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
