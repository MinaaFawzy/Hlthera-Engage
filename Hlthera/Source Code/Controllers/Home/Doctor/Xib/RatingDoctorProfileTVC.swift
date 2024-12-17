//
//  RatingDoctorProfileTVC.swift
//  Hlthera
//
//  Created by Mina Fawzy on 13/09/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit

class RatingDoctorProfileTVC: UITableViewCell {

    @IBOutlet weak var bookForOthersButton: UIButton!
    @IBOutlet weak var bookAppointementButton: UIButton!
    @IBOutlet weak var ratingsTable: UITableView!
    @IBOutlet weak var noRatingsImageView: UIImageView!
    
    var doctorDataModel: DoctorDataModel?
    var hospitalReviews: [Review]?
    var callBackBookAppoientment: (()->())?
    var callBackBookForOther: (()->())?
    var callBackReportProblem: (()->())?
    var hasComeFrom = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        configureReviews()
    }

    private func configureReviews() {
        ratingsTable.dataSource = self
        ratingsTable.delegate = self
        ratingsTable.register(UINib(nibName: ReviewsAndRatingsTVC.identifier, bundle: nil), forCellReuseIdentifier: ReviewsAndRatingsTVC.identifier)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

//MARK: - Actions
extension RatingDoctorProfileTVC {
    
    @IBAction func BookAppointmentButtonTapped(_ sender: Any) {
        callBackBookAppoientment?()
    }
    
    @IBAction func bookForOtherButtonTapped(_ sender: Any) {
        callBackBookForOther?()
    }
    
    @IBAction func reportProblemButtonTapped(_ sender: Any) {
        callBackReportProblem?()
    }
}

//MARK: - UITable Delegate & DataSorce
extension RatingDoctorProfileTVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasComeFrom == "hospital" {
            noRatingsImageView.isHidden = !(hospitalReviews?.isEmpty ?? true)
            return hospitalReviews?.count ?? 0
        } else {
            noRatingsImageView.isHidden = !(doctorDataModel?.result.ratingReviews?.isEmpty ?? true)
            return doctorDataModel?.result.ratingReviews?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if hasComeFrom == "hospital" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsAndRatingsTVC", for: indexPath) as! ReviewsAndRatingsTVC
            cell.selectionStyle = .none
            let obj = hospitalReviews
            if obj!.indices.contains(indexPath.row){
                if obj![indexPath.row].ratingType == "username"{
                    cell.labelComment?.text = obj![indexPath.row].comments
                    cell.labelUsername.text = (obj![indexPath.row].clientName)
                    cell.imageProfile.downlodeImage(serviceurl: obj![indexPath.row].clientPicture ?? "", placeHolder: UIImage(named: "no_data_image"))
                    let rating = obj![indexPath.row].rating
                    cell.stackViewRatings.setRatings(value: rating ?? 0)
                }
                else{
                    cell.labelComment?.text = obj![indexPath.row].comments
                    cell.labelUsername.text = "Anonymous".localize
                    let rating = obj![indexPath.row].rating
                    cell.stackViewRatings.setRatings(value: rating ?? 0)
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsAndRatingsTVC", for: indexPath) as! ReviewsAndRatingsTVC
            cell.selectionStyle = .none
            let obj = doctorDataModel!.result.ratingReviews
            if obj!.indices.contains(indexPath.row){
                if obj![indexPath.row].ratingType == "username"{
                    cell.labelComment?.text = obj![indexPath.row].comments
                    cell.labelUsername.text = (obj![indexPath.row].firstName ?? "") + " " + (obj![indexPath.row].lastName ?? "")
    //                cell.imageProfile.downlodeImage(serviceurl: obj![indexPath.row]., placeHolder: UIImage(named: "placeholder"))
                    let rating = obj![indexPath.row].ratings
                    cell.stackViewRatings.setRatings(value: rating ?? 0)
                }
                else{
                    cell.labelComment?.text = obj![indexPath.row].comments
                    cell.labelUsername.text = "Anonymous".localize
                    let rating = obj![indexPath.row].ratings
                    cell.stackViewRatings.setRatings(value: rating ?? 0)
                }
            }
            return cell
        }
    }
    
    
}
