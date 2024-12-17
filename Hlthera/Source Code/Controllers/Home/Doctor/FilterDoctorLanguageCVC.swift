//
//  FilterLanguageCVC.swift
//  Hlthera
//
//  Created by Prashant on 07/01/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class FilterDoctorLanguageCVC: UICollectionViewCell {
    @IBOutlet weak var labelLanguageName: UILabel!
    var removeCallback:(()->())?
    @IBAction func buttonRemoveLanguageTapped(_ sender: Any) {
        removeCallback?()
    }
    
}
