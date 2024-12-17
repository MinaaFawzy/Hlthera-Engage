//
//  PopUpOtherSelectionVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 20/01/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class PopUpOtherSelectionVC: UIViewController {
    var callback:(()->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func buttonChildTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func buttonAdultTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.callback?()
        })
    }

}
