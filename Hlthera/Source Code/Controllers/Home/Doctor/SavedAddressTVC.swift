//
//  SavedAddressTVCTableViewCell.swift
//  Hlthera
//
//  Created by Prashant Panchal on 20/01/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class SavedAddressTVC: UITableViewCell {
    @IBOutlet weak var imageIsSelected: UIImageView!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var viewBG: UIView!
    
    var deleteCallback:(()->())?
    var editCallback:(()->())?
    
   

   
//    override func awakeFromNib() {
//        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
//        leftSwipe.direction = .left
//        self.addGestureRecognizer(leftSwipe)
//        
//        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
//        rightSwipe.direction = .right
//        self.addGestureRecognizer(rightSwipe)
//    }
//
//    
//    @IBAction func buttonDeleteTapped(_ sender: Any) {
//        deleteCallback?()
//    }
//    @objc func swipeLeft(sender: UISwipeGestureRecognizer){
//        btnDelete.isHidden = false
//        UIView.animate(withDuration: 0.2) {
//            self.constraintTrailing.constant = 60
//            self.constraintLeading.constant = -60
//            self.viewBG.isHidden = false
//            self.btnDelete.isHidden = false
//           // self.btnDelete.isUserInteractionEnabled = false
//            self.layoutIfNeeded()
//        }
//    }
//
//    @objc func swipeRight(sender: UISwipeGestureRecognizer){
//        UIView.animate(withDuration: 0.2) {
//            //self.btnDelete.isUserInteractionEnabled = true
//            self.constraintTrailing.constant = 2.5
//            self.constraintLeading.constant = 2.5
//            self.viewBG.isHidden = true
//            self.btnDelete.isHidden = true
//            self.layoutIfNeeded()
//        }
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    @IBAction func buttonDeleteTapped(_ sender: Any) {
//        deleteCallback?()
//    }
    
    @IBAction func buttonEditTapped(_ sender: Any) {
        editCallback?()
    }
}
