//
//  PopUpViewController.swift
//  MarineUser
//
//  Created by Prashant on 24/06/20.
//  Copyright © 2020 Zahid Shaikh. All rights reserved.
//

import UIKit

class PopUpVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var imageIconView: UIView!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelDescription: UILabel!
    
    //MARK: Variables
    var popUpDescription = "Report has been successfully submitted".localize
    var popUpImage: UIImage = #imageLiteral(resourceName: "green_sm")
    var callback: (()->Void)?
    var cancelCallback: (()->())?
    var hideImageView: (()->())?
    var hideImage: Bool = false
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        if hideImage {
            imageIcon.isHidden = true
        }
    }
    
    // MARK: Methods
    func initialSetup() {
        self.imageIcon.image = popUpImage
        self.labelDescription.text = popUpDescription
        //callback?()
        hideImageView?()
    }
    
    // MARK: Actions
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.dismiss(animated: true){}
        callback?()
    }
}
