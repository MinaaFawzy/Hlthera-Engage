//
//  SurveySubmitCVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 10/02/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class SurveySubmitCVC: UICollectionViewCell {

    @IBOutlet var buttonsCheckBox: [UIButton]!
    var callback:((Int,Bool)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func buttonCheckTapped(_ sender: UIButton) {
        if sender.tag == 0{
            sender.isSelected = !sender.isSelected
            sender.isSelected ? (callback?(0,true)) : (callback?(0,false))
        }
        if sender.tag == 1{
            sender.isSelected = !sender.isSelected
            sender.isSelected ? (callback?(1,true)) : (callback?(1,false))
        }
        if sender.tag == 2{
            sender.isSelected = !sender.isSelected
            sender.isSelected ? (callback?(2,true)) : (callback?(2,false))
        }
        if sender.tag == 3{
            sender.isSelected = !sender.isSelected
            sender.isSelected ? (callback?(3,true)) : (callback?(3,false))
        }
        
    }
    
}
