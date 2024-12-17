//
//  AboutHospitalVC.swift
//  Hlthera
//
//  Created by Bisho Badie on 19/08/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit

class AboutHospitalVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var backgroundView: UIView!
//    @IBOutlet weak var aboutHospital: UITextView!
    @IBOutlet weak var aboutHospitalLable: UILabel!
    @IBOutlet weak var branchesCollection: UICollectionView!
    @IBOutlet weak var hospitalCollection: UICollectionView!
    @IBOutlet weak var doctorSearchBar: UISearchBar!
    @IBOutlet weak var doctorTable: UITableView!
    @IBOutlet weak var doctorTableImage: UIImageView!
    @IBOutlet weak var ratingTable: UITableView!
    @IBOutlet weak var ratingTableImage: UIImageView!
    
    var model: HospitalDetailsResult?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupCollectionViews()
//        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        setupSearchBar()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        aboutHospitalLable.text = model?.aboutHospital1
    }
    
    //MARK: - methods
    func setupTable() {
        ratingTable.delegate = self
        ratingTable.dataSource = self
        ratingTable.register(UINib(nibName: ReviewsAndRatingsTVC.identifier, bundle: nil), forCellReuseIdentifier: ReviewsAndRatingsTVC.identifier)
        doctorTable.delegate = self
        doctorTable.dataSource = self
        doctorTable.register(UINib(nibName: BookDoctorTVC.identifier, bundle: nil), forCellReuseIdentifier: BookDoctorTVC.identifier)
    }
    
    func setupSearchBar() {
        let searchView = self.doctorSearchBar
        searchView?.backgroundImage = UIImage()
        let searchField = self.doctorSearchBar.searchTextField
        searchField.backgroundColor = UIColor().hexStringToUIColor(hex: "#F5F7F9")
        searchField.textColor = UIColor().hexStringToUIColor(hex: "#212529")
        searchField.attributedPlaceholder = NSAttributedString(string: searchField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "#8794AA")])
        if let leftView = searchField.leftView as? UIImageView {
            leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
            leftView.tintColor = UIColor(hexString: "#8794AA")
        }
    }
    
    private func setupCollectionViews() {
        branchesCollection.delegate = self
        branchesCollection.dataSource = self
        branchesCollection.registerNib(for: BranchesCVC.self)
        hospitalCollection.delegate = self
        hospitalCollection.dataSource = self
        hospitalCollection.registerNib(for: HospitalCVC.self)
        hospitalCollection.isScrollEnabled = false
      }
}

// MARK: - UITableView Delegate & DataSource
extension AboutHospitalVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ratingTable {
            if model?.reviews?.count == 0 {
                ratingTableImage.isHidden = false
            } else {
                ratingTableImage.isHidden = true
            }
            return model?.reviews?.count ?? 0
        } else {
            if model?.doctorBasicInfo?.count == 0 {
                doctorTableImage.isHidden = false
            } else {
                doctorTableImage.isHidden = true
            }
            return model?.doctorBasicInfo?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ratingTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsAndRatingsTVC", for: indexPath) as! ReviewsAndRatingsTVC
            let obj = model?.reviews?[indexPath.row]
            cell.selectionStyle = .none
            if obj?.ratingType == "username"{
                cell.labelComment?.text = obj?.comments
                cell.labelUsername.text = obj?.clientName
                cell.imageProfile.downlodeImage(serviceurl: String.getString(obj?.clientPicture), placeHolder: UIImage(named: "placeholder"))
                cell.stackViewRatings.setRatings(value: Int(obj?.rating ?? 0))
            }
            else{
                cell.labelComment?.text = obj?.comments
                cell.labelUsername.text = "Anonymous".localize
                cell.imageProfile.isHidden = true
                cell.stackViewRatings.setRatings(value: Int(obj?.rating ?? 0))
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookDoctorTVC", for: indexPath) as! BookDoctorTVC
            let obj = model?.doctorBasicInfo?[indexPath.row]
            cell.labelDoctorName.text = obj?.doctorName
            cell.labelExperience.text = String.getString(obj?.doctorExp ?? "")
            cell.imageDoctor.downlodeImage(serviceurl: String.getString(obj?.doctorProfile), placeHolder: UIImage(named: "placeholder"))
//            cell.labelPrice.text = String.getString(obj?. ?? "")
            cell.labelRating.text = String.getString(obj?.ratings ?? "")
            return cell
        }
    }
    
}

// MARK: - UICollectionView Delegate & DataSource
extension AboutHospitalVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case hospitalCollection: return 3
        case branchesCollection: return 10
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case hospitalCollection:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HospitalCVC", for: indexPath) as? HospitalCVC else { return UICollectionViewCell() }
            return cell
        case branchesCollection:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BranchesCVC", for: indexPath) as? BranchesCVC else { return UICollectionViewCell() }
            return cell
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case branchesCollection: return CGSize.init(width: (view.frame.width-20)/3, height: branchesCollection.frame.height-20)
        case hospitalCollection: return CGSize.init(width: view.frame.width-20, height: 85)
        default: return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
