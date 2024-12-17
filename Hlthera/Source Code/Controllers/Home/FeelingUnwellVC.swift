//
//  FeelingUnwellVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 30/04/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class FeelingUnwellVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    
    // MARK: - Stored Properties
    var categories: [FeaturedSpecialty] = []
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
    //var categoriesImages = [
    //        UIImage(named: "stress") ?? UIImage()
    //            ,UIImage(named: "Headache") ?? UIImage()
    //            ,UIImage(named: "Sore") ?? UIImage()
    //            ,UIImage(named: "Cough") ?? UIImage()
    //            ,UIImage(named: "Cough") ?? UIImage()
    //            ,UIImage(named: "Cough") ?? UIImage()
    //        ,UIImage(named: "Cough") ?? UIImage()
    //        ,UIImage(named: "Cough") ?? UIImage()
    //    ]
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        lblTitle.font = .corbenRegular(ofSize: 15)
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        homeTopSliderBanners()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: - Actions
    @IBAction private func buttonBackTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UICollectionView Delegate & DataSource
extension FeelingUnwellVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if #available(iOS 15.0, *) {
            guard let nextVc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(identifier: "SearchDoctorListingVC") as? SearchDoctorListingVC else { return }
            nextVc.hasCameFrom = .feelingUnwell
            nextVc.passedFeatSpecialist = categories[indexPath.row]
            navigationController?.pushViewController(nextVc, animated: true)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView.numberOfRow(numberofRow: categories.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchDoctorCVC", for: indexPath) as! SearchDoctorCVC
        cell.clipsToBounds = false
        cell.layer.masksToBounds = false
        cell.labelName.text = categories[indexPath.row].name?.localize
        cell.imageLogo.downlodeImage(
            serviceurl: categories[indexPath.row].imagePath ?? "",
            placeHolder: #imageLiteral(resourceName: "placeholder_img")
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.10, height: collectionView.frame.width/2.10)
    }
}

extension FeelingUnwellVC {
    func homeTopSliderBanners() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params: [String: Any] = [:]
        TANetworkManager.sharedInstance.requestApi(
            withServiceName: ServiceName.sliderTopBanners,
            requestMethod: .GET,
            requestParameters: params,
            withProgressHUD: false
        ) {
            [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    var model: BannerHomeModel?
                    let convertDicToJsonString = try? JSONSerialization.data(withJSONObject: dictResult, options: [.prettyPrinted])
                    let jsonString = String(data: convertDicToJsonString!, encoding: .utf8)!
                    let jsonStringToData = Data(jsonString.utf8)
                    let decoder = JSONDecoder()
                    do {
                        model = try decoder.decode(BannerHomeModel.self, from: jsonStringToData)
                    } catch {
                        print(error.localizedDescription)
                    }
                    //self.sliderTopHomeBanners = (model?.data?.banners)
                    self.categories = model?.data?.featuredSpecialties ?? []
                    
                    //self.collectionViewSlider.reloadData()
                    self.collectionView.reloadData()
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
