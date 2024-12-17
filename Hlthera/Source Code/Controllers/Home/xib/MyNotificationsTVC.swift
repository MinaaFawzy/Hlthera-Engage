//
//  MyNotificationsTVC.swift
//  Hlthera
//
//  Created by Mina Fawzy on 11/10/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit

class MyNotificationsTVC: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var viewAcceptReject: UIView!
    @IBOutlet weak var constraintViewAcceptRejectHeight: NSLayoutConstraint!
    
    var joinCallback: (() -> ())?
    var cancelCallback: (() -> ())?
    var onMore: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        profileImage.contentMode = UIView.ContentMode.scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonJoinTapped(_ sender: UIButton) {
        joinCallback?()
    }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        cancelCallback?()
    }
    
    @IBAction func moreTapped(_ sender: Any) {
        onMore?()
    }
}
