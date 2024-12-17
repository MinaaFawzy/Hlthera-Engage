//
//  PharmacyMainOrderListingTVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 14/04/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class PharmacyMainOrderListingTVC: UITableViewCell {
    @IBOutlet weak var labelOrderId: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelTotalPrice: UILabel!
    @IBOutlet weak var labelReportType: UILabel!
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var labelQty: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonFullDetails: UIButton!
    
    var callbackFullDetailsTapped:(()->())?
    var callbackCancelTapped:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonFullDetailsTapped(_ sender: Any) {
        callbackFullDetailsTapped?()
    }
    @IBAction func buttonCancelTapped(_ sender: Any) {
        callbackCancelTapped?()
    }
    
}
class ResizableButton: UIButton {
    override var intrinsicContentSize: CGSize {
        let labelSize = titleLabel?.sizeThatFits(CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
        let desiredButtonSize = CGSize(width: labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right + 15, height: labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)

        return desiredButtonSize
    }
}
