//
//  HomeVC.swift
//  Hlthera
//
//  Created by Prashant on 14/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
//import JBTabBarAnimation
import GoogleMaps
import GooglePlaces
import ScalingCarousel
import SDWebImage
//import SwiftyJSON

class HomeVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var buttonLocation: UIButton!
    @IBOutlet weak private var viewNavigation: UIView!
    @IBOutlet weak private var imageProfile: UIImageView!
    @IBOutlet weak private var collectionViewSlider: ScalingCarouselView!
    @IBOutlet weak private var labelName: UILabel!
    @IBOutlet weak private var collectionViewCategories: UICollectionView!
    @IBOutlet weak private var collectionViewDiscoverDoctors: UICollectionView!
    @IBOutlet weak private var collectionViewHospitals: UICollectionView!
    @IBOutlet weak private var collectionViewTopDoctors: UICollectionView!
    @IBOutlet weak private var viewMap: GMSMapView!
    @IBOutlet weak private var buttonCart: HltheraCartButton!
    @IBOutlet private var viewAllButton: [UIButton]!
    
    @IBOutlet weak var feelingUnwellLabel: UILabel!
    // MARK: - stored properties
    var sliderTopHomeBanners: [BannerHomeItem]? = []
    var latitude: Double = 19.0760
    var longitude: Double = 72.8777
    var locationManager: CLLocationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    var hospitals: [HospitalDetailModel] = []
    var doctors: [DoctorDetailsModel] = []
    var categories: [FeaturedSpecialty] = []
    //var categories: [FeaturedSpecialty]? = []
    var categoriesImages = [
        UIImage(named: "unwell1") ?? UIImage(),
        UIImage(named: "unwell2") ?? UIImage(),
        UIImage(named: "unwell3") ?? UIImage(),
        UIImage(named: "unwell4") ?? UIImage(),
        UIImage(named: "unwell5") ?? UIImage(),
        UIImage(named: "unwell1") ?? UIImage(),
        UIImage(named: "unwell2") ?? UIImage(),
        UIImage(named: "unwell3") ?? UIImage()
    ]
    //var categories = ["Charity Donation","COVID-19 Testing","Pharmacy","Charity Donation","COVID-19 Testing"]
    //    var categoriesImages = [
    //        UIImage(named: "charity_donation") ?? UIImage()
    //        ,UIImage(named: "covid_testing") ?? UIImage()
    //        ,UIImage(named: "pharmacy") ?? UIImage()
    //        ,UIImage(named: "charity_donation") ?? UIImage()
    //        ,UIImage(named: "covid_testing") ?? UIImage()
    //       ]
    //
    //    var categories = ["Stress & Anxiety"
    //                      ,"Headache",  "Sore Throat","Cough",
    //                      "Cough",
    //                      "Cough"]
    //    var categoriesImages = [
    //        UIImage(named: "stress") ?? UIImage()
    //        ,UIImage(named: "Headache") ?? UIImage()
    //        ,UIImage(named: "Sore") ?? UIImage()
    //        ,UIImage(named: "Cough") ?? UIImage()
    //        ,UIImage(named: "Cough") ?? UIImage()
    //        ,UIImage(named: "Cough") ?? UIImage()
    //       ]
    //
    var obj: JBTabBarController?
    var mydelegate: ShareImageDelegate?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewTopDoctors.registerNib(for: TopHealerCell.self)
        collectionViewDiscoverDoctors.registerNib(for: DiscoverHealerCVC.self)
        labelName.font = .CorbenBold(ofSize: 17)
        viewAllButton.forEach { $0.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 13) }
        
        if self.tabBarController?.isKind(of: JBTabBarController.self) ?? false {
            let vc = self.tabBarController as! JBTabBarController
            self.mydelegate = vc as ShareImageDelegate
        }
        
        collectionViewSlider.translatesAutoresizingMaskIntoConstraints = false
        
        self.buttonLocation.setTitle(String.getString(kSharedUserDefaults.getAppLocation().name.localize), for: .normal)
        self.imageProfile.downlodeImage(serviceurl: String.getString(UserData.shared.profilePic), placeHolder: UIImage(named: "no_data_image"))
        labelName.text = (UserData.shared.firstName ?? "") + " " + (UserData.shared.lastName ?? "" )
        labelName.text = UserData.shared.firstName?.isEmpty ?? true ? UserData.shared.fullName : labelName.text
        //self.imageProfile.image ?? UIImage(named: "placeholder")!
        self.downlodeImage(serviceurl: String.getString(UserData.shared.profilePic), placeHolder: UIImage(named: "no_data_image"), completion: { image in
            self.mydelegate?.shareImage(image)
        })
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        viewNavigation.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        viewNavigation.layer.cornerRadius = 15
        DispatchQueue.init(label: "location", qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.locationManagerInitialSetup(locationManager: self.locationManager)
        }
        let camera = GMSCameraPosition.camera(withLatitude: kSharedUserDefaults.getAppLocation().lat,
                                              longitude: kSharedUserDefaults.getAppLocation().long,
                                              zoom: 15)
        viewMap.camera = camera
        viewMap.settings.myLocationButton = false
        viewMap.isMyLocationEnabled = true
        //viewMap.isHidden = true
        viewMap.isUserInteractionEnabled = true
        viewMap.settings.zoomGestures = true
        viewMap.delegate = self
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = "Default Location".localize
        marker.icon = #imageLiteral(resourceName: "location_map")
        marker.map = viewMap
        
        placesClient = GMSPlacesClient.shared()
        viewMap.clipsToBounds = true
        viewMap.cornerRadius = 10
        
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            let width = self.collectionViewSlider.frame.width - 50
            self.collectionViewSlider.scrollRectToVisible(CGRect(x: CGFloat(1) * width , y: 0, width: width, height: self.collectionViewSlider.frame.height), animated: true)
        })
        //refreshControl = UIRefreshControl()
        //refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        //scrollView.refreshControl = refreshControl
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named: "5")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localize)
        refreshControl.addTarget(self,
                                 action: #selector(refresh(_:)),
                                 for: .valueChanged)
        scrollView.refreshControl = refreshControl
        homeTopSliderBanners()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .darkContent
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateData(lat: Double.getDouble(kSharedUserDefaults.getAppLocation().lat), long: Double.getDouble(kSharedUserDefaults.getAppLocation().long), type: .doctors)
        updateData(lat: Double.getDouble(kSharedUserDefaults.getAppLocation().lat), long: Double.getDouble(kSharedUserDefaults.getAppLocation().long), type: .hospitals)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.refreshControl?.didMoveToSuperview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupStatusBar()
    }
    
    func returnPostionOfMapView(mapView: GMSMapView) {
        //Returns New Position of Mapview
        let geocoder = GMSGeocoder()
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let position = CLLocationCoordinate2DMake(latitude, longitude)
        let marker = GMSMarker()
        marker.position = position
        marker.title = "Selected Location".localize
        marker.snippet = "Drag map to change location".localize
        //marker.icon = #imageLiteral(resourceName: "Group 1")
        marker.isDraggable = false
        marker.map = viewMap
        geocoder.reverseGeocodeCoordinate(position) { response , error in
            if error != nil {
                print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            }else {
                _ = response?.results()?.first
                // self.currentLocation = String(result?.lines?[0] ?? "")
                self.latitude = position.latitude
                self.longitude = position.longitude
            }
        }
        
    }
    
    func updateMarkers() {
        hospitals.forEach {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: Double.getDouble($0.lat), longitude: Double.getDouble($0.long))
            marker.title = "\($0.name)"
            marker.icon = #imageLiteral(resourceName: "address")
            marker.isDraggable = false
            DispatchQueue.main.async { [weak self] in// Setting marker on mapview in main thread.
                guard let self = self else { return }
                marker.map = self.viewMap
            }
        }
    }
}

