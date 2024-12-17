//
//  OngoingBookingTVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 05/02/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class OngoingBookingTVC: UITableViewCell {
    
    @IBOutlet weak var labelBookingID: UILabel!
    @IBOutlet weak var labelDoctorName: UILabel!
    @IBOutlet weak var labelDoctorSpeciality: UILabel!
    @IBOutlet weak var labelDoctorRating: UILabel!
    @IBOutlet weak var labelDoctorAddress: UILabel!
    @IBOutlet weak var labelDoctorFees: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelExperience: UILabel!
    @IBOutlet weak var labelInProcess: UILabel!
    @IBOutlet weak var imageServiceIcon: UIImageView!
    @IBOutlet weak var imageDoctor: UIImageView!
    @IBOutlet weak var labelTimeLeft: UILabel!
    
    var callbackFullDetails: (()->())?
    var callbackSchedule: (()->())?
    var callbackConfirm: (()->())?
    var callbackCancel: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelDoctorName.font = .CorbenBold(ofSize: 14)
    }
    
    @IBAction private func buttonFullDetailsTapped(_ sender: Any) {
        callbackFullDetails?()
    }
}
