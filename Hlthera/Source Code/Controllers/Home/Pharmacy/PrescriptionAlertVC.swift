//
//  PrescriptionAlertVC.swift
//  Hlthera
//
//  Created by fluper on 27/03/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class PrescriptionAlertVC: UIViewController {

    @IBOutlet weak var buttonAvail: UIButton!
    @IBOutlet weak var buttonUpload: UIButton!
    var type:Int = -1
    var callbackContinue:((Int)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        selectButton(0)
        // Do any additional setup after loading the view.
    }
    func selectButton(_ type :Int){
        if type == 0{
            self.buttonAvail.isSelected = true
            self.buttonUpload.isSelected = false
            self.buttonAvail.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1), for: .normal)
            self.buttonUpload.setTitleColor(#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1), for: .normal)
        }
        else{
            self.buttonAvail.isSelected = false
            self.buttonUpload.isSelected = true
            self.buttonUpload.setTitleColor(#colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1), for: .normal)
            self.buttonAvail.setTitleColor(#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1), for: .normal)
        }
    }
    @IBAction func buttonAvailTapped(_ sender: Any) {
        selectButton(0)
    }
    @IBAction func buttonUploadTapped(_ sender: Any) {
        selectButton(1)
    }
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func buttonContinueTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {self.callbackContinue?(self.buttonAvail.isSelected ? 0 : 1)})
        
    }
    
}


