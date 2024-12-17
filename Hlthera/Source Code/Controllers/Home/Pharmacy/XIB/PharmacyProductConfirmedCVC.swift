//
//  PharmacyProductConfirmedCVC.swift
//  Hlthera
//
//  Created by fluper on 13/04/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class PharmacyProductConfirmedCVC: UICollectionViewCell {
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var labelProductSubtitle: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelQty: UILabel!
    @IBOutlet weak var imageCheck: UIImageView!
    @IBOutlet weak var labelReportStatus: UILabel!
    @IBOutlet weak var labelItemStatus: UILabel!
    
    var cartCallback:(()->())?
    var favoriteCallback:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageProduct.layer.maskedCorners  = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        imageProduct.layer.cornerRadius = 15
        // Initialization code
    }
   
   
}
