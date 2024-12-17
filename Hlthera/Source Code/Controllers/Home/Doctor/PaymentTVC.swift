//
//  PaymentTVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 21/01/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class PaymentTVC: UITableViewCell {
    @IBOutlet weak var imageIsSelected: UIImageView!
    @IBOutlet weak var labelCardName: UILabel!
    @IBOutlet weak var labelCardNumber: UILabel!
    @IBOutlet weak var labelCardPin: UILabel!
    @IBOutlet weak var labelValidThrough: UILabel!
    @IBOutlet weak var viewBG: UIView!
    
    var delegate : CellImageTapDelegate?
       var tapGestureRecognizer = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
       }
    
    private func initialize() {
            tapGestureRecognizer.addTarget(self, action: #selector(PaymentTVC.imageTapped(gestureRecgonizer:)))
            self.addGestureRecognizer(tapGestureRecognizer)
        }
    
    @objc func imageTapped(gestureRecgonizer: UITapGestureRecognizer) {
           delegate?.tableCell(didClickedImageOf: self)
       }
    
    override func layoutSubviews() {
        //contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

protocol CellImageTapDelegate {
    func tableCell(didClickedImageOf tableCell: UITableViewCell)
}
