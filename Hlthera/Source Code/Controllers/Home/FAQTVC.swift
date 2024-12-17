//
//  FAQTVC.swift
//  Hlthera
//
//  Created by Prashant on 15/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class FAQTVC: UITableViewCell {

    @IBOutlet weak var buttonQn: UIButton!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var imageDownArrow: UIImageView!
    
    var callbackTap: ((Bool)->())?
   
    @IBAction func buttonQnTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isSelected ? (callbackTap?(true)) : (callbackTap?(false))
    }
    
}
