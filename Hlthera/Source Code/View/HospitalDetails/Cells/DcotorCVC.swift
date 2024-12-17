//
//  DcotorCVC.swift
//  Hlthera
//
//  Created by Bishoy Badea [Pharma] on 20/05/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit

class DcotorCVC: UICollectionViewCell {
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var clinicNameLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var bookNowButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var callback:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func bookTapped(_ sender: Any) {
        callback?()
    }
    
    @IBAction func likeTapped(_ sender: Any) {
    }
}
