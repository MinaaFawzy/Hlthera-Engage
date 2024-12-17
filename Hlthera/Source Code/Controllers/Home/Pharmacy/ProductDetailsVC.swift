//
//  ProductDetailsVC.swift
//  Hlthera
//
//  Created by fluper on 25/03/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class ProductDetailsVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var labelPharmacyName: UILabel!
    @IBOutlet weak var labelPharmacyAddress: UILabel!
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var labelProductPrice: UILabel!
    @IBOutlet weak var labelProductSubtitle: UILabel!
    @IBOutlet weak var collectionViewProductImages: UICollectionView!
    @IBOutlet weak var labelProductTitle: UILabel!
    @IBOutlet weak var labelProductShortDescription: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var buttonCart: HltheraCartButton!
    @IBOutlet weak var buttonViewAddCart: UIButton!
    var array = [false,false,false]
    var titles = ["About this Product", "Benefits", "How to take/use"]
    var productData: [[String]] = [[""],[""],[""]]
    
    var data:PharmacyProductModel?
    var id = ""
    var imageUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.font = .corbenRegular(ofSize: 15)
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateDetails(obj: data ?? PharmacyProductModel(dict: [:]))
        buttonCart.refreshCartCount()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x/scrollView.bounds.width
        pageControl.currentPage = Int(x)
        print(scrollView.contentOffset.x)
    }
    
    func updateDetails(obj: PharmacyProductModel) {
        self.labelPharmacyName.text = obj.pharmacy_name
        self.labelPharmacyAddress.text = obj.pharmacy_address
        self.labelProductName.text = obj.name.capitalized
        self.labelProductSubtitle.text = obj.sort_desc
        self.labelProductShortDescription.text = obj.long_description
        self.labelProductPrice.text = "$" + obj.main_price
        self.pageControl.numberOfPages = obj.product_images.count
        obj.cart_id.isEmpty ? (self.buttonViewAddCart.setTitle("Add to Cart".localize, for:.normal)) : (self.buttonViewAddCart.setTitle("View Cart".localize, for:.normal))
        self.productData = [[data?.about_product ?? ""],data?.product_benifit ?? [],[data?.howtouse ?? ""]]
        self.collectionViewProductImages.reloadData()
        self.tableView.reloadData()
        
        
    }
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonCartTapped(_ sender: UIButton) {
        if let obj = data{
            if obj.cart_id.isEmpty && sender.tag != 1{
                globalApis.addRemoveCartProduct(id: data?.id ?? "", qty: 1, pharmacyId: data?.pharmacy_id ?? ""){ cartId in
                    self.data?.cart_id = cartId
                    
                    self.data?.cart_id.isEmpty ?? true ? (self.buttonViewAddCart.setTitle("Add to Cart".localize,for:.normal)) : (self.buttonViewAddCart.setTitle("View Cart".localize,for:.normal))
                    self.buttonCart.refreshCartCount()
                }
            }
            else{
                guard let vc = UIStoryboard(name: "Pharmacy", bundle: nil).instantiateViewController(withIdentifier: PharmacyCartVC.getStoryboardID()) as? PharmacyCartVC else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        
    }
}
extension ProductDetailsVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView    = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: array[section] ? 50 : 80))
        
        let subHeaderView = UIView(frame: CGRect(x: 2.5, y: 15, width: tableView.frame.width-5, height: 50))
        let tap = MyTapGesture.init(target: self, action: #selector(viewTitleTapped(_:)))
        tap.index = section
        subHeaderView.addGestureRecognizer(tap)
        subHeaderView.layer.maskedCorners = array[section] ? ([.layerMinXMinYCorner,.layerMaxXMinYCorner]) : ([.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner,.layerMinXMaxYCorner])
        let categoryLabel = UILabel(frame: CGRect(x: 15, y: 0, width: 200, height: 50))
        let dropDownImage = UIImageView(frame: CGRect(x:subHeaderView.frame.width - (40) , y: subHeaderView.frame.height/2 - 2.5 , width: 20.5, height: 9.5))
        let layer = subHeaderView.layer
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.45
        layer.shadowRadius = 2.5
        layer.masksToBounds = false
        subHeaderView.backgroundColor = .white
        subHeaderView.cornerRadius = 12
        headerView.backgroundColor = .white
        dropDownImage.image = array[section] ? (UIImage(named: "down_arrow_up")) : (UIImage(named: "down_arrow_down"))
        categoryLabel.font = UIFont(name: "SFProDisplay-Medium", size: 15.0)
        categoryLabel.textColor = #colorLiteral(red: 0.1450980392, green: 0.231372549, blue: 0.5019607843, alpha: 1)
        headerView.tag = section
        headerView.addSubview(subHeaderView)
        subHeaderView.addSubview(categoryLabel)
        subHeaderView.addSubview(dropDownImage)
        categoryLabel.text = self.titles[section]
        return headerView
    }
    @objc func viewTitleTapped(_ sender: MyTapGesture){
        self.array[sender.index] = !self.array[sender.index]
        
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.constraintTableViewHeight.constant = self.self.tableView.contentSize.height
        })
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return array[section] ? 65 : 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.productData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductDetailsTVC.identifier, for: indexPath) as! ProductDetailsTVC
        
        if indexPath.item == 1{
            let str = ""
            productData[indexPath.section].map{str + "\n" + $0}
            cell.labelContent.text = str
        }else{
            cell.labelContent.text = productData[indexPath.section][indexPath.row]
        }
        
        
        array[indexPath.section] ? (cell.viewContent.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]) : (cell.viewContent.layer.maskedCorners = [])
        cell.viewContent.layer.cornerRadius = 12
        cell.callback = {
            self.array[indexPath.row] = !self.array[indexPath.row]
            
            self.tableView.reloadData()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return array[indexPath.section] ? (UITableView.automaticDimension) : (0)
    }
    
    
}
extension ProductDetailsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.product_images.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductDetailsImagesCVC.identifier, for: indexPath) as! ProductDetailsImagesCVC
        if let images = data?.product_images{
            cell.imageProduct.downlodeImage(serviceurl: imageUrl+images[indexPath.row].images, placeHolder: #imageLiteral(resourceName: "placeholder-1"))
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewProductImages.frame.width, height: collectionViewProductImages.frame.height)
    }
    
}

class MyTapGesture: UITapGestureRecognizer {
    var index = Int()
}
