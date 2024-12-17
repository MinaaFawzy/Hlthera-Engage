//
//  DoctorHeaderTVC.swift
//  Hlthera
//
//  Created by Mina Fawzy on 17/10/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit

class DoctorHeaderTVC: UITableViewCell {

    
    @IBOutlet weak var labelDoctorName: UILabel!
    @IBOutlet weak var labelDoctorSpeciality: UILabel!
    @IBOutlet weak var backgroundVIew: UIView!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelExperience: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelHeartCount: UILabel!
    @IBOutlet weak var buttonPhone: UIButton!
    @IBOutlet weak var buttonChat: UIButton!
    @IBOutlet weak var buttonHome: UIButton!
    @IBOutlet weak var buttonFinance: UIButton!
    @IBOutlet weak var buttonVideo: UIButton!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    
    var callbackBackButton:(()->())?
    var callbackPhoneButton:(()->())?
    var callbackChatButton:(()->())?
    var callbackVideoButton:(()->())?
    var callbackHomeButton:(()->())?
    var callbackFinancialButton:(()->())?
    var callbackShareButton:(()->())?
    var callbackLocationButton:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonHome.setImage(UIImage(named: "home_visit_white")?.alpha(0.5), for: .normal)
        self.buttonVideo.setImage(UIImage(named: "video_white")!.alpha(0.5), for: .normal)
        self.buttonChat.setImage(UIImage(named: "chat")!.alpha(0.5), for: .normal)
        self.buttonPhone.setImage(UIImage(named: "call_white")!.alpha(0.5), for: .normal)
        self.buttonFinance.setImage(UIImage(named: "clinic_visit_white")!.alpha(0.5), for: .normal)
        self.buttonHome.isUserInteractionEnabled = false
        self.buttonVideo.isUserInteractionEnabled = false
        self.buttonChat.isUserInteractionEnabled = false
        self.buttonPhone.isUserInteractionEnabled = false
        self.buttonFinance.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    func setupHeaderData(data: DoctorDataResult?) {
        self.labelDoctorName.text = data?.doctorName
        self.labelHeartCount.text = String.getString(data?.likes)
        self.labelRating.text = String(format: "%.1f", data?.ratings ?? 0)
        self.reviewsCountLabel.text = String.getString(data?.ratingReviews?.count ?? 0)
        self.labelDoctorSpeciality.text = data?.doctorSpecialities?.first?.fullName
        self.labelExperience.text = (data?.doctorExp?.count > 2) ? data?.doctorExp : "\(String.getString(data?.doctorExp) )" + " years of exp.".localize
        self.imageProfile.downlodeImage(serviceurl: String.getString(data?.doctorProfile), placeHolder: UIImage(named: "no_data_image"))
        data?.doctorCommunicationServices?.forEach {
            if $0.commServiceType == "video" {
                self.buttonVideo.setImage(UIImage(named: "video_white"), for: .normal)
                self.buttonVideo.isUserInteractionEnabled = true
            }
            if $0.commServiceType == "home" {
                self.buttonHome.setImage(UIImage(named: "home_visit_white"), for: .normal)
                self.buttonHome.isUserInteractionEnabled = true
            }
            if $0.commServiceType == "chat" {
                self.buttonChat.setImage(UIImage(named: "chat"), for: .normal)
                self.buttonChat.isUserInteractionEnabled = true
            }
            if $0.commServiceType == "audio" {
                self.buttonPhone.setImage(UIImage(named: "call_white"), for: .normal)
                self.buttonPhone.isUserInteractionEnabled = true
            }
            if $0.commServiceType == "visit" {
                self.buttonFinance.setImage(UIImage(named: "clinic_visit_white"), for: .normal)
                self.buttonFinance.isUserInteractionEnabled = true
            }
        }
    }
        
        @IBAction private func buttonBackTapped(_ sender: Any) {
            callbackBackButton?()
        }
        
        @IBAction private func buttonPhoneTapped(_ sender: Any) {
            callbackPhoneButton?()
        }
        
        @IBAction private func buttonChatTapped(_ sender: Any) {
            callbackChatButton?()
        }
        
        @IBAction private func buttonHomeTapped(_ sender: Any) {
            callbackHomeButton?()
        }
        
        @IBAction private func buttonFinancialTapped(_ sender: Any) {
            callbackFinancialButton?()
        }
        
        @IBAction private func buttonVideoTapped(_ sender: Any) {
            callbackVideoButton?()
        }
        
        @IBAction private func buttonShareTapped(_ sender: Any) {
            callbackShareButton?()
        }
        
        @IBAction private func buttonLocationTapped(_ sender: Any) {
           callbackLocationButton?()
        }

}

