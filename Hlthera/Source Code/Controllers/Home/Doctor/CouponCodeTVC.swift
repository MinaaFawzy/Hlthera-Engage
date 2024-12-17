//
//  CouponCodeTVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 20/01/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class CouponCodeTVC: UITableViewCell {
    @IBOutlet weak var labelCouponName: UILabel!
    @IBOutlet weak var imageCoupon: UIImageView!
    var callback:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonUseCouponTapped(_ sender: Any) {
        callback?()
    }
    
}
