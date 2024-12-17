//
//  MyHospitalProfileVC.swift
//  Hlthera
//
//  Created by Mina Fawzy on 08/10/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class MyHospitalProfileVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var headerBackGroundView: UIView!
    @IBOutlet weak var HospitalProfileTableView: UITableView!
    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var hospitalSpecialties: UILabel!
    @IBOutlet weak var hospitalImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var specialtiesNumLAbel: UILabel!
    @IBOutlet weak var doctorsNumLabel: UILabel!
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    //MARK: - variables
    var selectedTab: Int = 0
    var id: Int = 0
    var model: HospitalDetailsResult?
    var navigationSelected: Bool = false
    var navigationTabsNames: [String] = [
        "Overview".localize,
        "Healers".localize,
        "Insurance".localize,
        "Reviews".localize]
    var navigationView: DoctorNavigationView?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.navigationView = getHospitalNavigationView()
        self.navigationView?.navigationTabsNames = self.navigationTabsNames
        self.navigationView?.setupCollectionView()
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(named: "11")
        fetchHospitalDetails(hospitalId: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                self.model = value.result
                self.selectedTab = 0
//                self.setupData(data: model)
                HospitalProfileTableView.reloadData()
                CommonUtils.showHudWithNoInteraction(show: false)
            case .failure(let error):
                CommonUtils.showHudWithNoInteraction(show: false)
                CommonUtils.showToast(message: error.localizedDescription)
            }
        }
//        setGradientBackground(view: headerBackGroundView, colors: [UIColor(named: "11")!, UIColor(named: "12")!])
//        setupCategoryCollection()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = .clear
    }
    
    //MARK: - IBActions
    @IBAction func shareButtonTapped(_ sender: Any) {
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - methods
    private func setGradientBackground(view: UIView, colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = [0.0, 1.0] // Adjust as needed to control the gradient direction
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func getHospitalNavigationView() -> DoctorNavigationView {
        return UINib(nibName: "DoctorNavigationView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! DoctorNavigationView
    }
    
    func setupCategoryCollection() {
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        categoryCollection.registerNib(for: HospitalCategory.self)
    }
    
    func setupTableView() {
        HospitalProfileTableView.delegate = self
        HospitalProfileTableView.dataSource = self
        HospitalProfileTableView.register(UINib(nibName: InfoAboutDoctorCell.identifier, bundle: nil), forCellReuseIdentifier: InfoAboutDoctorCell.identifier)
        HospitalProfileTableView.register(UINib(nibName: HospitalHealersTVC.identifier, bundle: nil), forCellReuseIdentifier: HospitalHealersTVC.identifier)
        HospitalProfileTableView.register(UINib(nibName: RatingDoctorProfileTVC.identifier, bundle: nil), forCellReuseIdentifier: RatingDoctorProfileTVC.identifier)
        HospitalProfileTableView.register(UINib(nibName: HospitalInsuranceTVC.identifier, bundle: nil), forCellReuseIdentifier: HospitalInsuranceTVC.identifier)
        HospitalProfileTableView.register(UINib(nibName: HospitalHeaderTVC.identifier, bundle: nil), forCellReuseIdentifier: HospitalHeaderTVC.identifier)
    }
    
    func setupData(data: HospitalDetailsResult?) {
        hospitalNameLabel.text = data?.hospitalName
        ratingLabel.text = String.getString(data?.rating)
        reviewsLabel.text = String.getString((data?.reviews?.count))
//        viewsLabel.text = String.getString(data.)
//        hospitalSpecialties.text = String.getString(data?.hospitalRegistration)
        hospitalImageView.downlodeImage(serviceurl: String.getString((data?.profileBaseURL ?? "") + (data?.profilePicture ?? "") ), placeHolder: UIImage(named: "placeholder_img"))
        specialtiesNumLAbel.text = "\(data?.specialtiesCount ?? 0)"
        doctorsNumLabel.text = "\(data?.doctorsCount ?? 0)"
        likesLabel.text = "\(data?.likes ?? 0)"
    }
}

//MARK: - table view functions of delegate and datasorce
extension MyHospitalProfileVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        HospitalProfileTableView.sectionHeaderTopPadding = 0
        if section == 0 {
            return nil
        }
        return self.navigationView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalHeaderTVC", for: indexPath) as! HospitalHeaderTVC
            cell.setupData(data: model)
            setGradientBackground(view: cell.headerBackGroundView, colors: [UIColor(named: "11")!, UIColor(named: "12")!])
            cell.callBackBackButton = {
                self.navigationController?.popViewController(animated: true)
            }
            cell.callBackShareButton = {
                
            }
            return cell
        } else {
            if indexPath.row  == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InfoAboutDoctorCell", for: indexPath) as! InfoAboutDoctorCell
                cell.infoLabel.text = model?.aboutHospital1
                return cell
            } else if indexPath.row  == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalHealersTVC", for: indexPath) as! HospitalHealersTVC
                cell.doctorsData = model?.doctorBasicInfo
                cell.doctorsTable.reloadData()
                return cell
            } else if indexPath.row  == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalInsuranceTVC", for: indexPath) as! HospitalInsuranceTVC
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RatingDoctorProfileTVC", for: indexPath) as! RatingDoctorProfileTVC
                cell.hasComeFrom = "hospital"
                cell.hospitalReviews = model?.reviews
                cell.bookAppointementButton.isHidden = true
                cell.bookForOthersButton.isHidden = true
                cell.ratingsTable.reloadData()
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//MARK: - collections funs
extension MyHospitalProfileVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return navigationTabsNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HospitalCategory", for: indexPath) as? HospitalCategory else { return UICollectionViewCell() }
        cell.categoryNameLabel.text = navigationTabsNames[indexPath.row]
        if indexPath.row == selectedTab {
            cell.activeView.backgroundColor = #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1)
            cell.categoryNameLabel.textColor = #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1)
        } else {
            cell.activeView.backgroundColor = .clear
            cell.categoryNameLabel.textColor = #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationSelected = true
        selectedTab = indexPath.row
        HospitalProfileTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        categoryCollection.reloadData()
    }
}

