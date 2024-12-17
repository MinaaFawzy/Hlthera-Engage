//
//  ScheduledBookingTVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 05/02/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class ScheduledBookingTVC: UITableViewCell {
    @IBOutlet weak var onlineDotImageView: UIImageView!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var buttonReschedule: UIButton!
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
    @IBOutlet weak var checkInButton: UIButton!
    
    var callbackFullDetails:(()->())?
    var callbackSchedule:(()->())?
    var callbackConfirm:(()->())?
    var callbackCancel:(()->())?
    var callbackCheckIn:(()->())?
    var callbackRate:(()->())?
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
    @IBAction func buttonScheduledTapped(_ sender: Any) {
        callbackSchedule?()
    }
    @IBAction func buttonConfirmTapped(_ sender: Any) {
        callbackConfirm?()
    }
    @IBAction func buttonCancelTapped(_ sender: Any) {
        callbackCancel?()
    }
    
    @IBAction func checkInTapped(_ sender: Any) {
        callbackCheckIn?()
    }
    
    @IBAction func rateTapped(_ sender: Any) {
        callbackRate?()
    }
}
