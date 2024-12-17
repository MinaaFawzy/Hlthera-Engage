//
//  PharmacyProductCVC.swift
//  Hlthera
//
//  Created by fluper on 24/03/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class PharmacyProductCVC: UICollectionViewCell {
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var labelProductSubtitle: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelQty: UILabel!
    @IBOutlet weak var buttonHeart: UIButton!
    @IBOutlet weak var constraintLabelWidth: NSLayoutConstraint!
    
    var cartCallback:(()->())?
    var favoriteCallback:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageProduct.layer.maskedCorners  = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        imageProduct.layer.cornerRadius = 15
        // Initialization code
    }
   
    @IBAction func buttonCartTapped(_ sender: Any) {
        cartCallback?()
    }
    @IBAction func buttonHeartTapped(_ sender: Any) {
        favoriteCallback?()
    }
    
}
