//
//  HospitalProfileVC.swift
//  Hlthera
//
//  Created by Prashant on 06/01/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class HospitalProfileVC: UIViewController, pageViewControllerProtocal, UIScrollViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak private var scroll: UIScrollView!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var collectionViewNavigation: UICollectionView!
    //@IBOutlet weak private var constraintContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak private var imageHospital: UIImageView!
    @IBOutlet weak private var buttonHeart: UIButton!
    @IBOutlet weak private var lblTitle: UILabel!
    
    // MARK: - stored properties
    var searchResult: HospitalDetailModel?
    var navigationTabsNames: [String] = [
        "Laboratory",
        "Ultrasound",
        "Consultation",
        "Diabetic care"]
    var containerViewController: PageVIewController?
    var selectedTab = 0
    var initialOffSet: CGFloat?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.delegate = self
//        lblTitle.font = .corbenRegular(ofSize: 15)
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        //setStatusBar(color: #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1))
        let imageUrl = String.getString(searchResult?.profile_picture).isEmpty ? (String.getString(searchResult?.hospital_profile)):(String.getString(searchResult?.profile_picture))
        self.imageHospital.downlodeImage(serviceurl: String.getString(searchResult?.profile_base_url) + imageUrl, placeHolder: UIImage(named: "placeholder"))
        // cell.imageHospital.downlodeImage(serviceurl: String.getString(self.hospitals[indexPath.row].profile_base_url + self.hospitals[indexPath.row].profile_picture), placeHolder: UIImage(named: "placeholder"))
        self.imageHospital.setGradientBackground3()
        if searchResult?.isLike ?? false {
            buttonHeart.isSelected = true
        } else {
            buttonHeart.isSelected = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initialOffSet = self.collectionViewNavigation.frame.origin.y
        containerViewController?.changeViewController(index: 0, direction: .forward)
        selectedTab = 0
        collectionViewNavigation.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segue.identifier == "pageVC" {
        //containerViewController = segue.destination as? PageVIewController
        //}
        if let vc = segue.destination as? PageVIewController,
           segue.identifier == "doctorPageVC" {
            containerViewController = vc
            vc.delegate = self
            vc.hospitalsListData = self.searchResult
            vc.hasCameFrom = .hospitalProfile
            vc.mydelegate = self
            segue.destination.view.translatesAutoresizingMaskIntoConstraints = false
            //segue.destinationViewController.view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func getSelectedPageIndex(with value: Int) {
        print(value)
        selectedTab = value
        if value == 1 {
            print(value)
            selectedTab = value
        } else {
            print(value)
            selectedTab = value
            //1300
            //self.constraintContainerViewHeight.constant = CGFloat(height)
        }
        self.collectionViewNavigation.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("-------  \(scroll.contentOffset.y)  ******* \(collectionViewNavigation.bounds.maxY)")
        //        collectionViewNavigation.transform = CGAffineTransform(translationX: 0, y: max(0, scroll.contentOffset.y - collectionViewNavigation.bounds.minY))
        
    }
}

// MARK: - Actions
extension HospitalProfileVC {
    @IBAction private func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func buttonHeartTapped(_ sender: UIButton) {
        let id = String.getString(searchResult?.hospital_id).isEmpty ? (searchResult?.id) : (searchResult?.hospital_id)
        favoriteApi(isLike: buttonHeart.isSelected ? true : false, type: .hospitals, id: Int.getInt(id))
    }
    
    @IBAction private func buttonShareTapped(_ sender: Any) {
        let textToShare = kAppName
        if let myWebsite = NSURL(string: String.getString(searchResult?.insurance_files_url)) {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction private func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension HospitalProfileVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return navigationTabsNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewDoctorNavigationCVC", for: indexPath) as! ViewDoctorNavigationCVC
        cell.labelTabName.text = navigationTabsNames[indexPath.row].localize
        if indexPath.row == selectedTab {
            cell.viewActive.isHidden = false
            cell.labelTabName.textColor = #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1)
            cell.labelTabName.font = UIFont(name: "SFProDisplay-Bold", size: 15)
        } else {
            cell.viewActive.isHidden = true
            cell.labelTabName.textColor = #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1)
            cell.labelTabName.font = UIFont(name: "SFProDisplay-Medium", size: 15)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewDoctorNavigationCVC", for: indexPath) as? ViewDoctorNavigationCVC else { return }
        selectedTab = indexPath.row
        collectionViewNavigation.reloadData()
    }
}

extension HospitalProfileVC {
    func favoriteApi(isLike: Bool, type: HasCameFrom, id: Int) {
        var params: [String: Any] = [:]
        
        var serviceUrl = ServiceName.doLike
        if !isLike{
            serviceUrl = ServiceName.doLike
            params = [ApiParameters.kLike:"1",
                      ApiParameters.kType:type == HasCameFrom.doctors ? "doctor" : "hospital",
                      ApiParameters.kTargetId:String.getString(id)]
        } else {
            serviceUrl = ServiceName.doUnlike
            params = [ApiParameters.kUnlike: "1",
                      ApiParameters.kType: type == HasCameFrom.doctors ? "doctor" : "hospital",
                      ApiParameters.kTargetId: String.getString(id)]
        }
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:serviceUrl,
                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: true)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    //if Int.getInt(dictResult["status"]) != 0{
                    self?.buttonHeart.isSelected = !isLike
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    //  }
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
