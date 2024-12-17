//
//  ChatMoreOptionsVC.swift
//  RippleApp
//
//  Created by Mohd Aslam on 09/05/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class ChatMoreOptionsVC: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var lblBlock: UILabel!
    
    var isBlock = false
    var selectOptionCallback: ((Int) ->Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblBlock.text = isBlock ? "Unblock User".localize : "Block User".localize
        //popupView.addShadowWithBlurOnView(popupView, spread: 0, blur: 20, color: .black, opacity: 0.15, OffsetX: 0, OffsetY: 3)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.popupView{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func tap_OptionBtn(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.selectOptionCallback?(sender.tag)

        }
    }

}
