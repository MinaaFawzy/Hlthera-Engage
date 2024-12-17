//
//  BookingAppointmentCVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 11/01/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class BookingAppointmentCVC: UICollectionViewCell {
    @IBOutlet weak var buttonType: UIButton!
    var typeTapped:((UIButton)->())?
    @IBAction func buttonTypeTapped(_ sender: UIButton) {
        typeTapped?(sender)
    }
    
}
