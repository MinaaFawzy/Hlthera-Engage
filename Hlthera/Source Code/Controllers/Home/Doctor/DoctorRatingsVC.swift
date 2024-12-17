//
//  DoctorRatingsVC.swift
//  Hlthera
//
//  Created by Mina Fawzy on 07/08/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit

class DoctorRatingsVC: UIViewController{
    
    
    var dcotorRatings: [DoctorRatingReview] = []
    var hospitalReview: [Review] = []
    var doctorId: Int = 0
    var hasCameFrom: HasCameFrom = .doctors

    //MARK: - @IBOutlet
    @IBOutlet weak var ratingTable: UITableView!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        switch hasCameFrom {
        case .doctors:
            getReviews()
        case .hospitals:
            break
        default : break
        }
        
        ratingTable.delegate = self
        ratingTable.dataSource = self
        ratingTable.register(UINib(nibName: ReviewsAndRatingsTVC.identifier, bundle: nil), forCellReuseIdentifier: ReviewsAndRatingsTVC.identifier)
    }

}

//MARK: - table func
extension DoctorRatingsVC:   UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch hasCameFrom {
        case .doctors:
            return dcotorRatings.count
        case .hospitals:
              return hospitalReview.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsAndRatingsTVC", for: indexPath) as! ReviewsAndRatingsTVC
        cell.selectionStyle = .none
        if hasCameFrom == .doctors {
            cell.imageProfile.isHidden = false
            if dcotorRatings[indexPath.row].ratingType == "username"{
                cell.labelComment?.text = dcotorRatings[indexPath.row].comments
                cell.labelUsername.text = dcotorRatings[indexPath.row].firstName
    //            cell.imageProfile.downlodeImage(serviceurl: ratings[indexPath.row]., placeHolder: UIImage(named: "placeholder"))
                let rating = dcotorRatings[indexPath.row].ratings
                cell.stackViewRatings.setRatings(value: Int(rating) ?? 0)
            } else {
                cell.imageProfile.isHidden = true
                cell.labelComment?.text = dcotorRatings[indexPath.row].comments
                cell.labelUsername.text = "Anonymous".localize
                let rating = dcotorRatings[indexPath.row].ratings
                cell.stackViewRatings.setRatings(value: Int(rating) ?? 0)
            }
        } else { // if has came from hospital
            if hospitalReview[indexPath.row].ratingType == "username"{
                cell.imageProfile.isHidden = false
                cell.labelComment?.text = hospitalReview[indexPath.row].comments
                cell.labelUsername.text = hospitalReview[indexPath.row].clientName
                cell.imageProfile.downlodeImage(serviceurl: (hospitalReview[indexPath.row].clientPicture ?? "") , placeHolder: UIImage(named: "placeholder"))
                let rating = hospitalReview[indexPath.row].rating
                cell.stackViewRatings.setRatings(value: Int(rating ?? 0))
            } else {
                cell.imageProfile.isHidden = true
                cell.labelComment?.text = hospitalReview[indexPath.row].comments
                cell.labelUsername.text = "Anonymous".localize
                let rating = hospitalReview[indexPath.row].rating
                cell.stackViewRatings.setRatings(value: Int(rating ?? 0))
            }
        }
        return cell
    }
}

//MARK: - get ratings
@available(iOS 15.0, *)
extension DoctorRatingsVC {
    func getReviews() {
        CommonUtils.showHudWithNoInteraction(show: true)
        var params: [String: Any] = [:]
        params[ApiParameters.doctor_id] = doctorId
        TANetworkManager.sharedInstance.requestApi(
            withServiceName: ServiceName.doctorDetails,
            requestMethod: .POST,
            requestParameters: params,
            withProgressHUD: false
        ) { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0 {
                        let data = kSharedInstance.getDictionary(dictResult["result"])
                        self?.dcotorRatings = kSharedInstance.getDictionaryArray(withDictionary:  data["rating_reviews"]).map{
                            DoctorRatingReview(data: $0)
                        }
                        self?.ratingTable.reloadData()
                    } else {
                        CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    }
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
