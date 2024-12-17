//
//  ProductDetailsTVC.swift
//  Hlthera
//
//  Created by fluper on 25/03/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class ProductDetailsTVC: UITableViewCell {
    
    // @IBOutlet weak var viewTitle: UIView!
    // @IBOutlet weak var imageArrow: UIImageView!
    @IBOutlet weak var viewContent: UIView!
    // @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    var callback:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(viewTitleTapped))
        //        viewTitle.addGestureRecognizer(tap)
        //        viewTitle.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    @objc func viewTitleTapped(_ sender: UITapGestureRecognizer){
        callback?()
    }
    
}
