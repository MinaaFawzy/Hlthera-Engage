//
//  CancelledBookingTVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 05/02/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class CancelledBookingTVC: UITableViewCell {
    @IBOutlet weak var labelBookingID: UILabel!
    @IBOutlet weak var labelDoctorName: UILabel!
    @IBOutlet weak var labelDoctorSpeciality: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelFees: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var imageServiceIcon: UIImageView!
    @IBOutlet weak var labelCancelled: UILabel!
    @IBOutlet weak var imageDoctor: UIImageView!
    @IBOutlet weak var labelExperience: UILabel!
    
    var callbackFullDetails:(()->())?
    var callbackBookAgain:(()->())?
    
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
        self.callbackFullDetails?()
    }
    @IBAction func buttonBookAgainTapped(_ sender: Any) {
        self.callbackBookAgain?()
    }
    
}
