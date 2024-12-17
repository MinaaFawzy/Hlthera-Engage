//
//  HospitalDetailsVC.swift
//  Hlthera
//
//  Created by Bishoy Badea [Pharma] on 20/05/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage


@available(iOS 15.0, *)
class HospitalDetailsVC: UIViewController, pageViewControllerProtocal {
    
    // MARK: - Outlets
    @IBOutlet weak var constraintContainerViewHeihgt: NSLayoutConstraint!
    @IBOutlet weak var ContainerView: UIView!
    @IBOutlet weak private var bookNowButton: UIButton!
    @IBOutlet weak private var numberOfSpecialitiesLabel: UILabel!
    @IBOutlet weak private var numberOfDoctorsLabel: UILabel!
    @IBOutlet weak private var viewsLabel: UILabel!
    @IBOutlet weak private var likeButton: UIButton!
    @IBOutlet weak private var likesLabel: UILabel!
    @IBOutlet weak private var reviewsLabel: UILabel!
    @IBOutlet weak private var ratingLabel: UILabel!
    @IBOutlet weak private var shareButton: UIButton!
    @IBOutlet weak private var hospitalCityNameLabel: UILabel!
    @IBOutlet weak private var specialityLabel: UILabel!
    @IBOutlet weak private var categoriesCollectionView: UICollectionView!
    @IBOutlet weak private var headerView: UIView!
    @IBOutlet weak private var profileImageView: UIImageView!
    
