//
//  FilterDoctorLocationTVC.swift
//  Hlthera
//
//  Created by Prashant on 07/01/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class FilterDoctorLocationTVC: UITableViewCell {

    @IBOutlet weak var labelLocationName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var imageAddressType: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
