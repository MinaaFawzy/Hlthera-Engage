//
//  ServicesVC.swift
//  Hlthera
//
//  Created by Prashant on 14/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class ServicesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var servicesList: [String] = ["Covid-19 Testing", "Pharmacy", "House Call", "Clinic Visit", "Teleconsultation"]
    var servicesIcons:[UIImage] = [UIImage(named: "cavid") ?? UIImage(),UIImage(named: "icon_pharmacy") ?? UIImage(),UIImage(named: "doctors_on_demand") ?? UIImage(),UIImage(named: "in_house") ?? UIImage(),UIImage(named: "icon_telemedicine") ?? UIImage()]
    var services:[ServicesModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.font = .corbenRegular(ofSize: 15)
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getServices()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
}

extension ServicesVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTVC", for: indexPath) as! AccountTVC
        cell.selectionStyle = .none
        let obj = services[indexPath.row]
        cell.imageIcon.downlodeImage(serviceurl: obj.service_icon, placeHolder: UIImage(named: "placeholder"))
        cell.labelName.text = obj.pharmacy_service.localize
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}

extension ServicesVC {
    
    func getServices() {
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.viewService,                                                   requestMethod: .GET,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    let data = kSharedInstance.getArray(dictResult["data"])
                    self?.services = data.map{ServicesModel(data: kSharedInstance.getDictionary($0))}
                    
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