//MARK: - Scrolling extension
extension MyHospitalProfileVC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if HospitalProfileTableView.contentOffset.x == 0.0 && HospitalProfileTableView.contentOffset.y != 0.0{
            if let indexPath = HospitalProfileTableView.indexPathForRow(at: CGPoint(x: HospitalProfileTableView.contentOffset.x , y: HospitalProfileTableView.contentOffset.y + 50)) {
                if indexPath.section == 0 {
                    HospitalProfileTableView.backgroundColor = UIColor(named: "11")
                    UIApplication.shared.statusBarView?.backgroundColor = UIColor(named: "11")
                } else {
                    UIApplication.shared.statusBarView?.backgroundColor = .white
                    HospitalProfileTableView.backgroundColor = .white
                }
                print("\(indexPath.row)-------\(indexPath.section)")
//                categoryCollection.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
                self.navigationView?.DoctorNavigationCollectionView.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: [.centeredVertically, .centeredHorizontally], animated: true)
               
                if selectedTab != indexPath.row {
                    selectedTab = indexPath.row
//                    categoryCollection.reloadData()
                    self.navigationView?.selectedTab = indexPath.row
                    self.navigationView?.DoctorNavigationCollectionView.reloadData()
                }
            }
        }
    }
}

// MARK: - GET Doctor Details
extension MyHospitalProfileVC {
    private func fetchHospitalDetails(hospitalId: Int, completion: @escaping (Swift.Result<HospitalDetailsResponse, Error>) -> Void) {
//        CommonUtils.showHud(show: true)
        CommonUtils.showHudWithNoInteraction(show: true)
        let baseURL = "http://62.210.203.134/hlthera_engage_backend/api/user/hospitals/get-details"
        
        let params: [String: Any] = ["hospital_id": "\(hospitalId)"]
        let headers: [String: String] = ["accessToken": kSharedUserDefaults.getLoggedInAccessToken()]
        
        Alamofire.request(
            baseURL,
            method: .get,
            parameters: params,
            headers: headers
        )
        .responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let doctorData = try JSONDecoder().decode(HospitalDetailsResponse.self, from: data)
                        completion(.success(doctorData))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
                print(error)
            }
        }
    }
}
