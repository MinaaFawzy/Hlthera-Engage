//
//  PastBookingTVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 05/02/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class PastBookingTVC: UITableViewCell {
    @IBOutlet weak var labelBookingID: UILabel!
   
    @IBOutlet weak var labelDoctorName: UILabel!
    @IBOutlet weak var labelDoctorSpeciality: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelFees: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var imageServiceIcon: UIImageView!
    @IBOutlet weak var labelCompleted: UILabel!
    @IBOutlet weak var imageDoctor: UIImageView!
    @IBOutlet weak var labelExperience: UILabel!
    
    var callbackFullDetails:(()->())?
    var callbackPrebooking:(()->())?
    var callbackReview:(()->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelDoctorName.font = .CorbenBold(ofSize: 14)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonFullDetailsTapped(_ sender: Any) {
        callbackFullDetails?()
    }
    @IBAction func buttonPrebookingTapped(_ sender: Any) {
        callbackPrebooking?()
    }
    @IBAction func buttonReviewTapped(_ sender: Any) {
        callbackReview?()
    }
    
}
