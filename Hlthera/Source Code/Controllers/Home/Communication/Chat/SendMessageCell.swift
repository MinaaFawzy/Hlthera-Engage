//
//  SendMessageCell.swift
//  PennyAuction
//
//  Created by Nitesh on 21/01/21.
//  Copyright © 2021 Gurmeet Kaur. All rights reserved.
//

import UIKit

class SendMessageCell: UITableViewCell {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var sendMessageLbl: UILabel!
    
    @IBOutlet weak var timeLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
