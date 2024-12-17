//
//  AlertVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 06/02/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class AlertVC: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    
    var alertTitle: String = "Alert".localize
    var alertDesc: String = "Are you sure you want to cancel this appointment?".localize
    var textColor: UIColor?
    var yesCallback: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if textColor != nil {
            self.labelDesc.textColor = textColor
        }
        self.labelTitle.text = alertTitle
        self.labelDesc.text = alertDesc
    }
    
    @IBAction func buttonYesTapped(_ sender: Any) {
        yesCallback?()
    }
    
    @IBAction func buttonNoTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
