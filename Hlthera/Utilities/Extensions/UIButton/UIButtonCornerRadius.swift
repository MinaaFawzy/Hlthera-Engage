//
//  UIButtonCornerRadius.swift
//  OneClickWash
//
//  Created by RUCHIN SINGHAL on 15/09/16.
//  Copyright © 2016 Appslure. All rights reserved.
//

import UIKit

class UIButtonCornerRadius: UIButton {
    @IBInspectable override var cornerRadius: CGFloat {
    didSet {
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = cornerRadius > 0
    }
  }
  @IBInspectable var makeCircle: Bool = false {
    didSet {
      layer.masksToBounds = cornerRadius > 0
    }
  }
}
class HltheraCartButton:UIButton{
    
    var badge:UILabel = UILabel()
    var count = 0 {
        didSet{
            self.layoutIfNeeded()
        }
    }
    required init(coder aDecoder:NSCoder) {
        
        super.init(coder:aDecoder)!
        self.subviews.map{if $0.restorationIdentifier == "cartCount"{
            $0.removeFromSuperview()
        }}
        badge = badgeLabel(withCount: count)
        badge.restorationIdentifier = "cartCount"
        badge.isHidden = true
        self.addSubview(badge)
        self.refreshCartCount()
        NSLayoutConstraint.activate([
            badge.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 14.5),
            badge.topAnchor.constraint(equalTo: self.topAnchor, constant: -3.5),
            badge.widthAnchor.constraint(equalToConstant: badgeSize),
            badge.heightAnchor.constraint(equalToConstant: badgeSize)
        ])
    }
    override func layoutSubviews() {
        super.layoutSubviews()
       
        self.layoutIfNeeded()
    }
    func refreshCartCount(){
        globalApis.getCartCount(){ count in
            self.count = count
            self.badge.text = String.getString(count)
            self.count > 0 ? (self.badge.isHidden = false) : (self.badge.isHidden = true)
        }
    }
    
}
let badgeSize: CGFloat = 15
let badgeTag = 0

func badgeLabel(withCount count: Int) -> UILabel {
    
    let badgeCount = UILabel(frame: CGRect(x: 0, y: 0, width: badgeSize, height: badgeSize))
    badgeCount.translatesAutoresizingMaskIntoConstraints = false
    badgeCount.tag = badgeTag
    badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
    badgeCount.textAlignment = .center
    badgeCount.layer.masksToBounds = true
    badgeCount.textColor = .white
    badgeCount.font = badgeCount.font.withSize(12)
    badgeCount.backgroundColor = .systemRed
    badgeCount.text = String(count)
    return badgeCount
}

