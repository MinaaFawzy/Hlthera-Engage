//
//  SenderDocumentCell.swift
//  AdvisoryExpert
//
//  Created by Mohd Aslam on 23/01/21.
//

import UIKit

class SenderDocumentCell: UITableViewCell {

    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var imageDoc: UIImageView!
    @IBOutlet weak var labelDocName: UILabel!
    @IBOutlet weak var viewDocument: UIView!
    @IBOutlet weak var tickImgView: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgTrailingConstraint: NSLayoutConstraint!
    
    var viewDocumentCallBack:(()->())?
    var DeleteCallBack :(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleDocument))
        self.viewDocument.addGestureRecognizer(tapGestureRecognizer)
        
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
    
    @objc func handleDocument(_ sender:UIButton) {
        
        self.viewDocumentCallBack?()
    }
    
    @IBAction func tap_DeleteBtn(_ sender: UIButton) {
        self.DeleteCallBack?()
    }
    
    @objc func swipeLeft(sender: UISwipeGestureRecognizer){
        btnDelete.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.imgTrailingConstraint.constant = 50
            self.layoutIfNeeded()
        }
    }
    
    @objc func swipeRight(sender: UISwipeGestureRecognizer){
        
        UIView.animate(withDuration: 0.2) {
            self.imgTrailingConstraint.constant = 20
            self.btnDelete.isHidden = true
            self.layoutIfNeeded()
        }
    }
    
}
