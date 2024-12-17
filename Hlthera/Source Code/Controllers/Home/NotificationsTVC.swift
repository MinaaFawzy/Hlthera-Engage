//
//  NotificationsTVC.swift
//  Hlthera
//
//  Created by Prashant on 14/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class NotificationsTVC: UITableViewCell {
    
    @IBOutlet weak var viewNotification: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewColor: UIView!
    @IBOutlet weak var viewDescription: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var buttonViewDetail: UIButton!
    var callbackViewDetails: (()->())?
    
    @IBAction func buttonViewDetailTapped(_ sender: Any) {
        callbackViewDetails?()
    }
    
}
