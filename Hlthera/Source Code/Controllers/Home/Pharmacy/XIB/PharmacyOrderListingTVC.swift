//
//  PharmacyOrderListingTVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 14/04/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class PharmacyOrderListingTVC: UITableViewCell {
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelOrderId: UILabel!
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelReportStatus: UILabel!
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var labelQty: UILabel!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonFullDetails: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonFullDetailsTapped(_ sender: Any) {
        
        
    }
    
}
