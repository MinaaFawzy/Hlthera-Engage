//
//  Cells.swift
//  Hlthera
//
//  Created by Fluper on 04/11/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import Foundation
import UIKit

//MARK:- TableView Cells
class EmergencyContactsTableViewCell:UITableViewCell{
    
    @IBOutlet weak var imageCountryCode: UIImageView!
    @IBOutlet weak var buttonCountryCode: UIButton!
    @IBOutlet weak var emergencyContactsTF: UITextField!
    @IBOutlet weak var relationTF: UITextField!
    @IBOutlet weak var btnRelation: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    
    var callBack: (()->())? = nil
    var object:EmergencyContactModal?
    
    @objc func textChange(_ text:UITextField){
           //self.textChange?(text.text ?? "")
           object?.text = text.text
       }
    @IBAction func btnAddTappeed(_ sender: UIButton) {
        self.callBack?()
    }
}
class AlergieTableViewCell:UITableViewCell{
    @IBOutlet weak var labelDisease: UILabel!
    @IBOutlet weak var btnMinus: UIButton!
    var removeCallBack:(()->())? = nil
    
    @IBAction func buttonMinusTapped(_ sender: UIButton) {
        self.removeCallBack?()
    }
}

//MARK:- CollectionView Cells
class LifeStyleCollectionViewCell:UICollectionViewCell{
    
}

//MARK:- Medical Screen
class HeaderView:UIView{
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblBtn:UILabel!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var btnAdd:UIButton!
}
class SymptomsTableCell: UITableViewCell{
    @IBOutlet weak var imgSelect:UIImageView!
    @IBOutlet weak var listName:UILabel!
}
class LifeStyleTableCell: UITableViewCell{
    
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var labelDisease: UILabel!
    var removeCallBack:(()->())? = nil
    @IBAction func buttonMinusTapped(_ sender: UIButton) {
        self.removeCallBack?()
    }
}
class LifeStyleAnswerCollectionViewCell:UICollectionViewCell {
    
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var labelAnswer: UILabel!
}

