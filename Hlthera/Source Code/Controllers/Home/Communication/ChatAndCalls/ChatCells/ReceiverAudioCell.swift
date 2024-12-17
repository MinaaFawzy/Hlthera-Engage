//
//  ReceiverAudioCell.swift
//  RippleApp
//
//  Created by Mohd Aslam on 06/05/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ReceiverAudioCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var viewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorView: NVActivityIndicatorView!
    @IBOutlet weak var viewBg: UIView!
    
    var DeleteCallBack :(()->())?
    var playCallback:(()->())?
    var saveCallback:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        indicatorView.type = .lineScalePulseOut
        indicatorView.color = CustomColor.kRed
        
        let image = UIImage(named: "chat_pauseAudio")!.withRenderingMode(.alwaysTemplate)
        playBtn.setImage(image, for: .selected)
        playBtn.tintColor = .black
        
        let image1 = UIImage(named: "chat_playIcon")!.withRenderingMode(.alwaysTemplate)
        playBtn.setImage(image1, for: .normal)
        playBtn.tintColor = .black
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        leftSwipe.direction = .left
        self.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        rightSwipe.direction = .right
        self.addGestureRecognizer(rightSwipe)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func tap_SaveBtn(_ sender: UIButton) {
        self.saveCallback?()
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        self.playCallback?()
    }
    
    @IBAction func tap_DeleteBtn(_ sender: UIButton) {
        self.DeleteCallBack?()
    }
    
    @objc func swipeLeft(sender: UISwipeGestureRecognizer){
        btnDelete.isHidden = true
        UIView.animate(withDuration: 0.2) {
            self.viewLeadingConstraint.constant = 15
            self.layoutIfNeeded()
        }
    }
    
    @objc func swipeRight(sender: UISwipeGestureRecognizer){
        self.btnDelete.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.viewLeadingConstraint.constant = 50
            self.layoutIfNeeded()
        }
    }
}
