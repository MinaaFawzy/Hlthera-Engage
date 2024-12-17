//
//  HospitalHeaderTVC.swift
//  Hlthera
//
//  Created by Mina Fawzy on 18/10/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit

class HospitalHeaderTVC: UITableViewCell {

    
    //MARK: - IBOutlets
    @IBOutlet weak var headerBackGroundView: UIView!
    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var hospitalSpecialties: UILabel!
    @IBOutlet weak var hospitalImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var specialtiesNumLAbel: UILabel!
    @IBOutlet weak var doctorsNumLabel: UILabel!
    
    var callBackShareButton:(()->())?
    var callBackBackButton:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        callBackShareButton?()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        callBackBackButton?()
    }
    func setupData(data: HospitalDetailsResult?) {
        self.hospitalNameLabel.text = data?.hospitalName
        self.ratingLabel.text = String.getString(data?.rating)
        self.reviewsLabel.text = String.getString((data?.reviews?.count))
//        viewsLabel.text = String.getString(data.)
//        hospitalSpecialties.text = String.getString(data?.hospitalRegistration)
        self.hospitalImageView.sd_setImage(with: .init(string: String.getString((data?.profileBaseURL ?? "") + (data?.profilePicture ?? "") )), placeholderImage: UIImage(named: "no_data_image"))
        self.specialtiesNumLAbel.text = "\(data?.specialtiesCount ?? 0)"
        self.doctorsNumLabel.text = "\(data?.doctorsCount ?? 0)"
        self.likesLabel.text = "\(data?.likes ?? 0)"
    }
}
