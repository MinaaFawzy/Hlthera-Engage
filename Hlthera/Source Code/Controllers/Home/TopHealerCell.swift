//
//  TopHealerCell.swift
//  Hlthera
//
//  Created by Bishoy Badea [Pharma] on 17/05/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit

class TopHealerCell: UICollectionViewCell {

    //@IBOutlet weak var constraintViewSliderLeading: NSLayoutConstraint!
    //@IBOutlet weak var constraintViewSliderTrailing: NSLayoutConstraint!
    //@IBOutlet weak var constraintViewSliderTop: NSLayoutConstraint!
    //@IBOutlet weak var constraintViewSliderBottom: NSLayoutConstraint!
    //@IBOutlet weak var viewSliderContent: UIView!
    @IBOutlet weak var viewDiscoverDoctor: UIView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var labelDiscoverSubHeading: UILabel!
    @IBOutlet weak var labelDiscoverDesc: UILabel!
    @IBOutlet weak var imageDiscoverDoctor: UIImageView!
    @IBOutlet weak var imageHospital: UIImageView!
    @IBOutlet weak var labelHospitalName: UILabel!
    @IBOutlet weak var labelHospitalAddress: UILabel!
    @IBOutlet weak var labelTopDoctorName: UILabel!
    @IBOutlet weak var labelTopDoctorSpecialization: UILabel!
    @IBOutlet weak var labelTopDoctorExperience: UILabel!
    @IBOutlet weak var imageTopDoctor: UIImageView!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelFee: UILabel!
    @IBOutlet weak var labelAvailability: UILabel!
    @IBOutlet weak var buttonDiscoverDoctor: UIButton!
    
    var callback: (()->())?
    
    @IBAction private func buttonDiscoverDoctorsTapped(_ sender: Any) {
        callback?()
    }
}
