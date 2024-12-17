//
//  AddOtherPopupVC.swift
//  Hlthera
//
//  Created by Bishoy Badea [Pharma] on 15/07/2023.
//  Copyright © 2023 EVA-PHARMA. All rights reserved.
//

import UIKit

class AddOtherPopupVC: UIViewController {
    
    var onContinue: (() -> ())?
    
    //MARK: - Outlets
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Age Restriction"
//        descriptionLabel.attributedText = adjustDescription()
        continueButton.setTitle("Continue", for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
    }
    
    private func adjustDescription() -> NSAttributedString {
        let sentence = "Book for Others is intended for individuals under the age of 18. please create your own profile for a personalised experience."

        let attributedString = NSMutableAttributedString(string: sentence)

        let boldFont = UIFont.boldSystemFont(ofSize: 17) // Adjust the font size as needed

        let range = (sentence as NSString).range(of: "under the age of 18")

        attributedString.addAttribute(NSAttributedString.Key.font, value: boldFont, range: range)

        // Use the attributedString as needed
        return attributedString
    }
    
    //MARK: - Actions
    @IBAction private func continueTapped() {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.onContinue?()
        }
    }
    
    @IBAction private func cancelTapped() {
        dismiss(animated: true)
    }
    
}
