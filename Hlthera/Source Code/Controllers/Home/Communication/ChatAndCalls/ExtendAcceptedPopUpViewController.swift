//
//  ExtendAcceptedPopUpViewController.swift
//  Consultation
//
//  Created by Mohit Kumar Mohit on 02/02/21.
//

import UIKit

class ExtendAcceptedPopUpViewController: UIViewController {
    var dismissCallBack:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.dismiss(animated: true){
                self.dismissCallBack?()
            }
        })
    }

}
