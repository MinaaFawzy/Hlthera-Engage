//
//  ChatItemTVC.swift
//  Hlthera
//
//  Created by Ahmed Hegazy on 09/01/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit

class ChatItemTVC: UITableViewCell {

    @IBOutlet weak var viewRight: UIView!
    @IBOutlet weak var viewLef: UIView!
    @IBOutlet weak var lblRight: UITextView!
    @IBOutlet weak var lblLeft: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblRight.isScrollEnabled = false
        lblRight.sizeToFit()
        lblLeft.isScrollEnabled = false
        lblLeft.sizeToFit()
    }

}
