//
//  BookDoctorTVC.swift
//  Hlthera
//
//  Created by Bisho Badie on 17/08/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit

class BookDoctorTVC: UITableViewCell {

    @IBOutlet weak var buttonHeart: UIButton!
    @IBOutlet weak var imageDoctor: UIImageView!
    @IBOutlet weak var labelDoctorName: UILabel!
    @IBOutlet weak var labelDoctorSpecialization: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelExperience: UILabel!
    @IBOutlet weak var imageExp: UIImageView!
    
    var heartTapped:((Bool)->())?
    var callback:(()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonBookTapped(_ sender: Any) {
        callback?()
    }
    @IBAction func buttonHeartTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        heartTapped?(sender.isSelected ? true : false)
    }
}