    // MARK: - Stored Properties
    var navigationTabsNames: [String] = [
        "Overview",
        "Healers",
        "Insurance",
        "Reviews"]
    var selectedTab = 0
    var id: Int = 0
    var model: HospitalDetailsResult?
    var containerViewController: PageVIewController?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViews()
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(named: "11")
        fetchHospitalDetails(hospitalId: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                self.model = value.result
                self.selectedTab = 0
                self.containerViewController?.hasCameFrom = .hospitals
                self.containerViewController?.hospitalData = self.model
                self.containerViewController?.changeViewController(index: 0, direction: .forward)
                self.setupView()
            case .failure(let error):
                CommonUtils.showHudWithNoInteraction(show: false)
                CommonUtils.showToast(message: error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerViewController?.changeViewController(index: 0, direction: .forward)
        selectedTab = 0
        categoriesCollectionView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = .clear
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PageVIewController,
           segue.identifier == "HospitalPageVC" {
            containerViewController = vc
            vc.delegate = self
            vc.hasCameFrom = .hospitals
            vc.hospitalData = self.model
            vc.mydelegate = self
        }
    }
    
    
    
    private func setupView() {
        hospitalCityNameLabel.text = model?.hospitalName
        profileImageView.downlodeImage(serviceurl: String.getString((self.model?.profileBaseURL ?? "") + (self.model?.profilePicture ?? "") ), placeHolder: UIImage(named: "placeholder_img"))
        ratingLabel.text = "\(model?.rating ?? 0)"
        numberOfSpecialitiesLabel.text = "\(model?.specialtiesCount ?? 0)"
        reviewsLabel.text = "\(model?.reviews?.count ?? 0)"
        numberOfDoctorsLabel.text = "\(model?.doctorsCount ?? 0)"
        likesLabel.text = "\(model?.likes ?? 0)"
        CommonUtils.showHudWithNoInteraction(show: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.setGradientBackground()
    }
    
    private func setupCollectionViews() {
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.registerNib(for: CategoryCVC.self)
    }
    
    private func setupGradientBackground() {
        headerView.applyGradient(
            colors: [
                UIColor(red: 61, green: 115, blue: 183),
                UIColor(red: 35, green: 65, blue: 107)
            ],
            startPoint: CGPoint(x: 0.0, y: 0.0),
            endPoint: CGPoint(x: 1.0, y: 1.0))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    func getSelectedPageIndex(with value: Int) {
        selectedTab = value
        if value == 0 {
            selectedTab = value
            self.categoriesCollectionView.reloadData()
            self.constraintContainerViewHeihgt.constant = 900
        } else {
            selectedTab = value
            self.categoriesCollectionView.reloadData()
            self.constraintContainerViewHeihgt.constant = 500
        }
        self.categoriesCollectionView.reloadData()
    }
    
    
    
}

// MARK: - Actions
extension HospitalDetailsVC {
    @IBAction private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - UICollectionView Delegate & DataSource
extension HospitalDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoriesCollectionView: return navigationTabsNames.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case categoriesCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCVC", for: indexPath) as? CategoryCVC else { return UICollectionViewCell() }
            cell.categoryTitleLabel.text = navigationTabsNames[indexPath.row]
            if indexPath.row == selectedTab {
                cell.focusView.backgroundColor = #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1)
                cell.categoryTitleLabel.textColor = #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1)
            } else {
                cell.focusView.backgroundColor = .clear
                cell.categoryTitleLabel.textColor = #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1)
            }
            return cell
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lastIndex = selectedTab
        selectedTab = indexPath.row
        var moveToScreen = true
        switch selectedTab {
        case 1:
            if model?.doctorBasicInfo?.count == 0 {
                moveToScreen = false
                CommonUtils.showToast(message: "No Healers Found")
            }
        case 2:
            if model?.insurances?.count == 0 {
                moveToScreen = false
                CommonUtils.showToast(message: "No Insurances Found")
            }
        case 3:
            if model?.reviews?.count == 0 {
                moveToScreen = false
                CommonUtils.showToast(message: "No Reviews Found")
            }
        default : break
            
        }
        if moveToScreen {
            if lastIndex > selectedTab {
                containerViewController?.changeViewController(index: selectedTab, direction: .reverse)
            } else {
                containerViewController?.changeViewController(index: selectedTab, direction: .forward)
            }
            categoriesCollectionView.reloadData()
        }
    }
}

// MARK: - Apply Gradient
extension UIView {
    func applyGradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

// TODO: - Compositional Collection View in Case we want to implement it....

//
//class MyCollectionViewController: UICollectionViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Set up collection view layout
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
//            // Return the layout for each section
//            // Customize the layout as per your requirements
//            return self.createLayoutSection()
//        }
//        // Assign the layout to the collection view
//        collectionView.collectionViewLayout = layout
//    }
//
//    // Create and return the layout section
//    private func createLayoutSection() -> NSCollectionLayoutSection {
//        // Customize and configure your layout section here
//        // You can define groups, items, and supplementary views
//        // using NSCollectionLayoutGroup, NSCollectionLayoutItem, and NSCollectionLayoutBoundarySupplementaryItem
//        // Return the configured layout section
//        return .init(group: .init(layoutSize: .init(widthDimension: 100, heightDimension: 100)))
//    }
//}
//
//override func numberOfSections(in collectionView: UICollectionView) -> Int {
//    // Return the number of sections in your collection view
//}
//
//override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    // Return the number of items in each section of your collection view
//}
//
//override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    // Dequeue and configure the cell for the corresponding index path
//    // Return the configured cell
//}
//
//class MyCollectionViewCell: UICollectionViewCell {
//    // Customize your collection view cell
//}
//
//class MySupplementaryView: UICollectionReusableView {
//    // Customize your supplementary view
//}
//
////collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "CellIdentifier")
////collectionView.register(MySupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderIdentifier")


// MARK: - GET Doctor Details
extension HospitalDetailsVC {
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

// MARK: - HospitalModel
struct HospitalDetailsResponse: Codable {
    let status: Int?
    let message: String?
    let result: HospitalDetailsResult?
}

// MARK: - Result
struct HospitalDetailsResult: Codable {
    let hospitalName: String?
    let id: Int?
    let profilePicture, email, address, hospitalRegistration: String?
    let aboutHospital1, aboutHospital2, licenseFirst, licenseSecond: String?
    let likes: Int?
    let lat, longitude: String?
    let doctorsCount, specialtiesCount: Int?
    let insurances: [String]?
    let rating: Int?
    let reviews: [Review]?
    let isLike: Int?
    let insuranceFilesURL, profileBaseURL: String?
    let doctorBasicInfo: [DoctorBasicInfo]?

    enum CodingKeys: String, CodingKey {
        case hospitalName = "hospital_name"
        case id
        case profilePicture = "profile_picture"
        case email, address
        case hospitalRegistration = "hospital_registration"
        case aboutHospital1 = "about_hospital_1"
        case aboutHospital2 = "about_hospital_2"
        case licenseFirst = "license_first"
        case licenseSecond = "license_second"
        case likes, lat, longitude
        case doctorsCount = "doctors_count"
        case specialtiesCount = "specialties_count"
        case insurances, rating, reviews, isLike
        case insuranceFilesURL = "insurance_files_url"
        case profileBaseURL = "profile_base_url"
        case doctorBasicInfo
    }
}

// MARK: - DoctorBasicInfo
struct DoctorBasicInfo: Codable {
    let doctorID: Int?
    let doctorName, email, mobileNumber, gender: String?
    let doctorProfile: String?
    let likes, doctorExp: Int?
    let doctorDetailInfo: DoctorDetailInfo?
    let availableToday, isLike: Int?
    let ratings: Double?
    let reviews: [Review]?
    let slotArray: SlotArray1?
    let doctorSpecialities: [DoctorSpeciality]?
    let doctorQualifications: [DoctorQualification]?
    let doctorCommunicationServices: [DoctorCommunicationService]?
    
    enum CodingKeys: String, CodingKey {
        case doctorID = "doctor_id"
        case doctorName = "doctor_name"
        case email
        case mobileNumber = "mobile_number"
        case gender
        case doctorProfile = "doctor_profile"
        case likes
        case doctorExp = "doctor_exp"
        case doctorDetailInfo
        case availableToday = "available_today"
        case isLike, ratings, reviews, slotArray
        case doctorSpecialities = "doctor_specialities"
        case doctorQualifications = "doctor_qualifications"
        case doctorCommunicationServices = "doctor_communication_services"
    }
}

// MARK: - DoctorCommunicationService
struct DoctorCommunicationService: Codable {
    let id: String?
    let doctorID: Int?
    let commServiceType, commDurationType, commDuration, commDurationFee: String?

    enum CodingKeys: String, CodingKey {
        case id
        case doctorID = "doctor_id"
        case commServiceType = "comm_service_type"
        case commDurationType = "comm_duration_type"
        case commDuration = "comm_duration"
        case commDurationFee = "comm_duration_fee"
    }
}

// MARK: - DoctorDetailInfo
struct DoctorDetailInfo: Codable {
    let licenseFirst, licenseSecond, doctorExp, aboutUs: String?
    let aboutUs2, address: String?

    enum CodingKeys: String, CodingKey {
        case licenseFirst = "license_first"
        case licenseSecond = "license_second"
        case doctorExp = "doctor_exp"
        case aboutUs = "about_us"
        case aboutUs2 = "about_us_2"
        case address
    }
}
// MARK: - Review
struct Review: Codable {
    let ratingType, clientName, comments: String?
    let rating: Int?
    let clientPicture: String?
    let ratingDate: String?
    let from: Int?

    enum CodingKeys: String, CodingKey {
        case ratingType = "rating_type"
        case clientName = "client_name"
        case comments, rating
        case clientPicture = "client_picture"
        case ratingDate = "rating_date"
        case from
    }
}

struct Afternoon1: Codable {
    let id: Int?
    let time: String?
    let available: Int?
}

struct SlotArray1: Codable {
    let slots: [Slot1]?
}

// MARK: - Slot
struct Slot1: Codable {
    let slotType, dates: String?
    let morning, afternoon, evening: [Afternoon1]?

    enum CodingKeys: String, CodingKey {
        case slotType = "slot_type"
        case dates, morning, afternoon, evening
    }
}