// MARK: - Actions
@available(iOS 15.0, *)
@available(iOS 15.0, *)
extension HomeVC {
    @IBAction private func buttonSearchTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: HomeSearchVC.getStoryboardID()) as? HomeSearchVC else { return }
        vc.hasComrFrom = .home
        vc.callback = { [weak self] index, doctor, hospital, pharmacy in
            guard let self = self else { return }
            switch index {
            case 0:
                guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: ViewDoctorProfileVC.getStoryboardID()) as? ViewDoctorProfileVC else { return }
                vc.searchResult = doctor
                UserData.shared.hospital_id = ""
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                guard let vc = UIStoryboard(name: Storyboards.kHospitals, bundle: nil).instantiateViewController(withIdentifier: HospitalProfileVC.getStoryboardID()) as? HospitalProfileVC else { return }
                vc.searchResult = hospital
                UserData.shared.hospital_id = ""
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                globalApis.getProductDetails(id:pharmacy?.id ?? "") { [weak self] url, data in
                    guard let self = self else { return }
                    guard let vc = UIStoryboard(name: "Pharmacy", bundle: nil).instantiateViewController(withIdentifier: ProductDetailsVC.getStoryboardID()) as? ProductDetailsVC else { return }
                    vc.data = data
                    vc.imageUrl = url
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            default: break
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func buttonCartTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Pharmacy", bundle: nil).instantiateViewController(withIdentifier: PharmacyCartVC.getStoryboardID()) as? PharmacyCartVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func buttonCategoriesViewAll(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: FeelingUnwellVC.getStoryboardID()) as? FeelingUnwellVC else { return }
        //vc.categories = self.categories
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func buttonViewAllDiscoverDoctors(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: SearchDoctorVC.getStoryboardID()) as? SearchDoctorVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func buttonViewAllHospitalsTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHospitals, bundle: nil).instantiateViewController(withIdentifier: HospitalListVC.getStoryboardID()) as? HospitalListVC else { return }
        vc.hospitalList = hospitals
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func buttonViewAllTopDoctorsTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: SearchDoctorVC.getStoryboardID()) as? SearchDoctorVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func buttonMyLocationTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: MyLocationVC.getStoryboardID()) as? MyLocationVC else { return }
        vc.hasCameFrom = .home
        vc.callback = { location in
            kSharedUserDefaults.setAppLocation(location: location)
            self.updateData(lat: Double.getDouble(kSharedUserDefaults.getAppLocation().lat), long: Double.getDouble(kSharedUserDefaults.getAppLocation().long), type: .doctors)
            self.updateData(lat: Double.getDouble(kSharedUserDefaults.getAppLocation().long), long: Double.getDouble(kSharedUserDefaults.getAppLocation().long), type: .hospitals)
            self.buttonLocation.setTitle(kSharedUserDefaults.getAppLocation().name.isEmpty ? ("Select Location".localize) : (kSharedUserDefaults.getAppLocation().name).localize, for: .normal)
            let position = CLLocationCoordinate2D(latitude: kSharedUserDefaults.getAppLocation().lat, longitude: kSharedUserDefaults.getAppLocation().long)
            let camera = GMSCameraPosition(target: position, zoom: 15, bearing: 0, viewingAngle: 0)
            let marker = GMSMarker(position: position)
            marker.title = "Selected Location".localize
            marker.icon = #imageLiteral(resourceName: "location_map")
            if self.viewMap.isHidden {
                self.viewMap.isHidden = false
                self.viewMap.camera = camera
            } else {
                self.viewMap.animate(to: camera)
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        updateData(lat: Double.getDouble(kSharedUserDefaults.getAppLocation().lat), long: Double.getDouble(kSharedUserDefaults.getAppLocation().long), type: .doctors)
        updateData(lat: Double.getDouble(kSharedUserDefaults.getAppLocation().lat), long: Double.getDouble(kSharedUserDefaults.getAppLocation().long), type: .hospitals)
    }
}
@available(iOS 15.0, *)
@available(iOS 15.0, *)

