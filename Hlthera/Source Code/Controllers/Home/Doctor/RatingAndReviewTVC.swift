//
//  RatingAndReviewTVC.swift
//  Hlthera
//
//  Created by Prashant on 29/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class RatingAndReviewTVC: UITableViewCell {
    @IBOutlet var imageEmojis: [UIImageView]!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelImage: UIImageView!
    @IBOutlet weak var labelReview: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
