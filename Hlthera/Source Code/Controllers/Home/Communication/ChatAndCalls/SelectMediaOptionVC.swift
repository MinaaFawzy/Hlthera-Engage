//
//  SelectMediaOptionVC.swift
//  RippleApp
//
//  Created by Mohd Aslam on 05/05/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class SelectMediaOptionVC: UIViewController {

    @IBOutlet var attachmentMainView: UIView!
    
    var videoCallback: ((Int) ->Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.attachmentMainView{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cameraAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.videoCallback?(1)

        }
    }
    
    @IBAction func galleryAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.videoCallback?(2)
        }
    }

}