// MARK: - UICollectionView Delegate & DataSource
@available(iOS 15.0, *)
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 7{
            collectionViewSlider.didScroll()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewSlider {
            return self.sliderTopHomeBanners!.count
        } else if collectionView == collectionViewCategories {
            return categories.count
        } else if collectionView == collectionViewDiscoverDoctors {
            return 2
        } else if collectionView == collectionViewHospitals {
            return hospitals.count
        } else if collectionView == collectionViewTopDoctors {
            return doctors.count
        } else {
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewSlider {
            let mycell = collectionView.dequeueReusableCell(withReuseIdentifier: "CodeCell", for: indexPath) as! CodeCell
            
            if let scalingCell = mycell as? ScalingCarouselCell {
                scalingCell.mainView.backgroundColor = .blue
            }
            
            let bannerItem = sliderTopHomeBanners![indexPath.row]
            //mycell.labelDoctorName.text = bannerItem.name
            //mycell.labelClinicName.text = bannerItem.ad_purpose
            //mycell.labelBannerHeading.text = bannerItem.created_at
            //mycell.labelDoctorSpecility.text = bannerItem.updated_at
            //mycell.image.downlodeImage(serviceurl: String.getString(UserData.shared.profilePic), placeHolder: #imageLiteral(resourceName: "placeholder"))
            mycell.image.downlodeImage(serviceurl: bannerItem.image!, placeHolder: #imageLiteral(resourceName: "placeholder_img"))
            DispatchQueue.main.async {
                mycell.setNeedsLayout()
                mycell.layoutIfNeeded()
            }
            return mycell
        } else if collectionView == collectionViewCategories {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVC", for: indexPath) as! HomeCVC
            cell.categoryImage.sd_setImage(with: URL(string: categories[indexPath.row].imagePath ?? ""))
            cell.categoryName.text = categories[indexPath.row].name?.localize
            //cell.categoryImage.downlodeImage(serviceurl:  self.categories![indexPath.row].image!, placeHolder: UIImage(named: "placeholder_img"))
            //cell.categoryImage.image = UIImage(named: categoriesImages[indexPath.row])
            //cell.categoryImage.downlodeImage(serviceurl: self.categories![indexPath.row].imagePath!, placeHolder: #imageLiteral(resourceName: "placeholder_img"))
            //cell.categoryImage.clipsToBounds = true
            //cell.categoryImage.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            //cell.categoryImage.layer.cornerRadius = 15
            //cell.categoryName.text = self.categories![indexPath.row].name
            return cell
        }
        else if collectionView == collectionViewDiscoverDoctors{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverHealerCVC", for: indexPath) as! DiscoverHealerCVC
            if indexPath.row == 0 {
                cell.discoverImage.image = UIImage(named: "nearby_healers")
                cell.discoverLable.text = "Nearby Healers".localize
            } else {
                cell.discoverImage.image = UIImage(named: "online_healers")
                cell.discoverLable.text = "Online Healers".localize
            }
            return cell
        } else if collectionView == collectionViewHospitals {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVC", for: indexPath) as! HomeCVC
            //cell.imageHospital.downlodeImage(serviceurl: String.getString(self.hospitals[indexPath.row].profile_base_url + self.hospitals[indexPath.row].profile_picture), placeHolder: UIImage(named: "placeholder_img"))
            cell.imageHospital.sd_setImage(with: .init(string: String.getString(self.hospitals[indexPath.row].profile_base_url + self.hospitals[indexPath.row].profile_picture)), placeholderImage: UIImage(named: "no_data_image"))
            cell.imageHospital.clipsToBounds = true
            cell.imageHospital.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            cell.imageHospital.layer.cornerRadius = 15
            cell.labelHospitalName.text = hospitals[indexPath.row].hospital_name
            cell.labelHospitalAddress.text = hospitals[indexPath.row].address.isEmpty ? ("Address not found".localize) : (hospitals[indexPath.row].address)
            return cell
        }
        else if collectionView == collectionViewTopDoctors{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopHealerCell", for: indexPath) as! TopHealerCell
            let obj = doctors[indexPath.row]
            //cell.imageTopDoctor.downlodeImage(serviceurl: obj.doctor_profile, placeHolder: UIImage(named:"placeholder"))
            cell.imageTopDoctor.sd_setImage(with: .init(string: obj.doctor_profile), placeholderImage: UIImage(named: "no_data_image"))
            cell.labelRating.text = String(format: "%.1f", obj.ratings )
            let date = Date()
            let dateFormattor = DateFormatter()
            dateFormattor.dateFormat = "yyyy'-'MM'-'dd"
            _ = obj.slots.filter {
                date.dateString(ofStyle: .long) == dateFormattor.date(from:$0.dates)?.dateString(ofStyle: .long)
            }
            //cell.labelFee.text = "Starting from $\(getMinimumPrice(from: obj))"
            //cell.labelAvailability.text =  res.isEmpty ? ("Not Available Today".localize) : ("Available Today".localize)
            cell.labelTopDoctorName.text = obj.doctor_name.capitalized
            let experience = Int.getInt(obj.doctor_exp)
            cell.labelTopDoctorExperience.text = experience < 2 ? ("\(experience)" + " Year".localize) : ("\(experience)" + " Years".localize)
            //cell.labelTopDoctorSpecialization.text = obj.doctor_specialities[0].full_name
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVC", for: indexPath) as! HomeCVC
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewSlider {
            if sliderTopHomeBanners?[indexPath.row].adPurpose == "Doctor" {
                guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: ViewDoctorProfileVC.getStoryboardID()) as? ViewDoctorProfileVC else { return }
                vc.hasCameFrom = .Banners
                vc.doctorID = sliderTopHomeBanners?[indexPath.row].serviceID ?? 0
//                UserData.shared.hospital_id = ""
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                guard let vc = UIStoryboard(name: Storyboards.kHospitals, bundle: nil).instantiateViewController(withIdentifier: MyHospitalProfileVC.getStoryboardID()) as? MyHospitalProfileVC else { return }
                vc.id = sliderTopHomeBanners?[indexPath.row].serviceID ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if collectionView == collectionViewCategories {
            guard let nextVc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(identifier: "SearchDoctorListingVC") as? SearchDoctorListingVC else { return }
            nextVc.hasCameFrom = .home
            nextVc.passedFeatSpecialist = categories[safe: indexPath.row]
            self.navigationController?.pushViewController(nextVc, animated: true)
        }
        if collectionView == collectionViewHospitals {
            //            let hospitalDetailsVC = HospitalDetailsVC.init(nibName: "HospitalDetailsVC", bundle: nil)
            //            hospitalDetailsVC.id = Int(hospitals[indexPath.row].id) ?? 0
            guard let vc = UIStoryboard(name: Storyboards.kHospitals, bundle: nil).instantiateViewController(withIdentifier: MyHospitalProfileVC.getStoryboardID()) as? MyHospitalProfileVC else { return }
            vc.id = Int(hospitals[indexPath.row].id) ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if collectionView == collectionViewTopDoctors {
            guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: ViewDoctorProfileVC.getStoryboardID()) as? ViewDoctorProfileVC else { return }
            vc.searchResult = doctors[indexPath.row]
            UserData.shared.hospital_id = ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if collectionView == collectionViewDiscoverDoctors {
            if indexPath.row == 0 {
                guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: SearchDoctorVC.getStoryboardID()) as? SearchDoctorVC else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: SearchDoctorListingVC.getStoryboardID()) as? SearchDoctorListingVC else { return }
                vc.isQuickSearch = false
                vc.pageTitle = "Find doctor near you?".localize
                vc.lat = kSharedUserDefaults.getAppLocation().lat
                vc.long = kSharedUserDefaults.getAppLocation().long
                vc.hasCameFrom = .doctors
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewSlider {
            return CGSize(width: collectionView.frame.width-50, height:collectionView.frame.height)
        } else if collectionView == collectionViewCategories {
            return CGSize(width: 85, height: 90)
        } else if collectionView == collectionViewDiscoverDoctors {
            return CGSize(width: UIScreen.main.bounds.width*0.45 , height: 120)
        } else if collectionView == collectionViewHospitals {
            return CGSize(width: 195, height: 190)
        } else {
            return CGSize(width: 210, height: 150)
        }
    }
}

extension HomeVC {
    func homeTopSliderBanners() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params: [String: Any] = [:]
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.sliderTopBanners,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { [self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    //let banners =  (dictResult as NSDictionary).value(forKeyPath: "data.banners")
                    //var jsonObj = JSON(banners)
                    //jsonObj.arrayValue.forEach({ json in
                    //let bannerItem =  BannerHomeItem()
                    //bannerItem.created_at = json["created_at"].stringValue
                    //bannerItem.ad_purpose = json["ad_purpose"].stringValue
                    //bannerItem.status = json["status"].intValue.toString()
                    //bannerItem.name = json["name"].stringValue
                    //bannerItem.id = json["id"].intValue.toString()
                    //bannerItem.ad_from = json["ad_from"].stringValue
                    //bannerItem.ad_to = json["ad_to"].stringValue
                    //bannerItem.service_id = json["service_id"].intValue.toString()
                    //bannerItem.updated_at = json["updated_at"].stringValue
                    //bannerItem.image = json["image"].stringValue
                    //self.sliderTopHomeBanners.append(bannerItem)
                    //})
                    
                    var model:BannerHomeModel?
                    let convertDicToJsonString = try? JSONSerialization.data(withJSONObject: dictResult, options: [.prettyPrinted])
                    let jsonString = String(data: convertDicToJsonString!, encoding: .utf8)!
                    let jsonStringToData = Data(jsonString.utf8)
                    let decoder = JSONDecoder()
                    do {
                        model = try decoder.decode(BannerHomeModel.self, from: jsonStringToData)
                    } catch {
                        print(error.localizedDescription)
                    }
                    self.sliderTopHomeBanners = (model?.data?.banners)
                    self.categories = model?.data?.featuredSpecialties ?? []
                    
                    self.collectionViewSlider.reloadData()
                    self.collectionViewCategories.reloadData()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
}

// MARK: - GMS View Delegate
extension HomeVC: GMSMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if kSharedUserDefaults.getAppLocation().lat == 0.0 && kSharedUserDefaults.getAppLocation().long == 0.0{
            let location:CLLocation = locations.last!
            
            DispatchQueue.main.async {
                let geocoder = GMSGeocoder()
                let position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let camera = GMSCameraPosition(target: position, zoom: 15, bearing: 0, viewingAngle: 0)
                let marker = GMSMarker(position: position)
                marker.title = "Selected Location".localize
                marker.icon = #imageLiteral(resourceName: "location_map")
                if self.viewMap.isHidden {
                    self.viewMap.isHidden = false
                    self.viewMap.camera = camera
                } else {
                    self.viewMap.animate(to: camera)
                }
                geocoder.reverseGeocodeCoordinate(position) { response , error in
                    if error != nil {
                        print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
                    }else {
                        let result = response?.results()?.first
                        // " \) > \) \(result?.locality == nil ? "" : " > ") "
                        //                "\(String.getString(result?.subLocality))\(result?.subLocality == nil ? "" : ", ") \(String.getString(result?.thoroughfare))"
                        //
                        
                        
                        //String(result?.lines?[0] ?? "")
                        kSharedUserDefaults.setAppLocation(location: SavedLocationsModel(lat: position.latitude, long: position.longitude, name: "\(String.getString(result?.locality)), \(String.getString(result?.country))"))
                        self.buttonLocation.setTitle("\(String.getString(result?.locality).localize), \(String.getString(result?.country).localize)", for: .normal)
                    }
                }
                //self.markers = []
                //self.buttonSearchMarina.tag = 1
                //self.searchMarinaApi(lat: self.latitude, long: self.longitude, listing: false)
                marker.map = self.viewMap
            }
            
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print(mapView.center)
        //mapView.clear()
        //returnPostionOfMapView(mapView: mapView)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        //mapView.clear()
        //returnPostionOfMapView(mapView: mapView)
    }
}

extension HomeVC {
    func updateData(lat: Double, long: Double, type: HasCameFrom) {
        //CommonUtils.showHudWithNoInteraction(show: false)
        var params: [String: Any] = [:]
        var serviceUrl = ServiceName.searchDoctor
        switch type {
        case .doctors:
            serviceUrl = ServiceName.doctorList
            params = [
                ApiParameters.kLatitude:String(lat),
                ApiParameters.kLongitude:String(long)
            ]
        case .hospitals:
            params = [
                ApiParameters.kLatitude: String(lat),
                ApiParameters.kLongitude: String(long)
            ]
            serviceUrl = ServiceName.hospitalList
        default: break
        }
        
        TANetworkManager.sharedInstance.requestApi(
            withServiceName: serviceUrl,
            requestMethod: .POST,
            requestParameters: params,
            withProgressHUD: false
        ) { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let result = kSharedInstance.getDictionaryArray(withDictionary: dictResult["result"])
                    switch type{
                    case .doctors:
                        self.doctors = result.map {
                            DoctorDetailsModel(data: $0)
                        }
                        self.collectionViewTopDoctors.reloadData()
                        break
                    case .hospitals:
                        self.hospitals = result.map{
                            HospitalDetailModel(data: $0)
                        }
                        self.updateMarkers()
                        //self.buttonCart.refreshCartCount()
                        self.collectionViewHospitals.reloadData()
                        break
                    default: break
                    }
                    DispatchQueue.main.async {
                        self.scrollView.refreshControl?.endRefreshing()
                    }
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                    break;
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
}

// MARK: - Code Cell
class CodeCell: ScalingCarouselCell {
    
    @IBOutlet weak var labelBannerHeading: UILabel!
    @IBOutlet weak var labelDoctorName: UILabel!
    @IBOutlet weak var labelDoctorSpecility: UILabel!
    @IBOutlet weak var labelClinicName: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

var profileImage = UIImage(named: "no_data_image")

extension UICollectionView {
    func registerNib(for cellClass: UICollectionViewCell.Type) {
        let nibName = String(describing: cellClass)
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: nibName)
    }
}
