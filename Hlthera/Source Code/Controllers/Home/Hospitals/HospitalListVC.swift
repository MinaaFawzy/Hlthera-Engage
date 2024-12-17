//
//  HospitalListVC.swift
//  Hlthera
//
//  Created by Mina Fawzy on 24/08/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit

class HospitalListVC: UIViewController {
    
    //MARK: - OutLets
    @IBOutlet weak var hospitalTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    var hospitalList: [HospitalDetailModel] = []
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hospitalTableView.delegate = self
        hospitalTableView.dataSource = self
        hospitalTableView.register(UINib(nibName: HospitalListTVC.identifier, bundle: nil), forCellReuseIdentifier: HospitalListTVC.identifier)
    }
    
    
}

//MARK: - Actions
extension HospitalListVC {
    
    @IBAction func filterButton(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: FilterDoctorVC.getStoryboardID()) as? FilterDoctorVC else { return }
        vc.fiterResult = { [weak self] _, data in
            guard let self = self else { return }
            self.hospitalList = data
            self.hospitalTableView.reloadData()
        }
        vc.hasCameFrom = .hospitals
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        //TODO Search
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK: - Table Funcs
extension HospitalListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hospitalList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HospitalListTVC.identifier, for: indexPath) as! HospitalListTVC
        let obj = hospitalList[indexPath.row]
        cell.hospitalName.text = obj.hospital_name.localize
//        cell.hospitalRating.text = "0!!" //TODO Rate
        cell.hospitalLocation.text = obj.address.isEmpty ? ("Address not found".localize) : (obj.address)
        cell.hospitalImage.sd_setImage(with: .init(string: obj.profile_base_url + obj.profile_picture), placeholderImage: UIImage(named: "no_data_image"))
        cell.Specialties.text = obj.hospital_specialities.count > 1 ? "\(obj.hospital_specialities.count )" + " Specialities".localize : "\(obj.hospital_specialities.count )" + " Specialitie".localize
        cell.doctorsNum.text = obj.doctorBasicInfo?.count > 1 ? "\(obj.doctorBasicInfo?.count ?? 0) " + " Healers".localize : "\(obj.doctorBasicInfo?.count ?? 0)" + " Healer".localize
        if obj.isLike {
            cell.heartButton.isSelected = true
        }
        cell.callbackBookNow = { [weak self] in
            guard let self = self else { return }
//            guard let vc = UIStoryboard(name: Storyboards.kHospitals, bundle: nil).instantiateViewController(withIdentifier: HospitalProfileVC.getStoryboardID()) as? HospitalProfileVC else { return }
//            vc.searchResult = obj
//            UserData.shared.hospital_id = ""
//            self.navigationController?.pushViewController(vc, animated: true)
            guard let vc = UIStoryboard(name: Storyboards.kHospitals, bundle: nil).instantiateViewController(withIdentifier: MyHospitalProfileVC.getStoryboardID()) as? MyHospitalProfileVC else { return }
            print("hospital iiid :\(obj.id)")
            vc.id = Int(obj.id) ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.callbackHeartButton = { [weak self] value in
            guard let self = self else { return }
            self.favoriteApi(isLike: !value, id: Int.getInt(obj.id))
        }
        return cell
    }
    
    
}

//MARK: - heart Api
extension HospitalListVC {
    func favoriteApi(isLike: Bool, id: Int) {
        var params:[String : Any] = [:]
        
        var serviceUrl = ServiceName.doLike
        if !isLike{
            serviceUrl = ServiceName.doLike
            params = [ApiParameters.kLike:"1",
                      ApiParameters.kType:"hospital",
                      ApiParameters.kTargetId:String.getString(id)]
        }
        else {
            serviceUrl = ServiceName.doUnlike
            params = [ApiParameters.kUnlike:"1",
                      ApiParameters.kType:"hospital",
                      ApiParameters.kTargetId:String.getString(id)]
        }
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:serviceUrl,
                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: true)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
//                    self?.getSearchListing()
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    
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

@available(iOS 15.0, *)
extension HospitalListVC {
    func getSearchListing() {
        CommonUtils.showHudWithNoInteraction(show: true)
        var params: [String: Any] = [:]
        let serviceUrl = ServiceName.hospitalList
        params = [ApiParameters.kIsQuickSearch:"0"]
        TANetworkManager.sharedInstance.requestApi(
            withServiceName: serviceUrl,
            requestMethod: .POST,
            requestParameters: params, withProgressHUD: false
        ) { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let result = kSharedInstance.getDictionaryArray(withDictionary: dictResult["result"])
                    self.hospitalList = result.map { HospitalDetailModel(data: $0) }
                    self.hospitalTableView.reloadData()
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
