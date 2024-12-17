//
//  HospitalListCVC.swift
//  Hlthera
//
//  Created by Mina Fawzy on 24/08/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit

class HospitalListTVC: UITableViewCell {

    //MARK: - OutLets
    @IBOutlet weak var hospitalName: UILabel!
    @IBOutlet weak var hospitalLocation: UILabel!
    @IBOutlet weak var Specialties: UILabel!
    @IBOutlet weak var doctorsNum: UILabel!
    @IBOutlet weak var hospitalImage: UIImageView!
    @IBOutlet weak var hospitalRating: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    
    var callbackBookNow:(()->())?
    var callbackHeartButton:((Bool)->())?
    
    //MARK: - LifrCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Actions
    @IBAction func bookNowButtonTapped(_ sender: UIButton) {
        callbackBookNow?()
    }
    
    @IBAction func heartButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        callbackHeartButton?(sender.isSelected ? true : false)
    }
    
}
