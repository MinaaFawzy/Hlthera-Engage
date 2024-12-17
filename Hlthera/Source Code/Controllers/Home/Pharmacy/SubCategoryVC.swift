//
//  SubCategoryVC.swift
//  Hlthera
//
//  Created by fluper on 27/03/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class SubCategoryVC: UIViewController {
    
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var viewSearchBar: UIView!
    @IBOutlet weak var constraintSubCategoriesHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewSubCategories: UICollectionView!
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var collectionProducts: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var subcategory:PharmacyCategoriesModel?
    var imageUrl = ""
    var products:[PharmacyProductModel] = []
    var searchedProducts:[PharmacyProductModel] = []
    var pageTitle = "Product Category".localize
    var isSearching = false
    var id = ""
    var sortType = ""
    var selectedSort = 0
    var hasCameFrom:HasCameFrom = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViews()
        setupSearchBar()
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        self.labelPageTitle.text = pageTitle
        switch hasCameFrom{
        case .pharmacyRecommendedProducts:
            constraintSubCategoriesHeight.constant = 0
            id = subcategory?.categories[0].id ?? ""
            self.labelPageTitle.text = "Recommended Products".localize
        case .pharmarcyTopProducts:
            constraintSubCategoriesHeight.constant = 0
            id = subcategory?.categories[0].id ?? ""
            self.labelPageTitle.text = "Top Products".localize
        default:
            constraintSubCategoriesHeight.constant = 95
            if subcategory?.categories.indices.contains(0) ?? false{
                getProducts(id: subcategory?.categories[0].id ?? "")
                id = subcategory?.categories[0].id ?? ""
                subcategory?.categories.map{$0.isSelected = false}
                subcategory?.categories[0].isSelected = true
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func setupSearchBar() {
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
        searchBar.delegate = self
        buttonSearch.isHidden = false
        viewSearchBar.isHidden = true
        //tableViewSearch.isScrollEnabled = false
    }
    
    @objc func doneAction(_ sender : UITextField!) {
        self.view.endEditing(true)
    }
    
    func setupCollectionViews() {
        collectionViewSubCategories.register(UINib(nibName: PharmacyCategoryCVC.identifier, bundle: nil), forCellWithReuseIdentifier: PharmacyCategoryCVC.identifier)
        collectionProducts.register(UINib(nibName: PharmacyProductCVC.identifier, bundle: nil), forCellWithReuseIdentifier: PharmacyProductCVC.identifier)
        
    }
    
    @IBAction func buttonSearchTapped(_ sender: Any) {
        buttonSearch.isHidden = true
        viewSearchBar.isHidden = false
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSortByTapped(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: PharmacySortVCViewController.getStoryboardID()) as? PharmacySortVCViewController else { return }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selectedSort = selectedSort
        vc.callback = { type,selectedSort in
            self.selectedSort = selectedSort
            vc.dismiss(animated: true, completion: {self.sortType = String.getString(type)
                self.getProducts(id: self.id,hasCameFrom: self.hasCameFrom)})
            
        }
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
}

extension SubCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewSubCategories{
            return subcategory?.categories.count ?? 0
        } else {
            return isSearching ? collectionView.numberOfRow(numberofRow: searchedProducts.count)   : collectionView.numberOfRow(numberofRow: products.count)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewSubCategories{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PharmacyCategoryCVC.identifier, for: indexPath) as! PharmacyCategoryCVC
            
            if let obj = subcategory?.categories[indexPath.row]{
                cell.viewContent.borderColor = #colorLiteral(red: 0.08235294118, green: 0.2235294118, blue: 0.3960784314, alpha: 1)
                obj.isSelected ? (cell.viewContent.layer.borderWidth = 2) : (cell.viewContent.layer.borderWidth = 0)
                cell.imageCategory.downlodeImage(serviceurl: "https://hlthera-s3.s3-ap-southeast-2.amazonaws.com/category_image/" + obj.category_image, placeHolder: #imageLiteral(resourceName: "placeholder-1"))
                cell.labelCategoryName.text = obj.category_name
            }
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PharmacyProductCVC.identifier, for: indexPath) as! PharmacyProductCVC
            
            let obj = isSearching ? searchedProducts[indexPath.row] : products[indexPath.row]
            cell.labelProductName.text = obj.name.capitalized
            cell.labelProductSubtitle.text = obj.sort_desc
            cell.labelQty.text = "Quantity(".localize +  (Int.getInt(obj.quantity) > 10 ? "10+" : obj.quantity) + ")"
            cell.labelPrice.text = "$" + obj.main_price
            cell.imageProduct.downlodeImage(serviceurl:  obj.main_image, placeHolder: #imageLiteral(resourceName: "placeholder-1"))
            obj.is_wishlist ? (cell.buttonHeart.isSelected = true) : (cell.buttonHeart.isSelected = false)
            cell.favoriteCallback = {
                globalApis.wishlistProduct(id:obj.id){
                    self.getProducts(id: self.id, hasCameFrom: self.hasCameFrom)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewSubCategories {
            subcategory?.categories.map{$0.isSelected = false}
            subcategory?.categories[indexPath.row].isSelected = true
            isSearching = false
            self.collectionProducts.reloadData()
            self.view.endEditing(true)
            collectionViewSubCategories.reloadData()
            buttonSearch.isHidden = false
            viewSearchBar.isHidden = true
            self.searchBar.text = ""
            id = subcategory?.categories[indexPath.row].id ?? ""
            getProducts(id: subcategory?.categories[indexPath.row].id ?? "")
        } else {
            globalApis.getProductDetails(id:isSearching ? searchedProducts[indexPath.row].id : products[indexPath.row].id){ url, data in
                
                guard let vc = UIStoryboard(name: "Pharmacy", bundle: nil).instantiateViewController(withIdentifier: ProductDetailsVC.getStoryboardID()) as? ProductDetailsVC else { return }
                vc.data = data
                vc.imageUrl = url
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewSubCategories{
            return CGSize(width: 90, height: 90)
        } else {
            return CGSize(width: collectionView.frame.width/2.02, height: 250)
        }
    }
    
}

extension SubCategoryVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            buttonSearch.isHidden = false
            viewSearchBar.isHidden = true
            isSearching = false
            self.view.endEditing(true)
        } else {
            isSearching = true
            searchedProducts = products.filter({
                $0.name.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.pharmacy_name.prefix(searchText.count) == searchText.lowercased()})
        }
        print(searchText)
        
        collectionProducts.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        buttonSearch.isHidden = false
        viewSearchBar.isHidden = true
        isSearching = false
        searchBar.text = ""
        self.view.endEditing(true)
        collectionProducts.reloadData()
    }
    
}

extension SubCategoryVC {
    func getProducts(id:String,hasCameFrom:HasCameFrom = .none){
        
        var url = ServiceName.product_list + "?subCategory_id=\(id)" + "&sort="+sortType
        var reqMethod:kHTTPMethod = .POST
        switch hasCameFrom{
        case .pharmacyRecommendedProducts:
            url = ServiceName.recommended_product + "?sort="+sortType
            reqMethod = .GET
        case .pharmarcyTopProducts:
            url = ServiceName.top_order_products + "?sort="+sortType
            reqMethod = .GET
        default:
            reqMethod = .POST
            url = ServiceName.product_list + "?subCategory_id=\(id)" + "&sort="+sortType
        }
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [:]
        TANetworkManager.sharedInstance.requestApi(withServiceName:url,                                                   requestMethod: reqMethod,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    self?.isSearching = false
                    self!.searchBar.text = ""
                    self?.imageUrl = String.getString(dictResult["url"])
                    let data = kSharedInstance.getArray(dictResult["product_list"])
                    self?.products =  data.map{
                        PharmacyProductModel(dict:kSharedInstance.getDictionary($0))
                    }
                    
                    
                    self?.collectionProducts.reloadData()
                    
                    
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
