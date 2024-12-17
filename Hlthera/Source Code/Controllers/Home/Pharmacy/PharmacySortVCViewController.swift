//
//  PharmacySortVCViewController.swift
//  Hlthera
//
//  Created by fluper on 06/04/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class PharmacySortVCViewController: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!
    
    var callbackAll: (()->())?
    var callbackLowToHigh: (()->())?
    var callbackHighToLow: (()->())?
    var callbackNewestFirst: (()->())?
    var callback: ((String, Int)->())?
    var selectedSort: Int = 0
    var isMyOrders: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sort = selectedSort == 1 && isMyOrders ? 3 : selectedSort
        selectButton(buttons[sort])
        if isMyOrders{
            buttons[0].setTitle("All orders".localize, for: .normal)
            buttons[1].isHidden = true
            buttons[2].isHidden = true
            buttons[3].setTitle("Last 30 days orders".localize, for: .normal)
        }
        else{
            buttons[0].setTitle("All".localize, for: .normal)
            buttons[1].setTitle("Price Low to High".localize, for: .normal)
            buttons[2].setTitle("Price High to Low".localize, for: .normal)
            buttons[3].setTitle("Newest First".localize, for: .normal)
        }
    }
    
    func selectButton(_ sender: UIButton) {
        for button in buttons {
            if sender == button {
                button.isSelected = true
                button.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1), for: .normal)
            } else {
                button.isSelected = false
                button.setTitleColor(#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1), for: .normal)
            }
        }
    }
    
    @IBAction func buttonAllTapped(_ sender: UIButton) {
        selectButton(sender)
        callback?("All".localize,0)
    }
    
    @IBAction func buttonLowToHightTapped(_ sender: UIButton) {
        selectButton(sender)
        callback?("low to high".localize,1)
    }
    
    @IBAction func buttonHighToLowTapped(_ sender: UIButton) {
        selectButton(sender)
        callback?("high to low".localize,2)
    }
    
    @IBAction func buttonNewestTapped(_ sender: UIButton) {
        selectButton(sender)
        callback?("latest".localize,isMyOrders ? 1 : 3)
    }
    
    @IBAction func buttonCloseTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
