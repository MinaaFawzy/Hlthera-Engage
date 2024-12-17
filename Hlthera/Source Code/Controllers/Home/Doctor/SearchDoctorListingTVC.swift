//
//  SearchDoctorListingTVC.swift
//  Hlthera
//
//  Created by Prashant on 23/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class SearchDoctorListingTVC: UITableViewCell {
    @IBOutlet weak var imageService: UIImageView!
    @IBOutlet weak var buttonHeart: UIButton!
    @IBOutlet weak var imageDoctor: UIImageView!
    @IBOutlet weak var labelDoctorName: UILabel!
    @IBOutlet weak var labelDoctorSpecialization: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    
    @IBOutlet weak var labelAvailibility: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelExperience: UILabel!
    @IBOutlet weak var imageExp: UIImageView!
    
    @IBOutlet weak var viewCheckBox: UIView!
    
    @IBOutlet weak var buttonCheckBox: UIButton!
    var callback:(()->())?
    
    var heartTapped:((Bool)->())?
    var checkBoxTapped:((Bool)->())?

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        labelDoctorName.font = .CorbenBold(ofSize: 14)
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
    
    @IBAction func buttonCheckBoxTapped(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
//        checkBoxTapped?(sender.isSelected ? true : false)
        
    }
}
