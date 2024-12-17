//
//  SendertextCell.swift
//  Traveller
//
//  Created by fluper on 23/07/19.
//  Copyright © 2019 Fluper. All rights reserved.
//

import UIKit

class SendertextCell: UITableViewCell {
    
    //MARK:- IBOutlet
    @IBOutlet var blueTickBtn: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblMsgTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var tickImgView: UIImageView!
    
    //mARK:- OBject
    var DeleteCallBack :(()->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBg.clipsToBounds = true
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        leftSwipe.direction = .left
        self.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        rightSwipe.direction = .right
        self.addGestureRecognizer(rightSwipe)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func tap_DeleteBtn(_ sender: UIButton) {
        self.DeleteCallBack?()
    }
    
    @objc func swipeLeft(sender: UISwipeGestureRecognizer){
        btnDelete.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.lblMsgTrailingConstraint.constant = 65
            self.layoutIfNeeded()
        }
    }
    
    @objc func swipeRight(sender: UISwipeGestureRecognizer){
        
        UIView.animate(withDuration: 0.2) {
            self.lblMsgTrailingConstraint.constant = 35
            self.btnDelete.isHidden = true
            self.layoutIfNeeded()
        }
    }
  
    
}
