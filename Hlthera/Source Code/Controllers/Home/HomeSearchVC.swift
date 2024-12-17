//
//  HomeSearchVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 17/04/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class HomeSearchVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var buttonBack: UIButton!
    @IBOutlet weak private var lblTitle: UILabel!
    //@IBOutlet weak var horizontalSpace: NSLayoutConstraint!
    
    // MARK: - Stored properties
    var sections: [String] = ["Doctors", "Hospitals", "Pharmacy"]
    var doctors: [DoctorDetailsModel] = []
    var pharmacies: [PharmacyProductModel] = []
    var hospitals: [HospitalDetailModel] = []
    var searchResults: [String] = []
    var hasComrFrom: HasCameFrom = .none
    var callback: ((Int, DoctorDetailsModel?, HospitalDetailModel?, PharmacyProductModel?) -> ())?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        if hasComrFrom == .home {
            buttonBack.isHidden = false
            //horizontalSpace.constant = 15
        } else {
            buttonBack.isHidden = true
            //horizontalSpace.constant = -25
        }
//        lblTitle.font = .corbenRegular(ofSize: 15)
        
        tableView.register(UINib(nibName: PharmacyHomeSearchTVC.identifier, bundle: nil), forCellReuseIdentifier: PharmacyHomeSearchTVC.identifier)
        tableView.tableFooterView = UIView()
        searchBar.delegate = self
        let searchField = self.searchBar.searchTextField
        searchField.addDoneOnKeyboardWithTarget(self, action: #selector(self.doneAction(_:)), shouldShowPlaceholder: false)
        if let clearButton = searchField.value(forKey: "_clearButton") as? UIButton{
            clearButton.addTarget(self, action: #selector(buttonCrossTapped(_:)), for: .touchUpInside)
        }
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    func setupSearchBar() {
        let searchView = self.searchBar
        searchView?.backgroundImage = UIImage()
        let searchField = self.searchBar.searchTextField
        searchField.backgroundColor = UIColor().hexStringToUIColor(hex: "#F5F7F9")
        searchField.textColor = UIColor().hexStringToUIColor(hex: "#212529")
        searchField.attributedPlaceholder = NSAttributedString(string: searchField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "#8794AA")])
        if let leftView = searchField.leftView as? UIImageView {
            leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
            leftView.tintColor = UIColor(hexString: "#8794AA")
        }
    }
}

// MARK: - Actions
extension HomeSearchVC {
    @objc private func doneAction(_ sender : UITextField!) {
        self.view.endEditing(true)
    }
    
    @IBAction private func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func buttonCancelTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableView Delegate & DataSource
extension HomeSearchVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].localize
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return doctors.count
        case 1:
            return hospitals.count
        case 2:
            return pharmacies.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PharmacyHomeSearchTVC.identifier,for: indexPath) as! PharmacyHomeSearchTVC
        switch indexPath.section{
        case 0:
            let obj = doctors[indexPath.row]
            cell.labelProductName.text = obj.doctor_name
            cell.imageProduct.downlodeImage(serviceurl: obj.doctor_profile, placeHolder: UIImage(named: "placeholder"))
        case 1:
            let obj = hospitals[indexPath.row]
            cell.labelProductName.text = obj.hospital_name
            cell.imageProduct.downlodeImage(serviceurl: obj.profile_base_url + obj.hospital_profile, placeHolder: UIImage(named: "placeholder"))
        case 2:
            let obj = pharmacies[indexPath.row]
            cell.labelProductName.text = obj.name
            cell.imageProduct.downlodeImage(serviceurl: obj.main_image, placeHolder: UIImage(named: "placeholder"))
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return doctors.isEmpty && !String.getString(searchBar.text).isEmpty ? 50 : 00
        case 1:
            return hospitals.isEmpty && !String.getString(searchBar.text).isEmpty ? 50 : 00
        case 2:
            return pharmacies.isEmpty && !String.getString(searchBar.text).isEmpty ? 50 : 00
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 50))
        let label = UILabel(frame: CGRect(x: 15, y: (view.frame.height/2) - 8, width: view.frame.width-15, height: 15))
        view.addSubview(label)
        label.text = "No data found".localize
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: true,completion: { [weak self] in
            guard let self = self else { return }
            switch indexPath.section {
            case 0:
                //self.callback?(0,self.doctors[indexPath.row],nil,nil)
                guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: ViewDoctorProfileVC.getStoryboardID()) as? ViewDoctorProfileVC else { return }
                vc.searchResult = self.doctors[indexPath.row]
                UserData.shared.hospital_id = ""
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                //self.callback?(1,nil,self.hospitals[indexPath.row],nil)
                guard let vc = UIStoryboard(name: Storyboards.kHospitals, bundle: nil).instantiateViewController(withIdentifier: HospitalProfileVC.getStoryboardID()) as? HospitalProfileVC else { return }
                vc.searchResult = self.hospitals[indexPath.row]
                UserData.shared.hospital_id = ""
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                self.callback?(2, nil, nil, self.pharmacies[indexPath.row])
            default: break
            }
        })
    }
}

extension HomeSearchVC: UISearchBarDelegate {
    func hideSearch() {
        self.doctors = []
        self.hospitals = []
        self.pharmacies = []
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.searchApi(searchText)
            })
        } else {
            self.doctors = []
            self.hospitals = []
            self.pharmacies = []
            self.tableView.reloadData()
        }
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if String.getString(searchBar.text) != ""{
            searchApi(String.getString(searchBar.text))
        } else {
            hideSearch()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearch()
    }
    
    @objc func buttonCrossTapped(_ sender: Any) {
        hideSearch()
    }
}

extension HomeSearchVC {
    func searchApi(_ string: String) {
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params: [String: Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:(ServiceName.homeSearch+"?search="+string).replacingOccurrences(of: " ", with: "+"),                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if !String.getString(self?.searchBar.text).isEmpty {
                        self?.doctors = kSharedInstance.getArray(dictResult["doctor_list"]).map{DoctorDetailsModel(data: kSharedInstance.getDictionary($0))}
                        self?.hospitals = kSharedInstance.getArray(dictResult["hospital_list"]).map{HospitalDetailModel(data: kSharedInstance.getDictionary($0))}
                        self?.pharmacies = kSharedInstance.getArray(dictResult["pharmacy_list"]).map{PharmacyProductModel(dict: kSharedInstance.getDictionary($0))}
                    } else {
                        self?.doctors = []
                        self?.hospitals = []
                        self?.pharmacies = []
                        self?.tableView.reloadData()
                    }
                    self?.tableView.reloadData()
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

