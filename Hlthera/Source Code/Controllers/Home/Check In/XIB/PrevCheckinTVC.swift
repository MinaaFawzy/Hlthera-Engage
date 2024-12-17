//
//  PrevBookingTVC.swift
//  Hlthera
//
//  Created by Ahmed Hegazy on 08/01/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit

class PrevCheckinTVC: UITableViewCell {
    
    @IBOutlet weak var labelBookingID: UILabel!
    @IBOutlet weak var labelDoctorName: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var imageServiceIcon: UIImageView!
    @IBOutlet weak var imageDoctor: UIImageView!
    //@IBOutlet weak var labelDoctorSpeciality: UILabel!
    //@IBOutlet weak var labelRating: UILabel!
    //@IBOutlet weak var labelAddress: UILabel!
    //@IBOutlet weak var labelFees: UILabel!
    //@IBOutlet weak var labelCompleted: UILabel!
    //@IBOutlet weak var labelExperience: UILabel!
    
    var callbackCheckIn:(()->())?
    var callbackChat:(()->())?
    //var callbackReview:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelDoctorName.font = .CorbenBold(ofSize: 14)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func buttonCheckInTapped(_ sender: Any) {
        callbackCheckIn?()
    }
    
    @IBAction func buttonChatTapped(_ sender: Any) {
        callbackChat?()
    }
    
    //@IBAction func buttonReviewTapped(_ sender: Any) {
    //    callbackReview?()
    //}
    
}
